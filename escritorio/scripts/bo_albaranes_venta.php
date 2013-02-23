<?php

/**Crear un albaran a partir de un pedido de ventas
Seleccionamos la localizacionde los articulos por almacen logico ordenados por fecha de caducidad mas cercana.
Para todas las lineas de detalla tendremos que actualizar el albaran el lote y el almacen logico
del ke vienen asi como la cantidad recibida escoger del almacen logico , crear albaran por almacen
Todo en ello en funcion del control de stock de el articulo y la permisividad de stock nevatigo de la empresa
El stock se usa solo para las cantidades , no para la generacion de albaranes
Al lorito con esto ultimo hay diferenciar por las cantidades

global $identificador_pedido;
global $Generar;

global $id_transportista;
global $ref_externa;
global $confirmacion;
global $enviado;
global $preparado;

Acciones :Generar

*/

function pre_albaranes_venta (&$Sesion) {
	$identificador_pedido=$Sesion->fetchVar('identificador_pedido','POST SESSION');
	$Generar=$Sesion->fetchVar('Generar','POST SESSION');
	$Localizar=$Sesion->fetchVar('LocalizarProducto','POST SESSION');

	$id_transportista=$Sesion->fetchVar('id_transportista','POST');
	$id_almacen_pedido=$Sesion->fetchVar('id_almacen','POST');
	$ref_externa=$Sesion->fetchVar('ref_externa','POST');
	$confirmacion=$Sesion->fetchVar('confirmacion','POST');
	$enviado=$Sesion->fetchVar('enviado','POST');
	$preparado=$Sesion->fetchVar('preparado','POST');
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$aBorrar = $Sesion->fetchVar('registro_borrar','POST');


	$usuario = identifica_usuarios ($Sesion);
	$oDb = $Sesion->get_db ('data');

	if (isset ($Generar)) {
		$aTmp = DeliveryNote::factoryFromDocument($identificador_pedido,'data');
		if (is_array($aTmp) and sizeof($aTmp)) 
			foreach (array_keys($aTmp) as $ida) {
				if (!empty($id_transportista)) $aTmpRec['id_transportista'] = $id_transportista;
				if (!empty($ref_externa)) $aTmpRec['referencia_externa'] = $ref_externa;
				if (is_array($aTmpRec) and sizeof($aTmpRec)) $aTmp[$ida]->update($aTmpRec);
				if ((bool)$Localizar) $aTmp[$ida]->LocateProduct();
				if ((bool)$preparado) {
					if (!(bool)$Localizar) $aTmp[$ida]->LocateProduct();
					for ($idx=$aTmp[$ida]->firstDetail(); isset($idx); $idx=$aTmp[$ida]->nextDetail()) {
						$aD = $aTmp[$ida]->getDetailData(NULL,$idx);
						if (true or $aTmp[$ida]->bVenta) 
							$aTmp[$ida]->setDetailAttribute('cantidad',$aTmp[$ida]->getDetailAttribute('stock_previsto',NULL,$idx),NULL,$idx);
						else
							$aTmp[$ida]->setDetailAttribute('stock_previsto',$aTmp[$ida]->getDetailAttribute('cantidad',NULL,$idx),NULL,$idx);
					}
					$aTmp[$ida]->update(array('preparado' => 1));
				}
				if ((bool)$enviado) $aTmp[$ida]->update(array('enviado' => 1));
				if ((bool)$confirmacion) $aTmp[$ida]->update(array('confirmacion' => 1));
				$aTmp[$ida]->Dump();
			}
	} // FIN DEL GENERAR

	switch ($accion) {
		case 'Borrar':
			debug("Borrando albaranes .. ");
			if (is_array($aBorrar) and sizeof($aBorrar))
				foreach ($aBorrar as $ida => $bool) {
					if ($bool) {
						debug("Borrando $ida ");
						$oAlb = new DeliveryNote();
						if ($oAlb->dbFill($ida)) {
							$oAlb->delete();
							$oAlb->Dump();
						}
					}
				}
			break;

		case 'ConfirmarDocumentoValorado':
			/**
			 * FixMe: Convendria establecer ciertas acciones como standard, de tal forma que no haga falta repetir el codigo
			 * del switch/case en cuestion en todos los scripts donde por ej, los distintos post de la confirmacion de documento
			 * valorado .
			 * **/
			$docvar = $Sesion->get_var('__document_iface_varname');
			if (empty($docvar)) $docvar = 'oPedido_en_curso';
			$oPedido = $Sesion->get_var($docvar);
			debug("Registrando para $docvar .. con ".get_class($oPedido));
			if (is_object($oPedido)) {
				$registro=$Sesion->fetchVar('registro','POST');
				$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');

				$pedido_tipo=$Sesion->fetchVar('pedido_tipo','POST');
				$direccion_entrega=$Sesion->fetchVar('direccion_entrega','POST');
				$agente=$Sesion->fetchVar('agente','POST');
				$observaciones=$Sesion->fetchVar('observaciones','POST');
				$registro=$Sesion->fetchVar('registro','POST');
				$servicios=$Sesion->fetchVar('servicios','POST');
				$forma_pago=$Sesion->fetchVar('forma_pago','POST');
				$divisa=$Sesion->fetchVar('divisa','POST');
				$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');
				$articulos_precios=$Sesion->fetchVar('articulos_precios','POST');
				$articulos_precios_old=$Sesion->fetchVar('articulos_precios_old','POST');

				$idped = $oPedido->getId();
				$last_id = $Sesion->get_var('last_id_pedido');
				debug("Last id $last_id y el id $idped ");
				if (is_numeric($last_id) AND $last_id == $idped) {
					return NULL;
				}
				$Sesion->set_var('last_id_pedido',$idped,'SECCION');

				if (method_exists($oPedido,'set_reciever_address') AND !$oPedido->set_reciever_address($registro['id_direccion']))
					if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

				if (!empty($id_transportista)) {
					debug("Mirando de meter el transportista $id_transportista ... ");
					$oPedido->setHeaderAttribute('id_transportista',$id_transportista);
				}

				$oPedido->set_agent($agente,TRUE);
				$oPedido->set_payment_method($forma_pago);
				$oPedido->set_currency($divisa);
				$oPedido->set_name($registro['nombre']);
				$oPedido->set_comments($registro['observaciones']);

				$oA = &$oPedido->getNote();
				for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
					$aD = $oA->getDetailData('DetallePedido',$idx);
					// debug("Datos ... ");
					// print_r($aD);

					if (!isset($articulos_confirmados[$idx])) 
						$oPedido->del_detail($idx);
					else {
						if (!empty($observaciones[$idx]))
							$oPedido->set_detail_comment($idx,$observaciones[$idx]);

						if (is_array($articulos_precios[$idx]) AND sizeof($articulos_precios[$idx]) AND 
								(!empty($articulos_precios[$idx]) OR is_numeric($articulos_precios[$idx])) ) {
							$precio = $oPedido->get_price($idx);
							debug("precio para $idx es $precio Y en el art es: ".$articulos_precios[$idx]);
							if ($precio != $articulos_precios[$idx]) $oPedido->set_price($idx,$articulos_precios[$idx]);
						}

						if (is_numeric($servicios[$idx])) {
							// debug("Anyadiendo servico ".$servicios[$idx]." al pedido y tal...");
							$oPedido->set_detail_contract($idx,$servicios[$idx]);
						} else {
							$tmps = $oPedido->get_detail_attribute($idx,'id_servicio');
							if (!empty($tmps))
								$oPedido->unset_detail_contract($idx);
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
				}

				if (isset($pedido_tipo) AND is_numeric($pedido_tipo) AND $pedido_tipo == 1) {
					if (!$oPedido->standard()) $oPedido->standard(TRUE);
				}

				$oPedido->calculate();
				// debug("Cascamos!! ");
				// break;
				/** **/
				$oPedido->dbDump();
				$id_pedido = $oPedido->getId();

				$Sesion->unset_var($docvar);
				$Sesion->unset_var('__document_iface_varname');

				// Fixme: Comprobar estas variables!
				$Sesion->unset_var("id_direccion_cliente");
				$Sesion->unset_var("id_direccion");
			}
			break;
	}

}										  // fin del precode

function cf_estado_albaran (&$Sesion, &$aData) {
//depurar_array($aDatos);
	if ($aData['Albaranes.confirmacion'] AND !$aData['Albaranes.devolucion']) {
		$aData['estado_albaran'] = 'ok';
	} elseif($aData['Albaranes.devolucion']) {
		$aData['estado_albaran'] = 'bad';
	} elseif($aData['Albaranes.enviado']) {
		$aData['estado_albaran'] = 'ok';
	} elseif($aData['Albaranes.preparado']) {
		$aData['estado_albaran'] = 'do';
	} else $aData['estado_albaran'] = 'none';
	return TRUE;
}

?>
