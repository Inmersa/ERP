<?php
/** Funcion encargada de limpiar los productos ke nos vienen del carrito y han sido deseleccionados para un pedido de venta
Tambien mete en la sesion tarifas y control de recargos (iva , inposiciones ...)
*/
function pre_confirmar_pedido(&$Sesion){
	$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');	//array de checkboxes con los ke keremos konfirmar
	$articulos_cesta=$Sesion->fetchVar('articulos_cesta','POST');			//array de hidden que habia en la cesta (para no borrar los k entran por promo)

	$cesta =$Sesion->fetchVar('cesta','POST',NULL,'classDocumentDetail');

	$array_bultos = $cesta['bultos'];
	$array_numero = $cesta['cantidad'];
	/**  **
	$array_bultos=$Sesion->fetchVar('array_bultos','POST',NULL,'classDocumentDetail');
	$array_numero=$Sesion->fetchVar('array_numero','POST',NULL,'classDocumentDetail');
	$array_precios=$Sesion->fetchVar('array_precios','POST',NULL,'classDocumentDetail');
	/** **/

	$registro=$Sesion->fetchVar('registro','POST');
	$servicios=$Sesion->fetchVar('servicios','POST');

	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';
	$oPedido = $Sesion->get_var($docvar);
	$aUsr = identifica_usuarios($Sesion);

	if (!is_object($oPedido)) {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'),IM_FATALERROR);
		return ;
	}

	if ($oPedido->debug) debug("Falta Re-comprobar las Cantidades ->".sizeof($oPedido->_aDetalles));
	if ($oPedido->debug) print_r($array_bultos);
	if ($oPedido->debug) print_r($array_numero);
	if ($oPedido->debug) debug("Registro :");
	if ($oPedido->debug) print_r($registro);
	if ($oPedido->debug) debug("Confirmados :");
	if ($oPedido->debug) print_r($articulos_confirmados);
	$aDel = array();
	debug("Pre confirmar pedido ".get_class($oPedido));
	print_r($array_bultos);

	for ($idxdet = $oPedido->first_detail(); isset($idxdet); $idxdet = $oPedido->next_detail()) {
		if (!isset($articulos_cesta[$idxdet])) continue;
		if (!isset($articulos_confirmados[$idxdet])) {
			if ($oPedido->debug) debug("borrando detalle $idxdet ...");
			$oPedido->del_detail($idxdet);
			continue;
		} elseif (is_numeric($array_bultos[$idxdet]['palets']) AND is_array($array_bultos) ) {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) cantidades de palets ".$oPedido->get_quantity($idxdet)." a ".$array_numero[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_numero[$idxdet],3);
		} elseif (is_numeric($array_bultos[$idxdet]['capas']) AND is_array($array_bultos) ) {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) cantidades de capas ".$oPedido->get_quantity($idxdet)." a ".$array_numero[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_numero[$idxdet],2);
		} elseif (is_numeric($array_bultos[$idxdet]['bultos']) AND is_array($array_bultos) ) {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) bultos de bultos ".$oPedido->get_quantity($idxdet,1)." a ".$array_bultos[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_numero[$idxdet],1);
		} else {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) cantidades de _unidades_ ".$oPedido->get_quantity($idxdet)." a ".$array_numero[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_numero[$idxdet],0);
		} 

		if ( method_exists($oPedido,'set_detail_contract') AND is_numeric($servicios[$idxdet]) ) {
			$aServ = $oPedido->get_detail_contract($idxdet);
			if (is_array($aServ) AND sizeof($aServ)) {
				if (is_numeric($servicios[$idxdet]) AND $servicios[$idxdet]!=$aServ['id']) $oPedido->set_detail_contract($idxdet,$servicios[$idxdet]);
				elseif (!$servicios[$idxdet]) {
					$oPedido->unset_detail_contract($idxdet);
				}
			} elseif (is_numeric($servicios[$idxdet])) { 
				$oPedido->set_detail_contract($idxdet,$servicios[$idxdet]);
			}
		}
	}
	/** **
	if (is_array($aDel))
		foreach($aDel as $idxdet)
			$oPedido->del_detail($idxdet);
	/** **/

	$aPed = $oPedido->get_info();
	$id_empresa = $aPed['id_empresa'];
	$id_div = $aPed['id_divisa'];
	$id_forma_pago = $aPed['id_forma_pago'];
	$id_cliente = $aPed['id_cliente'];
	if ($oPedido->debug) debug("divisa = $id_div");
	if ($oPedido->debug) debug("forma_pago = $id_forma_pago");
	$Sesion->set_var("id_empresa",$id_empresa,"INMED");
	$Sesion->set_var("id_divisa",$id_div,"INMED");
	$Sesion->set_var("id_forma_pago",$id_forma_pago,"INMED");
	// // $Sesion->set_var("id_cliente_pedido",$id_cliente,"INMED");

	if (method_exists($oPedido,'get_reciever_address')) {
		$aDirs = $oPedido->get_reciever_address();
		if (sizeof($aDirs) == 1) {
			$Dir = array_pop($aDirs);
			$Sesion->set_var("id_direccion",$Dir['id_direccion']);
		}
	}

	$oPedido->calculate();
	if (method_exists($oPedido,'_updateArticleContracts')) $oPedido->_updateArticleContracts();
	$Sesion->set_var($docvar,$oPedido);
	if ((int)$Sesion->get_var('es_factura') AND (int)$oPedido->getInstallment()) {
		$Sesion->set_var('factura_abono',1,'INMED');
	} else $Sesion->set_var('factura_abono',0,'INMED');

	// Destino del formulario de confirmacion:
	$send_form_to = $Sesion->fetchVar('send_form_to','GET POST SESSION');
	debug("De mano se puede enviar a $send_form_to con variable $docvar ");
	if (!empty($send_form_to)) {
		$Sesion->set_var('send_form_to',$send_form_to,'SUBSECCION');
	} else {
		if ((int)$Sesion->get_var('es_pedido')) {
			if (!strcasecmp($aUsr['desktop_name'],'Clientes')) $Sesion->set_var('send_form_to','bo_pedidos_cliente','INMED');
			else $Sesion->set_var('send_form_to','bo_pedidos_ventas','INMED');
		} elseif ((int)$Sesion->get_var('es_factura')) {
			$Sesion->set_var('send_form_to','bo_facturas_venta','INMED');
		} elseif ((int)$Sesion->get_var('es_presupuesto')) {
			$Sesion->set_var('send_form_to','bo_presupuestos_ventas','INMED');
		} elseif ((int)$Sesion->get_var('es_proforma')) {
			$Sesion->set_var('send_form_to','bo_proformas_venta','INMED');
		} elseif ((int)$Sesion->get_var('es_albaran')) {
			debug("Un albaran si ... a ver donde carajo lo mandamos. ");
			$Sesion->set_var('send_form_to','bo_albaranes_venta','INMED');
		}
	}

}


?>
