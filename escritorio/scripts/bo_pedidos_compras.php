<?php
/** Funciones del listado de pedidos de compra
global $registro; //pedido en si
global $Confirmar;
global $pedido_tipo;
global $agente;
global $forma_pago;
global $divisa;
Acciones : Confirmar
Al confirmar un pedido se actualizan todas las lineas de Iva descuentos especificos , aplicabilidad de iva ...
*/

function pre_pedidos_compras(&$Sesion) {
	$Confirmar=$Sesion->fetchVar('Confirmar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
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

	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$id_serie_facturacion=$Sesion->fetchVar('id_serie_facturacion','POST');

	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';
	if(isset($Confirmar)){
		$oPedido = $Sesion->get_var($docvar);
		if (!is_object($oPedido)) {
			$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
			return ;
		}
		$idped = $oPedido->getId();
		$last_id = $Sesion->get_var('last_id_pedido');
		if (is_numeric($last_id) AND $last_id == $idped) return NULL;
		$Sesion->set_var('last_id_pedido',$idped,'SECCION');

		if ($oPedido->debug) debug("en confirmados tenemos :");
		if ($oPedido->debug) print_r($articulos_confirmados);

		if (!$oPedido->set_reciever_address($registro['id_direccion']))
			if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

		$oPedido->set_agent($agente,TRUE);
		$oPedido->set_payment_method($forma_pago);
		$oPedido->set_currency($divisa);
		$oPedido->set_name($registro['nombre']);
		$oPedido->set_ext_reference($registro['referencia_externa']);
		$oPedido->set_comments($registro['observaciones']);

		if ($oPedido->debug) print_r($servicios);
		if ($oPedido->debug) debug("nos pateamos los detalles para establecer valores");

		for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
			if (!isset($articulos_confirmados[$idx])) 
				$oPedido->del_detail($idx);
			else {
				if (!empty($observaciones[$idx]))
					$oPedido->set_detail_comment($idx,$observaciones[$idx]);

				if (is_numeric($articulos_precios[$idx]) AND $articulos_precios[$idx] != $oPedido->get_price($idx) ) {
					// debug("Actuializando precio en $idx ");
					$oPedido->set_price($idx,$articulos_precios[$idx]);
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
		$oPedido->dbDump();
		/** **/
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');

		// Fixme: Comprobar estas variables!
		$Sesion->unset_var("id_direccion");
		/** **/

	} else { //fin de confirmar  un pedido
		// debug("Borrando el pedido en curso");
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');
	}

	switch($accion_ejecutar) {
		case "Borrar" : 
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
						if ($oPedido->dbfill($id_pedido)) {
							$oPedido->delete();
							$oPedido->dbdump();
							// debug("facturando $id_pedido..");
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}//hay ke borrar
		break;

		case "Facturar" :
			if(is_array($registro_borrar)) {
				$aPedidos = array_reverse($registro_borrar,TRUE);
				foreach($aPedidos as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
						if ($oPedido->dbfill($id_pedido)) {
							if (!is_array($aPedCli[$oPedido->get_issuer_id()])) $aPedCli[$oPedido->get_issuer_id()] = array();
							array_push($aPedCli[$oPedido->get_issuer_id()],$oPedido);
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
			}
			if (is_array($aPedCli) AND sizeof($aPedCli)) {
				// debug("serie = $id_serie_facturacion");
				foreach ($aPedCli as $idcli => $aPeds) {
					$oFactura = new Invoice($Sesion->App_Name,'data',inmPed_COMPRA);
					if (is_array($aPeds) AND sizeof($aPeds)) {
						// debug("proveedor $idcli ");
						foreach ($aPeds as $oPed) {
							// debug("Pedido : ".$oPed->get_reference());
							$oFactura->fillFromOrder($oPed);
						}
					}

					if (is_numeric($id_serie_facturacion)) 
						$oFactura->setSeries($id_serie_facturacion);

					$oFactura->dbDump();
					// debug("referencia ".$oFactura->getReference()." creada satisfactoriamente");
					$oFactura=NULL;
				}
			}
		break;

		case "Recalcular" :
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
						if ($oPedido->dbfill($id_pedido)) {
							$oPedido->_change_flags(inmPed_CHG_DISCOUNTS | inmPed_CHG_TAXES | 
									inmPed_CHG_DETAIL | inmPed_CHG_MAIN | inmPed_MODIFIED);
							$oPedido->eval_conditions(TRUE);
							$oPedido->calculate();
							$oPedido->dbdump();
							// debug("facturando $id_pedido..");
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
		break;

		default:
			/** **Probando...
			  $Sesion->unset_var("oPedido_en_curso");
			/** **/
		break;

	}//fin del caso ke te cagas

}//fin del precode

function cf_pedidos(&$Sesion,&$aData) {
	$oDb = $Sesion->get_db('data');
	// Estado pedido:
	if ((int)$aData['Pedidos.id_pedido']) {
		$cons = "SELECT estado ".
					"FROM Facturas, Pedidos_facturas ".
					"WHERE Pedidos_facturas.id_factura = Facturas.id_factura AND ".
					"Pedidos_facturas.id_pedido = ".$aData['Pedidos.id_pedido'];
		$rsfact = $oDb->query($cons);
		$nfacts = (int)$oDb->num_rows($rsfact);
		if (!$nfacts) { 
			$aData['noborrar'] = 0;
			$aData['estado_factura'] = 'none';
			$aData['link_factura'] = 0;
		} else {
			$aData['link_factura'] = 1;
			$aDaba['noborrar'] = 0;
			while ($aTmp = $oDb->fetch_assoc($rsfact)) {
				$est_fact += $aTmp['estado'];
				if ((int)$aTmp['estado']) $aData['noborrar'] = (int)$aTmp['estado'];
			}
			if ($est_fact == $nfacts) $aData['estado_factura'] = 'ok';
			else $aData['estado_factura'] = 'do';
			$aTmp = NULL;
		}
		$oDb->libera($rsfact);

		$cons = "SELECT preparado,enviado,confirmacion,devolucion ".
					"FROM Albaranes ".
					"WHERE Albaranes.id_pedido = ".$aData['Pedidos.id_pedido'];
		$rsalb = $oDb->query($cons);
		$nalb = (int)$oDb->num_rows($rsalb);
		if (!$nalb) {
			$aData['estado_albaran'] = 'none';
			$aData['link_albaran'] = 0;
		} else {
			$aData['link_albaran'] = 1;
			while ($aTmp = $oDb->fetch_assoc($rsalb)) {
				$npreparados = $aTmp['preparado'];
				$nenviados = $aTmp['enviado'];
				$nconfirmados = $aTmp['confirmacion'];
				$ndevueltos = $aTmp['devolucion'];
			}
			// debug("N($nalb) prep $npreparados env $nenviados confir $nconfirmados devue $ndevueltos");
			if ($nalb == $npreparados) {
				if ($nalb == $nconfirmados AND !$ndevueltos) {
					$aData['estado_albaran'] = 'ok';
					$aData['estado_pedido'] = 'ok';
				} elseif ($ndevueltos > 0) {
					$aData['estado_albaran'] = 'bad';
				} elseif ($nalb == $nenviados) {
					$aData['estado_albaran'] = 'ok';
				} else $aData['estado_albaran'] = 'do';
			} else $aData['estado_albaran'] = 'none';
		}

		$est = $aData['Pedidos.preparado'];
		if ((int)$est AND empty($aData['estado_pedido'])) {
			if ($aData['estado_albaran']=='ok') $aData['estado_pedido'] = 'ok';
			else $aData['estado_pedido'] = 'do';
		} elseif ((int)$est) {
			$aData['estado_pedido'] = 'do'; 
		} else $aData['estado_pedido'] = 'none'; 

		/** **
		  $cons = "SELECT SUM(Lineas_detalle.monto_total) as 'monto_pedido' ".
		  "FROM Pedidos, Lineas_detalle ".
		  "WHERE Pedidos.id_pedido = Lineas_detalle.id_pedido AND ".
		  "Pedidos.id_pedido = ".$aData['Pedidos.id_pedido'];
		  $rsfact = $oDb->query($cons);
		  $nfacts = (int)$oDb->num_rows($rsfact);
		  if (!$nfacts) { 
		  $aData['monto_pedido'] = 0;
		  } else {
		  $aTmp = $oDb->fetch_row($rsfact);
		  $aData['monto_pedido'] = $aTmp[0];
		  }
		/** **/
	}
	return 1;
}

?>
