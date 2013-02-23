<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.								 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre	 **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.																	 **
**																					 **
** Para mas informacion referente a la licencia de esta			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**																					 **
** Informacion de Contacto													 **
**    Josafat Moragrega Fernandez										 **
**    Engineering																 **
**    Director Tecnico														 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España						 **
**																					 **
**					(c) Web On Line Studios S.L.							 **
**                                                              **
******************************************************************
*****************************************************************/

/** Acuerdate de documentar esta clase **/

/****************************************************************
  Futuras Versiones:
	
  - En futuras versiones esta clase extendera una clase 'carrito'. Clase destinada a contener lineas de detalle,
	bien sea para un pedido, una factura, un albaran, un tpv, un ticket etc... Esta clase padre tendras todas las
	funcionalidades actuales aplicables sobre las lineas de detalle (comprobar/calcular descuentos, impuestos etc..)
	
	- Esta clase debera incorporar unos cuantos modos que le permitan tener distintos niveles de impacto sobre la db.
	de tal forma que sea soportable la carga de instaciar varias veces esta clase en modos sin 'carrito' y ligth
	
	- Tendremos una clase contenedora para varios pedidos, facturas, albaranes en su modo ligth.
*****************************************************************/

if (!defined('__inmersa_document_class_inc')) {
	include_inm($mod_path.'/document.class.inc');
}

if (!defined('__inmersa_invoice_class_inc')) {
define('__inmersa_invoice_class_inc',TRUE);

define(IEInvoice_ST_READY,			bindec('0001'));
define(IEInvoice_ST_LOCKED,		bindec('0010'));
define(IEInvoice_EFFECTS,			bindec("0010000000000000"));
define(IEInvoice_COMMISSIONS,		bindec("0100000000000000"));
define(IEInvoice_ACCOUNTENTRY,	bindec("1000000000000000"));

class Invoice extends Document {


	var $INSTALLMENT_EFFECTS_ACCOUNT = 1;
	var $INSTALLMENT_EFFECTS_MATTERS = 2;
	var $INSTALLMENT_MATTERS = 3;
	var $INSTALLMENT_ACCOUNT = 4;

	var $_aIDAlbaran;				// Array indexado por ids con los albaranes de la factura.
	var $_aDbDetToAlb;
	var $_aIdxToAlb;

	var $_aIDPedido;				// Array indexado por ids con los pedidos de la factura.
	var $_aIDTicket;				// Array indexado por ids con los tickets de la factura.
	var $_aIDFactura;				// Array indexado por ids con las facturas(_todas_) relacionadas con los pedidos.
	var $_aIDFacturaAbono;		// Array indexado por ids con las facturas de abono relacionadas con la factura .

	var $_aEfectos;				// Array indexado de los efectos de la factura
	var $_aConf = array(			// Configuracion de las instancias de tipo factura.
		'round_drafts' => true	// Si el iporte de la factura ha de ser redondeado antes de insertar el efecto(s) de la factura.
		);

	var $_bActualizarCuenta = false;				
	var $_ImporteCuenta = 0;				

	var $_aIndices = array();	// Vector contenedor de las instancias de indexacion.

	/** Constructor: (TODO: Retocar para usar el constructor de Document)
		* @param $tipo			-	Indica si el pedido es de compra o de venta (ver defines).
		* @param $doc_type	-	Indica si es un pedido o un presupuesto.(bool)
	 **/
	function Invoice($App_Name = NULL,$db_name = 'data',$tipo = inmPed_VENTA,$aCfg = NULL)  {

		parent::Document($App_Name,$db_name,$tipo,$doc_type);
		// global $$App_Name;
		$this->_oSesion = $GLOBALS[$this->App_Name];

		$tmp = $this->setMode($tipo);

		// Fixme: El modo stricto deberia ser una opcion
		// $this->_fPedido |= ~inmPed_STRICT;

		// Resetamos valores.
		$this->_aServicios = array();
		$this->_aIDPedido = NULL;
		$this->_aPedido['preparado'] = 0;
		$this->_aFlags['efectos'] = 0;
		$this->_aFlags['comisiones'] = 0;
		$this->_aFlags['asiento'] = 0;

		// debug("Constructor: Creando Indices ... ");
		// Crear Indices:
		$this->_aIndices['familia'] = new FieldIndexer('idx_detalle',array('nombre_grupo_familia','nombre_familia'));
		$this->_aIndices['producto'] = new FieldIndexer('idx_detalle',array('nombre_grupo_familia','nombre_familia','nombre'));
		$this->_aIndices['origen'] = new FieldIndexer('idx_detalle',array('iextra1'));
		$this->_aIndices['origenygrupo'] = new FieldIndexer('idx_detalle',array('iextra1','nombre_grupo_familia','nombre_familia','nombre'));
		$this->_aIndices['origenydestino'] = new FieldIndexer('idx_detalle',array('iextra1','iextra2'));
		$this->_aIndices['marca'] = new FieldIndexer('idx_detalle',array('nombre_marca'));

		$this->setCfg($aCfg);

		return $tmp;
	}

	function copyFromDocument($oDoc,$aDets = false,$bKeep = false,$bKeepDoc = true) {
		if (is_a($oDoc,'Document')) {
			parent::copyFromDocument($oDoc,$aDets,$bKeep,$bKeepDoc);

			if (is_a($oDoc,'Invoice')) {
				if (!$bKeepDoc OR !$this->getId()) {
					$aTmp = $oDoc->get_revenue();
					if (is_numeric($aTmp['id_tarifa'])) $this->set_revenue($aTmp['id_tarifa']);

					$fserie = $oDoc->getSeriesId();
					if ( (isset($fserie) AND !empty($fserie)) ) {
						$tipo = $this->getInstallment();
						$tipo_orig = $oDoc->getInstallment();
						if (($tipo>0 and $tipo_orig>0) or ($tipo==0 and $tipo_orig==0)) {
							$this->setSeries($fserie,false);
						} else {
							$fserie = $oDoc->getHeaderAttribute('id_serie_abonar');
							$this->setSeries($fserie,false);
						}
					}
				}
			}
		}
	}

	function setCfg($aCfg = NULL) {
		$retval = true;
		if (!is_array($aCfg)) {
			// debug("Obteniendo configuracion ... ");
			$aSCfg = $this->_oSesion->get_var('_aAppConf');
			$this->_aConf['iconta_dbname'] = $aSCfg['iconta_dbname'];
			$this->_aConf['iconta_dbcfgname'] = $aSCfg['iconta_dbcfgname'];
			$this->_aConf['iconta_ejercicio'] = $aSCfg['iconta_ejercicio'];
			$this->_aConf['iconta_diario'] = $aSCfg['iconta_diario'];
			$this->_aConf['iconta_canal'] = $aSCfg['iconta_canal'];
		} else {
			foreach ($aCfg as $campo => $valor) $this->_aConf[$campo] = $valor;
		}
		return $retval;
	}

	function getFromCfg($var = NULL) {
		if (empty($var) AND !is_numeric($var)) return $this->_aConf;
		else return $this->_aConf[$var];
	}

	function indexFields($idx = NULL) {
		if (is_array($this->_aIndices) AND sizeof($this->_aIndices)) {
			$aDet = $this->get_detail($idx);
			if (!is_array($aDet) OR !sizeof($aDet)) return false;
			$aDet['idx_detalle'] = $idx;

			foreach ($this->_aIndices as $i => $oIdx) {
				$aTmp = $aDet;
				$aTmp['idx_detalle'] = NULL;
				$aIdx = $this->_aIndices[$i]->get($aTmp);
				if (is_array($aIdx) AND sizeof($aIdx)) {
					// debug("Ya tenemos: ($i) para $idx ");
					$bCont = false;
					foreach ($aIdx as $num => $aI) {
						// print_r($aI);
						if (in_array($idx,$aI['values'])) {
							$bCont = true;
							// print_r($aI['values']);
							continue;
						}
					}
					if ($bCont) continue;
				}
				// debug("Indexando campos de linea $idx ... ");
				$this->_aIndices[$i]->Index($aDet);
			}
		}
	}

	function delIndexFields($idx = NULL) {
		debug("DES-Indexando campos de linea $idx ... ");
	}

	function get_id() { 
		return $this->getId(); 
	}

	function get_reference() { 
		return $this->getReference(); 
	}

	/** Metodos de mantenimiento (o sobrecargados del padre) **/
	function setDetailAttribute($idx,$campo,$valor = NULL) {

		$pedbase = 0;
		switch ($campo) {
			case 'id_pedido' :
				if (is_numeric($valor)) {
					$oldidped = $this->getDetailAttribute($idx,'id_pedido');
					if (is_numeric($oldidped)) $oldbase = $this->getDetailAttribute($idx,'base_imponible');
					$pedbase = $this->_aIDPedido[$valor]['base_imponible'];
				}
				break;

			default:
				// Comprobar si el campo tiene indice, y quitarlo de uno y meterlo en otro.
				break;
		}

		$retval = parent::setDetailAttribute($idx,$campo,$valor);

		if ($retval) 
			switch ($campo) {
				case 'id_pedido' :
					if (is_numeric($this->_aIDPedido[$oldidped]['base_imponible']) AND is_numeric($oldbase)) 
						$this->_aIDPedido[$oldidped]['base_imponible'] -= $oldbase;
					$pedbase += $oldbase;
					$this->_adjustOrders(array($valor => $pedbase),true);
					break;
			}

		return $retval;
	}

	function init() {
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->_oSesion = $GLOBALS[$this->App_Name];
		$this->set_db($this->_db_name);
	}

	function cerrar() {
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		unset($this->_db);
		unset($this->_oSesion);
		unset($this->_oAsiento);
		// unset($this->_db);
	}

	function error($err_code,$aParams = NULL) {
		$Sesion = $GLOBALS[$this->App_Name];
		if (!is_object($Sesion)) {
			echo "Error (Invoice.class:$err_code) $aParams";
			/** **
			global $$this->App_Name;
			array_push($this->_err_msg,$msg);
			array_push($this->_err_no,$err_code);
			echo "Error (inmPedido.class:$err_code) $msg";
			// $$this->App_Name->error($err_code,$msg);
			/** **/
		} else {
			$Sesion->lcMessage($err_code,$aParams);
		}
	}

	function _change_flags($tipo,$id = NULL) {
		if (!$tipo) return;
		parent::_change_flags($tipo,$id);
		if ($tipo & IEInvoice_EFFECTS) {
			if ($tipo & inmPed_OK) {
				$this->_aFlags['efectos'] |= inmPed_OK; 
				$this->_aFlags['efectos'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['efectos'] &= ~inmPed_MODIFIED; 
				$this->_aFlags['efectos'] &= ~inmPed_DB_COMMIT; 
			} else {
				if ($tipo & inmPed_MODIFIED) {
					$this->_aFlags['efectos'] |= inmPed_DB_COMMIT;
					$this->_aFlags['efectos'] |= inmPed_MODIFIED;
				}
				if ($tipo & inmPed_DB_COMMIT) {
					$this->_aFlags['efectos'] |= inmPed_DB_COMMIT;
				}
				if ($tipo & inmPed_DB_DELETE) {
					$this->_aFlags['efectos'] |= inmPed_DB_DELETE;
					$this->_aFlags['efectos'] |= inmPed_DB_COMMIT;
				}
			}
		} 
		if ($tipo & IEInvoice_COMMISSIONS) {
			if ($tipo & inmPed_OK) {
				$this->_aFlags['comisiones'] |= inmPed_OK; 
				$this->_aFlags['comisiones'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['comisiones'] &= ~inmPed_MODIFIED; 
				$this->_aFlags['comisiones'] &= ~inmPed_DB_COMMIT; 
			} else {
				if ($tipo & inmPed_DB_COMMIT) {
					$this->_aFlags['comisiones'] |= inmPed_DB_COMMIT;
				}
				if ($tipo & inmPed_MODIFIED) {
					$this->_aFlags['comisiones'] |= inmPed_DB_COMMIT;
				}
				if ($tipo & inmPed_DB_DELETE) {
					$this->_aFlags['comisiones'] |= inmPed_DB_DELETE;
					$this->_aFlags['comisiones'] |= inmPed_DB_COMMIT;
				}
			}
		} 
		if ($tipo & IEInvoice_ACCOUNTENTRY) {
			if ($tipo & inmPed_OK) {
				$this->_aFlags['asiento'] |= inmPed_OK; 
				$this->_aFlags['asiento'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['asiento'] &= ~inmPed_MODIFIED; 
				$this->_aFlags['asiento'] &= ~inmPed_DB_COMMIT; 
			} else {
				if ($tipo & inmPed_DB_COMMIT) {
					$this->_aFlags['asiento'] |= inmPed_DB_COMMIT;
				}
				if ($tipo & inmPed_MODIFIED) {
					$this->_aFlags['asiento'] |= inmPed_DB_COMMIT;
				}
				if ($tipo & inmPed_DB_DELETE) {
					$this->_aFlags['asiento'] |= inmPed_DB_DELETE;
					$this->_aFlags['asiento'] |= inmPed_DB_COMMIT;
				}
			}
		} 
	}

	function _build_taxes() {
		if (isset($this->_aPedido['id_serie_contabilizable']) AND !(int)$this->_aPedido['id_serie_contabilizable']) {
			if ($this->debug) debug("Invoice::_build_taxes() de una serie no contabilizable. ");
			parent::_build_taxes(false,false);
		} else parent::_build_taxes();
	}

	function _calculate_totals() {
		parent::_calculate_totals();
		if (isset($this->_aPedido['id_serie_contabilizable']) AND !(int)$this->_aPedido['id_serie_contabilizable']) {
			$this->_aTotales['importe'] += $this->_aTotales['retenido'];
			$this->_aTotales['retenido'] = 0;
		}
	}

	function eval_conditions($bCheck_dtos) {
		parent::eval_conditions($bCheck_dtos);
		//Fixme: Localizar si hay que recalcular los tickets tb. (o hacerlo siempre y pista)
		if (is_array($this->_aIDPedido) AND sizeof($this->_aIDPedido)) {
			foreach ($this->_aIDPedido as $idped => $aPed) {
				if (empty($idped)) continue;
				$oPed = new Order($this->App_Name,$this->_db_name,$this->getMode());
				$oPed->dbfill($idped);
				$oPed->_change_flags(inmPed_CHG_DETAIL | inmPed_CHG_PRICE,-1);
				$oPed->calculate(TRUE);
				$oPed->dbdump();
				$oPed = NULL;
				// debug("<b>Fin del recal</b>");
			}
		}
	}

	function set_detail_discount($idx,$discount = NULL,$bPto = TRUE,$nombre = NULL,$bForce = FALSE) {
		if (!is_numeric($idx)) return FALSE;
		$aDto = $this->get_detail_discount($idx);
		if (is_array($aDto) AND sizeof($aDto)) {
			$tiene_dto = TRUE;
			$campo_dto = ((is_numeric($aDto['monto']) AND $aDto['monto']!=0) ? 'monto' : 'porciento');
		} else $tiene_dto = FALSE;
		if (($idped=$this->getId_pedidoFromIdx($idx)) AND 
				(($tiene_dto AND $aDto[$campo_dto]!=$discount ) OR (!$tiene_dto AND $discount!=0) )) {
			$this->error('INVOICE_NODISCOUNT_ORDER',
					array('idx' => $idx, 'ref' => $this->_aDetalles[$idx]['nombre'], 'pedido' => $this->_aIDPedido[$idped]['referencia']));
			if ($this->debug) debug("dto: $discount pto($bPto) ($nombre)");
		} else {
			parent::set_detail_discount($idx,$discount,$bPto,$nombre,$bForce);
		}
	}

	function set_price($idx,$price = 0,$bDiscount = TRUE) {
		if (!is_numeric($idx)) return FALSE;
		if (($idped=$this->getId_pedidoFromIdx($idx))) {
			$this->error('INVOICE_NODISCOUNT_ORDER',
					array('idx' => $idx, 'ref' => $this->_aDetalles[$idx]['nombre'], 'pedido' => $this->_aIDPedido[$idped]['referencia']));
		} else {
			parent::set_price($idx,$price,$bDiscount);
		}
	}

	function set_quantity($idx,$cantidad,$bBultos = 0,$bSuma = false,$mTipo = inmPed_QUANTITY,$bDtos = TRUE) {
		if (!is_numeric($idx)) return false;
		if (($idped=$this->getId_pedidoFromIdx($idx))) {
			$base_ant = $this->get_detail_ammount($idx);
			if ($this->debug) debug("Anterior->base detalle: $base_ant - base pedido: ".$this->_aIDPedido[$idped]['base_imponible']);
		}

		$bDoIt = true;
		if ($this->getInstallment() AND $mTipo & inmPed_QUANTITY) {
			$iddb = $this->getDetailAttribute($idx,'id_detalle');
			// debug("iddb: $iddb ");
			if (is_numeric($iddb)) {
				// debug("Set_quantity($idx,$cantidad,$bBultos,$bSuma) ");
				// print_r($this->getInstalledInvoices());
				$cantidad_abonable = $this->getDetailInstalled($iddb);
				$cantidad_anterior = $this->get_quantity($idx);
				// debug("es abonable($cantidad_abonable) y abonada($cantidad_anterior) = podrian... : ".($cantidad_abonable-$cantidad_anterior));
				if ($cantidad_abonable-$cantidad_anterior <= 0 AND $bSuma AND $cantidad > 0 ) $bDoIt = false;
			}
		}

		if ($bDoIt) {
			$bDoIt = parent::set_quantity($idx,$cantidad,$bBultos,$bSuma,$mTipo,$bDtos);
			if ($this->getInstallment() AND is_numeric($cantidad_anterior) AND $mTipo & inmPed_QUANTITY ) {
				$cantidad_nueva = $this->get_quantity($idx);
				// debug("Re comprobamos a ver... si se permite $cantidad_nueva o no");
				if (($cantidad_nueva!=$cantidad_anterior) AND $cantidad_abonable - $cantidad_nueva < 0) {
					debug("Error: Hemos excedido los limites ... no se puede abonar mas cantidad de la facturada actualmente ");
					$bDoIt = parent::set_quantity($idx,$cantidad_anterior,false,false,$mTipo,$bDtos);
					if ($bDoIt) $bDoIt = false;
				}
			}
			if ($this->debug) print_r($this->_aDetalles[$idx]);
			if (is_numeric($idped) AND $bDoIt) {
				$base_act = $this->get_detail_ammount($idx);
				$base = $base_act - $base_ant;
				$aDtos = $this->get_discounts();
				if (is_array($aDtos) AND is_array($aDtos['detalle'])) 
					foreach ($aDtos['detalle'] as $orden => $aDt) 
						if (is_numeric($aDt['descuento'])) 
							$base -= round($base * $aDt['descuento'] / 100,$this->tot_decimals);

				if (is_numeric($idped) AND !empty($idped))
					$this->_aIDPedido[$idped]['base_imponible'] += round($base,$this->tot_decimals);
			}
		}
		return $bDoIt;
	}

	/** Fin de los metodos de mantenimiento **/

	/** 
	  * Metodos SET y GET de los atributos *
	  *
	  *   -- Metodos de Cabeceras y Pies --
	 */

	/** (TODO: Retocar para obtener las posibles direcciones -agentes no-)
	  * Metodo que establece/asigna la empresa(compras) o cliente(compras) receptora del documento pedido actual.
	  * @param	$id		-	id(en bbdd) del receptor que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return		bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function set_reciever($id,$bForce = FALSE) {
		if (!is_numeric($id)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;

		$id_empresa = (int)$this->_aEmisor[id_empresa];
		if ($this->_fPedido & inmPed_VENTA) {
			$retval = $this->_set_client_reciever($id,$bForce);
			$this->_possible_agents_clients($id,0);
		} else {
			$retval = $this->_set_enterprise_reciever($id,$bForce);
			$this->_possible_agents_clients($id,1);
		}
		if (!$retval) return $retval;
				
		if ((int)$this->_aEmisor['id']) {
			if ($this->debug) debug("Emisor ya establecido. Desbloqueando pedido...");
			$this->setDate();
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK | inmPed_DB_COMMIT);
		}

		/** **
		debug("set_reciever()");
		debug("<br/>Pedido :");
		print_r($this->_aPedido);
		debug("<br/>Receptor :");
		print_r($this->_aReceptor);
		debug("<br/>Agente :");
		print_r($this->_aAgente);
		debug("<br/>Tarifa :");
		print_r($this->_aTarifa);
		/** **/

		return TRUE;
	}

	/**
	  * Establece cual es el agente creador del pedido.
	  * @param  id_agente	-  Identificador del agente a establecer como realizador del pedido.
	  * @param  bForce		-  Si se ha de ignorar las opcion Strict y asignar el agente por 00
	  * @return bool			-	Verdadero caso de poder haber sido establecido, falso en caso de fallo
	  **/
	function setAgent($id_agente,$bForce = FALSE) {
		if (!is_numeric($id_agente)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		if ((int)$this->_aPedido['id_cliente'] ) { 
			// Si ya sabemos el cliente, comprobamos que el agente pertenezca al cliente (si es preciso)
			if (is_array($this->_aAgentes_cliente)) {
				if (!is_array($this->_aAgentes_cliente[$id_agente])) {
					if (!$bForce AND $this->_fPedido & inmPed_STRICT) {
						$this->error('DOCUMENT_NO_RECIEVERS_AGENT',array('id' => $id_agente));
						return FALSE;
					} else $agente_db = TRUE;
					$get_clientes = FALSE;
				} else { // Cogemos los datos del agente del array que ya hay.
					$this->_aAgente = $this->_aAgentes_cliente[$id_agente];
					$this->_aPedido['id_agente'] = $this->_aAgente['id_agente'];
					$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
					return TRUE;
				}
			} else {
				$agente_db = TRUE;
				$get_clientes = TRUE;
			}
		}  else  {
			$agente_db = TRUE;
			$get_clientes = TRUE;
		}

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}

		// Sacamos los valores del agente de la DB. (sin mirar cliente)
		if ($agente_db) {
			$cons = "SELECT ".
					  "Agentes.id_agente as 'id_agente', ".
					  "CONCAT(Agentes.apellidos,', ',Agentes.nombre) as 'nombre', ".
					  "Agentes.comision_base as 'comision', ".
					  "Agentes.comision_repartida as 'comision_repartida' ".
					  "FROM Agentes ".
					  "WHERE Agentes.id_agente = $id_agente ";
			$id_rs = $oDb->query($cons);
			if (!$oDb->num_rows($id_rs)) {
				$this->error('DOCUMENT_AGENT_NOTFOUND',array('id' => $id_agente));
				return FALSE;
			}
			$aTmp = $oDb->fetch_assoc($id_rs);
			$this->_aAgente = $aTmp;
			$this->_aPedido['id_agente'] = $this->_aAgente['id_agente'];
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
			$oDb->libera($id_rs);

			if ($get_clientes AND $this->_fPedido & inmPed_VENTA) {
				if ($this->debug) debug("Buscamos clientes para este agente...");
				// Rellenar el array de posibles clientes del agente.
				if (!(int)$this->_aPedido['id_cliente']) {
					$cons = "SELECT ".
							  "Cli.id_cliente as 'id_cliente', ".
							  "IF (Cli.razon_social IS NOT NULL,Cli.razon_social, ".
							  "CONCAT(Cli.apellidos,', ',Cli.nombre)) as 'nombre', ".
							  "AC.comision as 'comision', ".
							  "AC.comision_repartida as 'comision_repartida' ".
							  "FROM Clientes `Cli`, Agentes_clientes `AC` ".
							  "WHERE Cli.id_cliente = AC.id_cliente AND AC.id_agente = $id_agente ";
					$id_rs = $oDb->query($cons);
					if ($oDb->num_rows($id_rs)) 
						while ($aTmp = $oDb->fetch_assoc($id_rs)) $this->_aClientes_agente[$aTmp[id_cliente]] = $aTmp;
					else $this->_aClientes_agente = NULL;
					$oDb->libera($id_rs);
				}
			}
		}
	}

	/**
	  * Retorna un array con los datos del agente que ha realizado el pedido.
	  * @return array()	-	Los datos del agente.
	  **/
	function getAgent() {
		return $this->_aAgente;
	}


	/**
	  * Anyade un agente para recibir Comision(es) de esta Factura
	  * @param  id_agente	-  Identificador del agente a establecer como realizador del pedido.
	  * @param  bForce		-  Si se ha de ignorar las opcion Strict y asignar el agente por 00
	  * @return bool			-	Verdadero caso de poder haber sido establecido, falso en caso de fallo
	  **/
	function addAgent($id_agente,$bForce = FALSE) {
		if (!is_numeric($id_agente)) return FALSE;

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('INVOICE_NODB');
			return FALSE;
		}

		if (is_array($this->_aAgentes_cliente[$id_agente]) AND !$bForce) {
			$this->_aAgentes_comisiones[$id_agente] = $this->_aAgentes_cliente[$id_agente];
		} else {
			// Sacamos los valores del agente de la DB. (sin mirar cliente)
			$cons = "SELECT ".
					  "Agentes.id_agente as 'id_agente', ".
					  "CONCAT(Agentes.apellidos,', ',Agentes.nombre) as 'nombre', ".
					  "Agentes.comision_base as 'comision', ".
					  "Agentes.comision_repartida as 'comision_repartida' ".
					  "FROM Agentes ".
					  "WHERE Agentes.id_agente = $id_agente ";
			$id_rs = $oDb->query($cons);
			if (!$oDb->num_rows($id_rs)) {
				$this->error('DOCUMENT_AGENT_NOTFOUND',array('id' => $id_agente));
				return FALSE;
			}
			$aTmp = $oDb->fetch_assoc($id_rs);
			$this->_aAgentes_comisiones[$aTmp['id_agente']] = $aTmp;
			// $this->_aPedido['id_agente'] = $this->_aAgente['id_agente'];
			// $this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
			$oDb->libera($id_rs);
		}
		return TRUE;
	}

	/**
	  * Retorna un array con los datos del agente que ha realizado el pedido.
	  * @return array()	-	Los datos del agente.
	  **/
	function getAgentFrom($id = NULL,$bComision = NULL) {
		if (!is_numeric($id)) return NULL;
		if (!isset($bComision)) {
			if (is_array($this->_aAgentes_cliente[$id]))
				return $this->_aAgentes_cliente[$id];
			else return $this->_aAgentes_comisiones[$id];
		} elseif ($bComision) {
			// debug("getAgent: Obteniendo el agente de la comision");
			return $this->_aAgentes_comisiones[$id];
		} else {
			//debug("getAgent:  obteneidno el agente del cliente");
			return $this->_aAgentes_cliente[$id];
		}
	}

	/**
	  * Establece la referencia interna del pedido a la cadena indicada por parametro. Si la cadena no ha sido inidaca, o es nula
	  *	y el pedido no tiene referencia interna, este metodo se encarga de buscar una referencia adecuada asi como de incrementar
	  *	el contador de pedidos en la base de datos para la siguiente solicitud.
	  * Caso de recibir 0 como parametro, fuerza la busqueda de una nueva referencia.
	  **/
	function setReference($ref = NULL,$bForce = false) {
		// Fixme: Comprobar si el pedido/presupuesto es de compras o de ventas.
		if ((!isset($ref) OR empty($ref)) AND (empty($this->_aPedido['referencia']) OR $bForce)) {
			if ($this->_fPedido & inmPed_VENTA) $sufijo = 'ventas';
			else $sufijo = 'compras';
			if (empty($this->_aPedido['id_empresa']) OR !is_numeric($this->_aPedido['id_empresa'])) {
				$this->error('INVOICE_COMPANY_NOTFOUND',array('id' => $this->_aPedido['id_empresa']));
				return FALSE;
			}
			//crear la referencia e incrementar el contador
			$consulta = "SELECT ".
							"prefijo_fact_$sufijo as 'prefijo_ped', ".
							"sufijo_fact_$sufijo as 'sufijo_ped', ".
							"digitos_fact_$sufijo as 'digitos_ped' ".
							"FROM  Empresas where id_empresa = ".$this->_aPedido['id_empresa'];
			$idrs = $this->_db->query($consulta);
			if (!$this->_db->num_rows($idrs)) return FALSE;
			$aPrefs=$this->_db->fetch_assoc($idrs);

			//relleno de digitos para la numeracion de la factura
			$contador = $this->getSeriesCounter();
			$temporal = pow(10,( (int)$aPrefs['digitos_ped'] ));
			$temporal += $contador;
			$t = substr((string)$temporal,1);

			// $ref = $aPrefs[prefijo_ped].((!empty($aPrefs[prefijo_ped])) ? "-" : "").$t.
						// ((!empty($aPrefs[sufijo_ped])) ? "-" : "").$aPrefs[sufijo_ped];
			$ref = ((!empty($this->_aPedido['nombre_serie_facturacion'])) 
							? $this->_aPedido['nombre_serie_facturacion'] : '').$aPrefs['prefijo_ped'].$t.$aPrefs['sufijo_ped'];

		} elseif (!empty($this->_aPedido['referencia'])) {
			if (!isset($ref) OR empty($ref)) return true;
		}
		// debug("set_reference($ref)");
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		$this->_aPedido['referencia'] = $ref;
		return true;
	}

	function getReference($tipo = NULL) {
		if (empty($tipo) OR (strcmp($tipo,'extern') AND strcmp($tipo,'externa'))) 
			return $this->_aPedido['referencia'];
		else
			return $this->_aPedido['referencia_externa'];
	}

	function getId() {
		return $this->_aPedido['id_factura'];
	}

	function setStatus($preparado) {
		return $this->setIssued($preparado);
	}

	function getStatus() {
		return (int)$this->_aPedido['preparado'];
	}

	function setSeries($id = NULL,$bSetRef = true) {
			if ($this->_fPedido & inmPed_VENTA) $venta = 1;
			else $venta = 0;

			if ($bSetRef) $bSetRef = true;
			else $bSetRef = false;

			if ( (!is_numeric($id) OR $id == $this->_aPedido['id_serie']) AND $bSetRef ) return false;
			elseif ( (is_numeric($id) AND is_numeric($this->_aPedido['id_serie']) AND $id == $this->_aPedido['id_serie']) AND !$bSetRef ) return true;

			if (is_numeric($id)) {
				$id_serie = (int)$id;
				$cons="SELECT id_serie,contador,contabilizable,nombre,id_serie_abonar FROM Series_facturacion WHERE id_serie = $id_serie";
			} else {
				$cons="SELECT id_serie,contador,contabilizable,nombre,id_serie_abonar FROM Series_facturacion ".
							"WHERE ventas = $venta ORDER BY contador desc LIMIT 1";
			}
			$tmprs = $this->_db->query($cons);
			if (!$this->_db->num_rows($tmprs)) return false;
			$aTmp = $this->_db->fetch_row($tmprs);
			if (isset($this->_aPedido['id_serie_contabilizable']))
				$old_contabilizable = (int)$this->_aPedido['id_serie_contabilizable'];
			else $old_contabilizable = NULL;
			$this->_aPedido['id_serie'] = $id_serie = $aTmp[0];
			$this->_aPedido['id_serie_contabilizable'] = (int)$aTmp[2];
			$this->_aPedido['nombre_serie_facturacion'] = $aTmp[3];
			$this->_aPedido['id_serie_abonar'] = (int)$aTmp[4];
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
			if (!is_numeric($old_contabilizable) OR (is_numeric($old_contabilizable) AND $old_contabilizable!=$this->_aPedido['id_serie_contabilizable'])) {
				$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
				$this->_build_taxes();
			}

			if ($bSetRef) {
				$this->_aPedido['referencia'] = NULL;
				$this->setReference();
			}

			$this->_db->libera($tmprs);
	}

	function getSeriesCounter() {
			if ($this->_fPedido & inmPed_VENTA) $venta = 1;
			else $venta = 0;

			if (!is_numeric($id)) $id = $this->_aPedido['id_serie'];

			if (is_numeric($id)) {
				$id_serie = (int)$id;
				$cons = "SELECT id_serie,contador,contabilizable,nombre FROM Series_facturacion WHERE id_serie = $id_serie";
			} else {
				$cons = "SELECT id_serie,contador,contabilizable,nombre FROM Series_facturacion WHERE ventas = $venta ORDER BY contador desc LIMIT 1";
			}
			$tmprs = $this->_db->query($cons);
			if (!$this->_db->num_rows($tmprs)) return NULL;
			$aTmp = $this->_db->fetch_row($tmprs);
			if (!is_numeric($id)) {
				if (isset($this->_aPedido['id_serie_contabilizable']))
					$old_contabilizable = (int)$this->_aPedido['id_serie_contabilizable'];
				else $old_contabilizable = NULL;
				$this->_aPedido['id_serie'] = $id_serie = $aTmp[0];
				$this->_aPedido['id_serie_contabilizable'] = (int)$aTmp[2];
				$this->_aPedido['nombre_serie_facturacion'] = $aTmp[3];
				$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
				if (!is_numeric($old_contabilizable) OR (is_numeric($old_contabilizable) AND $old_contabilizable!=$this->_aPedido['id_serie_contabilizable'])) {
					$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
					$this->_build_taxes();
				}
			}
			$this->_db->libera($tmprs);
			if (is_numeric($id_serie)) {
				$cons = "UPDATE Series_facturacion SET contador = contador +1 WHERE id_serie = $id_serie";
				$this->_db->query($cons);
				return $aTmp[1];
			} else return NULL;
	}

	function getSeriesId() {
			if ($this->_fPedido & inmPed_VENTA) $venta = 1;
			else $venta = 0;

			return $this->_aPedido['id_serie'];
	}

	function getDate() {
		return $this->get_date();
	}

	function setDate($f = NULL) {
		$rval = $this->set_date($f);
		if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
		if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array('fecha' => $this->getDate()),'Facturas',false);
		if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $this->_aPedido[$fld] = $val;
		return $rval;
	}

	function getComments() {
		return $this->get_comments();
	}

	function setInstallment($tipo = NULL,$id_fra = NULL, $aDets = NULL) {

		if (!isset($tipo)) {
			$def_installment = $this->getFromCfg('invoice_default_installment');
			if (!is_numeric($def_installment)) {
				$aCfg = $this->_oSesion->get_var('_aAppConf');
				$def_installment = $aCfg['invoice_default_installment'];
			}
			if (is_numeric($def_installment)) $tipo = $def_installment;
		}
		if (!isset($tipo)) $tipo = $this->INSTALLMENT_EFFECTS_ACCOUNT;
		if (!is_numeric($tipo)) $tipo = $this->getInstallment();
		if (!is_numeric($tipo)) return false;

		$bDone = false;
		switch ($tipo) {
			case $this->INSTALLMENT_EFFECTS_ACCOUNT:
				$this->_aPedido['factura_abono'] = $this->INSTALLMENT_EFFECTS_ACCOUNT;
				$bDone = true;
				break;
			case $this->INSTALLMENT_EFFECTS_MATTERS:
				$this->_aPedido['factura_abono'] = $this->INSTALLMENT_EFFECTS_MATTERS;
				$bDone = true;
				break;
			case $this->INSTALLMENT_MATTERS:
				$this->_aPedido['factura_abono'] = $this->INSTALLMENT_MATTERS;
				$bDone = true;
				break;
			case $this->INSTALLMENT_ACCOUNT:
				$this->_aPedido['factura_abono'] = $this->INSTALLMENT_ACCOUNT;
				$bDone = true;
				break;
			default:
				$this->_aPedido['factura_abono'] = $this->INSTALLMENT_EFFECTS_ACCOUNT;
				$bDone = true;
				break;
		}

		if ($bDone) {
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);

			if (is_a($id_fra,'Invoice')) $oFra = $id_fra;

			if (is_object($oFra)) {
				$aAbonos = $oFra->getInstalledInvoices();

				$aAuxDet = array();
				if (!is_array($aDets)) {
					$bAll = true;
					$aDets = array();
				} else $bAll = false;

				$id = $this->getId();
				for ($idx = $oFra->first_detail(); isset($idx); $idx=$oFra->next_detail()) {
					$id_det = $oFra->getDetailAttribute($idx,'id_detalle');
					$tmp_cant = $oFra->get_quantity($idx);
					if ($bAll) $aDets[$idx] = 1;
					else if (!(int)$aDets[$idx]) continue;

					$cant = $oFra->get_quantity($idx);
					if ($this->debug) debug("La cantidad de la factura es $cant ");
					$aAuxDet[$idx] = $cant;
					if (is_array($aAbonos) AND sizeof($aAbonos)) 
						foreach ($aAbonos as $aF) {
							if (is_numeric($aF['id_factura']) AND $aF['id_factura']!=$id AND (int)$aF['factura_abono'] AND !empty($aF['detalles'][$id_det])) {
								if ($this->debug) debug("Restamos ".$aF['detalles'][$id_det]." de la factura de abono ".$aF['referencia']);
								$aAuxDet[$idx] -= $aF['detalles'][$id_det]; 
							}
						}
					// debug("Se podria resumir en : ".($oFra->getDetailInstalled($id_det)*-1)+$this->get_quantity());
					if ($aAuxDet[$idx]<=0) {
						if (is_numeric($aAuxDet[$idx]) AND $aAuxDet[$idx]>0) {
							debug("Error: No se puede abonar (".$aAuxDet[$idx].") de idx $idx por haber sido abonadas todas sus cantidades.");
						}
						$aAuxDet[$idx] = 0;
						$aDets[$idx] = NULL;
						unset($aDets[$idx]);
					}
				}
				if ($this->debug) {
					debug("para llamar Constructor copia con los siguientes detalles: ");
					print_r($aDets);
				}

				$this->copyFromDocument($oFra,$aDets,true);
				$id_fra = $oFra->getId();

				$aFra['preparado'] = $oFra->getStatus() ;
				$aFra['fecha'] = $oFra->getDate() ;
				$aFra['referencia'] = $oFra->getReference() ;

				if (is_array($aAuxDet) AND sizeof($aAuxDet)) {
					foreach ($aAuxDet as $idx => $cant) {
						if (!is_numeric($aDets[$idx])) continue;
						$id_det = $oFra->getDetailAttribute($idx,'id_detalle');
						if (!is_numeric($id_det)) continue;
						$idxnew = $this->get_idxdetail_db($id_det);
						if (!is_numeric($idxnew)) continue;

						$cantidad = $this->get_quantity($idx);
						if ($cantidad != $cant) {
							$this->set_quantity($idxnew,$cant,NULL,false,NULL,false);
						}
						$aFra['detalles'][$id_det] += $oFra->get_quantity($idx);
					}
				}
			}

			if (is_numeric($id_fra)) {
				if (!is_array($this->_aIDFacturaAbono[$id_fra])) {
					$aFra['id_factura'] = $id_fra;
					$aFra['_dbfetch'] = 0;
					$aFra['_abonar'] = 1;
					$this->_aIDFacturaAbono[$aFra['id_factura']] = $aFra;
				} elseif (is_array($aFra['detalles']) AND sizeof($aFra['detalles'])) {
					if ($this->debug) debug("Ete($id_fra) ya taba eh ... ");
					foreach ($aFra['detalles'] as $iddb => $cant) {
						if ($this->debug) debug("Detalle $iddb cantidad $cant ");
						if (!is_numeric($this->_aIDFacturaAbono[$aFra['id_factura']]['detalles'][$iddb])) {
							 $this->_aIDFacturaAbono[$id_fra]['detalles'][$iddb] = $cant;
						}
					}
				}
				if ($this->debug) print_r($this->_aIDFacturaAbono);
			}
		}
		return $bDone;
	}

	function getInstallment() {
		return $this->_aPedido['factura_abono'];
	}

	function getInstalledInvoices() {
		return $this->_aIDFacturaAbono;
	}

	function getDetailInstalled($iddb) {
		$aAlbs = $this->getInstalledInvoices();
		$cant = NULL;
		if (is_array($aAlbs) AND sizeof($aAlbs)) 
			foreach ($aAlbs as $id_alb => $aA) {
				if (is_numeric($aA['detalles'][$iddb]))
					if ((int)$aA['factura_abono']) $cant -= $aA['detalles'][$iddb];
					else $cant += $aA['detalles'][$iddb];
			}
		return $cant;
	}

	/**
	  * Metodo encargado de devolver los albaranes de un pedido.
	  **/
	function getDeliveryOrders() {
		return $this->_aIDAlbaran;
	}

	function isDetailDelivered($iddb) {
		$aAlbs = $this->getDeliveryOrders();
		if (is_array($aAlbs) AND sizeof($aAlbs)) 
			foreach ($aAlbs as $id_alb => $aA) 
				if (is_array($aA['detalles'][$iddb]) AND sizeof($aA['detalles'][$iddb]))
					return true;
		return false;
	}

	/**
	  * Metodo encargado de devolver las Facturas de un Pedido.
	  **/
	function getOrders() {
		return $this->_aIDPedido;
	}

	function del_detail($idx = NULL,$bDtos = TRUE, $bServi = FALSE) {
		if (!isset($idx)) $idx = $this->_DetIdx_act;
		$idped = $this->getDetailAttribute($idx,'id_pedido');
		if ($bServi) {
			$idserv = $this->get_detail_attribute($idx,'id_servicio');
			if (!is_numeric($idserv)) $bServi = FALSE;
			else {
				$price = $this->get_price($idx);
			}
		}

		$retval = parent::del_detail($idx,$bDtos);
		if (is_numeric($idx)) $this->delIndexFields($idx);
		// Des-Indexando:

		if ($bServi) {
			$this->_aDet_dbdel[$idx]['id_servicio'] = $idserv;
			$this->_aDet_dbdel[$idx]['price'] = $price;
		}
		return $retval;
	}

	function add_detail($id_art,$cantidad = NULL,$bBultos = 0,$bCheck_dtos = TRUE,$force_idx = NULL,$aForceIDs = 0) {
		$retval = parent::add_detail($id_art,$cantidad,$bBultos,$bCheck_dtos,$force_idx,$aForceIDs);
		if (is_numeric($retval)) $this->indexFields($retval);
		// Indexando:
		return $retval;
	}

	/**   -- Metodos de Cabeceras y Pies -- **/
	function getDeliveryFromDbDet($id_detalle) {
		if (is_array($this->_aDbDetToAlb[$id_detalle])) return $this->_aDbDetToAlb[$id_detalle];
		else return array();
	}

	function getDeliveryFromIdx($idx) {
		if (is_array($this->_aIdxToAlb[$idx])) return $this->_aIdxToAlb[$idx];
		else return array();
	}

	function __get($prop_name) {
		debug("Metodo get general ($prop_name,$prop_value)");
		return $this->$prop_name;
	}
	
	function __set($prop_name,$prop_value) {
		debug("Metodo set general ($prop_name,$prop_value)");
	}

	function __call($metodo,$aArgs) {
		debug("Metodo CALL general ($metodo,$aArgs)");
	}
	/** FIN de los Metodos set y get **/

	/** 
	  * Metodos de funcionalidades inherentes a la instancia 
	  *
	  ****** Metodos Privados:  ********
	  **/

	/**
	  * Metodo encargado de obtenernos los datos de las cabeceras del pedido. Estas son , emisor , receptor, forma de pago, divisa
	  * y pedido para los pedidos de venta. Este metodo es llamado por dbfill() para poblar estas estructuras.
	  * @param $id		-	Identificador del pedido del cual se desea poblar las cabeceras.
	  * @return bool	-	TRUE on success, FALSE on failure.
	  **/
function _dbfetch_sale_headders($id) {
	if (!is_numeric($id) OR $id == 0) return FALSE;

	$oDb = $this->_db;
	// Rellenamos las cabeceras del pedido:
	$cons = "SELECT Fra.id_factura as 'fra_id_factura', ".
			  "Fra.id_empresa as 'fra_id_empresa', ".
			  "Fra.id_tarifa as 'fra_id_tarifa', ".
			  "Fra.id_serie as 'fra_id_serie', ".
			  "Cli.id_cliente as 'fra_id_cliente', ".
			  "Fra.id_proveedor as 'fra_id_proveedor', ".
			  "Fra.id_agente as 'fra_id_agente', ".
			  "Fra.id_divisa as 'fra_id_divisa', ".
			  "Fra.id_forma_pago as 'fra_id_forma_pago', ".
			  "Fra.factura_abono as 'fra_factura_abono', ".
			  "FPago.nombre as 'fra_nombre_forma_pago', ".
			  "FPago.nombre as 'fpa_nombre', ".
			  "FPago.id_forma_pago as 'fpa_id_forma_pago', ".
			  "FPago.num_efectos as 'fpa_num_efectos', ".
			  "FPago.dias_efectos as 'fpa_dias_efectos', ".
			  "FPago.medio_pago as 'fpa_medio_pago', ".
			  "CliEmp.dia_facturacion_1 as 'fpa_dia_I', ".
			  "CliEmp.dia_facturacion_2 as 'fpa_dia_II', ".
			  "CliEmp.dia_facturacion_3 as 'fpa_dia_III', ".
			  "Fra.referencia as 'fra_referencia', ".
			  "Fra.referencia_externa as 'fra_referencia_externa', ".
			  "Fra.notas as 'fra_observaciones', ".
			  "Fra.fecha as 'fra_fecha', ".
			  "Fra.id_dia as 'fra_id_dia', ".
			  "Fra.fecha_emision as 'fra_fecha_emision', ".
			  "Fra.id_dia_emision as 'fra_id_dia_emision', ".
			  "Fra.estado as 'fra_preparado', ".
			  "Fra.contabilizado as 'fra_contabilizado', ".
			  "Fra.id_asiento as 'fra_id_asiento', ".
			  "Fra.monto_prepago as 'tot_monto_prepago', ".
			  "Fra.monto_cuenta as 'tot_monto_cuenta', ".
			  "Fra.descuento as 'tot_descuentos', ".
			  "Fra.base_imponible as 'tot_base_imponible', ".
			  "Fra.total_impuestos as 'tot_total_impuestos', ".
			  "Fra.retenido as 'tot_retenido', ".
			  "Fra.monto_total as 'tot_importe', ".
			  "(Fra.monto_total-Fra.monto_cuenta) as 'tot_importe_pagar', ".
			  "Fra.total_bruto as 'tot_bruto', ".
			  "Cli.id_cliente as 'cli_id', ".
			  "Cli.id_cliente as 'cli_id_cliente', ".
			  "Cli.razon_social as 'cli_razon_social', ".
			  "Cli.nombre as 'cli_nombre', ".
			  "Cli.apellidos as 'cli_apellidos', ".
			  "Cli.direccion_facturacion as 'cli_direccion_facturacion', ".
			  "Cli.poblacion as 'cli_poblacion', ".
			  "Cli.cp as 'cli_cp', ".
			  "Cli.prefijo_cif as 'cli_prefijo_cif', ".
			  "Cli.cif as 'cli_cif', ".
			  "Cli.telefono1 as 'cli_telefono1', ".
			  "Cli.fax as 'cli_fax', ".
			  "Cli.email as 'cli_email', ".
			  "Cli.web as 'cli_web', ".
			  "Prov2.nombre as 'cli_provincia', ".
			  "TCli.aplicar_iva as 'cli_aplicar_iva', ".
			  "TCli.aplicar_recargo as 'cli_aplicar_recargo', ".
			  "CliEmp.monto_cuenta as 'cli_monto_cuenta', ".
			  "CliEmp.dto_directo as 'cli_dto_directo', ".
			  "CliEmp.dto_pronto_pago as 'cli_dto_pronto_pago', ".
			  "CliEmp.aplicar_retencion as 'cli_aplicar_retencion', ".
			  "CliEmp.mostrar_ofertas as 'cli_mostrar_ofertas', ".
			  "CliEmp.aplicar_dto_vol as 'cli_aplicar_dto_volumen', ".
			  "CliEmp.cc_banco as 'cli_cc_banco', ".
			  "CliEmp.cc_cliente as 'cli_cc_cliente', ".
			  "CliEmp.cc_gastos as 'cli_cc_gastos', ".
			  "CliEmp.cc_ventas as 'cli_cc_ventas', ".
			  "CliEmp.cc_descuento_financiero as 'cli_cc_descuento_financiero', ".
			  "CliEmp.cc_descuento_comercial as 'cli_cc_descuento_comercial', ".
			  "CliEmp.cc_retenciones as 'cli_cc_retenciones', ".
			  "CliEmp.cc_efectos as 'cli_cc_efectos', ".
			  "Div2.id_divisa as 'cli_id_divisa', ".
			  "Div2.nombre as 'cli_div_nombre_divisa', ".
			  "Div2.leyenda as 'cli_div_leyenda', ".
			  "Div2.nombre as 'cli_div_nombre', ".
			  "Div2.ratio as 'cli_div_ratio', ".
			  "Emp.razon_social as 'emp_razon_social', ".
			  "Emp.capital_social as 'emp_capital_social', ".
			  "Emp.inscripcion_registro as 'emp_inscripcion_registro', ".
			  "Emp.direccion_facturacion as 'emp_direccion_facturacion', ".
			  "Emp.cif as 'emp_cif', ".
			  "Emp.prefijo_cif as 'emp_prefijo_cif', ".
			  "Emp.cp as 'emp_cp', ".
			  "Emp.poblacion as 'emp_poblacion', ".
			  "Prov.nombre as 'emp_provincia', ".
			  "Emp.fax as 'emp_fax', ".
			  "Emp.telefono1 as 'emp_telefono1', ".
			  "Emp.web as 'emp_web', ".
			  "Emp.email as 'emp_email', ".
			  "Emp.retencion as 'emp_retencion', ".
			  "Emp.id_empresa as 'emp_id_empresa', ".
			  "Emp.id_empresa as 'emp_id', ".
			  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto,NULL) as 'emp_dto_bulto', ".
			  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto_uds,NULL) as 'emp_dto_bulto_uds', ".
			  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa,NULL) as 'emp_dto_capa', ".
			  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa_uds,NULL) as 'emp_dto_capa_uds', ".
			  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet,NULL) as 'emp_dto_palet', ".
			  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet_uds,NULL) as 'emp_dto_palet_uds', ".
			  "Tar.nombre as 'tar_nombre', ".
			  "Tar.campo_accion as 'tar_campo_accion', ".
			  "Tar.campo_recomendacion as 'tar_campo_recomendacion', ".
			  "Tar.pto_recomendacion as 'tar_pto_recomendacion', ".
			  "Tar.coniva_recomendacion as 'tar_coniva_recomendacion', ".
			  "Tar.pto_primero as 'tar_pto_primero', ".
			  "Tar.pto_segundo as 'tar_pto_segundo', ".
			  "Tar.monto as 'tar_monto', ".
			  "Div.id_divisa as 'div_id_divisa', ".
			  "Div.leyenda as 'div_leyenda', ".
			  "Div.nombre as 'div_nombre_divisa', ".
			  "Div.ratio as 'div_ratio' ".
			  "FROM Facturas `Fra`, Clientes `Cli`, Clientes_empresas `CliEmp`, Forma_pago as `FPago`, ".
			  "Tarifas `Tar`, Empresas `Emp`, Divisa `Div`, Divisa `Div2`, Tipo_cliente `TCli`, Provincias `Prov`, Provincias `Prov2` ".
			  "WHERE Fra.id_factura = $id AND Prov.id_provincia = Emp.id_provincia ".
			  "AND FPago.id_forma_pago = Fra.id_forma_pago AND ".
			  "Prov2.id_provincia = Cli.id_provincia AND ".
			  "Fra.id_empresa = CliEmp.id_empresa AND CliEmp.id_cliente=Cli.id_cliente AND Fra.id_cliente = CliEmp.id_cliente AND ".
			  "Fra.id_tarifa = Tar.id_tarifa AND Fra.id_empresa = Emp.id_empresa AND ".
			  "Cli.id_divisa = Div2.id_divisa AND ".
			  "Emp.id_divisa = Div.id_divisa AND CliEmp.id_tipo_cliente = TCli.id_tipo_cliente ";

	$id_rs = $oDb->query($cons);
	if ($oDb->num_rows($id_rs)) {
		$aPedido = $oDb->fetch_assoc($id_rs);
		foreach($aPedido as $clave => $valor) {
			$ref_arr = substr($clave,0,4);
			$ref_resto = substr($clave,4);
			// debug("parcial = $ref_arr, resto = $ref_resto");
			if (!strcasecmp($ref_arr,'fra_')) {
				$this->_aPedido[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'cli_')) {
				$this->_aReceptor[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'emp_')) {
				$this->_aEmisor[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'tar_')) {
				$this->_aTarifa[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'div_')) {
				$this->_aDivisa[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'fpa_')) {
				$this->_aFPago[$ref_resto] = $valor;
			} elseif (!strcasecmp($ref_arr,'tot_')) {
				$this->_aTotales[$ref_resto] = $valor;
			}
		}
		if (is_numeric($this->_aPedido['id_serie'])) {
			$sercons = 'SELECT '.
							"Ser.contabilizable as 'id_serie_contabilizable', ".
							"Ser.nombre as 'nombre_serie_facturacion', Ser.id_serie_abonar as 'id_serie_abonar' ".
							'FROM Series_facturacion `Ser` WHERE Ser.id_serie = '.$this->_aPedido['id_serie'];
			$serrs = $oDb->query($sercons);
			if ($oDb->num_rows($serrs)) {
				$aTmp = $oDb->fetch_assoc($serrs);
				foreach ($aTmp as $clave => $valor) $this->_aPedido[$clave] = $valor;
				$aTmp = NULL;
				unset($aTmp);
			}
		}
		$this->_aTotales['sin_retencion'] = $this->_aTotales['importe'] + $this->_aTotales['retenido'];
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
		$retval = TRUE;
	} else $retval = FALSE;
	$oDb->libera($id_rs);
	return $retval;
}

	/**
	  * Metodo encargado de obtenernos los datos de las cabeceras del pedido. Estas son , emisor , receptor, forma de pago, divisa
	  * y pedido para los pedidos de COMPRA. Este metodo es llamado por dbfill() para poblar estas estructuras.
	  * @param $id		-	Identificador del pedido del cual se desea poblar las cabeceras.
	  * @return bool	-	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_purchase_headders($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;

		$oDb = $this->_db;
		// Rellenamos las cabeceras del pedido:
		$cons = "SELECT Fra.id_factura as 'fra_id_factura', ".
				  "Fra.id_empresa as 'fra_id_empresa', ".
				  "Fra.id_proveedor as 'fra_id_proveedor', ".
				  "Fra.id_agente as 'fra_id_agente', ".
				  "Fra.id_divisa as 'fra_id_divisa', ".
				  "Fra.id_serie as 'fra_id_serie', ".
				  "Fra.factura_abono as 'fra_factura_abono', ".
				  "Fra.id_forma_pago as 'fra_id_forma_pago', ".
				  "Fra.referencia as 'fra_referencia', ".
				  "Fra.referencia_externa as 'fra_referencia_externa', ".
				  "Fra.notas as 'fra_observaciones', ".
				  "Fra.fecha as 'fra_fecha', ".
				  "Fra.id_dia as 'fra_id_dia', ".
				  "Fra.fecha_emision as 'fra_fecha_emision', ".
				  "Fra.id_dia_emision as 'fra_id_dia_emision', ".
				  "Fra.estado as 'fra_preparado', ".
				  "Fra.contabilizado as 'fra_contabilizado', ".
				  "Fra.id_asiento as 'fra_id_asiento', ".
				  "Fra.monto_prepago as 'tot_monto_prepago', ".
				  "Fra.monto_cuenta as 'tot_monto_cuenta', ".
				  "Fra.descuento as 'tot_descuentos', ".
				  "Fra.base_imponible as 'tot_base_imponible', ".
				  "Fra.total_impuestos as 'tot_total_impuestos', ".
				  "Fra.retenido as 'tot_retenido', ".
				  "Fra.monto_total as 'tot_importe', ".
				  "(Fra.monto_total-Fra.monto_cuenta) as 'tot_importe_pagar', ".
				  "Fra.total_bruto as 'tot_bruto', ".
				  "FPago.nombre as 'fra_nombre_forma_pago', ".
				  "FPago.nombre as 'fpa_nombre', ".
				  "FPago.id_forma_pago as 'fpa_id_forma_pago', ".
				  "FPago.num_efectos as 'fpa_num_efectos', ".
				  "FPago.dias_efectos as 'fpa_dias_efectos', ".
				  "FPago.medio_pago as 'fpa_medio_pago', ".
				  "EmpPrv.dia_facturacion_1 as 'fpa_dia_I', ".
				  "EmpPrv.dia_facturacion_2 as 'fpa_dia_II', ".
				  "EmpPrv.dia_facturacion_3 as 'fpa_dia_III', ".
				  "Emp.id_empresa as 'emp_id', ".
				  "Emp.id_empresa as 'emp_id_empresa', ".
				  "Emp.razon_social as 'emp_razon_social', ".
				  "Emp.capital_social as 'emp_capital_social', ".
				  "Emp.inscripcion_registro as 'emp_inscripcion_registro', ".
				  "Emp.nombre as 'emp_nombre', ".
				  "Emp.apellidos as 'emp_apellidos', ".
				  "Emp.direccion_facturacion as 'emp_direccion_facturacion', ".
				  "Emp.poblacion as 'emp_poblacion', ".
				  "Emp.cp as 'emp_cp', ".
				  "Emp.prefijo_cif as 'emp_prefijo_cif', ".
				  "Emp.cif as 'emp_cif', ".
				  "Emp.telefono1 as 'emp_telefono1', ".
				  "Emp.telefono2 as 'emp_telefono2', ".
				  "Emp.fax as 'emp_fax', ".
				  "Emp.email as 'emp_email', ".
				  "Emp.web as 'emp_web', ".
				  "Prov2.nombre as 'emp_provincia', ".
				  "EmpPrv.aplicar_iva as 'emp_aplicar_iva', ".
				  "EmpPrv.comunitario as 'emp_comunitario', ".
				  "EmpPrv.aplicar_recargo as 'emp_aplicar_recargo', ".
				  "EmpPrv.monto_cuenta as 'emp_monto_cuenta', ".
				  "EmpPrv.descuento as 'emp_dto_directo', ".
				  "EmpPrv.descuento_financiero as 'emp_dto_pronto_pago', ".
				  "EmpPrv.aplicar_retencion as 'emp_aplicar_retencion', ".
				  "EmpPrv.mantener_ratio_divisa as 'prv_ratio_divisa_dias', ".
				  "EmpPrv.cc_banco as 'emp_cc_banco', ".
				  "EmpPrv.cc_proveedor as 'prv_cc_proveedor', ".
				  "EmpPrv.cc_gastos as 'prv_cc_gastos', ".
				  "EmpPrv.cc_compras as 'prv_cc_compras', ".
				  "EmpPrv.cc_descuento_financiero as 'prv_cc_descuento_financiero', ".
				  "EmpPrv.cc_descuento_comercial as 'prv_cc_descuento_comercial', ".
				  "EmpPrv.cc_retenciones as 'prv_cc_retenciones', ".
				  "EmpPrv.cc_efectos as 'prv_cc_efectos', ".
				  "1 as 'emp_mostrar_ofertas', ".
				  "Div2.id_divisa as 'emp_id_divisa', ".
				  "Div2.nombre as 'emp_div_nombre_divisa', ".
				  "Div2.leyenda as 'emp_div_leyenda', ".
				  "Div2.nombre as 'emp_div_nombre', ".
				  "(1/Div.ratio) as 'emp_div_ratio', ".
				  "Prv.id_proveedor as 'prv_id', ".
				  "Prv.id_proveedor as 'prv_id_proveedor', ".
				  "Prv.razon_social as 'prv_razon_social', ".
				  "Prv.domicilio as 'prv_direccion_facturacion', ".
				  "Prv.cif as 'prv_cif', ".
				  "Prv.prefijo_cif as 'prv_prefijo_cif', ".
				  "Prv.cp as 'prv_cp', ".
				  "Prv.poblacion as 'prv_poblacion', ".
				  "Prov.nombre as 'prv_provincia', ".
				  "Prv.fax as 'prv_fax', ".
				  "Prv.telefono1 as 'prv_telefono1', ".
				  "Prv.web as 'prv_web', ".
				  "Prv.email as 'prv_email', ".
				  "Prv.retencion as 'prv_retencion', ".
				  "IF(Prv.dto_gnrl_vol_bulto,Prv.dto_gnrl_vol_bulto,NULL) as 'prv_dto_bulto', ".
				  "IF(Prv.dto_gnrl_vol_bulto,Prv.dto_gnrl_vol_bulto_uds,NULL) as 'prv_dto_bulto_uds', ".
				  "IF(Prv.dto_gnrl_vol_capa,Prv.dto_gnrl_vol_capa,NULL) as 'prv_dto_capa', ".
				  "IF(Prv.dto_gnrl_vol_capa,Prv.dto_gnrl_vol_capa_uds,NULL) as 'prv_dto_capa_uds', ".
				  "IF(Prv.dto_gnrl_vol_palet,Prv.dto_gnrl_vol_palet,NULL) as 'prv_dto_palet', ".
				  "IF(Prv.dto_gnrl_vol_palet,Prv.dto_gnrl_vol_palet_uds,NULL) as 'prv_dto_palet_uds', ".
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.ratio as 'div_ratio' ".
				  "FROM Facturas `Fra`, Empresas `Emp`, Proveedores_empresas `EmpPrv`, Forma_pago as `FPago`, ".
				  "Proveedores `Prv`, Divisa `Div`, Divisa `Div2`, Provincias `Prov`, Provincias `Prov2` ".
				  "WHERE Fra.id_factura = $id AND Prv.id_proveedor = Fra.id_proveedor AND ".
				  "FPago.id_forma_pago = Fra.id_forma_pago AND ".
				  "Prov2.id_provincia = Emp.id_provincia AND Prov.id_provincia = Prv.id_provincia AND ".
				  "Fra.id_empresa = EmpPrv.id_empresa AND EmpPrv.id_proveedor=Prv.id_proveedor AND ".
				  "Emp.id_divisa = Div2.id_divisa AND ".
				  "Prv.id_divisa = Div.id_divisa ";

		$id_rs = $oDb->query($cons);
		if ($oDb->num_rows($id_rs)) {
			  $aPedido = $oDb->fetch_assoc($id_rs);
			  foreach($aPedido as $clave => $valor) {
					$ref_arr = substr($clave,0,4);
					$ref_resto = substr($clave,4);
					// debug("parcial = $ref_arr, resto = $ref_resto");
					if (!strcasecmp($ref_arr,'fra_')) {
						$this->_aPedido[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'emp_')) {
						$this->_aReceptor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'prv_')) {
						$this->_aEmisor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'tar_')) {
						$this->_aTarifa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'div_')) {
						$this->_aDivisa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'fpa_')) {
						$this->_aFPago[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'tot_')) {
						$this->_aTotales[$ref_resto] = $valor;
					}
			  }
			  if (is_numeric($this->_aPedido['id_serie'])) {
				  $sercons = 'SELECT '.
					  				"Ser.contabilizable as 'id_serie_contabilizable', ".
									"Ser.nombre as 'nombre_serie_facturacion', Ser.id_serie_abonar as 'id_serie_abonar' ".
									'FROM Series_facturacion `Ser` WHERE Ser.id_serie = '.$this->_aPedido['id_serie'];
				  $serrs = $oDb->query($sercons);
				  if ($oDb->num_rows($serrs)) {
					  $aTmp = $oDb->fetch_assoc($serrs);
					  foreach ($aTmp as $clave => $valor) $this->_aPedido[$clave] = $valor;
					  $aTmp = NULL;
					  unset($aTmp);
				  }
			  }
			  $this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
			  $this->_aTotales['sin_retencion'] = $this->_aTotales['importe'] - $this->_aTotales['retenido'];
			  $this->_aReceptor['mostrar_ofertas'] = 0;
			  $this->_aReceptor['aplicar_dto_volumen'] = 1;
			  $retval = TRUE;
		} else $retval = FALSE;
		$oDb->libera($id_rs);

		return $retval;
	}

	/**
	  * Metodo encargado de obtener de la bbdd el escandallo (o lineas de detalle) del pedido en curso. Con su precio real (sin ser alterado 
	  * por la tarifa aplicada ). Este metodo es exclusivo de VENTAS.
	  * @param $id		-	Identificador del pedido del cual se desea poblar las cabeceras.
	  * @return bool	-	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_saleorder_details($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;
		if (!is_array($this->_aIDAlbaran)) $hay_albaranes = 0;
		else $hay_albaranes = sizeof($this->_aIDAlbaran);
		$leyenda_divisa = $this->_aDivisa['leyenda'];
		$campo_accion = $this->_aTarifa['campo_accion'];
		$campo_rec = $this->_aTarifa['campo_recomendacion'];
		$oDb = $this->_db;

		$cons = "SELECT Det.id_detalle as 'id_detalle', ".
					"Det.id_articulo as 'id_articulo', ".
					"Det.id_pedido as 'id_pedido', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					( ($hay_albaranes) 
						? "Det.cantidad - Det.cantidad_recibida as 'cantidad_residual', "
						: "" ).
					"FraDet.cantidad as 'cantidad', ".
					"Det.precio_articulo as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"Det.monto as 'monto', ".
					"FraDet.importe as 'base_imponible', ".
					// "Det.precio_articulo - (Det.precio_articulo * Det.descuento / 100) ".
					  // "- Det.monto as 'precio_tarifa_descuento', ".
					"IF ( (Det.descuento > 0 OR Det.monto > 0),".
					"IF(Det.descuento>0,CONCAT(Det.descuento,' %'),CONCAT(Det.monto,' $leyenda_divisa')) ".
					",NULL) as 'tipo_descuento', ".
					"IF ( (Det.descuento > 0 OR Det.monto > 0),".
						"IF(Det.descuento>0,".
							"Det.precio_articulo - (Det.precio_articulo * Det.descuento / 100),".
								"Det.precio_articulo - Det.monto) ".
						",NULL) as 'precio_tarifa_descuento', ".
					"FraDet.notas as 'observaciones', ".
					"FraDet.iextra1 as 'iextra1', ".
					"FraDet.iextra2 as 'iextra2', ".
					"FraDet.iextra3 as 'iextra3', ".
					"FraDet.iextra4 as 'iextra4', ".
					"Det.oextra1 as 'oextra1', ".
					"Det.oextra2 as 'oextra2', ".
					"Det.oextra3 as 'oextra3', ".
					"Det.oextra4 as 'oextra4', ".
					"Det.id_servicio as 'id_servicio', ".
					"Art.nombre as 'nombre', ".
					"Art.referencia as 'referencia', ".
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"GFam.nombre as 'nombre_grupo_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"Art.id_unidad_medida as 'id_unidad_medida', ".
					"Um.leyenda as 'leyenda_unidad_medida', ".
					"Art.mascara_modulo as 'mascara_modulo', ".
					"Cert.nombre as 'certificado', ".
					"Cert.id_certificado as 'certificado_id', ".
					"Det.cantidad as 'cantidad_pedida', ".
					"(FraDet.cantidad*Art.peso_unidad) as 'peso', ".
					( (!empty($campo_rec)) 
					  ?  "Empart.$campo_rec as 'PVP_rec', "
					  : '').
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					"SUM(La.cantidad) as 'stock_real', ".
					( ($this->_aPedido['id_factura'])
						? "Empart.$campo_accion as 'precio_real', "
						: "" ).
					"Empart.dto_vol as 'dto_volumen', ".
					"Empart.dto_vol_bultos as 'dto_volumen_bultos', ".
					"Empart.unidades_bulto as 'unidades_bulto', ".
					"Empart.bultos_capa_palet as 'bultos_capa_palet', ".
					"Empart.capas_palet as 'capas_palet', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente', ".
					"Iva.cc_imp_repercutido as 'iva_cc_impuestos', ".
					"Iva.cc_re_repercutido as 'iva_cc_recargos' ".
					"FROM Lineas_detalle `Det`, Articulos `Art` LEFT JOIN Localizacion_articulos La ON (Art.id_articulo=La.id_articulo) ".
					"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
					"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
					"Familia_articulos `Fam` LEFT JOIN Grupo_familias GFam ON (Fam.id_grupo_familia=GFam.id_grupo_familia), ".
					"Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Facturas `Fra`, Facturas_detalle `FraDet` ".
					"WHERE Fra.id_factura = $id AND Fra.id_factura = FraDet.id_factura AND FraDet.id_detalle = Det.id_detalle AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Fra.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"GROUP BY id_detalle ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		$this->_aIdxToAlb = array();
		if ($oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			$aPeds = array();
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				if (!empty($campo_rec)) $fila['PVP_rec'] = $this->_applyRevenue($fila['PVP_rec'],$fila['porcentaje']);
				if (is_numeric($fila['id_pedido'])) $aPeds[$fila['id_pedido']] += $fila['base_imponible'];
				if ($fila['monto']>0) $fila['tipo_descuento_fmt'] = Document::format_number($fila['descuento'],$this->tot_decimals,true)." $leyenda_divisa ";
				elseif ($fila['descuento']>0) 
					$fila['tipo_descuento_fmt'] = Document::format_number($fila['descuento'],$this->tot_decimals,true)." % ";
				$this->_aDetalles[$i] = $fila;

				$aAlb = $this->getDeliveryFromDbDet($fila['id_detalle']);
				if (sizeof($aAlb))
					foreach ($aAlb as $ida) {
						if (!is_array($this->_aIdxToAlb[$i])) $this->_aIdxToAlb[$i] = array();
						array_push($this->_aIdxToAlb[$i],$ida);
					}

				$this->indexFields($i);

				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}
			$this->_adjustOrders($aPeds,true);

			if (!is_numeric($this->_aTotales['bruto']) OR $this->_aTotales['bruto']==0)
				$this->_aTotales['bruto'] = $total_bruto;
			$this->_aPedido['peso'] = $total_peso;
		} else $retval = FALSE;

		return $retval;
	}

	/**
	  * Metodo encargado de obtener de la bbdd el escandallo (o lineas de detalle) del pedido en curso. Con su precio real (sin ser alterado 
	  * por la tarifa aplicada ). Este metodo es exclusivo de COMPRAS.
	  * @param $id		-	Identificador del pedido del cual se desea poblar las cabeceras.
	  * @return bool	-	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_purchaseorder_details($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;
		if (!is_array($this->_aIDAlbaran)) $hay_albaranes = 0;
		else $hay_albaranes = sizeof($this->_aIDAlbaran);
		$leyenda_divisa = $this->_aDivisa['leyenda'];
		$id_prv = $this->_aEmisor['id'];
		$oDb = $this->_db;

		$cons = "SELECT Det.id_detalle as 'id_detalle', ".
					"Det.id_articulo as 'id_articulo', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.id_pedido as 'id_pedido', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					( ($hay_albaranes) 
						? "Det.cantidad - Det.cantidad_recibida as 'cantidad_residual', "
						: "" ).
					"FraDet.cantidad as 'cantidad', ".
					"Det.precio_articulo as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"Det.monto as 'monto', ".
					"FraDet.importe as 'base_imponible', ".
					// "Det.precio_articulo - (Det.precio_articulo * Det.descuento / 100) ".
					  // "- Det.monto as 'precio_tarifa_descuento', ".
					"IF ( (Det.descuento > 0 OR Det.monto > 0),".
					"IF(Det.descuento>0,CONCAT(Det.descuento,' %'),CONCAT(Det.monto,' $leyenda_divisa')) ".
					",NULL) as 'tipo_descuento', ".
					"IF ( (Det.descuento > 0 OR Det.monto > 0),".
						"IF(Det.descuento>0,".
							"Det.precio_articulo - (Det.precio_articulo * Det.descuento / 100),".
								"Det.precio_articulo - Det.monto) ".
						",NULL) as 'precio_tarifa_descuento', ".
					"FraDet.notas as 'observaciones', ".
					"FraDet.iextra1 as 'iextra1', ".
					"FraDet.iextra2 as 'iextra2', ".
					"FraDet.iextra3 as 'iextra3', ".
					"FraDet.iextra4 as 'iextra4', ".
					"Det.oextra1 as 'oextra1', ".
					"Det.oextra2 as 'oextra2', ".
					"Det.oextra3 as 'oextra3', ".
					"Det.oextra4 as 'oextra4', ".
					"Det.id_servicio as 'id_servicio', ".
					"Art.nombre as 'nombre', ".
					"Art.referencia as 'referencia', ".
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"GFam.nombre as 'nombre_grupo_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"Art.id_unidad_medida as 'id_unidad_medida', ".
					"Um.leyenda as 'leyenda_unidad_medida', ".
					"Art.mascara_modulo as 'mascara_modulo', ".
					"Cert.nombre as 'certificado', ".
					"Cert.id_certificado as 'certificado_id', ".
					"Det.cantidad as 'cantidad_pedida', ".
					"(FraDet.cantidad*Art.peso_unidad) as 'peso', ".
					"Empart.unidades_bulto as 'unidades_bulto', ".
					"Empart.bultos_capa_palet as 'bultos_capa_palet', ".
					"Empart.capas_palet as 'capas_palet', ".
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					"SUM(La.cantidad) as 'stock_real', ".
					"CompArt.precio as 'precio_real', ".
					"CompArt.referencia as 'referencia_externa', ".
					"CompArt.dto_vol as 'dto_volumen', ".
					"CompArt.dto_vol_bultos as 'dto_volumen_bultos', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente', ".
					"Iva.cc_imp_soportado as 'iva_cc_impuestos', ".
					"Iva.cc_re_soportado as 'iva_cc_recargos' ".
					"FROM Lineas_detalle `Det`, Articulos `Art` LEFT JOIN Localizacion_articulos La ON (Art.id_articulo=La.id_articulo) ".
					"LEFT JOIN Unidades_medida Um ON (Um.id_unidad_medida=Art.id_unidad_medida) ".
					"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
					"Familia_articulos `Fam` LEFT JOIN Grupo_familias GFam ON (Fam.id_grupo_familia=GFam.id_grupo_familia), ".
					"Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Facturas_detalle `FraDet`, Facturas `Fra`, Compra_articulos `CompArt` ".
					"WHERE FraDet.id_factura = $id AND FraDet.id_detalle = Det.id_detalle AND CompArt.id_proveedor = $id_prv AND ".
					"CompArt.id_articulo = Det.id_articulo AND FraDet.id_factura = Fra.id_factura AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Fra.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"GROUP BY id_detalle ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		$this->_aIdxToAlb = array();
		if ($oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			$aPeds = array();
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				if (is_numeric($fila['id_pedido']))
					$aPeds[$fila['id_pedido']] += $fila['base_imponible'];
				if ($fila['monto']>0) $fila['tipo_descuento_fmt'] = Document::format_number($fila['descuento'],$this->tot_decimals,true)." $leyenda_divisa ";
				elseif ($fila['descuento']>0) 
					$fila['tipo_descuento_fmt'] = Document::format_number($fila['descuento'],$this->tot_decimals,true)." % ";
				$this->_aDetalles[$i] = $fila;

				$aAlb = $this->getDeliveryFromDbDet($fila['id_detalle']);
				if (sizeof($aAlb))
					foreach ($aAlb as $ida) {
						if (!is_array($this->_aIdxToAlb[$i])) $this->_aIdxToAlb[$i] = array();
						array_push($this->_aIdxToAlb[$i],$ida);
					}

				$this->indexFields($i);

				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}
			foreach ($aPeds as $idped => $base) {
				if (!empty($idped) AND !is_array($this->_aIDPedido[$idped])) {
					$this->_aIDPedido[$idped]['id_pedido'] = $idped;
					$this->_aIDPedido[$idped]['id_factura'] = $this->getId();
				}
				// Calculando la base imponible total facturada de este pedido.
				if (!is_numeric($this->_aIDPedido[$idped]['base_imponible'])) {
					$aDtos = $this->get_discounts();
					if (is_array($aDtos) AND is_array($aDtos['detalle'])) 
						foreach ($aDtos['detalle'] as $orden => $aDt) 
							if (is_numeric($aDt['descuento'])) 
								$base -= $base * $aDt['descuento'] / 100;
					if (is_numeric($base)) $this->_aIDPedido[$idped]['base_imponible'] = round($base,$this->tot_decimals);
				}
			}
			if (!is_numeric($this->_aTotales['bruto']) OR $this->_aTotales['bruto']==0)
				$this->_aTotales['bruto'] = $total_bruto;
			$this->_aPedido['peso'] = $total_peso;
		} else $retval = FALSE;

		return $retval;
	}

	function _adjustOrders($aPeds,$bClean = true) {
		if (is_array($aPeds) AND sizeof($aPeds))
			foreach ($aPeds as $idped => $base) {
				if (empty($idped)) continue;
				if (!empty($idped) AND !is_array($this->_aIDPedido[$idped])) {
					$this->_aIDPedido[$idped]['id_pedido'] = $idped;
					$this->_aIDPedido[$idped]['id_factura'] = $this->getId();
				} elseif ($bClean) $this->_aIDPedido[$idped]['base_imponible'] = NULL;
				// Calculando la base imponible total facturada de este pedido.
				if (!is_numeric($this->_aIDPedido[$idped]['base_imponible'])) {
					$aDtos = $this->get_discounts();
					if (is_array($aDtos) AND is_array($aDtos['detalle'])) 
						foreach ($aDtos['detalle'] as $orden => $aDt) 
							if (is_numeric($aDt['descuento'])) 
								$base -= $base * $aDt['descuento'] / 100;
					// debug("La base del pedido $idped = $base y la redondearemos a ".$this->tot_decimals);
					if (is_numeric($base)) $this->_aIDPedido[$idped]['base_imponible'] = round($base,$this->tot_decimals);
				}
			}
		return;
	}

	/****** Metodos Publicos:  ********/

	/**
	  * Metodo para Generar una nueva Factura (con su referencia) a partir de otra factura ya existente.
	  **/

	function duplicate() {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('INVOICE_LOCKED');
			return -1;
		}
		$this->setReference(0);
		$this->setDate(0);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_NEWRECORD);
	}

	function doChargeFromAccount() {
		debug("Cargando el monto _de la_ cuenta del cliente ... ");
		if ($this->getMode() & inmPed_VENTA) {
			$tabla = 'Clientes_empresas';
			$campo = 'id_cliente';
			$id = $this->get_reciever_id();
			$idemp = $this->get_issuer_id();
		} else {
			$tabla = 'Proveedores_empresas';
			$campo = 'id_proveedor';
			$idemp = $this->get_reciever_id();
			$id = $this->get_issuer_id();
		}
		$retval = true;
		$cons = 'SELECT monto_cuenta FROM '.$tabla.' WHERE '.$campo.' = '.$id.' AND id_empresa = '.$idemp.' AND monto_cuenta > 0 ';
		$rs = $this->_db->query($cons);
		if ($this->_db->num_rows($rs)) {
			$aTmp = $this->_db->fetch_row($rs);
			$cuenta = $aTmp[0];
			if ($cuenta > $this->get_totals('importe_pagar')) $cuenta = $this->get_totals('importe_pagar');
			if ($cuenta > 0) {
				$this->_bActualizarCuenta = true;
				$this->_ImporteCuenta = $cuenta * -1;
				$this->set_total('monto_cuenta',$cuenta);
				$this->_db->libera($rs);
				$this->dbDump();
			} else $this->_db->libera($rs);
		} else {
			$retval = false;
			$this->_db->libera($rs);
		}
		return $retval;
	}

	function doChargeToAccount() {
		debug("Cargando el monto a cuenta del cliente ... ");
		$cuenta = $this->get_totals('monto_cuenta');
		if (empty($cuenta)) return false;

		if ($this->getMode() & inmPed_VENTA) {
			$tabla = 'Clientes_empresas';
			$campo = 'id_cliente';
			$id = $this->get_reciever_id();
			$idemp = $this->get_issuer_id();
		} else {
			$tabla = 'Proveedores_empresas';
			$campo = 'id_proveedor';
			$idemp = $this->get_reciever_id();
			$id = $this->get_issuer_id();
		}
		$retval = true;

		$this->_bActualizarCuenta = true;
		$this->_ImporteCuenta = $this->get_totals('monto_cuenta');
		$this->set_total('monto_cuenta',0);
		$this->dbDump();

		return $retval;
	}

	function _updateClientAccount($importe = NULL) {
		if (empty($importe) OR !is_numeric($importe) AND $this->_bActualizarCuenta) {
			$importe = $this->_ImporteCuenta;
			$this->_ImporteCuenta = 0;
		}
		if ($this->debug) debug("_updateClientAccount($importe)");
		if ($this->_bActualizarCuenta AND !empty($importe) AND is_numeric($importe)) {
			if ($this->getMode() & inmPed_VENTA) {
				$tabla = 'Clientes_empresas';
				$campo = 'id_cliente';
				$id = $this->get_reciever_id();
				$idemp = $this->get_issuer_id();
			} else {
				$tabla = 'Proveedores_empresas';
				$campo = 'id_proveedor';
				$idemp = $this->get_reciever_id();
				$id = $this->get_issuer_id();
			}

			$cons = 'UPDATE '.$tabla.' SET monto_cuenta = monto_cuenta + '.$importe.' WHERE '.$campo.' = '.$id.' AND id_empresa = '.$idemp;
			$this->_db->query($cons);
			$this->_aReceptor['monto_cuenta'] += $importe;

			$this->_bActualizarCuenta = false;
		}
	}


	function setIssued($preparado = NULL) {
		// Cuando Emitimos la Factura, marcar para que, al volcar a la bbdd, se haga el link con iConta
		if (!$preparado) $preparado = 1;

		if (!(int)$this->getIssued() AND (int)$preparado) {
			if (is_array($this->_aServicio_DetIdx) AND sizeof($this->_aServicio_DetIdx)) 
				foreach ($this->_aServicio_DetIdx as $id_servicio => $aIDx) {
					if (!is_array($aIDx) OR !sizeof($aIDx)) continue;
					foreach ($aIDx as $tmpidx) {
						$cant = $this->get_quantity($tmpidx);
						if (is_numeric($cant) AND $cant == 0) {
							$this->error('INVOICE_PENDING_CONTRACT',array('ref' => $this->getReference()));
							return false;
						}
					}
				}
		
			$ref = $this->getReference();
			if (empty($ref)) $this->setReference();
			if (!$this->getId()) $this->dbDump();

			$this->_aPedido['preparado'] = $preparado;
			if (!$this->doEffects()) {
				// echo "NO Se han generado bien los efectos";
				debug("NO se han generabo bien los efectos. ");
				$this->_aPedido['preparado'] = 0;
				return false;
			}
			$this->_bActualizarCuenta = true;
			// debug("<b>preparado</b> :".$this->_aPedido['preparado']);
			$this->_change_flags(inmPed_CHG_MAIN | (inmPed_LOCKED | inmPed_DB_COMMIT));

			$this->doAgentCommissions();
			$this->linkIConta();
		}
		return true;
	}

	function setUnIssued() {
		// Cuando Emitimos la Factura, marcar para que, al volcar a la bbdd, se haga el link con iConta
		$preparado = 0;

		if ((int)$this->getIssued()) {
			$unissu = true;
			$aCfg = $this->getFromCfg();
			if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $this->_oSesion->get_var('_aAppConf');
			$aoEfectos = array();
			$nume = 0;
			if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) {
				foreach ($this->_aEfectos as $idx => $aEff) 
					if (is_array($aEff)) {
						if ($aEff['id_factura']==$this->getId() AND ((int)$aEff['pagado'] OR $aEff['monto_pagado']>0) ) {
							$unissu = false;
							break;
						} else {
							$importe_efectos += $aEff['monto'];
						}
					} elseif (is_a($aEff,'Draft')) {
						if ($this->_aEfectos[$idx]->getAmmount('paid') > 0 AND $this->getId()==$this->_aEfectos[$idx]->getAttribute('id_factura')) {
							$unissu = false;
							break;
						}
						$this->_aEfectos[$idx]->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],
														$aCfg['iconta_diario'],$aCfg['iconta_canal']);

						if ($this->getInstallment()) {
							$oParciales = &$this->_aEfectos[$idx]->getPartialDrafts();
							$aItms = $oParciales->getFromIndex('id_factura_abono',$this->getId());
							if (is_array($aItms) AND sizeof($aItms)) {
								foreach ($aItms as $i) {
									$oI = &$oParciales->getItem($i);
									if (!$oI->delete(true)) {
										$unissu = false;
										break;
									}
									$importe_efectos += abs($oI->getAmmount('paid'));
									unset($oI);
								}
								if (!$unissu) break;
							} else {
								$importe_efectos += abs($this->_aEfectos[$idx]->getAmmount('total'));
							}
							unset($oParciales);
						} else {
							$importe_efectos += abs($this->_aEfectos[$idx]->getAmmount('total'));
						}
					}
			}
				
			if ($unissu) {
				if ($this->getInstallment()) {
					$monto_cuenta = $this->get_totals('importe_pagar') - $importe_efectos;
					if($this->debug) 
						debug("Devolviendo a cuenta $monto_cuenta con un importe de efectos = $importe_efectos cuando a pagar: ".$this->get_totals('importe_pagar'));
					if ($monto_cuenta > 0) {
						$this->_ImporteCuenta  = ($monto_cuenta * -1);
						$this->_bImporteCuenta = true;
					}
				}

				$this->_aPedido['preparado'] = 0;
				$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
				$this->_change_flags(IEInvoice_EFFECTS | inmPed_DB_DELETE | inmPed_DB_COMMIT);
				$this->_change_flags(IEInvoice_COMMISSIONS | inmPed_DB_DELETE | inmPed_DB_COMMIT);
				$this->linkIConta(false);
				$this->_bActualizarCuenta = true;
			} else {
				$this->error('INVOICE_ISSUED_DRAFTS');
				return false;
			}
		}
		return true;
	}

	function getIssued() {
		// Comprobar si la factura esta emitida o no.
		return $this->getStatus();
	}

	function getEffects() {
		return $this->_aEfectos;
	}

	function doEffects() {
		// Generar los Efectos de una Factura, caso de que no esten generados, o hayan cambiado los importes
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('INVOICE_LOCKED');
			return FALSE;
		}

		$bDoIt = true;

		$aCfg = $this->getFromCfg();
		if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $this->_oSesion->get_var('_aAppConf');
		// Si estamos en una factura de abono... Antes de naga comprobamos como se van a gestionar los pagos.
		if ($this->getInstallment()) {
			$monto_apagar = $this->get_totals('importe');
			if ($this->getInstallment() == $this->INSTALLMENT_EFFECTS_ACCOUNT OR
					$this->getInstallment() == $this->INSTALLMENT_EFFECTS_MATTERS ) {
				if ($this->getMode() & inmPed_VENTA) $id_cli = $this->get_reciever_id();
				else $id_prov = $this->get_issuer_id();

				$cons = 'SELECT E.id_efecto,E.monto-E.monto_pagado as "pendiente" '.
							'FROM Efectos E LEFT JOIN Facturas F ON (E.id_factura=F.id_factura) '.
							'WHERE F.factura_abono = 0 '.
							( (is_numeric($id_cli)) 
							  ? 'AND pago_cobro = 1 AND F.id_cliente = '.$id_cli
							  : 'AND pago_cobro = 0 AND F.id_proveedor = '.$id_prov
							).' AND E.monto_pagado < E.monto '.
							'ORDER BY E.fecha_vencimiento asc ';
				$rs = $this->_db->query($cons);
				if ($this->_db->num_rows($rs)) {
					$aoEfectos = array();
					$nume = 0;
					while ($aTmp = $this->_db->fetch_assoc($rs)) {
						$aoEfectos[$nume] = new Draft ($this->_oSesion->App_Name,$this->_db_name);
						if ($aoEfectos[$nume]->dbFill($aTmp['id_efecto'])) {
							$aoEfectos[$nume]->debug = $this->debug;
							$aoEfectos[$nume]->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],
														$aCfg['iconta_diario'],$aCfg['iconta_canal']);
							$oParciales = &$aoEfectos[$nume]->getPartialDrafts();

							$aPay['id_factura_abono'] = $this->getId();
							$epend = $aoEfectos[$nume]->getAmmount('pending');
							debug("pendiente efecto existente $epend cuando apagar: $monto_apagar y su asiento es: ".$aoEfectos[$nume]->getAttribute('id_asiento') );
							if ($epend > $monto_apagar) {
								$aPay['monto_satisfecho'] = $monto_apagar;
								$monto_apagar = 0;
								$idx = $oParciales->insert($aPay);
								$oI = &$oParciales->getItem($idx);
								// $oI->dontAccount();
								unset($oParciales);
								unset($oI);
								break;
							} else {
								$aPay['monto_satisfecho'] = $epend;
								$monto_apagar -= $epend;
								$idx = $oParciales->insert($aPay);
								$oI = &$oParciales->getItem($idx);
								// $oI->dontAccount();
								unset($oParciales);
								unset($oI);
							}
							$nume++;
						}
					}
				} 
				$this->_db->libera($rs);
				// $this->set_total('monto_cuenta');
			}

			if ($this->getInstallment() == $this->INSTALLMENT_EFFECTS_ACCOUNT OR 
					$this->getInstallment() == $this->INSTALLMENT_ACCOUNT) {
				if ($this->debug) debug("Invoice::Sumando $monto_apagar en la _cuenta_ del cliente, que ahora tiene: ".$this->_ImporteCuenta);
				if (empty($this->_ImporteCuenta)) {
					$this->_bActualizarCuenta = true;
					$this->_ImporteCuenta = $monto_apagar;
					$monto_apagar = 0;
				} else $this->setInstallment($this->INSTALLMENT_EFFECTS_MATTERS);
			}

			if (!$monto_apagar) $bDoIt = false;
		} else {
			$monto_apagar = $this->get_totals('importe_pagar');
			if ($this->debug) debug("Invoice:: Factura Norma, con monto a pagar : ".$monto_apagar." habiendo a cuenta. ".$this->_aTotales['monto_cuenta']);
			$bDoIt = true;
		}

		if ($this->debug) debug($bDoIt." tipo de abono: ".$this->getInstallment());
		
		if ($bDoIt AND is_array($this->_aFPago)) {
			if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) {
				foreach ($this->_aEfectos as $i => $E) {
					if (is_array($E) AND $E['id_factura'] != $this->getId()) {
						debug("Vamos a generar efectos con esto metido: ");
						print_r($E);
					}
				}
			}
			$monto = $monto_apagar / $this->_aFPago['num_efectos'];
			if ($this->debug) debug("Invoice:: Generando ".$this->_aFPago['num_efectos']." efectos por un valor individual de : $monto ");
			// Si se generan en efectos en una fra de abono, seran en negativo.
			if ($this->getInstallment()) {
				$monto *= -1;
			}

			$ffra = $this->getDate();
			if (!empty($ffra)) $tfra = strtotime(wol_db::formatear_fecha($ffra,false));
			else $tfra = time(NULL);
			$dias = array();
			if (!empty($this->_aFPago['dia_I'])) $dias[] = $this->_aFPago['dia_I'];
			if (!empty($this->_aFPago['dia_II'])) $dias[] = $this->_aFPago['dia_II'];
			if (!empty($this->_aFPago['dia_III'])) $dias[] = $this->_aFPago['dia_III'];
			sort($dias,SORT_NUMERIC);
			$this->_aEfectos = array();

			$aFra['id_factura'] = $this->getId();
			if ($this->getMode() & inmPed_VENTA) $aFra['id_cliente'] = $this->get_reciever_id();
			else $aFra['id_proveedor'] = $this->get_issuer_id();
			$aFra['id_factura'] = $this->getId();
			$aFra['fecha'] = $this->getDate();
			$aFra['referencia'] = $this->getReference();
			$aFra['referencia_externa'] = $this->getReference('extern');
			$aFra['estado'] = $this->getStatus();
			$aFra['factura_abono'] = $this->getInstallment();
			$aFra['id_factura_abono'] = $this->getHeaderAttribute('id_factura_abono');
			$aFra['id_serie'] = $this->getHeaderAttribute('id_serie');
			$aFra['base_imponible'] = $this->get_totals('base_imponible');
			$aFra['notas'] = $this->getHeaderAttribute('observaciones');


			for ($i = 1; $i <= $this->_aFPago['num_efectos']; $i++) {
				$en_dias = $i * $this->_aFPago['dias_efectos'];
				if (!is_array($dias) OR empty($dias) OR !sizeof($dias)) {
					$fecha_est = strtotime("+$en_dias day",$tfra);
					$str_fecha = strftime("%Y-%m-%d %H:%M",$fecha_est);
				} else {
					$fecha_est = strtotime("+$en_dias day",$tfra);
					$dia_est = strftime("%d",$fecha_est);
					$last = end($dias);
					reset($dias);
					if ($dia_est > $last) {
						$fecha_final = strtotime("+1 month",$fecha_est);
						$next_day = $dias[0];
						$fecha_final = strtotime("-".($dia_est-$next_day)." day",$fecha_final);
					} else {
						if (!$next_day) $next_day = $dia_est;
						foreach ($dias as $dia) {
							if ($next_day < $dia) {
								$next_day = $dia;
								break;
							} else continue;
						}
						$fecha_final = strtotime("+".($next_day-$dia_est)." day",$fecha_est);
					}
					$str_fecha = strftime("%Y-%m-%d %H:%M",$fecha_final);
				}
				if ($this->getId()) {
					$aEff['id_factura'] = $this->getId();
					$ref_ext = $this->getReference('extern');
					$aEff['concepto'] = 'Su Fra Nº '.$this->getReference().( (!empty($ref_ext)) ? ' ['.$ref_ext.']' : '' );
				}
				if ($this->getMode() & inmPed_VENTA) $aEff['pago_cobro'] = 1;
				else $aEff['pago_cobro'] = 0;

				// Si es una factura de abono (monto < 0), se invierte el tipo de efecto
				if ($monto < 0) {
					$aEff['pago_cobro'] = (int)!$aEff['pago_cobro'];
					$monto *= -1;
				}

				$aEff['emitido'] = 1;
				$aEff['fecha_vencimiento'] = $str_fecha;
				$aEff['monto'] = $monto;
				$aEff['medio_pago'] = $this->_aFPago['medio_pago'];

				$oEfecto = new Draft($this->_oSesion->App_Name,$this->_db_name);
				$oEfecto->debug = $this->debug;
				$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],
																	$aCfg['iconta_diario'],$aCfg['iconta_canal']);
				$oEfecto->update($aEff);
				$oEfecto->update($aFra,'Factura');
				// array_push($this->_aEfectos,&$oEfecto);
				$this->_aEfectos[] = &$oEfecto;
				unset($oEfecto);
			}
			$this->_change_flags(IEInvoice_EFFECTS | inmPed_DB_COMMIT);
		}

		if (is_array($aoEfectos) AND sizeof($aoEfectos)) {
			if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) $idx = array_pop(array_keys($this->_aEfectos));
			else $idx = 0;
			foreach (array_keys($aoEfectos) as $i ) {
				$this->_aEfectos[++$idx] = &$aoEfectos[$i];
			}
			$this->_change_flags(IEInvoice_EFFECTS | inmPed_DB_COMMIT);
		}
		return true;
	}

	function doAgentCommissions() {

		debug("Invoice::doAgentCommissions() ");
		$this->_aAgentes_comisiones = array();

		// No hay comisiones en compra.
		if ($this->getMode() & inmPed_COMPRA) return true;

		/** Si el cliente no tiene agentes, tomamos como base (para comisionado repartido) el agente por defecto. **/
		if (!is_array($this->_aAgentes_cliente) OR !sizeof($this->_aAgentes_cliente)) $this->addAgent(0);

		if ($this->debug) {
			debug("Agentes del cliente: ");
			print_r($this->_aAgentes_cliente);
		}

		if ($this->getInstallment() AND is_array($this->_aAgentes_cliente) AND sizeof($this->_aAgentes_cliente)) {
			foreach ($this->_aAgentes_cliente as $aAg) $str_where .= ( (!empty($str_where)) ? ' AND ' : '').'A.id_agente = '.$aAg['id_agente'];
			$cons = 'SELECT A.id_agente,A.nombre,A.apellidos,A.comision_repartida,A.comision_base, '.
						'ROUND(( (SUM(FA.monto)*100)/SUM(F.base_imponible)),2) as "comisionado" '.
						'FROM Agentes A LEFT JOIN Agentes_facturas FA ON (A.id_agente=FA.id_agente) '.
						'LEFT JOIN Facturas F ON (FA.id_factura=F.id_factura) '.
						'LEFT JOIN Facturas_abonos Fb ON (Fb.id_factura=F.id_factura) '.
						'WHERE Fb.id_factura_abono = '.$this->getId().
						' AND FA.monto>0 '.
						' GROUP BY A.id_agente ';
			$tmprs = $this->_db->query($cons);
			if ($this->_db->num_rows($tmprs)) {
				while ($aTmp = $this->_db->fetch_assoc($tmprs)) {
					if (!is_array($this->_aAgentes_comisiones[$aTmp['id_agente']])) $this->addAgent($aTmp['id_agente']);
					// Si es una factura de abono, los importes se vuelcan en negativo.
					$this->_aAgentes_comisiones[$aTmp['id_agente']]['comision'] = $aTmp['comisionado'];
					$this->_aAgentes_comisiones[$aTmp['id_agente']]['comision_repartida'] = 0;
				}
			} else {
				foreach ($this->_aAgentes_cliente as $idx => $aAg) $this->_aAgentes_cliente[$idx]['comision'] = 0;
			}
			$pto_reparto = 0;
		} else {
			/** Averiguamos cual es pto total que reparten los agentes de este cliente **/
			if (is_array($this->_aAgentes_cliente) AND sizeof($this->_aAgentes_cliente))
				foreach ($this->_aAgentes_cliente as $idag => $aAg) {
					if (!is_array($this->_aAgentes_comisiones[$idag])) $this->addAgent($idag);
					$pto_reparto += abs($aAg['comision_repartida']);
				}
		}

		$aTot = $this->get_totals();
		$base_imponible = $aTot['base_imponible'];
		$base_repartida = 0;

		/** Primero asignamos la comision que reparten los agentes 'nativos' del cliente 
		  *	(el pto total averiguado antes), y a los agentes de cada pedido les metemos de comision dicho pto
		  *	sobre la base del pedido que hayan realizado.
		  **/
		if (is_numeric($pto_reparto) AND $pto_reparto!=0) {
			if (is_array($this->_aIDPedido) AND sizeof($this->_aIDPedido)) {
				foreach ($this->_aIDPedido as $idped => $aPed) {
					if (is_numeric($aPed['id_agente']) AND is_numeric($aPed['base_imponible'])) {
						if (!is_array($this->_aAgentes_comisiones[$aPed['id_agente']])) $this->addAgent($aPed['id_agente']);
						$comision = $aPed['base_imponible'] * $pto_reparto / 100;
						$base_repartida += $aPed['base_imponible'];
						$this->_aAgentes_comisiones[$aPed['id_agente']]['importe_comision'] += $comision;
						if ($this->debug)
							debug($this->_aAgentes_comisiones[$aPed['id_agente']]['nombre'].' ha hecho el pedido '.$aPed['referencia'].' de '.
											$aPed['base_imponible'].' con '.$pto_reparto.'% de comision repartida, y se le sumaran '.$comision);
					}
				}
			}
			$aAg = $this->getAgent();
			if (is_array($aAg) AND sizeof($aAg) AND ( abs($base_imponible - $base_repartida) > 0) ) {
				if (is_numeric($aAg['id_agente']) AND is_numeric($base_imponible)) {
					if (!is_array($this->_aAgentes_comisiones[$aAg['id_agente']])) $this->addAgent($aAg['id_agente']);
					$comision = ($base_imponible - $base_repartida) * $pto_reparto / 100;
					$base_repartida += ($base_imponible - $base_repartida);
					$this->_aAgentes_comisiones[$aAg['id_agente']]['importe_comision'] += $comision;
				}
			}
		}

		$base_repartida = round($base_repartida,$this->tot_decimals);
		$pto_reparto = NULL;
		if (is_array($this->_aAgentes_comisiones) AND sizeof($this->_aAgentes_comisiones))
			foreach ($this->_aAgentes_comisiones as $idag => $aAg) {
				$pto_comision = abs($this->_aAgentes_comisiones[$idag]['comision']);
				$pto_reparto = $this->_aAgentes_comisiones[$idag]['comision_repartida'];
				if (!empty($base_repartida)) $mto_reparto = $base_repartida * abs($pto_reparto) / 100;
				else $mto_reparto = 0;
				if (!empty($base_imponible)) $mto_comision = $base_imponible * abs($pto_comision) / 100;
				else $mto_comision = 0;

				if ($this->debug) debug($aAg['nombre']." ya repartio $pto_reparto ($mto_reparto) sobre $base_repartida de su $pto_comision %");
				if (($base_imponible - $base_repartida) > 0) {
					if ($this->debug) debug($aAg['nombre']." Tiene $pto_comision % sobre ".($base_imponible - $base_repartida) );
					$this->_aAgentes_comisiones[$idag]['importe_comision'] += ($base_imponible - $base_repartida) * $pto_comision / 100;
				}
				if ($pto_reparto < 0) {
					if ($this->debug) debug($aAg['nombre']." Tambien tiene ".($pto_comision+$pto_reparto)." % sobre ".$base_repartida );
					$this->_aAgentes_comisiones[$idag]['importe_comision'] += ($base_repartida) * ($pto_comision+$pto_reparto) / 100;
				} else {
					if ($this->debug) debug($aAg['nombre']." Ademas tiene ".($pto_comision)." % sobre ".$base_repartida );
					$this->_aAgentes_comisiones[$idag]['importe_comision'] += $base_repartida * $pto_comision / 100;
				}
			}

		if (is_array($this->_aAgentes_comisiones) AND sizeof($this->_aAgentes_comisiones)) {
			if ($this->getInstallment()) {
				foreach ($this->_aAgentes_comisiones as $idag => $aAg) $this->_aAgentes_comisiones[$idag]['importe_comision'] *=-1;
			}

			if ($this->debug) {
				debug("Invoice::doAgentCommissions() - Las comisiones han cambiado:");
				print_r($this->_aAgentes_comisiones);
			}
			$this->_change_flags(IEInvoice_COMMISSIONS | (inmPed_MODIFIED | inmPed_DB_COMMIT));
		}

	}

	function linkIConta($bLink = true,$bForce = false) {
		// A traves de una instancia Entry, volcar los datos a Contabilidad.
		if (!$this->getId()) {
			$this->error('INVOICE_NODBRECORD_NOACENTRY');
			return FALSE;
		}
		if (!isset($bLink)) $bLink = true;
			
		$icontadb = $this->getFromCfg('iconta_dbname');
		$icontacfgdb = $this->getFromCfg('iconta_dbcfgname');
		$id_ejercicio = $this->getFromCfg('iconta_ejercicio');
		if (empty($icontadb) OR empty($icontacfgdb) OR empty($id_ejercicio)) {
			debug("No hay conectores, asi que tampoco volcado as IConta. ");
			$bLink = false;
		}

		if ($this->debug) debug("Lincando con Contabilidad esta Factura... (".$bLink.') conta('.$this->_aPedido['id_serie_contabilizable'].')');
		if ((int)$this->_aPedido['id_serie_contabilizable'] AND $bLink) {
			if ($this->debug) debug("conestando a $icontadb - $icontacfgdb en una que...(".$this->_aPedido['contabilizado'].") ");
			if ( (!(int)$this->_aPedido['contabilizado'] OR $bForce) AND !empty($icontadb) AND !empty($icontacfgdb)) {
				if ($this->debug) debug("Creando instancia Asiento .. ($icontadb) ($icontacfgdb)");
				if ($this->getMode() & inmPed_VENTA) 
					$oAsiento = new AccountEntry($this->App_Name,$icontadb,$icontacfgdb,ICEntry_MODE_SALE | ICEntry_MODE_CHECK_TAX,$id_ejercicio);
				else 
					$oAsiento = new AccountEntry($this->App_Name,$icontadb,$icontacfgdb,ICEntry_MODE_BUY | ICEntry_MODE_CHECK_TAX,$id_ejercicio);
				if (!is_object($oAsiento)) {
					debug("no se ha podido crear el asiento maxo ");
					$this->error('INVOICE_ACENTRY_FAILED');
					return FALSE;
				} else $oAsiento->debug = $this->debug;

				$gccClientes = $oAsiento->getCfg('cc_clientes');
				$gccVentas = $oAsiento->getCfg('cc_ventas');
				$gccAVentas = $oAsiento->getCfg('grp_abonosventas');
				$gccDPPVentas = $oAsiento->getCfg('grp_ppventas');
				$gccHaciendaCta = $oAsiento->getCfg('cc_hacienda_pagocta');
				$gccEfectosCliente = $oAsiento->getCfg('cc_efectos_cliente');
				$gccProveedores = $oAsiento->getCfg('cc_proveedores');
				$gccCompras = $oAsiento->getCfg('cc_compras');
				$gccACompras = $oAsiento->getCfg('grp_abonoscompras');
				$gccDPPCompras = $oAsiento->getCfg('grp_ppcompras');
				$gccRetenciones = $oAsiento->getCfg('cc_retenciones');
				$gccEfectosProveedor = $oAsiento->getCfg('cc_efectos_proveedor');
				if ($this->debug)
					debug("CuentasGenerales: ".
							'['.$gccClientes.'] '.
							'['.$gccVentas.'] '.
							'['.$gccAVentas.'] '.
							'['.$gccDPPVentas.'] '.
							'['.$gccHaciendaCta.'] '.
							'['.$gccEfectosCliente.'] '.
							'['.$gccProveedores.'] '.
							'['.$gccCompras.'] '.
							'['.$gccACompras.'] '.
							'['.$gccDPPCompras.'] '.
							'['.$gccRetenciones.'] '.
							'['.$gccEfectosProveedor.'] '.
							'');
				if (empty($gccClientes) OR empty($gccVentas) OR empty($gccHaciendaCta) OR empty($gccEfectosCliente) OR
						empty($gccProveedores) OR empty($gccCompras) OR empty($gccRetenciones) OR empty($gccEfectosProveedor) ) {
					debug("AccountEntry no esta configurado .. ");
					$this->error('ACCOUNTENTRY_NOT_CONFIGURED');
					return false;
				}
							
				$aD['id'] = $this->getFromCfg('iconta_diario');
				$aD['canal'] = $this->getFromCfg('iconta_diario');
				if (is_numeric($aD['id'])) {
					$oAsiento->addDiary($aD['id'],$aD['canal']);
				}

				$aTot = $this->get_totals();

				// Comprobaciones de las cuentas contalbes
				if ( ($this->getMode() & inmPed_VENTA) ) {
					$aRec = $this->get_reciever_info();
					$ladoFra = ICEntry_MOVE_HAVE;
					$ladoEntidad = ICEntry_MOVE_MUST;
					$conceptoBase = $aRec['razon_social'].' ('.$aRec['cif'].') ';

					$cc = $aRec['cc_cliente'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccClientes,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['entidad'] = $cc;
					} else $aCCs['entidad'] = $gccClientes;
					$oAsiento->dbFetchAccount($aCCs['entidad'],true,$conceptoBase);

					$cc = $aRec['cc_ventas'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccVentas,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['bases'] = $cc;
					} else $aCCs['bases'] = $gccVentas;
					$oAsiento->dbFetchAccount($aCCs['bases'],true,$conceptoBase);

					$cc = $aRec['cc_retenciones'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccHaciendaCta,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						if ($aTmp[0] != $aTmp2[0]) $aCCs['retenciones'] = $gccHaciendaCta;
						else $aCCs['retenciones'] = $cc;
					} else $aCCs['retenciones'] = $gccHaciendaCta;
					$oAsiento->dbFetchAccount($aCCs['retenciones'],true,$conceptoBase);

					$cc = $aRec['cc_efectos'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccEfectosCliente,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['efectos'] = $cc;
					} else $aCCs['efectos'] = $gccEfectosCliente;
					$oAsiento->dbFetchAccount($aCCs['efectos'],true,$conceptoBase);

					$cc = $aRec['cc_descuento_financiero'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccDPPVentas,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['dto_financiero'] = $cc;
					} else $aCCs['dto_financiero'] = $gccDPPVentas;
					$oAsiento->dbFetchAccount($aCCs['dto_financiero'],true,$conceptoBase);

				} else {
					$aTrueRec = $this->get_reciever_info();
					$aRec = $this->get_issuer_info();
					$aRec['aplicar_retencion'] = $aTrueRec['aplicar_retencion'];
					$aRec['aplicar_iva'] = $aTrueRec['aplicar_iva'];
					$aRec['aplicar_recargo'] = $aTrueRec['aplicar_recargo'];
					$aRec['comunitario'] = $aTrueRec['comunitario'];
					$ladoFra = ICEntry_MOVE_MUST;
					$ladoEntidad = ICEntry_MOVE_HAVE;
					$conceptoBase = $aRec['razon_social'].' ('.$aRec['cif'].') ';

					$cc = $aRec['cc_proveedor'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccProveedores,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['entidad'] = $cc;
					} else $aCCs['entidad'] = $gccProveedores;
					$oAsiento->dbFetchAccount($aCCs['entidad'],true,$conceptoBase);

					$cc = $aRec['cc_compras'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccCompras,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['bases'] = $cc;
					} else $aCCs['bases'] = $gccCompras;
					$oAsiento->dbFetchAccount($aCCs['bases'],true,$conceptoBase);

					$cc = $aRec['cc_retenciones'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccRetenciones,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						if ($aTmp[0] != $aTmp2[0]) $aCCs['retenciones'] = $gccRetenciones;
						else $aCCs['retenciones'] = $cc;
					} else $aCCs['retenciones'] = $gccRetenciones;
					$oAsiento->dbFetchAccount($aCCs['retenciones'],true,$conceptoBase);

					$cc = $aRec['cc_efectos'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccEfectosProveedor,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['efectos'] = $cc;
					} else $aCCs['efectos'] = $gccEfectosProveedor;
					$oAsiento->dbFetchAccount($aCCs['efectos'],true,$conceptoBase);

					$cc = $aRec['cc_descuento_financiero'];
					if (!empty($cc)) {
						$aTmp = $oAsiento->filterAccount($cc,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aTmp2 = $oAsiento->filterAccount($gccDPPCompras,NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
						$aCCs['dto_financiero'] = $cc;
					} else $aCCs['dto_financiero'] = $gccDPPCompras;
					$oAsiento->dbFetchAccount($aCCs['dto_financiero'],true,$conceptoBase);
				}

				if ($this->getInstallment()) {
					$tmpcc = $ladoFra;
					$ladoFra = $ladoEntidad;
					$ladoEntidad = $tmpcc;

					$aTmp = $oAsiento->filterAccount($aCCs['bases'],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
					if ($this->getMode() & inmPed_VENTA) {
						if (!empty($gccAVentas)) {
							$ccbase = $oAsiento->filterAccount($gccAVentas,$aTmp[1], ICEntry_FILTER_EXTENDED);
						}
					} else {
						if (!empty($gccAVentas)) {
							$ccbase = $oAsiento->filterAccount($gccAVentas,$aTmp[1], ICEntry_FILTER_EXTENDED);
						}
					}
					if (!empty($ccbase)) {
						debug("Tenemos base en $ccbase con $conceptoBase - la deberia crear");
						$aCCs['bases'] = $ccbase;
						$oAsiento->dbFetchAccount($aCCs['bases'],true,$conceptoBase);
					}

				}

				if ($this->debug) debug("Cuentas !");
				if ($this->debug) print_r($aCCs);
				if ($this->debug) print_r($aTot);

				$conceptoGrl = ' Fra '.$this->getReference()." (".$this->getDate().") ";
				$ref_ext = $this->getReference('extern');
				if (!empty($ref_ext)) $conceptoGrl .= '['.$ref_ext.'] ';
				$conceptoHCta = ' IRPF '.$conceptoGrl;

				// Metemos la ContraPArtida de Los IVAs (cta cliente/proveedor) Y su RETENCION.
				if ((int)$aRec['aplicar_retencion'] AND !empty($aTot['retenido'])) {
					if (abs($aTot['retenido']) > 0) {
						if ($this->debug)
							debug((($ladoEntidad & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
									' a la '.$aCCs['retenciones'].' Importe retencion: '.$aTot['retenido']);
						$idx = $oAsiento->addMove($aCCs['retenciones'],$aTot['retenido'],$ladoEntidad);
						$oAsiento->setConcept($idx,$conceptoHCta);
						$oAsiento->setMoveDate($idx,$this->getDate());
						$idx = NULL;
						$importe_efecto -= $aTot['retenido'];
					}
				}
				if ($this->debug) 
					debug((($ladoEntidad & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
							' a la '.$aCCs['entidad'].' <b>Importe</b> : '.$aTot['importe']);
				$idx = $oAsiento->addMove($aCCs['entidad'],$aTot['importe'],$ladoEntidad);
				$oAsiento->setConcept($idx,$conceptoGrl);
				$oAsiento->setMoveDate($idx,$this->getDate());
				$idx = NULL;

				/** **
				if (is_array($this->_aDescuentos['detalle']) AND sizeof($this->_aDescuentos['detalle'])) {
					foreach ($this->_aDescuentos['detalle'] as $id => $aDto) {
						if ((int)$aDto['financiero']) {
							if ($this->debug) 
								debug((($ladoEntidad & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
										' a la '.$aCCs['dto_financiero'].' Descuento Financiero : '.$aDto['importe']);
							$idx = $oAsiento->addMove($aCCs['dto_financiero'],$aDto['importe'],$ladoEntidad);
							$concepto = 'Descuento Financiero ('.$aDto['nombre'].') '.$conceptoGrl;
							$oAsiento->setConcept($idx,$concepto);
							$oAsiento->setMoveDate($idx,$this->getDate());
							$idx = NULL;
						}
					}
				}
				/** **/

				$dbdump = true;
				// Procedemos con los ivas.
				if (is_array($this->_aIVAs['detalle']) AND sizeof($this->_aIVAs['detalle'])) {
					// Metiendo las Bases de cotizacion y las cotizaciones
					foreach ($this->_aIVAs['detalle'] as $idiva => $aIVA) {
						// Comprobando la cuenta contable del impuesto
						$cc = $aIVA['cc_impuestos'];
						if (!empty($cc)) {
							$oAsiento->dbFetchAccount($aIVA['cc_impuestos'],true);
						} else {
							$this->error('ACENTRY_NOTAXCC',array('cc' => $aIVA['cc_impuestos'], 'nombre' => $aIVA['nombre']));
							$dbdump = false;
							continue;
						}

						if ($this->debug) 
							debug((($ladoFra & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
									' a la '.$aCCs['bases'].' Base de Cotizacion : '.$aIVA['base_imponible']);

						if (is_numeric($aIVA['base_imponible']) AND $aIVA['base_imponible']!=0) {
							$conceptoIVA = 'BI ('.$aIVA['porciento'].((!empty($aIVA['recargo_eq'])) ? ' - '.$aIVA['recargo_eq'] : '').') '.$conceptoGrl;
							$idx = $oAsiento->addMove($aCCs['bases'],$aIVA['base_imponible'],$ladoFra);
							$oAsiento->setConcept($idx,$conceptoIVA);
							$oAsiento->setMoveDate($idx,$this->getDate());
							$idx = NULL;
						}

						if (!$aRec['comunitario']) {
							if (is_numeric($aIVA['total_iva']) AND $aIVA['total_iva']!=0) {
								if ($this->debug) 
									debug((($ladoFra & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
											' a la '.$aIVA['cc_impuestos'].' Cuota de Impuesto : '.$aIVA['total_iva']);

								$conceptoIVACuota = 'Cuota Impuesto ('.$aIVA['porciento'].') '.$conceptoGrl;
								$idx = $oAsiento->addMove($aIVA['cc_impuestos'],$aIVA['total_iva'],$ladoFra);
								$oAsiento->setConcept($idx,$conceptoIVACuota);
								$oAsiento->setMoveDate($idx,$this->getDate());
								$idx = NULL;
							}

							if (is_numeric($aIVA['total_recargo']) AND $aIVA['total_recargo']!=0) {
								// Comprobando la cuenta contable del impuesto
								$cc = $aIVA['cc_recargos'];
								if (!empty($cc)) {
									$oAsiento->dbFetchAccount($aIVA['cc_recargos'],true);
								} else {
									$this->error('ACENTRY_NOTAXCC',array('cc' => $aIVA['cc_recargos']));
									$dbdump = false;
									continue;
								}

								if ($this->debug) 
									debug((($ladoFra & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
											' a la '.$aIVA['cc_recargos'].' Recargo de Impuesto : '.$aIVA['total_recargo']);

								$conceptoIVACuota = 'Recargo Impuesto ('.$aIVA['recargo_eq'].') '.$conceptoGrl;
								$idx = $oAsiento->addMove($aIVA['cc_recargos'],$aIVA['total_recargo'],$ladoFra);
								$oAsiento->setConcept($idx,$conceptoIVACuota);
								$oAsiento->setMoveDate($idx,$this->getDate());
								$idx = NULL;
							}
						} else {
							// Los IVAs intra-comunitarios, se autorepercuten.
							if ($this->getMode() & inmPed_COMPRA) {
								$cc = $aIVA['cc_comunitario_soportado'];
								$cc_auto = $aIVA['cc_comunitario_repercutido'];
							} else {
								$cc = $aIVA['cc_comunitario_repercutido'];
								$cc_auto = $aIVA['cc_comunitario_soportado'];
							}
							$oAsiento->dbFetchAccount($cc,true,'Impuesto Intra-Comunitario ('.$aIVA['nombre'].') ');
							$oAsiento->dbFetchAccount($cc_auto,true,'Impuesto Intra-Comunitario ('.$aIVA['nombre'].') ');

							if (is_numeric($aIVA['total_iva_calculado']) AND $aIVA['total_iva_calculado']!=0) {
								if ($this->debug) 
									debug((($ladoFra & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
											' a la '.$cc.' Cuota de Impuesto <b>Comunitario</b>: '.$aIVA['total_iva_calculado']);

								$conceptoIVACuota = 'Cuota Impuesto Comunitario ('.$aIVA['porciento'].') '.$conceptoGrl;
								$idx = $oAsiento->addMove($cc,$aIVA['total_iva_calculado'],$ladoFra);
								$oAsiento->setConcept($idx,$conceptoIVACuota);
								$oAsiento->setMoveDate($idx,$this->getDate());
								$idx = NULL;

								if ($this->debug) 
									debug((($ladoEntidad & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
											' a la '.$cc_auto.' Cuota de Impuesto <b>Comunitario</b>: '.$aIVA['total_iva_calculado']);

								$conceptoIVACuota = 'AutoRepercusion Impuesto Comunitario ('.$aIVA['porciento'].') '.$conceptoGrl;
								$idx = $oAsiento->addMove($cc_auto,$aIVA['total_iva_calculado'],$ladoEntidad);
								$oAsiento->setConcept($idx,$conceptoIVACuota);
								$oAsiento->setMoveDate($idx,$this->getDate());
								$idx = NULL;
							}
						}
					}

					// Metiendo los Efectos 
					if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) {
						$importe_efecto = $aTot['importe_pagar'];
						if (!is_numeric($importe_efecto)) $importe_efecto = $aTot['importe'];

						$aCfg = $this->getFromCfg();
						if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $this->_oSesion->get_var('_aAppConf');
						foreach ($this->_aEfectos as $idx => $oE) {
							if (is_a($oE,'Draft')) {
								// debug("Pateando efecto num $idx ... ");
								if (!$this->_aEfectos[$idx]->checkFlag($this->_aEfectos[$idx]->ST_EDIT)) {
									$this->_aEfectos[$idx]->setFlag($this->_aEfectos[$idx]->ST_EDIT);
								}
								if (!$this->_aEfectos[$idx]->isAccountable()) {
									$this->_aEfectos[$idx]->dontAccount(false);
									$this->_aEfectos[$idx]->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],
																$aCfg['iconta_diario'],$aCfg['iconta_canal']);
								}

								// Forzando que se contabilice el efecto
								// if (!is_numeric($this->_aEfectos[$idx]->getAttribute('id_asiento')))
								// 	$this->_aEfectos[$idx]->bAccountAsNew = true;
							}
						}
						$this->_change_flags(IEInvoice_EFFECTS | inmPed_MODIFIED);
						// $idx = $oAsiento->addMove($aCCs['entidad'],$importe_efecto,$ladoFra);
						// $oAsiento->setConcept($idx,$conceptoEfecto);
						$idx = NULL;
					} 

				} else debug("Este caso (Factura sin productos con iva) _NO_ deberia producirse");

				// Lo ultimo es el dtoFinanciero, para que su movimiento con la general de ventas/compras no enlace con ningun iva
				if (is_array($this->_aDescuentos['detalle']) AND sizeof($this->_aDescuentos['detalle'])) {
					foreach ($this->_aDescuentos['detalle'] as $id => $aDto) {
						if ((int)$aDto['financiero']) {
							if ($this->debug)
								debug((($ladoEntidad & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
										' a la '.$aCCs['dto_financiero'].' Descuento Financiero : '.$aDto['importe']);
							$idx = $oAsiento->addMove($aCCs['dto_financiero'],$aDto['importe'],$ladoEntidad);
							$concepto = 'Descuento Financiero ('.$aDto['descuento'].') '.$conceptoGrl;
							$oAsiento->setConcept($idx,$concepto);
							$oAsiento->setMoveDate($idx,$this->getDate());
							$idx = NULL;

							if ($this->debug)
								debug((($ladoFra & ICEntry_MOVE_MUST) ? 'Cargando ' : 'Abonando ').
										' a la '.$aCCs['dto_financiero'].' Descuento Financiero : '.$aDto['importe']);
							$idx = $oAsiento->addMove($aCCs['bases'],$aDto['importe'],$ladoFra);
							$concepto = 'Descuento Financiero ('.$aDto['descuento'].') '.$conceptoGrl;
							$oAsiento->setConcept($idx,$concepto);
							$oAsiento->setMoveDate($idx,$this->getDate());
							$idx = NULL;
						}
					}
				}

				if ($dbdump) {
					// debug("Haciendo el dump...");
					$oAsiento->setInvoice($this->getId());
					$oAsiento->setDocument($this->getReference());
					$oAsiento->setName('Fra Gestion Nº '.$this->getReference());
					$oAsiento->setDate($this->getDate());
					$notas = $this->getComments();
					if (!empty($notas)) $oAsiento->setDescription($notas);

					$oAsiento->dbDump();
					$id_asiento = $oAsiento->getId();
					$numero = $oAsiento->getReference();
					if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) {
						/** **
						foreach ($this->_aEfectos as $ide => $oE) {
							if (is_a($oE,'Draft')) {
								$this->_aEfectos[$ide]->update(array('id_asiento' => $id_asiento));
							}
						}
						/** **/
						$this->_change_flags(IEInvoice_EFFECTS | inmPed_MODIFIED);
					}
					
					// debug("id_asiento = $id_asiento");
					$this->_aPedido['contabilizado'] = 1;
					$this->_aPedido['id_asiento'] = $id_asiento;
					$this->_aPedido['asiento_numero'] = $numero;
					$this->_change_flags(IEInvoice_ACCOUNTENTRY | inmPed_MODIFIED);
					$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
				}
				$oAsiento = NULL;
			} else {
				if (is_numeric($this->_aPedido['id_asiento']))
					$this->error('INVOICE_ACENTRY_EXISTS',array('id' => $this->_aPedido['id_asiento']));
				return FALSE;
			}
		} elseif (!$bLink) {
			if ($this->getAccounted()) {
				$this->_change_flags(IEInvoice_ACCOUNTENTRY | inmPed_DB_DELETE);
			}
			if (is_array($this->_aEfectos) AND sizeof($this->_aEfectos)) {
				foreach ($this->_aEfectos as $idx => $oE) {
					if (is_a($oE,'Draft')) {
						$ida = $this->_aEfectos[$idx]->getAttribute('id_asiento');
						// Borrando asiento del efecto
						if (is_numeric($ida)) {
							$oAsiento = &$this->_aEfectos[$idx]->getAccountEntry($ida);
							$this->_aEfectos[$idx]->setAttribute('id_asiento',NULL);
							$this->_change_flags(IEInvoice_EFFECTS | inmPed_MODIFIED);
							if (!is_object($oAsiento)) continue;
							$this->_aEfectos[$idx]->setAccountEntry($ida,$oAsiento);
							$oAsiento->delete();
							unset($oAsiento);
						}
						// Borramos los asientos de los efectos parciales
						$oEPL = &$this->_aEfectos[$idx]->getPartialDrafts();
						if (is_a($oEPL,'DraftDetails')) {
							for ($idxp = $oEPL->firstItem(); isset($idxp); $idxp = $oEPL->nextItem()) {
								$oEP = &$oEPL->getItem();
								$ida = $oEP->getAttribute('id_asiento');
								if (is_numeric($ida)) {
									$oAsiento = &$this->_aEfectos[$idx]->getAccountEntry($ida);
									$oEP->setAttribute('id_asiento',NULL);
									if (!is_object($oAsiento)) continue;
									$oAsiento->delete();
									$this->_aEfectos[$idx]->setAccountEntry($ida,$oAsiento);
									unset($oAsiento);
								}
								unset($oEP);
							}
							$this->_change_flags(IEInvoice_EFFECTS | inmPed_MODIFIED);
						}
					}
				}
				// $idx = $oAsiento->addMove($aCCs['entidad'],$importe_efecto,$ladoFra);
				// $oAsiento->setConcept($idx,$conceptoEfecto);
				$idx = NULL;
			} 
		}

		return true;
	}

	function getAccounted() {
		if ((int)$this->_aPedido['contabilizado'] AND (int)$this->_aPedido['id_asiento']) {
			return $this->_aPedido['id_asiento'];
		} else return NULL;
	} 

	function getId_pedidoFromIdx($idx) {
		if (!is_numeric($idx)) return NULL;
		if (empty($this->_aDetalles[$idx]['id_pedido'])) return NULL;
		return $this->_aDetalles[$idx]['id_pedido'];
	}

	/**
	  * Parche para volcar un pedido a factura sin hacer ningun calculo. Usar junto con dbfill()
	  **/
	function fillFromOrder(&$oPedido,$id_serie_fra = NULL,$bGenerarResiduo = false) {
		if (!is_subclass_of($oPedido,'Document')) {
			$this->error('INVOICE_NODOCUMENT_PARAM',array('fnc' => 'fillFromOrder'));
			return FALSE;
		} 

		if (!($oPedido->getMode() & $this->getMode())) {
			$this->error('INVOICE_ORDER_MODE_MISMATCH');
			return FALSE;
		}
		if ($this->debug) debug("todo: Primero comprobar si la factura esta emitida, en tal caso no se puede tocar. ");

		$aFras = $oPedido->get_invoices();
		if (is_array($aFras)) {
			$this->error('ORDER_INVOICE_EXISTS');
			return FALSE;
		}

		$idem = $this->get_issuer_id();
		$idre = $this->get_reciever_id();
		if (!empty($idem) AND $idem != $oPedido->get_issuer_id()) {
			$this->error('INVOICE_ORDER_ISSUER_MISMATCH');
			return FALSE;
		} elseif (!empty($idre) AND $idre != $oPedido->get_reciever_id()) {
			$this->error('INVOICE_ORDER_RECIEVER_MISMATCH');
			return FALSE;
		} elseif (!$oPedido->get_issuer_id() OR !$oPedido->get_reciever_id()) {
			$this->error('ORDER_INCORRECT',array('id' => $oPedido->get_reference()));
			return FALSE;
		} elseif (empty($idem) OR empty($idre)) {
			$this->set_issuer($oPedido->get_issuer_id());
			$this->set_reciever($oPedido->get_reciever_id());
			$idre = $oPedido->get_reciever_id();
			$idem = $oPedido->get_issuer_id();
		}

		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('INVOICE_LOCKED');
			return FALSE;
		}

		$refext = $this->get_ext_reference();
		if (empty($refext)) $this->set_ext_reference($oPedido->get_ext_reference());
		else {
			$tmp = $oPedido->get_ext_reference();
			if (!empty($tmp)) $this->set_ext_reference($refext.' '.$tmp);
		}

		$iddiv = $oPedido->get_currency();
		$divisa = $this->get_currency();
		if (isset($divisa) AND $divisa['id_divisa'] != $iddiv['id_divisa']) {
			$this->error('INVOICE_ORDER_CURRENCY_MISMATCH');
			return FALSE;
		} elseif (!isset($divisa)) {
			$this->set_currency($iddiv);
		}

		$idfpago = $oPedido->get_payment_method();
		$fpago = $this->get_payment_method();
		if (!isset($fpago) OR empty($this->_aDetalles)) {
			$this->set_payment_method($idfpago);
		} elseif (isset($fpago) AND $fpago != $idfpago) {
			$this->error('INVOICE_ORDER_PAYMENT_MISMATCH');
			return FALSE;
		}

		$fserie = $this->getSeriesId();
		if ( (!isset($fserie) AND !empty($id_serie_fra)) ) {
			$this->setSeries($id_serie_fra,false);
		} elseif (isset($fserie) AND !empty($id_serie_fra) AND $fserie != $id_serie_fra) {
			$this->error('INVOICE_ORDER_PAYMENT_MISMATCH');
			return FALSE;
		} elseif (empty($id_serie_fra)) {
			$this->setSeries(NULL,false);
		}

		$this->_aPedido['id_tarifa'] = $oPedido->_aPedido['id_tarifa'];
		$peddate = $oPedido->getDate();
		if (strtotime(wol_db::formatear_fecha($peddate,false)) > time()) $this->setDate($peddate);
		else $this->setDate(0);

		// debug("todo: comprobar la divisa(si != return), forma de pago(si != fixit), serie?, tarifa nones no?");
		if (!is_array($this->_aDetalles)) $this->_aDetalles = array();
		$total_bruto = 0;
		$total_peso = 0;
		$aTmpPeds = array();
		$aBrutosPeds = array();
		if ($oPedido->get_deliveries()) {
			$hay_albaranes = 1;
			$aStockEstimado = array();
		} else $hay_albaranes = 0;

		if ($bGenerarResiduo) {
			$oPRes = new Order($this->App_Name,$this->_db_name,$this->getMode());
			$oPRes->set_issuer($this->get_issuer_id());
			$oPRes->set_reciever($this->get_reciever_id());
			if (method_exists($oPedido,'get_reciever_address')) {
				$aDir = $oPedido->get_reciever_address();
				if (is_array($aDir)) {
					$aDir = array_shift($aDir);
					$oPRes->set_reciever_address($aDir['id_direccion']);
				} else $oPRes = NULL;
			}
			$oPRes->setHeaderAttribute('residual',1);
		}
		for($idx = $oPedido->first_detail(); $idx; $idx = $oPedido->next_detail()) {
			$aTmpDet = $oPedido->get_detail($idx);
			// Los servicios seran tratados en renderContractsFromOrder() (Salvo la cuota de alta => importe > 0.0)
			if (is_numeric($aTmpDet['id_servicio']) AND !empty($aTmpDet['id_servicio']) 
					AND $oPedido->get_detail_ammount($idx)==0) continue;
			else $nRefCount++;
			$tmp_mask |= inmPed_MODIFIED;
			if ($hay_albaranes) {
				 $tmp_cant = $oPedido->get_quantity($idx,NULL,inmPed_QUANTITY_DELIVERED);
				 $cant_ped = $oPedido->get_quantity($idx);
				 if ($this->debug) debug("Cnt-Servida: $tmp_cant ; Cnt-Pedida: $cant_ped ");
				 // SI la cantidad recibida no es igual a la pedida, nuestra cantidad es la recibida.
				 if ($tmp_cant != $cant_ped) {
					 $aTmpDet['cantidad'] = $tmp_cant;
					 $aStockEstimado[$aTmpDet['id_articulo']] += $cant_ped - $tmp_cant;
					 $tmp_mask |= inmPed_CHG_DET_QUANTITY;
					 if (is_a($oPRes,'Order') AND ($oPedido->get_price($idx) OR !$oPedido->isInOffer($idx) )) {
						 // Metemos el producto sin comprobar descuentos
						 $newidx = $oPRes->add_detail($aTmpDet['id_articulo'],($cant_ped - $tmp_cant),NULL,false);
						 if ($oPedido->get_price($idx) == 0) {
							 // Es un producto sin cargo de una promo. asi que lo insertamos sin comprobar sus descuentos.
							 $oPRes->set_price($newidx,0,false);
						 } else {
							 // Asignando el mismo descuento en este nuevo pedido.
							 $aDto = $oPedido->get_detail_discount($idx);
							 if (is_array($aDto) AND sizeof($aDto)) {
								 if (!$aDto['porciento'] OR !$aDto['monto']) {
									 $oPRes->set_detail_discount($newidx,0,1,NULL,true);
								 } else {
									 if ($aDto['porciento'] != 0) {
										 $dto = $aDto['porciento'];
										 $bPto = true;
									 } else {
										 $dto = $aDto['monto'];
										 $bPto = false;
									 }
									 $oPRes->set_detail_discount($newidx,$dto,$bPto,$aDto['tipo'],true);
								 }
							 }
						 }
					 }
				 }
				 $aTmpDet['cantidad_pedida'] = $oPedido->get_quantity($idx);
			} 
			$aTmpDet['id_servicio'] = NULL;
			unset($aTmpDet['id_servicio']);
			$new_idx = (array_push($this->_aDetalles,$aTmpDet)-1);
			$total_bruto += $oPedido->_aDetalles[$idx]['base_imponible'];
			$total_peso += $oPedido->_aDetalles[$idx]['peso'];
			if (is_numeric($oPedido->_aDetalles[$idx]['id_pedido']) AND 
					!in_array($oPedido->_aDetalles[$idx]['id_pedido'],$aTmpPeds))
				array_push($aTmpPeds,$oPedido->_aDetalles[$idx]['id_pedido']);
			$aBrutosPeds[$oPedido->_aDetalles[$idx]['id_pedido']] = $total_bruto;
			$this->_change_flags(inmPed_CHG_DETAIL | $tmp_mask ,$new_idx);
			$tmp_mask = 0;
		}

		// Corregimos el stock estimado de los productos no servidos al completo.
		if (is_array($aStockEstimado) AND sizeof($aStockEstimado)) {
			$bVenta = ($this->getMode() & inmPed_VENTA);
			if ($bVenta) $id_empresa = $this->get_issuer_id();
			else $id_empresa = $this->get_reciever_id();
			foreach ($aStockEstimado as $id_articulo => $cantidad) {
				$cons = 'UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio '.
							( ($bVenta) ? '+' : '-' ).' \''.$cantidad.'\' '.
							'WHERE id_articulo = '.$id_articulo.' AND id_empresa = '.$id_empresa;
				$this->_db->query($cons);
				$this->_db->libera();
			}
		}
		$this->_aTotales['bruto'] += $total_bruto;
		$this->_aPedido['peso'] += $total_peso;
		if (is_numeric($oPedido->_aPedido['id_pedido']) AND !in_array($oPedido->_aPedido['id_pedido'],$aTmpPeds))
			array_push($aTmpPeds,$oPedido->_aPedido['id_pedido']);

		// Asociamos el pedido con esta factura, si hay referencias del pedido en la fra. (ej: servicio sin alta ni prepago)
		if (sizeof($aTmpPeds) AND $nRefCount) {
			foreach ($aTmpPeds as $idped) {
				if (empty($idped)) continue;
				$aPedFact = $this->_aIDPedido[$idped];
				if (!is_array($aPedFact)) $aPedFact = array();
				$base = NULL;
				// Calculando la base imponible total facturada de este pedido.
				if (!is_numeric($aPedFact[$idped]['base_imponible'])) {
					$base = $aBrutosPeds[$idped];
					$aDtos = $this->get_discounts();
					if (is_array($aDtos) AND is_array($aDtos['detalle'])) 
						foreach ($aDtos['detalle'] as $orden => $aDt) 
							if (is_numeric($aDt['descuento'])) 
								$base -= $base * $aDt['descuento'] / 100;
					if (is_numeric($base)) $aPedFact['base_imponible'] = $base;
				}
				if (empty($aPedFact['referencia']) AND $idped == $oPedido->get_id()) {
					$aPedFact['referencia'] = $oPedido->get_reference();
					$aPedFact['preparado'] = $oPedido->get_status();
				} else $aPedFact['_dbfetch']=0;
				$aPedFact['id_pedido'] = $idped;

				$aAg = $oPedido->get_agent();
				if (is_array($aAg) AND is_numeric($aAg['id_agente'])) $aPedFact['id_agente'] = $aAg['id_agente'];

				if (method_exists($oPedido,'get_reciever_address')) {
					$aDir = $oPedido->get_reciever_address();
					if (is_array($aDir) AND sizeof($aDir)) {
						$aDir = array_shift($aDir);
						if ((int)$aDir['id_direccion']) $aPedFact['id_direccion'] = $aDir['id_direccion'];
					}
				}

				if (!is_numeric($aPedFact['id_factura']) AND is_numeric($this->getId())) {
					$aPedFact['id_factura'] = $this->getId();
				}
				$this->_aIDPedido[$idped] = $aPedFact;
			}
		}

		$this->renderContractFromOrder($oPedido);
				
		if (is_a($oPRes,'Order') AND $oPRes->num_details()) {
			$ref_ext = $oPedido->get_ext_reference();
			if (!empty($ref_ext)) $oPRes->set_ext_reference($ref_ext);
			$aAg = $oPedido->get_agent();
			if (is_array($aAg) AND sizeof($aAg)) $oPRes->set_agent($aAg['id_agente']);
			$oPRes->calculate();
			$oPRes->dbDump();
			$oPedido->set_incomplete_order($oPRes->getId());
			$oPedido->dbDump();
		}

		if (!$this->num_details()) {
			// debug("Borrando la Fra actual... o al menos se marca");
			$this->delete();
		} else {
			if ($this->is_deleted()) $this->undelete();
			$this->_build_indexes();
			$this->_build_taxes();
			$this->_calculate_discounts();
			$this->_calculate_totals(false);
			$this->_change_flags(inmPed_CHG_DETAIL | inmPed_MODIFIED );
		}

		return true;
	}

	function renderContractFromOrder(&$oPedido) {
		if (!is_object($oPedido)) return FALSE;
		if (!is_array($oPedido->_aServicio_DetIdx) OR !sizeof($oPedido->_aServicio_DetIdx)) return FALSE;

		$aFacturas = array();
		$ffra = $this->getDate();
		if (empty($ffra)) $ffra = $oPedido->getDate();
		if (empty($ffra)) {
			$this->setDate();
			$ffra = $this->getDate();
		}
		if (strstr($ffra,' ')) {
			list($ffra,$nones)=split(' ',$ffra);
		}
		$ffra = wol_db::formatear_fecha($ffra,FALSE);

		if ($oPedido->getMode() & inmPed_VENTA) {
			$id_empresa = $oPedido->get_issuer_id();
			$id_cliente = $oPedido->get_reciever_id();
		} else {
			$id_proveedor = $oPedido->get_issuer_id();
			$id_empresa = $oPedido->get_reciever_id();
		}
		if (!is_numeric($id_empresa) AND (!is_numeric($id_proveedor) OR !is_numeric($id_cliente) ) ) return FALSE;

		foreach ($oPedido->_aServicio_DetIdx as $id_servicio => $aIdx) {
			if (!is_array($aIdx) OR !sizeof($aIdx)) continue;
			if (!is_numeric($oPedido->_aServicios[$id_servicio]['duracion']) OR
					!is_numeric($oPedido->_aServicios[$id_servicio]['plazo_factura']) OR 
					empty($oPedido->_aServicios[$id_servicio]['plazo_factura'])) {
				$this->error('INVOICE_CONTRACT_NOPERIOD',array('contract' => $oPedido->_aServicios[$id_servicio]['nombre']));
				continue;
			}

			if (!empty($ffra)) $tfra = strtotime($ffra);
			else $tfra = strtotime(date("Y-m-d"));
			$dias_plazo = $oPedido->_aServicios[$id_servicio]['plazo_factura'];
			$dias_duracion = $oPedido->_aServicios[$id_servicio]['duracion'];

			// Si es multipo de 365, contamos en anyos.
			if ($dias_duracion / 365 >= 1 AND floor($dias_duracion/365) == $dias_duracion/365) {
				$n_anyos = $dias_duracion / 365;
				$tmptimefin = strtotime("+$n_anyos year",$tfra);
				$nsecs = $tmptimefin - $tfra;
				$dias_duracion = $nsecs / (3600 * 24);
			} elseif ($dias_duracion / 30 >= 1 AND floor($dias_duracion/30) == $dias_duracion/30) {
				$n_meses = $dias_duracion / 30;
				$tmptimefin = strtotime("+$n_meses month",$tfra);
				$nsecs = $tmptimefin - $tfra;
				$dias_duracion = $nsecs / (3600 * 24);
			}
			// Obtenemos el momendo de fin e inicio de contrato
			$end_time = strtotime("+$dias_duracion day",$tfra);
			$start_time = $tfra;

			// Marcamos la cadena de avance de tiempo para strtotime()
			if ($dias_plazo / 365 >= 1 AND floor($dias_plazo/365) == $dias_plazo/365) {
				$n_anyos = $dias_plazo / 365;
				$n_meses = 0;
				$strtime_str = "+$n_anyos year";
			} elseif ($dias_plazo / 30 >= 1 AND floor($dias_plazo/30) == $dias_plazo/30) {
				$n_meses = $dias_plazo / 30;
				$n_anyos = 0;
				$strtime_str = "+$n_meses month";
			} else {
				$strtime_str = "+$dias_plazo day";
				$n_meses = 0;
				$n_anyos = 0;
			}

			$n_fras = ceil($dias_duracion / $dias_plazo);
			if ($this->debug) {
				debug('Servicio: '.$oPedido->_aServicios[$id_servicio]['nombre'].
						' Dura: '.$dias_duracion.
						'<br> Plazo: '.$dias_plazo.
						' Nº Fras: '.$n_fras.
						'<br> Fecha Fra-Alta: '.$ffra
						);
				print_r($aIdx);
			}
			$dias = array();
			/* 
			 * Para cada $id_servicio hay que generar $n_fras Facturas con las referencias de los detalles $aIdx
			 *	  Asi que preparamos el vector indexado por fechas, que contendra las referencias. Dado que todas van 
			 *		a pertenecer al mismo servicio, el numero de facturas y duracion son los mismos para todas.
			 */
			for ($i = 1; $i <= $n_fras; $i++) {
				$fecha_est = strtotime($strtime_str,$tfra);
				// Si queremos colocar una fecha mas alla del fin de contrato, corregimos y ponemos fin de contrato.
				if ($fecha_est > $end_time) {
					$fecha_est = $end_time;
				}
				$str_fecha = strftime("%Y-%m-%d",$fecha_est);
				$aFacturas[$str_fecha] = array('time' => $fecha_est);
				// debug("Generando Fra ".
						// " desde($tfra) : ".strftime("%Y-%m-%d %H:%M:%S",$tfra).
						// " para($fecha_est): ".strftime("%Y-%m-%d %H:%M:%S",$fecha_est));
				$tfra = $fecha_est;
			}
			if (!is_array($aFacturas) OR !sizeof($aFacturas)) continue;

			/* 
			 * Para cada $idx de detalle, lo metemos en las facturas que le corresponda. 
			 */
			foreach ($aIdx as $idx) {
				$bInsert = TRUE;
				$aDet = $oPedido->get_detail($idx);
				if (!is_array($aDet) OR !sizeof($aDet)) continue;
				$idart = $oPedido->get_detail_article_id($idx);
				$bAdelanto = $oPedido->_aServicios[$id_servicio]['referencias'][$idart]['por_adelantado'];
				$precio = $oPedido->_applyRevenue($aDet['precio_real']);
				$precio_dias = $aDet['servicios_duracion_precio'];
				$cant = $oPedido->get_quantity($idx);
				if ($this->debug) 
					debug('Referencia: '.$aDet['nombre'].'<br> Duracion Precio: '.$precio_dias.
							'<br> Precio: '.$precio.
							'<br> PorAdelantado: '.$bAdelanto);
				$aFechas = array_keys($aFacturas);
				// Si se factura por adelantado, el primer importe va en $this
				if ($bAdelanto) {
					$tini = $start_time;
					$tfin = $aFacturas[$aFechas[0]]['time'];
					if (!is_numeric($precio_dias) OR empty($precio_dias)) {
						// debug("El importe dependera de la cantidad que no se ha especificado ...");
						$cant = 0;
					} else {
						if ($precio_dias == 30 AND $n_meses > 0) {
							$importe = ($precio * $n_meses);
						} else {
							$dias_importe = ($tfin - $tini) / (3600 * 24);
							$importe = ($precio * $dias_importe) / $precio_dias;
						}
						// debug("cant: $cant");
						// debug("Calculado importe para $dias_importe Dias ... $importe Tazos");
					}
					$idx_a = $this->add_detail($idart,$cant);
					if ($importe) $this->set_price($idx_a,$importe);
					$this->set_detail_attribute($idx_a,'id_servicio',$id_servicio);
					$this->set_detail_comment($idx_a,strftime("%Y-%m-%d",$tini).' -> '.strftime("%Y-%m-%d",$tfin));
				}
				foreach ($aFechas as $i => $fecha) {
					if ($this->debug) debug("<br>Pos $i Fecha $fecha Time: ".$aFacturas[$fecha]['time']);
					if ($bAdelanto) {
						if ($i == sizeof($aFechas)-1) {
							// debug("Este periodo ya ha sido liquidado antes.");
							continue;
						}
						// debug("Se paga por adelantado... ");
						$tini = $aFacturas[$fecha]['time'];
						$tfin = $aFacturas[$aFechas[$i+1]]['time'];
					} else {
						// debug("Se paga al vencimiento...");
						if ($i == 0) $tini = $start_time;
						else $tini = $aFacturas[$aFechas[$i-1]]['time'];
						$tfin = $aFacturas[$fecha]['time'];
					}
					if ($this->debug) 
						debug("Calculos entre($tini) ".strftime("%Y-%m-%d %H:%M:%S",$tini)." Y($tfin) ".strftime("%Y-%m-%d %H:%M:%S",$tfin)." = ".($tfin-$tini)." Secs");

					if (!is_numeric($precio_dias) OR empty($precio_dias)) {
						if ($this->debug) debug("El importe dependera de la cantidad que no se ha especificado ...");
						$cant = 0;
					} else {
						// Redondeando por Dias, evitamos modificaciones de precio por 'daylight time saving'
						if ($precio_dias == 30 AND $n_meses > 0) {
							$importe = ($precio * $n_meses);
						} else {
							$dias_importe = round(($tfin - $tini) / (3600 * 24),0);
							$importe = ($precio * $dias_importe) / $precio_dias;
						}
						// debug("Calculando importe de $dias_importe Dias ... $importe Tazos");
					}
					// debug("Cantidad $cant ");
					$aTmp['cantidad'] = $cant;
					$aTmp['id_articulo'] = $idart;
					$aTmp['importe'] = $importe;
					$aTmp['concepto'] = strftime("%Y-%m-%d",$tini).' -> '.strftime("%Y-%m-%d",$tfin);
					if (!is_array($aFacturas[$fecha]['detalles']) OR !sizeof($aFacturas[$fecha]['detalles'])) 
						$aFacturas[$fecha]['detalles'] = array();

					array_push($aFacturas[$fecha]['detalles'],$aTmp);
					$str_where_fras .= ( (!empty($str_where_fras)) ? ' OR ' : '').' fecha like "'.$fecha.'%" ';
				}
			}
		}

		if (is_array($aFacturas) and sizeof($aFacturas)) {
			if ($this->debug) debug("Volcando la siguiente lista de Facturas ");
			// Falta id_cliente/id_proveedor
			$cons = 'SELECT id_factura,fecha FROM Facturas WHERE id_empresa='.$id_empresa.' AND '.
						( (is_numeric($id_cliente)) ? 'id_cliente='.$id_cliente : 'id_proveedor='.$id_proveedor ).' AND ('.
						$str_where_fras.')';
			$frasrs = $this->_db->query($cons);
			if ($this->_db->num_rows($frasrs)) {
				while ($aTmp = $this->_db->fetch_assoc($frasrs)) {
					list($fcha,$nones) = split(' ',$aTmp['fecha']);
					$aFacturas[$fcha]['id'] = $aTmp['id_factura'];
				}
			}

			foreach ($aFacturas as $date => $aFra) {
				$oFra = NULL;
				if (!is_array($aFra['detalles']) OR !sizeof($aFra['detalles'])) continue;
				$oFra = new Invoice($this->App_Name,$this->_db_name,$this->getMode());
				if (is_numeric($aFra['id'])) $oFra->dbFill($aFra['id']);
				else {
					$oFra->set_issuer($this->get_issuer_id());
					$oFra->set_reciever($this->get_reciever_id());
					$oFra->set_currency($this->get_currency());
					$oFra->set_payment_method($this->get_payment_method());
					$oFra->setDate($date);
					$oFra->setSeries($this->getHeaderAttribute('id_serie'),false);
				}
				if (!is_object($oFra)) continue;
				foreach ($aFra['detalles'] as $aDet) {
					if ($this->debug) {
						debug("Fra Datada en $date Detalle a insertar: ");
						print_r($aDet);
					}
					$idx_a = $oFra->add_detail($aDet['id_articulo'],$aDet['cantidad']);
					if ($importe) $oFra->set_price($idx_a,$aDet['importe']);
					$oFra->set_detail_attribute($idx_a,'id_servicio',$id_servicio);
					$oFra->set_detail_comment($idx_a,$aDet['concepto']);
				}
				if ($this->debug) debug("Aqui hariamos el dbdump de la factura ...");
				$oFra->calculate();
				$oFra->dbDump(false);
				$aTmpFra = NULL;
				$aTmpFra['id_factura'] = $oFra->getId();
				$aTmpFra['reference'] = $oFra->getReference();
				$aTmpFra['estado'] = $oFra->getStatus();
				$oPedido->set_invoice($aTmpFra);
			}
		}

		if ($this->debug) debug("Dumpeando el pedido ....");
		$oPedido->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		$oPedido->dbdump();
	}

	function dbFill($id_factura) {
		if (!is_object($this->_db)) return 0;
		if (!(int)$id_factura) return 0;
		$oDb = $this->_db;

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_sale_headders($id_factura)) {
				$this->error('INVOICE_NOHEADERS');
				return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchase_headders($id_factura)) {
				$this->error('INVOICE_NOHEADERS');
				return FALSE;
			}
		}
		$idag = $this->getHeaderAttribute('id_agente');
		if (is_numeric($idag)) $this->setAgent($idag);

		// paborrar_: $leyenda_divisa = $this->_aDivisa['leyenda'];
		// paborrar_: $campo_accion = $this->_aTarifa['campo_accion'];
		$id_factura = $this->_aPedido['id_factura'];
		$id_empresa = $this->_aPedido['id_empresa'];

		// WhatFor? (para los agentes del cliente y el modo stricto o para las dirsEntrega) 
		// $this->set_reciever($this->get_reciever_id());
		if ($this->_fPedido & inmPed_VENTA) {
			$this->_possible_agents_clients($this->get_reciever_id(),0);
			if ((int)$this->_aPedido['id_direccion']) {
				$id_direccion = $this->_aPedido['id_direccion'];
				$this->_aReceptor['id_direccion'] = $id_direccion;
				$this->_aPedido['id_direccion'] = $id_direccion;
				$this->_aPedido['id_almacen'] = NULL;
			}
		} else {
			$this->_possible_agents_clients($this->get_reciever_id(),1);
			if ((int)$this->_aPedido['id_almacen']) {
				$id_direccion = $this->_aPedido['id_almacen'];
				$this->_aReceptor['id_direccion'] = $id_direccion;
				$this->_aPedido['id_almacen'] = $id_direccion;
				$this->_aPedido['id_direccion'] = NULL;
			}
		}

		// Comprobamos los efectos (si la factura esta emitida)
		if ($this->getIssued()) {
			$cons = "SELECT DISTINCTROW E.id_efecto,E.id_factura,E.fecha_vencimiento,E.monto,E.medio_pago,E.pago_cobro, ".
						"E.id_banco,E.concepto,E.fecha_abono,E.fecha_devolucion,E.emitido,E.devuelto,E.pagado,E.monto_pagado, ".
						'B.nombre as "banco_nombre", B.cuenta_contable as "banco_cc" '.
						'FROM Efectos `E` LEFT JOIN Bancos B ON (E.id_banco=B.id_banco) '.
						( ($this->getInstallment())
						  ?  'LEFT JOIN Efectos_parciales EP ON (EP.id_efecto=E.id_efecto) '
						  : '' ).
						'WHERE E.id_factura = '.$id_factura.
						( ($this->getInstallment())
						  ? ' OR EP.id_factura_abono = '.$id_factura 
						  : '' );
			$idrs = $oDb->query($cons);
			$hay_efectos = (int)$oDb->num_rows($idrs);
			if ($hay_efectos) {
				$aCfg = $this->getFromCfg();
				if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $this->_oSesion->get_var('_aAppConf');
				while ($aTmp = $oDb->fetch_assoc($idrs)) {
					foreach($aTmp as $clave => $valor) $aEff[$clave] = $valor;
					// $this->_aEfectos[$aTmp['id_efecto']] = $aEff;
					$this->_aEfectos[$aTmp['id_efecto']] = new Draft($this->_oSesion->App_Name,$this->_db_name);
					$this->_aEfectos[$aTmp['id_efecto']]->debug = $this->debug;
					$this->_aEfectos[$aTmp['id_efecto']]->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],
																	$aCfg['iconta_diario'],$aCfg['iconta_canal']);
					$this->_aEfectos[$aTmp['id_efecto']]->dbFill($aTmp['id_efecto']);
				}
				$this->_change_flags(IEInvoice_EFFECTS | inmPed_OK);
			}
			$oDb->libera($idrs);
		}

		// Comprobamos las Comisiones de Los Agentes.
		$cons = "SELECT ".
					"AF.id_agente as 'id_agente', ".
					"CONCAT(A.apellidos,', ',A.nombre) as 'nombre', ".
					"A.comision_base as 'comision', ".
					"A.comision_repartida as 'comision_repartida', ".
					"AF.monto as 'importe_comision', ".
					"AF.monto_liquidado as 'importe_comision_liquidado' ".
					"FROM Agentes_facturas `AF`, Agentes `A` ".
					"WHERE A.id_agente = AF.id_agente AND AF.id_factura = ".$id_factura;
		$idrs = $oDb->query($cons);
		$hay_comisiones = (int)$oDb->num_rows($idrs);
		if ($hay_comisiones) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				// debug("dbFill()");
				$aAgC = $this->getAgentFrom($aTmp['id_agente']);
				if (!is_array($aAgC)) {
					//debug("Anyadiendo agente...");
					$aAgC['id_agente'] = $aTmp['id_agente'];
					$aAgC['nombre'] = $aTmp['nombre'];
					$aAgC['comision'] = $aTmp['comision'];
					$aAgC['comision_repartida'] = $aTmp['comision_repartida'];
				}
				$aAgC['importe_comision'] = $aTmp['importe_comision'];
				$aAgC['importe_comision_liquidado'] = $aTmp['importe_comision_liquidado'];
				$aAgC['_dbfetch'] = 1;
				$this->_aAgentes_comisiones[$aTmp['id_agente']] = $aAgC;
			}
			$this->_change_flags(IEInvoice_COMMISSIONS | inmPed_OK);
		} else $this->_aAgentes_comisiones = array();
		$oDb->libera($idrs);

		// Comprobamos la existencia de Albaranes para saber si necesitamos cantidad_residual.
		$cons = 'SELECT A.id_albaran,A.referencia,A.preparado,A.enviado,A.confirmacion,A.devolucion,A.fecha,A.fecha_envio,A.fecha_recepcion, '.
					'ADet.id_detalle, IF(ADet.fecha_caducidad,ADet.fecha_caducidad,NULL) as "fecha_caducidad", ADet.lote, '.
					'ADet.cantidad-ADet.cantidad_devuelta as "cantidad" '. // ', B.cantidad AS "cantidad_debaja" '.
					'FROM Albaranes `A`, Facturas_detalle, Lineas_detalle , Detalles_albaran `ADet` '.
					// 'LEFT JOIN Bajas_localizacion B ON (ADet.id_detalle=B.id_detalle) '.
					'WHERE Facturas_detalle.id_factura = '.$id_factura.
					' AND Facturas_detalle.id_detalle = Lineas_detalle.id_detalle '.
					'AND Lineas_detalle.id_detalle = ADet.id_detalle AND ADet.id_albaran = A.id_albaran ';
		$idrs = $oDb->query($cons);
		$hay_albaranes = (int)$oDb->num_rows($idrs);
		if ($hay_albaranes) {
			$this->_aDbDetToAlb = array();
			$aLosQueNo = array('fecha_caducidad','lote','id_detalle','cantidad','cantidad_devuelta');
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) if (!in_array($clave,$aLosQueNo)) $aAlb[$clave] = $valor;

				if (!is_array($this->_aIDAlbaran[$aTmp['id_albaran']])) 
					$this->_aIDAlbaran[$aTmp['id_albaran']] = $aAlb;
				if (!is_array($this->_aIDAlbaran[$aTmp['id_albaran']]['detalles'][$aTmp['id_detalle']])) 
					$this->_aIDAlbaran[$aTmp['id_albaran']]['detalles'][$aTmp['id_detalle']] = array();

				array_push($this->_aIDAlbaran[$aTmp['id_albaran']]['detalles'][$aTmp['id_detalle']],
						array('id_detalle' => $aTmp['id_detalle'], 'cantidad' => $aTmp['cantidad'], 'cantidad_baja' => $aTmp['cantidad_debaja'], 
							'fecha_caducidad' => $aTmp['fecha_caducidad'], 'lote' => $aTmp['lote']) );

				if (!is_array($this->_aDbDetToAlb[$aTmp['id_detalle']])) $this->_aDbDetToAlb[$aTmp['id_detalle']] = array();
				if (!in_array($aTmp['id_albaran'],$this->_aDbDetToAlb[$aTmp['id_detalle']])) {
					array_push($this->_aDbDetToAlb[$aTmp['id_detalle']],$aTmp['id_albaran']);
				}

			}
			$aLosQueNo = NULL;
			unset($aLosQueNo);
		} else {
			$this->_aDbDetToAlb = NULL;
			$this->_aIdxToAlb = NULL;
		}
		$oDb->libera($idrs);

		// Comprobamos la existencia de Pedidos 
		// Fixme: Esta query se puede unificar junto con la de Albaranes (dado que pasa por pedidos). 
		$cons = "SELECT P.id_pedido,P.referencia,P.preparado,P.id_agente,IF(P.id_almacen,P.id_almacen,P.id_direccion) as 'id_direccion' ".
					"FROM Pedidos `P`, Pedidos_facturas `F` WHERE P.id_pedido=F.id_pedido AND F.id_factura = ".$id_factura;
		$idrs = $oDb->query($cons);
		$hay_facturas = (int)$oDb->num_rows($idrs);
		if ($hay_facturas) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) {
					$aFac[$clave] = $valor;
				}
				$aFac['_dbfetch'] = 1;
				$this->_aIDPedido[$aTmp['id_pedido']] = $aFac;
			}
		}
		$oDb->libera($idrs);

		// Comprobamos las facturas asociadas a esta mediante pedidos
		if (is_array($this->_aIDPedido) ANd sizeof($this->_aIDPedido))
			foreach ($this->_aIDPedido as $idped => $nones)
				$str_where_ped .= ( (!empty($str_where_ped)) ? ' OR ' : ' ' ).'id_pedido = '.$idped;

		$cons = "SELECT F.id_factura,F.referencia,F.estado as 'preparado',F.fecha FROM Pedidos_facturas `FP`, Facturas `F` ".
					"WHERE FP.id_factura = F.id_factura AND FP.id_factura != ".$id_factura.
					( (!empty($str_where_ped)) ? ' AND ('.$str_where_ped.') ' : '');
		$idrs = $oDb->query($cons);
		$hay_facturas = (int)$oDb->num_rows($idrs);
		if ($hay_facturas) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) {
					$aFra[$clave] = $valor;
				}
				$aFra['_dbfetch'] = 1;
				$this->_aIDFactura[$aTmp['id_factura']] = $aFra;
			}
		}
		$oDb->libera($idrs);

		// Comprobamos los abonos.
		$cons = 'SELECT DISTINCTROW F.id_factura,F.referencia,F.estado as "preparado",F.fecha,F.factura_abono,Fd.id_detalle,Fd.cantidad '.
					'FROM Facturas_abonos `FA` '.
					( ($this->getInstallment())
					  ? 'LEFT JOIN Facturas_abonos FAux ON (FA.id_factura=FAux.id_factura AND FAux.id_factura_abono!='.$this->getId().') '
					  : ''
					).
					', Facturas `F` LEFT JOIN Facturas_detalle Fd ON (Fd.id_factura=F.id_factura) '.
					'WHERE '.
					( ($this->getInstallment())
					  ? 'FA.id_factura_abono = '.$this->getId().' AND (FA.id_factura=F.id_factura OR FAux.id_factura_abono=F.id_factura) '
					  : 'FA.id_factura = '.$this->getId().' AND FA.id_factura_abono = F.id_factura '
					  );

		$idrs = $oDb->query($cons);
		$hay_facturas = (int)$oDb->num_rows($idrs);
		if ($hay_facturas) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) {
					if (!strcasecmp($clave,'id_detalle') OR !strcasecmp($clave,'cantidad')) continue;
					$aFra[$clave] = $valor;
				}
				$aFra['_dbfetch'] = 1;
				if (!is_array($this->_aIDFacturaAbono[$aTmp['id_factura']])) $this->_aIDFacturaAbono[$aTmp['id_factura']] = $aFra;
				$this->_aIDFacturaAbono[$aTmp['id_factura']]['detalles'][$aTmp['id_detalle']] = $aTmp['cantidad'];
			}
		}
		$oDb->libera($idrs);

		//TODO: Documentar _aIDTicket
		// Comprobamos la existencia de Tickets para saber si necesitamos cantidad_residual.
		$cons = "SELECT T.id_ticket,T.referencia ".
					"FROM Tickets `T`, Facturas_detalle `FraDet`, Tickets_detalle `TDet`, Lineas_detalle `Det` ".
					"WHERE FraDet.id_factura = ".$id_factura.
					" AND FraDet.id_detalle = Det.id_detalle ".
					"AND Det.id_detalle = TDet.id_detalle AND TDet.id_ticket = T.id_ticket GROUP BY T.id_ticket";
		$idrs = $oDb->query($cons);
		$hay_albaranes = (int)$oDb->num_rows($idrs);
		if ($hay_albaranes) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) $aAlb[$clave] = $valor;
				$this->_aIDTicket[$aTmp['id_ticket']] = $aAlb;
			}
		}
		$oDb->libera($idrs);
		if ($this->debug) print_r($this->_aIDTicket);


		// Pasar esto a un metodo dbrecover_detail() ?
		// Localizamos y Rellenamos el detalle de los pedidos.

		// Fixme: pasar esto a un dbrecover_taxes() ?
		// Rellenamos la tabla de IVAs.
		$cons = "SELECT I.id_iva as 'id_iva', ".
				  "I.id_pedido as 'id_pedido', ".
				  "I.id_factura as 'id_factura', ".
				  "I.monto as 'base_imponible', ".
				  "I.bruto as 'bruto', ".
				  "I.recargo_iva as 'total_iva', ".
				  "I.recargo_equivalente as 'total_recargo', ".
				  "TI.porcentaje as 'porciento', ".
				  "TI.recargo_equivalente as 'recargo_eq', ".
				  "TI.cc_ce_repercutido as 'cc_comunitario_repercutido', ".
				  "TI.cc_ce_soportado as 'cc_comunitario_soportado', ".
				  ( ($this->_fPedido & inmPed_VENTA) 
					 ? "TI.cc_imp_repercutido as 'cc_impuestos', ".
						"TI.cc_re_repercutido as 'cc_recargos' "
					 : "TI.cc_imp_soportado as 'cc_impuestos', ".
						"TI.cc_re_soportado as 'cc_recargos' "
				  ).
				  "FROM IVAs `I`, Tipos_IVA `TI` ".
				  "WHERE I.id_factura = $id_factura AND I.id_iva = TI.id_iva order by id_iva desc";
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			$recalcular_iva = false;
			while($aTmp = $oDb->fetch_assoc($rs)) {
				$aTmp['total_iva_calculado'] = $this->format_number($aTmp['base_imponible'] * $aTmp['porciento'] / 100,$this->tot_decimals);
				$aTmp['total_recargo_calculado'] = $this->format_number($aTmp['base_imponible'] * $aTmp['recargo_eq'] / 100,$this->tot_decimals);
				$aIVAs[$aTmp['id_iva']] = $aTmp;
				$total_iva += $aTmp['total_iva'];
				$total_req += $aTmp['total_recargo'];
			}
			$this->_aIVAs['total_iva'] = $total_iva;
			$this->_aIVAs['total_recargo'] = $total_req;
			$this->_aIVAs['detalle'] = $aIVAs;
			$this->_aTotales['impuestos'] = $total_iva;
			$this->_aTotales['recargos'] = $total_req;
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK);
			$recalcular_iva = FALSE;
		} else {
			$recalcular_iva = TRUE;
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		}
		$oDb->libera($rs);
		if ($this->debug) {
			debug("IVas rellenos... : recal - ".$recalcular_iva);
			print_r($this->_aIVAs);
			debug("...");
		}

		// Fixme: pasar esto a un dbrecover_discounts() ?
		// Rellenamos la tabla de Descuentos.
		$cons = "SELECT id_descuento as 'id_descuento', ".
				  "id_factura as 'id_factura', ".
				  "id_pedido as 'id_pedido', ".
				  "orden as 'orden', ".
				  "monto_base as 'base_imponible', ".
				  "porcentaje as 'descuento', ".
				  "nombre as 'nombre', ".
				  "financiero as 'financiero', ".
				  "monto_final as 'importe' ".
				  "FROM Descuentos ".
				  "WHERE id_factura = $id_factura ORDER BY orden asc";
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			$recalcular_dtos = FALSE;
			while($aTmp = $oDb->fetch_assoc($rs)) {
				if (!is_array($aDtos[(int)$aTmp['orden']])) $aDtos[(int)$aTmp['orden']] = $aTmp;
				else $aDtos[] = $aTmp;
				$total += $aTmp['importe'];
			}
			if ($this->debug) debug("dbfill() - Descuentos");
			if ($this->debug) print_r($aDtos);
			$this->_aDescuentos['total'] = $total;
			$this->_aDescuentos['detalle'] = $aDtos;
			$this->_aTotales['descuentos'] = $total;
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK);
		} else {
			$recalcular_dtos = TRUE;
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
			$this->_aDescuentos['detalle'] = NULL;
		}
		$oDb->libera($rs);
		if ($this->debug) {
			debug("<b>Descuentos</b> rellenos... :");
			print_r($this->_aDescuentos);
			debug("...");
		}

		// Desbloqueamos el pedido para que pueda ser usado.
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
		// $this->_aFlags[pedido] &= ~inmPed_LOCKED;
		// $this->_aFlags[total_bases] |= inmPed_MODIFIED;

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_saleorder_details($id_factura)) {
				$this->error('INVOICE_NODETAILS');
				// return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchaseorder_details($id_factura)) {
				$this->error('INVOICE_NODETAILS');
				// return FALSE;
			}
		}
		$this->_build_indexes();

		//Fixme: Calculamos los totales del pedido.
		//TODO: Comprobamos que la serie de la factura sea contabilizable antes de calcular los ivas
		if ($recalcular_iva) {
			$this->_build_taxes();
		}
		if ($recalcular_dtos) $this->_calculate_discounts();
		// $this->_calculate_totals(FALSE);

		if ($this->debug) {
			debug("<br/>Pedido :");
			print_r($this->_aPedido);
			debug("<br/>Receptor :");
			print_r($this->_aReceptor);
			debug("<br/>Emisor :");
			print_r($this->_aEmisor);
			debug("<br/>Tarifa :");
			print_r($this->_aTarifa);
			debug("<br/>Divisa :");
			print_r($this->_aDivisa);
			// debug("Detalles :");
			// print_r($this->_aDetalles);
		}
		return true;
	}

	function Dump($tipo=NULL) {
		return $this->dbDump();
	}

	/**
	  * Vuelca TOD-O el contenido del pedido a la base de datos. Borrando registros si es preciso.
	  **/
	function dbDump($bGetRef = true) {
		if ($this->debug) debug("probando el dump...");
		if ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("pedido tocado...");
			if ($this->_aFlags['pedido'] & inmPed_DB_DELETE) {
				if ($this->debug) debug("BORRANDO (marcando flags)...");
				$this->_aFlags['calculos_iva'] |= inmPed_DB_DELETE;
				$this->_aFlags['calculos_iva'] |= inmPed_DB_COMMIT;
				$this->_aFlags['descuentos'] |= inmPed_DB_DELETE;
				$this->_aFlags['descuentos'] |= inmPed_DB_COMMIT;
				$this->_aFlags['detalles'] |= inmPed_DB_DELETE;
				$this->_aFlags['detalles'] |= inmPed_DB_COMMIT;
				$this->_change_flags(IEInvoice_EFFECTS | (inmPed_DB_DELETE | inmPed_DB_COMMIT));
				$this->_change_flags(IEInvoice_COMMISSIONS | (inmPed_DB_DELETE | inmPed_DB_COMMIT));
				if ($this->getId()) $this->linkIConta(FALSE);
				if (is_array($this->_aDetalles))
					foreach ($this->_aDetalles as $idx => $aNull)
						$this->del_detail($idx,FALSE);
				if (!is_numeric($this->getId())) return FALSE;
				$this->_db->tb_delete("Facturas",array("id_factura" => $this->getId()));
				if ($this->getInstallment()) {
					$this->_db->tb_delete("Facturas_abonos",array("id_factura_abono" => $this->getId()));
				} else {
					$this->_db->tb_delete("Facturas_abonos",array("id_factura" => $this->getId()));
				}
				$this->_db->tb_delete("Pedidos_facturas",array("id_factura" => $this->getId()));
				if ($this->debug) 
					debug("Molaria resetear el contador caso de ser el ultimo pedido realizado (".(int)$this->getReference.")");

			} elseif ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
				if ($this->debug) debug("Buscando numeracion para la referencia y la fecha...");
				$ref = $this->getReference();
				if (empty($ref)) {
					if ($bGetRef) $this->setReference(NULL,true);
					else {
						$tini = strtotime(date("Y-m-d H:i")); 
						$tfin = strtotime($this->getDate());
						// Fixme: Permitir la configuracion de este plazo
						$tDiasplazo = (60 * 60 * 24) * 5;
						// debug("Fra de $tfin cundo ahora: $tini");
						if ($tfin <= ($tini + $tDiasplazo)) $this->setReference();
					}
				}
				// Los productos de Servicio no Establecen Fecha.
				// $date = $this->get_date();
				// if (empty($date)) $this->set_date();
				if ($this->_aFlags['pedido'] & inmPed_DB_NEWRECORD) $this->_aPedido['id_factura'] = NULL;

				if ($this->_fPedido & inmPed_VENTA) 
					if (!is_numeric($this->_aPedido['id_cliente']) OR empty($this->_aPedido['id_cliente'])) {
						$this->error('INVOICE_NORECIEVER',array('ref' => $this->getReference()));
						return FALSE;
					} else {
						$this->_aPedido['id_proveedor'] = NULL;
					}
				else 
					if (!is_numeric($this->_aPedido['id_proveedor']) OR empty($this->_aPedido['id_proveedor'])) {
						$this->error('INVOICE_NOISSUER',array('ref' => $this->getReference()));
						return FALSE;
					} else {
						$this->_aPedido['id_cliente'] = NULL;
					}
				// TODO: Comprobar que el ratio es el que tiene que ser (junto con el dbfill)
				$aFra = $this->_aPedido;
				$aFra['ratio_divisa'] = $this->_aDivisa['ratio'];
				$aFra['base_imponible'] = $this->_aTotales['base_imponible'];
				$aFra['total_impuestos'] = $this->_aTotales['impuestos'] + $this->_aTotales['recargos'];
				//Fixme: $this->_aPedido['monto_cuenta'] = $this->_aTotales['monto_cuenta'];
				$aFra['descuento'] = $this->_aTotales['descuentos'];
				$aFra['retenido'] = $this->_aTotales['retenido'];
				$aFra['monto_cuenta'] = $this->_aTotales['monto_cuenta'];
				$aFra['monto_total'] = $this->_aTotales['importe'];
				$aFra['total_bruto'] = $this->_aTotales['bruto'];
				$aFra['estado'] = $this->getStatus();
				$aFra['notas'] = $this->_aPedido['observaciones'];
				if ((int)$this->_aPedido['id_factura']) {
					if ($this->debug) debug("Updateamos la factura...");
					$this->_db->tb_update("Facturas",$aFra);
				} else {
					if ($this->debug) debug("Insertando un nueva factura en la db...");
					$this->_db->tb_replace("Facturas",$aFra);
					$this->_aPedido['id_factura'] = $this->_db->last_insert_id();
				}

				// Como en setInstallment podemos no tener todavia  este id_factura
				//   es aqui, en el dump, donde se comprubea -caso de ser eso una factura de abono- la factura a la que se abona
				if (is_array($this->_aIDFacturaAbono) AND sizeof($this->_aIDFacturaAbono)) {
					foreach ($this->_aIDFacturaAbono as $aFra) {
						if (!(int)$aFra['_dbfetch'] AND (int)$aFra['_abonar']) {
							if ($this->getInstallment()) {
								$aTmp = NULL;
								$aTmp['id_factura_abono'] = $this->getId();
								$aTmp['id_factura'] = $aFra['id_factura'];
								$this->_db->tb_replace('Facturas_abonos',$aTmp);
							} else {
								$aTmp = NULL;
								$aTmp['id_factura'] = $this->getId();
								$aTmp['id_factura_abono'] = $aFra['id_factura'];
								$this->_db->tb_replace('Facturas_abonos',$aTmp);
							}
						}
					}
				}
				
			}
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
		} elseif ($this->debug) debug("La cabecera del pedido no se ha tocado...");

		if ( ($this->_aFlags['calculos_iva'] & inmPed_DB_COMMIT) ) {
			if ($this->debug) debug("Volcamos los ivas...".$this->_aFlags['calculos_iva']);
			if ($this->_aFlags['calculos_iva'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_factura']) {
				$cons = 'DELETE FROM IVAs WHERE '.
						'(!id_pedido OR id_pedido IS NULL OR id_pedido=0) AND '.
						'(!id_presupuesto OR id_presupuesto IS NULL OR id_presupuesto=0) AND '.
						' id_factura = '.$this->_aPedido['id_factura'];
				$this->_db->query($cons);
			} elseif ((int)$this->_aPedido['id_factura']) {
				$this->_build_taxes();
				if (is_array($this->_aIVAs['detalle']))
					foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva) {
						$aIva['id_iva'] = $id_iva;
						// $aIva['id_pedido'] = $this->_aPedido['id_pedido'];
						$aIva['id_factura'] = $this->_aPedido['id_factura'];
						$aIva['monto'] = $aIva['base_imponible'];
						$aIva['bruto'] = $aIva['bruto'];
						$aIva['recargo_iva'] = $aIva['total_iva'];
						$aIva['recargo_equivalente'] = $aIva['total_recargo'];
						if ($this->debug) print_r($aIva);
						$this->_db->tb_replace("IVAs",$aIva);
					}
				elseif ($this->debug) debug("No hay IVAs que volcar...");
				if (is_array($this->_aIva_dbdel) AND sizeof($this->_aIva_dbdel))
					foreach ($this->_aIva_dbdel as $aIva_del) {
						if (!isset($aIva_del['id_iva'])) continue;
						if (!isset($aIva_del['id_factura'])) 
							if (empty($this->_aPedido['id_factura'])) continue;
							else $aIva_del['id_factura'] = $this->_aPedido['id_factura'];

						if (empty($aIva_del['id_pedido'])) {
							unset($aIva_del['id_pedido']);
							$this->_db->tb_delete("IVAs",$aIva_del);
						} else {
							$aTmp['id_factura'] = 0;
							$aTmp['id_iva'] = $aIva_del['id_iva'];
							$aTmp['id_pedido'] = $aIva_del['id_pedido'];
							$aFld[] = "id_pedido";
							$aFld[] = "id_iva";
							$this->_db->tb_update("IVAs",$aTmp,$aFld);
						}
					}
			} else $this->error('INVOICE_NODBRECORD');
				//$this->error(404,"Me falta el id de Pedido para insertar los IVAs en la bbdd.");
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK);
		} else if ($this->debug) debug("Los IVAs no se han tocado...");


		if ($this->debug) debug("<b>INICIAMOS LOS DESCUENTOS</b>");
		if ($this->_aFlags['descuentos'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("Volcamos los descuentos...");
			if ($this->_aFlags['descuentos'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_factura']) {
				$cons = "DELETE FROM Descuentos WHERE (!id_pedido OR id_pedido IS NULL OR id_pedido=0) AND ".
							" id_factura = ".$this->_aPedido['id_factura'];
				$this->_db->query($cons);
			} elseif ((int)$this->_aPedido['id_factura']) {
				if (!is_array($this->_aDescuentos['detalle'])) $this->calculate();
				if (is_array($this->_aDescuentos['detalle']))
					foreach($this->_aDescuentos['detalle'] as $aDto) {
						// $aDto['id_pedido'] = $this->_aPedido['id_pedido'];
						$aDto['id_factura'] = $this->_aPedido['id_factura'];
						$aDto['monto_base'] = $aDto['base_imponible'];
						$aDto['porcentaje'] = $aDto['descuento'];
						$aDto['monto_final'] = $aDto['importe'];
						$aDto['financiero'] = (int)$aDto['financiero'];
						if ($this->debug) debug("Replace de descuentos:");
						if ($this->debug) print_r($aDto);
						$this->_db->tb_replace("Descuentos",$aDto);
					}
				elseif ($this->debug) debug("No hay Dscuentos que volcar...");
			} else $this->error('INVOICE_NODBRECORD');
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK);
		} else if ($this->debug) debug("Los DESCUENTOS NO se han tocado...");
		if ($this->debug) debug("<hr>");

		if ($this->_aFlags['asiento'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug('Volcando Asiento ...');
			if ($this->_aFlags['asiento'] & inmPed_DB_DELETE) {
				$icontadb = $this->getFromCfg('iconta_dbname');
				$icontacfgdb = $this->getFromCfg('iconta_dbcfgname');
				if (empty($icontadb) OR empty($icontacfgdb)) {
					debug("No hay conectores, asi que tampoco volcado. ");
					$this->error('INVOICE_ACENTRY_FAILED',array());
					return false;
				}

				if ($this->debug)
					debug("Creando instancia Asiento .. ($icontadb) ($icontacfgdb)");
				if ($this->getMode() & inmPed_VENTA) 
					$oAsiento = new AccountEntry($this->App_Name,$icontadb,$icontacfgdb,ICEntry_MODE_SALE | ICEntry_MODE_CHECK_TAX);
				else 
					$oAsiento = new AccountEntry($this->App_Name,$icontadb,$icontacfgdb,ICEntry_MODE_BUY | ICEntry_MODE_CHECK_TAX);
				if (!is_object($oAsiento)) {
					$this->error('INVOICE_ACENTRY_FAILED');
					return FALSE;
				}
				$id_asiento = $this->getAccounted();
				if ($this->debug) debug("El id_asiento : $id_asiento");
				if (is_numeric($id_asiento)) {
					if ($oAsiento->dbFill($id_asiento)) {
						$oAsiento->delete();
						$oAsiento->dbDump();
					} else {
						// Si no ha podido rellenar el id_asiento, sera porque el metodo (un)linkIConta ha borrado el asiento marcando el del efecto para borrado
						// $this->error('ACENTRY_DBFILL_FAIL',array('id' => $id_asiento));
						debug("Invoice::Asiento->dbFill() Failed!!! ");
					}
					$this->_aPedido['id_asiento'] = 'null';
					$this->_aPedido['contabilizado'] = 0;
					$aTmp['id_asiento'] = $this->_aPedido['id_asiento'];
					$aTmp['contabilizado'] = $this->_aPedido['contabilizado'];
					$aTmp['id_factura'] = $this->_aPedido['id_factura'];
					$this->_db->tb_update('Facturas',$aTmp);
					$this->_change_flags(IEInvoice_ACCOUNTENTRY | inmPed_OK);
				}
			}
		} elseif ($this->debug) debug("Asiento No-Borrado");


		if ($this->_aFlags['efectos'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("VOlcando Efectos...");
			if ($this->_aFlags['efectos'] & inmPed_DB_DELETE) {
				if ($this->debug) debug("... borrando Efectos");
				// if ($this->debug) print_r($this->_aEfectos);
				$aTmpEDel = array();
				if (is_array($this->_aEfectos))
					foreach ($this->_aEfectos as $idx => $aEff) {
						if (is_array($aEff)) {
							if (is_numeric($aEff['id_efecto']) AND $aEff['id_factura']==$this->getId())
								array_push($aTmpEDel,array('id_efecto' => $aEff['id_efecto']));
						} elseif (is_a($aEff,'Draft')) {
							// Si el efecto pertenece a esta factura, probamos a borrarlo
							if ($this->getId() == $aEff->getAttribute('id_factura')) $this->_aEfectos[$idx]->delete();
							$this->_aEfectos[$idx]->Dump();
						}
					}
				if (is_array($aTmpEDel) AND sizeof($aTmpEDel)) {
					$this->_db->tb_delete('Efectos',$aTmpEDel);
					$this->_db->tb_delete('Efectos_parciales',$aTmpEDel);
					$this->_aEfectos = array();
				}
				$aTmpEDel = NULL;
				$this->_change_flags(IEInvoice_EFFECTS | inmPed_OK);
			} else {
				if (!$this->getIssued()) {
					$this->_change_flags(IEInvoice_EFFECTS | inmPed_OK);
				} elseif(is_array($this->_aEfectos)) {
					$done = false;
					foreach ($this->_aEfectos as $ide => $aEff) {
						$done = true;

						if (is_array($aEff)) {
							if ($this->_aConf['round_drafts']) $aEff['monto'] = round($aEff['monto'],2);
							if (!is_numeric($aEff['id_factura'])) {
								$aEff['id_factura'] = $this->getId();
								$aEff['concepto'] = 'Su Factura Nº '.$this->getReference();
								if (!is_numeric($aEff['id_factura'])) {
									$done = false;
									break;
								}
							}
							if ($aEff['id_factura'] == $this->getId()) {
								if (is_numeric($aEff['id_efecto'])) 
									$this->_db->tb_update('Efectos',$aEff);
								else {
									$this->_db->tb_insert('Efectos',$aEff);
									$this->_aEfectos[$ide]['id_efecto'] = $this->_db->last_insert_id();
								}
							}
						} elseif (is_a($aEff,'Draft')) {
							$this->_aEfectos[$ide]->Dump();
						}
					}
					if ($done) {
						$this->_change_flags(IEInvoice_EFFECTS | inmPed_OK);
					}
				}
			}
		} else {
			if ($this->debug) debug("No se han tocado los efectos");
		}

		// Comprobamos las Comisiones de los agentes
		if ($this->_aFlags['comisiones'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("VOlcando Comisiones...");
			if ($this->_aFlags['comisiones'] & inmPed_DB_DELETE) {
				if ($this->debug) {
					debug("... borrando");
					print_r($this->_aAgentes_comisiones);
				}
				$aTmpEDel = array();
				if (is_array($this->_aAgentes_comisiones))
					foreach ($this->_aAgentes_comisiones as $aAgC) 
						if (is_numeric($aAgC['id_agente']))
							array_push($aTmpEDel,array('id_agente' => $aAgC['id_agente'], 'id_factura' => (int)$this->getId()));
				if (is_array($aTmpEDel) AND sizeof($aTmpEDel)) {
					$this->_db->tb_delete('Agentes_facturas',$aTmpEDel);
				}
				$aTmpEDel = NULL;
				$this->_change_flags(IEInvoice_COMMISSIONS | inmPed_OK);
			} else {
				if (0 AND !$this->getIssued()) {
					$this->_change_flags(IEInvoice_COMMISSIONS | inmPed_OK);
				} elseif(is_array($this->_aAgentes_comisiones)) {
					$done = FALSE;
					foreach ($this->_aAgentes_comisiones as $idag => $aAgC) {
						$done = TRUE;
						$aTmp['id_factura'] = $this->getId();
						$aTmp['id_agente'] = $aAgC['id_agente'];
						$aTmp['monto'] = round($aAgC['importe_comision'],$this->tot_decimals);
						$aTmp['monto_liquidado'] = $aAgC['importe_comision_liquidado'];
						if ((int)$aAgC['_dbfetch']) {
							$this->_db->tb_update('Agentes_facturas',$aTmp);
						} else {
							$this->_db->tb_replace('Agentes_facturas',$aTmp);
						}
					}
					if ($done) {
						$this->_change_flags(IEInvoice_COMMISSIONS | inmPed_OK);
					}
				}
			}
		} else {
			if ($this->debug) debug("No se han tocado las comisiones");
		}

		if ($this->debug) {
			debug("Albaranes!!");
			print_r($this->_aIDAlbaran);
		}

		$this->_updateClientAccount();

		if ($this->_aFlags['detalles'] & inmPed_DB_COMMIT) {
			$aBorrarDet = array();
			$aPedFra = array();
			if(!is_array($this->_aIDAlbaran) OR !sizeof($this->_aIDAlbaran)) $hay_albaranes = 0;
			else $hay_albaranes = 1;
			if ($this->_fPedido & inmPed_VENTA) $op_sign = '+';
			else $op_sign = '-';
			foreach($this->_aModif['detalles'] as $idx_det => $estado) {
				$aDet = $this->get_detail($idx_det);
				if (is_numeric($aDet['id_pedido']) AND !in_array($aDet['id_pedido'],$aPedFra)) array_push($aPedFra,$aDet['id_pedido']);

				// Fixme: Actualizar los socks cuando se borra o modifican cantidades.
				if ($estado & inmPed_DB_DELETE) {
					if ($this->debug) debug("Habria que borrar este detalle($idx_det)... si");
					// Meter este id_detalle dentro de un array de id_detalles a borrar.
					array_push($aBorrarDet,$idx_det);
					if (is_numeric($this->_aDet_dbdel[$idx_det]['id_detalle']) AND !empty($this->_aDet_dbdel[$idx_det]['id_detalle'])) {
						$idart = $this->_aDet_dbdel[$idx_det]['id_articulo'];
						if (!is_numeric($idart) or empty($idart)) {
							$this->error('INVOICE_NOIDPRODUCT',array('idx' => $idx_det));
							continue;
						}
						// debug("Indice a borrar:");
						// print_r($this->_aDet_dbdel[$idx_det]);
						$this->_db->tb_delete('Facturas_detalle',
								array('id_factura' => $this->_aPedido['id_factura'],'id_detalle' => $this->_aDet_dbdel[$idx_det]['id_detalle']));

						// Quitamos este id_pedido de los pedidos que conforman la factura
						if (is_numeric($aDet['id_pedido'])) $aPedFra = array_diff($aPedFra,array($aDet['id_pedido']));

						// debug("Quitando el id_pedido: ".$aDet['id_pedido']);
						// print_r($aPedFra);

						/** **/
						if (!$this->getInstallment() AND !$this->isDetailDelivered($this->getDetailAttribute($idx_det,'id_detalle')) ) {
							// Actualizamos la cantidad que hay ahora mismo en stock en la DB.
							if (is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_db']))
								$cant_org = $this->_aDet_dbdel[$idx_det]['cantidad_db'];
							else $cant_org = 0;

							//FixMe: Comprobar aqui, mejor, si el id_detalle tiene albaranes (no el documento completo)
							// if ($cant_org != $cant_act AND (!$hay_albaranes) ) 

							if (is_numeric($this->_aDet_dbdel[$idx_det]['id_pedido']) AND
									is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_pedida'])) {
								$cant_act = $this->_aDet_dbdel[$idx_det]['cantidad_pedida'];
								$this->_aDet_dbdel[$idx_det]['cantidad_db'] = $cant_act;
							} else $cant_act = 0;
							if ($cant_org != $cant_act) {
								$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
											"WHERE id_articulo = ".$idart." AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
								$this->_db->query($cons);
							}
						}
						/** **/
						$idart = NULL;
					}
				} elseif ($estado & inmPed_DB_COMMIT) {
					if ($this->debug) debug("Detalle $idx_det no actualizado");
					$aTmp = $this->get_detail($idx_det);
					if (!(int)$aTmp['id_pedido'] AND (int)$this->_aPedido['id_pedido'])
						$aTmp['id_pedido'] = $this->_aPedido['id_pedido'];
					// $aTmp['cantidad'] = $aTmp['cantidad_pedida'];
					$aTmp['precio_articulo'] = $aTmp['precio_tarifa'];
					$aTmp['monto_total'] = $aTmp['base_imponible'];
					if ($this->debug) debug("Linea de detalle");
					if ($this->debug) print_r($aTmp);

					if (!(int)$aTmp['id_detalle']) {
						if ($this->debug) debug("Detalle $idx_det No esta en la DB. Actualizando indices...");
						$this->_db->tb_replace("Lineas_detalle",$aTmp);
						$this->_aDetalles[$idx_det]['id_detalle'] = (int)$this->_db->last_insert_id();
						$this->_aDetIdx[$this->_aDetalles[$idx_det]['id_detalle']] = $idx_det;
					} else {
						if (!(int)$aTmp['id_pedido'] AND ($estado & (inmPed_CHG_DET_QUANTITY | inmPed_CHG_DET_PRICE | inmPed_CHG_DET_DISCOUNT))) 
							$this->_db->tb_update("Lineas_detalle",$aTmp);
					}

					// A la par volcamos Facturas_detalle
					$aTmpDetFra['id_detalle'] = $this->_aDetalles[$idx_det]['id_detalle'];
					$aTmpDetFra['id_factura'] = $this->_aPedido['id_factura'];
					$aTmpDetFra['cantidad'] = $this->get_quantity($idx_det);
					$aTmpDetFra['notas'] = $this->get_detail_comment($idx_det);
					$aTmpDetFra['importe'] = $this->get_detail_ammount($idx_det);
					$aTmpDetFra['iextra1'] = $this->getDetailAttribute($idx_det,'iextra1');
					$aTmpDetFra['iextra2'] = $this->getDetailAttribute($idx_det,'iextra2');
					$aTmpDetFra['iextra3'] = $this->getDetailAttribute($idx_det,'iextra3');
					$aTmpDetFra['iextra4'] = $this->getDetailAttribute($idx_det,'iextra4');
					if ($this->debug)
						debug("<br>whos ur daddy? cantidad_recibida(".empty($aTmp['cantidad_recibida']).") - hay_albaranes(".$hay_albaranes.") - ".$aTmpDetFra['cantidad']);

					if ($estado & inmPed_CHG_DET_QUANTITY AND !$this->getInstallment()) {
						/** En las facturas _NO_ se actualiza el stock, ni estimado ni nada, si se quiere modificar una factura por la razon
						  que quiera la empresa/operario, perfecto, pero no por problemas operativos (mercaderia en mal estado, etc...) porque
						  sino eso se haria en albaranes. (si los hay)
						/** **/
						// Actualizamos la cantidad que hay ahora mismo en la DB.
						if (is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_db']))
							$cant_org = $this->_aDet_dbdel[$idx_det]['cantidad_db'];
						else $cant_org = 0;
						if (is_numeric($aTmp['cantidad']))
							$cant_act = $aTmp['cantidad'];
						else $cant_act = 0;
						// El stock estimado _solo_ se modifica cuando _no_ hay albaranes.
						if ($cant_org != $cant_act AND (!$this->isDetailDelivered($this->getDetailAttribute($idx_det,'id_detalle'))) ) {
							$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
										"WHERE id_articulo = ".$aTmp['id_articulo']." AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
							$this->_db->query($cons);
						}
						$this->_aDet_dbdel[$idx_det]['cantidad_db'] = $cant_act;
					}

					$this->_db->tb_replace('Facturas_detalle',$aTmpDetFra);
	
				} elseif ($this->debug) debug("Nada que hacer para este detalle($idx_det)...");
			}
			
			// Borramos los que haya que borrar
			// Aqui quitamos los IDs en albaranes, para no borrar sus Lineas_detalle
			if (is_array($this->_aIDAlabaran) AND sizeof($this->_aIDAlbaran)) {
				$aDetAlb = array();
				// Comprobamos los detalles de nuestro Albaran.
				$cons = "SELECT DISTINCT Li.id_detalle as 'id_detalle' ".
							"FROM Lineas_detalle `Li`, Detalles_albaran `DA`, Albaranes `Alb`,  ".
							"WHERE DA.id_detalle = Li.id_detalle AND DA.id_albaran = Alb.id_albaran ".
							"AND Li.id_detalle = FraDet.id_detalle AND FraDet.id_factura = ".$this->getId();
				if ($this->debug) debug("query : $cons");
				$idrs = $this->_db->query($cons);
				if ($this->_db->num_rows($idrs)) 
					while ($aTmp = $this->_db->fetch_assoc($idrs)) {
						foreach ($this->_aDet_dbdel as $i => $aVal) 
							if ($aVal['id_detalle'] == $aTmp['id_detalle']) {
								$idx = $i;
								break;
							}
						if (isset($idx)) {
							array_push($aDetAlb,$idx);
							$idx = NULL;
						}
					}
				$this->_db->libera($idrs);
			}

			// COMPROBAR TICKETS TAMBIEN Tambien en la clase Order !!!
			if (is_array($this->_aIDTickets) AND sizeof($this->_aIDTickets)) {
				$aDetTkt = array();
				// Comprobamos los detalles de nuestra Factura.
				$cons = "SELECT DISTINCT Li.id_detalle as 'id_detalle' ".
							"FROM Lineas_detalle `Li`, Facturas_detalle `DF`, Facturas `Fac`, Tickets_detalle `TD` ".
							"WHERE DF.id_detalle = Li.id_detalle AND DF.id_factura = Fac.id_factura AND ".
							"DF.id_detalle = TD.id_detalle AND Fac.id_factura = ".$this->getId();
				if ($this->debug) debug("query : $cons");
				$idrs = $this->_db->query($cons);
				if ($this->_db->num_rows($idrs)) 
					while ($aTmp = $this->_db->fetch_assoc($idrs)) {
						foreach ($this->_aDet_dbdel as $i => $aVal) 
							if ($aVal['id_detalle'] == $aTmp['id_detalle']) {
								$idx = $i;
								break;
							}
						if (isset($idx)) {
							array_push($aDetTkt,$idx);
							$idx = NULL;
						}
					}
				$this->_db->libera($idrs);
			}

			$this->dbDeleteContracts();

			if (sizeof($aDetAlb)) $aToDelete = array_diff($aBorrarDet,$aDetAlb);
			else $aToDelete = $aBorrarDet;
			if (sizeof($aDetTkt)) $aToDelete = array_diff($aToDelete,$aDetTkt);

			foreach ($aToDelete as $i => $id) {
				if ((int)$this->_aDet_dbdel[$id]['id_detalle']) {
					if (!is_array($aDelete_Det)) $aDelete_Det = array();
					$idped = $this->_aDet_dbdel[$id]['id_pedido'];
					/** ** ya _no_ se actualiza stock estimado desde la factura. si _solo_ hay pedido **/
					// Actualizamos Stock y metemos el id_detalle en el array para tb_delete()
					if (is_numeric($this->_aDet_dbdel[$id]['cantidad_db']))
						$cant_org = $this->_aDet_dbdel[$id]['cantidad_db'];
					else $cant_org = 0;
					if (is_numeric($idped) AND 
							is_numeric($this->_aDet_dbdel[$id]['cantidad_pedida']))
						$cant_act = $this->_aDet_dbdel[$id]['cantidad_pedida'];
					else $cant_act = 0;
					$id_art = (int)$this->_aDet_dbdel[$id]['id_articulo'];
					$id_det = (int)$this->_aDet_dbdel[$id]['id_detalle'];
					// debug("idped: $idped   -  org: $cant_org ped: $cant_act");
					// Nos da = lo que tenga el pedido, actualizamos el stock_ficticion cuando se borre un detalle
					if ( (!$hay_albaranes) AND (($cant_act!=0 AND $cant_org != $cant_act) OR (empty($idped) AND !empty($cant_org))) ) {
  						$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
									"WHERE id_articulo = $id_art AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
						$this->_db->query($cons);
					}
					/** **/

					if (empty($this->_aDet_dbdel[$id]['id_pedido']))
						array_push($aDelete_Det,array('id_detalle' => $id_det));
					if ($this->debug) debug("Detalle borrado($id_det), Actualizando stock...");
					$idped = NULL;
				} else if ($this->debug) debug("solicitud de borrado de un detalle($id) sin id_detalle...");
			}

			if (is_array($aDelete_Det) AND sizeof($aDelete_Det)) $this->_db->tb_delete("Lineas_detalle",$aDelete_Det);
			$this->_change_flags(inmPed_CHG_DETAIL | inmPed_OK);
			$this->_change_flags(inmPed_CHG_DETAIL & ~inmPed_DB_COMMIT);
		} else if ($this->debug) debug("Los DETALLES NO se han tocado");

		// Volcamos la relacion que haya con los pedidos.
		if (is_array($aPedFra) AND sizeof($aPedFra)) 
			foreach ($aPedFra as $idped) {
				if (!empty($idped) AND !is_array($this->_aIDPedido[$idped])) {
					$aTmp = array();
					$aTmp['id_factura'] = $this->getId();
					if (is_numeric($aTmp['id_factura'])) {
						$aTmp['id_pedido'] = $idped;
						// Sobra si actualizamos mas abajo a partir de _aIDPedido: 
						$this->_db->tb_replace('Pedidos_facturas',$aTmp);
						$aTmp['_dbfetch'] = 1;
						$this->_aIDPedido[$idped] = $aTmp;
					}
				}
			}

		if ($this->debug) {
			debug("Pedidos :");
			print_r($this->_aIDPedido);
		}
		if (is_array($this->_aIDPedido) AND sizeof($this->_aIDPedido)) {
			foreach ($this->_aIDPedido as $idped => $aPed) {
				if ((int)$aPed['_dbfetch']) continue;
				if (!is_numeric($aPed['id_pedido'])) continue;
				if (!is_numeric($aPed['id_factura'])) {
					$aPed['id_factura'] = $this->getId();
					$this->_aIDPedido[$idped]['id_factura'] = $aPed['id_factura'];
				}
				if (!is_numeric($aPed['id_factura'])) break;
				if (is_array($aPedFra) AND sizeof($aPedFra) AND !in_array($aPed['id_pedido'],$aPedFra)) {
					// debug("Borrando pedido");
					$this->_db->tb_delete('Pedidos_facturas',$aPed);
				} else {
					$this->_db->tb_replace('Pedidos_facturas',$aPed);
					$this->_aIDPedido[$idped]['_dbfetch'] = 1;
				}
			}
		}

	} // Fin del dbdump()

	function dbDeleteContracts() {
			
		// Comprobando si hay contratos completos que se desean borrar.
		$aToDelete = array();
		foreach ($this->_aDet_dbdel as $aDel) 
			if (is_numeric($aDel['id_servicio']) AND !empty($aDel['id_servicio'])) {
				if (!is_array($aToDelete[$aDel['id_servicio']])) 
					$aToDelete[$aDel['id_servicio']] = array();
				array_push($aToDelete[$aDel['id_servicio']],array('id_articulo' => $aDel['id_articulo'],
														'cantidad' => $aDel['cantidad_db'], 'importe' => $aDel['price']) );
			}

		if (is_array($aToDelete) AND sizeof($aToDelete))  {
			$IDFs = array_keys($this->_aIDFactura);
			foreach ($aToDelete as $id_servicio => $aArticulos) {
				foreach ($aArticulos as $aArt) {
					$str_where .= ((!empty($str_where)) ? ' AND ' : ' ').
							'(Ld.id_articulo = '.$aArt['id_articulo'].' AND Ld.id_servicio = '.$id_servicio.
							' AND ( Ld.cantidad = \''.$aArt['cantidad'].'\' OR Ld.precio_articulo = \''.$aArt['importe'].'\' ))';
				}

				$i = 0;
				$cons = 'SELECT FD.id_factura,FD.id_detalle,Ld.id_articulo,Ld.id_servicio '.
							'FROM Facturas_detalle `FD`, Lineas_detalle `Ld`, Facturas `F` '.
							'WHERE F.estado = 0 AND F.id_factura = FD.id_factura AND Ld.id_detalle=FD.id_detalle '.
							' AND F.fecha > '.wol_db::formatear_fecha($this->getDate()).' AND ( ';
				foreach ($IDFs as $idf) if (is_numeric($idf)) $cons .= ((!$i++) ? '' : ' OR ').'FD.id_factura = '.$idf;
				$cons .= ') AND '.$str_where.' ORDER BY FD.id_factura ';
				$rs = $this->_db->query($cons);
				if ($this->_db->num_rows($rs)) {
					$last_id = 0;
					while ($aTmp = $this->_db->fetch_assoc($rs)) {
						if ($last_id != $aTmp['id_factura']) {
							$oFra = NULL;
							$oFra = new Invoice($this->App_Name,$this->_db_name,$this->getMode());
							$oFra->dbFill($aTmp['id_factura']);
							$idx = $oFra->get_idxdetail_db($aTmp['id_detalle']);
							if (!is_numeric($idx)) continue;
							if ($oFra->num_details() == 1) $oFra->delete();
							else $oFra->del_detail($idx);
							$oFra->dbdump();
							$last_id = $aTmp['id_factura'];
						}
					}
				}
				$this->_db->libera($rs);
			}
		}

	}

	/** Fin de los metodos de funcionalidades **/

} /**************** FIN DE LA CLASE ******************/

function nodb_invoice_deliveredto(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $aCfg;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}
	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');

	if (!$done OR $reset) {
		$done = 1;

		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_reciever_info();
		if (empty($aRetVal['direccion'])) $aRetVal['direccion'] = $aRetVal['direccion_facturacion'];
		if (method_exists($oPedido,'get_reciever_address')) $aTmp = $oPedido->get_reciever_address(false);
		elseif ((int)$aCfg['print_invoice_delivery'] AND is_a($oPedido,'Invoice')) {
			$aTmp = NULL;
			$aPeds = $oPedido->getOrders();
			if (is_array($aPeds) AND sizeof($aPeds)) {
				$baseact = 0;
				$id_dir = 0;
				foreach ($aPeds as $id => $aP) 
					if (abs($aP['base_imponible']) > $baseact) {
						$id_dir = $aP['id_direccion'];
						$baseact = abs($aP['base_imponible']);
					}
				if (!empty($id_dir)) {
					$oDb = $oPedido->_db;
					$cons = 'SELECT Direcciones_entrega.nombre, direccion, cp, poblacion, P.nombre as "provincia", telefono1, email, fax, '.
								'persona_contacto, cargo_persona_contacto, observaciones '.
								'FROM Direcciones_entrega LEFT JOIN Provincias P ON (Direcciones_entrega.id_provincia=P.id_provincia) '.
								'WHERE Direcciones_entrega.id_direccion = '.$id_dir;
					$tmprs = $oDb->query($cons);
					if ($oDb->num_rows($tmprs)) $aTmp = $oDb->fetch_assoc($tmprs);
					$oDb->libera($tmprs);
				}
			} 
		}

		if (is_array($aTmp) AND sizeof($aTmp))
			foreach ($aTmp as $campo => $valor) {
				if (is_array($valor)) break;
				$aRetVal[$campo] = $valor;
			}

		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_invoice_installments(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $aCfg;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aFras = $aBlocks[$block_name]['extras'];
	}
	if (empty($obj_var)) {
	   $docvar = $Sesion->get_var('__document_iface_varname');
	   if (empty($docvar)) $docvar = 'oPedido_en_curso';
	   $obj_var = $docvar;
	}
	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');

	if (!isset($done) OR $reset) {
		$oPedido = $Sesion->get_var($obj_var);
		if (!is_object($oPedido)) return NULL;

		$aTmp = NULL;
		$aFras = $oPedido->getInstalledInvoices();
		$done = 1;
		$reset = 0;
	}

	if (!is_array($aFras) OR empty($aFras)) {
		$reset = 1;
		$aRetVal = NULL;
	} else {
		$aS = array_pop($aFras);
		foreach ($aS as $campo => $valor)
			$aRetVal[$campo] = $valor;
	}

	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aFras;
	return $aRetVal;
}

}
