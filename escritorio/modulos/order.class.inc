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
	de tal forma que sea soportable la carga de instaciar varias veces esta clase en modos sin 'carrito' y light
	
	- Tendremos una clase contenedora para varios pedidos, facturas, albaranes en su modo ligth.
*****************************************************************/

if (!defined('__inmersa_document_class_inc')) {
	include_inm($mod_path.'/document.class.inc');
}

if (!defined('__inmersa_order_class_inc')) {
define('__inmersa_order_class_inc',TRUE);
class Order extends Document {

	var $_aIDAlbaran;						// Array indexado por ids con los albaranes del pedido.
	var $_aDbDetToAlb;
	var $_aIdxToAlb;

	var $_aIDFactura;						// Array indexado por ids con las facturas del pedido.
	var $_aServ_Pend = array();		// Vector de id_articulo's pendientes de comprobar sus contratos

	/** Constructor: (TODO: Retocar para usar el constructor de Document)
		* @param $tipo			-	Indica si el pedido es de compra o de venta (ver defines).
		* @param $doc_type	-	Indica si es un pedido o un presupuesto.(bool)
	 **/
	function Order($App_Name = NULL,$db_name = 'data',$tipo = inmPed_VENTA,$doc_type = 0)  {

		parent::Document($App_Name,$db_name,$tipo,$doc_type);

		// Resetamos valores.
		$this->_aServicios = array();
		$this->_aServicio_DetIdx = array();
		$this->_aServ_Pend = array();
		$this->_aPedido['preparado'] = 0;

		return $tmp;
	}

	/** Metodos de mantenimiento **/
	function init() {
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->set_db($this->_db_name);
		$this->debug = 0;
	}

	function cerrar() {
		parent::cerrar();
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		// $this->_db = NULL;
		unset($this->_db);
	}

	function error($err_code,$aParams = NULL) {
		$Sesion = $GLOBALS[$this->App_Name];
		if (!is_object($Sesion)) {
			echo "Error (Order.class:$err_code) $aParams";
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

	/** Fin de los metodos de mantenimiento **/

	/** 
	  * Metodos SET y GET de los atributos *
	  *
	  *   -- Metodos de Cabeceras y Pies --
	 */
	function setDate($f = NULL) {
		$rval = parent::set_date($f);
		if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
		if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array('fecha' => $this->getDate()),'Pedidos',false);
		if (is_array($aTmp) and sizeof($aTmp)) foreach ($aTmp as $fld => $val) $this->_aPedido[$fld] = $val;
		return $fval;
	}

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
		} else {
			$retval = $this->_set_enterprise_reciever($id,$bForce);
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
	  * Establece la direccion de entrega para el pedido.
	  * @return bool	-	Si se ha podido establecer la direccion con exito o no.
	  **/
	function set_reciever_address($id_direccion = NULL) 
	{
		if (!is_numeric($id_direccion)) 
			if (is_array($this->_aDirecciones_receptor) AND sizeof($this->_aDirecciones_receptor)) 
				$id_direccion = key($this->_aDirecciones_receptor);
			else return FALSE;
		if (!(int)$this->_aReceptor['id']) {
			$this->error('ORDER_NORECIEVER',array('ref' => $this->get_id().' '.$this->get_reference()));
			return FALSE;
		}
		if ( (!is_array($this->_aDirecciones_receptor) OR !is_array($this->_aDirecciones_receptor[$id_direccion])) 
					AND $this->_fPedido & inmPed_STRICT) return FALSE;
		if ($this->_fPedido & inmPed_VENTA) {
			$this->_aReceptor['id_direccion'] = $id_direccion;
			$this->_aPedido['id_direccion'] = $id_direccion;
			$this->_aPedido['id_almacen'] = NULL;
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		} else {
			$this->_aReceptor['id_direccion'] = $id_direccion;
			$this->_aPedido['id_almacen'] = $id_direccion;
			$this->_aPedido['id_direccion'] = NULL;
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		}

		return TRUE;
	}

	/**
	  * Este metodo es el encargado de devolver los datos de la direccion de entrega del pedido.
	  *	Si no se ha establecido la direccion de entrega, devuelve un array con todas, o null.
	  */
	function get_reciever_address($bAll = FALSE) {
		if (!isset($bAll)) $bAll = FALSE;
		if ((int)$this->_aReceptor['id_direccion'] AND !$bAll) 
			return array($this->_aDirecciones_receptor[$this->_aReceptor['id_direccion']]);
		else return $this->_aDirecciones_receptor;
	}

	/**
	  * Establece cual es el agente creador del pedido.
	  * @param  id_agente	-  Identificador del agente a establecer como realizador del pedido.
	  * @param  bForce		-  Si se ha de ignorar las opcion Strict y asignar el agente por 00
	  * @return bool			-	Verdadero caso de poder haber sido establecido, falso en caso de fallo
	  **/
	function set_agent($id_agente,$bForce = FALSE) {
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
	function get_agent() {
		return $this->_aAgente;
	}

	function get_incomplete_order() 
	{
		return $this->aPedido['id_pedido_incompleto'];
	}

	function set_incomplete_order($id) {
		if (!is_numeric($id) OR $id==$this->_aPedido['id_pedido_incompleto'] ) return false;
		$this->_aPedido['id_pedido_incompleto'] = (int)$id;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
	}

	/**
	  * Establece la referencia interna del pedido a la cadena indicada por parametro. Si la cadena no ha sido inidaca, o es nula
	  *	y el pedido no tiene referencia interna, este metodo se encarga de buscar una referencia adecuada asi como de incrementar
	  *	el contador de pedidos en la base de datos para la siguiente solicitud.
	  * Caso de recibir 0 como parametro, fuerza la busqueda de una nueva referencia.
	  **/
	function set_reference($ref = NULL) 
	{
		// Fixme: Comprobar si el pedido/presupuesto es de compras o de ventas.
		if ((!isset($ref) OR empty($ref)) AND (empty($this->_aPedido['referencia']) OR is_numeric($ref))) {
			if ($this->_fPedido & inmPed_VENTA) $sufijo = 'ventas';
			else $sufijo = 'compras';
			//crear la referencia e incrementar el contador
			$consulta = "SELECT ".
							"prefijo_ped_$sufijo as 'prefijo_ped', ".
							"sufijo_ped_$sufijo as 'sufijo_ped', ".
							"contador_ped_$sufijo as 'contador_ped', ".
							"digitos_ped_$sufijo as 'digitos_ped' ".
							"FROM  Empresas where id_empresa = ".$this->_aPedido['id_empresa'];
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
			$cons= "update Empresas set contador_ped_$sufijo = contador_ped_$sufijo + 1 where id_empresa = ".$this->_aPedido['id_empresa'];
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

	function get_reference() 
	{
		return $this->_aPedido[referencia];
	}

	function getId() {
		return $this->get_id();
	}

	function get_id() 
	{
		return $this->_aPedido['id_pedido'];
	}

	function set_status($preparado) 
	{
		if (!$preparado) $preparado = 0;
		else $preparado = 1;
		$this->_aPedido['preparado'] = $preparado;
		$this->_change_flags(inmPed_MAIN | inmPed_MODIFIED);
	}

	function get_status() 
	{
		return (int)$this->_aPedido['preparado'];
	}

	/**
	  * Metodo encargado de devolver los albaranes de un pedido.
	  **/
	function get_deliveries() 
	{
		if (is_array($this->_aIDAlbaran) AND sizeof($this->_aIDAlbaran)) return $this->_aIDAlbaran;
		else return NULL;
	}

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

	function getDeliveryFromDbDet($id_detalle) {
		if (is_array($this->_aDbDetToAlb[$id_detalle])) return $this->_aDbDetToAlb[$id_detalle];
		else return array();
	}

	function getDeliveryFromIdx($idx) {
		if (is_array($this->_aIdxToAlb[$idx])) return $this->_aIdxToAlb[$idx];
		else return array();
	}

	function getDeliveredQuantity($idx,$bReal = true,$bSent = false) {
		if (!isset($idx) OR !is_numeric($idx) OR !$this->verifyDetail($idx)) return NULL;
		if (!isset($bReal)) $bReal = true;
		if (!isset($bSent)) $bSent = false;

		$retval = 0;
		$aAlb = $this->getDeliveryFromIdx($idx);
		$id_det = $this->getDetailAttribute($idx,'id_detalle');
		if (is_array($aAlb) AND sizeof($aAlb)) 
			foreach ($aAlb as $id_alb) {
				if (is_array($this->_aIDAlbaran[$id_alb]['detalles'][$id_det]) AND sizeof($this->_aIDAlbaran[$id_alb]['detalles'][$id_det]))
					foreach ( $this->_aIDAlbaran[$id_alb]['detalles'][$id_det] as $aDet) {
						if ($bSent AND !$this->_aIDAlbaran[$id_alb]['enviado']) continue;
						$retval += $aDet['cantidad'];
						if (!$bReal) $retval -= $aDet['cantidad_devuelta'];
					}
			}

		return $retval;
	}

	/**
	  * Metodo encargado de devolver las Facturas de un Pedido.
	  **/
	function get_invoices() {
		return $this->_aIDFactura;
	}

	function set_invoice($aFra) {
		if (!is_array($aFra) OR !sizeof($aFra) OR !is_numeric($aFra['id_factura'])) return FALSE;
		$this->_aIDFactura[$aFra['id_factura']] = $aFra;
		return TRUE;
	}

	/**
	  * Recalculo del pedido - Metodo sobrecargado al padre
	  **/
	function eval_conditions($bParam = NULL) {
		$aFras = $this->get_invoices();
		if (!is_array($aFras) OR !sizeof($aFras)) parent::eval_conditions($bParam);
	}

	/**   -- Metodos de Cabeceras y Pies -- **/
	
	function __get($prop_name) {
		debug("Metodo get general ($prop_name,$prop_value)");
		return $this->$prop_name;
	}

	function __call($metodo,$aArgs) {
		debug("Metodo CALL general ($metodo,$aArgs)");
	}

	function __set($prop_name,$prop_value) 
	{
		debug("Metodo set general ($prop_name,$prop_value)");
	}


	function set_tipo_pedido($tipo) 
	{
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

	function _set_enterprise_reciever($id_empresa,$bForce = FALSE) {
		$retval = parent::_set_enterprise_reciever($id_empresa,$bForce);
	  	$this->_possible_agents_clients($id_empresa,0);
		$this->_possible_addresses($id_empresa);
		return $retval;
	}

	function _set_client_reciever($id_cliente,$bForce = FALSE) {
		$retval = parent::_set_client_reciever($id_cliente,$bForce);
	  	$this->_possible_agents_clients($id_cliente,1);
		$this->_possible_addresses($id_cliente);
		return $retval;
	}

	/**
	  * Este metodo puebla la estructura _aDirecciones_receptor que es un vector de array referenciales.
	  * Si el documento es de compra, la estructura se poblara con los datos de los almacenes de la empresa receptora.
	  * En el caso de ventas, son las direcciones de entra de nuestros clientes lo que se usaria.
	  * @param	$id	-	Clave primaria del registro en la bbdd (bien sea id_cliente o id_empresa).
	  * @return	bool	-	Si la operacion ha sido realizada con exito o no.
	  **/
	function _possible_addresses($id) 
	{
		if (!is_numeric($id)) return FALSE;

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error('DOCUMENT_NODB');
			return FALSE;
		}


		$retval = FALSE;
		if ($this->_fPedido & inmPed_VENTA) {
			// Rellenar el array de posibles direcciones de envio.
			$cons = "SELECT ".
					  "Direcciones_entrega.id_direccion as 'id_direccion', ".
					  "Direcciones_entrega.id_cliente as 'id_cliente', ".
					  "Direcciones_entrega.nombre as 'nombre', ".
					  "Direcciones_entrega.persona_contacto as 'persona_contacto', ".
					  "Direcciones_entrega.cargo_persona_contacto as 'cargo_persona_contacto', ".
					  "Direcciones_entrega.direccion as 'direccion', ".
					  "Direcciones_entrega.poblacion as 'poblacion', ".
					  "Direcciones_entrega.cp as 'codigo_postal', ".
					  "Direcciones_entrega.telefono1 as 'telefono1', ".
					  "Direcciones_entrega.observaciones as 'observaciones', ".
					  "Provincias.nombre as 'provincia' ".
					  "FROM Direcciones_entrega, Provincias ".
					  "WHERE Direcciones_entrega.id_provincia = Provincias.id_provincia AND Direcciones_entrega.id_cliente = $id";
			$id_rs = $oDb->query($cons);
			$this->_aDirecciones_receptor = array();
			if (!$oDb->num_rows($id_rs)) {
				$this->_aDirecciones_receptor = NULL;
				$this->error('ORDER_RECIEVER_NODELIVERYADDRESS',array('id' => $id));
			} else while($aTmp = $oDb->fetch_assoc($id_rs)) {
				$this->_aDirecciones_receptor[$aTmp['id_direccion']] = $aTmp;
			}
		} else {
			// Rellenar el array de posibles almacenes
			$cons = "SELECT ".
					  "Almacenes.id_almacen as 'id_direccion', ".
					  "Almacenes.id_almacen as 'id_almacen', ".
					  "Almacenes.id_empresa as 'id_empresa', ".
					  "Almacenes.nombre as 'nombre', ".
					  "Almacenes.persona_contacto as 'persona_contacto', ".
					  "Almacenes.cargo_persona_contacto as 'cargo_persona_contacto', ".
					  "Almacenes.direccion as 'direccion', ".
					  "Almacenes.poblacion as 'poblacion', ".
					  "Almacenes.cp as 'codigo_postal', ".
					  "Almacenes.telefono as 'telefono1', ".
					  "Provincias.nombre as 'provincia' ".
					  "FROM Almacenes, Provincias ".
					  "WHERE Almacenes.id_provincia = Provincias.id_provincia AND Almacenes.id_empresa = $id";
			$id_rs = $oDb->query($cons);
			$this->_aDirecciones_receptor = array();
			if (!$oDb->num_rows($id_rs)) {
				$this->_aDirecciones_receptor = NULL;
				$this->error('ORDER_RECIEVER_NODELIVERYADDRESS',array('id' => $id));
			} else while($aTmp = $oDb->fetch_assoc($id_rs)) {
				$this->_aDirecciones_receptor[$aTmp['id_almacen']] = $aTmp;
			}
		}

		return $retval;
	}

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
		$cons = "SELECT Ped.id_pedido as 'ped_id_pedido', ".
				  "Ped.id_presupuesto as 'ped_id_presupuesto', ".
				  "Ped.id_empresa as 'ped_id_empresa', ".
				  "Ped.id_agente as 'ped_id_agente', ".
				  "Ped.id_tarifa as 'ped_id_tarifa', ".
				  "Ped.id_direccion as 'ped_id_direccion', ".
				  "Cli.id_cliente as 'ped_id_cliente', ".
				  "Ped.id_proveedor as 'ped_id_proveedor', ".
				  "Ped.id_divisa as 'ped_id_divisa', ".
				  "Ped.id_forma_pago as 'ped_id_forma_pago', ".
				  "FPago.nombre as 'ped_nombre_forma_pago', ".
				  "FPago.nombre as 'fpa_nombre', ".
				  "FPago.id_forma_pago as 'fpa_id_forma_pago', ".
				  "FPago.num_efectos as 'fpa_num_efectos', ".
				  "FPago.dias_efectos as 'fpa_dias_efectos', ".
				  "FPago.medio_pago as 'fpa_medio_pago', ".
				  "CliEmp.dia_facturacion_1 as 'fpa_dia_I', ".
				  "CliEmp.dia_facturacion_2 as 'fpa_dia_II', ".
				  "CliEmp.dia_facturacion_3 as 'fpa_dia_III', ".
				  "Ped.id_pedido_incompleto as 'ped_id_pedido_incompleto', ".
				  "Ped.residual as 'ped_residual', ".
				  "Ped.nombre as 'ped_nombre', ".
				  "Ped.referencia as 'ped_referencia', ".
				  "Ped.referencia_externa as 'ped_referencia_externa', ".
				  "Ped.observaciones as 'ped_observaciones', ".
				  "Ped.fecha as 'ped_fecha', ".
				  "Ped.id_dia as 'ped_id_dia', ".
				  "Ped.preparado as 'ped_preparado', ".
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
				  "Ped.id_direccion as 'cli_id_direccion', ".
				  "TCli.aplicar_iva as 'cli_aplicar_iva', ".
				  "TCli.aplicar_recargo as 'cli_aplicar_recargo', ".
				  "CliEmp.dto_directo as 'cli_dto_directo', ".
				  "CliEmp.dto_pronto_pago as 'cli_dto_pronto_pago', ".
				  "CliEmp.aplicar_retencion as 'cli_aplicar_retencion', ".
				  "CliEmp.mostrar_ofertas as 'cli_mostrar_ofertas', ".
				  "CliEmp.aplicar_dto_vol as 'cli_aplicar_dto_volumen', ".
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
				  "FROM Pedidos `Ped`, Direcciones_entrega `Dir`, Clientes `Cli`, Clientes_empresas `CliEmp`, Forma_pago as `FPago`, ".
				  "Tarifas `Tar`, Empresas `Emp`, Divisa `Div`, Divisa `Div2`, Tipo_cliente `TCli`, Provincias `Prov`, Provincias `Prov2` ".
				  "WHERE Ped.id_pedido = $id AND Prov.id_provincia = Emp.id_provincia ".
				  "AND FPago.id_forma_pago = Ped.id_forma_pago AND ".
				  "Prov2.id_provincia = Cli.id_provincia AND ".
				  "Ped.id_direccion = Dir.id_direccion AND Dir.id_cliente = Cli.id_cliente AND ".
				  "Ped.id_empresa = CliEmp.id_empresa AND CliEmp.id_cliente=Cli.id_cliente AND ".
				  "Ped.id_tarifa = Tar.id_tarifa AND Ped.id_empresa = Emp.id_empresa AND ".
				  "Cli.id_divisa = Div2.id_divisa AND ".
				  "Emp.id_divisa = Div.id_divisa AND CliEmp.id_tipo_cliente = TCli.id_tipo_cliente ";

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
		$cons = "SELECT Ped.id_pedido as 'ped_id_pedido', ".
				  "Ped.id_presupuesto as 'ped_id_presupuesto', ".
				  "Ped.id_empresa as 'ped_id_empresa', ".
				  "Ped.id_agente as 'ped_id_agente', ".
				  "Ped.id_almacen as 'ped_id_almacen', ".
				  "Ped.id_proveedor as 'ped_id_proveedor', ".
				  "Ped.id_divisa as 'ped_id_divisa', ".
				  "Ped.id_forma_pago as 'ped_id_forma_pago', ".
				  "Ped.id_pedido_incompleto as 'ped_id_pedido_incompleto', ".
				  "Ped.residual as 'ped_residual', ".
				  "Ped.nombre as 'ped_nombre', ".
				  "Ped.referencia as 'ped_referencia', ".
				  "Ped.referencia_externa as 'ped_referencia_externa', ".
				  "Ped.observaciones as 'ped_observaciones', ".
				  "Ped.fecha as 'ped_fecha', ".
				  "Ped.id_dia as 'ped_id_dia', ".
				  "Ped.preparado as 'ped_preparado', ".
				  "FPago.nombre as 'ped_nombre_forma_pago', ".
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
				  "EmpPrv.descuento as 'emp_dto_directo', ".
				  "EmpPrv.descuento_financiero as 'emp_dto_pronto_pago', ".
				  "EmpPrv.aplicar_retencion as 'emp_aplicar_retencion', ".
				  "EmpPrv.mantener_ratio_divisa as 'prv_ratio_divisa_dias', ".
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
				  "FROM Pedidos `Ped`, Almacenes `Alm`, Empresas `Emp`, Proveedores_empresas `EmpPrv`, Forma_pago as `FPago`, ".
				  "Proveedores `Prv`, Divisa `Div`, Divisa `Div2`, Provincias `Prov`, Provincias `Prov2` ".
				  "WHERE Ped.id_pedido = $id AND Prv.id_proveedor = Ped.id_proveedor AND ".
				  "FPago.id_forma_pago = Ped.id_forma_pago AND ".
				  "Prov2.id_provincia = Emp.id_provincia AND Prov.id_provincia = Prv.id_provincia AND ".
				  "Ped.id_almacen = Alm.id_almacen AND ".
				  "Ped.id_empresa = EmpPrv.id_empresa AND EmpPrv.id_proveedor=Prv.id_proveedor AND ".
				  "Emp.id_divisa = Div2.id_divisa AND ".
				  "Prv.id_divisa = Div.id_divisa ";

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
					} elseif (!strcasecmp($ref_arr,'tar_')) {
						$this->_aTarifa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'div_')) {
						$this->_aDivisa[$ref_resto] = $valor;
					} elseif (!strcasecmp($ref_arr,'fpa_')) {
						$this->_aFPago[$ref_resto] = $valor;
					}
			  }
			  $this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
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
					"Empart.servicios_duracion_precio as 'servicios_duracion_precio', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente' ".
					"FROM Lineas_detalle `Det`, Articulos `Art` LEFT JOIN Localizacion_articulos La ON (Art.id_articulo=La.id_articulo) ".
					"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
					"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
					"Familia_articulos `Fam`, Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Pedidos `Ped` ".
					"WHERE Ped.id_pedido = $id AND Ped.id_pedido = Det.id_pedido AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Ped.id_empresa AND Art.id_marca = Mca.id_marca AND ".
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
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				if (!empty($campo_rec)) $fila['PVP_rec'] = $this->_applyRevenue($fila['PVP_rec'],$fila['porcentaje']);
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

				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}
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
					"Det.id_pedido as 'id_pedido', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					( ($hay_albaranes) 
						? "Det.cantidad - Det.cantidad_recibida as 'cantidad_residual', "
						: "" ).
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
					"(Det.cantidad*Art.peso_unidad) as 'peso', ".
					"Empart.unidades_bulto as 'unidades_bulto', ".
					"Empart.bultos_capa_palet as 'bultos_capa_palet', ".
					"Empart.capas_palet as 'capas_palet', ".
					"Empart.precio_venta as 'PVP_rec', ".
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					"SUM(La.cantidad) as 'stock_real', ".
					"CompArt.precio as 'precio_real', ".
					"CompArt.referencia as 'referencia_externa', ".
					"CompArt.dto_vol as 'dto_volumen', ".
					"CompArt.dto_vol_bultos as 'dto_volumen_bultos', ".
					"CompArt.id_servicio as 'servicios_id', ".
					"CompArt.cuota_alta as 'servicios_cuota_alta', ".
					"CompArt.servicios_poradelantado as 'servicios_por_adelantado', ".
					"CompArt.servicios_duracion_precio as 'servicios_duracion_precio', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente' ".
					"FROM Lineas_detalle `Det`, Articulos `Art` LEFT JOIN Localizacion_articulos La ON (La.id_articulo=Art.id_articulo) ".
					"LEFT JOIN Unidades_medida Um ON (Art.id_unidad_medida=Um.id_unidad_medida) ".
					"LEFT JOIN Certificados Cert ON (Art.id_certificado=Cert.id_certificado), ".
					"Familia_articulos `Fam`, Marcas `Mca`, Tipos_IVA `Iva`, ".
					"Empresas_articulos `Empart`, Pedidos `Ped`, Compra_articulos `CompArt` ".
					"WHERE Ped.id_pedido = $id AND Ped.id_pedido = Det.id_pedido AND CompArt.id_proveedor = $id_prv AND ".
					"CompArt.id_articulo = Det.id_articulo AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Ped.id_empresa AND Art.id_marca = Mca.id_marca AND ".
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
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
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

				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}
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

		if (!is_numeric($idx)) return false;
		if (!is_array($this->_aDetalles[$idx])) return false;
		$old_idserv = $this->_aDetalles[$idx]['id_servicio'];
		if (!is_numeric($id_servicio) OR empty($id_servicio)) {
			if (is_numeric($old_idserv) AND $old_idserv!=$id_servicio) return $this->unset_detail_contract($idx);
			else return false;
		}
		$this->_updateArticleContracts();

		if (!is_array($this->_aServicios[$id_servicio])) 
			if (!$this->_dbFetchContract($id_servicio)) return FALSE;

		$idart = $this->get_detail_article_id($idx);

		//Comprobamos que no exista la misma referencia y servicio en este pedido.
		$bMatch = FALSE;
		if (is_array($this->_aServicio_DetIdx[$id_servicio]) AND sizeof($this->_aServicio_DetIdx[$id_servicio]))
			foreach ($this->_aServicio_DetIdx[$id_servicio] as $tstidx) {
				if ($this->debug) debug("El servicio $id_servicio en indice $tstidx con ref($idart): ".$this->get_detail_article_id($tstidx));
				if ($this->get_detail_article_id($tstidx) == $idart) {
					$bMatch = TRUE;
					break;
				}
			}
		if ($bMatch) {
			// $this->error('ORDER_CONTRACT_DUPLICATE',array ('prod' => $this->_aDetalles[$idx]['nombre'].' ('.$idart.') ', 
						// 'contract' => $this->_aServicios[$id_servicio]['nombre']));
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

		$this->set_price($idx,$cuota,false);
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
		debug("unset_detail_contract() ... ");
		$this->_updateArticleContracts();
		if (!is_numeric($idx) OR !is_array($this->_aDetalles[$idx])) return FALSE;
		if (is_numeric($idx) AND is_numeric($this->_aDetalles[$idx]['id_servicio'])) {
			$idserv = $this->_aDetalles[$idx]['id_servicio'];
			if (is_array($this->_aServicio_DetIdx[$idserv]) AND in_array($idx,$this->_aServicio_DetIdx[$idserv]))
				$this->_aServicio_DetIdx[$idserv] = array_diff($this->_aServicio_DetIdx[$idserv],array($idx));
		}
		$precio = $this->_applyRevenue($this->_aDetalles[$idx]['precio_real']);
		$this->set_price($idx,$precio,false);
		$this->setDetailAttribute($idx,'id_servicio','null');
	}

	function getArticleContracts($id) {
		if (is_array($this->_aServ_Pend) AND sizeof($this->_aServ_Pend))
			$this->_updateArticleContracts();
		return parent::getArticleContracts($id);
	}

	function add_detail($id_art,$cantidad = NULL,$bBultos = 0,$bCheck_dtos = TRUE,$force_idx = NULL,$force_id_detalle = 0) {
		if (is_array($this->_aServ_Pend) AND !in_array($id_art,$this->_aServ_Pend)) 
			array_push($this->_aServ_Pend,$id_art);
		return parent::add_detail($id_art,$cantidad,$bBultos,$bCheck_dtos,$force_idx,$force_id_detalle);
	}

	/**
	  * Metodo encargado de establecer el pedido como pedido tipo para este cliente.
	  * @param $bDo	-	NULL, TRUE, FALSE
	  * @return bool	-	Caso de que se le mande NULL como parametro, devuelve si el pedido es tipo/standard o no.
	  *			-1		-	Caso de Error.
	  **/
	function standard($bDo = NULL) {
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return -1;
		}
		if (!isset($bDo) OR $bDo == NULL) return $this->_fPedido & inmPed_STANDARD;
		else {
			if ($bDo) $this->_fPedido |= inmPed_STANDARD; else $this->_fPedido |= ~inmPed_STANDARD;
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		}
	}

	/**
	  * Metodo para Generar un nuevo Pedido (con su referencia) a partir de un pedido ya existente.
	  **/
	function duplicate() {
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error('DOCUMENT_LOCKED');
			return -1;
		}
		$this->set_reference(0);
		$this->setDate(0);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_NEWRECORD);
	}

	/**
	  * Metodo encargado de convertir un presupuesto en pedido.
	  **/
	function convert_to_order() {
			  /** **
        if(isset($id_presupuesto)){
                $row33[0] = $id_presupuesto;
                $consulta = "update Lineas_detalle set id_presupuesto=0 where id_presupuesto = $id_presupuesto";
                $Sesion->query($consulta);
        }
		  /** **/
	}

	/**
	  * Fixme: Eliminar este metodo (no se usa)
	  * Parche para volcar un pedido a factura sin hacer ningun calculo. Usar junto con dbfill()
	  **/

	function dbfill($id_pedido) {
		if (!is_object($this->_db)) return 0;
		if (!(int)$id_pedido) return 0;
		$oDb = $this->_db;

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_sale_headders($id_pedido)) {
				$this->error('ORDER_NOHEADERS');
				return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchase_headders($id_pedido)) {
				$this->error('ORDER_NOHEADERS');
				return FALSE;
			}
		}

		// paborrar_: $leyenda_divisa = $this->_aDivisa['leyenda'];
		// paborrar_: $campo_accion = $this->_aTarifa['campo_accion'];
		$id_pedido = $this->_aPedido['id_pedido'];
		$id_empresa = $this->_aPedido['id_empresa'];

		// WhatFor? (para los agentes del cliente y el modo stricto o para las dirsEntrega) 
		$this->set_reciever($this->get_reciever_id());
		if ($this->_fPedido & inmPed_VENTA) {
			if ((int)$this->_aPedido['id_direccion']) {
				$id_direccion = $this->_aPedido['id_direccion'];
				$this->_aReceptor['id_direccion'] = $id_direccion;
				$this->_aPedido['id_direccion'] = $id_direccion;
				$this->_aPedido['id_almacen'] = NULL;
			}
		} else {
			if ((int)$this->_aPedido['id_almacen']) {
				$id_direccion = $this->_aPedido['id_almacen'];
				$this->_aReceptor['id_direccion'] = $id_direccion;
				$this->_aPedido['id_almacen'] = $id_direccion;
				$this->_aPedido['id_direccion'] = NULL;
			}
		}

		$this->set_agent($this->_aPedido['id_agente'],TRUE);

		// Comprobamos la existencia de Albaranes para saber si necesitamos cantidad_residual.
		/** **
		$cons = "SELECT id_albaran,referencia,fecha,fecha_envio,fecha_recepcion,preparado,enviado,confirmacion,devolucion FROM Albaranes WHERE id_pedido = ".$id_pedido;
		$idrs = $oDb->query($cons);
		$hay_albaranes = (int)$oDb->num_rows($idrs);
		if ($hay_albaranes) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) $aAlb[$clave] = $valor;
				$this->_aIDAlbaran[$aTmp['id_albaran']] = $aAlb;
			}
		}
		$oDb->libera($idrs);
		/** **/
		$cons = 'SELECT A.id_albaran,A.referencia,A.preparado,A.enviado,A.confirmacion,A.devolucion,A.fecha,A.fecha_envio,A.fecha_recepcion, '.
					'ADet.id_detalle, IF(ADet.fecha_caducidad,ADet.fecha_caducidad,NULL) as "fecha_caducidad", ADet.lote, '.
					'ADet.cantidad as "cantidad", ADet.cantidad_devuelta as "cantidad_devuelta" '. // ', B.cantidad AS "cantidad_debaja" '.
					'FROM Albaranes `A`, Lineas_detalle , Detalles_albaran `ADet` '.
					// 'LEFT JOIN Bajas_localizacion B ON (ADet.id_detalle=B.id_detalle) '.
					'WHERE Lineas_detalle.id_pedido = '.$id_pedido.' '.
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
						array('id_detalle' => $aTmp['id_detalle'], 'cantidad' => $aTmp['cantidad'], 'cantidad_devuelta' => $aTmp['cantidad_devuelta'], 
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

		// Comprobamos la existencia de Facturas 
		$cons = "SELECT F.id_factura,F.referencia,F.estado FROM Facturas `F`, Pedidos_facturas `P` ".
					"WHERE F.id_factura=P.id_factura AND P.id_pedido = ".$id_pedido;
		$idrs = $oDb->query($cons);
		$hay_facturas = (int)$oDb->num_rows($idrs);
		if ($hay_facturas) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) $aFac[$clave] = $valor;
				$aFac['_dbfetch'] = 1;
				$this->_aIDFactura[$aTmp['id_factura']] = $aFac;
			}
		}
		$oDb->libera($idrs);

		// Pasar esto a un metodo dbrecover_detail() ?
		// Localizamos y Rellenamos el detalle de los pedidos.

		// Fixme: pasar esto a un dbrecover_taxes() ?
		// Rellenamos la tabla de IVAs.
		$cons = "SELECT I.id_iva as 'id_iva', ".
				  "I.id_factura as 'id_factura', ".
				  "ROUND(I.monto,".$this->tot_decimals.") as 'base_imponible', ".
				  "I.bruto as 'bruto', ".
				  "ROUND(I.recargo_iva,".$this->tot_decimals.") as 'total_iva', ".
				  "ROUND(I.recargo_equivalente,".$this->tot_decimals.") as 'total_recargo', ".
				  "TI.porcentaje as 'porciento', ".
				  "TI.recargo_equivalente as 'recargo_eq' ".
				  "FROM IVAs `I`, Tipos_IVA `TI` ".
				  "WHERE I.id_pedido = $id_pedido AND I.id_iva = TI.id_iva order by id_iva desc";
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
			debug("IVas rellenos... :");
			print_r($this->_aIVAs);
			debug("...");
		}

		// Fixme: pasar esto a un dbrecover_discounts() ?
		// Rellenamos la tabla de Descuentos.
		$cons = "SELECT id_descuento as 'id_descuento', ".
				  "id_factura as 'id_factura', ".
				  "orden as 'orden', ".
				  "ROUND(monto_base,".$this->tot_decimals.") as 'base_imponible', ".
				  "porcentaje as 'descuento', ".
				  "nombre as 'nombre', ".
				  "financiero as 'financiero', ".
				  "ROUND(monto_final,".$this->tot_decimals.") as 'importe' ".
				  "FROM Descuentos ".
				  "WHERE id_pedido = $id_pedido ORDER BY orden asc";
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
			$this->_aDescuentos = NULL;
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
		}
		$oDb->libera($rs);
		if ($this->debug) {
			debug("Descuentos rellenos... :");
			print_r($this->_aDescuentos);
			debug("...");
		}

		// Desbloqueamos el pedido para que pueda ser usado.
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);
		// $this->_aFlags[pedido] &= ~inmPed_LOCKED;
		// $this->_aFlags[total_bases] |= inmPed_MODIFIED;

		// Comprobamos Si es un pedido Tipo o No:
		if ($this->_fPedido & inmPed_VENTA) $idt = $this->get_reciever_id();
		else $idt = $this->get_issuer_id();

		if ($idt AND is_numeric($idt)) {
			$cons = "SELECT nombre FROM ".
						( ($this->_fPedido & inmPed_VENTA) 
						  ?  "Pedidos_tipo_cliente "
						  :  "Pedidos_tipo_proveedor ").
						" WHERE id_pedido = ".$this->get_id()." AND ".
						( ($this->_fPedido & inmPed_VENTA)
						  ?  "id_cliente = "
						  :  "id_proveedor = ").
						"$idt AND id_empresa = ".$id_empresa;
			$pt_rs = $this->_db->query($cons);
			if ($this->_db->num_rows($pt_rs)) {
				$this->_fPedido |= inmPed_STANDARD;
				$aPedst = $this->_db->fetch_row($pt_rs);
				if (!empty($aPedst[0])) $this->set_name($aPedst[0]);
			}
		}

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_saleorder_details($id_pedido)) {
				$this->error('ORDER_NODETAILS');
				// return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchaseorder_details($id_pedido)) {
				$this->error('ORDER_NODETAILS');
				return FALSE;
			}
		}
		$this->_build_indexes();

		//Fixme: Calculamos los totales del pedido.
		if ($recalcular_iva) $this->_build_taxes();
		if ($recalcular_dtos) $this->_calculate_discounts();
		$this->_calculate_totals(FALSE);

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
	function dbdump() {
		if ($this->debug) debug("probando el dump...");
		if (!(int)$this->_aReciever['id_direccion']) {
			if ($this->debug) debug("Direccion de entrega no Establecida, Intentando asignar una...");
			$aDir = $this->get_reciever_address();
			if (is_array($aDir)) {
				$aDir = array_shift($aDir);
				if ((int)$aDir['id_direccion']) {
					$this->_aPedido['id_direccion'] = $aDir['id_direccion'];
				} else {
					debug("TODO: Falta el codigo para dar de alta direcciones de entrega cuando no existen");
				}
			} else {
				if ($this->debug) debug("Imposible asignar direccion de entrega");
				$this->error('ORDER_NODELIVERYADDRESS',array('ref' => $this->get_reference()));
				return false;
			}
		}
		if ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("pedido tocado...");
			if ($this->_aFlags['pedido'] & inmPed_DB_DELETE) {
				if ($this->debug) debug("BORRANDO (marcando flags)...");
					
				// No se pueden borrar pedidos con albaranes (Al menos hasta que no tengamos objeto)
				// if (is_array($this->_aIDAlbaran) AND sizeof($this->_aIDAlbaran)) return FALSE;

				$this->_aFlags['calculos_iva'] |= inmPed_DB_DELETE;
				$this->_aFlags['calculos_iva'] |= inmPed_DB_COMMIT;
				$this->_aFlags['descuentos'] |= inmPed_DB_DELETE;
				$this->_aFlags['descuentos'] |= inmPed_DB_COMMIT;
				$this->_aFlags['detalles'] |= inmPed_DB_DELETE;
				$this->_aFlags['detalles'] |= inmPed_DB_COMMIT;
				if (is_array($this->_aDetalles))
					foreach ($this->_aDetalles as $idx => $aNull)
						$this->del_detail($idx,FALSE);
				$this->_db->tb_delete("Pedidos",array("id_pedido" => $this->_aPedido['id_pedido']));
				$this->_db->tb_delete("Pedidos_facturas",array("id_pedido" => $this->_aPedido['id_pedido']));
				$this->_db->tb_update("Pedidos",array('id_pedido_incompleto' => 'null'),array("id_pedido_incompleto" => $this->_aPedido['id_pedido']));
				if ($this->getMode() & inmPed_VENTA)
					$this->_db->tb_delete("Pedidos_tipo_cliente",array("id_pedido" => $this->_aPedido['id_pedido']));
				else 
					$this->_db->tb_delete("Pedidos_tipo_proveedor",array("id_pedido" => $this->_aPedido['id_pedido']));

				if ($this->debug) 
					debug("Molaria resetear el contador caso de ser el ultimo pedido realizado (".(int)$this->_aPedido['referencia'].")");

				// En el modo estricto, el borrado tambien lo es. No hay pedido, tampoco fact ni albaran.
				if ($this->_fPedido & inmPed_STRICT) {
					/**  Esto molaria hacerlo por instancia, en vez de a pelo **
					// Borrar las facturas que no esten Emitidas.
					if (is_array($this->_aIDFactura))
						foreach ($this->_aIDFactura as $aFac)
							if ((int)$aFac['estado'] != 1) {
								if (!is_array($aFac_list)) $aFac_list = array();
								array_push($aFac_list,array("id_factura" => $aFac['id_factura']));
							}
					if (is_array($aFac_list)) {
						$this->_db->tb_delete("Pedidos_facturas",$aFac_list);
						$this->_db->tb_delete("Descuentos",$aFac_list);
						$this->_db->tb_delete("IVAs",$aFac_list);
					}
					/** **/

					/** **
					// Borrar los albaranes que no esten confirmados. (Cuando tengamos instancia: ahora joderia el stock real)
					if (is_array($this->_aIDAlbaran))
						foreach ($this->_aIDAlbaran as $aAlb)
							if ((int)$aAlb['confirmacion'] != 1) {
								if (!is_array($aAlb_list)) $aAlb_list = array();
								array_push($aAlb_list,array("id_albaran" => $aAlb['id_albaran']));
							}
					if (is_array($aAlb_list)) {
						$this->_db->tb_delete("Albaranes",$aAlb_list);
						$this->_db->tb_delete("Detalles_albaran",$aAlb_list);
					}
					/** **/

				}
			} elseif ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
				if ($this->debug) debug("Buscando numeracion para la referencia y la fecha...");
				$ref = $this->get_reference();
				if (empty($ref)) $this->set_reference();
				$date = $this->get_date();
				if (empty($date)) $this->setDate();
				if ($this->_aFlags['pedido'] & inmPed_DB_NEWRECORD)
					$this->_aPedido['id_pedido'] = NULL;
				if ($this->_fPedido & inmPed_VENTA) 
					if (!is_numeric($this->_aPedido['id_direccion']) OR empty($this->_aPedido['id_direccion'])) {
						$this->error('ORDER_NODELIVERYADDRESS',array('ref' => $this->get_reference()));
						return false;
					} else {
						$this->_aPedido['id_proveedor'] = NULL;
					}
				else 
					if (!is_numeric($this->_aPedido['id_proveedor']) OR empty($this->_aPedido['id_proveedor'])) {
						$this->error('DOCUMENT_NOISSUER',array('ref' => $this->get_reference()));
						return false;
					} else {
						$this->_aPedido['id_direccion'] = NULL;
					}
				// TODO: Comprobar que el ratio es el que tiene que ser (junto con el dbfill)
				$this->_aPedido['ratio_divisa'] = $this->_aDivisa['ratio'];

				if ((int)$this->_aPedido['id_pedido']) {
					if ($this->debug) debug("Updateamos el pedido...");
					$this->_db->tb_update("Pedidos",$this->_aPedido);
				} else {
					if ($this->debug) debug("Insertando un nuevo pedido en la db...");
					$this->_db->tb_replace("Pedidos",$this->_aPedido);
					$this->_aPedido['id_pedido'] = $this->_db->last_insert_id();
				}
				      
				// Volcamos la relacion que haya con las facturas.
				if (is_array($this->_aIDFactura) AND sizeof($this->_aIDFactura))
					foreach ($this->_aIDFactura as $aFra) {
						if (is_array($aFra) AND is_numeric($aFra['id_factura'])) {
							$aTmp = array();
							$aTmp['id_pedido'] = $this->getId();
							$aTmp['id_factura'] = $aFra['id_factura'];
							// Sobra si actualizamos mas abajo a partir de _aIDPedido: 
							$this->_db->tb_replace('Pedidos_facturas',$aTmp);
							$aFra['_dbfetch'] = 1;
							$this->_aIDFactura[$aFra['id_factura']] = $aFra;
						}  
					}     
			}
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);

			if( $this->_fPedido & inmPed_STANDARD ){
				$aTmp['id_pedido'] = $this->get_id();
				$aTmp['nombre'] = $this->get_name();
				if (empty($aTmp['nombre'])) $aTmp['nombre'] = "Pedido Tipo Sin Nombre";
				if ($this->getMode() & inmPed_VENTA) {
					$aTmp['id_cliente'] = $this->get_reciever_id();
					$aTmp['id_empresa'] = $this->get_issuer_id();
					$this->_db->tb_replace("Pedidos_tipo_cliente",$aTmp);
				} else {
					$aTmp['id_proveedor'] = $this->get_issuer_id();
					$aTmp['id_empresa'] = $this->get_reciever_id();
					$this->_db->tb_replace("Pedidos_tipo_proveedor",$aTmp);
				}
			}
		} elseif ($this->debug) debug("La cabecera del pedido no se ha tocado...");

		if ( ($this->_aFlags['calculos_iva'] & inmPed_DB_COMMIT) ) {
			if ($this->debug) debug("Volcamos los ivas...");
			if ($this->_aFlags['calculos_iva'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_pedido']) {
				$cons = 'DELETE FROM IVAs WHERE '.
						'(!id_factura OR id_factura IS NULL OR id_factura=0) AND '.
						'(!id_presupuesto OR id_presupuesto IS NULL OR id_presupuesto=0) AND '.
						' id_pedido = '.$this->_aPedido['id_pedido'];
				$this->_db->query($cons);
			} elseif ((int)$this->_aPedido['id_pedido']) {
				$this->_build_taxes();
				if (is_array($this->_aIVAs['detalle']))
					foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva) {
						$aIva['id_iva'] = $id_iva;
						$aIva['id_pedido'] = $this->_aPedido['id_pedido'];
						// $aIva[id_factura] = $this->_aPedido[id_factura];
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
						if (!isset($aIva_del['id_pedido'])) 
							if (empty($this->_aPedido['id_pedido'])) continue;
							else $aIva_del['id_pedido'] = $this->_aPedido['id_pedido'];

						if (empty($aIva_del['id_factura'])) {
							unset($aIva_del['id_factura']);
							$this->_db->tb_delete("IVAs",$aIva_del);
						} else {
							$aTmp['id_pedido'] = 0;
							$aTmp['id_iva'] = $aIva_del['id_iva'];
							$aTmp['id_factura'] = $aIva_del['id_factura'];
							$aFld[] = "id_factura";
							$aFld[] = "id_iva";
							$this->_db->tb_update("IVAs",$aTmp,$aFld);
						}
					}
			} else $this->error('ORDER_NODBRECORD');
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK);
		} else if ($this->debug) debug("Los IVAs no se han tocado...");

		if ($this->debug) debug("<b>INICIAMOS LOS DESCUENTOS</b>");
		if ($this->_aFlags['descuentos'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("Volcamos los descuentos...");
			if ($this->_aFlags['descuentos'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_pedido']) {
				$cons = "DELETE FROM Descuentos WHERE (!id_factura OR id_factura IS NULL OR id_factura=0) AND ".
							" id_pedido = ".$this->_aPedido['id_pedido'];
				if ($this->debug) debug("query : $cons");
				$this->_db->query($cons);
			} elseif ((int)$this->_aPedido['id_pedido']) {
				if (!is_array($this->_aDescuentos['detalle'])) $this->calculate();
				if (is_array($this->_aDescuentos['detalle']))
					foreach($this->_aDescuentos['detalle'] as $aDto) {
						$aDto['id_pedido'] = $this->_aPedido['id_pedido'];
						$aDto['id_factura'] = $this->_aPedido['id_factura'];
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
			} else $this->error('ORDER_NODBRECORD');
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK);
		} else if ($this->debug) debug("Los DESCUENTOS NO se han tocado...");

		if ($this->_aFlags['detalles'] & inmPed_DB_COMMIT) {
			$aBorrarDet = array();
			if ($this->_fPedido & inmPed_VENTA) $op_sign = '+';
			else $op_sign = '-';
			foreach($this->_aModif['detalles'] as $idx_det => $estado) {
				// Fixme: Actualizar los socks cuando se borra o modifican cantidades.
				if ($estado & inmPed_DB_DELETE) {
					if ($this->debug) debug("Habria que borrar este detalle($idx_det)... si");
					// Meter este id_detalle dentro de un array de id_detalles a borrar.
					array_push($aBorrarDet,$idx_det);
					if (is_numeric($this->_aDet_dbdel[$idx_det]['id_detalle']) AND !empty($this->_aDet_dbdel[$idx_det]['id_detalle'])) {
						/** Actualmente no permitimos borrar un detalle que pertenece a un albaran,ticket o factura.
						  Si quisiesemos des-asociar el detalle del pedido (aun asi con to-do) descomentar esto:
						$this->_db->tb_update('Lineas_detalle',
								array('id_pedido' => 0, 'id_detalle' => $this->_aDet_dbdel[$idx_det]['id_detalle']));
						/** **/
					}
				} elseif ($estado & inmPed_DB_COMMIT) {
					if ($this->debug) debug("Detalle $idx_det no actualizado");
					$aTmp = $this->get_detail($idx_det);
					$this->_aDetalles[$idx_det]['id_pedido'] = $aTmp['id_pedido'] = $this->_aPedido['id_pedido'];
					// $aTmp['cantidad'] = $aTmp['cantidad_pedida'];
					$aTmp['precio_articulo'] = $aTmp['precio_tarifa'];
					$aTmp['monto_total'] = $aTmp['base_imponible'];
					$aDto = $this->get_detail_discount($idx_det);
					if (!sizeof($aDto)) {
						$aTmp['monto'] = 0;
						$aTmp['descuento'] = 0;
					} else {
						$aTmp['monto'] = $aDto['monto'];
						$aTmp['descuento'] = $aDto['porciento'];
					}
					if ($this->debug) debug("Linea de detalle");
					if ($this->debug) print_r($aTmp);

					if (!(int)$aTmp['id_detalle']) {
						if ($this->debug) debug("Detalle $idx_det No esta en la DB. Actualizando indices...");
						$this->_db->tb_replace("Lineas_detalle",$aTmp);
						$this->_aDetalles[$idx_det]['id_detalle'] = (int)$this->_db->last_insert_id();
						$this->_aDetIdx[$this->_aDetalles[$idx_det]['id_detalle']] = $idx_det;
					} else {
						$this->_db->tb_update("Lineas_detalle",$aTmp);
					}
					// Actualizamos la cantidad que hay ahora mismo en la DB.
					if (is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_db']))
						$cant_org = $this->_aDet_dbdel[$idx_det]['cantidad_db'];
					else $cant_org = 0;
					if (is_numeric($aTmp['cantidad']))
						$cant_act = $aTmp['cantidad'];
					else $cant_act = 0;
					if ($cant_org != $cant_act) {
						$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
									"WHERE id_articulo = ".$aTmp['id_articulo']." AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
						$this->_db->query($cons);
					}
					$this->_aDet_dbdel[$idx_det]['cantidad_db'] = $cant_act;
					if ($this->debug) debug("Actualizando stock: $cons");
				} else if ($this->debug) debug("Nada que hacer para este detalle($idx_det)...");
			}
			// Borramos los que haya que borrar
			if (is_array($this->_aIDAlabaran)) {
				$aDetAlb = array();
				// Comprobamos los detalles de nuestro Albaran.
				$cons = "SELECT DISTINCT Li.id_detalle as 'id_detalle' ".
							"FROM Lineas_detalle `Li`, Detalles_albaran `DA`, Albaranes `Alb` ".
							"WHERE DA.id_detalle = Li.id_detalle AND DA.id_albaran = Alb.id_albaran AND Alb.id_pedido = ".$this->get_id();
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

			if (is_array($this->_aIDFactura)) {
				$aDetFac = array();
				// Comprobamos los detalles de nuestra Factura.
				$cons = "SELECT DISTINCT Li.id_detalle as 'id_detalle' ".
							"FROM Lineas_detalle `Li`, Facturas_detalle `DF`, Facturas `Fac`, Pedidos_facturas `PF` ".
							"WHERE DF.id_detalle = Li.id_detalle AND DF.id_factura = Fac.id_factura AND ".
							"Fac.id_factura = PF.id_factura AND PF.id_pedido = ".$this->get_id();
				$idrs = $this->_db->query($cons);
				if ($this->_db->num_rows($idrs)) 
					while ($aTmp = $this->_db->fetch_assoc($idrs)) {
						foreach ($this->_aDet_dbdel as $i => $aVal) 
							if ($aVal['id_detalle'] == $aTmp['id_detalle']) {
								$idx = $i;
								break;
							}
						if (isset($idx)) {
							array_push($aDetFac,$idx);
							$idx = NULL;
						}
					}
				$this->_db->libera($idrs);
			}

			//Fixme: Faltan comprobar tambien que el detalle no pertenezca a ningun tickests.

			if (sizeof($aDetAlb)) $aToDelete = array_diff($aBorrarDet,$aDetAlb);
			else $aToDelete = $aBorrarDet;
			if (sizeof($aDetFac)) $aToDelete = array_diff($aToDelete,$aDetFac);

			foreach ($aToDelete as $i => $id) {
				if ((int)$this->_aDet_dbdel[$id]['id_detalle']) {
					if (!is_array($aDelete_Det)) $aDelete_Det = array();
					// Actualizamos Stock y metemos el id_detalle en el array para tb_delete()
					if (is_numeric($this->_aDet_dbdel[$id]['cantidad_db']))
						$cant_org = $this->_aDet_dbdel[$id]['cantidad_db'];
					else $cant_org = 0;
					// Si borramos la linea de detalle no hay nada que 'recuperar' del stock
					$cant_act = 0;
					$id_art = (int)$this->_aDet_dbdel[$id]['id_articulo'];
					$id_det = (int)$this->_aDet_dbdel[$id]['id_detalle'];
					if ($cant_org != $cant_act) {
						$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org) ".
									"WHERE id_articulo = $id_art AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
						$this->_db->query($cons);
					}
					array_push($aDelete_Det,array('id_detalle' => $id_det));
					if ($this->debug) debug("Detalle borrado($id_det), Actualizando stock...");
				} else if ($this->debug) debug("solicitud de borrado de un detalle($id) sin id_detalle...");
			}
			if (is_array($aDelete_Det)) $this->_db->tb_delete("Lineas_detalle",$aDelete_Det);
			$this->_change_flags(inmPed_CHG_DETAIL | inmPed_OK);
		} else if ($this->debug) debug("Los DETALLES NO se han tocado");

		return true;

	} // Fin del dbdump()

	/** Fin de los metodos de funcionalidades **/

} /**************** FIN DE LA CLASE ******************/

}

