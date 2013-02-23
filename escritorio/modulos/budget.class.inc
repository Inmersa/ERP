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

if (!defined('__inmersa_budget_class_inc')) {
define('__inmersa_budget_class_inc',TRUE);

class Budget extends Document {
	var $ST_READY		=	1;
	var $ST_LOCKED		=	2;

	var $STDOC_NONE		=	0;
	var $STDOC_REVIEWED	=	1;
	var $STDOC_APPROVED	=	2;
	var $STDOC_REJECTED	=	-1;
	var $STDOC_PASSED		=	3;

	var $_aCfg = array(			// Configuracion de las instancias de tipo factura.
		'round_drafts' => true	// Si el iporte de la factura ha de ser redondeado antes de insertar el efecto(s) de la factura.
		);

	var $_aIDPedido;				// Array indexado por ids con los pedidos de la factura.

	var $_aIDFactura;				// Array indexado por ids con las facturas(_todas_) relacionadas con los pedidos.

	var $_aEfectos;				// Array indexado de los efectos de la factura

	/** Constructor: (TODO: Retocar para usar el constructor de Document)
		* @param $tipo			-	Indica si el pedido es de compra o de venta (ver defines).
		* @param $doc_type	-	Indica si es un pedido o un presupuesto.(bool)
	 **/
	function Budget($App_Name = NULL,$db_name,$tipo = inmPed_VENTA,$doc_type = 0)  {

		if (empty($App_Name)) $this->App_Name = "Sesion";
		else $this->App_Name = $App_Name;
		$App_Name = $this->App_Name;
		if ($this->debug) debug("Constructor de Presupuesto ... ".$this->App_Name);

		parent::Document($App_Name,$db_name,$tipo,$doc_type);

		$this->set_db($db_name);

		$this->_db_name = $db_name;
		// global $$App_Name;
		$this->_oSesion = $GLOBALS[$this->App_Name];

		$tmp = $this->setMode($tipo);

		// Fixme: El modo stricto deberia ser una opcion
		// $this->_fPedido |= ~inmPed_STRICT;

		// Comprobamos el tipo de documento
		if ((int)$doc_type<3) $this->_bPedido = (int)$doc_type;
		else $this->_bPedido = TRUE;
		
		// Resetamos valores.
		$this->_aDetalles = $this->_aIVAs['detalle'] = $this->_aDescuentos = $this->_aTotales = NULL;
		$this->_aIva_dbdel = array();
		$this->_aServicios = array();
		$this->_aPedido['preparado'] = 0;
		$this->_aFlags['efectos'] = 0;
		$this->_aFlags['comisiones'] = 0;
		$this->_aFlags['asiento'] = 0;

		return $tmp;
	}

	function get_id() { 
		return $this->getId(); 
	}

	function get_reference() { 
		return $this->getReference(); 
	}

	/** Metodos de mantenimiento (o sobrecargados del padre) **/
	function init() {
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->set_db($this->_db_name);
		$app = $this->App_Name;
		global $$app;
		$this->_oSesion = $$app;
	}

	function cerrar() {
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		$this->_db = NULL;
		$this->_oSesion = NULL;
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

	function _updateStatus($tipo,$id = NULL) {
		$this->_change_flags($tipo,$id);
	}

	function _build_taxes() {
		if (isset($this->_aPedido['id_serie_contabilizable']) AND !(int)$this->_aPedido['id_serie_contabilizable']) {
			parent::_build_taxes(FALSE,FALSE);
		} else parent::_build_taxes();
	}

	function _calculate_totals() {
		parent::_calculate_totals();
		if (isset($this->_aPedido['id_serie_contabilizable']) AND !(int)$this->_aPedido['id_serie_contabilizable']) {
			$this->_aTotales['importe'] += $this->_aTotales['retenido'];
			$this->_aTotales['retenido'] = 0;
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
			$this->error('BUDGET_NODISCOUNT_ORDER',
					array('idx' => $idx, 'ref' => $this->_aDetalles[$idx]['nombre'], 'pedido' => $this->_aIDPedido[$idped]['nombre']));
			if ($this->debug) debug("dto: $discount pto($bPto) ($nombre)");
		} else {
			parent::set_detail_discount($idx,$discount,$bPto,$nombre,$bForce);
		}
	}

	function set_price($idx,$price = 0,$bDiscount = TRUE) {
		if (!is_numeric($idx)) return FALSE;
		if (($idped=$this->getId_pedidoFromIdx($idx))) {
			$this->error('BUDGET_NODISCOUNT_ORDER',
					array('idx' => $idx, 'ref' => $this->_aDetalles[$idx]['nombre'], 'pedido' => $this->_aIDPedido[$idped]['nombre']));
		} else {
			parent::set_price($idx,$price,$bDiscount);
		}
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

		$id_empresa = (int)$this->_aEmisor['id_empresa'];
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

	function setAgent($id) {
		if (!is_numeric($id)) return false;
		if (!$this->getAgent($id) AND !$this->addAgent($id)) return false;

		$this->setHeaderAttribute('id_agente',$id);
	}

	function set_agent($id) { return $this->setAgent($id); }

	/**
	  * Retorna un array con los datos del agente que ha realizado el pedido.
	  * @return array()	-	Los datos del agente.
	  **/
	function getAgent($id = NULL,$bComision = NULL) {
		if (!is_numeric($id)) $id = $this->getHeaderAttribute('id_agente');
		if (!is_numeric($id)) return NULL;

		if (is_array($this->_aAgentes_cliente[$id])) return $this->_aAgentes_cliente[$id];
		else return NULL;
	}

	/**
	  * Establece la referencia interna del pedido a la cadena indicada por parametro. Si la cadena no ha sido inidaca, o es nula
	  *	y el pedido no tiene referencia interna, este metodo se encarga de buscar una referencia adecuada asi como de incrementar
	  *	el contador de pedidos en la base de datos para la siguiente solicitud.
	  * Caso de recibir 0 como parametro, fuerza la busqueda de una nueva referencia.
	  **/
	function setReference($ref = NULL,$bForce = false) {
		// Fixme: Comprobar si el pedido/presupuesto es de compras o de ventas.
		if ( $bForce OR ( (!isset($ref) OR empty($ref)) AND (empty($this->_aPedido['referencia']) OR is_numeric($ref)) ) ) {
			if ($this->_fPedido & inmPed_VENTA) $sufijo = 'ventas';
			else $sufijo = 'compras';
			//crear la referencia e incrementar el contador
			if (!$this->isProforma()) {
				$consulta = "SELECT ".
								"prefijo_pre_$sufijo as 'prefijo_ped', ".
								"sufijo_pre_$sufijo as 'sufijo_ped', ".
								"contador_pre_$sufijo as 'contador_ped', ".
								"digitos_pre_$sufijo as 'digitos_ped' ".
								"FROM  Empresas where id_empresa = ".$this->_aPedido['id_empresa'];
			} else {
				$consulta = "SELECT ".
								"prefijo_pro_$sufijo as 'prefijo_ped', ".
								"sufijo_pro_$sufijo as 'sufijo_ped', ".
								"contador_pro_$sufijo as 'contador_ped', ".
								"digitos_pro_$sufijo as 'digitos_ped' ".
								"FROM  Empresas where id_empresa = ".$this->_aPedido['id_empresa'];
			}
			$idrs = $this->_db->query($consulta);
			if (!$this->_db->num_rows($idrs)) return FALSE;
			$aPrefs=$this->_db->fetch_assoc($idrs);

			//relleno de digitos para la numeracion del pedido
			$temporal = pow(10,( (int)$aPrefs['digitos_ped'] ));
			$temporal += $aPrefs['contador_ped'];
			$t = substr((string)$temporal,1);

			// $ref = $aPrefs[prefijo_ped].((!empty($aPrefs[prefijo_ped])) ? "-" : "").$t.
					  	// ((!empty($aPrefs[sufijo_ped])) ? "-" : "").$aPrefs[sufijo_ped];
			$ref = $aPrefs['prefijo_ped'].$t.$aPrefs['sufijo_ped'];
			if (!$this->isProforma()) {
				$cons= "update Empresas set contador_pre_$sufijo = contador_pre_$sufijo + 1 where id_empresa = ".$this->_aPedido['id_empresa'];
			} else {
				$cons= "update Empresas set contador_pro_$sufijo = contador_pro_$sufijo + 1 where id_empresa = ".$this->_aPedido['id_empresa'];
			}
			$this->_db->query($cons);

			/** **
			// Comprobar si es presupuesto...
			$consulta = "select prefijo_pre , sufijo_pre , contador_pre , digitos_pre ".
					 				"FROM  Empresas where id_empresa = $usuario[id]";
			$resul22=$oDb->query($consulta);
			$row22=$oDb->fetch_array($resul22);

			//relleno de digitos para la numeracion del presupuesto
			$temporal = pow(10,( (int) $row22[digitos_pre] ));
			$temporal += $row22[contador_pre];
			$t = substr((string)$temporal,1);

			$registro["referencia"] = $row22[prefijo_pre] . $t  . $row22[sufijo_pre];
			$consulta = "update Empresas set contador_pre = contador_pre + 1 where id_empresa = $usuario[id]";
			$oDb->query($consulta);
			//depurar_array($registro);
			/** **/
		} elseif (!empty($this->_aPedido['referencia'])) {
			if (!isset($ref) OR empty($ref)) return TRUE;
		}
		// debug("set_reference($ref)");
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		$this->_aPedido['referencia'] = $ref;
		return TRUE;
	}

	function getReference() {
		return $this->_aPedido['referencia'];
	}

	function getId() {
		return $this->_aPedido['id_presupuesto'];
	}

	function setId($id) {
		if (!is_numeric($id) OR empty($id)) return false;
		$this->_aPedido['id_presupuesto'] = $id;
		return true;
	}

	function setStatus($estado = NULL) {
		// Cuando Emitimos la Factura, marcar para que, al volcar a la bbdd, se haga el link con iConta
		if (!$estado) $estado = $this->STDOC_NONE;
		if (!is_numeric($estado)) return false;

		switch($estado) {
			case $this->STDOC_PASSED:
				if (is_array($this->_aIDPedido) AND sizeof($this->_aIDPedido)) {
					$this->setHeaderAttribute('estado',2);
					$this->_change_flags(inmPed_CHG_MAIN | (inmPed_MODIFIED | inmPed_DB_COMMIT));
				}
				break;
			case $this->STDOC_REJECTED:
				$this->setHeaderAttribute('estado',-1);
				$this->_change_flags(inmPed_CHG_MAIN | (inmPed_MODIFIED | inmPed_DB_COMMIT));
				break;
			case $this->STDOC_APPROVED:
				$this->setHeaderAttribute('estado',2);
				$this->_change_flags(inmPed_CHG_MAIN | (inmPed_MODIFIED | inmPed_DB_COMMIT));
				break;
			case $this->STDOC_REVIEWED:
				$this->setHeaderAttribute('estado',1);
				$this->_change_flags(inmPed_CHG_MAIN | (inmPed_MODIFIED | inmPed_DB_COMMIT));
				break;
			case $this->STDOC_NONE:
				$this->setHeaderAttribute('estado',0);
				$this->_change_flags(inmPed_CHG_MAIN | (inmPed_MODIFIED | inmPed_DB_COMMIT));
				break;

			default:
				break;
			
		}
		return TRUE;
	}

	function getStatus() {
		return (int)$this->_aPedido['estado'];
	}

	function getDate() {
		return $this->get_date();
	}

	function setDate($f = NULL) {
		$rval = parent::set_date($f);
		if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
		if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array('fecha' => $this->getDate()),'Presupuestos',false);
		if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $this->_aPedido[$fld] = $val;
		return $rval;
	}

	function getComments() {
		return $this->get_comments();
	}

	function makeOrder($id_direccion) {

		if (!is_numeric($id_direccion)) return false;
		if (empty($this->_db_name)) return false;

		if (!(int)$this->getId()) {
			$this->error('BUDGET_DBFILL');
			return false;
		}

		$aPed = $this->getOrders();
		if (is_array($aPed) AND sizeof($aPed)) return true;

		$oPedido = new Order($this->App_Name,$this->_db_name,$this->getMode());

		if (!is_object($oPedido)) {
			$this->error('BUDGET_NODOCUMENT_PARAM',array('fnc' => '_newOrder'));
			return false;
		} 

		if (!($oPedido->getMode() & $this->getMode())) {
			$this->error('BUDGET_ORDER_MODE_MISMATCH');
			return false;
		}

		$idem = $this->get_issuer_id();
		$idre = $this->get_reciever_id();
		if (!empty($idem) AND !empty($idre)) {
			$oPedido->set_issuer($this->get_issuer_id());
			$oPedido->set_reciever($this->get_reciever_id());
		} else {
			if (empty($idem)) $this->error('BUDGET_NOISSUER');
			else $this->error('BUDGET_NORECIEVER');
			return false;
		}

		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('BUDGET_LOCKED');
			return false;
		}

		if (!$oPedido->set_reciever_address($id_direccion)) {
			return false;
		}

		$divisa = $this->get_currency();
		if (isset($divisa) ) {
			$oPedido->set_currency($divisa);
		} else {
			$this->error('BUDGET_ORDER_CURRENCY_MISMATCH');
			return false;
		}

		$fpago = $this->get_payment_method();
		if (is_numeric($fpago)) {
			$oPedido->set_payment_method($fpago);
		} else {
			$this->error('BUDGET_ORDER_PAYMENT_MISMATCH');
			return FALSE;
		}

		$oPedido->setHeaderAttribute('id_tarifa',$this->getHeaderAttribute('id_tarifa'));
		$this->setDate(0);

		for ($idx = $this->first_detail(); $idx; $idx = $this->next_detail()) {
			$idart = $this->getDetailAttribute($idx,'id_articulo');
			$cantidad = $this->get_quantity($idx);
			$precio = $this->get_price($idx);

			$pedidx = $oPedido->add_detail($idart,$cantidad);
			if (!$pedidx) continue;

			$iddet = $this->getDetailAttribute($idx,'id_detalle');
			if (is_numeric($iddet)) $oPedido->setDetailAttribute($pedidx,'id_detalle',$iddet);

			$id_servicio = $this->get_detail_contract($idx);
			if (is_numeric($id_servicio)) $oPedido->set_detail_contract($pedidx,$id_servicio);

			if ($precio != $oPedido->get_price($pedidx))
				$oPedido->set_price($pedidx,$precio);

			if ($precio != $oPedido->get_price($pedidx))
				$oPedido->set_price($pedidx,$precio);

			if ($this->have_discount($idx)) {
				$aDto = $this->get_detail_discount($idx);
				if (!empty($aDto['porciento'])) {
					$bPto = true;
					$dto = $aDto['porciento'];
				} else {
					$bPto = false;
					$dto = $aDto['monto'];
				}
				$nombre = $aDto['tipo'];
				$oPedido->set_detail_discount($pedidx,$dto,$bPto,$nombre,true);

			}
		}

		if ($oPedido->num_details()) {
			$oPedido->setHeaderAttribute('id_presupuesto',$this->getId());
			$oPedido->calculate();
			$oPedido->dbDump();
			$this->_aIDPedido[$oPedido->getId()]['id_pedido'] = $oPedido->getId();
			$this->_aIDPedido[$oPedido->getId()]['id_presupuesto'] = $this->getId();
			$this->_aIDPedido[$oPedido->getId()]['referencia'] = $oPedido->get_reference();
			$this->_aIDPedido[$oPedido->getId()]['fecha'] = $oPedido->get_date();
			$this->setStatus($this->STDOC_PASSED);
		}

		return true;
	}

	function toProforma() {
		if (!(int)$this->_aPedido['factura_proforma']) {
			$this->_aPedido['es_proforma'] = 1;
			$ref = $this->getReference();
			if (!empty($ref)) $this->setReference(NULL,true);
		}
	}

	function isProforma() {
		return ( ((int)$this->_aPedido['es_proforma']) ? true : false);
	}

	/**
	  * Metodo encargado de devolver las Facturas de un Pedido.
	  **/
	function getOrders() {
		return $this->_aIDPedido;
	}

	function del_detail($idx = NULL,$bDtos = TRUE, $bServi = FALSE) {
		if (!isset($idx)) $idx = $this->_DetIdx_act;
		if ($bServi) {
			$idserv = $this->get_detail_attribute($idx,'id_servicio');
			if (!is_numeric($idserv)) $bServi = FALSE;
			else {
				$price = $this->get_price($idx);
			}
		}
		parent::del_detail($idx,$bDtos);
		if ($bServi) {
			$this->_aDet_dbdel[$idx]['id_servicio'] = $idserv;
			$this->_aDet_dbdel[$idx]['price'] = $price;
		}
	}

	/**   -- Metodos de Cabeceras y Pies -- **/
	
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
	$cons = "SELECT Pre.id_presupuesto as 'pre_id_presupuesto', ".
			  "Pre.id_empresa as 'pre_id_empresa', ".
			  "Pre.id_tarifa as 'pre_id_tarifa', ".
			  "Cli.id_cliente as 'pre_id_cliente', ".
			  "Pre.id_proveedor as 'pre_id_proveedor', ".
			  "Pre.id_divisa as 'pre_id_divisa', ".
			  "Pre.id_forma_pago as 'pre_id_forma_pago', ".
			  "Pre.id_rfq as 'pre_id_rfq', ".
			  "Pre.factura_proforma as 'pre_es_proforma', ".
			  "FPago.nombre as 'pre_nombre_forma_pago', ".
			  "FPago.nombre as 'fpa_nombre', ".
			  "FPago.id_forma_pago as 'fpa_id_forma_pago', ".
			  "FPago.num_efectos as 'fpa_num_efectos', ".
			  "FPago.dias_efectos as 'fpa_dias_efectos', ".
			  "FPago.medio_pago as 'fpa_medio_pago', ".
			  "CliEmp.dia_facturacion_1 as 'fpa_dia_I', ".
			  "CliEmp.dia_facturacion_2 as 'fpa_dia_II', ".
			  "CliEmp.dia_facturacion_3 as 'fpa_dia_III', ".
			  "Pre.referencia as 'pre_referencia', ".
			  "Pre.referencia_externa as 'pre_referencia_externa', ".
			  "Pre.observaciones as 'pre_observaciones', ".
			  "Pre.fecha as 'pre_fecha', ".
			  "Pre.estado as 'pre_estado', ".
			  "Pre.descuentos as 'tot_descuentos', ".
			  "Pre.base_imponible as 'tot_base_imponible', ".
			  "Pre.impuestos as 'tot_total_impuestos', ".
			  "Pre.retenciones as 'tot_retenido', ".
			  "Pre.importe as 'tot_importe', ".
			  "Pre.bruto as 'tot_bruto', ".
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
			  "FROM Presupuestos `Pre`, Clientes `Cli`, Clientes_empresas `CliEmp`, Forma_pago as `FPago`, ".
			  "Tarifas `Tar`, Empresas `Emp`, Divisa `Div`, Divisa `Div2`, Tipo_cliente `TCli`, Provincias `Prov`, Provincias `Prov2` ".
			  "WHERE Pre.id_presupuesto = $id AND Prov.id_provincia = Emp.id_provincia ".
			  "AND FPago.id_forma_pago = Pre.id_forma_pago AND ".
			  "Prov2.id_provincia = Cli.id_provincia AND ".
			  "Pre.id_empresa = CliEmp.id_empresa AND CliEmp.id_cliente=Cli.id_cliente AND Pre.id_cliente = CliEmp.id_cliente AND ".
			  "Pre.id_tarifa = Tar.id_tarifa AND Pre.id_empresa = Emp.id_empresa AND ".
			  "Cli.id_divisa = Div2.id_divisa AND ".
			  "Emp.id_divisa = Div.id_divisa AND CliEmp.id_tipo_cliente = TCli.id_tipo_cliente ";

	$id_rs = $oDb->query($cons);
	if ($oDb->num_rows($id_rs)) {
		$aPedido = $oDb->fetch_assoc($id_rs);
		foreach($aPedido as $clave => $valor) {
			$ref_arr = substr($clave,0,4);
			$ref_resto = substr($clave,4);
			// debug("parcial = $ref_arr, resto = $ref_resto");
			if (!strcasecmp($ref_arr,'pre_')) {
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
		$cons = "SELECT Pre.id_presupuesto as 'pre_id_presupuesto', ".
				  "Pre.id_empresa as 'pre_id_empresa', ".
				  "Pre.id_proveedor as 'pre_id_proveedor', ".
				  "Pre.id_divisa as 'pre_id_divisa', ".
				  "Pre.id_forma_pago as 'pre_id_forma_pago', ".
				  "Pre.factura_proforma as 'pre_es_proforma', ".
				  "Pre.id_forma_pago as 'pre_id_forma_pago', ".
				  "Pre.id_rfq as 'pre_id_rfq', ".
				  "Pre.referencia as 'pre_referencia', ".
				  "Pre.referencia_externa as 'pre_referencia_externa', ".
				  "Pre.observaciones as 'pre_observaciones', ".
				  "Pre.fecha as 'pre_fecha', ".
				  "Pre.estado as 'pre_estado', ".
				  "Pre.descuentos as 'tot_descuentos', ".
				  "Pre.base_imponible as 'tot_base_imponible', ".
				  "Pre.impuestos as 'tot_total_impuestos', ".
				  "Pre.retenciones as 'tot_retenido', ".
				  "Pre.importe as 'tot_importe', ".
				  "Pre.bruto as 'tot_bruto', ".
				  "FPago.nombre as 'pre_nombre_forma_pago', ".
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
				  "EmpPrv.descuento as 'emp_dto_directo', ".
				  "EmpPrv.descuento_financiero as 'emp_dto_pronto_pago', ".
				  "EmpPrv.aplicar_retencion as 'emp_aplicar_retencion', ".
				  "EmpPrv.mantener_ratio_divisa as 'prv_ratio_divisa_dias', ".
				  "EmpPrv.cc_banco as 'emp_cc_banco', ".
				  "EmpPrv.cc_proveedor as 'emp_cc_proveedor', ".
				  "EmpPrv.cc_gastos as 'emp_cc_gastos', ".
				  "EmpPrv.cc_compras as 'emp_cc_compras', ".
				  "EmpPrv.cc_descuento_financiero as 'emp_cc_descuento_financiero', ".
				  "EmpPrv.cc_descuento_comercial as 'emp_cc_descuento_comercial', ".
				  "EmpPrv.cc_retenciones as 'emp_cc_retenciones', ".
				  "EmpPrv.cc_efectos as 'emp_cc_efectos', ".
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
				  "FROM Facturas `Pre`, Empresas `Emp`, Proveedores_empresas `EmpPrv`, Forma_pago as `FPago`, ".
				  "Proveedores `Prv`, Divisa `Div`, Divisa `Div2`, Provincias `Prov`, Provincias `Prov2` ".
				  "WHERE Pre.id_presupuesto = $id AND Prv.id_proveedor = Pre.id_proveedor AND ".
				  "FPago.id_forma_pago = Pre.id_forma_pago AND ".
				  "Prov2.id_provincia = Emp.id_provincia AND Prov.id_provincia = Prv.id_provincia AND ".
				  "Pre.id_empresa = EmpPrv.id_empresa AND EmpPrv.id_proveedor=Prv.id_proveedor AND ".
				  "Emp.id_divisa = Div2.id_divisa AND ".
				  "Prv.id_divisa = Div.id_divisa ";

		$id_rs = $oDb->query($cons);
		if ($oDb->num_rows($id_rs)) {
			  $aPedido = $oDb->fetch_assoc($id_rs);
			  foreach($aPedido as $clave => $valor) {
					$ref_arr = substr($clave,0,4);
					$ref_resto = substr($clave,4);
					// debug("parcial = $ref_arr, resto = $ref_resto");
					if (!strcasecmp($ref_arr,'pre_')) {
						$this->_aPedido[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'emp_')) {
						$this->_aReceptor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'prv_')) {
						$this->_aEmisor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'div_')) {
						$this->_aDivisa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'fpa_')) {
						$this->_aFPago[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'tot_')) {
						$this->_aTotales[$ref_resto] = $valor;
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

		$leyenda_divisa = $this->_aDivisa['leyenda'];
		$campo_accion = $this->_aTarifa['campo_accion'];
		$campo_rec = $this->_aTarifa['campo_recomendacion'];
		$oDb = $this->_db;

		$cons = "SELECT Det.id_detalle as 'id_detalle', ".
					"Det.id_articulo as 'id_articulo', ".
					"Det.id_pedido as 'id_pedido', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					"ROUND(Det.cantidad,".$this->tot_decimals.") as 'cantidad', ".
					"ROUND(Det.precio_articulo,".$this->tot_decimals.") as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"ROUND(Det.monto,".$this->tot_decimals.") as 'monto', ".
					"ROUND(Det.monto_total,".$this->tot_decimals.") as 'base_imponible', ".
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
					"Det.observaciones as 'observaciones', ".
					"Det.id_servicio as 'id_servicio', ".
					"Art.nombre as 'nombre', ".
					"Art.referencia as 'referencia', ".
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"Art.id_unidad_medida as 'id_unidad_medida', ".
					"Um.leyenda as 'leyenda_unidad_medida', ".
					"Cert.nombre as 'certificado', ".
					"Cert.id_certificado as 'certificado_id', ".
					"ROUND(Det.cantidad,".$this->tot_decimals.") as 'cantidad_pedida', ".
					"(Det.cantidad*Art.peso_unidad) as 'peso', ".
					( (!empty($campo_rec)) 
					  ?  "ROUND(Empart.$campo_rec,".$this->tot_decimals.") as 'PVP_rec', "
					  : '').
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					"SUM(La.cantidad) as 'stock_real', ".
					( ($this->_aPedido['id_pedido'])
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
					"Familia_articulos `Fam`, Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Presupuestos `Pre` ".
					"WHERE Pre.id_presupuesto = $id AND Pre.id_presupuesto = Det.id_presupuesto AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Pre.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"GROUP BY id_detalle ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		if ($oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			$aPeds = array();
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				if ((is_numeric($this->_aTarifa['pto_recomendacion']) OR (int)$this->_aTarifa['coniva_recomendacion']) 
						AND (!empty($campo_rec))) {
					if (is_numeric($this->_aTarifa['pto_recomendacion']) AND $this->_aTarifa['pto_recomendacion']!=0 ) {
						$fila['PVP_rec'] += $fila['PVP_rec'] * $this->_aTarifa['pto_recomendacion'] / 100;
						if ((int)($this->_aTarifa['coniva_recomendacion']) ) {
							$fila['PVP_rec'] += $fila['PVP_rec'] * $fila['porcentaje'] / 100;
						}
						$fila['PVP_rec'] = round($fila['PVP_rec'],$this->tot_decimals);
					}
				}
				if (is_numeric($fila['id_pedido']))
					$aPeds[$fila['id_pedido']] += $fila['base_imponible'];
				$this->_aDetalles[$i] = $fila;
				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}

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

		$leyenda_divisa = $this->_aDivisa['leyenda'];
		$id_prv = $this->_aEmisor['id'];
		$oDb = $this->_db;

		$cons = "SELECT Det.id_detalle as 'id_detalle', ".
					"Det.id_articulo as 'id_articulo', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.id_pedido as 'id_pedido', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					"ROUND(Det.cantidad,".$this->tot_decimals.") as 'cantidad', ".
					"ROUND(Det.precio_articulo,".$this->tot_decimals.") as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"ROUND(Det.monto,".$this->tot_decimals.") as 'monto', ".
					"ROUND(Det.monto_total,".$this->tot_decimals.") as 'base_imponible', ".
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
					"Det.observaciones as 'observaciones', ".
					"Det.id_servicio as 'id_servicio', ".
					"Art.nombre as 'nombre', ".
					"Art.referencia as 'referencia', ".
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"Art.id_unidad_medida as 'id_unidad_medida', ".
					"Um.leyenda as 'leyenda_unidad_medida', ".
					"Cert.nombre as 'certificado', ".
					"Cert.id_certificado as 'certificado_id', ".
					"ROUND(Det.cantidad,".$this->tot_decimals.") as 'cantidad_pedida', ".
					"(Det.cantidad*Art.peso_unidad) as 'peso', ".
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
					"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
					"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
					" Familia_articulos `Fam`, Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Presupuestos `Pre`, Compra_articulos `CompArt` ".
					"WHERE Pre.id_presupuesto = $id AND Pre.id_presupuesto = Det.id_presupuesto AND CompArt.id_proveedor = $id_prv AND ".
					"CompArt.id_articulo = Det.id_articulo AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Pre.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"GROUP BY id_detalle ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		if ($oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			$aPeds = array();
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				if (is_numeric($fila['id_pedido']))
					$aPeds[$fila['id_pedido']] += $fila['base_imponible'];
				$this->_aDetalles[$i] = $fila;
				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}

			if (!is_numeric($this->_aTotales['bruto']) OR $this->_aTotales['bruto']==0)
				$this->_aTotales['bruto'] = $total_bruto;
			$this->_aPedido['peso'] = $total_peso;
		} else $retval = FALSE;

		return $retval;
	}

	function _updateArticleContracts() {
		if (is_array($this->_aServ_Pend) AND sizeof($this->_aServ_Pend)) {
			foreach ($this->_aServ_Pend as $in => $idart) {
				$aTmp = parent::getArticleContracts($idart);
				if (is_array($aTmp) AND sizeof($aTmp))
					$this->_aServ_Pend[$in] = NULL;
			}
			$this->_dbFetchContractsForIDs($this->_aServ_Pend);
			$this->_aServ_Pend = array();
		}
	}

	/****** Metodos Publicos:  ********/
	function set_detail_contract($idx,$id_servicio) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return NULL;
		}

		if (!is_numeric($idx)) return FALSE;
		if (!is_array($this->_aDetalles[$idx])) return FALSE;
		$old_idserv = $this->_aDetalles[$idx]['id_servicio'];
		if (!is_numeric($id_servicio) OR empty($id_servicio)) {
			if (is_numeric($old_idserv)) return $this->unset_detail_contract($idx);
			else return FALSE;
		}
		$this->_updateArticleContracts();

		if (!is_array($this->_aServicios[$id_servicio])) 
			if (!$this->_dbFetchContract($id_servicio)) return FALSE;

		$idart = $this->get_detail_article_id($idx);

		//Comprobamos que no exista la misma referencia y servicio en este pedido.
		$bMatch = FALSE;
		if (is_array($this->_aServicio_DetIdx[$id_servicio]) AND sizeof($this->_aServicio_DetIdx[$id_servicio]))
			foreach ($this->_aServicio_DetIdx[$id_servicio] as $tstidx) 
				if ($this->get_detail_article_id($tstidx) == $idart) {
					$bMatch = TRUE;
					break;
				}
		if ($bMatch) {
			$this->error('ORDER_CONTRACT_DUPLICATE',array ('prod' => $this->_aDetalles[$idx]['nombre'].' ('.$idart.') ', 
						'contract' => $this->_aServicios[$id_servicio]['nombre']));
			return FALSE;
		}

		if (!is_numeric($this->_aServicios[$id_servicio]['referencias'][$idart]['cuota'])) {
			$cuota_alta = NULL;
		} else {
			$cuota_alta = $this->_aServicios[$id_servicio]['referencias'][$idart]['cuota'];
		}

		$aServList = $this->getArticleContracts($idart);
		if (!is_array($aServList[$id_servicio]) OR !sizeof($aServList[$id_servicio])) {
			$this->error('ORDER_PRODUCT_NOTINCONTRACT',array('prod' => $this->_aDetalles[$idx]['nombre'].' ('.$idart.')'));
			return FALSE;
		}
		$cuota = (float) $aServList[$id_servicio]['cuota'];
		if (!empty($cuota)) $cuota = $this->_applyRevenue($cuota);

		$this->set_price($idx,$cuota,FALSE);
		$comment = $this->get_detail_comment($idx);
		$this->set_detail_comment($idx,'Cuota de Alta. '.$comment);
		$this->setDetailAttribute($idx,'id_servicio',$id_servicio);

		// Rellenando el Indice de servicios
		if (!is_array($this->_aServicio_DetIdx[$id_servicio]) OR !sizeof($this->_aServicio_DetIdx[$id_servicio])) 
			$this->_aServicio_DetIdx[$id_servicio] = array();
		array_push($this->_aServicio_DetIdx[$id_servicio],$idx);

		return TRUE;
	}

	function unset_detail_contract($idx) {
		$this->_updateArticleContracts();
		if (!is_numeric($idx) OR !is_array($this->_aDetalles[$idx])) return FALSE;
		if (is_numeric($idx) AND is_numeric($this->_aDetalles[$idx]['id_servicio'])) {
			$idserv = $this->_aDetalles[$idx]['id_servicio'];
			if (is_array($this->_aServicio_DetIdx[$idserv]) AND in_array($idx,$this->_aServicio_DetIdx[$idserv]))
				$this->_aServicio_DetIdx[$idserv] = array_diff($this->_aServicio_DetIdx[$idserv],array($idx));
		}
		$precio = $this->_applyRevenue($this->_aDetalles[$idx]['precio_real']);
		$this->set_price($idx,$precio,FALSE);
		$this->setDetailAttribute($idx,'id_servicio','null');
	}

	function getArticleContracts($id) {
		if (is_array($this->_aServ_Pend) AND sizeof($this->_aServ_Pend))
			$this->_updateArticleContracts();
		return parent::getArticleContracts($id);
	}


	/**
	  * Metodo para Generar una nueva Factura (con su referencia) a partir de otra factura ya existente.
	  **/

	function duplicate() {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('BUDGET_LOCKED');
			return -1;
		}
		$this->setReference(0);
		$this->setDate(0);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_NEWRECORD);
	}

	function getIssued() {
		// Comprobar si la factura esta emitida o no.
		return $this->getStatus();
	}

	function getId_pedidoFromIdx($idx) {
		if (!is_numeric($idx)) return NULL;
		if (empty($this->_aDetalles[$idx]['id_pedido'])) return NULL;
		return $this->_aDetalles[$idx]['id_pedido'];
	}

	function dbFill($id) {
		if (!is_object($this->_db)) return 0;
		if (!(int)$id) return 0;
		$oDb = $this->_db;

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_sale_headders($id)) {
				$this->error('BUDGET_NOHEADERS');
				return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchase_headders($id)) {
				$this->error('BUDGET_NOHEADERS');
				return FALSE;
			}
		}

		// paborrar_: $leyenda_divisa = $this->_aDivisa['leyenda'];
		// paborrar_: $campo_accion = $this->_aTarifa['campo_accion'];
		$id = $this->getId();
		$id_empresa = $this->getHeaderAttribute('id_empresa');

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

		// Comprobamos la existencia de Pedidos 
		// Fixme: Esta query se puede unificar junto con la de Albaranes (dado que pasa por pedidos). 
		$cons = "SELECT P.id_pedido,P.referencia,P.preparado,P.id_agente FROM Pedidos `P` ".
					"WHERE P.id_presupuesto = ".$id;
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

		// Pasar esto a un metodo dbrecover_detail() ?
		// Localizamos y Rellenamos el detalle de los pedidos.

		// Fixme: pasar esto a un dbrecover_taxes() ?
		// Rellenamos la tabla de IVAs.
		$cons = "SELECT I.id_iva as 'id_iva', ".
				  "I.id_pedido as 'id_pedido', ".
				  "I.id_factura as 'id_factura', ".
				  "I.id_presupuesto as 'id_presupuesto', ".
				  "ROUND(I.monto,".$this->tot_decimals.") as 'base_imponible', ".
				  "I.bruto as 'bruto', ".
				  "ROUND(I.recargo_iva,".$this->tot_decimals.") as 'total_iva', ".
				  "ROUND(I.recargo_equivalente,".$this->tot_decimals.") as 'total_recargo', ".
				  "TI.porcentaje as 'porciento', ".
				  "TI.recargo_equivalente as 'recargo_eq', ".
				  ( ($this->_fPedido & inmPed_VENTA) 
					 ? "TI.cc_imp_repercutido as 'cc_impuestos', ".
						"TI.cc_re_repercutido as 'cc_recargos' "
					 : "TI.cc_imp_soportado as 'cc_impuestos', ".
						"TI.cc_re_soportado as 'cc_recargos' "
				  ).
				  "FROM IVAs `I`, Tipos_IVA `TI` ".
				  "WHERE I.id_presupuesto = $id AND I.id_iva = TI.id_iva order by id_iva desc";
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			$recalcular_iva = FALSE;
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
				  "id_presupuesto as 'id_presupuesto', ".
				  "orden as 'orden', ".
				  "ROUND(monto_base,".$this->tot_decimals.") as 'base_imponible', ".
				  "porcentaje as 'descuento', ".
				  "nombre as 'nombre', ".
				  "financiero as 'financiero', ".
				  "ROUND(monto_final,".$this->tot_decimals.") as 'importe' ".
				  "FROM Descuentos ".
				  "WHERE id_presupuesto = $id ORDER BY orden asc";
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
			if (!$this->_dbfetch_saleorder_details($id)) {
				$this->error('BUDGET_NODETAILS');
				// return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchaseorder_details($id)) {
				$this->error('BUDGET_NODETAILS');
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
		return TRUE;
	}

	/**
	  * Vuelca TOD-O el contenido del pedido a la base de datos. Borrando registros si es preciso.
	  **/
	function dbDump($bGetRef = TRUE) {
		if ($this->debug) debug("probando el dump...");
		if ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("pedido tocado...");
			if ($this->_aFlags['pedido'] & inmPed_DB_DELETE) {
				if ($this->debug) debug("BORRANDO (marcando flags)...");
				$this->_change_flags(inmPed_CHG_TAXES|(inmPed_DB_DELETE | inmPed_DB_COMMIT));
				$this->_change_flags(inmPed_CHG_DISCOUNTS|(inmPed_DB_DELETE | inmPed_DB_COMMIT));
				// $this->_change_flags(inmPed_CHG_DISCOUNTS|(inmPed_DB_DELETE | inmPed_DB_COMMIT));
				// $this->_change_flags(inmPed_CHG_DETAIL|(inmPed_DB_DELETE | inmPed_DB_COMMIT),-1);

				if (is_array($this->_aDetalles))
					foreach ($this->_aDetalles as $idx => $aNull)
						$this->del_detail($idx,FALSE);
				if (!is_numeric($this->getId())) return FALSE;
				$this->_db->tb_delete("Presupuestos",array("id_presupuesto" => $this->getId()));
				if (is_array($this->_aIDPedido) AND sizeof($this->_aIDPedido))
					foreach ($this->_aIDPedido as $id_pedido => $aPed)
						$this->_db->tb_update("Pedidos",array("id_presupuesto" => 'null', 'id_presupuesto' => $id_pedido));

				if ($this->debug) 
					debug("Molaria resetear el contador caso de ser el ultimo pedido realizado (".(int)$this->getReference.")");

			} elseif ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
				if ($this->debug) debug("Buscando numeracion para la referencia y la fecha...");
				$ref = $this->getReference();
				if (empty($ref)) {
					if ($bGetRef) $this->setReference();
					else {
						$tini = strtotime(date("Y-m-d H:i")); 
						$tfin = strtotime($this->getDate());
						// Plazo maximo que no cambia la fecha del doc, al emitir/cambiar ref
						// Fixme: Permitir la configuracion de este plazo
						$tDiasplazo = (60 * 60 * 24) * 5;
						// debug("Fra de $tfin cundo ahora: $tini");
						if ($tfin <= ($tini + $tDiasplazo)) $this->setReference();
					}
				}
				// Los productos de Servicio no Establecen Fecha.
				// $date = $this->get_date();
				// if (empty($date)) $this->set_date();
				if ($this->_aFlags['pedido'] & inmPed_DB_NEWRECORD)
					$this->_aPedido['id_presupuesto'] = NULL;
				if ($this->_fPedido & inmPed_VENTA) {
					if (!is_numeric($this->_aPedido['id_cliente']) OR empty($this->_aPedido['id_cliente'])) {
						$this->error('BUDGET_NORECIEVER',array('ref' => $this->getReference()));
						return FALSE;
					} else {
						$this->_aPedido['id_proveedor'] = NULL;
					}
				} else {
					if (!is_numeric($this->_aPedido['id_proveedor']) OR empty($this->_aPedido['id_proveedor'])) {
						$this->error('BUDGET_NOISSUER',array('ref' => $this->getReference()));
						return FALSE;
					} else {
						$this->_aPedido['id_cliente'] = NULL;
					}
				}

				// TODO: Comprobar que el ratio es el que tiene que ser (junto con el dbfill)
				$aFra = $this->_aPedido;
				$aFra['factura_proforma'] = (int)$this->isProforma();
				$aFra['base_imponible'] = $this->_aTotales['base_imponible'];
				$aFra['impuestos'] = $this->_aTotales['impuestos'] + $this->_aTotales['recargos'];
				//Fixme: $this->_aPedido['monto_cuenta'] = $this->_aTotales['monto_cuenta'];
				$aFra['descuentos'] = $this->_aTotales['descuentos'];
				$aFra['retenciones'] = $this->_aTotales['retenido'];
				$aFra['importe'] = $this->_aTotales['importe'];
				$aFra['bruto'] = $this->_aTotales['bruto'];
				$aFra['estado'] = $this->getStatus();
				$aFra['observaciones'] = $this->_aPedido['observaciones'];
				if ((int)$this->getId()) {
					if ($this->debug) debug("Updateamos la factura...");
					$this->_db->tb_update("Presupuestos",$aFra);
				} else {
					if ($this->debug) debug("Insertando un nueva factura en la db...");
					$this->_db->tb_replace("Presupuestos",$aFra);
					$this->setId($this->_db->last_insert_id());
				}
				
			}
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
		} elseif ($this->debug) debug("La cabecera del pedido no se ha tocado...");

		if ( ($this->_aFlags['calculos_iva'] & inmPed_DB_COMMIT) ) {
			if ($this->debug) debug("Volcamos los ivas... ".decbin($this->_aFlags['calculos_iva']));
			if ( ($this->_aFlags['calculos_iva'] & inmPed_DB_DELETE) AND (int)$this->getId()) {
				$cons = 'DELETE FROM IVAs WHERE '.
						'(!id_pedido OR id_pedido IS NULL OR id_pedido=0) AND '.
						'(!id_factura OR id_factura IS NULL OR id_factura=0) AND '.
						' id_presupuesto = '.$this->getId();
				$this->_db->query($cons);
			} elseif ((int)$this->getId()) {
				$this->_build_taxes();
				if (is_array($this->_aIVAs['detalle'])) {
					foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva) {
						$bDump = true;
						foreach ($this->_aIva_dbdel as $aI) 
							if ($id_iva==$aI['id_iva']) {
								$bDump = false;
								break;
							}
						if (!$bDump) continue;
						$aIva['id_iva'] = $id_iva;
						// $aIva['id_pedido'] = $this->_aPedido['id_pedido'];
						$aIva['id_presupuesto'] = $this->getId();
						$aIva['monto'] = $aIva['base_imponible'];
						$aIva['bruto'] = $aIva['bruto'];
						$aIva['recargo_iva'] = $aIva['total_iva'];
						$aIva['recargo_equivalente'] = $aIva['total_recargo'];
						if ($this->debug) print_r($aIva);
						$this->_db->tb_replace("IVAs",$aIva);
					}
				} else
					if ($this->debug) debug("No hay IVAs que volcar...");

				if (is_array($this->_aIva_dbdel) AND sizeof($this->_aIva_dbdel))
					foreach ($this->_aIva_dbdel as $aIva_del) {
						if (!isset($aIva_del['id_iva'])) continue;
						if (!isset($aIva_del['id_presupuesto'])) {
							$id = $this->getId();
							if (empty( $id )) continue;
							else $aIva_del['id_presupuesto'] = $id;
						}

						if (empty($aIva_del['id_pedido']) AND empty($aIva_del['id_factura'])) {
							unset($aIva_del['id_pedido']);
							$this->_db->tb_delete("IVAs",$aIva_del);
						} else {
							$aTmp['id_presupuesto'] = 0;
							$aTmp['id_iva'] = $aIva_del['id_iva'];
							$aTmp['id_pedido'] = (int)$aIva_del['id_pedido'];
							$aTmp['id_factura'] = (int)$aIva_del['id_factura'];
							$aFld[] = "id_pedido";
							$aFld[] = "id_factura";
							$aFld[] = "id_iva";
							$this->_db->tb_update("IVAs",$aTmp,$aFld);
						}
					}
			} else $this->error('BUDGET_NODBRECORD');
				//$this->error(404,"Me falta el id de Pedido para insertar los IVAs en la bbdd.");
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK);
		} else if ($this->debug) debug("Los IVAs no se han tocado...");


		if ($this->debug) debug("<b>INICIAMOS LOS DESCUENTOS</b>");
		if ($this->_aFlags['descuentos'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("Volcamos los descuentos...");
			if ($this->_aFlags['descuentos'] & inmPed_DB_DELETE AND (int)$this->getId()) {
				$cons = 'DELETE FROM Descuentos WHERE '.
							'(!id_pedido OR id_pedido IS NULL OR id_pedido=0) AND '.
							'(!id_factura OR id_factura IS NULL OR id_factura=0) AND '.
							' id_presupuesto = '.$this->getId();
				$this->_db->query($cons);
			} elseif ((int)$this->getId()) {
				if (!is_array($this->_aDescuentos['detalle'])) $this->calculate();
				if (is_array($this->_aDescuentos['detalle']))
					foreach($this->_aDescuentos['detalle'] as $aDto) {
						// $aDto['id_pedido'] = $this->_aPedido['id_pedido'];
						$aDto['id_presupuesto'] = $this->getId();
						$aDto['monto_base'] = $aDto['base_imponible'];
						$aDto['porcentaje'] = $aDto['descuento'];
						$aDto['nombre'] = $aDto['nombre'];
						$aDto['financiero'] = $aDto['financiero'];
						$aDto['monto_final'] = $aDto['importe'];
						if ($this->debug) debug("Replace de descuentos:");
						if ($this->debug) print_r($aDto);
						$this->_db->tb_replace("Descuentos",$aDto);
					}
				elseif ($this->debug) debug("No hay Dscuentos que volcar...");
			} else $this->error('BUDGET_NODBRECORD');
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK);
		} else if ($this->debug) debug("Los DESCUENTOS NO se han tocado...");
		if ($this->debug) debug("<hr>");

		if ($this->_aFlags['detalles'] & inmPed_DB_COMMIT) {
			$aBorrarDet = array();
			$aPedFra = array();

			if ($this->_fPedido & inmPed_VENTA) $op_sign = '+';
			else $op_sign = '-';
			foreach($this->_aModif['detalles'] as $idx_det => $estado) {
				// Fixme: Actualizar los socks cuando se borra o modifican cantidades.
				if ($estado & inmPed_DB_DELETE) {
					if ($this->debug) debug("Habria que borrar este detalle($idx_det)... si");
					// Meter este id_detalle dentro de un array de id_detalles a borrar. (para comprobar que si tiene id_pedido no se borren)
					array_push($aBorrarDet,$idx_det);
					if (is_numeric($this->_aDet_dbdel[$idx_det]['id_detalle']) AND !empty($this->_aDet_dbdel[$idx_det]['id_detalle'])) {
						$idart = $this->_aDet_dbdel[$idx_det]['id_articulo'];
						if (!is_numeric($idart) or empty($idart)) {
							$this->error('BUDGET_NOIDPRODUCT',array('idx' => $idx_det));
							continue;
						}

						/* **
						// debug("Indice a borrar:");
						// print_r($this->_aDet_dbdel[$idx_det]);
						$this->_db->tb_delete('Facturas_detalle',
								array('id_factura' => $this->_aPedido['id_factura'],'id_detalle' => $this->_aDet_dbdel[$idx_det]['id_detalle']));
						/** **/
						$idart = NULL;
					}
				} elseif ($estado & inmPed_DB_COMMIT) {
					if ($this->debug) debug("Detalle $idx_det no actualizado");
					$aTmp = $this->get_detail($idx_det);
					if (is_numeric($aTmp['id_pedido']) AND !in_array($aTmp['id_pedido'],$aPedFra))
						array_push($aPedFra,$aTmp['id_pedido']);
					if (!(int)$aTmp['id_presupuesto'] AND (int)$this->getId()) $aTmp['id_presupuesto'] = $this->getId();

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
						// if (!(int)$aTmp['id_pedido'] AND ($estado & (inmPed_CHG_DET_QUANTITY | inmPed_CHG_DET_PRICE | inmPed_CHG_DET_DISCOUNT))) 
						if (!(int)$aTmp['id_pedido'] )
							$this->_db->tb_update("Lineas_detalle",$aTmp);
					}

					/** **
					// A la par volcamos Facturas_detalle
					$aTmpDetFra['id_detalle'] = $this->_aDetalles[$idx_det]['id_detalle'];
					$aTmpDetFra['id_presupuesto'] = $this->getId();
					$aTmpDetFra['cantidad'] = $this->get_quantity($idx_det);
					$aTmpDetFra['observaciones'] = $this->get_detail_comment($idx_det);
					$aTmpDetFra['monto_total'] = $this->get_detail_ammount($idx_det);
					if ($this->debug)
						debug("<br>whos ur daddy? cantidad_recibida(".empty($aTmp['cantidad_recibida']).") - hay_albaranes(".$hay_albaranes.") - ".$aTmpDetFra['cantidad']);

					if ($estado & inmPed_CHG_DET_QUANTITY) {
						/** En las facturas _NO_ se actualiza el stock, ni estimado ni nada, si se quiere modificar una factura por la razon
						  que quiera la empresa/operario, perfecto, pero no por problemas operativos (mercaderia en mal estado, etc...) porque
						  sino eso se haria en albaranes. (si los hay)
						/** **
						// Actualizamos la cantidad que hay ahora mismo en la DB.
						if (is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_db']))
							$cant_org = $this->_aDet_dbdel[$idx_det]['cantidad_db'];
						else $cant_org = 0;
						if (is_numeric($aTmp['cantidad']))
							$cant_act = $aTmp['cantidad'];
						else $cant_act = 0;
						// El stock estimado _solo_ se modifica cuando _no_ hay albaranes.
						if ($cant_org != $cant_act AND (!$hay_albaranes) ) {
							$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
										"WHERE id_articulo = ".$aTmp['id_articulo']." AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
							$this->_db->query($cons);
						}
						$this->_aDet_dbdel[$idx_det]['cantidad_db'] = $cant_act;
					}

					$this->_db->tb_replace('Lineas_detalle',$aTmpDetFra);
					/** **/
	
				} elseif ($this->debug) debug("Nada que hacer para este detalle($idx_det)...");
			}
			
			$aToDelete = $aBorrarDet;
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

		/** A Comprobar cuando consolidemos un presupuesto en pedido. **
		// Volcamos la relacion que haya con los pedidos.
		if (is_array($aPedFra) AND sizeof($aPedFra)) 
			foreach ($aPedFra as $idped) {
				if (!empty($idped) AND !is_array($this->_aIDPedido[$idped])) {
					$aTmp = array();
					$aTmp['id_presupuesto'] = $this->getId();
					if (is_numeric($aTmp['id_presupuesto'])) {
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
					$this->_db->tb_delete('Pedidos_facturas',$aPed);
				} else {
					$this->_db->tb_replace('Pedidos_facturas',$aPed);
					$this->_aIDPedido[$idped]['_dbfetch'] = 1;
				}
			}
		}
		/** **/

	} // Fin del dbdump()

	/** Fin de los metodos de funcionalidades **/

} /**************** FIN DE LA CLASE ******************/

}

?>
