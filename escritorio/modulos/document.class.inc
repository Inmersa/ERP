<?php
/*****************************************************************
** Aplicacion dise�ada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.								 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3� Izda,    **
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
**    C/Alcala 18 3� Izda, 28014 Madrid, Espa�a						 **
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
	de tal forma que sea soportable la carga de instaciar varias veces esta clase en modos sin 'carrito' y light
	
	- Tendremos una clase contenedora para varios pedidos, facturas, albaranes en su modo ligth.
*****************************************************************/
/** Defines: **/

if (!defined('__inmersa_document_class_inc')) {
define('__inmersa_document_class_inc',TRUE);

// Cambios de estado de las lineas de Detalle -Mascaras de modificaciones-
define(inmPed_CHG_DET_QUANTITY,	bindec("00001"));
define(inmPed_CHG_DET_PRICE,		bindec("00010"));
define(inmPed_CHG_DET_DISCOUNT,	bindec("00100"));
// Cambios de estado -Mascaras de modificaciones-
define(inmPed_DB_NEWRECORD,		bindec("000000001000"));
define(inmPed_DB_COMMIT,			bindec("000000010000"));
define(inmPed_DB_DELETE,			bindec("000000100000"));
define(inmPed_MODIFIED,				bindec("000001000000"));
define(inmPed_LOCKED,				bindec("000010000000"));
define(inmPed_OK,						bindec("000100000000"));
// Para las banderas:
define(inmPed_CHG_MAIN,				bindec("0001000000000"));
define(inmPed_CHG_DISCOUNTS,		bindec("0010000000000"));
define(inmPed_CHG_TAXES,			bindec("0100000000000"));
define(inmPed_CHG_DETAIL,			bindec("1000000000000"));
// Para las opciones generales del pedido
define(inmPed_COMPRA,				bindec("00000001"));  
define(inmPed_VENTA,					bindec("00000010"));  
define(inmPed_PRESUPUESTO,			bindec("00000100"));  // Si es pedido o presupuesto
define(inmPed_STRICT,				bindec("00001000"));  // Si se ha de ser estricto en las comprobaciones de agente-cliente
define(inmPed_STANDARD,				bindec("00010000"));  // Mascara para marcar el pedido tipo
// Para indicar Cantidades (tipos):
define(inmPed_QUANTITY,					bindec("00001"));
define(inmPed_QUANTITY_REQUESTED,	bindec("00010"));
define(inmPed_QUANTITY_DELIVERED,	bindec("00100"));

class Document {
	// Variables Publicas de la clase
	var $App_Name = ""; 			// Nombre de aplicacion y por tanto de instancia global de sesion.
	var $op_decimals;				// Numero de decimales con los que se realizan las operaciones de calculo.
	var $tot_decimals;			// Numero de decimales con los que se obtendra el total resultante de los calculos.

	// Variables Privadas a la clase
	var $_fPedido;					// int: Opciones Generales del pedido (ver mascaras)

	var $_aDirecciones_receptor;// Las posibles Direcciones de entrega del receptor de este pedido
	var $_aAgentes_cliente;		// Los posibles Agentes del receptor de este pedido
	var $_aClientes_agente;		// Los posibles Receptores del Agente de este pedido
	var $_aPedido;					// Datos propios del pedido
	var $_aReceptor;				// Datos del cliente o empresa receptora del pedido.
	var $_aEmisor;					// Datos de la empresa o proveedor emisor del pedido.
	var $_aAgente;					// Agente que realiza el Pedido 
	var $_aTarifa;					// Tarifa a aplicar al pedido (solo ventas)
	var $_aDivisa;					// Datos de la divisa del pedido

	var $_aDetalles = array(	// Todos los detalles del pedido (junto con sus dtos)
			array(					// El indice de este array es el identificador de manejo del detalle.
		 'id_detalle'					=> 0,	// ID del detalle en la base de datos
		 'id_articulo'					=> 0,	// ID del articulo en la db
		 'id_servicio'					=> 0,	// ID servicio que se ha contratado en este pedido con este detalle/articulo
		 'cantidad_recibida'			=> 0,	// cantidad recibida por el receptor
		 'cantidad_residual'			=> 0,	// cantidad no satisfecha y pedida por el receptor
		 'cantidad_pedida'			=> 0,	// cantidad total pedida por el receptor
		 'precio_tarifa'				=> 0,	// precio del articulo una vez aplicada la tarifa del receptor
		 'descuento'					=> 0,	// decuento sobre el precio del articulo (porciento)
		 'monto'							=> 0,	// monto de descuento sobre el precio del articulo
		 'tipo_descuento'				=> 0,	// nombre del descuento se le ha aplicado al receptor en este detalle
		 'dto_aplicado'				=> 0,	// valor del descuento se le ha aplicado al receptor en este detalle
		 'precio_tarifa_descuento'	=> 0,	// precio del articulo una vez aplicados la tarifa y el descuento
		 'nombre'						=> "",// nombre del articulo en question
		 'id_familia'					=> 0,	// familia del articulo en question
		 'control_stock'				=> 0,	// si es necesario controlar el stock del articulo o no
		 'precio_real'					=> 0,	// precio base del articulo, sin tarifa ni descuento
		 'id_iva'						=> 0,	// identificador del iva a aplicado sobre el articulo
		 'porcentaje'					=> 0,	// porcentaje del iva aplicado
		 'recargo_equivalente'		=> 0,	// porcentaje del recargo de equivalencia aplicable 
		 'unidades_bulto'				=> 0	// unidades por cada bulto del articulo
					  )
						 );

	var $_aModif = array(
			"detalles" => array() // Mascara de modificadiones indexadas por idx detalle.
						 );
	var $_aIva_dbdel = array(	 // Lista de los IVAs que hay que borrar del pedido.
			array( 
				"id_pedido" => 0, // Pedido de la db al que pertenece el IVA
				"id_factura"=> 0,	// Factura a la que pertenece el IVA.
				"id_iva"		=> 0	// Id del iva que se va a borrar.
						) );	
	var $_aDet_dbdel = array(	 // Lista de id_detalle s en espera de ser borrados de la db (no necesariamente de ser borrados).
			array( 
				"id_detalle" => 0,		// id_detalle de la db a borrar (si relleno y marcado para borrar el idx en _aModif, se borra).
				"cantidad_actual"=> 0,	// Cantidad que tenia el detalle (para actualizar stock)
				"cantidad_recibida"=> 0,// Cantidad recibida por el cliente del detalle (para actualizar stock)
				"cantidad_pedida"=> 0	// Cantidad pedida por el cliente en el detalle (para actualizar stock)
						) );	

	var $_aTotales = array(
			"bruto" => 0,					// Total de las bases de los detalles
			"bruto_no_imponible" => 0,	// Total de las bases de los detalles sin aplicar su descuento.
			"base_imponible" => 0,		// Total de las bases imponibles
						 );
	var $_aDescuentos = array(
			"total"	=> 0,
			"detalle"=> array(
				"orden" => array(		// Detalles de los descuentos (ordenador por orden de aplicacion)
				  "base_imponible"=> 0,// Base imponible sobre la que se aplica el dto.
				  "descuento"		=> 0,// Descuento aplicado.
				  "nombre"			=> "",// Nombre del tipo de descuento (Comercial/Financiero...)
				  "financiero"		=> 0,// Si el descuento es financiero o no.
				  "importe"			=> 0,// importe del descuento.
					  ))
						 );

	var $_aIVAs = array(
			"total_iva"				=> 0,// Total de impuestos a pagar.
			"total_recargo"		=> 0,// Total de recargo sobre impuestos a pagar.
			"detalle"=> array(
				"id_iva" => array(
				  "base_imponible"=> 0,// Base imponible sobre la que se aplica el iva.
				  "porciento"		=> 0,// Porcentaje de iva.
				  "recargo_eq"		=> 0,// Porcentaje del recargo de equivalencia.
				  "total_iva"		=> 0,// Monto de impuesto para este tipo de iva
				  "total_iva_calculado"		=> 0,		// Monto de impuesto para este tipo de iva (independientemente de si se aplica o no)
				  "total_recargo"	=> 0,// Monto de recargo para este tipo de iva
				  "total_recargo_calculado"	=> 0 // Monto de recargo para este tipo de iva (independientemente de si se aplica o no)
					  )
				)
						 );

	var $_aOff_Promo = array(array()); // Ofertas y promos indexadas por id_articulo.
	var $_aServicios = array(			// Array indexado por ids con los servicios/contratos del pedido.
		'id' => NULL,						// ID del servicio
		'nombre' => NULL,					// Nombre del servicio
		'duracion' => NULL,				// Duracion, en dias, del servicio
		'plazo_factura' => NULL,		// Dias entre factura y factura
		'referencias' => array()		// Vector indexado por id_articulo con contenido = la cuota de alta que le toca.
			);

	// Indices a punteros de detalle y Flags de estado:
	var $_aDetIdx			= array();	// Indice conversor de id_detalle a idx_detalle
	var $_aDetIdx_Art	= array(array());	// Indice conversor de id_articulo a un array de idx_detalles
	var $_DetIdx_act = 0;				// Indice de detalle actualmente en curso (modificandose).
	var $_aServicio_DetIdx = array(			// Indice conversor de id_servicio a vector con idxs que tienen dicho servicio
			array()
			);
	var $_bModificado;			// Indica si se han de recalcular los ivas, dtos y totales.
	var $_aFlags = array (
			 "total_bases"		=> 0,		// Si el total de bases imponibles esta ok.
			 "calculos_iva"	=> 0,		// Estado de los calculos de impuestos.
			 "descuentos"		=> 0,		// Estado de los descuentos.
			 "pedido"			=> inmPed_LOCKED,		// Estado del estado principal del pedido.
			 "detalles"			=> 0,		// Estado de los detalles.
						 );					// Banderas de estado de pedido.

	var $_locale;					// Vector con informacion de formatos numericos

	// Instancias Dependientes:
	var $_db = ""; //  = wolDB::init(); // Base de datos conectada a los datos de gestion donde estan los pedidos.
	var $_db_name="";						// Nombre de la conexion a la base de datos dentro de la aplicacion actual.

	function dbg($msg,$method = NULL,$aP = NULL) {
		if (!$this->debug) return;
		if (is_array($aP) and sizeof($aP)) foreach ($aP as $k => $v) $plist .= ((!empty($plist)) ? ' , ' : ' ').$k.' = '.$v;
		if (is_array($msg) and sizeof($msg))
			foreach ($msg as $m) {
				if (!is_array($m)) debug(get_class($this)."::".$method.((!empty($plist)) ? '( '.$plist.' ) ' : '()').' => '.$m);
				else print_r($m);
			}
		else debug(get_class($this)."::".$method.((!empty($plist)) ? '('.$plist.') ' : '()').' => '.$msg);
	}

	/** Constructor:
		* @param $tipo			-	Indica si el pedido es de compra o de venta (ver defines).
		* @param $doc_type	-	Indica si es un pedido o un presupuesto.(bool)
	 **/
	function Document($App_Name = NULL,$db_name,$tipo = inmPed_VENTA,$doc_type = 0)  {

		if (!$App_Name) $this->App_Name = "Sesion";
		else $this->App_Name = $App_Name;
		if ($this->debug) debug("Constructor de inmPedido ... ".$this->App_Name);

		$this->set_db($db_name);

		$tmp = $this->set_tipo_pedido($tipo);

		// Fixme: El modo stricto deberia ser una opcion
		// $this->_fPedido |= ~inmPed_STRICT;

		// Comprobamos el tipo de documento
		if ((int)$doc_type<3) $this->_bPedido = (int)$doc_type;
		else $this->_bPedido = TRUE;
		
		// Resetamos valores.
		$this->_aDetalles = $this->_aIVAs['detalle'] = $this->_aDescuentos = $this->_aTotales = NULL;
		$this->_aDet_dbdel = array();
		$this->_aIva_dbdel = array();
		$this->_aPedido['preparado'] = 0;

		$Sesion = &$GLOBALS[$this->App_Name];
		if (is_a($Sesion,'wolSesion')) {
			$aCfg = $Sesion->get_var('_aAppConf');

			if (is_numeric($aCfg['gnrl_opdoc_digits'])) $this->op_decimals = $aCfg['gnrl_opdoc_digits'];
			else $this->op_decimals = 3;
			if (is_numeric($aCfg['gnrl_totdoc_digits'])) $this->tot_decimals = $aCfg['gnrl_totdoc_digits'];
			else $this->tot_decimals = 2;

			if (!empty($aCfg['gnrl_decimal_point'])) $this->_locale['decimal_point'] = $aCfg['gnrl_decimal_point'];
			else $this->_locale['decimal_point'] = ',';
			if (!empty($aCfg['gnrl_thousands_sep'])) $this->_locale['thousands_sep'] = $aCfg['gnrl_thousands_sep'];
			else $this->_locale['thousands_sep'] = '.';
			if (!empty($aCfg['gnrl_money_format'])) $this->_locale['money_format'] = $aCfg['gnrl_money_format'];
			else $this->_locale['money_format'] = '%=*#4.2i';

		} else {
			$this->op_decimals = 4;
			$this->tot_decimals = 3;
			$this->_locale['money_format'] = '%=*#4.2i';
			$this->_locale['decimal_point'] = ',';
			$this->_locale['thousands_sep'] = '.';
		}

		// print_r($fmt);
		// debug("Operativos: ".$this->op_decimals." Totales: ".$this->tot_decimals);

		return $tmp;
	}

	function __toString() {
    		return $this->get_reference().'/'.$this->num_details.'/'.$this->_fPedido;
	}

	function copyFromDocument($oDoc,$bDetails = false,$bKeepDbIds = false,$bKeepDoc = true) {
		if (is_a($oDoc,'Document')) {
			if (!isset($bKeepDoc)) $bKeepDoc = true;

			$modo = $this->getMode();
			$this->setMode($modo);
			$id_emisor = $this->get_issuer_id();
			$id_receptor = $this->get_reciever_id();

			if (!$bKeepDoc OR empty($id_emisor) OR empty($id_receptor)) {
				$this->set_issuer($oDoc->get_issuer_id());
				$this->set_reciever($oDoc->get_reciever_id());

				$idag = $oDoc->getHeaderAttribute('id_agente');
				if (is_numeric($idag) AND $idag != $this->getHeaderAttribute('id_agente') ) {
					if (method_exists($this,'set_agent')) $this->set_agent($idag);
					else $this->setHeaderAttribute('id_agente',$idag);
				}

				if (method_exists($oDoc,'get_reciever_address') AND method_exists($this,'set_reciever_address')) {
					$aDir = $oDoc->get_reciever_address();
					$aDirThis = $this->get_reciever_address();
					if (is_array($aDir) AND is_numeric($aDir[0]['id_direccion']) AND $aDir[0]['id_direccion'] != $aDirThis[0]['id_direccion']) {
						$aDir = array_shift($aDir);
						$this->set_reciever_address($aDir['id_direccion']);
						$aDir = $this->get_reciever_address();
					}
				}

				$this->clean_discounts();
				$aDto = $oDoc->get_discounts();
				if (is_array($aDto['detalle']) AND sizeof($aDto['detalle'])) {
					foreach ($aDto['detalle'] as $ord => $aD) {
						$this->set_discount($ord,$aD['descuento'],$aD['nombre'],(bool)$aD['financiero']);
					}
				} 

				$aVarsThis = get_object_vars($this);
				$aVars = get_object_vars($oDoc);
				if (isset($aVars['_aIDAlbaran']) AND isset($aVarsThis['_aIDAlbaran'])) {
					$this->_aIDAlbaran = $oDoc->_aIDAlbaran;
				}
			} elseif ($this->debug) debug("Document::copyFromDocument() ... Copiandolo solo detalles ... ");


			// Te falta la divisa y los ivas

			if ($bDetails OR (is_array($bDetails) AND sizeof($bDetails)) ) {
				for ($idx=$oDoc->first_detail(); $idx; $idx=$oDoc->next_detail()) {
					if (is_array($bDetails) AND sizeof($bDetails) AND !(int)$bDetails[$idx]) continue;

					$ida = $oDoc->get_detail_article_id($idx);
					$cant = $oDoc->get_quantity($idx);
					$precio = $oDoc->get_price($idx);

					if ($bKeepDbIds) {
						$id_det = $oDoc->getDetailAttribute($idx,'id_detalle');
						$id_pedido = $oDoc->getDetailAttribute($idx,'id_pedido');
						$aIDs['id_detalle'] = $id_det;
						$aIDs['id_pedido'] = $id_pedido;
					} else $aIDs = NULL;

					$idxnew = $this->add_detail($ida,$cant,NULL,false,NULL,$aIDs);
					// Evitando que se disparen las alertas por modificar una linea de detalle perteneciente a otros documentos
					$this->setDetailAttribute($idxnew,'id_detalle',NULL);
					$this->setDetailAttribute($idxnew,'id_pedido',NULL);
					$this->set_price($idxnew,$precio);

					if ($oDoc->have_discount($idx)) {
						$aDto = $oDoc->get_detail_discount($idx);
						if ($aDto['porciento'] != 0) {
							$dto = $aDto['porciento'];
							$bPto = true;
						} else {
							$dto = $aDto['monto'];
							$bPto = false;
						}
						$this->set_detail_discount($idxnew,$dto,$bPto,$aDto['tipo'],true);
					} else $this->set_detail_discount($idxnew,0,1,NULL,true);
					$this->setDetailAttribute($idxnew,'id_detalle',$id_det);
					$this->setDetailAttribute($idxnew,'id_pedido',$id_pedido);
				}
			}
			$this->_build_indexes();
			$this->calculate();
		}
	}

	/** Metodos de mantenimiento **/
	function &getDb() {
		return $this->_db;
	}

	function init() {
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->set_db($this->_db_name);
	}

	function cerrar() {
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		unset($this->_db);
	}

	/**
	  * Metodo encargado de actualizar las banderas caso de producirse un cambio en el pedido.
	  * @param $tipo	-	Tipo de cambio realizado. (ver defines).
	  * @return NULL
	  **/
	function _change_flags($tipo = 0,$id = NULL) {
		if (!$tipo) return;
		if ( ($tipo & inmPed_CHG_DETAIL) ) {
				// $this->_aFlags[];
			if ($this->debug) debug("change_flags($tipo) en Detalle ($id)");
			// Fixme: Arreglar esto, que los detalles puedan tener los flags de ok y demas, no tos a bloke
			if ( ($tipo & inmPed_OK) ) {
				if ($this->debug) debug("Como que Detalles OK??");
			}
			$base = FALSE;
			// Fixme: Testear esta linea; if ( ($idx_det = $this->current_detail()) ) 
			$aDetToCheck = array();
			if (is_numeric($id)) {
				if ($id == -1 AND is_array($this->_aDetalles) AND sizeof($this->_aDetalles))
					foreach ($this->_aDetalles as $i => $aNull) array_push($aDetToCheck,$i);
				elseif(is_array($this->_aDetalles[$id])) array_push($aDetToCheck,$id);
			} else { // Aqui, en teoria, no deberia tocar nada.
				if (is_array($this->_aDetalles) AND sizeof($this->_aDetalles))
					foreach ($this->_aDetalles as $i => $aNull) array_push($aDetToCheck,$i);
			}

			if (is_array($aDetToCheck) AND sizeof($aDetToCheck)) 
				foreach ($aDetToCheck as $idx_det) {
					$mask = $this->_aModif['detalles'][$idx_det];
					// debug("mascara para el detalle $idx_det = $mask");
					if ( ($tipo & inmPed_CHG_DET_QUANTITY) ) {
						if ($this->debug) debug("Cantidades de $idx_det..");
						$base = true;
						// $this->_aModif[detalles][$idx_det] &= ~inmPed_CHG_DET_QUANTITY;
						$this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_QUANTITY;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$mask |= inmPed_MODIFIED;
					}
					if ( ($tipo & inmPed_CHG_DET_PRICE) ) {
						if ($this->debug) debug("precio de $idx_det..");
						$base = true;
						$this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_PRICE;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$mask |= inmPed_MODIFIED;
					}
					if ( ($tipo & inmPed_CHG_DET_DISCOUNT) ) {
						if ($this->debug) debug("descuentos de $idx_det..");
						$base = true;
						$this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_DISCOUNT;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$mask |= inmPed_MODIFIED;
					}
					if ( ($mask & inmPed_MODIFIED) OR ($tipo & inmPed_DB_COMMIT) OR ($tipo & inmPed_MODIFIED) ) {
						if ($this->debug) debug("Modificado, sin mas ($idx_det)");
						$this->_aModif['detalles'][$idx_det] |= inmPed_MODIFIED;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$this->_aFlags['detalles'] |= (inmPed_DB_COMMIT | inmPed_MODIFIED);
					}
					if ( ($tipo & inmPed_DB_DELETE) ) {
						// $this->_aModif[detalles][$idx_det] &= ~inmPed_MODIFIED;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_DELETE;
						$this->_aFlags['detalles'] |= (inmPed_DB_COMMIT);
					}
					if ( ($tipo & inmPed_NEWRECORD) ) {
						// $this->_aModif[detalles][$idx_det] &= ~inmPed_MODIFIED;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
						$this->_aModif['detalles'][$idx_det] |= inmPed_DB_NEWRECORD;
						$this->_aFlags['detalles'] |= (inmPed_DB_COMMIT);
					}
					if ($base) $this->_calcular_baseimponible($idx_det);
				}

			if ( ($tipo & inmPed_MODIFIED) ) {
				$tipo = 0;
				$tipo |= inmPed_CHG_DISCOUNTS;
				$tipo |= inmPed_CHG_TAXES;
				$tipo |= inmPed_CHG_MAIN;
				$tipo |= inmPed_MODIFIED;
				$this->_aFlags['detalles'] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
			}
			/** **
			// if ($base) {
				$this->_aFlags[calculos_iva] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$this->_aFlags[descuentos] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$this->_aFlags[total_bases] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
			// }
			/** **/
		} 
		if ( ($tipo & inmPed_CHG_MAIN)) {
			if ($tipo & inmPed_MODIFIED) {
				$this->_aFlags['total_bases'] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$this->_aFlags['pedido'] |= (inmPed_DB_COMMIT);
				$tipo |= inmPed_CHG_DISCOUNTS | inmPed_CHG_TAXES | inmPed_MODIFIED;
			} elseif ($tipo & inmPed_OK) {
				$this->_aFlags['pedido'] &= ~inmPed_LOCKED; 
				$this->_aFlags['pedido'] &= ~inmPed_DB_COMMIT; 
				$this->_aFlags['pedido'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['pedido'] &= ~inmPed_MODIFIED; 
			} 
			if ($tipo & inmPed_LOCKED) {
				$this->_aFlags['pedido'] |= inmPed_LOCKED;
			}
			if ($tipo & inmPed_DB_COMMIT) {
				$this->_aFlags['pedido'] |= inmPed_DB_COMMIT;
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags['pedido'] |= inmPed_DB_COMMIT;
				$this->_aFlags['pedido'] |= inmPed_DB_NEWRECORD;
			}
		}

		if ( ($tipo & inmPed_CHG_DISCOUNTS)) {
			if ($tipo & inmPed_MODIFIED) {
				$this->_aFlags['descuentos'] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
			} elseif ( ($tipo & inmPed_OK) ) {
				$this->_aFlags['descuentos'] |= inmPed_OK; 
				$this->_aFlags['descuentos'] &= ~inmPed_DB_COMMIT; 
				$this->_aFlags['descuentos'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['descuentos'] &= ~inmPed_MODIFIED; 
			} elseif ( ($tipo & inmPed_DB_DELETE) ) {
				$this->_aFlags['descuentos'] |= inmPed_DB_DELETE; 
				$this->_aFlags['descuentos'] |= inmPed_DB_COMMIT; 
				$this->_aFlags['descuentos'] &= ~inmPed_OK; 
				$this->_aFlags['descuentos'] &= ~inmPed_MODIFIED; 
			}
			if ($tipo & inmPed_DB_COMMIT) {
				$this->_aFlags['descuentos'] |= inmPed_DB_COMMIT;
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags['descuentos'] |= inmPed_DB_COMMIT;
				$this->_aFlags['descuentos'] |= inmPed_DB_NEWRECORD;
			}
		}

		if ( ($tipo & inmPed_CHG_TAXES)) {
			if ($tipo & inmPed_MODIFIED) {
				$this->_aFlags['calculos_iva'] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
			} elseif ( ($tipo & inmPed_OK) ) {
				$this->_aFlags['calculos_iva'] |= inmPed_OK; 
				$this->_aFlags['calculos_iva'] &= ~inmPed_DB_DELETE; 
				$this->_aFlags['calculos_iva'] &= ~inmPed_MODIFIED; 
				$this->_aFlags['calculos_iva'] &= ~inmPed_DB_COMMIT; 
			} elseif ( ($tipo & inmPed_DB_DELETE) ) {
				$this->_aFlags['calculos_iva'] |= inmPed_DB_DELETE; 
				$this->_aFlags['calculos_iva'] |= inmPed_DB_COMMIT; 
				$this->_aFlags['calculos_iva'] &= ~inmPed_OK; 
				$this->_aFlags['calculos_iva'] &= ~inmPed_MODIFIED; 
			}

			if ( ($tipo & inmPed_DB_COMMIT)) {
				$this->_aFlags['calculos_iva'] |= inmPed_DB_COMMIT; 
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags['calculos_iva'] |= inmPed_DB_COMMIT;
				$this->_aFlags['calculos_iva'] |= inmPed_DB_NEWRECORD;
			}
		}
	}

	function error($err_code,$aParams = NULL) {
		$Sesion = $GLOBALS[$this->App_Name];
		if (!is_object($Sesion)) {
			echo "Error (Document.class:$err_code) $aParams";
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

	function __wakeup() {
		// debug("rocknroll aint noise polution (".$this->_db.") (".$this->App_Name.")");
		// include("modulos/pedidos.class.inc");
		// $this->set_db($this->_db_name);
		// $this->_db=$$this->App_Name->get_db($this->_db_name);
		// debug("shiiiiiiiiiiit".$this->_db);
	}

	function null__sleep() {
		// $this->_db->cerrar();
		// $aVars = get_class_vars(get_class($this));
		$aVars = get_object_vars($this);
		debug("jurasdf -- (".$this->App_Name.")");
		print_r($aVars);
		return $aVars;
	}

	/** Fin de los metodos de mantenimiento **/

	/** 
	  * Metodos SET y GET de los atributos *
	  *
	  *   -- Metodos de Cabeceras y Pies --
	 */

	/**
	  * Metodo que establece/asigna la empresa(ventas) o proveedor(compras) emisora del documento pedido actual.
	  * @return bool	-	Si se ha establecido el emisor con exito o no.
	  **/
	function set_issuer($id) {
		if (!(int)$id) return FALSE;

		if ($this->_fPedido & inmPed_VENTA) {
			$retval = $this->_set_enterprise_issuer($id);
		} else {
			$retval = $this->_set_provider_issuer($id);
		}
		if (!$retval) return $retval;
				
		// Si ya tenemos emisor y receptor, establecemos la fecha del pedido al momento actual.
		if ((int)$this->_aReceptor['id']) {
			if ($this->debug) debug("Receptor ya establecido. Desbloqueando pedido...");
			$this->set_date();
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT | inmPed_OK);
		}
		$this->_aPedido['preparado'] = 0;

		/** **
		debug("set_issuer()");
		debug("<br/>Pedido :");
		print_r($this->_aPedido);
		debug("<br/>Emisor :");
		print_r($this->_aEmisor);
		debug("<br/>Receptor :");
		print_r($this->_aReceptor);
		debug("<br/>Tarifa :");
		print_r($this->_aTarifa);
		debug("<br/>Divisa :");
		print_r($this->_aDivisa);
		/** **/

		// Desbloqueamos el pedido para que pueda ser usado.
		/** ** Fixme: beta-testear esto
		if ((int)$this->_aPedido[id_cliente])
			$this->_aFlags[pedido] &= ~inmPed_LOCKED;
		/** **
		if ((int)$this->_aPedido[id_cliente])
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK | inmPed_DB_COMMIT);
		// Fixme: se podria llamar al metodo set_status()?
		$this->_aPedido[preparado] = 0;
		/** **/
		return TRUE;
	}

	/**
	  * Metodo encargado de devolver informacion sobre el emisor del documento.
	  **/
	function get_issuer_id() {
		return $this->_aEmisor['id'];
	}

	/**
	  * Metodo encargado de devolver informacion sobre el emisor del documento.
	  **/
	function get_issuer_info() {
		return $this->_aEmisor;
	}

	/** (TODO: Retocar para _no_ obtener posibles direcciones -agentes si-)
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
		} else {
			$retval = $this->_set_enterprise_reciever($id,$bForce);
		}
		if (!$retval) return $retval;
				
		if ((int)$this->_aEmisor['id']) {
			if ($this->debug) debug("Emisor ya establecido. Desbloqueando pedido...");
			$this->set_date();
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
	  * Devuelve la informacion del receptor del pedido.
	  * @return array()	-	Array referencial de los datos del receptor del pedido.
	  **/
	function get_reciever_info() {
		return $this->_aReceptor;
	}

	function get_reciever_id() {
		return $this->_aReceptor['id'];
	}

	function set_revenue($id_tarifa) {
		// Caso de compras, Aprovechamos para convertir los precios a la moneda de la 
		//		Empresa que lo recibe, dado que los precios de Compra_articulos, estan en la moneda del proveedor.
		// debug("set_revenue($id_tarifa) - ".$this->_aPedido['id_tarifa']);
		if (!is_numeric($id_tarifa)) return FALSE;
		if ((int)$id_tarifa == $this->_aPedido['id_tarifa']) return TRUE;
		$cons = "SELECT ".
				  "Tar.id_tarifa as 'id_tarifa', ".
				  "Tar.nombre as 'nombre', ".
				  "Tar.campo_accion as 'campo_accion', ".
				  "Tar.campo_recomendacion as 'campo_recomendacion', ".
				  "Tar.pto_recomendacion as 'pto_recomendacion', ".
				  "Tar.coniva_recomendacion as 'coniva_recomendacion', ".
				  "Tar.pto_primero as 'pto_primero', ".
				  "Tar.pto_segundo as 'pto_segundo', ".
				  "Tar.monto as 'tar_monto' ".
				  "FROM Tarifas `Tar` WHERE id_tarifa = $id_tarifa";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return FALSE;
		$aTar = $this->_db->fetch_assoc($idrs);
		$this->_aTarifa['id_tarifa'] = $aTar['id_tarifa'];
		$this->_aTarifa['nombre'] = $aTar['nombre'];
		$this->_aTarifa['campo_accion'] = $aTar['campo_accion'];
		$this->_aTarifa['campo_recomendacion'] = $aTar['campo_recomendacion'];
		$this->_aTarifa['pto_recomendacion'] = $aTar['pto_recomendacion'];
		$this->_aTarifa['coniva_recomendacion'] = $aTar['coniva_recomendacion'];
		$this->_aTarifa['pto_primero'] = $aTar['pto_primero'];
		$this->_aTarifa['pto_segundo'] = $aTar['pto_segundo'];
		$this->_aTarifa['monto'] = $aTar['tar_monto'];
		$this->_aPedido['id_tarifa'] = $id_tarifa;
		$this->eval_conditions();
		// Fixme: Anyadir flags de recalculo total del pedido (todos los detalles tb).

	}

	function get_revenue() {
		return $this->_aTarifa;
	}

	function set_date($fecha = NULL) {
		if (!isset($fecha) AND empty($this->_aPedido['fecha']) OR (empty($fecha) AND is_numeric($fecha)))
			$fecha = date("d/m/Y H:i:s");
		elseif (!empty($this->_aPedido['fecha'])) 
			if (!isset($fecha) OR empty($fecha)) return TRUE;

		$this->_aPedido['fecha'] = $fecha;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		return TRUE;
	}

	function setDate($f = NULL) {
		return $this->set_date($f);
	}

	function get_date() {
		return $this->_aPedido['fecha'];
	}

	function getDate() {
		return $this->get_date();
	}

	/**
	  * Establece ls divisa de pago del pedido.
	  **/
	function set_currency($id_divisa) {
		if (!is_numeric($id_divisa)) return NULL;
		$id_divisa = (int)$id_divisa;
		if ($this->_aDivisa['id_divisa'] == $id_divisa) return 1;
		$cons = "SELECT ".
				  "Div.id_divisa as 'id_divisa', ".
				  "Div.leyenda as 'leyenda', ".
				  "Div.ratio as 'ratio' ".
				  // "Div.ratio_compra as 'ratio_compra' ".
				  "FROM Divisa `Div` WHERE id_divisa = $id_divisa ";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return 0;
		$aDiv = $this->_db->fetch_assoc($idrs);
		$this->_aDivisa = $aDiv;
		$this->_aPedido['id_divisa'] = $aDiv['id_divisa'];
		if ($this->debug) debug("Campo de divisa, habria que recalcular los totales? para obtener los datos en la nueva divisa?");
		return 1;
	}

	/**
	  * Obtiene la informacion de la divisa que esta siendo usada para el pedido.
	  **/
	function get_currency() {
		return $this->_aDivisa;
	}

	/**
	  * Establece el nombre del pedido actual
	  * @param $nombre - Nombre que se le ha de dar al pedido.
	  * @return bool	-	Si la operacion se ha realizadon con exito o no.
	  **/
	function set_name($nombre) {
		if (empty($nombre)) return FALSE;
		$this->_aPedido['nombre'] = $nombre;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		return TRUE;
	}

	/**
	  * Metodo encargado de obtener el nombre del pedido
	  * @return string - nombre del pedido.
	  **/
	function get_name() {
		return $this->_aPedido['nombre']; 
	}

	/**
	  * Establece los comentarios sobre el pedido.
	  **/
	function set_comments($big_text) {
		if (empty($big_text) AND empty($this->_aPedido['observaciones'])) return FALSE;
		if (!strcmp($big_text,$this->_aPedido['observaciones'])) return FALSE;
		$this->_aPedido['observaciones'] = $big_text;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		return TRUE;
	}

	/**
	  * Obtiene los comentarios para el pedido actual.
	  **/
	function get_comments() {
		return $this->_aPedido['observaciones'];
	}


	/**
	  * Metodo encargado de Establecer la referencia Externa del Documento.
	  */
	function set_ext_reference($ref_externa) {
		if ( (!empty($this->_aPedido['referencia_externa']) 
				AND !strcasecmp($ref_externa,$this->_aPedido['referencia_externa']))
				OR (empty($ref_externa) AND empty($this->_aPedido['referencia_externa'])) ) return TRUE;
		$this->_aPedido['referencia_externa'] = $ref_externa;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
	}

	/**
	  * Metodo encargado de Retornar la referencia Externa del Documento.
	  */
	function get_ext_reference() {
		return $this->_aPedido['referencia_externa'];
	}

	/**
	  * Metodo destinado a permitir al entrada de datos del pedido en un array en vez de usando los metodos.
	  **/
	function set_info($aPedido) {
	}

	function get_info() {
		return $this->_aPedido;
	}

	/**
	  * Metodo encargado de establecer la forma de pago de este pedido.
	  **/
	function set_payment_method($id_forma_pago,$bForce = FALSE) {
		if (!isset($bForce)) $bForce = FALSE;
		if (!isset($id_forma_pago) OR !is_numeric($id_forma_pago)) return FALSE;
		if ((int)$id_forma_pago == $this->_aPedido['id_forma_pago']) return TRUE;
		
		$cons = "SELECT ".
				  "FPago.id_forma_pago as 'id_forma_pago', ".
				  "FPago.nombre as 'nombre_forma_pago', ".
				  "FPago.num_efectos as 'num_efectos', ".
				  "FPago.dias_efectos as 'dias_efectos', ".
				  "FPago.medio_pago as 'medio_pago' ".
				  "FROM Forma_pago `FPago` ".
				  "WHERE FPago.id_forma_pago = $id_forma_pago";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return FALSE;
		$aTmp = $this->_db->fetch_assoc($idrs);
		$this->_aPedido['id_forma_pago'] = $aTmp['id_forma_pago'];
		$this->_aPedido['nombre_forma_pago'] = $aTmp['nombre_forma_pago'];

		/** Documentar!!!!!! **/
		$this->_aFPago['nombre'] = $aTmp['nombre_forma_pago'];
		$this->_aFPago['id_forma_pago'] = $aTmp['id_forma_pago'];
		$this->_aFPago['dias_efectos'] = $aTmp['dias_efectos'];
		$this->_aFPago['num_efectos'] = $aTmp['num_efectos'];
		$this->_aFPago['medio_pago'] = $aTmp['medio_pago'];
		// print_r($this->_aFPago);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);

		return TRUE;
	}

	/**
	  * Metodo que retorna la forma de pago estipulada para este pedido.
	  **/
	function get_payment_method() {
		return $this->_aPedido['id_forma_pago'];
	}

	/**   -- Metodos de Cabeceras y Pies -- **/
	
	/**
	  * Obtiene el id_articulo de la linea de detalle indicada.
	  **/
	function get_detail_article_id($idx_det = NULL) {
		if (!isset($idx_det)) $idx_det = $this->_DetIdx_act;
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		return $this->_aDetalles[$idx_det]['id_articulo'];
	}

	/**
	  * Metodo encargado de obtener el identificador idx_detalle a partir de un id_detalle de la db
	  **/
	function get_idxdetail_db($id_det) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		return $this->_aDetIdx[$id_det];
	}

	function set_idxdetail_db($idx,$id_detalle) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return NULL;
		}
		if (!is_numeric($idx) OR !is_numeric($id_detalle)) return FALSE;
		if (!is_array($this->_aDetalles[$idx])) return FALSE;
		$this->_aDetIdx[$id_detalle] = $idx;
		$this->_aDetalles[$idx]['id_detalle'] = $id_detalle;
		return TRUE;
	}

	/**
	  * Metodo que devuelve un array con los identificadores de detalle que contienen un articulo especificado.
	  */
	function get_idxdetail_art($id_art) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		$id_art = (int)$id_art;
		if (!is_array($this->_aDetIdx_Art[$id_art]) OR empty($this->_aDetIdx_Art[$id_art])) return NULL;
		else return $this->_aDetIdx_Art[$id_art];
	}

	function setDetailAttribute($idx,$campo,$valor = NULL) {
		return $this->set_detail_attribute($idx,$campo,$valor);
	}
	function getDetailAttribute($idx,$campo) {
		return $this->get_detail_attribute($idx,$campo);
	}

	function set_detail_attribute($idx,$campo,$valor = NULL) {
		if (!is_numeric($idx)) return false;
		if (!is_array($this->_aDetalles[$idx]) OR !sizeof($this->_aDetalles[$idx])) return false;
		$this->_aDetalles[$idx][$campo] = $valor;
		return true;
	}

	function get_detail_attribute($idx,$campo) {
		if (!is_numeric($idx)) $idx = $this->current_detail();
		if (!is_numeric($idx)) return NULL;
		if (!is_array($this->_aDetalles[$idx]) OR !sizeof($this->_aDetalles[$idx])) return NULL;
		return $this->_aDetalles[$idx][$campo];
	}

	function setHeaderAttribute($campo,$valor = NULL) {
		return $this->set_header_attribute($campo,$valor);
	}
	function getHeaderAttribute($campo) {
		return $this->get_header_attribute($campo);
	}

	function set_header_attribute($campo,$valor = NULL) {
		if (!is_array($this->_aPedido) OR !sizeof($this->_aPedido)) return FALSE;
		$this->_aPedido[$campo] = $valor;
		return TRUE;
	}

	function get_header_attribute($campo) {
		if (!is_array($this->_aPedido) OR !sizeof($this->_aPedido)) return NULL;
		return $this->_aPedido[$campo];
	}

	/** 
	  * Metodo para obtener la informacion de una linea de detalle determinada.
	  * @param $idx_det	-	Identificador del detalle a devolver
	  * @return array()	-	Array associativo con las informacion de la linea de detalle.
	  */
	function get_detail($idx_det) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		return $this->_aDetalles[$idx_det];
	}

	function get_detail_contract($idx_det) {
		if (!is_numeric($idx_det)) return NULL;
		if (!is_array($this->_aDetalles[$idx_det]) OR !is_numeric($this->_aDetalles[$idx_det]['id_servicio'])) return NULL;
		return $this->_aServicios[$this->_aDetalles[$idx_det]['id_servicio']];
	}

	/**
	  * Anyade Comentarios a la linea de detalle.
	  *
	  **/
	function set_detail_comment($idx_det,$big_text) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		$this->_aDetalles[$idx_det]['observaciones'] = $big_text;

		$this->_aModif['detalles'][$idx_det] |= inmPed_MODIFIED;
		$this->_change_flags(inmPed_CHG_DETAIL);
		return 1;
	}

	/**
	  * Obtiene los Comentarios de una linea de detalle.
	  *
	  **/
	function get_detail_comment($idx_det) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		return ( (!empty($this->_aDetalles[$idx_det]['observaciones'])) ? $this->_aDetalles[$idx_det]['observaciones'] : NULL);
	}

	/**
	  * Cambia la cantidad de una linea de detalle.
	  * @param $idx_det	-	Identificador de la linea de detalle que se ha de modificar.
	  * @param $cantidad	-	Cantidad a insertar en la linea de detalle.
	  * @paran $bBultos	-	Si la cantidad indicada son bultos (true) o unidades(false).
	  * @param $bSuma		-	Si la cantidad indicada ha de ser sumada o asignada. 
	  * @param $mTipo		-	Si la cantidad indicada se ha de marcar como recibida/pedida/normal 
	  *							(inmPed_QUANTITY_DELIVERED | inmPed_QUANTITY_REQUESTED | inmPed_QUANTITY) 
	  * @paran $bDtos		-	Si han de volver a Comprobar los descuentos.
	  * @return bool		-	Si se han producido los cambios correctamente o no.
	  * NOTA: Metodo sobrecargado en la clase Invoice
	  */
	function set_quantity($idx_det,$cantidad,$bBultos = 0,$bSuma = FALSE,$mTipo = inmPed_QUANTITY,$bDtos = TRUE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return false;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!is_numeric($cantidad)) return 0;
		if (!isset($bDtos)) $bDtos = true;
		if (!isset($bBultos)) $bBultos = 0;
		if (!isset($bSuma)) $bSuma = false;
		if (!isset($mTipo)) $mTipo = inmPed_QUANTITY;

		/** ** (Jodemos los cambios de cantidades de las promos)
		$price = $this->get_price($idx_det);
		if ( ($this->_fPedido & inmPed_STRICT) AND empty($price)) {
			$this->error(600,"No se puede cambiar la cantidad de un articulo sin cargo");
			return FALSE;
		}
		/** **/
		if ($this->debug) debug("set_quanetity($idx_det, $cantidad, $bBultos, sumga: $bSuma, tipos: $mTipo, dtos: $bDtos)");

		if (is_numeric($cantidad )) {
			if (is_integer($cantidad)) $cantidad = (int)$cantidad;
			else $cantidad = Document::format_number($cantidad,$this->op_decimals);
		} else $cantidad = (int)$cantidad;
		if ($bBultos) 
			if ($bBultos==1 AND is_numeric($this->_aDetalles[$idx_det]['unidades_bulto'])) {
				$cantidad *= ($this->_aDetalles[$idx_det]['unidades_bulto']);
			} elseif ($bBultos==2 AND is_numeric($this->_aDetalles[$idx_det]['unidades_bulto']) 
					AND is_numeric($this->_aDetalles[$idx_det]['bultos_capa_palet']) ) {
				$cantidad *= ($this->_aDetalles[$idx_det]['unidades_bulto']) * ($this->_aDetalles[$idx_det]['bultos_capa_palet']) ;
			} elseif ($bBultos==3 AND is_numeric($this->_aDetalles[$idx_det]['unidades_bulto'])
					AND is_numeric($this->_aDetalles[$idx_det]['bultos_capa_palet']) AND is_numeric($this->_aDetalles[$idx_det]['capas_palet']) ) {
				$cantidad *= ($this->_aDetalles[$idx_det]['unidades_bulto']) * ($this->_aDetalles[$idx_det]['bultos_capa_palet'])
									* ($this->_aDetalles[$idx_det]['capas_palet']);
			}

		$modif_mask = (inmPed_CHG_DETAIL | inmPed_MODIFIED);
		if ( ($this->_aDetalles[$idx_det]['cantidad'] != $cantidad OR $bSuma) AND is_numeric($cantidad)) {
			if ($bSuma) $this->_aDetalles[$idx_det]['cantidad'] += $cantidad;
			else $this->_aDetalles[$idx_det]['cantidad'] = $cantidad;
			$this->_aDetalles[$idx_det]['peso'] = 
				$this->_aDetalles[$idx_det]['peso_unidad'] * ($this->_aDetalles[$idx_det]['cantidad']);
			$modif_mask |= inmPed_CHG_DET_QUANTITY;
		} else return true;

		if ($mTipo & inmPed_QUANTITY_DELIVERED) {
			if ($bSuma) $this->_aDetalles[$idx_det]['cantidad_recibida'] += $cantidad;
			else $this->_aDetalles[$idx_det]['cantidad_recibida'] = $cantidad;
			$modif_mask |= inmPed_CHG_DET_QUANTITY;
		} 
		if ($mTipo & inmPed_QUANTITY_REQUESTED) {
			if ($bSuma) $this->_aDetalles[$idx_det]['cantidad_pedida'] += $cantidad;
			else $this->_aDetalles[$idx_det]['cantidad_pedida'] = $cantidad;
			$modif_mask |= inmPed_CHG_DET_QUANTITY;
		}

		if ( $bDtos AND !($aTmp = $this->check_client_discount($idx_det,TRUE)) AND
					!($aTmp = $this->check_offers($idx_det,TRUE))  AND
					!($aTmp = $this->check_volume_discount($idx_det,TRUE)) ) {
			if ($this->debug) debug("set_quantity($idx_det) - No hay descuentos!");
		} elseif($bDtos) {
			if ($this->debug) debug("set_quantity ha localizado descuentos aplicables..");
			if ($this->debug) print_r($aTmp);
			// $this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_DISCOUNT;
			$modif_mask |= inmPed_CHG_DET_DISCOUNT;
		}
		$this->_change_flags($modif_mask,$idx_det);

		if ($this->debug)
			debug("set_quantity($idx_det)... ".
					" Recibida = ".$this->_aDetalles[$idx_det]['cantidad_recibida'].
					" Pedida = ".$this->_aDetalles[$idx_det]['cantidad']
					);
		// $this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_QUANTITY;

		if ($this->debug) debug("set_quantity() el detalle:");
		// if ($this->debug) print_r($this->_aDetalles[$idx_det]);
		return true;
	}

	/**
	  * Obtiene la cantidad de una linea de detalle.
	  * @param $idx_det	-	Identificador del detalle que hay que consultar.
	  * @param $bBultos	-	Si la cantidad ha retornar ha de ser en bultos(1)/capas(2)/palets(3).
	  * @param $mTipo		-	Si la cantidad indicada se ha de marcar como recibida/pedida/normal 
	  *							(inmPed_QUANTITY_DELIVERED | inmPed_QUANTITY_REQUESTED | inmPed_QUANTITY) 
	  **/
	function get_quantity($idx_det,$bBultos = 0, $mTipo = inmPed_QUANTITY ) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!isset($bBultos)) $bBultos = 0;

		if ($mTipo & inmPed_QUANTITY_DELIVERED) $campo_cantidad = 'cantidad_recibida';
		elseif ($mTipo & inmPed_QUANTITY_REQUESTED) $campo_cantidad = 'cantidad_pedida';
		else $campo_cantidad = 'cantidad';

		if ($bBultos)
			if ($bBultos == 1 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto']) {
				$cant = $this->_aDetalles[$idx_det][$campo_cantidad] / $this->_aDetalles[$idx_det]['unidades_bulto'];
			} elseif ($bBultos==2 AND $this->_aDetalles[$idx_det]['unidades_bulto'] 
					AND $this->_aDetalles[$idx_det]['bultos_capa_palet']) {
				$cant = $this->_aDetalles[$idx_det][$campo_cantidad] /
				  		($this->_aDetalles[$idx_det]['unidades_bulto'] * $this->_aDetalles[$idx_det]['bultos_capa_palet']);
			} elseif ($bBultos==3 AND $this->_aDetalles[$idx_det]['unidades_bulto']
					AND $this->_aDetalles[$idx_det]['bultos_capa_palet'] AND $this->_aDetalles[$idx_det]['capas_palet']) {
				$cant =  $this->_aDetalles[$idx_det][$campo_cantidad] /
						($this->_aDetalles[$idx_det]['unidades_bulto'] * $this->_aDetalles[$idx_det]['bultos_capa_palet']
									* $this->_aDetalles[$idx_det]['capas_palet']);
			} else {
				//Fixme: revisar consecuencias de comentar esto.
				//  $this->error(510,"El detalle indicado no tiene unidades por bulto. Division por 0");
				return NULL;
			}
		else $cant = $this->_aDetalles[$idx_det][$campo_cantidad];

		if ($this->debug) debug("get_quantity($idx_det) de la ($campo_cantidad) ?? = $cant");
		return $cant;
	}

	/**
	  * Metodo que establece el descuento, y tipo de descuento de una linea de detalle.
	  * @param $idx_det	-	Id de la linea de detalle a modificar.
	  * @param $discount	-	Descuento a aplicar.
	  * @param $bPto		-	Si es un porcierto o un Monto.
	  * @param $nombre	-  Nombre del descuento.
	  * @param $bForce	-	Forzar la modificacion cuando ya existe un descuento.
	  * @return bool		-  Si la operacion se ha realizado con exito.
	  * NOTA: Metodo sobrecargado en la clase Invoice
	  **/
	function set_detail_discount($idx_det,$discount = NULL,$bPto = TRUE,$nombre = NULL,$bForce = FALSE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		// Valores por defecto.
		if (!isset($bPto)) $bPto = TRUE;
		if (!$bForce) $bForce = FALSE;
		$done = FALSE;
		if ($this->debug) debug("set_detail_discount() al id $idx_det de $discount en porciento($bPto) con nombre($nombre) forzar($bForce)");
		$chg_dto = FALSE;
		if (is_numeric($discount)) 
			if (($bPto OR (empty($discount) AND $this->have_discount($idx_det)) ) AND (!$this->have_discount($idx_det) OR $bForce)) {
				if ($discount > 100) $discount = 100;
				$this->_aDetalles[$idx_det]['precio_tarifa_descuento'] = $this->_aDetalles[$idx_det]['precio_tarifa'] -
					  ($this->_aDetalles[$idx_det]['precio_tarifa'] * $discount / 100);
				if ($this->_aDetalles[$idx_det]['descuento'] != $discount) $chg_dto = TRUE;
				$this->_aDetalles[$idx_det]['descuento'] = $discount;
				$this->_aDetalles[$idx_det]['dto_aplicado'] = $discount;
				$done = true;
			} 
			if ((!$bPto OR (empty($discount) AND $this->have_discount($idx_det)) ) AND 
						(!$this->have_discount($idx_det) OR $bForce) AND (!empty($this->_aDetalles[$idx_det]['precio_tarifa']))) { // Si precio != 0
				$mnt = $this->get_detail_ammount($idx_det);
				if ($mnt < $discount) $discount = $mnt;
				$this->_aDetalles[$idx_det]['precio_tarifa_descuento'] = $this->_aDetalles[$idx_det]['precio_tarifa'] -
					  ( $discount );
				if ($this->_aDetalles[$idx_det]['monto'] != $discount) $chg_dto = TRUE;
				$this->_aDetalles[$idx_det]['monto'] = $discount;
				$this->_aDetalles[$idx_det]['dto_aplicado'] = $discount;
				$done = true;
			}
		if ($done OR $bForce) {
			$this->_aDetalles[$idx_det]['tipo_descuento'] = $nombre;
			// $done = TRUE;
		}
		if ($done) {
			$this->_aDetalles[$idx_det]['precio_tarifa_descuento'] =
					  Document::format_number($this->_aDetalles[$idx_det]['precio_tarifa_descuento'],$this->op_decimals);
			if ($chg_dto) {
				if ($this->debug) debug("<b>Cambiando flags ...</b>");
				$this->_change_flags(inmPed_CHG_DETAIL | inmPed_CHG_DET_DISCOUNT,$idx_det);
			}
		}
	}

	/**
	  * Con este metodo obtenemos los descuentos de una linea de detalle. (si tiene)
	  * @param $idx	-	Identificador de la linea de detalle de la cual se desea obtener los descuentos.
	  * @return NULL - on Error ; array() - on !discounts; array("porciento","monto","tipo") on discounts
	  **/
	function get_detail_discount($idx) {
		if (!is_numeric($idx)) return NULL;
		if (!is_array($this->_aDetalles[$idx])) return NULL;
		if (!$this->have_discount($idx)) return array();
		else return array("porciento" => $this->_aDetalles[$idx]['descuento'],
								"monto"		=> $this->_aDetalles[$idx]['monto'],
								"tipo"		=> $this->_aDetalles[$idx]['tipo_descuento']);
	}

	/**
	  * Este metodo establece el precio del articulo indicado en el detalle idx
	  * @param $idx_detalle		-	Detalle al cual hay que cambiarle el precio
	  * @param $price				-  Precio que se desea poner.
	  * @param $bDiscount		-	Si el precio incluye descuento o no
	  * @return bool		- Si la operacion se ha realizado con exito.
	  * NOTA: Metodo sobrecargado en la clase Invoice
	  **/
	function set_price($idx_det,$price = 0,$bDiscount = true) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return NULL;
		}
		if (!is_numeric($price)) return false;
		if (!is_array($this->_aDetalles[$idx_det])) return false;
		if ($this->debug) 
			debug("Establecemos($idx_det) el precio... $price");

		$this->_aDetalles[$idx_det]['precio_tarifa'] = $price;
		//Si alquien quiere un descuento, que use set_detail_discount():
		// if ($bDiscount) $this->_aDetalles[$idx_det]['precio_tarifa_descuento'] = $price;

//debug("Resultado = ");
// print_r($this->_aDetalles[$idx_det]);

		// Marcamos el cambio.
		// $this->_aModif[detalles][$idx_det] |= inmPed_CHG_DET_PRICE;
		$this->_change_flags(inmPed_CHG_DETAIL | inmPed_CHG_DET_PRICE,$idx_det);

		return true;
	}

	/**
	  * Este metodo devuelve el precio del articulo indicado en el detalle idx
	  * @param $idx_detalle		-	Detalle al cual hay que cambiarle el precio
	  * @param $bDiscount		-	Si el precio ha de incluir el descuento del detalle o no
	  * @return float				- Precio del articulo en la linea de detalle
	  **/
	function get_price($idx_det,$bDiscount = TRUE) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!isset($bDiscount)) $bDiscount = FALSE;

		if ($bDiscount AND $this->_aDetalles[$idx_det]['precio_tarifa_descuento']) $fld = 'precio_tarifa_descuento';
		else $fld = 'precio_tarifa';
		$fld = 'precio_tarifa'; //Fixme: Precio tarifa descuento desabilidato

		return $this->_aDetalles[$idx_det][$fld];
	}

	function get_detail_ammount($idx_det) {
		if (!is_numeric($idx_det)) return NULL;
		return $this->_aDetalles[$idx_det]['base_imponible'];
	}

	function set_detail_ammount($idx_det,$importe) {
		if (!is_numeric($idx_det)) return NULL;
		$this->_aDetalles[$idx_det]['base_imponible'] = $importe;
		$this->_change_flags(inmPed_CHG_DETAIL | inmPed_MODIFIED,$idx_det);
		return true;
	}

	/**
	  * Devuelve la informacion de los impuestos aplicados al pedido.
	  */
	function get_taxes() {
		return $this->_aIVAs;
	}

	/**
	  * Devuelve la informacion de los descuentos globales aplicados al pedido en base al cliente.
	  */
	function get_discounts() {
		return $this->_aDescuentos;
	}

	function set_discount($orden,$dto,$nombre = NULL,$bFinanciero = false) {
		if (!is_numeric($orden)) return false;
		if (!$dto OR !is_numeric($dto)) return false;
		$this->_aDescuentos['detalle'][$orden]['orden'] = $orden;
		$this->_aDescuentos['detalle'][$orden]['nombre'] = $nombre;
		$this->_aDescuentos['detalle'][$orden]['descuento'] = $dto;
		$this->_aDescuentos['detalle'][$orden]['financiero'] = (bool)$bFinanciero;
		$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
		if ($this->_calculate_discounts()) {
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		}
	}

	function clean_discounts() {
		if (is_array($this->_aDescuentos) AND sizeof($this->_aDescuentos) ) {
			$this->_reset_discounts();
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_DB_DELETED);
		}
	}

	/**
	  * Obtiene la informacion de los calculos totales del pedido.
	  */
	function get_totals($campo = NULL) {
		if (empty($campo)) {
			return $this->_aTotales;
		} else return $this->_aTotales[$campo];
	}

	function set_total($campo,$valor) {
		// Solo monto a cuenta
		if (strcasecmp($campo,'monto_cuenta')) return false;

		if (!is_numeric($valor)) return false;
		$this->_aTotales[$campo] = $valor;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		$this->_calculate_totals(false);

		return true;
	}

	/**
	  * Mentodo encargado de decirnos si el metodo es de Compra/Venta
	  **/
	function getMode() {
		if ($this->_fPedido & inmPed_VENTA) {
			return inmPed_VENTA;
		} else return inmPed_COMPRA;
	}

	/**
	  * Mentodo encargado de establecer el metodo es de Compra/Venta
	  **/
	function setMode($tipo) {
		if ($tipo & inmPed_VENTA) {
			$this->_fPedido &= ~inmPed_COMPRA;
			$this->_fPedido |= inmPed_VENTA;
		} else {
			$this->_fPedido &= ~inmPed_VENTA;
			$this->_fPedido |= inmPed_COMPRA;
		}
	}

	function __get($prop_name) {
		if ($this->debug) debug("Metodo get general ($prop_name,$prop_value)");
		return $this->$prop_name;
	}

	function __set($prop_name,$prop_value) {
		if ($this->debug) debug("Metodo set general ($prop_name,$prop_value)");
	}

	function __call($metodo,$aArgs) {
		if ($this->debug) debug("Metodo CALL general ($metodo,$aArgs)");
	}

	function set_db($db_name) {
		// $app = $this->App_Name;
		// global $$app;
		// debug("set_db( -".$this->App_Name."- $db_name )");
		$Sesion = &$_SESSION[$this->App_Name];
		// debug("set_db( -".$this->App_Name."- $db_name )");
		if (empty($db_name)) $db = &$Sesion->get_db($this->_db_name);
		else {
			$this->_db_name = $db_name;
			$db = &$Sesion->get_db($this->_db_name);
		}
		$this->_db = &$db;
		return TRUE;
	}

	function set_tipo_pedido($tipo) {
		if ($tipo & inmPed_VENTA)
			$this->_fPedido |= inmPed_VENTA;
		else { // Si no es de venta, es de compra.
			$this->_fPedido &= ~inmPed_VENTA;
		}
		return 1;
	}

	/** FIN de los Metodos set y get **/

	/** 
	  * Metodos de funcionalidades inherentes a la instancia 
	  *
	  ****** Metodos Privados:  ********
	  **/

	/**
	  * Metodo que establece/asigna la empresa emisora del documento pedido actual.
	  * @return bool	-	Si se ha establecido el emisor con exito o no.
	  **/
	function _set_enterprise_issuer($id_empresa) {
		if (!(int)$id_empresa) return FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}
		$id_cliente = (int)$this->_aReceptor['id_cliente'];
		// Caso de compras, id_proveedor
		$cons = "SELECT ".  // Datos del Emisor
				  "Emp.retencion as 'emp_retencion', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto,NULL) as 'emp_dto_bulto', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto_uds,NULL) as 'emp_dto_bulto_uds', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa,NULL) as 'emp_dto_capa', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa_uds,NULL) as 'emp_dto_capa_uds', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet,NULL) as 'emp_dto_palet', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet_uds,NULL) as 'emp_dto_palet_uds', ".
				  "Emp.id_empresa as 'emp_id_empresa', ".
				  "Emp.id_empresa as 'emp_id', ".
				  "Emp.razon_social as 'emp_razon_social', ".
				  "Emp.capital_social as 'emp_capital_social', ".
				  "Emp.inscripcion_registro as 'emp_inscripcion_registro', ".
				  "Emp.cif as 'emp_cif', ".
				  "Emp.prefijo_cif as 'emp_prefijo_cif', ".
				  "Emp.direccion_facturacion as 'emp_direccion_facturacion', ".
				  "Emp.cp as 'emp_cp', ".
				  "Emp.poblacion as 'emp_poblacion', ".
				  "Prov.nombre as 'emp_provincia', ".
				  "Emp.fax as 'emp_fax', ".
				  "Emp.telefono1 as 'emp_telefono1', ".
				  "Emp.web as 'emp_web', ".
				  "Emp.email as 'emp_email', ".
				  "Emp.id_empresa as 'ped_id_empresa', ". 
				  "Div.id_divisa as 'ped_id_divisa', ". 
				  // Divisa del Pedido (=emisor).
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.ratio as 'div_ratio' ".
				  (	($id_cliente) 
						?  ", CliEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
							"FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
							"FPago.nombre as 'fpa_nombre', ".
							"FPago.id_forma_pago as 'fpa_id_forma_pago', ".
							"FPago.num_efectos as 'fpa_num_efectos', ".
							"FPago.dias_efectos as 'fpa_dias_efectos', ".
							"FPago.medio_pago as 'fpa_medio_pago', ".
							// Tarifa de precios (solo ventas)
							"Tar.nombre as 'tar_nombre', ".
							"Tar.campo_accion as 'tar_campo_accion', ".
							"Tar.campo_recomendacion as 'tar_campo_recomendacion', ".
							"Tar.pto_recomendacion as 'tar_pto_recomendacion', ".
							"Tar.coniva_recomendacion as 'tar_coniva_recomendacion', ".
							"Tar.pto_primero as 'tar_pto_primero', ".
							"Tar.pto_segundo as 'tar_pto_segundo', ".
							"Tar.monto as 'tar_monto', ".
							"CliEmp.dia_facturacion_1 as 'fpa_dia_I', ".	
							"CliEmp.dia_facturacion_2 as 'fpa_dia_II', ".	
							"CliEmp.dia_facturacion_3 as 'fpa_dia_III', ".	
							"CliEmp.id_tarifa as 'ped_id_tarifa', ".	// defecto cliente
							"TCli.aplicar_iva as 'cli_aplicar_iva', ".
							"TCli.aplicar_recargo as 'cli_aplicar_recargo', ".
							"CliEmp.dto_directo as 'cli_dto_directo', ".
							"CliEmp.dto_pronto_pago as 'cli_dto_pronto_pago', ".
							"CliEmp.aplicar_retencion as 'cli_aplicar_retencion', ".
							"CliEmp.mostrar_ofertas as 'cli_mostrar_ofertas', ".
							"CliEmp.cc_banco as 'cli_cc_banco', ".
							"CliEmp.cc_cliente as 'cli_cc_cliente', ".
							"CliEmp.cc_gastos as 'cli_cc_gastos', ".
							"CliEmp.cc_ventas as 'cli_cc_ventas', ".
							"CliEmp.cc_descuento_financiero as 'cli_cc_descuento_financiero', ".
							"CliEmp.cc_descuento_comercial as 'cli_cc_descuento_comercial', ".
							"CliEmp.cc_retenciones as 'cli_cc_retenciones', ".
							"CliEmp.cc_efectos as 'cli_cc_efectos' "
						: "").
				  "FROM Empresas `Emp`, Divisa `Div`, Provincias `Prov` ".
				  (	($id_cliente)
						?	", Tarifas `Tar`, Forma_pago `FPago`, Clientes_empresas `CliEmp`, ".
							"Tipo_cliente `TCli` "
						: "").
				  "WHERE Emp.id_divisa = Div.id_divisa AND Emp.id_empresa = $id_empresa AND Emp.id_provincia = Prov.id_provincia ".
				  (	($id_cliente)
						?	"AND CliEmp.id_empresa = Emp.id_empresa AND CliEmp.id_cliente = $id_cliente AND ".
							"CliEmp.id_forma_pago = FPago.id_forma_pago AND CliEmp.id_tarifa = Tar.id_tarifa AND ".
							"CliEmp.id_tipo_cliente = TCli.id_tipo_cliente "
						: "");
		$id_rs = $oDb->query($cons);
		if ($oDb->num_rows($id_rs)) {
			  $aPedido = $oDb->fetch_assoc($id_rs);
			  foreach($aPedido as $clave => $valor) {
					$ref_arr = substr($clave,0,4);
					$ref_resto = substr($clave,4);
					// debug("parcial = $ref_arr, resto = $ref_resto");
					if (!strcasecmp($ref_arr,'ped_')) {
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
					}
			  }
		} else return FALSE;
				
		return TRUE;
	}

	/**
	  * Metodo que establece/asigna al proveedor emisor del documento pedido actual.
	  * @return bool	-	Si se ha establecido el emisor con exito o no.
	  **/
	function _set_provider_issuer($id_proveedor) {
		if (!(int)$id_proveedor) return FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}
		$id_empresa = (int)$this->_aReceptor['id_empresa'];
		// Caso de compras, id_proveedor
		$cons = "SELECT ".  // Datos del Emisor
				  "Prv.retencion as 'prv_retencion', ".
				  "IF(Prv.dto_gnrl_vol_bulto,Prv.dto_gnrl_vol_bulto,NULL) as 'prv_dto_bulto', ".
				  "IF(Prv.dto_gnrl_vol_bulto,Prv.dto_gnrl_vol_bulto_uds,NULL) as 'prv_dto_bulto_uds', ".
				  "IF(Prv.dto_gnrl_vol_capa,Prv.dto_gnrl_vol_capa,NULL) as 'prv_dto_capa', ".
				  "IF(Prv.dto_gnrl_vol_capa,Prv.dto_gnrl_vol_capa_uds,NULL) as 'prv_dto_capa_uds', ".
				  "IF(Prv.dto_gnrl_vol_palet,Prv.dto_gnrl_vol_palet,NULL) as 'prv_dto_palet', ".
				  "IF(Prv.dto_gnrl_vol_palet,Prv.dto_gnrl_vol_palet_uds,NULL) as 'prv_dto_palet_uds', ".
				  "Prv.id_proveedor as 'prv_id_proveedor', ".
				  "Prv.id_proveedor as 'prv_id', ".
				  "Prv.razon_social as 'prv_razon_social', ".
				  "Prv.cif as 'prv_cif', ".
				  "Prv.prefijo_cif as 'prv_prefijo_cif', ".
				  "Prv.domicilio as 'prv_direccion_facturacion', ".
				  "Prv.cp as 'prv_cp', ".
				  "Prv.poblacion as 'prv_poblacion', ".
				  "Prov.nombre as 'prv_provincia', ".
				  "Prv.fax as 'prv_fax', ".
				  "Prv.telefono1 as 'prv_telefono1', ".
				  "Prv.web as 'prv_web', ".
				  "Prv.email as 'prv_email', ".
				  "Prv.id_proveedor as 'ped_id_proveedor', ". 
				  "Div.id_divisa as 'ped_id_divisa', ". 
				  // Divisa del Pedido (=emisor).
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.ratio as 'div_ratio', ".
				  "(1/Div.ratio) as 'emp_div_ratio' ".
				  (	($id_empresa) 
						?  ", PrvEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
							"FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
							"FPago.nombre as 'fpa_nombre', ".
							"FPago.id_forma_pago as 'fpa_id_forma_pago', ".
							"FPago.num_efectos as 'fpa_num_efectos', ".
							"FPago.dias_efectos as 'fpa_dias_efectos', ".
							"FPago.medio_pago as 'fpa_medio_pago', ".
							"PrvEmp.dia_facturacion_1 as 'fpa_dia_I', ".	
							"PrvEmp.dia_facturacion_2 as 'fpa_dia_II', ".	
							"PrvEmp.dia_facturacion_3 as 'fpa_dia_III', ".	
							"PrvEmp.aplicar_iva as 'emp_aplicar_iva', ".
							"PrvEmp.comunitario as 'emp_comunitario', ".
							"PrvEmp.aplicar_recargo as 'emp_aplicar_recargo', ".
							"PrvEmp.descuento as 'emp_dto_directo', ".
							"PrvEmp.descuento_financiero as 'emp_dto_pronto_pago', ".
							"PrvEmp.aplicar_retencion as 'emp_aplicar_retencion', ".
							"PrvEmp.cc_banco as 'emp_cc_banco', ".
							"PrvEmp.cc_proveedor as 'emp_cc_proveedor', ".
							"PrvEmp.cc_gastos as 'emp_cc_gastos', ".
							"PrvEmp.cc_compras as 'emp_cc_compras', ".
							"PrvEmp.cc_descuento_financiero as 'emp_cc_descuento_financiero', ".
							"PrvEmp.cc_descuento_comercial as 'emp_cc_descuento_comercial', ".
							"PrvEmp.cc_retenciones as 'emp_cc_retenciones', ".
							"PrvEmp.cc_efectos as 'emp_cc_efectos' "
						: "").
				  "FROM Proveedores `Prv`, Divisa `Div`, Provincias `Prov` ".
				  (	($id_empresa)
						?	", Forma_pago `FPago`, Proveedores_empresas `PrvEmp`, ".
							"Divisa `Div2`, Empresas `Emp` "
						: "").
				  "WHERE Prv.id_divisa = Div.id_divisa AND Prv.id_proveedor = $id_proveedor AND Prv.id_provincia = Prov.id_provincia ".
				  (	($id_empresa)
						? 	"AND PrvEmp.id_empresa = $id_empresa AND PrvEmp.id_empresa = Emp.id_empresa AND ".
							"PrvEmp.id_forma_pago = FPago.id_forma_pago AND Emp.id_divisa=Div2.id_divisa AND PrvEmp.id_proveedor = Prv.id_proveedor "
						: "");
		$id_rs = $oDb->query($cons);
		if ($oDb->num_rows($id_rs)) {
			  $aPedido = $oDb->fetch_assoc($id_rs);
			  foreach($aPedido as $clave => $valor) {
					$ref_arr = substr($clave,0,4);
					$ref_resto = substr($clave,4);
					// debug("parcial = $ref_arr, resto = $ref_resto");
					if (!strcasecmp($ref_arr,'ped_')) {
						$this->_aPedido[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'emp_')) {
						$this->_aReceptor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'prv_')) {
						$this->_aEmisor[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'div_')) {
						$this->_aDivisa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'fpa_')) {
						$this->_aFPago[$ref_resto] = $valor;
					}
			  }
		} else return FALSE;
				
		return TRUE;
	}

	/**
	  * Metodo que establece/asigna el cliente receptor del documento pedido actual.
	  * @param	$id_cliente	-	cliente que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return		bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function _set_client_reciever($id_cliente,$bForce = FALSE) {
		// Separar este bloque y los 2 del final en 3 metodos? 2 solo para los del final?

		if (!is_numeric($id_cliente)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		// Si tenemos un agente seleccionado y el pedido esta marcado como estricto,
		//		el cliente solo puede ser alguno de los clientes del agente.
		if ((int)$this->_aPedido['id_agente'] AND $this->_fPedido & inmPed_STRICT) { 
			// Fixme: Que pasa si un cliente no tiene agentes? podria este agente hacer el pedido?.
			if (is_array($this->_aClientes_agente) AND !is_array($this->_aClientes_agente[$id_cliente])) {
				$this->error('DOCUMENT_NO_AGENTS_RECIEVER');
				return FALSE;
			} else {
				$id_cliente = (int)$id_cliente;
				$this->_aAgente['comision'] = $this->_aClientes_agente[$id_cliente]['comision'];
				$this->_aAgente['comision_repartida'] = $this->_aClientes_agente[$id_cliente]['comision_repartida'];
			}
		}
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}
		// Fixme: Hacer comprobacion de si el cliente seleccionado es el mismo que el activo ahora mismo.
		// Fixme: Permitir cambio de cliente, cambiando la tarifa y llamando a eval_conditions()
		$id_empresa = (int)$this->_aEmisor['id_empresa'];
		$id_cli = (int)$this->_aPedido['id_cliente'];
		if ($id_cli != $id_cliente OR $bForce) {
				  // Caso de compras, id_proveedor
				  $cons = "SELECT ".
							 // Datos del receptor
							 "Cli.id_cliente as 'cli_id_cliente', ".
							 "Cli.id_cliente as 'cli_id', ".
							 "Cli.id_cliente as 'ped_id_cliente', ".
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
							 "Prov.nombre as 'cli_provincia', ".
							 "Div2.id_divisa as 'cli_id_divisa', ".
							 "Div2.leyenda as 'cli_div_leyenda', ".
							 "Div2.nombre as 'cli_div_nombre', ".
							 "(1/Div2.ratio) as 'cli_div_ratio' ".
							 (		($id_empresa) 
								  ?  ", CliEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
									  "FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
										"FPago.nombre as 'fpa_nombre', ".
										"FPago.id_forma_pago as 'fpa_id_forma_pago', ".
										"FPago.num_efectos as 'fpa_num_efectos', ".
										"FPago.dias_efectos as 'fpa_dias_efectos', ".
										"FPago.medio_pago as 'fpa_medio_pago', ".
									  // Tarifa de precios (solo ventas)
									  "Tar.nombre as 'tar_nombre', ".
									  "Tar.campo_accion as 'tar_campo_accion', ".
									  "Tar.campo_recomendacion as 'tar_campo_recomendacion', ".
									  "Tar.pto_recomendacion as 'tar_pto_recomendacion', ".
									  "Tar.coniva_recomendacion as 'tar_coniva_recomendacion', ".
									  "Tar.pto_primero as 'tar_pto_primero', ".
									  "Tar.pto_segundo as 'tar_pto_segundo', ".
									  "Tar.monto as 'tar_monto', ".
										"CliEmp.dia_facturacion_1 as 'fpa_dia_I', ".	
										"CliEmp.dia_facturacion_2 as 'fpa_dia_II', ".	
										"CliEmp.dia_facturacion_3 as 'fpa_dia_III', ".	
									  "CliEmp.id_tarifa as 'ped_id_tarifa', ".	// defecto cliente
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
										"CliEmp.cc_efectos as 'cli_cc_efectos' "
								  : "").
							 "FROM Clientes `Cli`, Provincias `Prov`, Divisa `Div2` ".
							 (		($id_empresa)
								  ?	", Tarifas `Tar`, Forma_pago `FPago`, Clientes_empresas `CliEmp`, ".
									  "Tipo_cliente `TCli` "
								  : "").
							 "WHERE Cli.id_cliente = $id_cliente AND Prov.id_provincia = Cli.id_provincia AND ".
							 "Cli.id_divisa = Div2.id_divisa ".
							 (	($id_empresa)
								  ?	"AND CliEmp.id_cliente = Cli.id_cliente AND CliEmp.id_empresa = $id_empresa AND ".
									  "CliEmp.id_forma_pago = FPago.id_forma_pago AND CliEmp.id_tarifa = Tar.id_tarifa AND ".
									  "CliEmp.id_tipo_cliente = TCli.id_tipo_cliente "
								  : "");

				  $id_rs = $oDb->query($cons);
				  if ($oDb->num_rows($id_rs)) {
						 $aPedido = $oDb->fetch_assoc($id_rs);
						 foreach($aPedido as $clave => $valor) {
							  $ref_arr = substr($clave,0,4);
							  $ref_resto = substr($clave,4);
							  // debug("parcial = $ref_arr, resto = $ref_resto");
							  if (!strcasecmp($ref_arr,'ped_')) {
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
							  }
						 }
						 $this->_seek_discounts(TRUE);
				  } else return FALSE;
				  $oDb->libera($id_rs);
		}

		return TRUE;
	}

	/**
	  * Metodo que establece/asigna la empresa receptora del documento pedido actual.
	  * @param	$id_empresa	-	receptor que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return		bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function _set_enterprise_reciever($id_empresa,$bForce = FALSE) {
		// Caso de compras, el id_empresa
		if (!is_numeric($id_empresa)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}

		/** ** De momento no hay Agentes de Compra.
		// Si tenemos un agente seleccionado y el pedido esta marcado como estricto,
		//		el cliente solo puede ser alguno de los clientes del agente.
		if ((int)$this->_aPedido[id_agente] AND $this->_fPedido & inmPed_STRICT) { 
			// Fixme: Que pasa si un cliente no tiene agentes? podria este agente hacer el pedido?.
			if (is_array($this->_aClientes_agente) AND !is_array($this->_aClientes_agente[$id_cliente])) {
				$this->error(500,"El receptor no se corresponde a ninguno de los clientes del agente seleccionado");
				return FALSE;
			} else {
				$id_cliente = (int)$id_cliente;
				$this->_aAgente[comision] = $this->_aClientes_agente[$id_cliente][comision];
				$this->_aAgente[comision_repartida] = $this->_aClientes_agente[$id_cliente][comision_repartida];
			}
		}
		/** **/

		// Fixme: Hacer comprobacion de si el cliente seleccionado es el mismo que el activo ahora mismo.
		// Fixme: Permitir cambio de cliente, cambiando la tarifa y llamando a eval_conditions()
		if ($this->_aPedido['id_proveedor'] == $this->_aEmisor['id'])
			$id_proveedor = (int)$this->_aEmisor['id'];
		else $id_proveedor = NULL;
		if ($this->_aPedido['id_empresa'] == $this->_aReceptor['id'])
			$id_emp = $this->_aReceptor['id'];
		else $id_emp = NULL;

		if ($id_emp != $id_empresa OR $bForce) {
				  // Caso de compras, id_proveedor
				  $cons = "SELECT ".
							 // Datos del receptor
							 "Emp.id_empresa as 'ped_id_empresa', ".
							 "Emp.id_empresa as 'emp_id_empresa', ".
							 "Emp.id_empresa as 'emp_id', ".
							 "Emp.razon_social as 'emp_razon_social', ".
							 "Emp.capital_social as 'emp_capital_social', ".
							 "Emp.inscripcion_registro as 'emp_inscripcion_registro', ".
							 "Emp.nombre as 'emp_nombre', ".
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
							 "Prov.nombre as 'emp_provincia', ".
							 "Div2.id_divisa as 'emp_id_divisa', ".
							 "Div2.leyenda as 'emp_div_leyenda', ".
							 "Div2.nombre as 'emp_div_nombre' ".
							 (		($id_proveedor) 
								  ?  ", PrvEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
									  "FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
									  "FPago.nombre as 'fpa_nombre', ".
									  "FPago.id_forma_pago as 'fpa_id_forma_pago', ".
									  "FPago.num_efectos as 'fpa_num_efectos', ".
									  "FPago.dias_efectos as 'fpa_dias_efectos', ".
									  "FPago.medio_pago as 'fpa_medio_pago', ".
									  "PrvEmp.dia_facturacion_1 as 'fpa_dia_I', ".	
									  "PrvEmp.dia_facturacion_2 as 'fpa_dia_II', ".	
									  "PrvEmp.dia_facturacion_3 as 'fpa_dia_III', ".	
									  "PrvEmp.aplicar_iva as 'emp_aplicar_iva', ".
									  "PrvEmp.comunitario as 'emp_comunitario', ".
									  "PrvEmp.aplicar_recargo as 'emp_aplicar_recargo', ".
									  "PrvEmp.descuento as 'emp_dto_directo', ".
									  "PrvEmp.descuento_financiero as 'emp_dto_pronto_pago', ".
									  "PrvEmp.aplicar_retencion as 'emp_aplicar_retencion', ".
									  "PrvEmp.mantener_ratio_divisa as 'prv_ratio_divisa_dias', ".
										"PrvEmp.cc_banco as 'emp_cc_banco', ".
										"PrvEmp.cc_proveedor as 'emp_cc_proveedor', ".
										"PrvEmp.cc_gastos as 'emp_cc_gastos', ".
										"PrvEmp.cc_compras as 'emp_cc_compras', ".
										"PrvEmp.cc_descuento_financiero as 'emp_cc_descuento_financiero', ".
										"PrvEmp.cc_descuento_comercial as 'emp_cc_descuento_comercial', ".
										"PrvEmp.cc_retenciones as 'emp_cc_retenciones', ".
										"PrvEmp.cc_efectos as 'emp_cc_efectos' "
								  : "").
							 "FROM Empresas `Emp`, Provincias `Prov`, Divisa `Div2` ".
							 (		($id_proveedor)
								  ?	", Forma_pago `FPago`, Proveedores_empresas `PrvEmp` "
								  : "").
							 "WHERE Emp.id_empresa = $id_empresa AND Prov.id_provincia = Emp.id_provincia AND ".
							 "Emp.id_divisa = Div2.id_divisa ".
							 (	($id_proveedor)
								  ?	"AND PrvEmp.id_empresa = Emp.id_empresa AND PrvEmp.id_proveedor = $id_proveedor AND ".
									  "PrvEmp.id_forma_pago = FPago.id_forma_pago "
								  : "");

				  $id_rs = $oDb->query($cons);
				  if ($oDb->num_rows($id_rs)) {
						 $aPedido = $oDb->fetch_assoc($id_rs);
						 foreach($aPedido as $clave => $valor) {
							  $ref_arr = substr($clave,0,4);
							  $ref_resto = substr($clave,4);
							  if (!strcasecmp($ref_arr,'ped_')) {
								  $this->_aPedido[$ref_resto] = $valor;
							  } elseif (!strcasecmp($ref_arr,'emp_')) {
								  $this->_aReceptor[$ref_resto] = $valor;
							  } elseif (!strcasecmp($ref_arr,'prv_')) {
								  $this->_aEmisor[$ref_resto] = $valor;
							  } elseif (!strcasecmp($ref_arr,'div_')) {
								  $this->_aDivisa[$ref_resto] = $valor;
							  } elseif (!strcasecmp($ref_arr,'fpa_')) {
								  $this->_aFPago[$ref_resto] = $valor;
							  }
						 }
						 $this->_seek_discounts(TRUE);
						 $this->_aReceptor['mostrar_ofertas'] = 0;
						 $this->_aReceptor['aplicar_dto_volumen'] = 1;
				  } else return FALSE;
				  $oDb->libera($id_rs);
		}

		return TRUE;
	}

	/**
	  * Este metodo se va a encargar de rellenar los atributos: _aAgentes_cliente y _aClientes_agente
	  * Ambos atributos son de tipo array(array[referencial]). Contienen la lista de los posibles Agentes 
	  *	de un cliente y la de los posibles Clientes de una gente -respectivamente-
	  * La utilidad de ambos arrays esta en el modo stricto del documento, en el cual una vez establecido el 
	  *	cliente o agente del mismo, no es posible indicar otro agente o cliente distinto a los que mantienen
	  *	relacion con la entidad ya seleccionada (cliente o agente).
	  * @param	$id	-	Valor de la clave primaria de agente o cliente en la bbdd.
	  * @return	bool	-	Si se han podido establecer con exito.
	  **/
	function _possible_agents_clients($id, $tipo = 0) {
		if (!is_numeric($tipo) OR !is_numeric($id)) return NULL;

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}

		$retval = FALSE;
		if ($this->_fPedido & inmPed_VENTA) {
			if (!$tipo) { // Rellenar el array de posibles agentes del cliente.
				$cons = "SELECT DISTINCT ".
						  "Ag.id_agente as 'id_agente', ".
						  "CONCAT(Ag.apellidos,', ',Ag.nombre) as 'nombre', ".
						  "IF (AC.comision IS NULL,Ag.comision_base,AC.comision) as 'comision', ".
						  "IF (AC.comision_repartida IS NULL,Ag.comision_repartida,AC.comision_repartida) as 'comision_repartida' ".
						  "FROM Agentes `Ag`, Agentes_clientes `AC` ".
						  "WHERE Ag.id_agente = AC.id_agente AND AC.id_cliente = $id AND AC.fecha_fin IS NULL";
				$id_rs = $oDb->query($cons);
				$this->_aAgentes_cliente = array();
				if ($oDb->num_rows($id_rs)) 
					while ($aTmp = $oDb->fetch_assoc($id_rs)) $this->_aAgentes_cliente[$aTmp['id_agente']] = $aTmp;
				else $this->_aAgentes_cliente = NULL;
				$oDb->libera($id_rs);
				$retval = TRUE;
			} else { // Rellenar el array de posibles clientes del agente.
			}
		} else {
			// Las compras, de momento no tienen agente asociado.
// debug("Agentes de compra? _no_ existen");
			$this->_aAgentes_cliente = NULL;
			$this->_aClientes_agente = NULL;
			$retval = TRUE;
		}

		return $retval;
	}

	/**
	  * Anyade un agente para recibir Comision(es) de esta Factura
	  * @param  id_agente	-  Identificador del agente a establecer como realizador del pedido.
	  * @param  bForce		-  Si se ha de ignorar las opcion Strict y asignar el agente por 00
	  * @return bool			-	Verdadero caso de poder haber sido establecido, falso en caso de fallo
	  **/
	function addAgent($id_agente,$bForce = FALSE) {
		// debug("Document::addAgent($id_agente,$bForce) ---> Error de Flujo");
		if (!is_numeric($id_agente)) return FALSE;

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return false;
		}

		$retval = false;
		if (is_array($this->_aAgentes_cliente[$id_agente]) AND !$bForce) {
			$retval = true;
		} else {
			if ($this->_fPedido & inmPed_VENTA) {
				$cons = "SELECT DISTINCT ".
						  "Ag.id_agente as 'id_agente', ".
						  "CONCAT(Ag.apellidos,', ',Ag.nombre) as 'nombre', ".
						  "Ag.comision_base as 'comision', ".
						  "Ag.comision_repartida as 'comision_repartida' ".
						  "FROM Agentes `Ag` ".
						  "WHERE Ag.id_agente = $id_agente ";
				
				$id_rs = $oDb->query($cons);
				if (!$oDb->num_rows($id_rs)) {
					$this->error('DOCUMENT_AGENT_NOTFOUND',array('id' => $id_agente));
					return false;
				} else {
					while ($aTmp = $oDb->fetch_assoc($id_rs)) $this->_aAgentes_cliente[$aTmp['id_agente']] = $aTmp;
				}
				$aTmp = $oDb->fetch_assoc($id_rs);
				$this->_aAgentes_cliente[$aTmp['id_agente']] = $aTmp;
				$oDb->libera($id_rs);
			}
		}
		return TRUE;
	}

	
	/**
	  * Obtiene las condiciones de compra/venta de un articulo.
	  **/
	function _get_article_conditions($id_art) {
		if (!is_numeric($id_art)) return NULL;

		if ($this->_fPedido & inmPed_VENTA) {
			$campo_accion = $this->_aTarifa['campo_accion'];
			$campo_rec = $this->_aTarifa['campo_recomendacion'];
			$id_empresa = $this->_aPedido['id_empresa'];
			$id_cliente = $this->_aPedido['id_cliente'];

			$oDb = $this->_db;
			$cons = "SELECT Art.id_articulo as 'id_articulo', ".
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
						"Art.mascara_modulo as 'mascara_modulo', ".
						"Cert.nombre as 'certificado', ".
						"Cert.id_certificado as 'certificado_id', ".
						"EmpArt.$campo_accion as 'precio_real', ".
						"Art.codigo_barras as 'codigo_barras', ".
						"Art.codigo_barras_bulto as 'codigo_barras_bulto', ".
						"Art.codigo_barras_palet as 'codigo_barras_palet', ".
						"EmpArt.unidades_bulto as 'unidades_bulto', ".
						"EmpArt.bultos_capa_palet as 'bultos_capa_palet', ".
						"EmpArt.capas_palet as 'capas_palet', ".
						"EmpArt.stock as 'control_stock', ".
						"EmpArt.stock_ficticio as 'stock_estimado', ".
						"SUM(La.cantidad) as 'stock_real', ".
						 ( (!empty($campo_rec)) 
							?  "EmpArt.$campo_rec as 'PVP_rec', "
							: '').
						"EmpArt.dto_vol as 'dto_volumen', ".
						"EmpArt.dto_vol_bultos as 'dto_volumen_bultos', ".
						"EmpArt.servicios_duracion_precio as 'servicios_duracion_precio', ".
						"Tiva.id_iva as 'id_iva', ".
						"Tiva.porcentaje as 'porcentaje', ".
						"Tiva.recargo_equivalente as 'recargo_equivalente', ".
						"Tiva.cc_imp_repercutido as 'iva_cc_impuestos', ".
						"Tiva.cc_re_repercutido as 'iva_cc_recargos' ".
						"FROM Articulos `Art` LEFT JOIN Localizacion_articulos La ON (Art.id_articulo=La.id_articulo) ".
						"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
						"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
						"Tipos_IVA `Tiva`, Empresas_articulos `EmpArt`, Familia_articulos `Fam`, Marcas `Mca` ".
						"WHERE Art.id_articulo = $id_art AND Fam.id_familia = Art.id_familia AND Mca.id_marca = Art.id_marca AND ".
						"Art.id_iva = Tiva.id_iva AND EmpArt.id_articulo = Art.id_articulo AND ".
						"EmpArt.id_empresa = $id_empresa ".
						"GROUP BY Art.id_articulo ";
			$id_rs = $oDb->query($cons);
			if ($oDb->num_rows($id_rs)) {
				$fila = $oDb->fetch_assoc($id_rs);
				$fila['precio_tarifa'] = $this->_applyRevenue($fila['precio_real']);
				if (!empty($campo_rec)) $fila['PVP_rec'] = $this->_applyRevenue($fila['PVP_rec'],$fila['porcentaje']);
				// Campo rec
			} else $fila = NULL;
		} else {
			$id_empresa = $this->_aPedido['id_empresa'];
			$id_proveedor = $this->_aPedido['id_proveedor'];

			$oDb = $this->_db;
			$cons = "SELECT Art.id_articulo as 'id_articulo', ".
						"Art.nombre as 'nombre', ".
						"Art.referencia as 'referencia', ".
						"Art.descripcion as 'descripcion', ".
						"Art.id_familia as 'id_familia', ".
						"Fam.nombre as 'nombre_familia', ".
						"Art.id_marca as 'id_marca', ".
						"Mca.nombre as 'nombre_marca', ".
						"Art.peso_unidad as 'peso_unidad', ".
						"Art.id_unidad_medida as 'id_unidad_medida', ".
						"Art.mascara_modulo as 'mascara_modulo', ".
						"Um.leyenda as 'leyenda_unidad_medida', ".
						"Cert.nombre as 'certificado', ".
						"Cert.id_certificado as 'certificado_id', ".
						"CompArt.precio as 'precio_real', ".
						"CompArt.referencia as 'referencia_externa', ".
						"CompArt.descuento as 'dto_proveedor', ".
						"CompArt.dto_vol as 'dto_volumen', ".
						"CompArt.dto_vol_bultos as 'dto_volumen_bultos', ".
						"CompArt.id_servicio as 'servicios_id', ".
						"CompArt.cuota_alta as 'servicios_cuota_alta', ".
						"CompArt.servicios_duracion_precio as 'servicios_duracion_precio', ".
						"CompArt.servicios_poradelantado as 'servicios_por_adelantado', ".
						"EmpArt.unidades_bulto as 'unidades_bulto', ".
						"EmpArt.bultos_capa_palet as 'bultos_capa_palet', ".
						"EmpArt.capas_palet as 'capas_palet', ".
						"EmpArt.stock as 'control_stock', ".
						"EmpArt.stock_ficticio as 'stock_estimado', ".
						"SUM(La.cantidad) as 'stock_real', ".
						"EmpArt.precio_venta as 'PVP_rec', ".
						"Tiva.id_iva as 'id_iva', ".
						"Tiva.porcentaje as 'porcentaje', ".
						"Tiva.recargo_equivalente as 'recargo_equivalente', ".
						"Tiva.cc_imp_soportado as 'iva_cc_impuestos', ".
						"Tiva.cc_re_soportado as 'iva_cc_recargos' ".
						"FROM Articulos `Art` LEFT JOIN Localizacion_articulos La ON (La.id_articulo=Art.id_articulo) ".
						"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
						"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
						"Tipos_IVA `Tiva`, Empresas_articulos `EmpArt`, ". 
						"Familia_articulos Fam, Marcas Mca, Compra_articulos CompArt ".
						"WHERE Art.id_articulo = $id_art AND Fam.id_familia = Art.id_familia AND Mca.id_marca = Art.id_marca AND ".
						"Art.id_iva = Tiva.id_iva AND EmpArt.id_articulo = Art.id_articulo AND CompArt.id_proveedor = $id_proveedor AND ".
						"EmpArt.id_empresa = $id_empresa AND CompArt.id_articulo = Art.id_articulo ".
						"GROUP BY Art.id_articulo ";
			$id_rs = $oDb->query($cons);
			if ($oDb->num_rows($id_rs)) {
				$fila = $oDb->fetch_assoc($id_rs);
				$fila['precio_tarifa'] = $fila['precio_real'];
			} else $fila = NULL;
		}

		return $fila;
	}

	function _applyRevenue($price,$ivarec = NULL) {
		$retval = $price;
		if ($this->getMode() & inmPed_VENTA) {
			if ($this->debug) debug("_applyRevenue sobre $price :: ".$this->op_decimals." - ".$this->tot_decimals);
			if (is_numeric($price)) {
				if (!is_numeric($ivarec)) {
					$fila['precio_tarifa'] = $price;
					$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_primero'] )/100);
					$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_segundo'] )/100);
					$fila['precio_tarifa']=$fila['precio_tarifa'] + $this->_aTarifa['monto'] ;
					$fila['precio_tarifa'] = Document::format_number($fila['precio_tarifa'],$this->op_decimals);
					$retval = $fila['precio_tarifa'];
				} else {
					if ((is_numeric($this->_aTarifa['pto_recomendacion']) OR (int)$this->_aTarifa['coniva_recomendacion']) 
							AND (!empty($price))) {
						$retval = $price;
						if (is_numeric($this->_aTarifa['pto_recomendacion']) AND $this->_aTarifa['pto_recomendacion']!=0 ) {
							$retval += $retval * ($this->_aTarifa['pto_recomendacion'] / 100);
						}
						if ((int)($this->_aTarifa['coniva_recomendacion']) AND !empty($ivarec) ) {
							$retval += $retval * ($ivarec / 100);
							$retval = Document::format_number($retval,$this->tot_decimals);
						}
					} else $retval = NULL;
				}
			} else $retval = NULL;
		}
		return $retval;
	}

	function _dbFetchContract($id) {
		$aIDs = array();

		if (is_numeric($id)) array_push($aIDs,$id);
		elseif (is_array($id)) $aIDs = $id;
		else return FALSE;
		$oDb = $this->_db;

		foreach ($aIDs as $id) $strwhere = ( (!empty($strwhere)) ? ' OR ' : '' ).' id_servicio = '.$id;

		$cons = 'SELECT id_servicio as "id", '.
					'nombre as "nombre", '.
					'duracion as "duracion", '.
					'plazo_factura as "plazo_factura" '.
					'FROM Servicios WHERE '.$strwhere;
		$idrs = $oDb->query($cons);
		if ($oDb->num_rows($idrs)) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				$this->_aServicios[$aTmp['id']] = $aTmp;
			}
		} else return FALSE;

		return TRUE;
	}
		
	/**
	  * Calcula la base imponible de una linea de detalle.
	  * @param	idx_det	- Identificador del detalle para el cual calcular la base imponible
	  **/
	function _calcular_baseimponible($idx_det) {
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;

		/** fixed **
		if ((float)$this->_aDetalles[$idx_det][descuento] OR (float)$this->_aDetalles[$idx_det][monto])
			$precio = $this->_aDetalles[$idx_det][precio_tarifa_descuento];
		else $precio = $this->_aDetalles[$idx_det][precio_tarifa];
		/** **/
		$precio = $this->_aDetalles[$idx_det]['precio_tarifa'];

		/** ** 
		  * La base imponible se ha de calcular sobre la cantidad indicada en la linea de detalle.
		  *	Que haya o no cantidad por servir, residual, recibida o lo que sea, son datos por un lado
		  *	informativos, y por otro a tener en cuenta cuando se 'recalcula' una factura/pedido que tiene
		  *	albaranes a fin de corregir la cantidad. que a la hora de facturar,emitir, sea usada para la bimponible
		  *
		if (!(double)($this->_aDetalles[$idx_det]['cantidad_residual']))
			if (!(double)($this->_aDetalles[$idx_det]['cantidad_recibida']))
				$cantidad = $this->_aDetalles[$idx_det]['cantidad'];
			else $cantidad = $this->_aDetalles[$idx_det]['cantidad_recibida'];
		elseif ((double)($this->_aDetalles[$idx_det]['cantidad_recibida']))
			$cantidad = $this->_aDetalles[$idx_det]['cantidad_recibida'];
		else $cantidad = $this->_aDetalles[$idx_det]['cantidad'] - $this->_aDetalles[$idx_det]['cantidad_residual'];
		/** **/
		$cantidad = $this->_aDetalles[$idx_det]['cantidad'];
		

		$base = $precio * $cantidad;
		if ((float)$this->_aDetalles[$idx_det]['descuento'])
			$base -= ($base * $this->_aDetalles[$idx_det]['descuento'] / 100);
		elseif ((float)$this->_aDetalles[$idx_det]['monto'])
			$base -= $this->_aDetalles[$idx_det]['monto'];

		$this->_aDetalles[$idx_det]['base_imponible'] = Document::format_number($base,$this->tot_decimals); 
		if (!$this->_is_tax($this->_aDetalles[$idx_det]['id_iva'])) 
			$this->_add_tax($this->_aDetalles[$idx_det]['id_iva'],$this->_aDetalles[$idx_det]['porcentaje'],
					$this->_aDetalles[$idx_det]['recargo_equivalente'],TRUE,
					$this->_aDetalles[$idx_det]['iva_cc_impuestos'],$this->_aDetalles[$idx_det]['iva_cc_recargos']);

		if ($this->debug) debug("<b>_calcular_base_imponible</b>(Idx - $idx_det) ".
							"Cantidades: Residual(".$this->_aDetalles[$idx_det]['cantidad_residual'].
							") Recibida(".$this->_aDetalles[$idx_det]['cantidad_recibida'].
							") Pedida(".$this->_aDetalles[$idx_det]['cantidad'].
							") P.B.(".$this->_aDetalles[$idx_det]['base_imponible']." $$$)");

		$this->_aFlags['total_bases'] |= inmPed_MODIFIED;
		return 1;
	}

	/**
	  * Calcula el total de las bases imponibles de las lineas de detalle.
	  **/
	function _totales_baseimponible($bForce = FALSE) {
		$total = 0;
		$limpio = 0;
		$peso = 0;
		if ( ($this->_aFlags['total_bases'] & inmPed_MODIFIED) OR $bForce ) {
			if ($this->debug) 
				debug("Calculando bases imponibles...");
			$aIReset = array();
			// Resetamos los valores de los IVAs y los descuentos.
			// $this->_reset_taxes();
			// $this->_reset_discounts();
			for ($idx = $this->first_detail(); isset($idx); $idx = $this->next_detail()) {
				if ($this->debug) debug("Recorreiendo detalle $idx");
				// $this->_calcular_baseimponible($idx);
				$aItem = $this->get_detail($idx);

				// Calculando las bases de cotizacion por iva
				if (!in_array($aItem['id_iva'],$aIReset)) {
					$suma = false;
					array_push($aIReset,$aItem['id_iva']);
					$this->_add_tax($aItem['id_iva'],NULL,NULL,TRUE,$aItem['iva_cc_impuestos'],$aItem['iva_cc_recargos']);
				} else $suma = true;
				if (!$this->_is_tax($aItem['id_iva'])) {
					$this->_add_tax($aItem['id_iva'],$aItem['porcentaje'],$aItem['recargo_equivalente'],$aItem['iva_cc_impuestos'],$aItem['iva_cc_recargos']);
				}
				$this->_charge_tax($aItem['id_iva'],$aItem['base_imponible'],$suma);
				$total += $aItem['base_imponible'];
				$limpio += $this->get_quantity($idx) * $this->get_price($idx,FALSE);
				$peso += $aItem['peso'];
			}
			if ($this->debug) debug("Total bruto = $total; Total bruto no imponible = ".$limpio);
			$this->_aTotales['bruto']	= Document::format_number($total,$this->tot_decimals);
			$this->_aTotales['bruto_no_imponible'] = Document::format_number($limpio,$this->tot_decimals);
			$this->_aPedido['peso'] = Document::format_number($peso,$this->tot_decimals);
			if (is_array($this->_aIVAs['detalle']))
				foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva)
					if (!in_array($id_iva,$aIReset) AND sizeof($this->_aIVAs['detalle']) > 1) // El ultimo IVA no se borra.
						$this->_del_tax($id_iva);
		} else return 1;
		// Fixme: Hacer esto por change_flags
		$this->_aFlags['total_bases'] &= ~inmPed_MODIFIED;
		return 1;
	}

	/**
	  * Metodo encargado de anyadir un nuevo tipo de iva a nuestro pedido
	  * @param $id_iva	-	Identificador del tipo de iva que es.
	  * @param $pto		-	Porcentaje de iva/tax/impuesto a aplicar.
	  * @param $req		-	Porcentaje del recargo de equivalencia del iva.
	  * @param $bReset	-	Si se ha de resetear la base imponible o no.
	  * @return bool		-	Si la operacion se ha realizado con exito o no.
	  **/
	function _add_tax($id_iva,$pto = 0,$req = 0,$bReset = FALSE, $cc_imp = NULL, $cc_req = NULL) {
		if (!is_numeric($id_iva)) return 0;
		if ((int)is_array($this->_aIVAs['detalle'][$id_iva])) {
			if ($bReset) {
				$this->_aIVAs['detalle'][$id_iva]['bruto'] = 0;
				$this->_aIVAs['detalle'][$id_iva]['total_iva'] = 0;
				$this->_aIVAs['detalle'][$id_iva]['total_iva_calculado'] = 0;
				$this->_aIVAs['detalle'][$id_iva]['total_recargo'] = 0;
				$this->_aIVAs['detalle'][$id_iva]['total_recargo_calculado'] = 0;
				if (!empty($cc_imp)) $this->_aIVAs['detalle'][$id_iva]['cc_impuestos'] = $cc_imp;
				if (!empty($cc_req)) $this->_aIVAs['detalle'][$id_iva]['cc_recargos'] = $cc_req;
				$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
			}
			return 1;
		}
		if (!is_numeric($pto)) return 0;
		if (!is_numeric($req)) return 0;
		if (!$bReset) $bReset = FALSE;
		if ($bReset) $this->_aIVAs['detalle'][$id_iva]['bruto'] = 0;
		$this->_aIVAs['detalle'][$id_iva]['porciento'] = Document::format_number($pto,$this->op_decimals);
		$this->_aIVAs['detalle'][$id_iva]['recargo_eq'] = Document::format_number($req,$this->op_decimals);
		if (!empty($cc_imp)) $this->_aIVAs['detalle'][$id_iva]['cc_impuestos'] = $cc_imp;
		if (!empty($cc_req)) $this->_aIVAs['detalle'][$id_iva]['cc_recargos'] = $cc_req;
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		return 1;
	}

	function _get_tax($id_iva) {
		return $this->_aIVAs[$id_iva];
	}

	/**
	  * Metodo encargado de borrar un tipo de impuesto del pedido. 
	  * @param $id_iva	-	Identificador del iva/impuesto que se ha de borrar.
	  * @return bool		-	Si se ha realizado la operacion con exito.
	  */
	function _del_tax($id_iva) {
		if (!isset($id_iva) OR !is_array($this->_aIVAs['detalle'][$id_iva])) return FALSE;
		$aTmp['id_iva'] = $id_iva;
		$aTmp['id_pedido'] = $this->_aIVAs['detalle'][$id_iva]['id_pedido'];
		$aTmp['id_factura'] = $this->_aIVAs['detalle'][$id_iva]['id_factura'];
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		unset($this->_aIVAs['detalle'][$id_iva]);
		array_push($this->_aIva_dbdel,$aTmp);
	}

	/**
	  * Metodo encargado de indicar si un tipo(id) de impuesto existe o no.
	  * @param $id_iva	-	Identificador del iva/impuesto que se ha de borrar.
	  * @return bool		-	Si se ha realizado la operacion con exito.
	  */
	function _is_tax($id_iva) {
		// debug("_is_tax($id_iva) : ".is_array($this->_aIVAs[detalle][$id_iva]));
		if ((int)is_array($this->_aIVAs['detalle'][$id_iva])) return TRUE;
		else return FALSE;
	}

	/**
	  * Reseta las bases para los calculos de IVA y las pone a 0
	  **/
	function _reset_taxes() {
		if (is_array($this->_aIVAs['detalle'])) {
			foreach ($this->_aIVAs['detalle'] as $idiva => $aIVA) {
				$this->_aIVAs['detalle'][$idiva]['bruto'] = 0;
				$this->_aIVAs['detalle'][$idiva]['base_imponible'] = 0;
			}
		}
		$this->_aIVAs['total_iva'] = 0;
		$this->_aIVAs['total_recargo'] = 0;
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
	}


	/**
	  * Metodo encargado de incrementar/decrementar el bruto de imposicion de cada tipo de iva.
	  * @param $id_iva	-	Identificador del tipo de iva.
	  * @param $monto		-	Cantidad a sumar/asignar.
	  * @param $bSuma		-	Si el monto ha de ser sumado o asignado.
	  * @return bool		-	si la operacion se ha realizado con exito.
	  */
	function _charge_tax($id_iva,$monto,$bSuma = TRUE) {
		if (!is_numeric($monto)) return 0;
		if (!is_numeric($id_iva)) return 0;
		if (!isset($bSuma)) $bSuma = TRUE;

		if (!is_array($this->_aIVAs['detalle'][$id_iva])) 
			$this->_add_tax($id_iva,NULL,NULL);
		if (!isset($bSuma) OR $bSuma == NULL) $bSuma = TRUE;
		if (!$bSuma)
			$this->_aIVAs['detalle'][$id_iva]['bruto'] = Document::format_number($monto,$this->op_decimals);
		else $this->_aIVAs['detalle'][$id_iva]['bruto'] += Document::format_number($monto,$this->op_decimals);
		$this->_aIVAs['detalle'][$id_iva]['base_imponible'] = 0;
		if ($this->debug) debug("_charge_tax($id_iva) = > ".$this->_aIVAs['detalle'][$id_iva]['bruto']." Suma($bSuma)");
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		//Fixme: Tenemos 2 flags para los ivas, este de calculos_iva y luego el de pedido (inmPed_TAXES)
		//		El segundo deberia ser para no comprobar siquiera los ivas, y el primero para sumar o no los ivas de las lineas 
		//		de detalle.
	}

	/**
	  * Metodo encargado de recalcular desde 0 los detalles del iva. A partir de los detalles.
	  * @return bool	-	Si los calculos se han realizado bien o no.
	  */
	function _build_taxes($bApIva = TRUE,$bApRec = TRUE) {
		if ( ($this->_aFlags['calculos_iva'] & inmPed_MODIFIED)) {
			if (!isset($bApIva)) $bApIva = TRUE;
			if (!isset($bApRec)) $bApRec = TRUE;
			$this->_totales_baseimponible();
			$aIva = array();
			$recalcular = FALSE;
			if (is_array($this->_aIVAs['detalle']))
				foreach($this->_aIVAs['detalle'] as $idv => $aIva) 
					if (!isset($aIva['bruto'])) { $recalcular = TRUE; break; }

			if ($this->debug) debug("Reconstruyendo taxes ($recalcular)");
			if ($this->_aFlags['calculos_iva'] & inmPed_MODIFIED OR $recalcular) {
				if ($this->debug) debug("Ivas tocados...");
				// $this->_reset_taxes();
				$this->_aIVAs['total_iva'] = 0;
				$this->_aIVAs['total_recargo'] = 0;
				//Fixme: Aki mejor llamar a totales_baseimponible()
				//No hace falta forzarlo: $this->_change_flags(inmPed_CHG_MAIN | inmPed_MODIFIED);
				$this->_totales_baseimponible(TRUE);
				$this->_calculate_discounts();
			}

			$aplicar_iva = (int)$this->_aReceptor['aplicar_iva'];
			$comunitario = (int)$this->_aReceptor['comunitario'];
			$aplicar_recargo = (int)$this->_aReceptor['aplicar_recargo'];
			if ($this->debug) 
				debug("Hemos vuelto de lanzar los descuentos desde el iva.i aplicar: iva($aplicar_iva) req($aplicar_recargo) com($comunitario)");

			if (is_array($this->_aIVAs['detalle']))
				foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva) {
					if ( $aIva['base_imponible'] == 0) $this->_aIVAs['detalle'][$id_iva]['base_imponible'] = $aIva['bruto'];

					$this->_aIVAs['detalle'][$id_iva]['total_iva_calculado'] = Document::format_number(
							  ($this->_aIVAs['detalle'][$id_iva]['base_imponible'] * $this->_aIVAs['detalle'][$id_iva]['porciento'] / 100),
																							$this->tot_decimals);
					if ( ($aplicar_iva AND !$comunitario) AND $bApIva) {
						$this->_aIVAs['detalle'][$id_iva]['total_iva'] = Document::format_number(
								  ($this->_aIVAs['detalle'][$id_iva]['base_imponible'] * $this->_aIVAs['detalle'][$id_iva]['porciento'] / 100),
																								$this->tot_decimals);
						if ($this->debug)
							debug("Aplicamos IVA! $id_iva - El ".$this->_aIVAs['detalle'][$id_iva]['porciento'].
										" de ".$this->_aIVAs['detalle'][$id_iva]['base_imponible']." es ".$this->_aIVAs['detalle'][$id_iva]['total_iva'].
										" O = ".($this->_aIVAs['detalle'][$id_iva]['base_imponible'] * $this->_aIVAs['detalle'][$id_iva]['porciento'] / 100)
										);
					} else $this->_aIVAs['detalle'][$id_iva]['total_iva'] = 0;

					$this->_aIVAs['detalle'][$id_iva]['total_recargo_calculado'] = Document::format_number(
							  ($this->_aIVAs['detalle'][$id_iva]['base_imponible'] * $this->_aIVAs['detalle'][$id_iva]['recargo_eq'] / 100),
																							$this->tot_decimals);
					if ( ($aplicar_recargo AND !$comunitario) AND $bApRec) 
						$this->_aIVAs['detalle'][$id_iva]['total_recargo'] = Document::format_number(
								  ($this->_aIVAs['detalle'][$id_iva]['base_imponible'] * $this->_aIVAs['detalle'][$id_iva]['recargo_eq'] / 100),
																								$this->tot_decimals);
					else $this->_aIVAs['detalle'][$id_iva]['total_recargo'] = 0;

					$this->_aIVAs['total_iva'] += $this->_aIVAs['detalle'][$id_iva]['total_iva'];
					$this->_aIVAs['total_recargo'] += $this->_aIVAs['detalle'][$id_iva]['total_recargo'];
				}
			$this->_aIVAs['total_iva'] = Document::format_number($this->_aIVAs['total_iva'],$this->tot_decimals);
			$this->_aIVAs['total_recargo'] = Document::format_number($this->_aIVAs['total_recargo'],$this->tot_decimals);
			if ($this->debug) debug("<b>Build taxes cambiando flags </b>...");
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK | inmPed_DB_COMMIT);
			$this->_calculate_totals();
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		}

		if ($this->debug) debug("Total de los ivas: ");
		if ($this->debug) print_r($this->_aIVAs);
		return 1;
	}

	/**
	  * Metodo encargado de Re-extraer del cliente los detalles de sus descuentos.
	  * @param $bForce - Si ha de forzar la recogida de los dtos y el recalculo de dtos gnrales.
	  **/
	function _seek_discounts($bForce = FALSE) {
		if (!isset($bForce)) $bForce = FALSE;
		if ($bForce OR !is_array($this->_aDescuentos['detalle'])) {
			if ($this->debug) debug("Seeeek discounts... a toda costa..");
			if (is_array($this->_aDescuentos['detalle'])) {
				foreach ($this->_aDescuentos['detalle'] as $tmpid => $aDto) {
					if ((int)$aDto['id_descuento']) 
						if (0) $this->_db->tb_delete("Descuentos",array("id_descuento" => $aDto['id_descuento'])) ;
						else debug("NO borramos Descuentos");
				}
			}
			if (!is_array($this->_aDescuentos['detalle']))
				$this->_aDescuentos = array("total" => 0, "detalle" => array());
			$detalles_descuento = array();
			$i = 0;
			// Descuentos actuales son: Dto directo
			if((float)$this->_aReceptor['dto_directo']){
					$aTmp = $this->_aDescuentos['detalle'][$i];
				$aTmp['orden'] = $i++;
				$aTmp['nombre'] = "cli";
				$aTmp['financiero'] = 0;
				$aTmp['descuento'] = $this->_aReceptor['dto_directo'];
				$detalles_descuento[$aTmp['orden']] = $aTmp;
				$aTmp = array();
			} 
			// Y : Dto pronto pago. (no molaria aqui comprobar la forma de pago?)
			if((float)$this->_aReceptor['dto_pronto_pago']){
					$aTmp = $this->_aDescuentos['detalle'][$i];
				$aTmp['orden'] = $i++;
				$aTmp['nombre'] = "P.P.";
				$aTmp['financiero'] = 1;
				$aTmp['descuento'] = $this->_aReceptor['dto_pronto_pago'];
				$detalles_descuento[$aTmp['orden']] = $aTmp;
			}
			$total_descuentos = 0;

			if ($i) 
				foreach ($detalles_descuento as $idx => $aDto) $this->_aDescuentos['detalle'][$idx] = $aDto;
			else 
				if ($this->debug) debug("No hay descuentos globales aplicables");

			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
		}
	}

	/**
	  * Metodo encargado de calcular los descuentos globales al pedido aplicables para este cliente.
	  */
	function _calculate_discounts() {
		$retval = false;
		if ($this->_aFlags['descuentos'] & inmPed_MODIFIED) {
			if ($this->debug) debug("calculando descuentos...");
			if (!is_array($this->_aDescuentos)) {
				$this->_seek_discounts(TRUE);
			} else $i = sizeof($this->_aDescuentos['detalle']);
			$this->_aDescuentos['total'] = 0;

			// Calculamos descuentos.
			if (is_array($this->_aDescuentos['detalle']) AND sizeof($this->_aDescuentos['detalle']) ) {
				$this->_totales_baseimponible();
				$retval = true;

				if (!is_array($this->_aIVAs['detalle'])) {
					$this->_add_tax(0,0,0,TRUE);
					$this->_charge_tax(0,$this->_aTotales['bruto']);
				}
				ksort($this->_aDescuentos['detalle']);
				reset($this->_aDescuentos['detalle']);
				$aDReset = array();
				$total_descuentos = 0;
				if (is_array($this->_aIVAs['detalle']) AND sizeof($this->_aIVAs['detalle'])) {
					$aIVAS = $this->_aIVAs['detalle'];
				} else {
					$aIVAS = array();
					$aTmp = $this->get_totals();
					if (is_numeric($aTmp['bruto'])) $aIVAS[0]['bruto'] = (float)$aTmp['bruto'];
				}
				foreach ($aIVAS as $id_iva => $aIVA) {
					$base = $aIVA['bruto'];
					if ($this->debug) debug("Base para el iva $id_iva = $base");
					foreach($this->_aDescuentos['detalle'] as $i => $aDto) {
						if (!in_array($i,$aDReset)) {
							$this->_aDescuentos['detalle'][$i]['base_imponible'] = $this->_aDescuentos['detalle'][$i]['importe'] = 0;
							array_push($aDReset,$i);
						}
						$importe = Document::format_number( ($base * $aDto['descuento'] / 100), $this->op_decimals );
						$this->_aDescuentos['detalle'][$i]['base_imponible'] += $base;
						$this->_aDescuentos['detalle'][$i]['importe'] += $importe;
						// if (!$aDto['financiero']) {
						if (true) {
							// debug("descontamos descuento de la base de cotizacion, al no ser este dto financiero. Base: $base (".$aDto['nombre'].') ');
							$base = Document::format_number( ($base - $importe), $this->op_decimals );
						}
						$total_descuentos += $importe;
						// Si quisieses almacenar los dtos por iva, se haria aqui mismo.
					}
					if (is_array($this->_aIVAs['detalle'][$id_iva])) {
						$this->_aIVAs['detalle'][$id_iva]['base_imponible'] = Document::format_number($base,$this->tot_decimals);
					}
				}
				$this->_aDescuentos['total'] = Document::format_number($total_descuentos,$this->tot_decimals);
				foreach ($this->_aDescuentos['detalle'] as $i => $aDto) {
					$this->_aDescuentos['detalle'][$i]['base_imponible'] = Document::format_number($aDto['base_imponible'],$this->tot_decimals);
					$this->_aDescuentos['detalle'][$i]['importe'] = Document::format_number($aDto['importe'],$this->tot_decimals);
				}
			} else $this->_aDescuentos = NULL;
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK | inmPed_DB_COMMIT);
				// debug("no hay detalle de descuentos?");
				// print_r($this->_aDescuentos);
		}
		if ($this->debug) debug("Hemos calculado los descuentos. estos son:");
		if ($this->debug) print_r($this->_aDescuentos);
		return $retval;
	}

	/**
	  * Reseta las bases para los calculos de los descuentos y las pone a 0
	  **/
	function _reset_discounts() {
		if (is_array($this->_aDescuentos['detalle'])) {
			foreach ($this->_aDescuentos['detalle'] as $id => $aDto) {
				$this->_aDescuentos['detalle'][$id]['importe'] = 0;
				$this->_aDescuentos['detalle'][$id]['base_imponible'] = 0;
			}
		}
		$this->_aDescuentos['total'] = 0;
		$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
	}


	/**
	  * Metodo encargado de calcular internamente los importes totales del pedido.
	  * @param $bRecalcular	-	Si ha de intentar recalcular Ivas y Descuentos o no.
	  **/
	function _calculate_totals($bRecalcular = TRUE) {
		if (!isset($bRecalcular)) $bRecalcular = TRUE;
		if ($bRecalcular) {
			$this->_totales_baseimponible();
			$this->_build_taxes();
		} 
		$aplicar_retencion = $this->_aReceptor['aplicar_retencion'];

		// $impuestos = $this->_aIVAs[total_iva] + $this->_aIVAs[total_recargo];
		// $this->_aTotales[impuestos] = $impuestos;
		$this->_aTotales['descuentos'] = Document::format_number($this->_aDescuentos['total'],$this->tot_decimals);
		$this->_aTotales['impuestos'] = Document::format_number($this->_aIVAs['total_iva'],$this->tot_decimals);
		$this->_aTotales['recargos']	= Document::format_number($this->_aIVAs['total_recargo'],$this->tot_decimals);
		$this->_aTotales['total_impuestos']	= Document::format_number($this->_aIVAs['total_recargo'] + $this->_aIVAs['total_iva'],$this->tot_decimals);
	
		$dto_financiero = 0;
		if (is_array($this->_aIVAs['detalle']) AND sizeof($this->_aIVAs['detalle'])) {
			$base = 0;
			foreach ($this->_aIVAs['detalle'] as $aIVA) $base += $aIVA['base_imponible'];
			// Buscamos el importe de descuentos financieros (no incluidos por tanto en la base de los ivas)
			if (false AND is_array($this->_aDescuentos['detalle']) AND sizeof($this->_aDescuentos['detalle'])) 
				foreach ($this->_aDescuentos['detalle'] as $aDto)
					if ((int)$aDto['financiero']) {
						$dto_financiero += $aDto['importe'];
					}
			
		} else {
			$base = $this->_aTotales['bruto'] - $this->_aTotales['descuentos'];
		}
		$this->_aTotales['base_imponible'] = Document::format_number($base,$this->tot_decimals);

		$this->_aTotales['sin_retencion'] = Document::format_number( ($this->_aTotales['base_imponible'] - $dto_financiero) + 
														$this->_aTotales['recargos'] + $this->_aTotales['impuestos'], $this->tot_decimals);

		if ($aplicar_retencion) $total_retenciones = ( $this->_aTotales['base_imponible'] * $this->_aEmisor['retencion']) / 100;
		$this->_aTotales['retenido'] = Document::format_number($total_retenciones,$this->tot_decimals);

		$this->_aTotales['importe'] = Document::format_number($this->_aTotales['sin_retencion'] - $this->_aTotales['retenido'],$this->tot_decimals);
		$this->_aTotales['importe_pagar'] = 
				Document::format_number($this->_aTotales['importe'] - ($this->_aTotales['monto_cuenta'] + $this->_aTotales['monto_prepago']), $this->tot_decimals);

		if ($this->_aDivisa['id_divisa'] != $this->_aReceptor['id_divisa'] AND $this->_aReceptor['div_ratio']!=0) {
			$this->_aTotales['divisa_cliente_importe'] = Document::format_number( $this->_aTotales['importe'] * $this->_aReceptor['div_ratio'], $this->tot_decimals);
			/** **
			if ($this->_fPedido & inmPed_VENTA)
				$this->_aTotales['divisa_cliente_importe'] = round (
						 $this->_aTotales['importe'] * ($this->_aDivisa['ratio'] / $this->_aReceptor['div_ratio']), $this->tot_decimals);
			/** **/
			$this->_aTotales['divisa_cliente_leyenda'] = $this->_aReceptor['div_leyenda'];
			$this->_aTotales['divisa_cliente_nombre'] = $this->_aReceptor['div_nombre'];
		}

		// foreach ($this->_aTotales as $tag => $value) $this->_aTotales[$tag] = round($this->_aTotales[$tag],2);

		if ($this->debug) debug("Calculo de Totales :");
		if ($this->debug) print_r($this->_aTotales);
		return;
	}

	function format_number($dato,$ndig = 2,$bVis = false) {
		if (!is_a($this,'Document')) {
			debug("Document::format_number() - Obteniendo cfg para formateo");
		}
		//debug("dato: $dato con $ndig ".number_format($dato,$ndig,'.',''));
		$nfrac = $ndig;
		for ($i = 0; $i < $nfrac; $i++) if ($dato == round($dato,$i)) $nfrac = $i;

		if (!$bVis) return number_format($dato,$nfrac,'.','');
		else return number_format($dato,$nfrac,',','.');
		//FixMe: Obtener los separadores decimales y de millar, de la sesion cuando sea posible
	}

	/**
	  * Metodo encargado de reconstruir todos los indices internos de los detalles despues de una carga desde la db.
	  *
	  **/
	function _build_indexes() {
		$old_dbg = $this->debug;
		$this->dbg('','_build_indexes');
		$aPromo_det = array(); // Las promociones del pedido.
		$aArt_sincargo = array(); // Lista de idx_detalle sin cargo
		$aArt_depromo = array();
		$this->_aDet_dbdel = array();
		$this->_dbFetchOffers();
		for($idx_act = $this->first_detail() ; isset($idx_act); $idx_act = $this->next_detail()) {
			$fila = NULL;
			$fila = $this->get_detail($idx_act);
			$id_articulo = $this->get_detail_article_id($idx_act);
			if ((int)$fila['id_detalle']) {
				$this->_aDetIdx[(int)$fila['id_detalle']] = $idx_act;
				if (empty($this->_aDet_dbdel[$idx_act]['cantidad_db']))
					$this->_aDet_dbdel[$idx_act]['cantidad_db'] = $this->get_quantity($idx_act);
			}
			if (!is_array($this->_aDetIdx_Art[(int)$fila['id_articulo']]) 
					OR !in_array($idx_act,$this->_aDetIdx_Art[(int)$fila['id_articulo']]))
				$this->_aDetIdx_Art[(int)$fila['id_articulo']][] = $idx_act;

			$aPromo = NULL;
			if ($this->get_price($idx_act) AND !$this->have_discount($idx_act))
				$aPromo = $this->check_offers($idx_act,false);
			elseif (!(float)$this->get_price($idx_act)) 
				if (is_array($aArt_depromo) AND !in_array($idx_act,$aArt_depromo)) 
					array_push($aArt_sincargo,$idx_act);

			$cantidad = $this->get_quantity($idx_act);
			$this->dbg( array("Idx $idx_act . Promo: ",$this->_aOff_Promo[$id_articulo]),'_build_indexes');
			if (is_array($aPromo) AND (!(int)$aPromo['oferta_promocion'] OR $aPromo['oferta_promocion']==2) AND is_array($aPromo['promo'])) {
					// Si no hemos localizdo el id del array de promos, lo hacemos.
					$id_promocion = $aPromo['id_promocion'];
					$idx_promo = NULL;
					if (!isset($idx_promo)) {
						$aAllPromo = $this->_aOff_Promo[$id_articulo];
						foreach ($this->_aOff_Promo[$id_articulo] as $idp => $aPromo)
							if ($aPromo['id_promocion'] == $id_promocion) {
								$idx_promo = $idp;
								break;
							}
						// Si no localizamos la promo, no hay nada que hacer
						if (!isset($idx_promo)) continue;
						$this->dbg("La promo localizada es $idx_promo",'_bild_indexes');
						$aPromo_det[$idx_act]['idp'] = $idx_promo;
						$aPromo_det[$idx_act]['id_articulo'] = $id_articulo;
						$aPromo_det[$idx_act]['promocion'] = $aPromo;
					} 

					$ratio_cant = floor($cantidad / $aPromo['cantidad']);

					// Almacenamos los articulos sin cargo de la promo de este articulo
					$aSearchFor = array();
					if ($ratio_cant > 0) 
						foreach ($aPromo['promo'] as $id => $aArt) {
							$aTmp['id_articulo'] = $aArt['id_articulo'];
							$aTmp['cantidad'] = $aArt['cantidad'] * $ratio_cant;
							$aTmp['id_promo_det'] = $id;
							array_push($aSearchFor,$aTmp);
						}
					$this->dbg( array("<b>Buscamos</b> para la promo del $id_articulo los siguiente (a: $idx_act) productos sin cargo: ",$aSearchFor) ,'_build_indexes');

					// Buscamos los articulos de la promo desde el id detalle actual hasta el ultimo.
					$idx_orig = $idx_act;
					$first = TRUE;
					for ($idx_s = $this->next_detail(); isset($idx_s); $idx_s = $this->next_detail()) {
						$this->dbg("Pasada por $idx_s a ".$this->get_price($idx_s),'_build_indexes');
						if ((float)$this->get_price($idx_s)) continue;

						$this->dbg("Searching in $idx_s ... npromo($idx_promo) art($id_articulo)",'_build_indexes');
						$id_art = $this->get_detail_article_id($idx_s);
						if (!$id_art) continue;
						foreach ($aSearchFor as $tmpid => $aArt) 
							if ($aArt['id_articulo'] == $id_art) {
								if ($aArt['cantidad'] == $this->get_quantity($idx_s)) {
									debug("<b>Encontrado!</b>");
									$this->dbg("Eureka($idx_s)!, coinciden las cantidades(".$this->get_quantity($idx_s).")",'_build_indexes');
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$id_articulo][$idx_promo]['idx_det'])) {
										array_push($this->_aOff_Promo[$id_articulo][$idx_promo]['idx_det'],$idx_act);
										$this->set_detail_discount($idx_act,0,1,$aPromo['nombre'],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$id_articulo][$idx_promo]['promo'][$aArt['id_promo_det']][$idx_act] = $idx_s;
									$this->set_detail_discount($idx_s,0,1,$aPromo['nombre'],TRUE);
									// Este detalle ya no es considerado como sin cargo (y perdido)
									array_push($aArt_depromo,$idx_s);
									// Dejamos de Buscar este articulo.
									$this->dbg('Eliminando item '.$tmpid.' de las lista ','_build_indexes');
									$aSearchFor[$tmpid] = NULL;
									unset($aSearchFor[$tmpid]);
								}
							}
						if (!sizeof($aSearchFor)) break;
					}
					// Los no encontrados los guardamos para un segundo intento.
					if (is_array($aSearchFor) AND sizeof($aSearchFor))
						$aPromo_det[$idx_act]['pendientes'] = $aSearchFor;
					// Restablecemos el id detalle para continuar reconstruyendo los indices
					$this->set_active_detail($idx_orig);
				}
		}

		if (is_array($aArt_sincargo) AND sizeof($aArt_sincargo)) {
			if (is_array($aPromo_det)) {
				foreach ($aPromo_det as $idx_act => $aPromo) {
					if (is_array($aPromo['pendientes'])) {
						$this->dbg("Cosillas pendientes en($idx_act)...",'_build_indexes');
						foreach ($aPromo['pendientes'] as $id_pend => $aArt) {
							foreach($aArt_sincargo as $id_sincargo => $idx_) {
								if ($this->get_detail_article_id($idx_) == $aArt['id_articulo'] 
										AND $this->get_quantity($idx_) == $aArt['cantidad']) {
									$this->dbg("Articulo($aArt[id_articulo]) encontrado en($idx_) la repesca!",'_build_indexes');
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['idx_det'])) {
										array_push($this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['idx_det'],$idx_act);
										$this->set_detail_discount($idx_act,0,1,$aPromo['promocion']['nombre'],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['promo'][$aArt['id_promo_det']][$idx_act] = $idx_;
									$this->set_detail_discount($idx_,0,1,$aPromo['promocion']['nombre'],TRUE);
									// Borramos este articulo sin cargo, ya no esta perdido.
									$aArt_sincargo[$id_sincargo] = NULL;
									unset($aArt_sincargo[$id_sincargo]);
									$aPromo_det[$idx_act]['pendientes'][$id_pend] = NULL;
									unset($aPromo_det[$idx_act]['pendientes'][$id_pend]);
								}
							}
						}
						if (!is_array($aPromo_det[$idx_act]['pendientes']) OR !sizeof($aPromo_det[$idx_act]['pendientes'])) {
							$aPromo_det[$idx_act] = NULL;
							unset($aPromo_det[$idx_act]);
						}
					} 
					if (!is_array($aPromo_det[$idx_act]['pendientes'])) {
						$aPromo_det[$idx_act] = NULL;
						unset($aPromo_det[$idx_act]);
					}

				}
			}
		}

		if (is_array($aArt_sincargo) AND sizeof($aArt_sincargo)) {
			if (is_array($aPromo_det)) {
				foreach ($aPromo_det as $idx_act => $aPromo) {
					if (is_array($aPromo['pendientes'])) {
						$this->dbg("Cosillas pendientes en($idx_act)...",'_build_indexes');
						foreach ($aPromo['pendientes'] as $id_pend => $aArt) {
							if (!is_array($this->_aOff_Promo[$aArt['id_articulo']])) continue;
							foreach($aArt_sincargo as $id_sincargo => $idx_) {
								if ($this->get_detail_article_id($idx_) == $aArt['id_articulo'] ) {
									$this->dbg("Articulo($aArt[id_articulo]) encontrado en($idx_) la repesca-CHUNGA!",'_build_indexes');
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['idx_det'])) {
										array_push($this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['idx_det'],$idx_act);
										$this->set_detail_discount($idx_act,0,1,$aPromo['promocion']['nombre'],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$aArt['id_articulo']][$aPromo['idp']]['promo'][$aArt['id_promo_det']][$idx_act] = $idx_;
									$this->set_detail_discount($idx_,0,1,$aPromo['promocion']['nombre'],TRUE);
									// Borramos este articulo sin cargo, ya no esta perdido.
									$aArt_sincargo[$id_sincargo] = NULL;
									unset($aArt_sincargo[$id_sincargo]);
									$aPromo_det[$idx_act]['pendientes'][$id_pend] = NULL;
									unset($aPromo_det[$idx_act]['pendientes'][$id_pend]);
								}
							}
						}
						if (!is_array($aPromo_det[$idx_act]['pendientes']) OR !sizeof($aPromo_det[$idx_act]['pendientes'])) {
							$aPromo_det[$idx_act] = NULL;
							unset($aPromo_det[$idx_act]);
						}
					} 
					if (!is_array($aPromo_det[$idx_act]['pendientes'])) {
						$aPromo_det[$idx_act] = NULL;
						unset($aPromo_det[$idx_act]);
					}

				}
			}
		}

		// Rellenando el Indice de servicios
		$this->_aServicio_DetIdx = array();
		$aTmpServ = array();
		$aTmpArts = array();
		if (is_array($this->_aDetalles) AND sizeof($this->_aDetalles)) 
			foreach ($this->_aDetalles as $idx => $aDet) {
				$id_servicio = $aDet['id_servicio'];
				$idart = $this->get_detail_article_id($idx);
				if (!in_array($idart,$aTmpArts)) array_push($aTmpArts,$idart);
				if (is_numeric($id_servicio) AND !empty($id_servicio)) {
					if (!is_array($this->_aServicio_DetIdx[$id_servicio])) $this->_aServicio_DetIdx[$id_servicio] = array();
					array_push($this->_aServicio_DetIdx[$id_servicio],$idx);
					if (!in_array($id_servicio,$aTmpServ)) array_push($aTmpServ,$id_servicio);
				}
			}

		$this->_dbFetchContractsForIDs($aTmpArts);

		$aGetServ = array();
		foreach ($aTmpServ as $ids)
			if (!is_array($this->_aServicios[$ids]) OR !sizeof($this->_aServicios[$ids]))
				array_push($aGetServ,$ids);

		if (is_array($aGetServ) AND sizeof($aGetServ)) {
			$this->_dbFetchContract($aGetServ);
		}

		$this->dbg("FIN de Document::_build_indexes()<hr>",'_build_indexes');
		return TRUE;
	}

	function _dbFetchContractsForIDs($aIDs) {

		if (is_array($aIDs) AND sizeof($aIDs)) {
			$aIDs = array_unique($aIDs);
			// Obtenemos las cuotas de alta y flag de pago adelantado en todas referencias y servicios
			if ($this->getMode() & inmPed_VENTA) {
				$id_empresa = $this->get_issuer_id();
				$str_where_art = NULL;
				foreach ($aIDs as $idart) 
					if (is_numeric($idart)) 
						$str_where_art .= ( (!empty($str_where_art)) ? ' OR ' : '' ).'id_articulo = '.$idart;

				if (empty($str_where_art)) return FALSE;

				$cons = 'SELECT S.id_servicio as "id", '.
							'S.nombre as "nombre", '.
							'S.duracion as "duracion", '.
							'S.plazo_factura as "plazo_factura", '.
							'SE.id_articulo,SE.cuota_alta,SE.servicios_poradelantado '.
							'FROM Empresas_servicios `SE`, Servicios `S` '.
							'WHERE S.id_servicio = SE.id_servicio AND SE.id_empresa='.$id_empresa.' AND ('.$str_where_art.') '.
							'ORDER BY S.id_servicio ';
				$idrs = $this->_db->query($cons);
				if ($this->_db->num_rows($idrs))
					while ($aTmp = $this->_db->fetch_assoc($idrs)) {
						if (!is_array($this->_aServicios[$aTmp['id']])) 
							$this->_aServicios[$aTmp['id']] = array('id' => $aTmp['id'], 'nombre' => $aTmp['nombre'],
										'duracion' => $aTmp['duracion'], 'plazo_factura' => $aTmp['plazo_factura'], 'referencias' => array());
						$this->_aServicios[$aTmp['id']]['referencias'][$aTmp['id_articulo']] =
							array('cuota' => $aTmp['cuota_alta'], 'por_adelantado' => $aTmp['servicios_poradelantado']);
					}
			} else {
				// Recordemos que en compras, solo puede haber un servicio por referencia. ==> obtenemos la informacion de la linea de detalle,
				//		dado que contiene la informacion necesaria, no hace falta lanzar ninguna consulta.
				$aIDx_check = array();
				foreach ($aIDs as $idart) {
					$aIDx = NULL;
					$aIDx = $this->get_idxdetail_art($idart);
					if (is_array($aIDx) AND sizeof($aIDx)) {
						if (!in_array($aIDx[0],$aIDx_check) AND 
								!is_array($this->_aServicios[$this->getDetailAttribute($aIDx[0],'servicios_id')]['referencias'][$idart]) ) 
							array_push($aIDx_check,$aIDx[0]);
					}
				}

				if (is_array($aIDx_check) AND sizeof($aIDx_check)) {
					// Primero comprobamos tener todos los servicios poblados, sino, los mandamos poblar.
					$aServ_check = array();
					foreach ($aIDx_check as $tmpidx) {
						$idserv = $this->getDetailAttribute($tmpidx,'servicios_id');
						if (empty($idserv) OR !is_numeric($idserv)) continue;
						if ( (!is_array($this->_aServicios[$idserv]) OR !sizeof($this->_aServicios[$idserv])) 
								AND (!in_array($idserv,$aServ_check)) ) 
							array_push($aServ_check,$idserv);
					}
					if (is_array($aServ_check) AND sizeof($aServ_check)) {
						$this->_dbFetchContract($aServ_check);
					}
					

					// Poblamos las estructuras de referenicas por servicio
					foreach ($aIDx_check as $tmpidx) {
						$idart = $this->get_detail_article_id($tmpidx);
						$idserv = $this->getDetailAttribute($tmpidx,'servicios_id');
						if (is_numeric($idserv) AND is_array($this->_aServicios[$idserv]) AND sizeof($this->_aServicios[$idserv])) {
							if (!is_array($this->_aServicios[$idserv]['referencias'][$idart])) {
								$this->_aServicios[$idserv]['referencias'][$idart] = array(
										'cuota' => $this->_aDetalles[$tmpidx]['servicios_cuota_alta'],
										'por_adelantado' => $this->_aDetalles[$tmpidx]['servicios_por_adelantado']);
							}
						}
					}
				}

			}
		}

		return TRUE;
	}

	/****** Metodos Publicos:  ********/

	/**
	  * Metodo encargado de Re-evaluar las condiciones de venta/compra. (re-obtener precios y dtos)
	  * @param $bCheck_dtos - Si se han de evaluar tambien los descuentos por linea de detalle.
	  * NOTA: Metodo sobrecargado en la clase Invoice
	  **/
	function eval_conditions($bCheck_dtos = false) {
		if (!isset($bCheck_dtos)) $bCheck_dtos = false;
		//Carefull: no se porque estaba esto, pero estorba para cambiar tarifas, dado que si establecemos el receptor de nuevo
		//  se machacan los valores de la tarifa. :	$this->set_reciever($this->get_reciever_id(),TRUE);
		$have_some = FALSE;

		/** **/

		if ($bCheck_dtos) {
			debug("Document::eval_conditions() <b>Vaciando</b> Promociones ... ");
			$this->_aOff_Promo = array();
			$this->_dbFetchOffers();
		}
		for ($idx_det = $this->first_detail(); is_numeric($idx_det); $idx_det = $this->next_detail()) {
			if (!$have_some) $have_some = TRUE;
			$price = NULL;
			$aDet = $this->_get_article_conditions($this->get_detail_article_id($idx_det));
			$aDet['id_detalle'] = $this->_aDetalles[$idx_det]['id_detalle'];
			$aDet['id_pedido'] = $this->_aDetalles[$idx_det]['id_pedido'];
			$aDet['id_albaran'] = $this->_aDetalles[$idx_det]['id_albaran'];
			$aDet['id_servicio'] = $this->_aDetalles[$idx_det]['id_servicio'];
			$aDet['id_presupuesto'] = $this->_aDetalles[$idx_det]['id_presupuesto'];
			$old_price = $this->get_price($idx_det);

			if (!$bCheck_dtos) {
				$aDto = $this->get_detail_discount($idx_det);
				if (is_array($aDto) AND sizeof($aDto)) {
					$aDet['descuento'] = $aDto['porciento'];
					$aDet['monto'] = $aDto['monto'];
					$aDet['tipo_descuento'] = $aDto['tipo'];
				}
				$cant = $this->get_quantity($idx_det);
				$new_price = $aDet['precio_tarifa'];
				$aDet['precio_tarifa'] = $old_price;
				$this->_aDetalles[$idx_det] = $aDet;
				$this->set_price($idx_det,$new_price);

				$this->set_quantity($idx_det,$cant);
			} else {
				if (!(float)$old_price) {
					// Pasaremos por alto este detalle si pertenece a alguna oferta:
					if ($this->isInOffer($idx_det,TRUE)) {
						continue;
					}
				}

				// Primero quitamos cualquier descuento que haya
				$this->set_detail_discount($idx_det,0,0,NULL,TRUE);

				$cant = $this->get_quantity($idx_det);
				if ($this->debug) debug("eval_conditions($idx_det) recogiendo la cantidad anterior: $cant");
				$new_price = $aDet['precio_tarifa'];
				$aDet['precio_tarifa'] = $old_price;
				$this->_aDetalles[$idx_det] = $aDet;
				$this->set_price($idx_det,$new_price);

				if ($this->debug) debug("eval_conditions() estudiando los descuentos de $idx_det ....");
				$this->set_quantity($idx_det,$cant,NULL,NULL,NULL,FALSE);
				/** **/
				if (!$this->have_discount($idx_det))
					$aTmp = $this->check_client_discount($idx_det,TRUE);
				// debug("familia...");
				if (!$this->have_discount($idx_det))
					$aTmp = $this->check_family_discount($idx_det,TRUE);
				// debug("promos...");
				if (!$this->have_discount($idx_det))
					$aTmp = $this->check_offers($idx_det,TRUE);
					// print_r($aTmp);
				// debug("Volumen...");
				if (!$this->have_discount($idx_det))
					$aTmp = $this->check_volume_discount($idx_det,TRUE);

				if (!$this->have_discount($idx_det)) {
					if ($this->debug) debug('Poniendo los descuentos a 0 ...');
					$this->set_detail_discount($idx_det,0,0,NULL,TRUE);
				} else {
					if ($this->debug) debug("Parece ser que si que tiene esos descuentos ... ");
					$this->_calcular_baseimponible($idx_det);
				}
				/** **/
			}
			/** **/
		
			// $this->_aModif['detalles'][$idx_det] |= (inmPed_CHG_DET_QUANTITY | inmPed_DET_PRICE) | inmPed_CHG_DET_DISCOUNT;
			$this->_change_flags(inmPed_CHG_DETAIL | ((inmPed_CHG_DET_QUANTITY | inmPed_DET_PRICE) | inmPed_CHG_DET_DISCOUNT),$idx_det);
		}
	}

	/**
	  * Metodo encargado de devolver el puntero al primer detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function first_detail($bSetPointer = TRUE) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		if (is_array($this->_aDetalles)) {
			reset($this->_aDetalles);
			list($clave,$valor) = each($this->_aDetalles);
			reset($this->_aDetalles);
			if ($bSetPointer AND isset($clave)) $this->_DetIdx_act = $clave;
			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;
		return $clave;
	}

	/**
	  * Este metodo obtiene el siguiente detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function next_detail($bSetPointer = TRUE) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->_aDetalles)) return NULL;
		if (!isset($this->_DetIdx_act)) return NULL;
		$aKeys = array_keys($this->_aDetalles);
		$continuar = TRUE;
		$retval = NULL;
		foreach ($aKeys as $key) {
			if ($key > $this->_DetIdx_act) {
				if ($bSetPointer) $this->_DetIdx_act = $key;
				$retval = $key;
				break;
			} 
		}

		return $retval;
	}

	/**
	  * Metodo encargado de establecer el puntero activo a las lineas de detalle.
	  **/
	function set_active_detail($idx_det) {
		if (!is_array($this->_aDetalles[$idx_det])) return FALSE;
		$this->_DetIdx_act = $idx_det;
		return TRUE;
	}

	/**
	  * Este metodo obtiene el actual detalle indicado por el puntero a las lineas de detalle.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function current_detail() {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		// debug("current_detail(".$this->_DetIdx_act.")");
		if (!is_array($this->_aDetalles)) return NULL;
		if (!isset($this->_DetIdx_act)) return NULL;
		if (is_array($this->_aDetalles[$this->_DetIdx_act]))
			return $this->_DetIdx_act;
		else return NULL;
	}

	/**
	  * Este metodo obtiene el anterior detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function prev_detail($bSetPointer = TRUE) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->_aDetalles)) return NULL;
		if (!isset($this->_DetIdx_act)) return NULL;
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		$aKeys = array_keys($this->_aDetalles);
		$continuar = TRUE;
		$retval = NULL;
		while ( ($key=array_pop($aKeys)) ) {
			if ($key < $this->_DetIdx_act) {
				if ($bSetPointer) $this->_DetIdx_act = $key;
				$retval = $key;
				break;
			}
		}
		return $retval;
	}

	/**
	  * Metodo encargado de devolver el puntero al ultimo detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function last_detail($bSetPointer = TRUE) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		if (is_array($this->_aDetalles)) {
			end($this->_aDetalles);
			list($clave,$valor) = each($this->_aDetalles);
			reset($this->_aDetalles);
			if ($bSetPointer AND isset($clave)) $this->_DetIdx_act = $clave;
			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;
		return $clave;
	}

	/**
	  * Metodo encargado de anyadir una linea de detalle al pedido.
	  * @param	$id_art			Articulo que se quiere anyadir al pedido.
	  * @param	$cantidad	-	Cantidad del articulo que se desea insertar.
	  * @param	$bBultos		-	Indicativo de si la cantidad indicada son unidades(0)/bultos(1)/capas(2) o palets(3). (unidades predefinido)
	  * @param	$bCheck_dtos	Indicativo de si se han de comprobar los descuentos de cliente, ofertas y promos para el articulo.
	  * @param	$force_idx	-	Identificador de detalle en el que colocar el articulo si no existe.
	  * NOTA: Metodo sobrescrito en la clas Order
	  **/
	function add_detail($id_art,$cantidad = NULL,$bBultos = 0,$bCheck_dtos = TRUE,$force_idx = NULL,$aForceIDs = 0) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		$id = (int)$id_art;
		if (!$id) return 0;
		if (!isset($bCheck_dtos)) $bCheck_dtos = TRUE;
		if (!isset($bBultos)) $bBultos = 0;
		if ($this->debug) 
			debug("<b>add_detail</b> del Art $id_art - Uds $cantidad  - ChkDtos($bCheck_dtos) EnBultos($bBultos) Force($force_idx)");

		if (is_array($aForceIDs) AND sizeof($aForceIDs)) 
			foreach ($aForceIDs as $campo => $valor) {
				if (!is_numeric($campo)) {
					$fila[$campo] = $valor;
					if (!strcasecmp($campo,'id_detalle')) {
						$idx_conflict = $this->get_idxdetail_db($valor);
						if (!is_numeric($idx_conflict) OR !is_array($this->_aDetalles[$idx_conflict]) ) {
							$idx_conflict = NULL;
						}
					}
				}
			}

		// Obtenemos las condiciones de compra/venta:
		if (is_numeric($idx_conflict)) {
			$fila = $this->get_detail($idx_conflict);
			if (is_array($fila)) $force_idx = $idx_conflict;
			$bSuma = true;
		} else {
			$fila = $this->_get_article_conditions($id_art);
			$bSuma = false;
		}
		if (!$fila) return 0;


		if (is_numeric($cantidad )) {
			if (is_integer($cantidad)) $cantidad = (int)$cantidad;
			else $cantidad = Document::format_number($cantidad,$this->op_decimals);
		} else settype($cantidad,'float');

		if (!$bBultos) $cantidad_fila = $cantidad;
		else{
			if ($bBultos == 1 AND (int)$fila['unidades_bulto']) {
				$cantidad_fila = $cantidad * $fila['unidades_bulto'];
			} elseif ($bBultos==2 AND (int)$fila['unidades_bulto'] 
					AND (int)$fila['bultos_capa_palet']) {
				$cantidad_fila = $cantidad * $fila['unidades_bulto'] * $fila['bultos_capa_palet'];
			} elseif ($bBultos==3 AND (int)$fila['unidades_bulto']
					AND (int)$fila['bultos_capa_palet'] AND (int)$fila['capas_palet']) {
				$cantidad_fila = $cantidad * $fila['unidades_bulto'] * $fila['bultos_capa_palet'] * (int) $fila['capas_palet'];
			} else $cantidad_fila = $cantidad;
		}
		

		// Fixme: Falta meter en un array los posibles servicios por articulo, en plan ofertas. (otro metodo? -check_servicios-)

		if ($force_idx AND !is_array($this->_aDetalles[$force_idx])) {
			$idx_det = $force_idx;
			if ((int)$this->_aDet_dbdel[$idx_det]['id_detalle']) {
				debug("Recuperando el id_detalle: ".$this->_aDet_dbdel[$idx_det]['id_detalle']);
				$this->_aDetalles[$idx_det]['id_detalle'] = $this->_aDet_dbdel[$idx_det]['id_detalle']; 
			}

			$this->_aModif['detalles'][$idx_det] &= ~inmPed_DB_DELETE;
			// $this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
		} else {
			if (is_numeric($force_idx) AND $force_idx == $idx_conflict) {
				$idx_det = $force_idx;
			} else {
				$idx_det = $this->last_detail(false);
				while (!empty($this->_aModif['detalles'][++$idx_det])) ;
			}
		}

		if ($this->debug) debug("add_detail() Insertando posicion $idx_det");
		$this->_aDetalles[$idx_det] = $fila;
		if (!empty($cantidad_fila)) {
			if ($this->set_quantity($idx_det,$cantidad_fila,NULL,$bSuma,NULL,false)) {
				$peso = ($fila['cantidad']) * $fila['peso_unidad'];
				$this->setDetailAttribute($idx_det,'peso',$peso);
			}
		}

		//Fixme: TODO Ojo con los indices aki!!!
		if ($force_idx AND $force_idx = $idx_det) ksort($this->_aDetalles);

		if (!is_array($this->_aDetIdx_Art[(int)$fila['id_articulo']]) OR 
							 !in_array($idx_det,$this->_aDetIdx_Art[(int)$fila['id_articulo']]))
			$this->_aDetIdx_Art[(int)$fila['id_articulo']][] = $idx_det;

		// $this->_aModif['detalles'][$idx_det] |= (inmPed_CHG_DET_QUANTITY | inmPed_DET_PRICE) | inmPed_CHG_DET_DISCOUNT;
		$this->_change_flags(inmPed_CHG_DETAIL | ((inmPed_MODIFIED | inmPed_CHG_DET_QUANTITY) | inmPed_CHG_DET_DISCOUNT),$idx_det);

		// Fixme: la comprobacion de ofertas molaria tenerlas en un solo query con un inner join
		// Buscar los descuentos del cliente por articulo y luego familia
		// Si el cliente no tiene descuento ni por articulo ni por familia se comprueba
		//	 primero las ofertas por articulo y luego las de familia (generales ambas)
		if ($bCheck_dtos) {
			$this->_dbFetchOffers(array($idx_det));
			if (!$this->have_discount($idx_det))
				$aTmp = $this->check_client_discount($idx_det,TRUE);
			if (!$this->have_discount($idx_det))
				$aTmp = $this->check_family_discount($idx_det,TRUE);
			if (!$this->have_discount($idx_det))
				$aTmp = $this->check_offers($idx_det,TRUE);
				// print_r($aTmp);
			if (!$this->have_discount($idx_det))
				$aTmp = $this->check_volume_discount($idx_det,TRUE);

			if (!$this->have_discount($idx_det))
				if ($this->debug) debug("No hay descuentos para el Id $idx_det");
			else if ($this->debug) debug("Hemos encontrado Dtos para el Idx $idx_det");
			//if ($this->debug) 
				// print_r($aTmp);
		}

		/** **
		debug("--");
		debug("Detalle recien insertado");
		print_r($this->_aDetalles[$idx_det]);
		debug("--");
		/** **/
		return $idx_det;

	}


	/**
	  * Metodo encargado de borrar un detalle de las lineas de detalle del pedido.
	  * @param $idx_det	-	Identificador del detalle que se ha de borrar (caso de NULL el actualmente en uso).
	  * @param $bDtos		-	Comprueba se se han de comprobar las ofertas/promos a la hora de borrar.
	  * @return	bool		-	Si la operacion se ha realizado con exito o no.
	  * NOTAS: Metodo sobrescrito en clase Invoice
	  **/
	function del_detail($idx_det = NULL,$bDtos = TRUE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		if (!isset($idx_det)) $idx_det = $this->_DetIdx_act;
		if (!isset($bDtos)) $bDtos = TRUE;

		if ($this->debug) debug(" del_detail($idx_det) ");
		if (!is_array($this->_aDetalles[$idx_det])) return FALSE;
		if ($this->debug) debug("<b>del_detail</b>($idx_det) --> Existe! ");

		if ($bDtos AND ($aOff = $this->check_offers($idx_det,false))) {
			if (true or $this->debug) debug("del_detail($idx_det) de una oferta...");
			if (is_array($aOff['promo']))
				foreach ($aOff['promo'] as $aArt) {
					if (!is_numeric($aArt[$idx_det])) continue;
					$SinCargo = $aArt[$idx_det];
					if (true or $this->debug) {
						debug("Borrando($idx_det) Idxs... ".$SinCargo);
						print_r($SinCargo);
					}
					$this->del_detail($SinCargo,FALSE);
				}
		}

		if ((int)$this->_aDetalles[$idx_det]['id_detalle']) {
			// Marcamos el registro para ser borrado de la base de datos.
			// $this->_aModif['detalles'][$idx_det] |= inmPed_DB_DELETE;
			// $this->_aModif['detalles'][$idx_det] |= inmPed_DB_COMMIT;
			$this->_change_flags((inmPed_CHG_DETAIL | inmPed_DB_DELETE),$idx_det);
			$this->_aDet_dbdel[$idx_det]['id_detalle'] = $this->_aDetalles[$idx_det]['id_detalle'];
			$this->_aDet_dbdel[$idx_det]['id_articulo'] = $this->_aDetalles[$idx_det]['id_articulo'];
			$this->_aDet_dbdel[$idx_det]['id_pedido'] = $this->_aDetalles[$idx_det]['id_pedido'];
			$this->_aDet_dbdel[$idx_det]['cantidad_actual'] = $this->get_quantity($idx_det);
			$this->_aDet_dbdel[$idx_det]['cantidad_recibida'] = $this->get_quantity($idx_det,FALSE,inmPed_QUANTITY_DELIVERED);
			$this->_aDet_dbdel[$idx_det]['cantidad_pedida'] = $this->get_quantity($idx_det,FALSE,inmPed_QUANTITY_REQUESTED);
			if ($this->debug) {
				debug("Borrando idx $idx_det, Que ahora va por: ");
				print_r($this->_aDet_dbdel[$idx_det]);
			}
		} else {
			$this->_aModif['detalles'][$idx_det] &= ~inmPed_DB_COMMIT;
		}

		// Borramos este Indice de los servicios (si existe)
		$idserv = $this->_aDetalles[$idx]['id_servicio'];
		if (is_array($this->_aServicio_DetIdx[$idserv]) AND in_array($idx,$this->_aServicio_DetIdx[$idserv]))
		   $this->_aServicio_DetIdx[$idserv] = array_diff($this->_aServicio_DetIdx[$idserv],array($idx));

		// Borramos el registro de las lineas de detalle. (moviendo si es preciso el puntero a los detalles).
		// Nos cepillamos los indices que apuntente a esta linea de detalle.
		$id_detalle = $this->_aDetalles[$idx_det]['id_detalle'];
		$this->_aDetIdx[$id_detalle] = NULL;
		unset($this->_aDetIdx[$id_detalle]);
		$this->_aDetIdx_Art[$this->_aDetalles[$idx_det]['id_articulo']] = array_diff(
						$this->_aDetIdx_Art[$this->_aDetalles[$idx_det]['id_articulo']],array($idx_det));

		$this->_aDetalles[$idx_det] = NULL;
		unset($this->_aDetalles[$idx_det]);

		$this->_change_flags( inmPed_CHG_MAIN | inmPed_MODIFIED );
		$this->_change_flags( (inmPed_CHG_DETAIL | inmPed_MODIFIED) | inmPed_CHG_DET_QUANTITY,-1);
	}

	function num_details() {
	   return sizeof($this->_aDetalles);
	}

	function verifyDetail($idx) {
		return ( (is_array($this->_aDetalles[$idx])) ? true : false );
	}

	/** 
	  * Metodo encargado de obtener un vector con las referencias de los servicios/contratos aplicables al id articulos $idart
	  *
	  * NOTA: Metodo sobrescrito en las clase Order.
	  **/
	function getArticleContracts($idart) {
		$aRetVal = NULL;
		if (!is_numeric($idart) OR empty($idart)) return NULL;
		if (is_array($this->_aServicios) AND sizeof($this->_aServicios)) {
			foreach ($this->_aServicios as $ids => $aSer) {
				if (is_array($aSer['referencias'][$idart]) AND sizeof($aSer['referencias'][$idart]) AND !is_array($aRetVal[$ids])) {
					foreach ($aSer as $campo => $valor) {
						if ($campo != 'referencias') $aRetVal[$ids][$campo] = $valor;
						else {
							foreach ($aSer['referencias'][$idart] as $c => $v) $aRetVal[$ids][$c] = $v;
						}
					}
					$aRetVal[$ids]['id_articulo'] = $idart;
				}
			}
		}
		return $aRetVal;
	}

	function get_article_contracts($idart) {
		return $this->getArticleContracts($idart);
	}

	/**
	  * Metodo para comprobar si una linea de detalle tiene descuento o no.
	  * @param $idx_det	-	Identificador de la linea de detalle sobre la cual se quiere hacer la comprobacion.
	  * @return bool		-	Devuelve si tiene o no descuento la linea.
	  */
	function have_discount($idx_det) {
		/** **
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		/** **/
		if (!is_array($this->_aDetalles[$idx_det])) return false;
		if (0 AND $this->debug) {
			debug("have_discount($idx_det)");
			debug("dto : ".$this->_aDetalles[$idx_det]['descuento'].
					"monto : ".$this->_aDetalles[$idx_det]['monto'].
					"tipo : ".$this->_aDetalles[$idx_det]['tipo_descuento']);
		}
		if ((float)$this->_aDetalles[$idx_det]['descuento'] OR (float)$this->_aDetalles[$idx_det]['monto'] 
					OR !empty($this->_aDetalles[$idx_det]['tipo_descuento'])) return true;
		else return false;
	}

	/**
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto			Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  **/
	function check_client_discount($idx_det,$bCommit = TRUE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		$idx_det = (int)$idx_det;
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		if (!isset($bCommit)) $bCommit = TRUE;
		if ($this->debug) debug("Comprobando descuentos de cliente ($bCommit)...");

		if ($this->_fPedido & inmPed_VENTA) {
			$id_empresa = $this->_aPedido['id_empresa'];
			$id_cliente = $this->_aPedido['id_cliente'];
			$id_articulo = $this->_aDetalles[$idx_det]['id_articulo'];
			$oDb = $this->_db;

			$fila = NULL;
			  //descuento por cliente y articulo
			$consulta = "Select descuento , monto  FROM Cliente_articulos ".
						  "WHERE id_articulo = $id_articulo and id_empresa = $id_empresa and id_cliente = $id_cliente";
			$resul4 = $oDb->query($consulta);
			if ($oDb->num_rows($resul4)) {
				$row4 = $oDb->fetch_array($resul2);
				if($row4['descuento'] > 0 ){
					$fila['descuento'] = $row4['descuento'];
					$fila['tipo_descuento'] = $row4['descuento'] .  " % Cli/Art";
					$fila['tipo_descuento_fmt'] = Document::format_number($row4['descuento'],$this->tot_decimals,true)." % Cli/Art";
					$fila['is_pto']	= TRUE;
				} elseif($row4['monto'] > 0){
					$fila['monto'] = $row4['monto'];
					$fila['tipo_descuento'] = $row4['monto'].' '.$leyenda_divisa." Cli/Art ";
					$fila['tipo_descuento_fmt'] = Document::format_number($row4['monto'],$this->tot_decimals,true).' '.$leyenda_divisa.' Cli/Art ';
					$fila['is_pto']	= FALSE;
				}
			} else { // Si no hay descuento por articulo, miramos a ver por familia.
				//descuento por familia de articulos y cliente
				$consulta = "Select descuento from Cliente_familia_articulos , Articulos
						 where Articulos.id_articulo = $id_articulo and Cliente_familia_articulos.id_empresa = $id_empresa
						 and Cliente_familia_articulos.id_cliente = $id_cliente
						 and Cliente_familia_articulos.id_familia = Articulos.id_familia";
				$resul2 = $oDb->query($consulta);
				$row2 = $oDb->fetch_array($resul2);
				if(!isset($fila['descuento']) AND !isset($fila['monto']) )
						 if($row2['descuento'] > 0) {
									$fila['descuento'] = $row2['descuento'];
									$fila['tipo_descuento'] = $row2['descuento'] . " % Cli/Fam";
									$fila['tipo_descuento_fmt'] = Document::format_number($row2['descuento'],$this->tot_decimals,true)." % Cli/FaFam";
									$fila['is_pto']	= TRUE;
						 }
			}
			if (is_array($fila) AND $bCommit) {
				// FALSE es para que no lo inserte caso de ya existir un descuento.
				$this->set_detail_discount($idx_det,$fila['descuento'],$fila['is_pto'],$fila['tipo_descuento_fmt'],FALSE);
			}
			// debug("Todos los detalles: ");
			// print_r($this->_aDetalles);
		} else { // Descuentos por articulo en _compra_
			$aDet = $this->get_detail($idx_det);
			if ($this->debug) debug("Comprobando dtos de Compra ... ");
			if (is_numeric($aDet['dto_proveedor']) AND $aDet['dto_proveedor']!=0 ) {
				if ($this->debug) debug("dto encontrado(".$aDet['dto_proveedor'].") ".(int)empty($aDet['dto_proveedor']));
				$fila['descuento'] = $aDet['dto_proveedor'];
				$fila['tipo_descuento'] = $aDet['dto_proveedor'].' % Art';
				$fila['tipo_descuento_fmt'] = Document::format_number($aDet['dto_proveedor'],$this->tot_decimals,true)." % Art";
				$fila['is_pto'] = TRUE;
				if (is_array($fila) AND sizeof($fila) AND $bCommit) {
					// FALSE es para que no lo inserte caso de ya existir un descuento.
					$this->set_detail_discount($idx_det,$fila['descuento'],$fila['is_pto'],$fila['tipo_descuento_fmt'],FALSE);
				}
			} else $fila = NULL;
		}
		return $fila;

	}

	/**
	  * Comprueba los descuentos generales por familia de articulo.
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto			Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  */
	function check_family_discount($idx_det,$bCommit = TRUE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		//Descuento global por familia
		if (!(int)$this->_aReceptor['mostrar_ofertas']) return NULL;
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		if (!isset($bCommit)) $bCommit = TRUE;
		if ($this->debug) debug("Comprobando descuentos por familia ($bCommit) ...");
		$id_empresa = $this->_aPedido['id_empresa'];
		$id_articulo = $this->_aDetalles[$idx_det]['id_articulo'];
		$oDb = $this->_db;

		$consulta = "Select descuento from Descuento_familia , Articulos , Familia_articulos
					 where Articulos.id_articulo = $id_articulo and
							 Descuento_familia.id_empresa = $id_empresa  and
							 Descuento_familia.id_familia = Articulos.id_familia";
		$resul8 = $oDb->query($consulta);
		$row8 = $oDb->fetch_array($resul8);
		if(!isset($fila['descuento']) AND !isset($fila['monto']) )
					 if($row8['descuento'] > 0){
								$fila['descuento'] = $row8['descuento'];
								$fila['tipo_descuento'] =  $row8['descuento'] . " % Fam";
								$fila['tipo_descuento_fmt'] = Document::format_number($row8['descuento'],$this->tot_decimals,true)." % Fam";
								$fila['is_pto'] = TRUE;
					 }
		if (is_array($fila) AND $bCommit) {
			// FALSE es para que no lo inserte caso de ya existir un descuento.
			$this->set_detail_discount($idx_det,$fila['descuento'],$fila['is_pto'],$fila['tipo_descuento_fmt'],FALSE);
		}
		return $fila;
	}

	/**
	  * @param	$idx_det		Identificador del detalle de pedido sobre el cual se ha de comprobar si tiene oferta o promocion
	  * @param	$bCommit		Indica si se ha de modificar el pedido o no.
	  * @return $aOffPromo	Devueve la oferta o promocion con la cantidad minima para atenerse a la misma.
	  *				[id_promocion]		-	Identificador de la promocion en la db
	  *				[nombre]				-	Nombre de la oferta o de la promocion
	  *				[cantidad]			-	Cantidad minima para satisfacer la oferta o la promocion
	  *				[descuento]			-	Descuento de la oferta
	  *				[monto]				-	Monto a descontar por cada unidad
	  *				[oferta_promocion]-	Si es una Oferta (1) o una Promocion (0) (bool)
	  *				[promo] =	array(array(id_articulo => x, cantidad => y)).
	  *										-	articulos y cantidades de regalo(precio 0) por cada cantidad satisfecha en una promo.
	  **/
	function check_offers($idx_det,$bCommit = false) {
		static $bHuecos;
		$old_dbug = $this->debug;
		$old_dbg = $this->debug;
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		if (!isset($bCommit)) $bCommit = FALSE;
		if (!isset($bHuecos)) $bHuecos = TRUE;

		$mostrar_ofertas = $this->_aReceptor['mostrar_ofertas'];
		if (!$mostrar_ofertas AND $bCommit) return NULL;

		$id_articulo = (int)$this->_aDetalles[$idx_det]['id_articulo']; 
		if (!$id_articulo) return NULL;
		// Fixme: Para las ofertas cantidad_pedida o recibida? :? 
		$cantidad = $this->get_quantity($idx_det);
		if ($this->debug) 
			debug("check_offers de $id_articulo Commit?($bCommit) ");

		$aPromo = array();
		$leyenda_divisa = $this->_aDivisa['leyenda'];
		if ( (!is_array($this->_aOff_Promo[$id_articulo]) OR empty($this->_aOff_Promo[$id_articulo])) ) {
			return NULL;
		} else if((int)$mostrar_ofertas AND !empty($this->_aOff_Promo[$id_articulo])) {
			$aPromociones = $this->_aOff_Promo[$id_articulo];
			if ($this->debug) debug("Ya habia una oferta marcada sir ($id_articulo)...");
			if ($this->debug) print_r($aPromociones);
			$applied = false;
			$aPromo_ant = array();
			$aPromo_act = array();
			foreach ($aPromociones as $idp => $aPromo) {
				//ofertas
				if ($this->debug) debug("Analizando la Promo $idp para la que hacen falta un minimo de ".$aPromo['cantidad']." Y ahora hay ".$cantidad);
				if($aPromo['oferta_promocion'] == 1) {
					if(($aPromo['cantidad'] <= abs($cantidad)) AND !$applied) {
						if (!in_array($idx_det,$aPromo['idx_det']) ) {
							if($aPromo['descuento'] > 0){
								$aTmp['descuento'] = $aPromo['descuento'];
								$aTmp['tipo_descuento'] = $aPromo['descuento'] . " % (".$aPromo['nombre'].")";
								$aTmp['tipo_descuento_fmt'] = Document::format_number($aPromo['descuento'],$this->tot_decimals,true)." % (".$aPromo['nombre'].")";
								$aTmp['is_pto']	= TRUE;
							} elseif($aPromo['monto'] > 0){
								$aTmp['descuento'] = $aPromo['monto'];
								$aTmp['tipo_descuento'] = $aPromo['monto']." $leyenda_divisa (".$aPromo['nombre'].")";
								$aTmp['tipo_descuento_fmt'] = Document::format_number($aPromo['monto'],$this->tot_decimals,true)." $leyenda_divisa (".$aPromo['nombre'].")";
								$aTmp['is_pto']	= FALSE;
							}
							$this->set_detail_discount($idx_det,$aTmp['descuento'],$aTmp['is_pto'],$aTmp['tipo_descuento_fmt'],TRUE);
							array_push($this->_aOff_Promo[$id_articulo][$idp]['idx_det'],$idx_det);
							$applied = TRUE;
							$idx_promo = $idp;
						}
					} elseif (in_array($idx_det,$aPromo['idx_det'])) { 
						// Aqui quitarle la oferta/promo si no llega a la cantidad.
						$this->set_detail_discount($idx_det,0,true,NULL,true);
						$this->_aOff_Promo[$id_articulo][$idp]['idx_det'] = 
								array_diff($this->_aOff_Promo[$id_articulo][$idp]['idx_det'],array($idx_det));
					}
				}
				if ( is_array($aPromo['promo']) AND (!(int)$aPromo['oferta_promocion'] OR (int)$aPromo['oferta_promocion']==2)) {
					if ( ((int)$aPromo['cantidad'] <= abs($cantidad)) AND !$applied) {
						if ($this->debug) 
							debug("Primera promo aplicable(idx:$idx_det), cantidad($cantidad)");
						if (!in_array($idx_det,$aPromo['idx_det']) AND $bCommit) { 
							array_push($this->_aOff_Promo[$id_articulo][$idp]['idx_det'],$idx_det);
							$new  = TRUE;
						} else {
							if (!$bCommit AND !in_array($idx_det,$aPromo['idx_det'])) 
								if ($this->debug) debug("SIN commit para la promo $idp (que cumple) en $idx_det ...");
							$new = FALSE;
						}
						foreach ($aPromo['promo'] as $norden => $aTmp) {
							if ($this->debug) debug("VAmos a comprobar los datos restantes del pedido por la promord $norden en $id_articulo");
							if ($this->debug) print_r($aTmp);
							if ($bCommit) {
								if ($cantidad > 0) $ratio_cantidad = floor($cantidad / $aPromo['cantidad']);
								else $ratio_cantidad = ceil($cantidad / $aPromo['cantidad']);
								if ($this->debug) debug("Hacemos efectiva la promocion encontrada Inactiva? (new?:$new)...");
								if ($new AND (!isset($aTmp[$idx_det])) ) {
									if (is_array($aPromo_ant) AND sizeof($aPromo_ant)) {
										while ($idx_ = array_shift($aPromo_ant)) {
											$tmp = $this->getDetailAttribute($idx_,'id_detalle');
											$tmp2 = $this->_aDet_dbdel[$idx_]['id_detalle'];
											if (empty($tmp) and empty($tmp2)) {
												debug("Detalle vacio, Reciclamos $idx_ ");
												$aPrx['idx_pos'] = $idx_;
												break;
											}
										}
									} 
									$aPrx['id_articulo'] = $aTmp['id_articulo'];
									$aPrx['cantidad'] = $aTmp['cantidad'] * $ratio_cantidad;
									$aPrx['idx_trigger'] = $idx_det;
									$aPrx['idp_det'] = $norden;
									$aPrx['idx_promo'] = $idp;
									$aPrx['nombre'] = $aPromo['nombre'];
									array_push($aPromo_act,$aPrx);
								} else {
									if ($this->debug) 
										debug("Cambio de cantidades($cantidad) en una promocion ".
												"activa $cantidad X $ratio_cantidad * $aTmp[cantidad]...");
									$idx = $aTmp[$idx_det];
									$id_art = $aTmp['id_articulo'];
									if ($this->debug) 
										debug("cambiando articulo $id_art en detalle $idx..");
									$cant = $aTmp['cantidad'] * $ratio_cantidad;
									$aArt = $this->get_detail($idx);
									if (!is_array($aArt) OR $aArt['id_articulo']!=$id_art OR ($this->get_price($idx)!=0)) { 
										// Este caso no se produce:
										// Si estaba borrado, lo a�adimos en la misma pos de detalle (si no hay otro ahora)
										if ($this->debug) 
											debug("Anyadimos articulo($id_art) borrado($idx) de promocion...");
										$idx_ = $this->add_detail($id_art,$cant,NULL,FALSE,$idx);
										if ($idx != $idx_) {
											if ($this->debug) debug("No se pudo re-insertar la linea de detalle");
											$this->_aOff_Promo[$id_articulo][$idp]['promo'][$norden][$idx_det] = $idx_;
										}
										$this->set_price($idx_,0,TRUE);
										$this->set_detail_discount($idx_,0,NULL,$aPromo['nombre'],TRUE);
									} else {
										if ($this->debug) debug("metemos cantidad $cant en $idx");
										$this->set_price($idx,0,TRUE);
										$this->set_quantity($idx,$cant,NULL,NULL,NULL,FALSE);
										$this->set_detail_discount($idx,0,NULL,$aPromo['nombre'],TRUE);
									}
									$this->set_detail_discount($idx_det,0,NULL,$aPromo['nombre'],TRUE);
								}
								if ($this->debug) debug("De Regalo van: ");
								if ($this->debug) print_r($aPromo_act);
							}
						} // Mientras me queden articulos de promocion... 
						$idx_promo = $idp;
						$applied = TRUE;
						if (!$this->have_discount($idx_det)) 
							$this->set_detail_discount($idx_det,0,NULL,$aPromo['nombre'],TRUE);
					} elseif (in_array($idx_det,$aPromo['idx_det'])) {
						if ($this->debug) debug("El detalle $idx_det (Ref: $id_articulo) existe en esta promo ".$aPromo['nombre'].", lo quitamos por no cumplir");
						// Aqui quitar la promo si no ha llegado a la cantida pertinente o se ha aplicado otra.
						$this->_aOff_Promo[$id_articulo][$idp]['idx_det'] = 
								array_diff($this->_aOff_Promo[$id_articulo][$idp]['idx_det'],array($idx_det));
						if ($this->debug) debug("Eliminamos(trigger - $idx_det) lineas sin cargo de promo ".$aPromo['nombre'].
								" por no cumplir cantidades $cantidad");
						foreach ($aPromo['promo'] as $norden => $aTmp) {
							$idx = $aTmp[$idx_det];
							if ($this->debug) 
								debug("Cepillandose el art ".$aTmp['id_articulo']." Que esta en $idx");
							$this->del_detail($idx,FALSE);
							if (!is_array($aPromo_act) OR !sizeof($aPromo_act)) {
								array_push($aPromo_ant,$idx);
								if (!$applied) $this->set_detail_discount($idx_det,0,NULL,NULL,TRUE);
							} else 
								foreach ($aPromo_act as $pos => $aPrx) 
									if (!isset($aPrx['idx_pos'])) {
										$tmp = $this->getDetailAttribute($idx,'id_detalle');
										$tmp2 = $this->_aDet_dbdel[$idx]['id_detalle'];
										if (empty($tmp) and empty($tmp2)) {
											debug("Detalle vacio para $pos, Reciclamos $idx ");
											$aPromo_act[$pos]['idx_pos'] = $idx;
											break;
										}
									}
							/** Queremos recuperar la posicion del art sin cargo? *(no o si?)*/
							$this->_aOff_Promo[$id_articulo][$idp]['promo'][$norden][$idx_det] = NULL;
							unset($this->_aOff_Promo[$id_articulo][$idp]['promo'][$norden][$idx_det]); 
							/** **/
						}
						if ($this->debug) print_r($this->_aOff_Promo[$id_articulo][$idp]);
					} elseif (is_array($aPromo['promo'])) {
						if ($this->debug) debug("Comprobando promo ".$aPromo['nombre']." para limpiarla de detalles no usados .. ");
						// Esta promocion pudo haber estado activa, a ver si tiene idx_detalles no usados para reciclarlos.
						foreach ($aPromo['promo'] as $aPr)
							if ( isset($aPr[$idx_det]) AND !$this->get_detail_article_id($aPr[$idx_det]) ) {
								if ($this->debug) debug("Reciclando detalle $idx_det por no poseer id_articulo ");
								// Si ha estado activa para este detalle y tiene una lindea de detalle de promocion libre, la reciclamos.
								if (!is_array($aPromo_act) OR !sizeof($aPromo_act))
									array_push($aPromo_ant,$aPr[$idx_det]);
								else 
									foreach ($aPromo_act as $pos => $aPrx)
										if (!isset($aPrx['idx_pos'])) {
											debug("Detalle vacio sobre $pos, Reciclamos ".$aPrx[$idx_det]);
											$tmp = $this->getDetailAttribute($aPrx[$idx_det],'id_detalle');
											$tmp2 = $this->_aDet_dbdel[$idx_det]['id_detalle'];
											if (empty($tmp) and empty($tmp2)) $aPromo_act[$pos]['idx_pos'] = $aPrx[$idx_det];
										}
							}
					}
				} // Fin de si es promo
			} // Fin del recorrido de promociones
			// Anyado promos nuevas al final de todo por si puedo aprovechar el hueco dejado por otra promo de este detalle.
			if ($applied AND is_array($aPromo_act) AND sizeof($aPromo_act)) {
				if ($this->debug) debug("Commit .. ");
				$this->set_detail_discount($aPromo_act[0]['idx_trigger'],0,TRUE,$aPromo_act[0]['nombre'],TRUE);
				foreach ($aPromo_act as $aPrx) {
					if (isset($aPrx['idx_pos'])) $idx_ = $aPrx['idx_pos'];
					else $idx_ = NULL;
					if ($this->debug) debug("Consolidando la promo en ".$aPromo_act[0]['idx_trigger']." -> Add de: $idx_ ");
					$tmp_idx = $this->add_detail($aPrx['id_articulo'],$aPrx['cantidad'],NULL,FALSE,$idx_);
					$this->set_price($tmp_idx,0,TRUE);
					$this->set_detail_discount($tmp_idx,0,NULL,$aPrx['nombre'],TRUE);
					// debug("<b>COMMIT</b> - ID:$aPrx[id_articulo] IDX_Promo: $aPrx[idx_promo] IDP_DET: $aPrx[idp_det] IDX_Trigger: $aPrx[idx_trigger] val: $tmp_idx ");
					$this->_aOff_Promo[$aPrx['id_articulo']][$aPrx['idx_promo']]['promo'][$aPrx['idp_det']][$aPrx['idx_trigger']] = $tmp_idx;
					// $this->_aOff_Promo[$id_articulo][$aPrx['idx_promo']]['promo'][$aPrx['idp_det']][$aPrx['idx_trigger']] = $tmp_idx;
				}
			}
			if ($this->debug) debug("Promo N $idx_promo : Applied? ($applied) ");
			if ($this->debug) print_r($this->_aOff_Promo);
			// Comprobar cantidad antes de asignar el array de retorno. Y devolver solo la que le toco.
			if ($applied) $aPromo = $this->_aOff_Promo[$id_articulo][$idx_promo]; 
		} else {
			if ($this->debug) debug("Document::check_offers() <b>Vaciando</b> Promociones para $id_articulo ... ");
			$aPromo = $this->_aOff_Promo[$id_articulo] = NULL;
			if ($this->debug) debug("El articulo $id_articulo no tiene nah de nah");
		} // Fin de si mostrar_ofertas
		if (!is_array($aPromo) OR (is_array($aPromo) AND !sizeof($aPromo))) return $this->_aOff_Promo[$id_articulo][$idx_promo];
		else return $aPromo;
	}

	/**
	  * Metodo encargado de comprobar si un idx/linea de detalle pertenece a una oferta/promocion o no.
	  * @param bRegalo	-	bool que limita la comprobacion a los productos sin cargo, o no. por defecto, valen todos.
	  **/
	function isInOffer ($idx,$bRegalo = false) {
		if (!is_numeric($idx)) return FALSE;
		$bFound = false;
		debug("esta $idx en una promo? ($bRegalo) ");
		if (is_array($this->_aOff_Promo) AND sizeof($this->_aOff_Promo))
			foreach ($this->_aOff_Promo as $idart => $aPromos) {
				if (is_array($aPromos) AND sizeof($aPromos))
					foreach ($aPromos as $ind => $aPromo) {
						if (!is_array($aPromo['idx_det'])) continue;
						if (!$bRegalo AND in_array($idx,$aPromo['idx_det'])) {
							$bFound = true;
							break;
						}
						foreach ($aPromo['idx_det'] as $idx_detcargo) {
							foreach ($aPromo['promo'] as $aSinCargo) 
								if ($idx == $aSinCargo[$idx_detcargo]) {
									$bFound = true;
									break;
								}
							if ($bFound) break;
						}
					}
				if ($bFound) break;
			}

		return $bFound;
	}

	/**
	  * Metodo encargado de obtener _todas_ las posibles ofertas y promociones, a fecha del documento, para sus referencias
	  * @param $aIdx 	- 	Lista de Indices del documento, para los cuales hacer la comprobacion.
	  * @return true on success, false on error
	  */
	function _dbFetchOffers($aIdx = NULL,$bForce = false) {
		$oDb = $this->getDb();

		if (!isset($bForce)) $bForce = false;
		if (!is_array($aIdx) or !sizeof($aIdx)) {
			$idx_ant = $this->current_detail();
			$aIdx = array();
			for($i = $this->first_detail(); isset($i); $i= $this->next_detail()) 
				if (!in_array($i,$aIdx) AND (!is_array($this->_aOff_Promo[$id_art]) OR !sizeof($this->_aOff_Promo[$id_art])) ) 
					array_push($aIdx,$i);
			$this->set_active_detail($idx_ant);
		}
		if (!is_array($aIdx) or !sizeof($aIdx)) return false;

		$aArts = array();
		$this->dbg('','_dbFetchOffers');
		foreach ($aIdx as $idx) {
			$id_art = $this->get_detail_article_id($idx);
			if (!in_array($id_art,$aArts)) {
				if (is_array($this->_aOff_Promo[$id_art]) and sizeof($this->_aOff_Promo[$id_art])) {
					if ($this->debug) debug("Document::_dbFetchOffers() <b>NO Vaciando</b> Promociones para $id_art ... No Comment");
					continue;
				}
				$this->_aOff_Promo[$id_art] = array();
				array_push($aArts,$id_art);
			}
		}
		if (!is_array($aArts) or !sizeof($aArts)) return false;

		// Establecemos la fecha para la comprobacion de ofertas y promociones
		$date = $this->get_date();
		if (empty($date)) $date = "NOW()";
		else $date = wol_db::formatear_fecha($date);

		$str_where_pr = '';
		foreach ($aArts as $ida) $str_where_pr .= ( (!empty($str_where_pr)) ? ' OR ' : '').' P.id_articulo = '.$ida;

		//Promociones u ofertas
		$cons_promos = 'SELECT Pa.id_promocion,Pa.id_articulo, Pa.cantidad '.
						 'FROM Promociones P LEFT JOIN Promociones_articulos Pa ON (P.id_promocion=Pa.id_promocion) '.
						 'WHERE ('.$str_where_pr.') AND P.id_empresa = '.$this->_aPedido['id_empresa'].' AND P.oferta != 1 '.
						 ' AND P.fecha_inicio < '.$date.' AND (P.fecha_fin>'.$date.' OR P.fecha_fin IS NULL OR P.fecha_fin=0) '.
						 ' ORDER BY P.cantidad desc ';
		// debug($cons_promos);
		$pr_rs = $oDb->query($cons_promos);
		$aPromoList = array();
		if ($oDb->num_rows($pr_rs)) 
			while ($aTmp = $oDb->fetch_assoc($pr_rs)) {
				if (!is_array($aPromoList[$aTmp['id_promocion']])) $aPromoList[$aTmp['id_promocion']] = array();
				array_push($aPromoList[$aTmp['id_promocion']],$aTmp);
			}
		$oDb->libera($pr_rs);

		$consulta = 'SELECT id_articulo,id_promocion, cantidad, descuento, monto, oferta as "oferta_promocion", nombre  '.
						 'FROM Promociones P '.
						 'WHERE ('.$str_where_pr.') AND id_empresa = '.$this->_aPedido['id_empresa'].
						 ' AND fecha_inicio < '.$date.' AND (fecha_fin>'.$date.' OR fecha_fin IS NULL OR fecha_fin=0) '.
						 ' ORDER BY cantidad desc ';
		// debug($consulta);
		$promo_rs = $oDb->query($consulta);
		  
		// No se puede modificar la linea de detalle si ya tiene descuento aplicado.
		// if ($bCommit AND $this->have_discount($idx_det)) $bCommit = false;
		// if ($this->debug) debug("check_offers(Idx - $idx_det) - Commit($bCommit)");
		$bCommit = false;
		$bHuecos = false;

		$aIdx_vacio = array();
		if ($bHuecos) {
			if ($this->debug) debug("Hueco en $idx_det ");
			$idx_ant = $this->current_detail();
			$this->set_active_detail($idx_det);
			$bHuecos = false;
			for($i = $idx_ant; isset($i); $i= $this->next_detail()) {
				if (!isset($ant_i)) { 
					$ant_i = $i; 
					continue; 
				} elseif ($ant_i < ($i-1))  {
					$bHuecos = true;
					while (++$ant_i < $i) array_push($aIdx_vacio,$ant_i);
				}
				$ant_i = $i;
			}
			$this->set_active_detail($idx_ant);
		} // else debug("No hay Huecos desde $idx_det");

		$applied = false;
		$idp = 0;
		if ($oDb->num_rows($promo_rs)) {
			while($aPromo = $oDb->fetch_assoc($promo_rs)) {
				$aPromo['idx_det'] = array();
				$id_articulo = $aPromo['id_articulo'];
				if (!is_array($this->_aOff_Promo[$id_articulo])) $this->_aOff_Promo[$id_articulo] = array();
				$id_promo = $aPromo['id_promocion'];
				if ($this->debug) debug("Revisando la promo $id_promo : ");
				if ($this->debug) print_r($aPromo);
				//ofertas
				if($aPromo['oferta_promocion'] == 1) {
					if($bCommit AND ((int)$aPromo['cantidad'] <= $cantidad) AND !$applied ) {
						if($aPromo['monto'] > 0){ // El monto prima sobre el dto (mas especifico)
							$impte = $this->get_detail_ammount($idx_det); 
							if (abs($impte) < abs($aPromo['monto'])) $aPromo['monto'] = $impte; // No se dta mas de lo que vale
							$aTmp['descuento'] = $aPromo['monto'];
							$aTmp['tipo_descuento'] = $aPromo['monto']." $leyenda_divisa (".$aPromo['nombre'].")";
							$aTmp['tipo_descuento_fmt'] = Document::format_number($aPromo['monto'],$this->tot_decimals,true)." $leyenda_divisa (".$aPromo['nombre'].")";
							$aTmp['is_pto']	= FALSE;
						} elseif($aPromo['descuento'] > 0){
							$aTmp['descuento'] = $aPromo['descuento'];
							$aTmp['tipo_descuento'] = $aPromo['descuento'] . " % (".$aPromo['nombre'].")";
							$aTmp['tipo_descuento_fmt'] = Document::format_number($aPromo['descuento'],$this->tot_decimals,true)." % (".$aPromo['nombre'].")";
							$aTmp['is_pto']	= TRUE;
						}
						$this->set_detail_discount($idx_det,$aTmp['descuento'],$aTmp['is_pto'],$aTmp['tipo_descuento_fmt'],TRUE);
						array_push($aPromo['idx_det'],$idx_det);
						$applied = TRUE;
						$idx_promo = $idp;
					}
				}
				//Promociones
				if (!(int)$aPromo['oferta_promocion'] OR (int)$aPromo['oferta_promocion']==2) {
					$aPromo['promo'] = array();
					if ($bCommit) {
						if ($cantidad > 0) $ratio_cantidad = floor($cantidad / $aPromo['cantidad']);
						else $ratio_cantidad = ceil($cantidad / $aPromo['cantidad']);
					}
					$applied_det = FALSE;
					$set_id_promo = FALSE;

					// while ($aTmp = $oDb->fetch_assoc($tmp_rs)) 
					if (is_array($aPromoList[$id_promo]) and sizeof($aPromoList[$id_promo]))
						while ($aTmp = array_shift($aPromoList[$id_promo])) {
							if ($bCommit AND !$applied AND $aPromo['cantidad']<=abs($cantidad) ) {
								if ($this->debug) debug("DBfetched: Hacemos efectiva la promocion encontrada...");
								array_push($aPromo['idx_det'],$idx_det);
								$aTmp[$idx_det] = array();

								// debug("No hemos encontrado la promocion nin! $aTmp[cantidad]");
								if (is_array($aIdx_vacio) AND sizeof($aIdx_vacio)) $idx_ = array_shift($aIdx_vacio);
								else $idx_ = NULL;
								$tmp_idx = $this->add_detail($aTmp['id_articulo'],($ratio_cantidad * $aTmp['cantidad']),NULL,FALSE,$idx_);
								// $this->set_cuantity($tmp_idx,0);
								$this->set_price($tmp_idx,0,TRUE);
								$this->set_detail_discount($tmp_idx,0,NULL,$aPromo['nombre'],TRUE);
								$aTmp[$idx_det] = $tmp_idx;
								$applied_det = TRUE;
							} elseif (!$applied AND $aPromo['cantidad']<=abs($cantidad)) $set_id_promo = TRUE;
							array_push($aPromo['promo'],$aTmp);
						} // Mientras me queden articulos de promocion... 
					if ($applied_det) {
						$this->set_detail_discount($idx_det,0,0,$aPromo['nombre']."",TRUE);
						$applied = TRUE;
						$set_id_promo = TRUE;
					}
					if ($set_id_promo) $idx_promo = $idp;
				} // Si tiene promocion
				if ($this->debug) debug("Almacenamos promo pa la proxima...");
				if ($this->debug) print_r($aPromo);
				if ($this->debug) debug("");
				array_push($this->_aOff_Promo[$id_articulo],$aPromo);
			} // Fin del mientras queden promociones u ofertas.
			$idp++;
		} // Fin de si hay promociones_ofertas en la db
		$this->dbg( array("Todas las promociones : ",$this->_aOff_Promo),'_dbFetchOffers');
	}

	/**
	  * Comprueba los descuentos generales por volumen de articulo.
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto			Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  */
	function check_volume_discount($idx_det,$bCommit = TRUE) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		if ($this->debug) debug("Dtos por Volumen: (".$this->_aReceptor['aplicar_dto_volumen'].")");
		if (!(int)$this->_aReceptor['aplicar_dto_volumen']) return NULL;
		//Descuento global por VolumeVolumen
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		if ($this->have_discount($idx_det)) return NULL;

		if (!isset($bCommit)) $bCommit = TRUE;

		$id_empresa = $this->_aPedido['id_empresa'];
		$id_articulo = $this->_aDetalles[$idx_det]['id_articulo'];
		$oDb = $this->_db;

		$cantidad_pedida = $this->get_quantity($idx_det);
		if ($this->debug) debug("Comprobando($bCommit) descuento por(para $cantidad_pedida) volumen(en $idx_det)...".$this->_aDetalles[$idx_det]['unidades_bulto']);

		// Fixme: Faltan por configurar los descuentos por caja
		if ($this->_aDetalles[$idx_det]['unidades_bulto']>0 AND $bCommit AND
						abs($cantidad_pedida) >= $this->_aDetalles[$idx_det]['unidades_bulto']
						AND (int)$this->_aReceptor['aplicar_dto_volumen']) {
			$numero_bultos = $cantidad_pedida / $this->_aDetalles[$idx_det]['unidades_bulto'];
			if ($this->debug) debug("numero bultos : $numero_bultos ; dto-detalle: ".$this->_aDetalles[$idx_det]['dto_volumen']);
			if (is_numeric($this->_aDetalles[$idx_det]['dto_volumen'])) {
				$dto = $this->_aDetalles[$idx_det]['dto_volumen'];
				if ($this->debug) debug("Aplicando dto volumen : ".$this->_aDetalles[$idx_det]);
				if (is_numeric($this->_aDetalles[$idx_det]['dto_volumen_bultos']))
					$btos = $this->_aDetalles[$idx_det]['dto_volumen_bultos'];
				else $btos = 1;
				if ($this->debug) debug("$dto % en articulo por $btos Bultos");
				$sBts = $btos.' Btos';
			} else {
				$dto = NULL;
				if (!is_numeric($dto) AND is_numeric($this->_aEmisor['dto_palet'])) {
					if (is_numeric($this->_aEmisor['dto_palet_uds'])) $palets_dto = $this->_aEmisor['dto_palet_uds'];
					else $palets_dto = 1;
					$bultos_dto = $this->_aDetalles[$idx_det]['capas_palet'] 
									* $this->_aDetalles[$idx_det]['bultos_capa_palet']
									* $palets_dto;
					if ((int)$bultos_dto AND $numero_bultos >= $bultos_dto) {
						$sBts = $palets_dto." Plt";
						$dto = $this->_aEmisor['dto_palet'];
					} else $dto = NULL;
				} 

				if (!is_numeric($dto) AND is_numeric($this->_aEmisor['dto_capa'])) {
					if (is_numeric($this->_aEmisor['dto_capa_uds'])) $capas_dto = $this->_aEmisor['dto_capa_uds'];
					else $capas_dto = 1;
					$bultos_dto = $this->_aDetalles[$idx_det]['bultos_capa_palet'] * $capas_dto;
					if ((int)$bultos_dto AND $numero_bultos >= $bultos_dto) {
						$sBts = $capas_dto." Cpa";
						$dto = $this->_aEmisor['dto_capa'];
					} else $dto = NULL;
				} 

				if (!is_numeric($dto) AND is_numeric($this->_aEmisor['dto_bulto']) AND $this->_aDetalles[$idx_det]['unidades_bulto']>1 ) {
					$dto = $this->_aEmisor['dto_bulto'];
					if (is_numeric($this->_aEmisor['dto_bulto_uds']))
						$btos = $this->_aEmisor['dto_bulto_uds'];
					else $btos = 1;
					if ((int)$btos) $sBts = $btos." Btos";
					else $dto = 0;
				} 
			}
			if ($this->debug) debug("supuuuutamadre($dto) no? (".$cantidad_pedida / $this->_aDetalles[$idx_det]['unidades_bulto'].") (".$btos.")");
			if (is_numeric($dto) AND (abs($cantidad_pedida) / $this->_aDetalles[$idx_det]['unidades_bulto']) >= $btos) {
				$fila['descuento'] = $dto;
				$fila['is_pto'] = TRUE;
				if ((int)$dto) {
					$fila['tipo_descuento'] = $dto.'% x '.$sBts;
					$fila['tipo_descuento_fmt'] = Document::format_number($dto,$this->tot_decimals,true).'% x '.$sBts;
				}
				// debug("Poniendo dto($dto): $sBts ");
				// print_r($fila);
				if ($this->debug) debug("Asignando Dto por Volumen...");
			}
		}

		/** **
		$consulta = "Select descuento from Descuento_familia , Articulos , Familia_articulos
					 where Articulos.id_articulo = $id_articulo and
							 Descuento_familia.id_empresa = $id_empresa  and
							 Descuento_familia.id_familia = Articulos.id_familia";
		$resul8 = $oDb->query($consulta);
		$row8 = $oDb->fetch_array($resul8);
		if(!isset($fila[descuento]) AND !isset($fila[monto]) )
					 if($row8[descuento] > 0){
								$fila[descuento] = $row8[descuento];
								$fila[tipo_descuento] =  $row8[descuento] . " % Fam";
								$fila[is_pto] = TRUE;
					 }
		/** **/
		if (is_array($fila) AND $bCommit) {
			// FALSE es para que no lo inserte caso de ya existir un descuento.
			// debug("<b>set_detail_discount()!</b>");
			$this->set_detail_discount($idx_det,$fila['descuento'],$fila['is_pto'],$fila['tipo_descuento_fmt'],FALSE);
		}
		return $fila;
	}

	/** 
	  * Computa todos los totales del pedido
	  *
	  */
	function calculate() {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return ;
		}
		if ($this->debug) debug("A calcular..");
		$this->_calculate_discounts();
		$this->_build_taxes();
		$this->_calculate_totals();
		// Marcar el pedido como calculado.
	}

	function delete() {
		if ($this->debug) debug("Marcando el pedido para ser borrado...");
		$this->_aFlags['pedido'] |= (inmPed_DB_DELETE | inmPed_DB_COMMIT);
	}

	function undelete() {
		if ($this->debug) debug("Desmarcando el pedido para ser borrado");
		$this->_aFlags['pedido'] &= ~inmPed_DB_DELETE;
	}

	function is_deleted() {
		if ($this->debug) debug("Comprobando si el pedido esta marcado para ser borrado...");
		return ( ($this->_aFlags['pedido'] & inmPed_DB_DELETE) ? TRUE : FALSE);
	}

	/** Fin de los metodos de funcionalidades **/

} /**************** FIN DE LA CLASE ******************/
}

