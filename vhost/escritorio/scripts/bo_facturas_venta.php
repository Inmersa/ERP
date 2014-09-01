<?php
/** Funciones del listado de facturas de compra
  global $identificador_pedido;
  global $Generar;
  global $notas;
  global $id_forma_pago;
  global $id_serie;
  global $ref_externa;

  Acciones : Generar .
  Si no existe un albaran se genera la factura a parir del pedido ,
  Si existen albaranes Se crea una factura con los articulos ke hemos podidos satisfacer (recalculando)
  y un pedido de nombre pendiente con los articulos ke no teniamos en los almacenes (localizacion)
  controlar ke el pedido no sea vacio el residual
 */
function pre_facturas_venta(&$Sesion) {
	$identificador_pedido=$Sesion->fetchVar('identificador_pedido','POST');
	$Generar=$Sesion->fetchVar('Generar','POST');
	$notas=$Sesion->fetchVar('notas','POST');
	$id_forma_pago=$Sesion->fetchVar('id_forma_pago','POST');
	$id_serie=$Sesion->fetchVar('id_serie','POST');
	$ref_externa=$Sesion->fetchVar('ref_externa','POST');
	$residuo=$Sesion->fetchVar('residuo','POST');
	$contador=$Sesion->fetchVar('contador','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$Confirmar=$Sesion->fetchVar('Confirmar','POST');

	//el login
	$usuario = identifica_usuarios($Sesion);
	$id_empresa = $usuario['id'];

	if(isset($Confirmar)){
		//del formulario
		$pedido_tipo=$Sesion->fetchVar('pedido_tipo','POST');
		$direccion_entrega=$Sesion->fetchVar('direccion_entrega','POST');
		$agente=$Sesion->fetchVar('agente','POST');
		$observaciones=$Sesion->fetchVar('observaciones','POST');
		$registro=$Sesion->fetchVar('registro','POST');
		$servicios=$Sesion->fetchVar('servicios','POST');
		$forma_pago=$Sesion->fetchVar('forma_pago','POST');
		$divisa=$Sesion->fetchVar('divisa','POST');
		$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');

		$articulos=$Sesion->fetchVar('articulos','POST',NULL,'classDocumentDetail');
		$articulos_precios=$articulos['precio'];
		$articulos_old=$Sesion->fetchVar('articulos_old','POST',NULL,'classDocumentDetail');
		$articulos_precios_old=$articulos_old['precio'];

		$docvar = $Sesion->get_var('__document_iface_varname');
		if (empty($docvar)) $docvar = 'oPedido_en_curso';
		$oPedido = $Sesion->get_var($docvar);
		if (!is_object($oPedido)) return NULL;

		if ($oPedido->debug) debug("en confirmados tenemos :");
		if ($oPedido->debug) print_r($articulos_confirmados);

		if (is_numeric($agente)) $oPedido->setAgent($agente,true);
		$oPedido->set_payment_method($forma_pago);
		$oPedido->set_currency($divisa);
		$oPedido->set_name($registro['nombre']);
		$oPedido->set_ext_reference($registro['referencia_externa']);
		$oPedido->set_comments($registro['observaciones']);
		if (isset($registro['fecha'])) $oPedido->setDate($registro['fecha']);

		if ($oPedido->debug) 
			debug("nos pateamos los detalles para establecer valores");

		for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
			if (!isset($articulos_confirmados[$idx])) 
				$oPedido->del_detail($idx);
			else {
				if (!empty($observaciones[$idx]))
					$oPedido->set_detail_comment($idx,$observaciones[$idx]);

				if ( method_exists($oPedido,'set_detail_contract') AND is_numeric($servicios[$idx]) ) {
					$aServ = $oPedido->get_detail_contract($idx);
					if (is_array($aServ) AND sizeof($aServ)) {
						if (is_numeric($servicios[$idx]) AND $servicios[$idx]!=$aServ['id']) $oPedido->set_detail_contract($idx,$servicios[$idx]);
						elseif (!$servicios[$idx]) {
							$oPedido->unset_detail_contract($idx);
						}
					} elseif (is_numeric($servicios[$idx])) { 
						$oPedido->set_detail_contract($idx,$servicios[$idx]);
					}
				}

				if (is_numeric($articulos_precios[$idx]) AND $articulos_precios[$idx] != $oPedido->get_price($idx) ) {
					$oPedido->set_price($idx,$articulos_precios[$idx]);
				}
			}
		}

		$oPedido->calculate();
		/** **/
		$oPedido->dbdump();
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');

		// Fixme: Comprobar estas variables!
		$Sesion->unset_var("id_direccion_cliente");
		$Sesion->unset_var("id_direccion");
	} else {
		$pedido_reciente = (int) $Sesion->get_var("pedido_reciente");
		if(isset($Generar) AND !$pedido_reciente){
			$docvar = $Sesion->get_var('__document_iface_varname');
			if (empty($docvar)) $docvar = 'oPedido_en_curso';
			$oPedido = $Sesion->get_var($docvar);
			if (!is_object($oPedido) OR strcasecmp(get_class($oPedido),'Order')) return NULL;

			$id = $oPedido->get_id();

			$oFactura = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
			if (!is_object($oFactura)) {
				$Sesion->lcMessage('LCS_MODULE_FAILINSTANCE',array('class' => 'Invoice'));
				$Sesion->perror_link('?logout=1');
				return;
			}

			if ($oFactura->fillFromOrder($oPedido,NULL,( ((int)$residuo) ? true : false ))) {
				if (is_numeric($id_serie)) $oFactura->setSeries($id_serie);
				if (is_numeric($id_forma_pago)) $oFactura->set_payment_method($id_forma_pago);
				if (!empty($notas)) $oFactura->set_comments($notas);
				if (!empty($ref_externa)) $oFactura->set_ext_reference($ref_externa);
		
				$oFactura->dbDump();
			}
			$Sesion->set_var("pedido_reciente",$id,"SUBSECCION");
		}

		switch($accion_ejecutar) {
			case "Borrar" : 
				if(is_array($registro_borrar))
					foreach($registro_borrar as $id_factura => $valor)
						if($valor == 1){
							$oFra = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
							if ($oFra->dbFill($id_factura)) {
								$oFra->delete();
								$oFra->dbDump();
								// debug("facturando $id_pedido..");
							} else {
								$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Facturas', 'id' => $id_factura));
							}
							$oFra = NULL;
							unset($oFra);
						}//hay ke borrar
			break;

			case "Recalcular" :
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_factura => $valor)
					if($valor == 1){
						$oFra = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
						$oFra->debug=0;
						if ($oFra->dbFill($id_factura)) {
							$oFra->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_CHG_TAXES | 
									inmPed_CHG_DETAIL | inmPed_CHG_MAIN | inmPed_MODIFIED);
							$oFra->eval_conditions(TRUE);
							$oFra->calculate();
							$oFra->dbDump();
							// debug("facturando $id_pedido..");
						} else $Sesion->lcMessage('INVOICE_DBFILL',array('id' => $id_factura));
						$oFra = NULL;
						unset($oFra);
					}
			break;

			case "Emitir" : 
				if(is_array($registro_borrar))
					foreach($registro_borrar as $id_factura => $valor)
						if($valor == 1){
							$oFra = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
							if ($oFra->dbFill($id_factura)) {
								$oFra->setIssued();
								$oFra->dbDump();
								// debug("facturando $id_pedido..");
							} else $Sesion->lcMessage('INVOICE_DBFILL',array('id' => $id_factura));
							$oFra = NULL;
							unset($oFra);
						}//hay ke borrar
			break;


			default:
			$Sesion->unset_var("oPedido_en_curso");
			break;
		}//fin del caso ke te cagas

	} // fin de si estamos modificando una factura, o accionando desde el listado.

}//fin del precode

function estado_factura(&$Sesion,&$aDatos) {
	//depurar_array($aDatos);
	switch($aDatos["Facturas.estado"]){
		case 0 :
			return  "<img src=\"imag/amarillo.gif\" width=\"14\" height=\"14\">";
		case 1 :
			return "<img src=\"imag/verde.gif\" width=\"14\" height=\"14\">";
			//              case 2 : return "Cobrada";
	}
}

function se_puede_borrar(&$Sesion,&$aDatos){
	if($aDatos["Facturas.estado"] == 1){
		return 0;
	}
	return 1;
}

?>
