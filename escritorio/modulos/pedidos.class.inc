<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.		        				 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y 		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre 	 **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.       														 **
**																					 **
** Para mas informacion referente a la licencia de esta 			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On 	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**							        												 **
** Informacion de Contacto				        							 **
**    Josafat Moragrega Fernandez			        					 **
**    Engineering					        									 **
**    Director Tecnico 					        							 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España		        		 **
**																					 **
** 				(c) Web On Line Studios S.L. 							 **
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
/** Defines: **/


// Cambios de estado de las lineas de Detalle -Mascaras de modificaciones-
define(inmPed_CHG_DET_QUANTITY,	bindec("0001"));
define(inmPed_CHG_DET_PRICE,		bindec("0010"));
define(inmPed_CHG_DET_DISCOUNT,	bindec("0100"));
// Cambios de estado -Mascaras de modificaciones-
define(inmPed_CHG_DETAIL,			bindec("000000000100"));
define(inmPed_DB_NEWRECORD,		bindec("000000001000"));
define(inmPed_DB_COMMIT,			bindec("000000010000"));
define(inmPed_DB_DELETE,			bindec("000000100000"));
define(inmPed_MODIFIED,				bindec("000001000000"));
define(inmPed_LOCKED,				bindec("000010000000"));
define(inmPed_OK,						bindec("000100000000"));
// Para las banderas:
define(inmPed_CHG_MAIN,				bindec("001000000000"));
define(inmPed_CHG_DISCOUNTS,		bindec("010000000000"));
define(inmPed_CHG_TAXES,			bindec("100000000000"));
// Para las opciones generales del pedido
define(inmPed_COMPRA,				bindec("00000000"));  
define(inmPed_VENTA,					bindec("00000001"));  
define(inmPed_PRESUPUESTO,			bindec("00000010"));  // Si es pedido o presupuesto
define(inmPed_STRICT,				bindec("00000100"));  // Si se ha de ser estricto en las comprobaciones de agente-cliente
define(inmPed_STANDARD,				bindec("00001000"));  // Si 

class inmPedido 
{
	// Variables Publicas de la clase
	var $App_Name = ""; // Nombre de aplicacion y por tanto de instancia global de sesion.
	var $op_decimals = 2; 		// Numero de decimales con los que se realizan las operaciones de calculo.
	var $tot_decimals = 3; 		// Numero de decimales con los que se obtendra el total resultante de los calculos.

	// Variables Privadas a la clase
	var $_fPedido; 				// int: Opciones Generales del pedido (ver mascaras)

	var $_aDirecciones_receptor;// Las posibles Direcciones de entrega del receptor de este pedido
	var $_aAgentes_cliente;		// Los posibles Agentes del receptor de este pedido
	var $_aClientes_agente;		// Los posibles Receptores del Agente de este pedido
	var $_aPedido;					// Datos propios del pedido
	var $_aReceptor;				// Datos del cliente o empresa receptora del pedido.
	var $_aEmisor;					// Datos de la empresa o proveedor emisor del pedido.
	var $_aAgente;					// Agente que realiza el Pedido 
	var $_aTarifa;					// Tarifa a aplicar al pedido (solo ventas)
	var $_aDivisa;					// Datos de la divisa del pedido

	var $_aIDAlbaran;				// Array indexado por ids con los albaranes del pedido.
	var $_aIDFactura;				// Array indexado por ids con las facturas del pedido.

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
	var $_aDet_dbdel = array(	 // Lista de id_detalle s en espera de ser borrados de la db.
			array( 
				"id_detalle" => 0, 		// id_detalle de la db a borrar.
				"cantidad_total"=> 0,	// Cantidad que tenia el detalle (para actualizar stock)
				"cantidad_recibida"=> 0	// Cantidad recibida por el cliente del detalle (para actualizar stock)
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
				  "descuento" 		=> 0,// Descuento aplicado.
				  "nombre" 			=> "",// Nombre del tipo de descuento (Comercial/Financiero...)
				  "importe" 		=> 0,// importe del descuento.
					  ))
						 );

	var $_aIVAs = array(
			"total_iva"				=> 0,// Total de impuestos a pagar.
			"total_recargo"		=> 0,// Total de recargo sobre impuestos a pagar.
			"detalle"=> array(
				"id_iva" => array(
				  "base_imponible"=> 0,// Base imponible sobre la que se aplica el iva.
				  "porciento" 		=> 0,// Porcentaje de iva.
				  "recargo_eq" 	=> 0,// Porcentaje del recargo de equivalencia.
				  "total_iva"	 	=> 0,// Monto de impuesto para este tipo de iva
				  "total_recargo"	=> 0,// Monto de recargo para este tipo de iva
					  )
				)
						 );

	var $_aOff_Promo = array(array()); // Ofertas y promos indexadas por id_articulo.
	var $_aServicios = array(array()); // Servicios disponibles para cara articulo. (Fixme: not implemented)

	// Indices a punteros de detalle y Flags de estado:
	var $_aDetIdx			= array();	// Indice conversor de id_detalle a idx_detalle
	var $_aDetIdx_Art	= array(array());	// Indice conversor de id_articulo a un array de idx_detalles
	var $_DetIdx_act = 0;				// Indice de detalle actualmente en curso (modificandose).
	var $_bModificado;			// Indica si se han de recalcular los ivas, dtos y totales.
	var $_aFlags = array (
			 "total_bases" 	=> 0,		// Si el total de bases imponibles esta ok.
			 "calculos_iva" 	=> 0,		// Estado de los calculos de impuestos.
			 "descuentos" 		=> 0,		// Estado de los descuentos.
			 "pedido" 			=> inmPed_LOCKED,		// Estado del estado principal del pedido.
			 "detalles" 		=> 0,		// Estado de los detalles.
						 );					// Banderas de estado de pedido.

	var $_err_msg = array();			// Mensajes de error producidos.
	var $_err_no  = array();			// Codigos de error producidos.
	var $_eno_last= 0;					// Ultimo codigo de error producido.
	var $_emg_last= "";					// Ultimo mensaje de error producido.
	// Instancias Dependientes:
	var $_db = ""; //  = wolDB::init(); // Base de datos conectada a los datos de gestion donde estan los pedidos.
	var $_db_name=""; 					// Nombre de la conexion a la base de datos dentro de la aplicacion actual.
	var $_sess_var = "oPedido_en_curso"; // Nombre de la variable de sesion que contiene la instancia actual

	/** Constructor:
		* @param $tipo 		-	Indica si el pedido es de compra o de venta (ver defines).
		* @param $doc_type	-	Indica si es un pedido o un presupuesto.(bool)
	 **/
	function inmPedido($App_Name = NULL,$db_name,$tipo = inmPed_VENTA,$doc_type = 0)  
	{
		$this->debug = 1;

		if (!$App_Name) $this->App_Name = "Sesion";
		else $this->App_Name = "Sesion"; // $App_Name;
		$this->debug = 0; 
		if ($this->debug) debug("Constructor de inmPedido ... ".$this->App_Name);

		$this->set_db($db_name);

debug("tipo pedido = $tipo");		
		$tmp = $this->set_tipo_pedido($tipo);

		// Fixme: El modo stricto deberia ser una opcion
		// $this->_fPedido |= ~inmPed_STRICT;

		// Comprobamos el tipo de documento
		if ((int)$doc_type<3) $this->_bPedido = (int)$doc_type;
		else $this->_bPedido = TRUE;
		
		// Resetamos valores.
		$this->_aDetalles = $this->_aIVAs[detalle] = $this->_aDescuentos = $this->_aTotales = NULL;
		$this->_aIva_dbdel = array();
		$this->_aPedido[preparado] = 0;

		$this->set_session_var();
		$this->op_decimals = 2;
		$this->tot_decimals = 2;

		return $tmp;
	}

	/** Metodos de mantenimiento **/
	function init() 
	{
		// debug("init.... (".$this->App_Name.")");
		// print_r($this);
		$this->set_db($this->_db_name);
	}

	function cerrar() 
	{
		if ($this->debug) debug("cerramos Chiringo... ".$this->App_Name);
		$this->_db = NULL;
		// unset($this->_db);
	}

	/**
	  * Metodo encargado de actualizar las banderas caso de producirse un cambio en el pedido.
	  * @param $tipo	-	Tipo de cambio realizado. (ver defines).
	  * @return NULL
	  **/
	function _change_flags($tipo = 0) 
	{
		if (!$tipo) return;
		if ( ($tipo & inmPed_CHG_DETAIL) ) {
				// $this->_aFlags[];
			// if ($this->debug) debug("change_flags($tipo) en Detalles");
			// Fixme: Arreglar esto, que los detalles puedan tener los flags de ok y demas, no tos a bloke
			if ( ($tipo & inmPed_OK) ) {
				if ($this->debug) debug("Como que Detalles OK??");
			}
			$base = FALSE;
			// Fixme: Testear esta linea; if ( ($idx_det = $this->current_detail()) ) {
			foreach ($this->_aModif[detalles] as $idx_det => $mask) {
				// debug("mascara para el detalle $idx_det = $mask");
				if ( ($mask & inmPed_CHG_DET_QUANTITY) ) {
					// if ($this->debug) debug("Cantidades de $idx_det..");
					$base = TRUE;
					$this->_aModif[detalles][$idx_det] &= ~inmPed_CHG_DET_QUANTITY;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
				}
				if ( ($mask & inmPed_CHG_DET_PRICE) ) {
					// if ($this->debug) debug("precio de $idx_det..");
					$base = TRUE;
					$this->_aModif[detalles][$idx_det] &= ~inmPed_CHG_DET_PRICE;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
				}
				if ( ($mask & inmPed_CHG_DET_DISCOUNT) ) {
					// if ($this->debug) debug("descuentos de $idx_det..");
					$base = TRUE;
					$this->_aModif[detalles][$idx_det] &= ~inmPed_CHG_DET_DISCOUNT;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
				}
				if ( ($mask & inmPed_MODIFIED) ) {
					// if ($this->debug) debug("Modificado, sin mas ($idx_det)");
					$this->_aModif[detalles][$idx_det] &= ~inmPed_MODIFIED;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
					$this->_aFlags[detalles] |= (inmPed_DB_COMMIT);
				}
				if ( ($mask & inmPed_NEWRECORD) ) {
					$this->_aModif[detalles][$idx_det] &= ~inmPed_MODIFIED;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
					$this->_aModif[detalles][$idx_det] |= inmPed_DB_NEWRECORD;
					$this->_aFlags[detalles] |= (inmPed_DB_COMMIT);
				}
				if ($base) $this->_calcular_baseimponible($idx_det);
			}
			if ( ($tipo & inmPed_MODIFIED) ) {
				$tipo = 0;
				$tipo |= inmPed_CHG_DISCOUNTS;
				$tipo |= inmPed_CHG_TAXES;
				$tipo |= inmPed_CHG_MAIN;
				$tipo |= inmPed_MODIFIED;
				$this->_aFlags[detalles] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
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
				$this->_aFlags[total_bases] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$tipo |= inmPed_CHG_DISCOUNTS | inmPed_CHG_TAXES | inmPed_MODIFIED;
			} elseif ($tipo & inmPed_OK) {
				$this->_aFlags[pedido] &= ~inmPed_LOCKED; 
				$this->_aFlags[pedido] &= ~inmPed_DB_COMMIT; 
				$this->_aFlags[pedido] &= ~inmPed_DB_DELETE; 
				$this->_aFlags[pedido] &= ~inmPed_MODIFIED; 
			} 
			if ($tipo & inmPed_LOCKED) {
				$this->_aFlags[pedido] |= inmPed_LOCKED;
			}
			if ($tipo & inmPed_DB_COMMIT) {
				$this->_aFlags[pedido] |= inmPed_DB_COMMIT;
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags[pedido] |= inmPed_DB_COMMIT;
				$this->_aFlags[pedido] |= inmPed_DB_NEWRECORD;
			}
		}

		if ( ($tipo & inmPed_CHG_DISCOUNTS)) {
			if ($tipo & inmPed_MODIFIED) {
				$this->_aFlags[descuentos] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
			} elseif ( ($tipo & inmPed_OK) ) {
				$this->_aFlags[descuentos] |= inmPed_OK; 
				// $this->_aFlags[descuentos] &= ~inmPed_DB_COMMIT; 
				$this->_aFlags[descuentos] &= ~inmPed_DB_DELETE; 
				$this->_aFlags[descuentos] &= ~inmPed_MODIFIED; 
			}
			if ($tipo & inmPed_DB_COMMIT) {
				$this->_aFlags[descuentos] |= inmPed_DB_COMMIT;
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags[descuentos] |= inmPed_DB_COMMIT;
				$this->_aFlags[descuentos] |= inmPed_DB_NEWRECORD;
			}
		}

		if ( ($tipo & inmPed_CHG_TAXES)) {
			if ($tipo & inmPed_MODIFIED) {
				$this->_aFlags[calculos_iva] |= (inmPed_MODIFIED | inmPed_DB_COMMIT);
				$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
			} 
			if ( ($tipo & inmPed_OK) ) {
				$this->_aFlags[calculos_iva] |= inmPed_OK; 
				$this->_aFlags[calculos_iva] &= ~inmPed_DB_DELETE; 
				$this->_aFlags[calculos_iva] &= ~inmPed_MODIFIED; 
			}
			if ( ($tipo & inmPed_DB_COMMIT)) {
				$this->_aFlags[calculos_iva] |= inmPed_DB_COMMIT; 
			}
			if ($tipo & inmPed_DB_NEWRECORD) {
				$this->_aFlags[calculos_iva] |= inmPed_DB_COMMIT;
				$this->_aFlags[calculos_iva] |= inmPed_DB_NEWRECORD;
			}
		}
	}

	function error($err_code,$msg) 
	{
		global $$this->App_Name;
		array_push($this->_err_msg,$msg);
		array_push($this->_err_no,$err_code);
		echo "Error (inmPedido.class:$err_code) $msg";
		// $$this->App_Name->error($err_code,$msg);
	}

	function err_msg() 
	{
		if (!empty($this->_emg_last)) {
			$retval = $this->_emg_last;
			$this->_emg_last = NULL;
		} else {
			$retval = array_pop($this->_err_msg);
			$this->_eno_last = array_pop($this->_err_no);
		}
		return $retval;
	}

	function err_no() 
	{
		if (!empty($this->_eno_last)) {
			$retval = $this->_eno_last;
			$this->_eno_last = 0;
		} else {
			$retval = array_pop($this->_err_no);
			$this->_emg_last = array_pop($this->_err_msg);
		}
		return $retval;
	}

	function __wakeup() 
	{
		// debug("rocknroll aint noise polution (".$this->_db.") (".$this->App_Name.")");
		// include("modulos/pedidos.class.inc");
		// $this->set_db($this->_db_name);
		// $this->_db=$$this->App_Name->get_db($this->_db_name);
		// debug("shiiiiiiiiiiit".$this->_db);
	}

	function null__sleep() 
	{
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
	function set_issuer($id) 
	{
		if (!(int)$id) return FALSE;

		if ($this->_fPedido & inmPed_VENTA) {
debug("El mu jodio piensa que es de venta...");
			$retval = $this->_set_enterprise_issuer($id);
		} else {
debug("Pedido Compra... estableciendo proveedor emisor = $id");
			$retval = $this->_set_provider_issuer($id);
		}
		if (!$retval) return $retval;
				
		// Si ya tenemos emisor y receptor, establecemos la fecha del pedido al momento actual.
		if ((int)$this->_aReceptor['id']) {
			if ($this->debug) debug("Receptor ya establecido. Desbloqueando pedido...");
			$this->set_date();
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT | inmPed_OK);
		}
		$this->set_status(0);

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
	function get_issuer_id() 
	{
		return $this->_aEmisor['id'];
	}

	/**
	  * Metodo encargado de devolver informacion sobre el emisor del documento.
	  **/
	function get_issuer_info() 
	{
		return $this->_aEmisor;
	}

	/**
	  * Metodo que establece/asigna la empresa(compras) o cliente(compras) receptora del documento pedido actual.
	  * @param 	$id 		-	id(en bbdd) del receptor que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return 	bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function set_reciever($id,$bForce = FALSE) 
	{
		if (!is_numeric($id)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;

		$id_empresa = (int)$this->_aEmisor[id_empresa];
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
			$this->error(505,"No se ha indicado un receptor. Indiquelo primero");
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
	function get_reciever_address($bAll = FALSE) 
	{
		if (!isset($bAll)) $bAll = FALSE;
		if ((int)$this->_aReceptor['id_direccion'] AND !$bAll) 
		  	return array($this->_aDirecciones_receptor[$this->_aReceptor['id_direccion']]);
		else return $this->_aDirecciones_receptor;
	}

	/**
	  * Devuelve la informacion del receptor del pedido.
	  * @return array()	-	Array referencial de los datos del receptor del pedido.
	  **/
	function get_reciever_info() 
	{
		return $this->_aReceptor;
	}

	function get_reciever_id() 
	{
		return $this->_aReceptor['id'];
	}

	function set_revenue($id_tarifa) 
	{
		// Caso de compras, Aprovechamos para convertir los precios a la moneda de la 
		// 	Empresa que lo recibe, dado que los precios de Compra_articulos, estan en la moneda del proveedor.
		if (!is_numeric($id_tarifa)) return FALSE;
		if ((int)$id_tarifa = $this->_aPedido['id_tarifa']) return TRUE;
		$cons = "SELECT ".
				  "Tar.id_tarifa as 'id_tarifa', ".
				  "Tar.nombre as 'nombre', ".
				  "Tar.campo_accion as 'campo_accion', ".
				  "Tar.pto_primero as 'pto_primero', ".
				  "Tar.pto_segundo as 'pto_segundo', ".
				  "Tar.monto as 'tar_monto' ".
				  "FROM Tarifas Tar WHERE id_tarifa = $id_tarifa";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return FALSE;
		$aTar = $this->_db->fetch_assoc($idrs);
		$this->_aTarifa['id_tarifa'] = $aTar['id_tarifa'];
		$this->_aTarifa['nombre'] = $aTar['nombre'];
		$this->_aTarifa['campo_accion'] = $aTar['campo_accion'];
		$this->_aTarifa['pto_primero'] = $aTar['pto_primero'];
		$this->_aTarifa['pto_segundo'] = $aTar['pto_segundo'];
		$this->_aTarifa['monto'] = $aTar['tar_monto'];
		$this->_aPedido['id_tarifa'] = $id_tarifa;
		$this->eval_conditions();
		// Fixme: Anyadir flags de recalculo total del pedido (todos los detalles tb).
	}

	function get_revenue() 
	{
		return $this->_aTarifa;
	}

	/**
	  * Establece cual es el agente creador del pedido.
	  * @param  id_agente	-  Identificador del agente a establecer como realizador del pedido.
	  * @param  bForce		-  Si se ha de ignorar las opcion Strict y asignar el agente por 00
	  * @return bool 			-	Verdadero caso de poder haber sido establecido, falso en caso de fallo
	  **/
	function set_agent($id_agente,$bForce = FALSE) 
	{
		if (!is_numeric($id_agente)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		if ((int)$this->_aPedido['id_cliente'] ) { 
			// Si ya sabemos el cliente, comprobamos que el agente pertenezca al cliente (si es preciso)
			if (is_array($this->_aAgentes_cliente)) {
				if (!is_array($this->_aAgentes_cliente[$id_agente])) {
					if (!$bForce AND $this->_fPedido & inmPed_STRICT) {
						$this->error(502,"El agente indicado no esta dentro de los Agentes del Cliente del pedido");
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
			$this->error(1,"DB connection not instanciated");
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
				$this->error(505,"No se ha podido encontrar el agente No $id_agente");
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
							  "FROM Clientes Cli, Agentes_clientes AC ".
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
	function get_agent() 
	{
		return $this->_aAgente;
	}

	function set_date($fecha = NULL) 
	{
		if (!isset($fecha) AND empty($this->_aPedido[fecha]) OR (empty($fecha) AND is_numeric($fecha)))
			$fecha = date("Y-m-d H:i:s");
		elseif (!empty($this->_aPedido[fecha])) 
			if (!isset($fecha) OR empty($fecha)) return TRUE;

		$this->_aPedido[fecha] = $fecha;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		return TRUE;
	}

	function get_date() 
	{
		return $this->_aPedido[fecha];
	}

	function get_incomplete_order() 
	{
		return $this->aPedido['id_pedido_incompleto'];
	}

	function set_incomplete_order($id) 
	{
		if (!is_numeric($id)) return 0;
		$this->aPedido['id_pedido_incompleto'] = (int)$id;
	}

	/**
	  * Establece ls divisa de pago del pedido.
	  **/
	function set_currency($id_divisa) 
	{
		if (!is_numeric($id_divisa)) return NULL;
		$id_divisa = (int)$id_divisa;
		if ($this->_aDivisa[id_divisa] == $id_divisa) return 1;
		$cons = "SELECT ".
				  "Div.id_divisa as 'id_divisa', ".
				  "Div.leyenda as 'leyenda', ".
				  "Div.ratio as 'ratio' ".
				  // "Div.ratio_compra as 'ratio_compra' ".
				  "FROM Divisa Div WHERE id_divisa = $id_divisa ";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return 0;
		$aDiv = $this->_db->fetch_assoc($idrs);
		$this->_aDivisa = $aDiv;
		$this->_aPedido[id_divisa] = $aDiv[id_divisa];
		if ($this->debug) debug("Campo de divisa, habria que recalcular los totales? para obtener los datos en la nueva divisa?");
		return 1;
	}

	/**
	  * Obtiene la informacion de la divisa que esta siendo usada para el pedido.
	  **/
	function get_currency() 
	{
		return $this->_aDivisa;
	}

	/**
	  * Establece el nombre del pedido actual
	  * @param $nombre - Nombre que se le ha de dar al pedido.
	  * @return bool	-	Si la operacion se ha realizadon con exito o no.
	  **/
	function set_name($nombre) 
	{
		if (empty($nombre)) return FALSE;
		$this->_aPedido[nombre] = $nombre;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		return TRUE;
	}

	/**
	  * Metodo encargado de obtener el nombre del pedido
	  * @return string - nombre del pedido.
	  **/
	function get_name() 
	{
		return $this->_aPedido[nombre];
	}

	/**
	  * Establece los comentarios sobre el pedido.
	  **/
	function set_comments($big_text) 
	{
		if (empty($big_text)) return FALSE;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		if (!empty($big_text)) $this->_aPedido[observaciones] = $big_text;
		return TRUE;
	}

	/**
	  * Obtiene los comentarios para el pedido actual.
	  **/
	function get_comments() 
	{
		return $this->_aPedido[observaciones];
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

	function get_id() 
	{
		return $this->_aPedido[id_pedido];
	}

	/**
	  * Metodo encargado de Establecer la referencia Externa del Documento.
	  */
	function set_ext_reference($ref_externa) 
	{
		if (empty($ref_externa)) return FALSE;
		if (!empty($this->_aPedido[referencia_externa]) 
				AND !strcasecmp($ref_externa,$this->_aPedido[referencia_externa])) return TRUE;
		$this->_aPedido[referencia_externa] = $ref_externa;
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
	}

	/**
	  * Metodo encargado de Retornar la referencia Externa del Documento.
	  */
	function get_ext_reference($ref_externa) 
	{
		return $this->_aPedido[referencia_externa];
	}

	/**
	  * Metodo destinado a permitir al entrada de datos del pedido en un array en vez de usando los metodos.
	  **/
	function set_info($aPedido) 
	{
	}

	function get_info() 
	{
		return $this->_aPedido;
	}

	function set_status($preparado) 
	{
		if (!$preparado) $preparado = 0;
		else $preparado = 1;
		$this->_aPedido[preparado] = $preparado;
		$this->_change_flags(inmPed_MAIN | inmPed_MODIFIED);
	}

	function get_status() 
	{
	}

	/**
	  * Metodo encargado de establecer la forma de pago de este pedido.
	  **/
	function set_payment_method($id_forma_pago) 
	{
		if (!isset($id_forma_pago) OR !is_numeric($id_forma_pago)) return FALSE;
		// if ((int)$id_forma_pago == $this->_oPedido[id_forma_pago]) return TRUE;
		
		$cons = "SELECT ".
				  "FPago.id_forma_pago as 'id_forma_pago', ".
				  "FPago.nombre as 'nombre_forma_pago', ".
				  "FPago.num_efectos as 'num_efectos', ".
				  "FPago.dias_efectos as 'dias_efectos', ".
				  "FPago.medio_pago as 'medio_pago' ".
				  "FROM Forma_pago FPago ".
				  "WHERE FPago.id_forma_pago = $id_forma_pago";
		$idrs = $this->_db->query($cons);
		if (!$this->_db->num_rows($idrs)) return FALSE;
		$aTmp = $this->_db->fetch_assoc($idrs);
		$this->_aPedido[id_forma_pago] = $aTmp[id_forma_pago];
		$this->_aPedido[nombre_forma_pago] = $aTmp[nombre_forma_pago];

		/** Documentar!!!!!! **/
		$this->_aFPago[nombre] = $aTmp[nombre_forma_pago];
		$this->_aFPago[id_forma_pago] = $aTmp[id_forma_pago];
		$this->_aFPago[dias_efectos] = $aTmp[dias_efectos];
		$this->_aFPago[num_efectos] = $aTmp[num_efectos];
		$this->_aFPago[medio_pago] = $aTmp[medio_pago];
		// print_r($this->_aFPago);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);

		return TRUE;
	}

	/**
	  * Metodo que retorna la forma de pago estipulada para este pedido.
	  **/
	function get_payment_method() 
	{
		return $this->_aPedido[id_forma_pago];
	}

	/**
	  * Metodo encargado de devolver los albaranes de un pedido.
	  **/
	function get_deliveries() 
	{
		return $this->_aIDAlbaran;
	}
	/**
	  * Metodo encargado de devolver las Facturas de un Pedido.
	  **/
	function get_invoices() 
	{
		return $this->_aIDFactura;
	}

	/**   -- Metodos de Cabeceras y Pies -- **/
	
	function set_detail_contract($idx_det,$id_servicio) 
	{
		debug("Solicitud de establecimiento de servicio para $idx_det");
	}

	function get_detail_contract($idx_det) 
	{
	}

	/**
	  * Obtiene el id_articulo de la linea de detalle indicada.
	  **/
	function get_detail_article_id($idx_det = NULL) 
	{
		if (!isset($idx_det)) $idx_det = $this->_DetIdx_act;
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		return $this->_aDetalles[$idx_det]['id_articulo'];
	}

	/**
	  * Metodo encargado de obtener el identificador idx_detalle a partir de un id_detalle de la db
	  **/
	function get_idxdetail_db($id_det) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		return $this->_aDetIdx[$id_det];
	}

	/**
	  * Metodo que devuelve un array con los identificadores de detalle que contienen un articulo especificado.
	  */
	function get_idxdetail_art($id_art) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		$id_art = (int)$id_art;
		if (!is_array($this->_aDetIdx_Art[$id_art]) OR empty($this->_aDetIdx_Art[$id_art])) return NULL;
		else return $this->_aDetIdx_Art[$id_art];
	}

	/** 
	  * Metodo para obtener la informacion de una linea de detalle determinada.
	  * @param $idx_det	-	Identificador del detalle a devolver
	  * @return array()	-	Array associativo con las informacion de la linea de detalle.
	  */
	function get_detail($idx_det) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		return $this->_aDetalles[$idx_det];
	}

	/**
	  * Anyade Comentarios a la linea de detalle.
	  *
	  **/
	function set_detail_comment($idx_det,$big_text) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		$this->_aDetalles[$idx_det][observaciones] = $big_text;

		$this->_aModif[detalles][$idx_det] |= inmPed_MODIFIED;
		$this->_change_flags(inmPed_CHG_DETAIL);
		return 1;
	}

	/**
	  * Obtiene los Comentarios de una linea de detalle.
	  *
	  **/
	function get_detail_comment($idx_det) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		return ( (!empty($this->_aDetalles[$idx_det][observaciones])) ? $this->_aDetalles[$idx_det][observaciones] : NULL);
	}

	/**
	  * Cambia la cantidad de una linea de detalle.
	  * @param $idx_det	- 	Identificador de la linea de detalle que se ha de modificar.
	  * @param $cantidad	- 	Cantidad a insertar en la linea de detalle.
	  * @paran $bBultos	- 	Si la cantidad indicada son bultos (true) o unidades(false).
	  * @param $bSuma		- 	Si la cantidad indicada ha de ser sumada o asignada. 
	  * @param $bRecibi	- 	Si la cantidad indicada se ha de marcar como recibida tambien.
	  * @paran $bDtos		- 	Si han de volver a Comprobar los descuentos.
	  * @return bool		- 	Si se han producido los cambios correctamente o no.
	  */
	function set_quantity($idx_det,$cantidad,$bBultos = 0,$bSuma = FALSE,$bRecibi = FALSE,$bDtos = TRUE) 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!is_numeric($cantidad)) return 0;
		if (!isset($bDtos)) $bDtos = TRUE;
		if (!isset($bBultos)) $bBultos = 0;
		if (!isset($bRecibi)) $bRecibi = FALSE;
		if (!isset($bSuma)) $bSuma = FALSE;

		/** ** (Jodemos los cambios de cantidades de las promos)
		$price = $this->get_price($idx_det);
		if ( ($this->_fPedido & inmPed_STRICT) AND empty($price)) {
			$this->error(600,"No se puede cambiar la cantidad de un articulo sin cargo");
			return FALSE;
		}
		/** **/

		if (is_numeric($cantidad )) {
			if (is_integer($cantidad)) $cantidad = (int)$cantidad;
			else $cantidad = round($cantidad,$this->op_decimals);
		} else $cantidad = (int)$cantidad;
		if ($bBultos) 
			if ($bBultos==1 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto']) {
				$cantidad *= (int)$this->_aDetalles[$idx_det]['unidades_bulto'];
			} elseif ($bBultos==2 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto'] 
					AND (int)$this->_aDetalles[$idx_det]['bultos_capa_palet']) {
				$cantidad *= (int)$this->_aDetalles[$idx_det]['unidades_bulto'] * (int)$this->_aDetalles[$idx_det]['bultos_capa_palet'];
			} elseif ($bBultos==3 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto']
					AND (int)$this->_aDetalles[$idx_det]['bultos_capa_palet'] AND (int)$this->_aDetalles[$idx_det]['capas_palet']) {
				$cantidad *= (int)$this->_aDetalles[$idx_det]['unidades_bulto'] * (int)$this->_aDetalles[$idx_det]['bultos_capa_palet']
									* (int) $this->_aDetalles[$idx_det]['capas_palet'];
			}
		if ($this->_aDetalles[$idx_det]['cantidad_pedida'] != $cantidad AND is_numeric($cantidad)) {
			if ($bSuma) $this->_aDetalles[$idx_det]['cantidad_pedida'] += $cantidad;
			else $this->_aDetalles[$idx_det]['cantidad_pedida'] = $cantidad;
			$this->_aDetalles[$idx_det]['peso'] = 
				$this->_aDetalles[$idx_det]['peso_unidad'] * $this->_aDetalles[$idx_det]['cantidad_pedida'];
		}

		if ($bRecibi) 
			if ($bSuma) $this->_aDetalles[$idx_det]['cantidad_recibida'] += $cantidad;
			else $this->_aDetalles[$idx_det]['cantidad_recibida'] = $cantidad;

		if ( $bDtos AND !($aTmp = $this->check_client_discount($idx_det,TRUE)) AND
					!($aTmp = $this->check_offers($idx_det,TRUE))  AND
					!($aTmp = $this->check_volume_discount($idx_det,TRUE)) ) {
				if ($this->debug) debug("set_quantity() - No hay descuentos!");
		} elseif($bDtos) {
			if ($this->debug) debug("set_quantity ha localizado descuentos aplicables..");
			if ($this->debug) print_r($aTmp);
			$this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_DISCOUNT;
		}

		if ($this->debug)
			debug("set_quantity($idx_det)... ".
					" Recibida = ".$this->_aDetalles[$idx_det][cantidad_recibida].
					" Pedida = ".$this->_aDetalles[$idx_det][cantidad_pedida]
					);
		$this->_aModif['detalles'][$idx_det] |= inmPed_CHG_DET_QUANTITY;
		$this->_change_flags(inmPed_CHG_DETAIL | inmPed_MODIFIED);

		// if ($this->debug) debug("set_quantity() el detalle:");
		// if ($this->debug) print_r($this->_aDetalles[$idx_det]);
		return 1;
	}

	/**
	  * Obtiene la cantidad de una linea de detalle.
	  * @param $idx_det	-	Identificador del detalle que hay que consultar.
	  * @param $bBultos	-	Si la cantidad ha retornar ha de ser en bultos.
	  * @param $bRecibida-	Tipo de cantidad a consultar (0-Pedida;1-Recibida;2-Total)
	  **/
	function get_quantity($idx_det,$bBultos = 0, $bRecibida = FALSE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!isset($bRecibida)) $bRecibida = FALSE;
		if (!isset($bBultos)) $bBultos = 1;

		if ($bRecibida) $campo_cantidad = 'cantidad_recibida';
		else $campo_cantidad = 'cantidad_pedida';

		if ($bBultos)
			if ($bBultos == 1 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto']) {
				$cant = $this->_aDetalles[$idx_det][$campo_cantidad] / $this->_aDetalles[$idx_det]['unidades_bulto'];
			} elseif ($bBultos==2 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto'] 
					AND (int)$this->_aDetalles[$idx_det]['bultos_capa_palet']) {
				$cant = $this->_aDetalles[$idx_det][$campo_cantidad] /
				  		((int)$this->_aDetalles[$idx_det]['unidades_bulto'] * (int)$this->_aDetalles[$idx_det]['bultos_capa_palet']);
			} elseif ($bBultos==3 AND (int)$this->_aDetalles[$idx_det]['unidades_bulto']
					AND (int)$this->_aDetalles[$idx_det]['bultos_capa_palet'] AND (int)$this->_aDetalles[$idx_det]['capas_palet']) {
				$cant =  $this->_aDetalles[$idx_det][$campo_cantidad] /
						((int)$this->_aDetalles[$idx_det]['unidades_bulto'] * (int)$this->_aDetalles[$idx_det]['bultos_capa_palet']
									* (int) $this->_aDetalles[$idx_det]['capas_palet']);
			} else {
				//Fixme: revisar consecuencias de comentar esto.
				//  $this->error(510,"El detalle indicado no tiene unidades por bulto. Division por 0");
				return NULL;
			}
		else $cant = $this->_aDetalles[$idx_det][$campo_cantidad];

		// debug("la $campo_cantidad de $idx_det ?? = $cant");
		return $cant;
	}

	/**
	  * Metodo que establece el descuento, y tipo de descuento de una linea de detalle.
	  * @param $idx_det	-	Id de la linea de detalle a modificar.
	  * @param $discount	- 	Descuento a aplicar.
	  * @param $bPto		-	Si es un porcierto o un Monto.
	  * @param $nombre	-  Nombre del descuento.
	  * @param $bForce	-	Forzar la modificacion cuando ya existe un descuento.
	  * @return bool		-  Si la operacion se ha realizado con exito.
	  **/
	function set_discount($idx_det,$discount = NULL,$bPto = TRUE,$nombre = NULL,$bForce = FALSE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		// Valores por defecto.
		if (!$bPto) $bPto = TRUE;
		if (!$bForce) $bForce = FALSE;
		$done = FALSE;
		if ($this->debug) debug("set_discount() al id $idx_det de $discount en porciento($bPto) con nombre($nombre) forzar($bForce)");
		$chg_dto = FALSE;
		if (is_numeric($discount)) 
			if ($bPto AND (!$this->have_discount($idx_det) OR $bForce)) {
				$this->_aDetalles[$idx_det][precio_tarifa_descuento] = $this->_aDetalles[$idx_det][precio_tarifa] -
					  ($this->_aDetalles[$idx_det][precio_tarifa] * $discount / 100);
				if ($this->_aDetalles[$idx_det][descuento] != $discount) $chg_dto = TRUE;
				$this->_aDetalles[$idx_det][descuento] = $discount;
				$done = TRUE;
			} elseif (!$bPto AND (!$this->have_discount($idx_det) OR $bForce)) {
				$this->_aDetalles[$idx_det][precio_tarifa_descuento] = $this->_aDetalles[$idx_det][precio_tarifa] -
					  ( $discount );
				if ($this->_aDetalles[$idx_det][monto] != $discount) $chg_dto = TRUE;
				$this->_aDetalles[$idx_det][monto] = $discount;
				$done = TRUE;
			}
		if ($nombre OR $bForce) {
			$this->_aDetalles[$idx_det][tipo_descuento] = $nombre;
			// $done = TRUE;
		}
		if ($done) {
			$this->_aDetalles[$idx_det][precio_tarifa_descuento] =
					  round($this->_aDetalles[$idx_det][precio_tarifa_descuento],$this->op_decimals);
			if ($chg_dto) {
				$this->_aModif[detalles][$idx_det] |= inmPed_CHG_DET_DISCOUNT;
				$this->_change_flags(inmPed_CHG_DETAIL);
			}
		}
	}

	/**
	  * Con este metodo obtenemos los descuentos de una linea de detalle. (si tiene)
	  * @param $idx 	-	Identificador de la linea de detalle de la cual se desea obtener los descuentos.
	  * @return NULL - on Error ; array() - on !discounts; array("porciento","monto","tipo") on discounts
	  **/
	function get_detail_discount($idx) 
	{
		if (!is_numeric($idx)) return NULL;
		if (!is_array($this->_aDetalles[$idx])) return NULL;
		if (!$this->have_discount($idx)) return array();
		else return array("porciento" => $this->_aDetalles[$idx][descuento],
								"monto"		=> $this->_aDetalles[$idx][monto],
								"tipo"		=> $this->_aDetalles[$idx][tipo_descuento]);
	}

	/**
	  * Este metodo establece el precio del articulo indicado en el detalle idx
	  * @param $idx_detalle 	-	Detalle al cual hay que cambiarle el precio
	  * @param $price				-  Precio que se desea poner.
	  * @param $bDiscount	 	-	Si el precio incluye descuento o no
	  * @return bool		- Si la operacion se ha realizado con exito.
	  **/
	function set_price($idx_det,$price = 0,$bDiscount = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_numeric($price)) return 0;
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if ($this->debug) debug("Establecemos($idx_det) el precio... $price");

		$this->_aDetalles[$idx_det][precio_tarifa] = $price;
		if ($bDiscount) $this->_aDetalles[$idx_det][precio_tarifa_descuento] = $price;
//debug("Resultado = ");
// print_r($this->_aDetalles[$idx_det]);

		// Marcamos el cambio.
		$this->_aModif[detalles][$idx_det] |= inmPed_CHG_DET_PRICE;
		$this->_change_flags(inmPed_CHG_DETAIL);

		return 1;
	}

	/**
	  * Este metodo devuelve el precio del articulo indicado en el detalle idx
	  * @param $idx_detalle 	-	Detalle al cual hay que cambiarle el precio
	  * @param $bDiscount	 	-	Si el precio ha de incluir el descuento del detalle o no
	  * @return float				- Precio del articulo en la linea de detalle
	  **/
	function get_price($idx_det,$bDiscount = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return 0;
		if (!isset($bDiscount)) $bDiscount = FALSE;

		if ($bDiscount AND $this->_aDetalles[$idx_det][precio_tarifa_descuento]) $fld = 'precio_tarifa_descuento';
		else $fld = 'precio_tarifa';
		$fld = 'precio_tarifa'; //Fixme: Precio tarifa descuento desabilidato

		return $this->_aDetalles[$idx_det][$fld];
	}

	/**
	  * Devuelve la informacion de los impuestos aplicados al pedido.
	  */
	function get_taxes() 
	{
		return $this->_aIVAs;
	}

	/**
	  * Devuelve la informacion de los descuentos globales aplicados al pedido en base al cliente.
	  */
	function get_discounts() 
	{
		return $this->_aDescuentos;
	}

	/**
	  * Obtiene la informacion de los calculos totales del pedido.
	  */
	function get_totals() 
	{
		return $this->_aTotales;
	}


	function __get($prop_name,$prop_value) 
	{
	}

	function __set($prop_name,$prop_value) 
	{
	}

	function __call() 
	{
	}

	function set_db($db_name) 
	{
		$app = $this->App_Name;
		global $$app;
		// debug("set_db( -$app- )");
		if (empty($db_name)) $db = $$app->get_db($this->_db_name);
		else {
			$this->_db_name = $db_name;
			$db = $$app->get_db($this->_db_name);
		}
		$this->_db = $db;
		return 1;
	}

	/**
	  * Metodo encargado de que las funciones nodb mantengan pista de la instancia que tienen que mostrar.
	  **/
	function set_session_var($var_name = NULL) {
		$app = $this->App_Name;
		global $$app;
		if (is_numeric($var_name)) return 0;

		if (empty($var_name) ) $var_name = $this->_sess_var;
		else {
			$this->_sess_var = $var_name;
		}
		$$app->set_var('_varoPed',$var_name);
		return 1;
	}

	/**
	  * Nombre de la variable de sesion que contiene/contendra la instancia actual.
	  **/
	function get_session_var() {
		return $this->_sess_var;
	}

	function set_tipo_pedido($tipo) 
	{
		if ($tipo & inmPed_VENTA)
			$this->_fPedido |= inmPed_VENTA;
		else { // Si no es de venta, es de compra.
			$this->_fPedido &= ~inmPed_VENTA;
debug("Es de compra!!");
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
	function _set_enterprise_issuer($id_empresa) 
	{
		if (!(int)$id_empresa) return FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error(1,"DB connection not instanciated");
			return FALSE;
		}
		$id_cliente = (int)$this->_aReceptor['id_cliente'];
		// Caso de compras, id_proveedor
		$cons = "SELECT ".  // Datos del Emisor
				  "Emp.retencion as 'emp_retencion', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto,NULL) as 'emp_dto_bulto', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto_uds,NULL) as 'emp_dto_bulto_uds', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa,NULL) as 'emp_dto_capa', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa,_udsNULL) as 'emp_dto_capa_uds', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet,NULL) as 'emp_dto_palet', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet,_udsNULL) as 'emp_dto_palet_uds', ".
				  "Emp.id_empresa as 'emp_id_empresa', ".
				  "Emp.id_empresa as 'emp_id', ".
				  "Emp.razon_social as 'emp_razon_social', ".
				  "Emp.cif as 'emp_cif', ".
				  "Emp.prefijo_cif as 'emp_prefijo_cif', ".
				  "Emp.direccion_facturacion as 'emp_direccion_facturacion', ".
				  "Emp.cp as 'emp_cp', ".
				  "Emp.poblacion as 'emp_poblacion', ".
				  "Prov.nombre as 'emp_provincia', ".
				  "Emp.fax as 'emp_fax', ".
				  "Emp.telefono1 as 'emp_telefono1', ".
				  "Emp.id_empresa as 'ped_id_empresa', ". 
				  "Div.id_divisa as 'ped_id_divisa', ". 
				  // Divisa del Pedido (=emisor).
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.ratio as 'div_ratio' ".
				  ( 	($id_cliente) 
					 	?  ", CliEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
					 		"FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
							"FPago.nombre as 'fpa_nombre', ".
							"FPago.id_forma_pago as 'fpa_id_forma_pago', ".
							"FPago.num_efectos as 'fpa_num_efectos', ".
							"FPago.dias_efectos as 'fpa_dias_efectos', ".
							"FPago.medio_pago as 'fpa_medio_pago', ".
							// Tarifa de precios (solo ventas)
							"Tar.campo_accion as 'tar_campo_accion', ".
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
							"CliEmp.mostrar_ofertas as 'cli_mostrar_ofertas' "
						: "").
				  "FROM Empresas Emp, Divisa Div, Provincias Prov ".
				  ( 	($id_cliente)
						? 	", Tarifas Tar, Forma_pago FPago, Clientes_empresas CliEmp, ".
							"Tipo_cliente TCli "
						: "").
				  "WHERE Emp.id_divisa = Div.id_divisa AND Emp.id_empresa = $id_empresa AND Emp.id_provincia = Prov.id_provincia".
				  (	($id_cliente)
						? 	"AND CliEmp.id_empresa = Emp.id_empresa AND CliEmp.id_cliente = $id_cliente AND ".
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
	function _set_provider_issuer($id_proveedor) 
	{
		if (!(int)$id_proveedor) return FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error(1,"DB connection not instanciated");
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
				  "Prv.id_proveedor as 'ped_id_proveedor', ". 
				  "Div.id_divisa as 'ped_id_divisa', ". 
				  // Divisa del Pedido (=emisor).
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.ratio as 'div_ratio', ".
				  "(1/Div.ratio) as 'emp_div_ratio' ".
				  ( 	($id_empresa) 
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
							"PrvEmp.aplicar_recargo as 'emp_aplicar_recargo', ".
							"PrvEmp.descuento as 'emp_dto_directo', ".
							"PrvEmp.descuento_financiero as 'emp_dto_pronto_pago', ".
							"PrvEmp.aplicar_retencion as 'emp_aplicar_retencion', "
						: "").
				  "FROM Proveedores Prv, Divisa Div, Provincias Prov ".
				  ( 	($id_empresa)
						? 	", Forma_pago FPago, Proveedores_empresas PrvEmp, ".
							"Divisa Div2, Empresas Emp "
						: "").
				  "WHERE Prv.id_divisa = Div.id_divisa AND Prv.id_proveedor = $id_proveedor AND Prv.id_provincia = Prov.id_provincia".
				  (	($id_empresa)
						? 	"AND PrvEmp.id_empresa = $id_empresa AND PrvEmp.id_empresa = Emp.id_empresa AND ".
							"PrvEmp.id_forma_pago = FPago.id_forma_pago "
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
	  * @param 	$id_cliente	-	cliente que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return 	bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function _set_client_reciever($id_cliente,$bForce = FALSE) 
	{
		// Separar este bloque y los 2 del final en 3 metodos? 2 solo para los del final?

		if (!is_numeric($id_cliente)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		// Si tenemos un agente seleccionado y el pedido esta marcado como estricto,
		//		el cliente solo puede ser alguno de los clientes del agente.
		if ((int)$this->_aPedido[id_agente] AND $this->_fPedido & inmPed_STRICT) { 
			// Fixme: Que pasa si un cliente no tiene agentes? podria este agente hacer el pedido?.
			if (is_array($this->_aClientes_agente) AND !is_array($this->_aClientes_agente[$id_cliente])) {
				$this->error(500,"El receptor no se corresponde a ninguno de los clientes del agente seleccionado");
				return FALSE;
			} else {
				$id_cliente = (int)$id_cliente;
				$this->_aAgente['comision'] = $this->_aClientes_agente[$id_cliente]['comision'];
				$this->_aAgente['comision_repartida'] = $this->_aClientes_agente[$id_cliente]['comision_repartida'];
			}
		}
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error(1,"DB connection not instanciated");
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
							 "Prov.nombre as 'cli_provincia', ".
							 "Div2.id_divisa as 'cli_id_divisa', ".
							 "Div2.leyenda as 'cli_div_leyenda', ".
							 "Div2.nombre as 'cli_div_nombre', ".
							 "(1/Div2.ratio) as 'cli_div_ratio' ".
							 ( 	($id_empresa) 
								  ?  ", CliEmp.id_forma_pago as 'ped_id_forma_pago', ".// forma pago defecto receptor
								  	  "FPago.nombre as 'ped_nombre_forma_pago', ".// forma pago defecto receptor
										"FPago.nombre as 'fpa_nombre', ".
										"FPago.id_forma_pago as 'fpa_id_forma_pago', ".
										"FPago.num_efectos as 'fpa_num_efectos', ".
										"FPago.dias_efectos as 'fpa_dias_efectos', ".
										"FPago.medio_pago as 'fpa_medio_pago', ".
									  // Tarifa de precios (solo ventas)
									  "Tar.campo_accion as 'tar_campo_accion', ".
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
									  "CliEmp.aplicar_dto_vol as 'cli_aplicar_dto_volumen' "
								  : "").
							 "FROM Clientes Cli, Provincias Prov, Divisa Div2 ".
							 ( 	($id_empresa)
								  ? 	", Tarifas Tar, Forma_pago FPago, Clientes_empresas CliEmp, ".
									  "Tipo_cliente TCli "
								  : "").
							 "WHERE Cli.id_cliente = $id_cliente AND Prov.id_provincia = Cli.id_provincia AND ".
							 "Cli.id_divisa = Div2.id_divisa ".
							 (	($id_empresa)
								  ? 	"AND CliEmp.id_cliente = Cli.id_cliente AND CliEmp.id_empresa = $id_empresa AND ".
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

		$this->_possible_agents_clients($id_cliente,0);
		$this->_possible_addresses($id_cliente);

		return TRUE;
	}

	/**
	  * Metodo que establece/asigna la empresa receptora del documento pedido actual.
	  * @param 	$id_empresa	-	receptor que vamos a establecer 
	  * @param  $bForce	-	Forzar el establecimiendo/reobtencion de datos.
	  * @return 	bool	-	Devuelve un indicativo de si la operacion se ha realiza con exito o no.
	  **/
	function _set_enterprise_reciever($id_empresa,$bForce = FALSE) 
	{
		// Caso de compras, el id_empresa
		if (!is_numeric($id_empresa)) return FALSE;
		if (!isset($bForce)) $bForce = FALSE;
		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error(1,"DB connection not instanciated");
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
							 "Prov.nombre as 'emp_provincia', ".
							 "Div2.id_divisa as 'emp_id_divisa', ".
							 "Div2.leyenda as 'emp_div_leyenda', ".
							 "Div2.nombre as 'emp_div_nombre' ".
							 ( 	($id_proveedor) 
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
									  "PrvEmp.aplicar_recargo as 'emp_aplicar_recargo', ".
									  "PrvEmp.descuento as 'emp_dto_directo', ".
									  "PrvEmp.descuento_financiero as 'emp_dto_pronto_pago', ".
									  "PrvEmp.aplicar_retencion as 'emp_aplicar_retencion', ".
									  "PrvEmp.mantener_ratio_divisa as 'prv_ratio_divisa_dias' "
								  : "").
							 "FROM Empresas Emp, Provincias Prov, Divisa Div2 ".
							 ( 	($id_proveedor)
								  ? 	", Forma_pago FPago, Proveedores_empresas PrvEmp "
								  : "").
							 "WHERE Emp.id_empresa = $id_empresa AND Prov.id_provincia = Emp.id_provincia AND ".
							 "Emp.id_divisa = Div2.id_divisa ".
							 (	($id_proveedor)
								  ? 	"AND PrvEmp.id_empresa = Emp.id_empresa AND PrvEmp.id_proveedor = $id_proveedor AND ".
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

		$this->_possible_agents_clients($id_empresa,1);
		$this->_possible_addresses($id_empresa);

		return TRUE;
	}

	/**
	  * Este metodo se va a encargar de rellenar los atributos: _aAgentes_cliente y _aClientes_agente
	  * Ambos atributos son de tipo array(array[referencial]). Contienen la lista de los posibles Agentes 
	  *	de un cliente y la de los posibles Clientes de una gente -respectivamente-
	  * La utilidad de ambos arrays esta en el modo stricto del documento, en el cual una vez establecido el 
	  *	cliente o agente del mismo, no es posible indicar otro agente o cliente distinto a los que mantienen
	  *	relacion con la entidad ya seleccionada (cliente o agente).
	  * @param	$id	- 	Valor de la clave primaria de agente o cliente en la bbdd.
	  * @return	bool	-	Si se han podido establecer con exito.
	  **/
	function _possible_agents_clients($id, $tipo = 0) 
	{
		if (!is_numeric($tipo) OR !is_numeric($id)) return NULL;

		$oDb = $this->_db;
		if (!is_object($oDb)) {
			$this->error(1,"DB connection not instanciated");
			return FALSE;
		}

		$retval = FALSE;
		if ($this->_fPedido & inmPed_VENTA) {
			if (!$tipo) { // Rellenar el array de posibles agentes del cliente.
				if (!(int)$this->_aPedido['id_agente']) {
					$cons = "SELECT ".
							  "Ag.id_agente as 'id_agente', ".
							  "CONCAT(Ag.apellidos,', ',Ag.nombre) as 'nombre', ".
							  "AC.comision as 'comision', ".
							  "AC.comision_repartida as 'comision_repartida' ".
							  "FROM Agentes Ag, Agentes_clientes AC ".
							  "WHERE Ag.id_agente = AC.id_agente AND AC.id_cliente = $id";
					$id_rs = $oDb->query($cons);
					$this->_aAgentes_cliente = array();
					if ($oDb->num_rows($id_rs)) 
						while ($aTmp = $oDb->fetch_assoc($id_rs)) $this->_aAgentes_cliente[$aTmp['id_agente']] = $aTmp;
					else $this->_aAgentes_cliente = NULL;
					$oDb->libera($id_rs);
					$retval = TRUE;
				}
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
			$this->error(1,"DB connection not instanciated");
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
				$this->error(501,"El receptor no tiene direccion de entrega");
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
				$this->error(501,"El receptor no tiene direccion de entrega");
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
	  * @return bool	- 	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_sale_headders($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;

		$oDb = $this->_db;
		// Rellenamos las cabeceras del pedido:
		$cons = "SELECT Ped.id_pedido as 'ped_id_pedido', ".
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
				  "Ped.nombre as 'ped_nombre', ".
				  "Ped.referencia as 'ped_referencia', ".
				  "Ped.referencia_externa as 'ped_referencia_externa', ".
				  "Ped.observaciones as 'ped_observaciones', ".
				  "Ped.fecha as 'ped_fecha', ".
				  "Ped.preparado as 'ped_preparado', ".
				  "Ped.id_pedido_incompleto as 'ped_id_pedido_incompleto', ".
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
				  "Prov2.nombre as 'cli_provincia', ".
				  "Ped.id_direccion as 'cli_id_direccion', ".
				  "TCli.aplicar_iva as 'cli_aplicar_iva', ".
				  "TCli.aplicar_recargo as 'cli_aplicar_recargo', ".
				  "CliEmp.dto_directo as 'cli_dto_directo', ".
				  "CliEmp.dto_pronto_pago as 'cli_dto_pronto_pago', ".
				  "CliEmp.aplicar_retencion as 'cli_aplicar_retencion', ".
				  "CliEmp.mostrar_ofertas as 'cli_mostrar_ofertas', ".
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
				  "Emp.retencion as 'emp_retencion', ".
				  "Emp.id_empresa as 'emp_id_empresa', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto,NULL) as 'prv_dto_bulto', ".
				  "IF(Emp.dto_gnrl_vol_bulto,Emp.dto_gnrl_vol_bulto_uds,NULL) as 'prv_dto_bulto_uds', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa,NULL) as 'prv_dto_capa', ".
				  "IF(Emp.dto_gnrl_vol_capa,Emp.dto_gnrl_vol_capa_uds,NULL) as 'prv_dto_capa_uds', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet,NULL) as 'prv_dto_palet', ".
				  "IF(Emp.dto_gnrl_vol_palet,Emp.dto_gnrl_vol_palet_uds,NULL) as 'prv_dto_palet_uds', ".
				  "Tar.campo_accion as 'tar_campo_accion', ".
				  "Tar.pto_primero as 'tar_pto_primero', ".
				  "Tar.pto_segundo as 'tar_pto_segundo', ".
				  "Tar.monto as 'tar_monto', ".
				  "Div.id_divisa as 'div_id_divisa', ".
				  "Div.leyenda as 'div_leyenda', ".
				  "Div.nombre as 'div_nombre_divisa', ".
				  "Div.ratio as 'div_ratio' ".
				  "FROM Pedidos Ped, Direcciones_entrega Dir, Clientes Cli, Clientes_empresas CliEmp, Forma_pago as FPago, ".
				  "Tarifas Tar, Empresas Emp, Divisa Div, Divisa Div2, Tipo_cliente TCli, Provincias Prov, Provincias Prov2 ".
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
	  * @return bool	- 	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_purchase_headders($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;

		$oDb = $this->_db;
		// Rellenamos las cabeceras del pedido:
		$cons = "SELECT Ped.id_pedido as 'ped_id_pedido', ".
				  "Ped.id_empresa as 'ped_id_empresa', ".
				  "Ped.id_agente as 'ped_id_agente', ".
				  "Ped.id_almacen as 'ped_id_almacen', ".
				  "Ped.id_proveedor as 'ped_id_proveedor', ".
				  "Ped.id_divisa as 'ped_id_divisa', ".
				  "Ped.id_forma_pago as 'ped_id_forma_pago', ".
				  "Ped.id_pedido_incompleto as 'ped_id_pedido_incompleto', ".
				  "Ped.nombre as 'ped_nombre', ".
				  "Ped.referencia as 'ped_referencia', ".
				  "Ped.referencia_externa as 'ped_referencia_externa', ".
				  "Ped.observaciones as 'ped_observaciones', ".
				  "Ped.fecha as 'ped_fecha', ".
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
				  "Prov2.nombre as 'emp_provincia', ".
				  "EmpPrv.aplicar_iva as 'emp_aplicar_iva', ".
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
				  "FROM Pedidos Ped, Almacenes Alm, Empresas Emp, Proveedores_empresas EmpPrv, Forma_pago as FPago, ".
				  "Proveedores Prv, Divisa Div, Divisa Div2, Provincias Prov, Provincias Prov2 ".
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
			  $retval = TRUE;
		} else $retval = FALSE;
		$oDb->libera($id_rs);

		return $retval;
	}

	/**
	  * Metodo encargado de obtener de la bbdd el escandallo (o lineas de detalle) del pedido en curso. Con su precio real (sin ser alterado 
	  * por la tarifa aplicada ). Este metodo es exclusivo de VENTAS.
	  * @param $id		-	Identificador del pedido del cual se desea poblar las cabeceras.
	  * @return bool	- 	TRUE on success, FALSE on failure.
	  **/
	function _dbfetch_saleorder_details($id) {
		if (!is_numeric($id) OR $id == 0) return FALSE;
		if (!is_array($this->_aIDAlbaran)) $hay_albaranes = 0;
		else $hay_albaranes = sizeof($this->_aIDAlbaran);
		$leyenda_divisa = $this->_aDivisa['leyenda'];
		$campo_accion = $this->_aTarifa['campo_accion'];
		$oDb = $this->_db;

		$cons = "SELECT Det.id_detalle as 'id_detalle', ".
					"Det.id_articulo as 'id_articulo', ".
					"Det.id_servicio as 'id_servicio', ".
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					( ($hay_albaranes) 
						? "Det.cantidad - Det.cantidad_recibida as 'cantidad_residual', "
						: "" ).
					"Det.cantidad as 'cantidad_pedida', ".
					"ROUND(Det.precio_articulo,".$this->tot_decimals.") as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"ROUND(Det.monto,".$this->tot_decimals.") as 'monto', ".
					"ROUND(Det.monto_total,".$this->tot_decimals." as 'base_imponible', ".
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
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"(Det.cantidad*Art.peso_unidad) as 'peso', ".
					"ROUND(Empart.precio_venta,".$this->tot_decimals." as 'PVP_rec', ".
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					( ($this->_aPedido['id_pedido'])
						? "Empart.$campo_accion as 'precio_real', "
						: "" ).
					"EmpArt.dto_vol as 'dto_volumen', ".
					"EmpArt.dto_vol_bultos as 'dto_volumen_bultos', ".
					"EmpArt.unidades_bulto as 'unidades_bulto', ".
					"EmpArt.bultos_capa_palet as 'bultos_capa_palet', ".
					"EmpArt.capas_palet as 'capas_palet', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente' ".
					"FROM Lineas_detalle Det, Articulos Art, Familia_articulos Fam, Marcas Mca, Tipos_IVA Iva, ".
					"Empresas_articulos Empart, Pedidos Ped ".
					"WHERE Ped.id_pedido = $id AND Ped.id_pedido = Det.id_pedido AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Ped.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		if (!$oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				$this->_aDetalles[$i] = $fila;
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
	  * @return bool	- 	TRUE on success, FALSE on failure.
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
					"Det.cantidad_recibida as 'cantidad_recibida', ".
					( ($hay_albaranes) 
						? "Det.cantidad - Det.cantidad_recibida as 'cantidad_residual', "
						: "" ).
					"Det.cantidad as 'cantidad_pedida', ".
					"Det.precio_articulo as 'precio_tarifa', ".
					"Det.descuento as 'descuento', ".
					"Det.monto as 'monto', ".
					"Det.monto_total as 'base_imponible', ".
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
					"Art.descripcion as 'descripcion', ".
					"Art.id_familia as 'id_familia', ".
					"Fam.nombre as 'nombre_familia', ".
					"Art.id_marca as 'id_marca', ".
					"Mca.nombre as 'nombre_marca', ".
					"Art.peso_unidad as 'peso_unidad', ".
					"(Det.cantidad*Art.peso_unidad) as 'peso', ".
					"Empart.unidades_bulto as 'unidades_bulto', ".
					"Empart.bultos_capa_palet as 'bultos_capa_palet', ".
					"Empart.capas_palet as 'capas_palet', ".
					"Empart.precio_venta as 'PVP_rec', ".
					"Empart.stock as 'control_stock', ".
					"Empart.stock_ficticio as 'stock_estimado', ".
					"CompArt.precio as 'precio_real', ".
					"CompArt.dto_vol as 'dto_volumen', ".
					"CompArt.dto_vol_bultos as 'dto_volumen_bultos', ".
					"Iva.id_iva as 'id_iva', ".
					"Iva.porcentaje as 'porcentaje', ".
					"Iva.recargo_equivalente as 'recargo_equivalente' ".
					"FROM Lineas_detalle Det, Articulos Art, Familia_articulos Fam, Marcas Mca, Tipos_IVA Iva, ".
					"Empresas_articulos Empart, Pedidos Ped, Compra_articulos CompArt ".
					"WHERE Ped.id_pedido = $id AND Ped.id_pedido = Det.id_pedido AND CompArt.id_proveedor = $id_prv AND ".
					"CompArt.id_articulo = Det.id_articulo AND ".
					"Empart.id_articulo=Art.id_articulo AND Empart.id_empresa = Ped.id_empresa AND Art.id_marca = Mca.id_marca AND ".
					"Det.id_articulo=Art.id_articulo AND Art.id_iva=Iva.id_iva AND Art.id_familia = Fam.id_familia ".
					"ORDER BY id_detalle asc ";
		$id_res = $oDb->query($cons);
		if ($oDb->num_rows($id_res)) {
			$retval = TRUE;
			$this->_aDetalles = array();
			$total_bruto = 0;
			$total_peso = 0;
			for($i = 1; $fila = $oDb->fetch_assoc($id_res); $i++ ) {
				$this->_aDetalles[$i] = $fila;
				$total_bruto += $fila['base_imponible'];
				$total_peso += $fila['peso'];
			}
			$this->_aTotales['bruto'] = $total_bruto;
			$this->_aPedido['peso'] = $total_peso;
		} else $retval = FALSE;

		return $retval;
	}

	/**
	  * Obtiene las condiciones de compra/venta de un articulo.
	  **/
	function _get_article_conditions($id_art) 
	{
		if (!is_numeric($id_art)) return NULL;

		if ($this->_fPedido & inmPed_VENTA) {
			$campo_accion = $this->_aTarifa['campo_accion'];
			$id_empresa = $this->_aPedido['id_empresa'];
			$id_cliente = $this->_aPedido['id_cliente'];

			$oDb = $this->_db;
			$cons = "SELECT Art.id_articulo as 'id_articulo', ".
						"Art.nombre as 'nombre', ".
						"Art.descripcion as 'descripcion', ".
						"Art.id_familia as 'id_familia', ".
						"Fam.nombre as 'nombre_familia', ".
						"Art.id_marca as 'id_marca', ".
						"Mca.nombre as 'nombre_marca', ".
						"Art.peso_unidad as 'peso_unidad', ".
						"EmpArt.$campo_accion as 'precio_real', ".
						"EmpArt.unidades_bulto as 'unidades_bulto', ".
						"EmpArt.bultos_capa_palet as 'bultos_capa_palet', ".
						"EmpArt.capas_palet as 'capas_palet', ".
						"EmpArt.stock as 'control_stock', ".
						"EmpArt.stock_ficticio as 'stock_estimado', ".
						"EmpArt.precio_venta as 'PVP_rec', ".
						"EmpArt.dto_vol as 'dto_volumen', ".
						"EmpArt.dto_vol_bultos as 'dto_volumen_bultos', ".
						"Tiva.id_iva as 'id_iva', ".
						"Tiva.porcentaje as 'porcentaje', ".
						"Tiva.recargo_equivalente as 'recargo_equivalente' ".
						"FROM Articulos Art, Tipos_IVA Tiva, Empresas_articulos EmpArt, Familia_articulos Fam, Marcas Mca ".
						"WHERE Art.id_articulo = $id_art AND Fam.id_familia = Art.id_familia AND Mca.id_marca = Art.id_marca AND ".
						"Art.id_iva = Tiva.id_iva AND EmpArt.id_articulo = Art.id_articulo AND ".
						"EmpArt.id_empresa = $id_empresa ";
			$id_rs = $oDb->query($cons);
			if ($oDb->num_rows($id_rs)) {
				$fila = $oDb->fetch_assoc($id_rs);
				$fila['precio_tarifa'] = $fila['precio_real'];
				$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_primero'] )/100);
				$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_segundo'] )/100);
				$fila['precio_tarifa']=$fila['precio_tarifa'] + $this->_aTarifa['monto'] ;
				$fila['precio_tarifa'] = round($fila['precio_tarifa'],$this->op_decimals);
			} else $fila = NULL;
		} else {
			$id_empresa = $this->_aPedido['id_empresa'];
			$id_proveedor = $this->_aPedido['id_proveedor'];

			$oDb = $this->_db;
			$cons = "SELECT Art.id_articulo as 'id_articulo', ".
						"Art.nombre as 'nombre', ".
						"Art.descripcion as 'descripcion', ".
						"Art.id_familia as 'id_familia', ".
						"Fam.nombre as 'nombre_familia', ".
						"Art.id_marca as 'id_marca', ".
						"Mca.nombre as 'nombre_marca', ".
						"Art.peso_unidad as 'peso_unidad', ".
						"CompArt.precio as 'precio_real', ".
						"CompArt.dto_vol as 'dto_volumen', ".
						"CompArt.dto_vol_bultos as 'dto_volumen_bultos', ".
						"EmpArt.unidades_bulto as 'unidades_bulto', ".
						"EmpArt.bultos_capa_palet as 'bultos_capa_palet', ".
						"EmpArt.capas_palet as 'capas_palet', ".
						"EmpArt.stock as 'control_stock', ".
						"EmpArt.stock_ficticio as 'stock_estimado', ".
						"EmpArt.precio_venta as 'PVP_rec', ".
						"Tiva.id_iva as 'id_iva', ".
						"Tiva.porcentaje as 'porcentaje', ".
						"Tiva.recargo_equivalente as 'recargo_equivalente' ".
						"FROM Articulos Art, Tipos_IVA Tiva, Empresas_articulos EmpArt, ". 
						"Familia_articulos Fam, Marcas Mca, Compra_articulos CompArt ".
						"WHERE Art.id_articulo = $id_art AND Fam.id_familia = Art.id_familia AND Mca.id_marca = Art.id_marca AND ".
						"Art.id_iva = Tiva.id_iva AND EmpArt.id_articulo = Art.id_articulo AND CompArt.id_proveedor = $id_proveedor AND ".
						"EmpArt.id_empresa = $id_empresa AND CompArt.id_articulo = Art.id_articulo";
			$id_rs = $oDb->query($cons);
			if ($oDb->num_rows($id_rs)) {
				$fila = $oDb->fetch_assoc($id_rs);
				$fila['precio_tarifa'] = $fila['precio_real'];
				/** **
				$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_primero'] )/100);
				$fila['precio_tarifa']=$fila['precio_tarifa'] + ( ($fila['precio_tarifa'] * $this->_aTarifa['pto_segundo'] )/100);
				$fila['precio_tarifa']=$fila['precio_tarifa'] + $this->_aTarifa['monto'] ;
				$fila['precio_tarifa'] = round($fila['precio_tarifa'],$this->op_decimals);
				/** **/
			} else $fila = NULL;
		}

		return $fila;
	}
		
	/**
	  * Calcula la base imponible de una linea de detalle.
	  * @param 	idx_det	- Identificador del detalle para el cual calcular la base imponible
	  **/
	function _calcular_baseimponible($idx_det) 
	{
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;

		/** fixed **
		if ((float)$this->_aDetalles[$idx_det][descuento] OR (float)$this->_aDetalles[$idx_det][monto])
			$precio = $this->_aDetalles[$idx_det][precio_tarifa_descuento];
		else $precio = $this->_aDetalles[$idx_det][precio_tarifa];
		/** **/
		$precio = $this->_aDetalles[$idx_det][precio_tarifa];

		if (empty($this->_aDetalles[$idx_det][cantidad_residual]))
			if (empty($this->_aDetalles[$idx_det][cantidad_recibida]))
				$cantidad = $this->_aDetalles[$idx_det][cantidad_pedida];
			else $cantidad = $this->_aDetalles[$idx_det][cantidad_recibida];
		elseif (!empty($this->_aDetalles[$idx_det][cantidad_recibida]))
			$cantidad = $this->_aDetalles[$idx_det][cantidad_recibida];
		else $cantidad = $this->_aDetalles[$idx_det][cantidad_pedida] - $this->_aDetalles[$idx_det][cantidad_residual];

		$base = $precio * $cantidad;
		if ((float)$this->_aDetalles[$idx_det][descuento])
			$base -= ($base * $this->_aDetalles[$idx_det][descuento] / 100);
		elseif ((float)$this->_aDetalles[$idx_det][monto])
			$base -= $this->_aDetalles[$idx_det][monto];

		$this->_aDetalles[$idx_det][base_imponible] = round($base,$this->tot_decimals); 
		if (!$this->_is_tax($this->_aDetalles[$idx_det][id_iva])) 
			$this->_add_tax($this->_aDetalles[$idx_det][id_iva],$this->_aDetalles[$idx_det][porcentaje],
					$this->_aDetalles[$idx_det][recargo_equivalente],TRUE);

		if ($this->debug) debug("_calcular_base_imponible(Idx - $idx_det) ".
							"Cantidades: Residual(".$this->_aDetalles[$idx_det][cantidad_residual].
							") Recibida(".$this->_aDetalles[$idx_det][cantidad_recibida].
							") Pedida(".$this->_aDetalles[$idx_det][cantidad_pedida].
							") P.B.(".$this->_aDetalles[$idx_det][base_imponible]." $$$)");

		$this->_aFlags[total_bases] |= inmPed_MODIFIED;
		return 1;
	}

	/**
	  * Calcula el total de las bases imponibles de las lineas de detalle.
	  **/
	function _totales_baseimponible() 
	{
		$total = 0;
		$limpio = 0;
		$peso = 0;
		if ( ($this->_aFlags[total_bases] & inmPed_MODIFIED) ) {
			if ($this->debug) 
				debug("Calculando bases imponibles...");
			$aIReset = array();
			// Resetamos los valores de los IVAs y los descuentos.
			// $this->_reset_taxes();
			// $this->_reset_discounts();
			for ($idx = $this->first_detail(); isset($idx); $idx = $this->next_detail()) {
				if ($this->debug) debug("Recorreiendo detalle $idx");
				$this->_calcular_baseimponible($idx);
				$aItem = $this->get_detail($idx);
				if (!in_array($aItem[id_iva],$aIReset)) {
					$suma = FALSE;
					array_push($aIReset,$aItem[id_iva]);
					$this->_add_tax($aItem[id_iva],NULL,NULL,TRUE);
				} else $suma = TRUE;
				$this->_charge_tax($aItem[id_iva],$aItem[base_imponible],$suma);
				$total += $aItem[base_imponible];
				$limpio += $this->get_quantity($idx) * $this->get_price($idx,FALSE);
				$peso += $aItem[peso];
			}
			if ($this->debug) debug("Total bruto = $total; Total bruto no imponible = ".$limpio);
			$this->_aTotales[bruto]	= round($total,$this->tot_decimals);
			$this->_aTotales[bruto_no_imponible] = round($limpio,$this->tot_decimals);
			$this->_aPedido[peso] = (float)round($peso,$this->tot_decimals);
			if (is_array($this->_aIVAs[detalle]))
				foreach ($this->_aIVAs[detalle] as $id_iva => $aIva)
					if (!in_array($id_iva,$aIReset))
						$this->_del_tax($id_iva);
		} else return 1;
		// Fixme: Hacer esto por change_flags
		$this->_aFlags[total_bases] &= ~inmPed_MODIFIED;
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
	function _add_tax($id_iva,$pto = 0,$req = 0,$bReset = FALSE) 
	{
		if (!is_numeric($id_iva)) return 0;
		if ((int)is_array($this->_aIVAs[detalle][$id_iva])) {
			if ($bReset) {
				$this->_aIVAs[detalle][$id_iva][bruto] = 0;
				$this->_aIVAs[detalle][$id_iva][total_iva] = 0;
				$this->_aIVAs[detalle][$id_iva][total_recargo] = 0;
				$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
			}
			return 1;
		}
		if (!is_numeric($pto)) return 0;
		if (!is_numeric($req)) return 0;
		if (!$bReset) $bReset = FALSE;
		if ($bReset) $this->_aIVAs[detalle][$id_iva][bruto] = 0;
		$this->_aIVAs[detalle][$id_iva][porciento] = round($pto,$this->op_decimals);
		$this->_aIVAs[detalle][$id_iva][recargo_eq] = round($req,$this->op_decimals);
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		return 1;
	}

	function _get_tax($id_iva) 
	{
		return $this->_aIVAs[$id_iva];
	}

	/**
	  * Metodo encargado de borrar un tipo de impuesto del pedido. 
	  * @param $id_iva	-	Identificador del iva/impuesto que se ha de borrar.
	  * @return bool		-	Si se ha realizado la operacion con exito.
	  */
	function _del_tax($id_iva) 
	{
		if (!isset($id_iva) OR !is_array($this->_aIVAs[detalle][$id_iva])) return FALSE;
		$aTmp[id_iva] = $id_iva;
		$aTmp[id_pedido] = $this->_aIVAs[detalle][$id_iva][id_pedido];
		$aTmp[id_factura] = $this->_aIVAs[detalle][$id_iva][id_factura];
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		unset($this->_aIVAs[detalle][$id_iva]);
		array_push($this->_aIva_dbdel,$aTmp);
	}

	/**
	  * Metodo encargado de indicar si un tipo(id) de impuesto existe o no.
	  * @param $id_iva	-	Identificador del iva/impuesto que se ha de borrar.
	  * @return bool		-	Si se ha realizado la operacion con exito.
	  */
	function _is_tax($id_iva) 
	{
		// debug("_is_tax($id_iva) : ".is_array($this->_aIVAs[detalle][$id_iva]));
		if ((int)is_array($this->_aIVAs[detalle][$id_iva])) return TRUE;
		else return FALSE;
	}

	/**
	  * Reseta las bases para los calculos de IVA y las pone a 0
	  **/
	function _reset_taxes() 
	{
		if (is_array($this->_aIVAs[detalle])) {
			foreach ($this->_aIVAs[detalle] as $idiva => $aIVA) {
				$this->_aIVAs[detalle][$idiva][bruto] = 0;
				$this->_aIVAs[detalle][$idiva][base_imponible] = 0;
			}
		}
		$this->_aIVAs[total_iva] = 0;
		$this->_aIVAs[total_recargo] = 0;
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
	}


	/**
	  * Metodo encargado de incrementar/decrementar el broto de imposicion de cada tipo de iva.
	  * @param $id_iva	-	Identificador del tipo de iva.
	  * @param $monto		-	Cantidad a sumar/asignar.
	  * @param $bSuma		-	Si el monto ha de ser sumado o asignado.
	  * @return bool		-	si la operacion se ha realizado con exito.
	  */
	function _charge_tax($id_iva,$monto,$bSuma = TRUE) 
	{
		if (!is_numeric($monto)) return 0;
		if (!is_numeric($id_iva)) return 0;
		if (!isset($bSuma)) $bSuma = TRUE;

		if (!is_array($this->_aIVAs[detalle][$id_iva])) 
			$this->_add_tax($id_iva,NULL,NULL);
		if (!isset($bSuma) OR $bSuma == NULL) $bSuma = TRUE;
		if (!$bSuma)
			$this->_aIVAs[detalle][$id_iva][bruto] = round($monto,$this->op_decimals);
		else $this->_aIVAs[detalle][$id_iva][bruto] += round($monto,$this->op_decimals);
		$this->_aIVAs[detalle][$id_iva][base_imponible] = 0;
		if ($this->debug) debug("_charge_tax($id_iva) = > ".$this->_aIVAs[detalle][$id_iva][bruto]." Suma($bSuma)");
		$this->_change_flags(inmPed_CHG_TAXES | inmPed_MODIFIED);
		//Fixme: Tenemos 2 flags para los ivas, este de calculos_iva y luego el de pedido (inmPed_TAXES)
		//		El segundo deberia ser para no comprobar siquiera los ivas, y el primero para sumar o no los ivas de las lineas 
		//		de detalle.
	}

	/**
	  * Metodo encargado de recalcular desde 0 los detalles del iva. A partir de los detalles.
	  * @return bool	-	Si los calculos se han realizado bien o no.
	  */
	function __OFF_build_taxes() 
	{
		if ( ($this->_aFlags[calculos_iva] & inmPed_MODIFIED)) {
			$this->_totales_baseimponible();
			$aIva = array();
			$recalcular = FALSE;
			foreach($this->_aIVAs as $idv => $aIva) 
				if (!isset($aIva[bruto])) { $recalcular = TRUE; break; }

			if ($this->_aFlags[calculos_iva] & inmPed_MODIFIED OR $recalcular) {
				if ($this->debug) debug("Ivas tocados...");
				// $this->_reset_taxes();
				$this->_aIVAs[total_iva] = 0;
				$this->_aIVAs[total_recargo] = 0;
				//Fixme: Aki mejor llamar a totales_baseimponible()
				//No hace falta forzarlo: $this->_change_flags(inmPed_CHG_MAIN | inmPed_MODIFIED);
				$this->_totales_baseimponible();
			}
			$this->_calculate_discounts();

			$aplicar_iva = (int)$this->_aReceptor[aplicar_iva];
			$aplicar_recargo = (int)$this->_aReceptor[aplicar_recargo];
			if ($this->debug) 
				debug("Hemos vuelto de lanzar los descuentos desde el iva.i aplicar: iva($aplicar_iva) req($aplicar_recargo) ");

			foreach ($this->_aIVAs[detalle] as $id_iva => $aIva) {
				if ( $aIva[base_imponible] == 0) $this->_aIVAs[detalle][$id_iva][base_imponible] = $aIva[bruto];

				if ($aplicar_iva) 
					$this->_aIVAs[detalle][$id_iva][total_iva] = round(
							  ($this->_aIVAs[detalle][$id_iva][base_imponible] * $this->_aIVAs[detalle][$id_iva][porciento] / 100),
																							$this->op_decimals);
				if ($aplicar_recargo) 
					$this->_aIVAs[detalle][$id_iva][total_recargo] = round(
							  ($this->_aIVAs[detalle][$id_iva][base_imponible] * $this->_aIVAs[detalle][$id_iva][recargo_eq] / 100),
																							$this->op_decimals);
				$this->_aIVAs[total_iva] += $this->_aIVAs[detalle][$id_iva][total_iva];
				$this->_aIVAs[total_recargo] += $this->_aIVAs[detalle][$id_iva][total_recargo];
			}
			$this->_aIVAs[total_iva] = round($this->_aIVAs[total_iva],$this->tot_decimals);
			$this->_aIVAs[total_recargo] = round($this->_aIVAs[total_recargo],$this->tot_decimals);
			// debug("Build taxes cambiando flags ...");
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK | inmPed_DB_COMMIT);
		}

		if ($this->debug) debug("Total de los ivas: ");
		if ($this->debug) print_r($this->_aIVAs);
		return 1;
	}

	/**
	  * Metodo encargado de Re-extraer del cliente los detalles de sus descuentos.
	  * @param $bForce - Si ha de forzar la recogida de los dtos y el recalculo de dtos gnrales.
	  **/
	function _seek_discounts($bForce = FALSE) 
	{
		if (!isset($bForce)) $bForce = FALSE;
		if ($bForce OR !is_array($this->_aDescuentos[detalle])) {
			if ($this->debug) debug("Seeeek discounts... a toda costa..");
			if (is_array($this->_aDescuentos['detalle'])) {
				foreach ($this->_aDescuentos['detalle'] as $tmpid => $aDto) {
					if ((int)$aDto['id_descuento']) 
						$this->_db->tb_delete("Descuentos",array("id_descuento" => $aDto[id_descuento])) ;
				}
			}
			$this->_aDescuentos = array("total" => 0, "detalle" => array());
			$detalles_descuento = array();
			$i = 0;
			// Descuentos actuales son: Dto directo
			if((float)$this->_aReceptor['dto_directo']){
				$aTmp['orden'] = $i++;
				$aTmp['nombre'] = "cli";
				$aTmp['descuento'] = $this->_aReceptor['dto_directo'];
				$detalles_descuento[$aTmp['orden']] = $aTmp;
				$aTmp = array();
			} 
			// Y : Dto pronto pago. (no molaria aqui comprobar la forma de pago?)
			if((float)$this->_aReceptor['dto_pronto_pago']){
				$aTmp['orden'] = $i++;
				$aTmp['nombre'] = "P.P.";
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
	function __OFF_calculate_discounts() 
	{
		if ($this->_aFlags[descuentos] & inmPed_MODIFIED) {
			if ($this->debug) debug("calculando descuentos...");
			$this->_aDescuentos[total] = 0;
			if (!is_array($this->_aDescuentos)) {
				$this->_seek_discounts(TRUE);
			} else $i = sizeof($this->_aDescuentos[detalle]);

			// Calculamos descuentos.
			if (is_array($this->_aDescuentos[detalle]) AND sizeof($this->_aDescuentos[detalle]) ) {
				$this->_totales_baseimponible();

				if (!is_array($this->_aIVAs[detalle])) {
					$this->_add_tax(0,0,0,TRUE);
					$this->_charge_tax(0,$this->_aTotales[bruto]);
				}
				ksort($this->_aDescuentos[detalle]);
				reset($this->_aDescuentos[detalle]);
				$aDReset = array();
				$total_descuentos = 0;
				foreach ($this->_aIVAs[detalle] as $id_iva => $aIVA) {
					$base = $aIVA[bruto];
					if ($this->debug) debug("Base para el iva $id_iva = $base");
					foreach($this->_aDescuentos[detalle] as $i => $aDto) {
						if (!in_array($i,$aDReset)) {
							$this->_aDescuentos[detalle][$i][base_imponible] = $this->_aDescuentos[detalle][$i][importe] = 0;
							array_push($aDReset,$i);
						}
						$importe = round( ($base * $aDto[descuento] / 100), $this->op_decimals );
						$this->_aDescuentos[detalle][$i][base_imponible] += $base;
						$this->_aDescuentos[detalle][$i][importe] += $importe;
						$base = round( ($base - $importe), $this->op_decimals );
						$total_descuentos += $importe;
						// Si quisieses almacenar los dtos por iva, se haria aqui mismo.
					}
					$this->_aIVAs[detalle][$id_iva][base_imponible] = $base;
				}
				$this->_aDescuentos[total] = round($total_descuentos,$this->tot_decimals);
			} else $this->_aDescuentos = NULL;
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK | inmPed_DB_COMMIT);
				// debug("no hay detalle de descuentos?");
				// print_r($this->_aDescuentos);
		}
		if ($this->debug) debug("Hemos calculado los descuentos. estos son:");
		if ($this->debug) print_r($this->_aDescuentos);
		return 1;
	}

	/**
	  * Reseta las bases para los calculos de los descuentos y las pone a 0
	  **/
	function _reset_discounts() 
	{
		if (is_array($this->_aDescuentos[detalle])) {
			foreach ($this->_aDescuentos[detalle] as $id => $aDto) {
				$this->_aDescuentos[detalle][$id][importe] = 0;
				$this->_aDescuentos[detalle][$id][base_imponible] = 0;
			}
		}
		$this->_aDescuentos[total] = 0;
		$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
	}


	/**
	  * Metodo encargado de calcular internamente los importes totales del pedido.
	  * @param $bRecalcular	-	Si ha de intentar recalcular Ivas y Descuentos o no.
	  **/
	function __OFF_calculate_totals($bRecalcular = TRUE) 
	{
		if (!isset($bRecalcular)) $bRecalcular = TRUE;
		if ($bRecalcular) {
			$this->_totales_baseimponible();
			$this->_build_taxes();
		} 
		$aplicar_retencion = $this->_aReceptor['aplicar_retencion'];

		// $impuestos = $this->_aIVAs[total_iva] + $this->_aIVAs[total_recargo];
		// $this->_aTotales[impuestos] = $impuestos;
		$this->_aTotales['descuentos'] = (float)$this->_aDescuentos['total'];
		$this->_aTotales['impuestos'] = $this->_aIVAs['total_iva'];
		$this->_aTotales['recargos']	= $this->_aIVAs['total_recargo'];
	
		$this->_aTotales['base_imponible'] = $this->_aTotales['bruto'] - $this->_aTotales['descuentos'];

		$this->_aTotales['sin_retencion'] = $this->_aTotales['base_imponible'] + 
				  											$this->_aTotales['recargos'] + $this->_aTotales['impuestos'] ;

		if ($aplicar_retencion) $total_retenciones = $this->_aTotales['base_imponible'] * $this->_aEmisor['retencion'] / 100;
		$this->_aTotales['retenido'] = round($total_retenciones,$this->tot_decimals);

		$this->_aTotales['importe'] = (float) $this->_aTotales['sin_retencion'] - $this->_aTotales['retenido'];

		if ($this->_aDivisa['id_divisa'] != $this->_aReceptor['id_divisa'] AND $this->_aReceptor['div_ratio']!=0) {
			$this->_aTotales['divisa_cliente_importe'] = round (
					$this->_aTotales['importe'] * $this->_aReceptor['div_ratio'], $this->tot_decimals);
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

	/**
	  * Metodo encargado de reconstruir todos los indices internos de los detalles despues de una carga desde la db.
	  *
	  **/
	function __OFF_build_indexes() 
	{
		if ($this->debug) debug("_build_indexes()!");
		$aPromo_det = array(); // Las promociones del pedido.
		$aArt_sincargo = array(); // Lista de idx_detalle sin cargo
		$aArt_depromo = array();
		for($idx_act = $this->first_detail() ; isset($idx_act); $idx_act = $this->next_detail()) {
			$fila = NULL;
			$fila = $this->get_detail($idx_act);
			$id_articulo = $this->get_detail_article_id($idx_act);
			if ((int)$fila['id_detalle']) {
				$this->_aDetIdx[(int)$fila['id_detalle']] = $idx_act;
				if (empty($this->_aDet_dbdel[$idx_act]['cantidad_db']))
					$this->_aDet_dbdel[$idx_act]['cantidad_db'] = $this->_aDetalles[$idx_act]['cantidad_pedida'];
			}
			if (!is_array($this->_aDetIdx_Art[(int)$fila['id_articulo']]) 
					OR !in_array($idx_act,$this->_aDetIdx_Art[(int)$fila['id_articulo']]))
				$this->_aDetIdx_Art[(int)$fila['id_articulo']][] = $idx_act;

			$aPromo = NULL;
			if ((float)$this->get_price($idx_act) AND !$this->have_discount($idx_act))
				$aPromo = $this->check_offers($idx_act,FALSE);
			elseif (!(float)$this->get_price($idx_act)) 
				if (is_array($aArt_depromo) AND !in_array($idx_act,$aArt_depromo)) 
					array_push($aArt_sincargo,$idx_act);

			$cantidad = $this->get_quantity($idx_act);
			if (is_array($aPromo) AND !(int)$aPromo[oferta_promocion] AND is_array($aPromo[promo])) {
					// Si no hemos localizdo el id del array de promos, lo hacemos.
					$id_promocion = $aPromo[id_promocion];
					$idx_promo = NULL;
					if (!isset($idx_promo)) {
						$aAllPromo = $this->_aOff_Promo[$id_articulo];
						foreach ($this->_aOff_Promo[$id_articulo] as $idp => $aPromo)
							if ($aPromo[id_promocion] == $id_promocion) {
								$idx_promo = $idp;
								break;
							}
						// Si no localizamos la promo, no hay nada que hacer
						if (!isset($idx_promo)) continue;
						if ($this->debug) debug("La promo localizada es $idx_promo");
						$aPromo_det[$idx_act][idp] = $idx_promo;
						$aPromo_det[$idx_act][id_articulo] = $id_articulo;
						$aPromo_det[$idx_act][promocion] = $aPromo;
					} 

					$ratio_cant = floor($cantidad / $aPromo[cantidad]);

					// Almacenamos los articulos sin cargo de la promo de este articulo
					$aSearchFor = array();
					foreach ($aPromo[promo] as $id => $aArt) {
						$aTmp[id_articulo] = $aArt[id_articulo];
						$aTmp[cantidad] = $aArt[cantidad] * $ratio_cant;
						$aTmp[id_promo_det] = $id;
						array_push($aSearchFor,$aTmp);
					}
					if ($this->debug) {
						debug("Buscamos los siguiente productos sin cargo: ");
						print_r($aSearchFor);
					}

					// Buscamos los articulos de la promo desde el id detalle actual hasta el ultimo.
					$idx_orig = $idx_act;
					$first = TRUE;
					for ($idx_s = $this->next_detail(); isset($idx_s); $idx_s = $this->next_detail()) {
						if ((float)$this->get_price($idx_s)) break;

						if ($this->debug) debug("Searching in $idx_s ... npromo($idx_promo) art($id_articulo)");
						$id_art = $this->get_detail_article_id($idx_s);
						if (!$id_art) continue;
						foreach ($aSearchFor as $tmpid => $aArt) 
							if ($aArt[id_articulo] == $id_art) {
								if ($aArt[cantidad] == $this->get_quantity($idx_s)) {
									if ($this->debug) debug("Eureka($idx_s)!, coinciden las cantidades(".$this->get_quantity($idx_s).")");
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$id_articulo][$idx_promo][idx_det])) {
										array_push($this->_aOff_Promo[$id_articulo][$idx_promo][idx_det],$idx_act);
										$this->set_discount($idx_act,0,1,$aPromo[nombre],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$id_articulo][$idx_promo][promo][$aArt[id_promo_det]][$idx_act] = $idx_s;
									$this->set_discount($idx_s,0,1,$aPromo[nombre],TRUE);
									// Este detalle ya no es considerado como sin cargo (y perdido)
									array_push($aArt_depromo,$idx_s);
									// Dejamos de Buscar este articulo.
									$aSearchFor[$tmpid] = NULL;
									unset($aSearchFor[$tmpid]);
								}
							}
						if (!sizeof($aSearchFor)) break;
					}
					// Los no encontrados los guardamos para un segundo intento.
					if (is_array($aSearchFor) AND sizeof($aSearchFor))
						$aPromo_det[$idx_act][pendientes] = $aSearchFor;
					// Restablecemos el id detalle para continuar reconstruyendo los indices
					$this->set_active_detail($idx_orig);
				}
		}

		if (is_array($aArt_sincargo) AND sizeof($aArt_sincargo)) {
			if (is_array($aPromo_det)) {
				foreach ($aPromo_det as $idx_act => $aPromo) {
					if (is_array($aPromo[pendientes])) {
						if ($this->debug) debug("Cosillas pendientes en($idx_act)...");
						foreach ($aPromo[pendientes] as $id_pend => $aArt) {
							foreach($aArt_sincargo as $id_sincargo => $idx_) {
								if ($this->get_detail_article_id($idx_) == $aArt[id_articulo] 
										AND $this->get_quantity($idx_) == $aArt[cantidad]) {
									if ($this->debug) debug("Articulo($aArt[id_articulo]) encontrado en($idx_) la repesca!");
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][idx_det])) {
										array_push($this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][idx_det],$idx_act);
										$this->set_discount($idx_act,0,1,$aPromo[promocion][nombre],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][promo][$aArt[id_promo_det]][$idx_act] = $idx_;
									$this->set_discount($idx_,0,1,$aPromo[promocion][nombre],TRUE);
									// Borramos este articulo sin cargo, ya no esta perdido.
									$aArt_sincargo[$id_sincargo] = NULL;
									unset($aArt_sincargo[$id_sincargo]);
									$aPromo_det[$idx_act][pendientes][$id_pend] = NULL;
									unset($aPromo_det[$idx_act][pendientes][$id_pend]);
								}
							}
						}
						if (!is_array($aPromo_det[$idx_act][pendientes]) OR !sizeof($aPromo_det[$idx_act][pendientes])) {
							$aPromo_det[$idx_act] = NULL;
							unset($aPromo_det[$idx_act]);
						}
					} 
					if (!is_array($aPromo_det[$idx_act][pendientes])) {
						$aPromo_det[$idx_act] = NULL;
						unset($aPromo_det[$idx_act]);
					}

				}
			}
		}

		if (is_array($aArt_sincargo) AND sizeof($aArt_sincargo)) {
			if (is_array($aPromo_det)) {
				foreach ($aPromo_det as $idx_act => $aPromo) {
					if (is_array($aPromo[pendientes])) {
						if ($this->debug) debug("Cosillas pendientes en($idx_act)...");
						foreach ($aPromo[pendientes] as $id_pend => $aArt) {
							foreach($aArt_sincargo as $id_sincargo => $idx_) {
								if ($this->get_detail_article_id($idx_) == $aArt[id_articulo] ) {
									if ($this->debug) debug("Articulo($aArt[id_articulo]) encontrado en($idx_) la repesca-CHUNGA!");
									// Si no estaba indexada la promo, la indexamos en la raiz (art trigger)
									if (!in_array($idx_act,$this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][idx_det])) {
										array_push($this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][idx_det],$idx_act);
										$this->set_discount($idx_act,0,1,$aPromo[promocion][nombre],TRUE);
									}
									// insertar el indice de detalle de promo a linea de detalle
									$this->_aOff_Promo[$aArt[id_articulo]][$aPromo[idp]][promo][$aArt[id_promo_det]][$idx_act] = $idx_;
									$this->set_discount($idx_,0,1,$aPromo[promocion][nombre],TRUE);
									// Borramos este articulo sin cargo, ya no esta perdido.
									$aArt_sincargo[$id_sincargo] = NULL;
									unset($aArt_sincargo[$id_sincargo]);
									$aPromo_det[$idx_act][pendientes][$id_pend] = NULL;
									unset($aPromo_det[$idx_act][pendientes][$id_pend]);
								}
							}
						}
						if (!is_array($aPromo_det[$idx_act][pendientes]) OR !sizeof($aPromo_det[$idx_act][pendientes])) {
							$aPromo_det[$idx_act] = NULL;
							unset($aPromo_det[$idx_act]);
						}
					} 
					if (!is_array($aPromo_det[$idx_act][pendientes])) {
						$aPromo_det[$idx_act] = NULL;
						unset($aPromo_det[$idx_act]);
					}

				}
			}
		}
		// debug("Asi nos han kedao las promos:");
		// print_r($this->_aOff_Promo);
		debug("Asi nos han kedao los Indices:");
		print_r($this->_aDet_dbdel);
		return TRUE;
	}

	/****** Metodos Publicos:  ********/

	/**
	  * Metodo encargado de establecer el pedido como pedido tipo para este cliente.
	  * @param $bDo	- 	NULL, TRUE, FALSE
	  * @return bool 	- 	Caso de que se le mande NULL como parametro, devuelve si el pedido es tipo/standard o no.
	  *			-1 	-	Caso de Error.
	  **/
	function standard($bDo = NULL) 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return -1;
		}
		if (!isset($bDo) OR $bDo == NULL) return $this->_fPedido & inmPed_STANDARD;
		else {
			if ($bDo) $this->_fPedido |= inmPed_STANDARD;
			else $this->_fPedido |= ~inmPed_STANDARD;
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_COMMIT);
		}
	}

	/**
	  * Metodo para Generar un nuevo Pedido (con su referencia) a partir de un pedido ya existente.
	  **/
	function duplicate() 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return -1;
		}
		$this->set_reference(0);
		$this->set_date(0);
		$this->_change_flags(inmPed_CHG_MAIN | inmPed_DB_NEWRECORD);
	}

	/**
	  * Metodo encargado de Re-evaluar las condiciones de venta/compra. (re-obtener precios y dtos)
	  * @param $bCheck_dtos - Si se han de evaluar tambien los descuentos por linea de detalle.
	  **/
	function eval_conditions($bCheck_dtos = FALSE) 
	{
		if (!isset($bCheck_dtos)) $bCheck_dtos = FALSE;
		$this->set_reciever($this->get_reciever_id(),TRUE);
		$have_some = FALSE;
		if ($bCheck_dtos) {
			// Quitamos las ofertas de los detalles que las tengan.
			foreach ($this->_aOff_Promo as $idart => $aPromArt) {
				foreach ($aPromArt as $aPromo)
					if (is_array($aPromo['idx_det']))
						foreach ($aPromo['idx_det'] as $idx_)
							$this->set_discount($idx_,0,0,NULL,TRUE);
			}
			$this->_aOff_Promo = array();
			$this->_build_indexes();
			for($i = $this->first_detail(); isset($i); $i = $this->next_detail())
				if (!(float)$this->get_price($i) AND !$this->have_discount($i)) {
					debug("eval_conditios($bCheck_dtos) Borrando $i ...");
					$this->del_detail($i,FALSE);
				} elseif ($this->have_discount($i)) {
				}
		}
		for ($idx_det = $this->first_detail(); isset($idx_det); $idx_det = $this->next_detail()) {
			/** **/
			if (!$have_some) $have_some = TRUE;
			$aDet = $this->_get_article_conditions($this->get_detail_article_id($idx_det));
			$aDet['id_detalle'] = $this->_aDetalles[$idx_det]['id_detalle'];
			if (!$bCheck_dtos) {
				$aDto = $this->get_detail_discount($idx_det);
				if (isarray($aDto) AND sizeof($aDto)) {
					$aDet['descuento'] = $aDto['porciento'];
					$aDet['monto'] = $aDto['monto'];
					$aDet['tipo_descuento'] = $aDto['tipo'];
				}
				$cant = $this->get_quantity($idx_det);
				$this->_aDetalles[$idx_det] = $aDet;
				$this->set_quantity($idx_det,$cant);
			} else {
				$price = $this->get_price($idx_det);
				if (!(float)$price) continue;
				$cant = $this->get_quantity($idx_det);
				$this->_aDetalles[$idx_det] = $aDet;
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
				/** **/
			}
			/** **/
		
			$this->_aModif['detalles'][$idx_det] |= (inmPed_CHG_DET_QUANTITY | inmPed_DET_PRICE) | inmPed_CHG_DET_DISCOUNT;
		}
		if ($have_some)
			$this->_change_flags(inmPed_CHG_DETAIL | inmPed_MODIFIED);
	}

	/**
	  * Metodo encargado de convertir un presupuesto en pedido.
	  **/
	function convert_to_order() 
	{
			  /** **
        if(isset($id_presupuesto)){
                $row33[0] = $id_presupuesto;
                $consulta = "update Lineas_detalle set id_presupuesto=0 where id_presupuesto = $id_presupuesto";
                $Sesion->query($consulta);
        }
		  /** **/
	}

	/**
	  * Parche para volcar un pedido a factura sin hacer ningun calculo. Usar junto con dbfill()
	  **/
	function dbdump_invoice($aFra = NULL) 
	{
		$this->_calculate_totals();
		if (!is_array($this->_aIDFactura)) {
			$this->set_status(1);
			$this->dbdump();

		// debug("TotaleX : ");
			//print_r($aFra);
			if ((int)$aFra['id_forma_pago']) $this->set_payment_method($aFra['id_forma_pago']);
			if (!empty($aFra['observaciones'])) $notas = $aFra['observaciones'];
			if (!empty($aFra['referencia_externa'])) $ref_externa = $aFra['referencia_externa'];
			if (!empty($aFra['referencia'])) $ref = $aFra['referencia'];
			else $ref = NULL;

			if ($this->_fPedido & inmPed_VENTA) $venta = 1;
			else $venta = 0;
			if (!empty($aFra['id_serie'])) $id_serie = (int)$aFact['id_serie'];
			else {
				$cons = "SELECT id_serie,contador FROM Series_facturacion WHERE ventas = $venta ORDER BY contador desc LIMIT 1";
				$tmprs = $this->_db->query($cons);
				if (!$this->_db->num_rows($tmprs)) return 0;
				$aTmp = $this->_db->fetch_row($tmprs);
				$aFra['id_serie'] = $id_serie = $aTmp[0];
				$this->_db->libera($tmprs);
			}

			$aFact = array(
						"id_forma_pago" => $this->_aPedido['id_forma_pago'],
						"id_tarifa" => $this->_aPedido['id_tarifa'],
						"id_proveedor" => $this->_aPedido['id_proveedor'],
						"id_serie" => $id_serie, // Obtener de la DB la mas usada
						"id_divisa" => $this->_aPedido['id_divisa'],
						"id_cliente" => $this->_aPedido['id_cliente'],
						"id_empresa" => $this->_aPedido['id_empresa'],
						"referencia" => $ref,
						"referencia_externa" => $ref_externa,
						"monto_cuenta" => 0, 
						"descuento" => $this->_aTotales['descuentos'],
						"base_imponible" => $this->_aTotales['base_imponible'],
						"total_impuestos" => $this->_aTotales['impuestos'] + $this->_aTotales['recargos'],
						"retenido" => $this->_aTotales['retenido'],
						"monto_total" => $this->_aTotales['importe'],
						"notas" => $notas,
						"fecha" => date("Y-m-d H:i:s"),
						"estado" => 0,
						"factura_abono" => 0,
						"ratio_divisa" => $this->_aDivisa['ratio'],
						"contabilizado" => 0
								 );

			// Referencia:
			$cons = 	"SELECT ".
					 	"prefijo_fact_".( ($venta) ? 'ventas' : 'compras')." as 'prefijo_fact', ".
						"sufijo_fact_".( ($venta) ? 'ventas' : 'compras')." as 'sufijo_fact', ".
						"digitos_fact_".( ($venta) ? 'ventas' : 'compras')." as 'digitos_fact'".
						"FROM  Empresas WHERE id_empresa = ".$this->_aPedido['id_empresa'];
			$rs = $this->_db->query($cons);
			$aPref = $this->_db->fetch_array($rs);
			$this->_db->libera($rs);

			//e incrementar el contador de la serie
			$consulta = "select contador , nombre from  Series_facturacion where id_serie = $id_serie";
			$rs=$this->_db->query($consulta);
			$aSerie=$this->_db->fetch_array($rs);

			//relleno de digitos para la numeracion del pedido
			$temporal = pow(10,( (int) $aPref['digitos_fact'] ));
			$temporal += $aSerie['contador'];
			$t = substr((string)$temporal,1);

			// Fixme: Quitar todos los '-' de la composicion tanto de referencias como de facturas.
			$aFact['referencia'] = (!empty($aSerie['nombre']) ? $aSerie['nombre'] : "").
					$aPref['prefijo_fact'].$t.(!empty($aPref['sufijo_fact']) ? $aPref['sufijo_fact'] : "");
			$cons = "update Series_facturacion set contador = contador + 1 where id_serie = $id_serie";
			$this->_db->query($cons);

			// Falta la referencia y la serie.
			// debug("La factura!");
			// print_r($aFact);
			$this->_db->tb_replace("Facturas",$aFact);
			$aFact[id_factura] = $this->_db->last_insert_id();
			// salida("Factura $aFact[referencia] CREADA correspondiente al pedido ".$this->_aPedido[referencia]."<br/>\n");

			$aPedFact['id_pedido'] = $this->_aPedido['id_pedido'];
			$aPedFact['id_factura'] = $aFact['id_factura'];
			// debug("La relacion ped-fact :");
			// print_r($aPedFact);
			$this->_db->tb_replace("Pedidos_facturas",$aPedFact);

			$cons = "INSERT INTO Facturas_detalle (id_factura,id_detalle,cantidad) ".
					  //"SELECT ".$aFact[id_factura].",id_detalle,IF(cantidad_recibida,cantidad_recibida,cantidad) FROM Lineas_detalle ".
					  "SELECT ".$aFact['id_factura'].",id_detalle,cantidad FROM Lineas_detalle ".
					  "WHERE id_pedido = ".$this->_aPedido['id_pedido'];
			$this->_db->query($cons);
			// debug($cons);

			$cons = "UPDATE IVAs set id_factura = ".$aFact['id_factura']." WHERE id_pedido = ".$this->_aPedido['id_pedido'];
			$this->_db->query($cons);
			// debug($cons);

			$cons = "UPDATE Descuentos set id_factura = ".$aFact['id_factura']." WHERE id_pedido = ".$this->_aPedido['id_pedido'];
			$this->_db->query($cons);
			// debug($cons);
				/** Las comisiones **/
			$Agente = $this->get_agent();
			if (is_array($Agente) AND sizeof($Agente) AND is_numeric($Agente['id_agente'])) {
				$Agente['comision'];
				$Agente['comision_repartida'];
				$AgFra['id_agente'] = $Agente['id_agente'];
				$AgFra['id_factura'] = $aFact['id_factura'];
				$AgFra['comision'] = $Agente['comision'];
				$AgFra['monto'] = $Agente['comision'] * $aFact['base_imponible'] / 100;
				$this->_db->tb_replace("Agentes_facturas",$AgFra);
			}

				/** Acto seguido Los Efectos **/
			// print_r($this->_aFPago);
			if (is_array($this->_aFPago)) {
				$monto = $aFact['monto_total'] / $this->_aFPago['num_efectos'];
				$dias = array();
				if (!empty($this->_aFPago['dia_I'])) $dias[] = $this->_aFPago['dia_I'];
				if (!empty($this->_aFPago['dia_II'])) $dias[] = $this->_aFPago['dia_II'];
				if (!empty($this->_aFPago['dia_III'])) $dias[] = $this->_aFPago['dia_III'];
				sort($dias,SORT_NUMERIC);

				for ($i = 1; $i <= $this->_aFPago['num_efectos']; $i++) {
					$en_dias = $i * $this->_aFPago['ias_efectos'];
					if (!is_array($dias) OR empty($dias) OR !sizeof($dias))
						$str_fecha = "DATE_ADD(NOW(),INTERVAL $en_dias DAY)";
					else {
						$fecha_est = strtotime("+$en_dias day");
						$dia_est = strftime("%d",$fecha_est);
						$last = end($dias);
						reset($dias);
						if ($dia_est > $last) {
							$fecha_final = strtotime("+1 month",$fecha_est);
							$next_day = $dias[0];
							$fecha_final = strtotime("-".($dia_est-$next_day)." day",$fecha_final);
						} else {
							foreach ($dias as $dia) 
								if (!$next_day OR $next_day < $dia) $next_day = $dia;
								else continue;
							$fecha_final = strtotime("+".($next_day-$dia_est)." day",$fecha_est);
						}
						$str_fecha = strftime("%Y-%m-%d %H:%M",$fecha_final);
						$str_fecha = "'$str_fecha'";
					}
					$cons = "INSERT INTO Efectos (id_factura,concepto,fecha_vencimiento,monto,pago_cobro,medio_pago) ".
								"VALUES (".$aFact['id_factura'].",'Su Fra Nº ".$aFact['referencia'].
								"',$str_fecha,$monto,1,'".$this->_aFPago['medio_pago']."')";
					$this->_db->query($cons);
				}
			}

		} else {
			foreach ($this->_aIDFactura as $aFac) $refs .= ((!empty($refs)) ? ", " : "").$aFac['referencia'];
			salida("Sorry, Pedido ".$this->_aPedido['referencia']." fue Facturado en : ".$refs);
		}

	}

	function dbfill($id_pedido) 
	{
		if (!is_object($this->_db)) return 0;
		if (!(int)$id_pedido) return 0;
		$oDb = $this->_db;

		if ($this->_fPedido & inmPed_VENTA) {
			if (!$this->_dbfetch_sale_headders($id_pedido)) {
				$this->error(315,'No se ha podido obtener las Cabeceras del pedido.');
				return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchase_headders($id_pedido)) {
				$this->error(315,'No se ha podido obtener las Cabeceras del pedido.');
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
		$cons = "SELECT id_albaran,referencia,preparado,enviado,confirmacion,devolucion FROM Albaranes WHERE id_pedido = ".$id_pedido;
		$idrs = $oDb->query($cons);
		$hay_albaranes = (int)$oDb->num_rows($idrs);
		if ($hay_albaranes) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) $aAlb[$clave] = $valor;
				$this->_aIDAlbaran[$aTmp['id_albaran']] = $aAlb;
			}
		}
		$oDb->libera($idrs);

		// Comprobamos la existencia de Facturas 
		$cons = "SELECT F.id_factura,F.referencia,F.estado FROM Facturas F, Pedidos_facturas P ".
					"WHERE F.id_factura=P.id_factura AND P.id_pedido = ".$id_pedido;
		$idrs = $oDb->query($cons);
		$hay_facturas = (int)$oDb->num_rows($idrs);
		if ($hay_facturas) {
			while ($aTmp = $oDb->fetch_assoc($idrs)) {
				foreach($aTmp as $clave => $valor) $aFac[$clave] = $valor;
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
				  "I.monto as 'base_imponible', ".
				  "I.recargo_iva as 'total_iva', ".
				  "I.recargo_equivalente as 'total_recargo', ".
				  "TI.porcentaje as 'porciento', ".
				  "TI.recargo_equivalente as 'recargo_eq' ".
				  "FROM IVAs I, Tipos_IVA TI ".
				  "WHERE I.id_pedido = $id_pedido AND I.id_iva = TI.id_iva order by id_iva desc";
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			$recalcular_iva = FALSE;
			while($aTmp = $oDb->fetch_assoc($rs)) {
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
				  "monto_base as 'base_imponible', ".
				  "porcentaje as 'descuento', ".
				  "nombre as 'nombre', ".
				  "monto_final as 'importe' ".
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
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_MODIFIED);
			$this->_aDescuentos['detalle'] = NULL;
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
				$this->error(315,'No se ha podido obtener las Cabeceras del pedido.');
				return FALSE;
			}
		} else {
			if (!$this->_dbfetch_purchaseorder_details($id_pedido)) {
				$this->error(315,'No se ha podido obtener las Cabeceras del pedido.');
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
	function dbdump() 
	{
		$this->debug = 1;
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
				$this->error(550,"No se puede volcar el pedido a la DB sin direccion de entrega.");
				return FALSE;
			}
		}
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
				foreach ($this->_aDetalles as $idx => $aNull)
					$this->del_detail($idx,FALSE);
debug("Borrando en pedidos y pedidos_facturas el id: ".$this->_aPedido['id_pedido']);
if (1) {
				$this->_db->tb_delete("Pedidos",array("id_pedido" => $this->_aPedido['id_pedido']));
				$this->_db->tb_delete("Pedidos_facturas",array("id_pedido" => $this->_aPedido['id_pedido']));
}
				if ($this->debug) 
					debug("Molaria resetear el contador caso de ser el ultimo pedido realizado (".(int)$this->_aPedido['referencia'].")");

				// En el modo estricto, el borrado tambien lo es. No hay pedido, tampoco fact ni albaran.
				if ($this->_fPedido & inmPed_STRICT) {
					// Borrar las facturas que no esten Emitidas.
					if (is_array($this->_aIDFactura))
						foreach ($this->_aIDFactura as $aFac)
							if ((int)$aFac['estado'] != 1) {
								if (!is_array($aFac_list)) $aFac_list = array();
								array_push($aFac_list,array("id_factura" => $aFac['id_factura']));
							}
					if (is_array($aFac_list)) {
debug("Borrando Pedidos_facturas, facturas facturas_detalle, descuentos e IVAs");
print_r($aFact_list);
if(1) {
						$this->_db->tb_delete("Pedidos_facturas",$aFac_list);
						$this->_db->tb_delete("Facturas",$aFac_list);
						$this->_db->tb_delete("Facturas_detalle",$aFac_list);
						$this->_db->tb_delete("Descuentos",$aFac_list);
						$this->_db->tb_delete("IVAs",$aFac_list);
}
					}

					// Borrar los albaranes que no esten confirmados.
					if (is_array($this->_aIDAlbaran))
						foreach ($this->_aIDAlbaran as $aAlb)
							if ((int)$aAlb['confirmacion'] != 1) {
								if (!is_array($aAlb_list)) $aAlb_list = array();
								array_push($aAlb_list,array("id_albaran" => $aAlb['id_albaran']));
							}
					if (is_array($aAlb_list)) {
debug("Borrando Albaranes y Detalles_albaran:");
print_r($aAlb_list);
if (1) {
						$this->_db->tb_delete("Albaranes",$aAlb_list);
						$this->_db->tb_delete("Detalles_albaran",$aAlb_list);
}
					}

				}
			} elseif ($this->_aFlags['pedido'] & inmPed_DB_COMMIT) {
				if ($this->debug) debug("Buscando numeracion para la referencia y la fecha...");
				$ref = $this->get_reference();
				if (empty($ref)) $this->set_reference();
				$date = $this->get_date();
				if (empty($date)) $this->set_date();
				if ($this->_aFlags['pedido'] & inmPed_DB_NEWRECORD)
					$this->_aPedido['id_pedido'] = NULL;
				if ($this->_fPedido & inmPed_VENTA) 
					if (!is_numeric($this->_aPedido['id_direccion']) OR empty($this->_aPedido['id_direccion'])) {
						$this->error(415,"Pedido de Venta sin Direccion de Entrega.");
						return FALSE;
					} else {
						$this->_aPedido['id_proveedor'] = NULL;
					}
				else 
					if (!is_numeric($this->_aPedido['id_proveedor']) OR empty($this->_aPedido['id_proveedor'])) {
						$this->error(415,"Pedido de Compra sin Proveedor asignado.");
						return FALSE;
					} else {
						$this->_aPedido['id_direccion'] = NULL;
					}
				// TODO: Comprobar que el ratio es el que tiene que ser (junto con el dbfill)
				$this->_aPedido['ratio_divisa'] = $this->_aDivisa['ratio'];

				if ((int)$this->_aPedido['id_pedido']) {
					if ($this->debug) debug("Updateamos el pedido...");
print_r($this->_aPedido);
if (1) {
					$this->_db->tb_update("Pedidos",$this->_aPedido);
}
				} else {
					if ($this->debug) debug("Insertando un nuevo pedido en la db...");
print_r($this->_aPedido);
if (1) {
					$this->_db->tb_replace("Pedidos",$this->_aPedido);
					$this->_aPedido['id_pedido'] = $this->_db->last_insert_id();
} else $this->_aPedido['id_pedido'] = 666;
				}
			}
			$this->_change_flags(inmPed_CHG_MAIN | inmPed_OK);

			// Fixme: Hacer comprobacion e insertar en Pedidos tipo (tambien de compras!)
			if( $this->_fPedido & inmPed_STANDARD ){
				$aTmp['id_cliente'] = $this->get_reciever_id();
				$aTmp['id_empresa'] = $this->get_issuer_id();
				$aTmp['id_pedido'] = $this->get_id();
				$aTmp['nombre'] = $this->get_name();
				if (empty($aTmp['nombre'])) $aTmp['nombre'] = "Pedido Tipo Sin Nombre";
debug("Pedidos tipo.... ");
print_r($aTmp);
if (1) {
				$this->_db->tb_replace("Pedidos_tipo_cliente",$aTmp);
}
			}
		} elseif ($this->debug) debug("La cabecera del pedido no se ha tocado...");

		if ( ($this->_aFlags['calculos_iva'] & inmPed_DB_COMMIT) ) {
			if ($this->debug) debug("Volcamos los ivas...");
			if ($this->_aFlags['calculos_iva'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_pedido']) {
				$cons = "DELETE FROM IVAs WHERE (!id_factura OR id_factura IS NULL OR id_factura=0) AND ".
							" id_pedido = ".$this->_aPedido['id_pedido'];
debug("query: $cons");
if (1) {
				$this->_db->query($cons);
}
			} elseif ((int)$this->_aPedido['id_pedido']) {
				$this->_build_taxes();
				if (is_array($this->_aIVAs['detalle']))
					foreach ($this->_aIVAs['detalle'] as $id_iva => $aIva) {
						$aIva['id_iva'] = $id_iva;
						$aIva['id_pedido'] = $this->_aPedido['id_pedido'];
						// $aIva[id_factura] = $this->_aPedido[id_factura];
						$aIva['monto'] = $aIva['base_imponible'];
						$aIva['recargo_iva'] = $aIva['total_iva'];
						$aIva['recargo_equivalente'] = $aIva['total_recargo'];
						if ($this->debug) print_r($aIva);
if (1) {
						$this->_db->tb_replace("IVAs",$aIva);
}
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
debug("Borrando ivAs ,,");
print_r($aIva_del);
if (1) {
							$this->_db->tb_delete("IVAs",$aIva_del);
}
						} else {
							$aTmp['id_pedido'] = 0;
							$aTmp['id_iva'] = $aIva_del['id_iva'];
							$aTmp['id_factura'] = $aIva_del['id_factura'];
							$aFld[] = "id_factura";
							$aFld[] = "id_iva";
debug ("Update de IVAs ...");
print_r($aTmp);
if (1) {
							$this->_db->tb_update("IVAs",$aTmp,$aFld);
}
						}
					}
			} else $this->error(404,"Me falta el id de Pedido para insertar los IVAs en la bbdd.");
			$this->_change_flags(inmPed_CHG_TAXES | inmPed_OK);
		} else if ($this->debug) debug("Los IVAs no se han tocado...");

debug("<b>INICIAMOS LOS DESCUENTOS</b>");
		if ($this->_aFlags['descuentos'] & inmPed_DB_COMMIT) {
			if ($this->debug) debug("Volcamos los descuentos...");
			if ($this->_aFlags['descuentos'] & inmPed_DB_DELETE AND (int)$this->_aPedido['id_pedido']) {
				$cons = "DELETE FROM Descuentos WHERE (!id_factura OR id_factura IS NULL OR id_factura=0) AND ".
							" id_pedido = ".$this->_aPedido['id_pedido'];
debug("query : $cons");
if (1) {
				$this->_db->query($cons);
}
			} elseif ((int)$this->_aPedido['id_pedido']) {
				if (!is_array($this->_aDescuentos['detalle'])) $this->calculate();
				if (is_array($this->_aDescuentos['detalle']))
					foreach($this->_aDescuentos['detalle'] as $aDto) {
						$aDto['id_pedido'] = $this->_aPedido['id_pedido'];
						$aDto['id_factura'] = $this->_aPedido['id_factura'];
						$aDto['monto_base'] = $aDto['base_imponible'];
						$aDto['porcentaje'] = $aDto['descuento'];
						$aDto['monto_final'] = $aDto['importe'];
						if ($this->debug) debug("Replace de descuentos:");
						if ($this->debug) print_r($aDto);
if (1) {
						$this->_db->tb_replace("Descuentos",$aDto);
}
					}
				elseif ($this->debug) debug("No hay Dscuentos que volcar...");
			} else $this->error(404,"PK de Pedido not found");
			$this->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_OK);
		} else if ($this->debug) debug("Los DESCUENTOS NO se han tocado...");
debug("<hr>");

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
				} elseif ($estado & inmPed_DB_COMMIT) {
					if ($this->debug) debug("Detalle $idx_det no actualizado");
					$aTmp = $this->get_detail($idx_det);
					$this->_aDetalles[$idx_det]['id_pedido'] = $aTmp['id_pedido'] = $this->_aPedido['id_pedido'];
					$aTmp['cantidad'] = $aTmp['cantidad_pedida'];
					$aTmp['precio_articulo'] = $aTmp['precio_tarifa'];
					$aTmp['monto_total'] = $aTmp['base_imponible'];
					if ($this->debug) debug("Linea de detalle");
					if ($this->debug) print_r($aTmp);

					if (!(int)$aTmp['id_detalle']) {
						if ($this->debug) debug("Detalle $idx_det No esta en la DB. Actualizando indices...");
if (1) {
						$this->_db->tb_replace("Lineas_detalle",$aTmp);
}
						$this->_aDetalles[$idx_det]['id_detalle'] = (int)$this->_db->last_insert_id();
						$this->_aDetIdx[$this->_aDetalles[$idx_det]['id_detalle']] = $idx_det;
					} else {
if (1) {
						$this->_db->tb_update("Lineas_detalle",$aTmp);
}
					}
					// Actualizamos la cantidad que hay ahora mismo en la DB.
					if (is_numeric($this->_aDet_dbdel[$idx_det]['cantidad_db']))
						$cant_org = $this->_aDet_dbdel[$idx_det]['cantidad_db'];
					else $cant_org = 0;
					if (is_numeric($aTmp['cantidad_pedida']))
						$cant_act = $aTmp['cantidad_pedida'];
					else $cant_act = 0;
					if ($cant_org != $cant_act) {
						$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
									"WHERE id_articulo = ".$aTmp['id_articulo']." AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
debug ("query : $cons");
if (1) {
						$this->_db->query($cons);
}
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
							"FROM Lineas_detalle Li, Detalles_albaran DA, Albaranes Alb ".
							"WHERE DA.id_detalle = Li.id_detalle AND DA.id_albaran = Alb.id_albaran AND Alb.id_pedido = ".$this->get_id();
debug("query : $cons");
if(1) {
				$idrs = $this->_db->query($cons);
}
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
				// Comprobamos los detalles de nuestro Albaran.
				$cons = "SELECT DISTINCT Li.id_detalle as 'id_detalle' ".
							"FROM Lineas_detalle Li, Facturas_detalle DF, Facturas Fac, Pedidos_facturas PF ".
							"WHERE DF.id_detalle = Li.id_detalle AND DF.id_factura = Fac.id_factura AND ".
							"Fac.id_factura = PF.id_factura AND PF.id_pedido = ".$this->get_id();
debug("query : $cons");
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
					if (is_numeric($this->_aDet_dbdel[$id]['cantidad_pedida']))
						$cant_act = $this->_aDet_dbdel[$id]['cantidad_pedida'];
					else $cant_act = 0;
					$id_art = (int)$this->_aDet_dbdel[$id]['id_articulo'];
					$id_det = (int)$this->_aDet_dbdel[$id]['id_detalle'];
					if ($cant_org != $cant_act) {
						$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio $op_sign ($cant_org - $cant_act) ".
									"WHERE id_articulo = $id_art AND id_empresa = ".(int)$this->_aPedido['id_empresa'];
debug("query : $cons");
if (1) {
						$this->_db->query($cons);
}
					}
					array_push($aDelete_Det,array('id_detalle' => $id_det));
					if ($this->debug) debug("Detalle borrado($id_det), Actualizando stock...");
				} else if ($this->debug) debug("solicitud de borrado de un detalle($id) sin id_detalle...");
			}
			if (is_array($aDelete_Det)) $this->_db->tb_delete("Lineas_detalle",$aDelete_Det);
			$this->_change_flags(inmPed_CHG_DETAIL | inmPed_OK);
		} else if ($this->debug) debug("Los DETALLES NO se han tocado");
$this->debug=0;

	} // Fin del dbdump()

	/**
	  * Metodo encargado de devolver el puntero al primer detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function first_detail($bSetPointer = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
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
	function next_detail($bSetPointer = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
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
	function set_active_detail($idx_det) 
	{
		if (!is_array($this->_aDetalles[$idx_det])) return FALSE;
		$this->_DetIdx_act = $idx_det;
		return TRUE;
	}

	/**
	  * Este metodo obtiene el actual detalle indicado por el puntero a las lineas de detalle.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function current_detail() 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
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
	function prev_detail($bSetPointer = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
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
	function last_detail($bSetPointer = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
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
	  * @param 	$id_art			Articulo que se quiere anyadir al pedido.
	  * @param 	$cantidad	-	Cantidad del articulo que se desea insertar.
	  * @param 	$bBultos		-	Indicativo de si la cantidad indicada son bultos o unidades. (unidades predefinido)
	  * @param 	$bCheck_dtos	Indicativo de si se han de comprobar los descuentos de cliente, ofertas y promos para el articulo.
	  * @param 	$force_idx	-	Identificador de detalle en el que colocar el articulo si no existe.
	  **/
	function add_detail($id_art,$cantidad = NULL,$bBultos = 0,$bCheck_dtos = TRUE,$force_idx = NULL) 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		$id = (int)$id_art;
		if (!$id) return 0;
		if (!isset($bCheck_dtos)) $bCheck_dtos = TRUE;
		if (!isset($bBultos)) $bBultos = 0;
		if ($this->debug) 
			debug("add_detail del Art $id_art - Uds $cantidad  - ChkDtos($bCheck_dtos) EnBultos($bBultos) Force($force_idx)");

		// Obtenemos las condiciones de compra/venta:
		$fila = $this->_get_article_conditions($id_art);
		if (!$fila) return 0;

		if (is_numeric($cantidad )) {
			if (is_integer($cantidad)) $cantidad = (int)$cantidad;
			else $cantidad = round($cantidad,$this->op_decimals);
		} else $cantidad = (int)$cantidad;
		if (!$bBultos) $fila['cantidad_pedida'] = $cantidad;
		else{
			if ($bBultos == 1 AND (int)$fila['unidades_bulto']) {
		  		$fila['cantidad_pedida'] = $cantidad * $fila['unidades_bulto'];
			} elseif ($bBultos==2 AND (int)$fila['unidades_bulto'] 
					AND (int)$fila['bultos_capa_palet']) {
				$fila['cantidad_pedida'] = $cantidad * (int)$fila['unidades_bulto'] * (int)$fila['bultos_capa_palet'];
			} elseif ($bBultos==3 AND (int)$fila['unidades_bulto']
					AND (int)$fila['bultos_capa_palet'] AND (int)$fila['capas_palet']) {
				$fila['cantidad_pedida'] = $cantidad * (int)$fila['unidades_bulto'] * (int)$fila['bultos_capa_palet']
									* (int) $fila['capas_palet'];
			} else $fila['cantidad_pedida'] = $cantidad;
		}

		// Fixme: Falta meter en un array los posibles servicios por articulo, en plan ofertas. (otro metodo? -check_servicios-)

		if ($force_idx AND !is_array($this->_aDetalles[$force_idx])) {
			$idx_det = $force_idx;
			// if ((int)$this->_aDet_dbdel[$idx_des][id_detalle])
				// $this->_aDetalles[$idx_det][id_detalle] = $this->_aDet_dbdel[$idx_det][id_detalle]; 
			// $this->_aModif[detalles][$idx_det] |= inmPed_DB_DELETE;
			// $this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
		} else {
			$idx_det = $this->last_detail(FALSE);
			$idx_det++;
		}

		if ($this->debug) debug("add_detail() Insertando posicion $idx_det");
		$fila['peso'] = $fila['cantidad_pedida'] * $fila['peso_unidad'];
		$this->_aDetalles[$idx_det] = $fila;
		//Fixme: TODO Ojo con los indices aki!!!
		if ($force_idx AND $force_idx = $idx_det) ksort($this->_aDetalles);

		if (!is_array($this->_aDetIdx_Art[(int)$fila['id_articulo']]) OR 
							 !in_array($idx_det,$this->_aDetIdx_Art[(int)$fila['id_articulo']]))
			$this->_aDetIdx_Art[(int)$fila['id_articulo']][] = $idx_det;

		$this->_aModif['detalles'][$idx_det] |= (inmPed_CHG_DET_QUANTITY | inmPed_DET_PRICE) | inmPed_CHG_DET_DISCOUNT;
		$this->_change_flags(inmPed_CHG_DETAIL | inmPed_MODIFIED);

		// Fixme: la comprobacion de ofertas molaria tenerlas en un solo query con un inner join
		// Buscar los descuentos del cliente por articulo y luego familia
		// Si el cliente no tiene descuento ni por articulo ni por familia se comprueba
		//	 primero las ofertas por articulo y luego las de familia (generales ambas)
		if ($bCheck_dtos) {
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
	  * @return	bool		- 	Si la operacion se ha realizado con exito o no.
	  **/
	function del_detail($idx_det = NULL,$bDtos = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!isset($idx_det)) $idx_det = $this->_DetIdx_act;
		if (!isset($bDtos)) $bDtos = TRUE;

		if ($this->debug) debug(" del_detail($idx_det) ");
		if (!is_array($this->_aDetalles[$idx_det])) return FALSE;
		if ($this->debug) debug(" del_detail($idx_det) --> Existe! ");

		if ($bDtos AND ($aOff = $this->check_offers($idx_det))) {
			if ($this->debug) debug("del_detail($idx_det) de una oferta...");
			if (is_array($aOff[promo]))
				foreach ($aOff[promo] as $aArt) {
					if (!is_numeric($aArt[$idx_det])) continue;
					$SinCargo = $aArt[$idx_det];
					if ($this->debug) {
						debug("Borrando($idx_det) Idxs...");
						print_r($aSinCargo);
					}
					$this->del_detail($SinCargo,FALSE);
				}
		}

		if ((int)$this->_aDetalles[$idx_det][id_detalle]) {
			// Marcamos el registro para ser borrado de la base de datos.
			$this->_aModif[detalles][$idx_det] |= inmPed_DB_DELETE;
			$this->_aModif[detalles][$idx_det] |= inmPed_DB_COMMIT;
			$this->_aDet_dbdel[$idx_det][id_detalle] = $this->_aDetalles[$idx_det][id_detalle];
			$this->_aDet_dbdel[$idx_det][id_articulo] = $this->_aDetalles[$idx_det][id_articulo];
			$this->_aDet_dbdel[$idx_det][cantidad_total] = $this->_aDetalles[$idx_det][cantidad_total];
			$this->_aDet_dbdel[$idx_det][cantidad_recibida] = $this->_aDetalles[$idx_det][cantidad_recibida];
		} else {
			$this->_aModif[detalles][$idx_det] &= ~inmPed_DB_COMMIT;
		}

		// Borramos el registro de las lineas de detalle. (moviendo si es preciso el puntero a los detalles).
		// Nos cepillamos los indices que apuntente a esta linea de detalle.
		$id_detalle = $this->_aDetalles[$idx_det][id_detalle];
		$this->_aDetIdx[$id_detalle] = NULL;
		unset($this->_aDetIdx[$id_detalle]);
		$this->_aDetIdx_Art[$this->_aDetalles[$idx_det][id_articulo]] = array_diff(
						$this->_aDetIdx_Art[$this->_aDetalles[$idx_det][id_articulo]],array($idx_det));

		$this->_aDetalles[$idx_det] = NULL;
		unset($this->_aDetalles[$idx_det]);

		$this->_change_flags(inmPed_CHG_MAIN | inmPed_CHG_DETAIL | inmPed_MODIFIED);
	}

	/**
	  * Metodo para comprobar si una linea de detalle tiene descuento o no.
	  * @param $idx_det	-	Identificador de la linea de detalle sobre la cual se quiere hacer la comprobacion.
	  * @return bool		-	Devuelve si tiene o no descuento la linea.
	  */
	function have_discount($idx_det) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!is_array($this->_aDetalles[$idx_det])) return FALSE;
		if ($this->debug) {
			debug("have_discount($idx_det)");
			debug("dto : ".$this->_aDetalles[$idx_det][descuento].
					"monto : ".$this->_aDetalles[$idx_det][monto].
					"tipo : ".$this->_aDetalles[$idx_det][tipo_descuento]);
		}
		if ((float)$this->_aDetalles[$idx_det][descuento] OR (float)$this->_aDetalles[$idx_det][monto] 
					OR !empty($this->_aDetalles[$idx_det][tipo_descuento])) return TRUE;
		else return FALSE;
	}

	/**
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param 	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto		 	Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  **/
	function check_client_discount($idx_det,$bCommit = TRUE) 
	{
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		$idx_det = (int)$idx_det;
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		if (!isset($bCommit)) $bCommit = TRUE;
		if ($this->debug) debug("Comprobando descuentos de cliente ($bCommit)...");

		if ($this->_fPedido & inmPed_VENTA) {
			$id_empresa = $this->_aPedido[id_empresa];
			$id_cliente = $this->_aPedido[id_cliente];
			$id_articulo = $this->_aDetalles[$idx_det][id_articulo];
			$oDb = $this->_db;

			$fila = NULL;
			  //descuento por cliente y articulo
			$consulta = "Select descuento , monto  FROM Cliente_articulos ".
						  "WHERE id_articulo = $id_articulo and id_empresa = $id_empresa and id_cliente = $id_cliente";
			$resul4 = $oDb->query($consulta);
			if ($oDb->num_rows($resul4)) {
				$row4 = $oDb->fetch_array($resul2);
				if($row4[descuento] > 0 ){
					$fila[descuento] = $row4[descuento];
					$fila[tipo_descuento] = $row4[descuento] .  " % Cli/Art";
					$fila[is_pto]	= TRUE;
				} elseif($row4[monto] > 0){
					$fila[monto] = $row4[monto];
					$fila[tipo_descuento] = $row4[monto] . " " .  $leyenda_divisa . " Cli/Art ";
					$fila[is_pto]	= FALSE;
				}
			} else { // Si no hay descuento por articulo, miramos a ver por familia.
				//descuento por familia de articulos y cliente
				$consulta = "Select descuento from Cliente_familia_articulos , Articulos
						 where Articulos.id_articulo = $id_articulo and Cliente_familia_articulos.id_empresa = $id_empresa
						 and Cliente_familia_articulos.id_cliente = $id_cliente
						 and Cliente_familia_articulos.id_familia = Articulos.id_familia";
				$resul2 = $oDb->query($consulta);
				$row2 = $oDb->fetch_array($resul2);
				if(!isset($fila[descuento]) AND !isset($fila[monto]) )
						 if($row2[descuento] > 0) {
									$fila[descuento] = $row2[descuento];
									$fila[tipo_descuento] = $row2[descuento] . " % Cli/Fam";
									$fila[is_pto]	= TRUE;
						 }
			}
			if (is_array($fila) AND $bCommit) {
				// FALSE es para que no lo inserte caso de ya existir un descuento.
				$this->set_discount($idx_det,$fila[descuento],$fila[is_pto],$fila[tipo_descuento],FALSE);
			}
			// debug("Todos los detalles: ");
			// print_r($this->_aDetalles);
		} else { // Descuentos por articulo en _compra_
			$fila = NULL;
		}
		return $fila;

	}

	/**
	  * Comprueba los descuentos generales por familia de articulo.
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param 	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto		 	Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  */
	function check_family_discount($idx_det,$bCommit = TRUE) 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
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
		if(!isset($fila[descuento]) AND !isset($fila[monto]) )
					 if($row8[descuento] > 0){
								$fila[descuento] = $row8[descuento];
								$fila[tipo_descuento] =  $row8[descuento] . " % Fam";
								$fila[is_pto] = TRUE;
					 }
		if (is_array($fila) AND $bCommit) {
			// FALSE es para que no lo inserte caso de ya existir un descuento.
			$this->set_discount($idx_det,$fila[descuento],$fila[is_pto],$fila[tipo_descuento],FALSE);
		}
		return $fila;
	}

	/**
	  * @param 	$idx_det 	Identificador del detalle de pedido sobre el cual se ha de comprobar si tiene oferta o promocion
	  * @param 	$bCommit 	Indica si se ha de modificar el pedido o no.
	  * @return $aOffPromo 	Devueve la oferta o promocion con la cantidad minima para atenerse a la misma.
	  *				[id_promocion]		-	Identificador de la promocion en la db
	  *				[nombre]				-	Nombre de la oferta o de la promocion
	  *				[cantidad]			-	Cantidad minima para satisfacer la oferta o la promocion
	  *				[descuento]			-	Descuento de la oferta
	  *				[monto]				-	Monto a descontar por cada unidad
	  *				[oferta_promocion]-	Si es una Oferta (1) o una Promocion (0) (bool)
	  *				[promo] =	array(array(id_articulo => x, cantidad => y)).
	  *										- 	articulos y cantidades de regalo(precio 0) por cada cantidad satisfecha en una promo.
	  **/
	function check_offers($idx_det,$bCommit = FALSE) 
	{
		static $bHuecos;
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!isset($bCommit)) $bCommit = FALSE;
		if (!isset($bHuecos)) $bHuecos = TRUE;

		$mostrar_ofertas = $this->_aReceptor[mostrar_ofertas];
		if (!$mostrar_ofertas) return NULL;

		$id_articulo = (int)$this->_aDetalles[$idx_det][id_articulo];
		if (!$id_articulo) return NULL;
		// Fixme: Para las ofertas cantidad_pedida o recibida? :? 
		$cantidad = $this->get_quantity($idx_det);

		$oDb = $this->_db;
		$aPromo = array();
		if ( (!is_array($this->_aOff_Promo[$id_articulo]) OR empty($this->_aOff_Promo[$id_articulo])) ) {
		 
			// Establecemos la fecha para la comprobacion de ofertas y promociones
			$date = $this->get_date();
			if (empty($date)) $date = "NOW()";
			else $date = "'".$date."'";

			//Promociones u ofertas
		  	$consulta = "Select id_promocion, cantidad, descuento , monto , oferta as 'oferta_promocion' , nombre  ".
							 "FROM Promociones ".
							 "WHERE id_articulo = $id_articulo and id_empresa = ".$this->_aPedido[id_empresa].
							 " AND fecha_inicio < $date AND (fecha_fin>$date OR fecha_fin IS NULL OR fecha_fin=0) ".
							 " ORDER BY cantidad desc ";
		  	$promo_rs = $oDb->query($consulta);
		  
			// No se puede modificar la linea de detalle si ya tiene descuento aplicado.
		  	if ($bCommit AND $this->have_discount($idx_det))
				$bCommit = FALSE;

			if ($this->debug) debug("check_offers(Idx - $idx_det) - Commit($bCommit)");
			$aIdx_vacio = array();
			if ($bHuevos) {
				debug("Hueco en $idx_det ");
				$idx_ant = $this->current_detail();
				$this->set_active_detail($idx_det);
				$bHuecos = FALSE;
				for($i = $idx_ant; isset($i); $i= $this->next_detail()) {
					if (!isset($ant_i)) { 
						$ant_i = $i; 
						continue; 
					} elseif ($ant_i < ($i-1))  {
						$bHuecos = TRUE;
						while (++$ant_i < $i) array_push($aIdx_vacio,$ant_i);
					}
					$ant_i = $i;
				}
				$this->set_active_detail($idx_ant);
			} // else debug("No hay Huecos desde $idx_det");


			$applied = FALSE;
			$idp = 0;
		  	if ($oDb->num_rows($promo_rs)) {
				$this->_aOff_Promo[$id_articulo] = array();
				while($aPromo = $oDb->fetch_assoc($promo_rs)) {
					$aPromo[idx_det] = array();
					$id_promo = $aPromo[id_promocion];
					//ofertas
					if($aPromo[oferta_promocion] == 1) {
						if($bCommit AND ((int)$aPromo[cantidad] <= $cantidad) AND !$applied ) {
							if($aPromo[descuento] > 0){
								$aTmp[descuento] = $aPromo[descuento];
								$aTmp[tipo_descuento] = $aPromo[descuento] . " % (".$aPromo[nombre].")";
								$aTmp[is_pto]	= TRUE;
							} elseif($aPromo[monto] > 0){
								$aTmp[descuento] = $aPromo[monto];
								$aTmp[tipo_descuento] = $aPromo[monto]." $leyenda_divisa (".$aPromo[nombre].")";
								$aTmp[is_pto]	= FALSE;
							}
							$this->set_discount($idx_det,$aTmp[descuento],$aTmp[is_pto],$aTmp[tipo_descuento],TRUE);
							array_push($aPromo[idx_det],$idx_det);
							$applied = TRUE;
							$idx_promo = $idp;
						}
					}
					//Promociones
					if (!(int)$aPromo[oferta_promocion] OR (int)$aPromo[oferta_promocion]==2) {
					 	$cons = "SELECT id_articulo, cantidad ".
								"FROM Promociones_articulos ".
								"WHERE Promociones_articulos.id_promocion = $id_promo ORDER BY cantidad desc";
					 	$tmp_rs = $oDb->query($cons);
						$aPromo[promo] = array();
						if ($bCommit) {
							if ($cantidad > 0) $ratio_cantidad = floor($cantidad / $aPromo[cantidad]);
							else $ratio_cantidad = ceil($cantidad / $aPromo[cantidad]);
						}
						$applied_det = FALSE;
						$set_id_promo = FALSE;

						while ($aTmp = $oDb->fetch_assoc($tmp_rs)) {
							if ($bCommit AND !$applied AND $aPromo[cantidad]<=abs($cantidad) ) {
								if ($this->debug) debug("DBfetched: Hacemos efectiva la promocion encontrada...");
								array_push($aPromo[idx_det],$idx_det);
								$aTmp[$idx_det] = array();

								// debug("No hemos encontrado la promocion nin! $aTmp[cantidad]");
								if (is_array($aIdx_vacio) AND sizeof($aIdx_vacio)) $idx_ = array_shift($aIdx_vacio);
								else $idx_ = NULL;
								$tmp_idx = $this->add_detail($aTmp[id_articulo],($ratio_cantidad * $aTmp[cantidad]),NULL,FALSE,$idx_);
								// $this->set_cuantity($tmp_idx,0);
								$this->set_price($tmp_idx,0,TRUE);
								$this->set_discount($tmp_idx,0,NULL,$aPromo[nombre],TRUE);
								$aTmp[$idx_det] = $tmp_idx;
								$applied_det = TRUE;
							} elseif (!$applied AND $aPromo[cantidad]<=abs($cantidad))
								$set_id_promo = TRUE;
							array_push($aPromo[promo],$aTmp);
						} // Mientras me queden articulos de promocion... 
						if ($applied_det) {
							$this->set_discount($idx_det,0,0,$aPromo[nombre]."",TRUE);
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
		} else if((int)$mostrar_ofertas AND !empty($this->_aOff_Promo[$id_articulo])) {
			$aPromociones = $this->_aOff_Promo[$id_articulo];
			if ($this->debug) debug("Ya habia una oferta marcada sir ($id_articulo)...");
			if ($this->debug) print_r($aPromociones);
			$applied = FALSE;
			$aPromo_ant = array();
			$aPromo_act = array();
			foreach ($aPromociones as $idp => $aPromo) {
				//ofertas
				if($aPromo[oferta_promocion] == 1) {
					if(((int)$aPromo[cantidad] <= abs($cantidad)) AND !$applied AND !in_array($idx_det,$aPromo[idx_det]) ) {
						if($aPromo[descuento] > 0){
							$aTmp[descuento] = $aPromo[descuento];
							$aTmp[tipo_descuento] = $aPromo[descuento] . " % (".$aPromo[nombre].")";
							$aTmp[is_pto]	= TRUE;
						} elseif($aPromo[monto] > 0){
							$aTmp[descuento] = $aPromo[monto];
							$aTmp[tipo_descuento] = $aPromo[monto]." $leyenda_divisa (".$aPromo[nombre].")";
							$aTmp[is_pto]	= FALSE;
						}
						$this->set_discount($idx_det,$aTmp[descuento],$aTmp[is_pto],$aTmp[tipo_descuento],TRUE);
						array_push($this->_aOff_Promo[$id_articulo][$idp][idx_det],$idx_det);
						$applied = TRUE;
						$idx_promo = $idp;
					} elseif (in_array($idx_det,$aPromo[idx_det])) { 
						// Aqui quitarle la oferta/promo si no llega a la cantidad.
						$this->set_discount($idx_det,0,TRUE,NULL,TRUE);
						$this->_aOff_Promo[$id_articulo][$idp][idx_det] = 
								array_diff($this->_aOff_Promo[$id_articulo][$idp][idx_det],array($idx_det));
					}
				}
				if ( is_array($aPromo[promo]) AND (!(int)$aPromo[oferta_promocion] OR (int)$aPromo[oferta_promocion]==2)) {
					if ( ((int)$aPromo[cantidad] <= abs($cantidad)) AND !$applied) {
						if ($this->debug) 
							debug("Primera promo aplicable($idx_det), cantidad($cantidad)");
						if (!in_array($idx_det,$aPromo[idx_det]) AND $bCommit) { 
							array_push($this->_aOff_Promo[$id_articulo][$idp][idx_det],$idx_det);
							$new  = TRUE;
						} else {
							if (!$bCommit) debug("SIN commit para lapromo en $idx_det ...");
							$new = FALSE;
						}
						foreach ($aPromo[promo] as $norden => $aTmp) {
							// debug("VAmos a comprobar los datos restantes del pedido");
							if ($bCommit) {
								if ($cantidad > 0) $ratio_cantidad = floor($cantidad / $aPromo[cantidad]);
								else $ratio_cantidad = ceil($cantidad / $aPromo[cantidad]);
								if ($this->debug) debug("Hacemos efectiva la promocion encontrada Inactiva? ($new)...");
								if ($new AND (!isset($aTmp[$idx_det])) ) {
									if (is_array($aPromo_ant) AND sizeof($aPromo_ant)) {
										$idx_ = array_shift($aPromo_ant);
										$aPrx[idx_pos] = $idx_;
									} 
									$aPrx[id_articulo] = $aTmp[id_articulo];
									$aPrx[cantidad] = $aTmp[cantidad] * $ratio_cantidad;
									$aPrx[idx_trigger] = $idx_det;
									$aPrx[idp_det] = $norden;
									$aPrx[idx_promo] = $idp;
									$aPrx[nombre] = $aPromo[nombre];
									array_push($aPromo_act,$aPrx);
								} else {
									if ($this->debug) 
										debug("Cambio de cantidades($cantidad) en una promocion ".
												"activa $cantidad X $ratio_cantidad * $aTmp[cantidad]...");
									$idx = $aTmp[$idx_det];
									$id_art = $aTmp[id_articulo];
									if ($this->debug) 
										debug("cambiando articulo $id_art en detalle $idx..");
									$cant = $aTmp[cantidad] * $ratio_cantidad;
									$aArt = $this->get_detail($idx);
									if (!is_array($aArt) OR $aArt[id_articulo]!=$id_art OR ($this->get_price($idx)!=0)) { 
										// Este caso no se produce:
										// Si estaba borrado, lo añadimos en la misma pos de detalle (si no hay otro ahora)
										if ($this->debug) 
											debug("Anyadimos articulo($id_art) borrado($idx) de promocion...");
										$idx_ = $this->add_detail($id_art,$cant,NULL,FALSE,$idx);
										if ($idx != $idx_) {
											if ($this->debug) debug("No se pudo re-insertar la linea de detalle");
											$this->_aOff_Promo[$id_articulo][$idp][promo][$norden][$idx_det] = $idx_;
										}
										$this->set_price($idx_,0,TRUE);
										$this->set_discount($idx_,0,NULL,$aPromo[nombre],TRUE);
									} else {
										if ($this->debug) debug("metemos cantidad $cant en $idx");
										$this->set_price($idx,0,TRUE);
										$this->set_quantity($idx,$cant,NULL,NULL,NULL,FALSE);
										$this->set_discount($idx,0,NULL,$aPromo[nombre],TRUE);
									}
								}
							}
						} // Mientras me queden articulos de promocion... 
						$idx_promo = $idp;
						$applied = TRUE;
						if (!$this->have_discount($idx_det)) 
							$this->set_discount($idx_det,0,NULL,$aPromo[nombre],TRUE);
					} elseif (in_array($idx_det,$aPromo[idx_det])) {
						// Aqui quitar la promo si no ha llegado a la cantida pertinente o se ha aplicado otra.
						$this->_aOff_Promo[$id_articulo][$idp][idx_det] = 
								array_diff($this->_aOff_Promo[$id_articulo][$idp][idx_det],array($idx_det));
						if ($this->debug) print_r($this->_aOff_Promo[$id_articulo][$idp]);
						if ($this->debug) debug("Eliminamos(trigger - $idx_det) lineas sin cargo de promo ".$aPromo[nombre].
								" por no cumplir cantidades $cantidad");
						foreach ($aPromo[promo] as $norden => $aTmp) {
							$idx = $aTmp[$idx_det];
							if ($this->debug) 
								debug("Cepillandose el art ".$aTmp[id_articulo]." Que esta en $idx");
							$this->del_detail($idx,FALSE);
							if (!is_array($aPromo_act) OR !sizeof($aPromo_act)) {
								array_push($aPromo_ant,$idx);
								if (!$applied) $this->set_discount($idx_det,0,NULL,NULL,TRUE);
							} else 
								foreach ($aPromo_act as $pos => $aPrx) 
									if (!isset($aPrx[idx_pos])) {
										$aPromo_act[$pos][idx_pos] = $idx;
										break;
									}
							/** Queremos recuperar la posicion del art sin cargo? *(no)*
							$this->_aOff_Promo[$id_articulo][$idp][promo][$norden][$idx_det] = NULL;
							unset($this->_aOff_Promo[$id_articulo][$idp][promo][$norden][$idx_det]); 
							/** **/
						}
					} elseif (is_array($aPromo[promo])) {
						// Esta promocion pudo haber estado activa, a ver si tiene idx_detalles no usados para reciclarlos.
						foreach ($aPromo[promo] as $aPr)
							if ( isset($aPr[$idx_det]) AND !$this->get_detail_article_id($aPr[$idx_det]) ) {
								// Si ha estado activa para este detalle y tiene una lindea de detalle de promocion libre, la reciclamos.
								if (!is_array($aPromo_act) OR !sizeof($aPromo_act))
									array_push($aPromo_ant,$aPr[$idx_det]);
								else 
									foreach ($aPromo_act as $pos => $aPrx)
										if (!isset($aPrx[idx_pos]))
											$aPromo_act[$pos][idx_pos] = $aPrx[$idx_det];
							}
					}
				} // Fin de si es promo
			} // Fin del recorrido de promociones
			// Anyado promos nuevas al final de todo por si puedo aprovechar el hueco dejado por otra promo de este detalle.
			if ($applied AND is_array($aPromo_act) AND sizeof($aPromo_act)) {
				$this->set_discount($aPromo_act[0][idx_trigger],0,TRUE,$aPromo_act[0][nombre],TRUE);
				foreach ($aPromo_act as $aPrx) {
					if (isset($aPrx[idx_pos])) $idx_ = $aPrx[idx_pos];
					else $idx_ = NULL;
					$tmp_idx = $this->add_detail($aPrx[id_articulo],$aPrx[cantidad],NULL,FALSE,$idx_);
					$this->set_price($tmp_idx,0,TRUE);
					$this->set_discount($tmp_idx,0,NULL,$aPrx[nombre],TRUE);
					$this->_aOff_Promo[$aPrx[id_articulo]][$aPrx[idx_promo]][promo][$aPrx[idp_det]][$aPrx[idx_trigger]] = $tmp_idx;
				}
			}
			// Comprobar cantidad antes de asignar el array de retorno. Y devolver solo la que le toco.
			if ($applied) $aPromo = $this->_aOff_Promo[$id_articulo][$idx_promo]; 
		} else {
			$aPromo = $this->_aOff_Promo[$id_articulo] = NULL;
			if ($this->debug) debug("El articulo $id_articulo no tiene nah de nah");
		} // Fin de si mostrar_ofertas
		if (!is_array($aPromo) OR is_array($aPromo) AND !sizeof($aPromo)) return $this->_aOff_Promo[$id_articulo][$idx_promo];
		else return $aPromo;
	}

	/**
	  * Comprueba los descuentos generales por volumen de articulo.
	  * @param  $idx_det		Identificador del detalle sobre el que se ha de comprobar el descuento.
	  * @param 	$bCommit		Indicativo de si se ha de modificar la linea de detalle con los resultados obtenidos.
	  * @return $aDto		 	Devueve el array con la informacion del descuento, o NULL.
	  *				[descuento]						-	cantidad/porciento del descuento
	  *				[tipo_descuento]				-	tipo del descuento a aplicar.
	  *				[precio_tarifa_descuento]	-	Precio del articulo una vez aplicados tarifa y descuento.
	  */
	function check_volume_discount($idx_det,$bCommit = TRUE) 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if (!(int)$this->_aReceptor['aplicar_dto_volumen']) return NULL;
		//Descuento global por VolumeVolumen
		if (!is_array($this->_aDetalles[$idx_det])) return NULL;
		if ($this->have_discount($idx_det)) return NULL;

		if (!isset($bCommit)) $bCommit = TRUE;

		$id_empresa = $this->_aPedido['id_empresa'];
		$id_articulo = $this->_aDetalles[$idx_det]['id_articulo'];
		$oDb = $this->_db;

		// debug("Comprobando descuento por volumen($idx_det)...".$this->_aDetalles[$idx_det][unidades_bulto]);

		$cantidad_pedida = $this->get_quantity($idx_det);
		// Fixme: Faltan por configurar los descuentos por caja
		if ($this->_aDetalles[$idx_det]['unidades_bulto']>1 AND $bCommit AND
						abs($cantidad_pedida) >= $this->_aDetalles[$idx_det]['unidades_bulto']
						AND (int)$this->_aReceptor['aplicar_dto_volumen']) {
			$numero_bultos = $cantidad_pedida / $this->_aDetalles[$idx_det]['unidades_bulto'];
			if (is_numeric($this->_aDetalles[$idx_det]['dto_volumen'])) {
				$dto = $this->_aDetalles[$idx_det]['dto_volumen'];
				if (is_numeric($this->_aDetalles[$idx_det]['dto_volumen_bultos']))
					$btos = $this->_aDetalles[$idx_det]['dto_volumen_bultos'];
				else $btos = 1;
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

				if (!is_numeric($dto) AND is_numeric($this->_aEmisor['dto_bulto'])) {
					$dto = $this->_aEmisor['dto_bulto'];
					if (is_numeric($this->_aEmisor['dto_bulto_uds']))
						$btos = $this->_aEmisor['dto_bulto_uds'];
					else $btos = 1;
					if ((int)$btos) $sBts = $btos." Btos";
					else $dto = 0;
				} 
			}
			if ((int)$dto AND (abs($cantidad_pedida) / $this->_aDetalles[$idx_det]['unidades_bulto']) >= $btos) {
				$fila['descuento'] = $dto;
				$fila['tipo_descuento'] = "$dto% $sBts";
				$fila['is_pto'] = TRUE;
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
			$this->set_discount($idx_det,$fila['descuento'],$fila['is_pto'],$fila['tipo_descuento'],FALSE);
		}
		return $fila;
	}

	/** 
	  * Computa todos los totales del pedido
	  *
	  */
	function calculate() 
	{
		if ($this->_aFlags['pedido'] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		if ($this->debug) debug("A calcular..");
		$this->_calculate_discounts();
		$this->_build_taxes();
		$this->_calculate_totals();
		// Marcar el pedido como calculado.
	}

	function delete() 
	{
		if ($this->debug) debug("Marcando el pedido para ser borrado...");
		$this->_aFlags[pedido] |= (inmPed_DB_DELETE | inmPed_DB_COMMIT);
	}

	function undelete() 
	{
		if ($this->debug) debug("Desmarcando el pedido para ser borrado");
		$this->_aFlags[pedido] &= ~inmPed_DB_DELETE;
	}

	function is_deleted() 
	{
		if ($this->debug) debug("Comprobando si el pedido esta marcado para ser borrado...");
		return ( ($this->_aFlags[pedido] & inmPed_DB_DELETE) ? TRUE : FALSE);
	}

	/** Fin de los metodos de funcionalidades **/

} /**************** FIN DE LA CLASE ******************/

// overload("inmPedido");
// inmPedido.overload();
/******* Funciones nodb para Obtener los datos del oPedido_en_curso ***********/
function nodb_order_data(&$Sesion,$block_name) 
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$aRetVal = $oPedido->get_info();
		if (empty($aRetVal['observaciones'])) $aRetVal['observaciones'] = "";
		$aAg = $oPedido->get_agent();
		$aDiv = $oPedido->get_currency();
		$aRetVal['nombre_agente'] = $aAg['nombre'];
		$aRetVal['nombre_divisa'] = $aDiv['nombre_divisa'];

		// Estado del pedido:
		$aAlb = $oPedido->get_deliveries();
		$parcial = 0;
		if (is_array($aAlb)) 
			foreach($aAlb as $alb) {
				if ((int)$alb['confirmacion']) {
					if (isset($last_status) AND $last_status != 3) $parcial =1;
					if ((int)$last_status <= 4) {
						$estadio = 'Entregado';
						$last_status = 3;
					}
				} elseif ((int)$alb['enviado']) {
					if (isset($last_status) AND $last_status != 2) $parcial =1;
					if ((int)$last_status <= 3) {
						$estadio = 'Enviado';
						$last_status = 2;
					}
				} elseif ((int)$alb['preparado']) {
					if (isset($last_status) AND $last_status != 1) $parcial =1;
					if ((int)$last_status <= 2) {
						$estadio = 'Preparado';
						$last_status = 1;
					}
				} else {
					if (isset($last_status) AND (int)$last_status != 0) $parcial =1;
					if (!(int)$last_status) {
						$estadio = 'En Preparacion';
						$last_status = 0;
					}
				}
			}
		else $estadio = 'En Preparacion';
		$estado = ( ((int)$parcial) ? 'Parcialmente ' : '').$estadio;
		$aRetVal['descripcion_estado'] = $estado;
		$aRetVal['numero_estado'] = $last_status;

		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}


function nodb_currency_data(&$Sesion,$block_name) 
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$aRetVal = $oPedido->get_currency();
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_issuer_data(&$Sesion,$block_name) 
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	if (!$done OR $reset) 
	{
		$done = 1;
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$aRetVal = $oPedido->get_issuer_info();
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function nodb_reciever_data(&$Sesion,$block_name) 
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	if (!$done OR $reset) {
		$done = 1;
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		if (!is_object($oPedido)) return NULL;
		$aRetVal = $oPedido->get_reciever_info();
		$aTmp = $oPedido->get_reciever_address(FALSE);
		if (is_array($aTmp))
			foreach ($aTmp as $campo => $valor) {
				if (is_array($valor)) break;
				$aRetVal["direccion_".$campo] = $valor;
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

/** 
 * funcion ke realiza todos los calculos del pedido
 * LOS MANTIENE EN SESION A LA ESPERA DE CONFIRMACION PARA LA INSERCION EN LA BASE DE DATOS
 */
function nodb_order_details(&$Sesion,$block_name)
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$not_first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	$oPedido = $Sesion->get_var("oPedido_en_curso");
	if (!is_object($oPedido)) return NULL;

	if (!$not_first OR $reset) {
		$idxdet = $oPedido->first_detail();
		$not_first = 1;
	} else $idxdet = $oPedido->next_detail();

	if (!isset($idxdet)) {
		$reset = 1;
		$aArt = NULL;
	} else { 
		$reset = 0;
		$Sesion->set_var("oPedido_en_curso",$oPedido);

		$aDiv = $oPedido->get_currency();
		$aArt = $oPedido->get_detail($idxdet);
		$aArt['idx_detalle'] = $idxdet;
		$aArt['leyenda_divisa'] = $aDiv['leyenda'];
		$bultos = $oPedido->get_quantity($idxdet,TRUE); 
		$cant = $oPedido->get_quantity($idxdet);
		if ($bultos == (int)$bultos)
			$aArt['bultos'] = $bultos;

		$aArt['cantidad_total'] = $aArt['cantidad'] = $aArt['cantidad_pedida'];
		$aArt['precio_articulo'] = $aArt['precio'] = $oPedido->get_price($idxdet);
	}

	$aBlocks[$block_name]['done'] = $not_first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aArt;
}

/** calcula los ivas en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido */
function nodb_taxes_detail(&$Sesion,$block_name)
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aIVAs = $aBlocks[$block_name]['extras'];
		$aDiv = $aBlocks[$block_name]['divisa'];
	}
	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$aTotIva = $oPedido->get_taxes();
		$aIVAs = $aTotIva['detalle'];
		$aDiv = $oPedido->get_currency();
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aIVAs) OR empty($aIVAs)) {
		$reset = 1;
		$aRetVal = NULL;
	} else {
		$aIva = array_pop($aIVAs);
		$aRetVal['porcentaje'] = $aIva['porciento'] ;
		$aRetVal['porcentaje_recargo_equivalente'] = $aIva['recargo_eq'];
		$aRetVal['recargo_iva'] = $aIva['total_iva'];
		$aRetVal['recargo_equivalente'] = $aIva['total_recargo'];
		$aRetVal['base_imponible'] = $aIva['base_imponible'];
		$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
	}
	
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aIVAs;
	$aBlocks[$block_name]['divisa'] = $aDiv;
	return $aRetVal;
}

/** calcula los descuentos en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido y detalles IVA*/
function nodb_discounts_detail(&$Sesion,$block_name)
{
	static $aBlocks;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
		$aDtos = $aBlocks[$block_name]['extras'];
		$aDiv = $aBlocks[$block_name]['divisa'];
	}

	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$aTotDtos = $oPedido->get_discounts();
		$aDtos = $aTotDtos['detalle'];
		$aDiv = $oPedido->get_currency();
		if (!is_array($aDtos) OR empty($aDtos)) return NULL;
		$first = 1;
		$reset = 0;
	}
	if (!is_array($aDtos) OR !sizeof($aDtos)) {
		$reset = 1;
		return NULL;
	}
	$aDto = array_shift($aDtos);
	$aRetVal['base_imponible'] = $aDto['base_imponible'] ;
	$aRetVal['descuento'] = $aDto['descuento'];
	$aRetVal['importe'] = $aDto['importe'];
	$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
	$aRetVal['nombre'] = $aDto['nombre'];
	$aRetVal['orden'] = $aDto['orden'];

	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	$aBlocks[$block_name]['extras'] = $aDtos;
	$aBlocks[$block_name]['divisa'] = $aDiv;
	return $aRetVal;
}


/** calcula los totales en funcion de las lineas de detalle ke nos llegan de nodb_confirmar_pedido , detalle_iva y detalle_descuento*/
function nodb_order_totals(&$Sesion,$block_name)
{
	static $aBlocks;
	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$first = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}

	if (!isset($first) OR $reset) {
		$oPedido = $Sesion->get_var("oPedido_en_curso");
		$oPedido->calculate();
		$aTotales = $oPedido->get_totals();
		$aDiv = $oPedido->get_currency();
		$aRetVal = $aTotales;
		$aRetVal['leyenda_divisa'] = $aDiv['leyenda'];
		$aRetVal['total_impuestos'] = $aRetVal['impuestos'] + $aRetVal['recargos'];
		$first = 1;
		$reset = 0;
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $first;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

?>
