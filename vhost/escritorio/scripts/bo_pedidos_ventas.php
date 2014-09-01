<?php

function pre_pedidos(&$Sesion) {
	$id_cliente_sesion = $id_cliente = id_entidad($Sesion,'id_cliente',$id_cliente);
	return pre_pedidos_ventas($Sesion);
}

function pre_pedidos_ventas(&$Sesion) {
	$Confirmar=$Sesion->fetchVar('Confirmar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$id_serie_facturacion=$Sesion->fetchVar('id_serie_facturacion','POST');

	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';

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

		//$oPedido = $Sesion->get_var($docvar);
		$oPedido = &$Sesion->getVarByRef($docvar);
		if (!is_object($oPedido)) {
			$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
			return ;
		}
		$idped = $oPedido->getId();
		$last_id = $Sesion->get_var('last_id_pedido');
		if (is_numeric($last_id) AND $last_id == $idped) {
			return NULL;
		}
		$Sesion->set_var('last_id_pedido',$idped,'SECCION');

		if ($oPedido->debug) debug("en confirmados tenemos :");
		if ($oPedido->debug) print_r($articulos_confirmados);

		if (method_exists($oPedido,'set_reciever_address') AND !$oPedido->set_reciever_address($registro['id_direccion']))
			if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

		$oPedido->set_agent($agente,TRUE);
		$oPedido->set_payment_method($forma_pago);
		$oPedido->set_currency($divisa);
		$oPedido->set_name($registro['nombre']);
		//debug("Wow ... poniendo la ref externa: ".$registro['referencia_externa']);
		$oPedido->set_ext_reference($registro['referencia_externa']);
		$oPedido->set_comments($registro['observaciones']);
		if (is_numeric($registro['id_direccion'])) $oPedido->set_reciever_address($registro['id_direccion']);
		if (isset($registro['fecha'])) $oPedido->setDate($registro['fecha']);

		if ($oPedido->debug) 
			debug("nos pateamos los detalles para establecer valores");
		for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
			if (!isset($articulos_confirmados[$idx])) 
				$oPedido->del_detail($idx);
			else {
				if (!empty($observaciones[$idx]))
					$oPedido->set_detail_comment($idx,$observaciones[$idx]);

				$precio = $oPedido->get_price($idx);
				if ($precio != $articulos_precios[$idx]) $oPedido->set_price($idx,$articulos_precios[$idx]);

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
		/** **/
		$oPedido->dbDump();
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');

		// Fixme: Comprobar estas variables!
		$Sesion->unset_var("id_direccion_cliente");
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
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
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
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbfill($id_pedido)) {
							if (!is_array($aPedCli[$oPedido->get_reciever_id()])) $aPedCli[$oPedido->get_reciever_id()] = array();
							array_push($aPedCli[$oPedido->get_reciever_id()],$oPedido);
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
			}
			if (is_array($aPedCli) AND sizeof($aPedCli)) {
				$aCfg = $Sesion->get_var('_aAppConf');
				$bResiduo = (bool)$aCfg['invoice_onnew_residual'];
				foreach ($aPedCli as $idcli => $aPeds) {
					$oFactura = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
					if (is_array($aPeds) AND sizeof($aPeds)) {
						foreach ($aPeds as $oPed) {
							$oFactura->fillFromOrder($oPed,$id_serie_facturacion,$bResiduo);
						}
					}
					if (is_numeric($id_serie_facturacion)) 
						$oFactura->setSeries($id_serie_facturacion);

					$oFactura->dbDump();
					$oFactura=NULL;
				}
			}
			break;

		case "Recalcular" :
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
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
						$Sesion->unset_var($docvar);
					}
			break;

		default:
			$Sesion->unset_var($docvar);
			break;
	}//fin del caso ke te cagas

	// debug("set unset ... ");
	$Sesion->set_var('es_pedido',1);
	$Sesion->unset_var('es_presupuesto');
	$Sesion->unset_var('es_proforma');
	$Sesion->unset_var('es_factura');

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
				$npreparados += $aTmp['preparado'];
				$nenviados += $aTmp['enviado'];
				$nconfirmados += $aTmp['confirmacion'];
				$ndevueltos += $aTmp['devolucion'];
			}
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

function busca_hueco_almacen(&$Localizaciones,$numero_huecos){
	for($i = 1;$i < $numero_huecos['n_planta'];$i++)
		for($j = 1;$j < $numero_huecos['n_pasillo'];$j++)
			for($k = 1;$k < $numero_huecos['n_fila'];$k++)
				for($l = 1;$l < $numero_huecos['n_columna'];$l++)
					if($Localizaciones[$i][$j][$k][$l] != 1){
						$Localizaciones[$i][$j][$k][$l] = 1;
						return array( "planta" => $i ,
								"pasillo" => $j ,
								"fila" => $k ,
								"columna" => $l ,
								);
					}
}

function pre_facturas_pedido(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	if(isset($id_pedido)){
		$id_pedido = $Sesion->set_var("id_pedido",$id_pedido,"SUBSECCION");
	}
}

function estado_factura(&$Sesion,&$aDatos) {
	//depurar_array($aDatos);
	switch($aDatos["Facturas.estado"]){
		case 0 :return  "<img src=\"imag/amarillo.gif\" width=\"14\" height=\"14\">";
		case 1 :return "<img src=\"imag/verde.gif\" width=\"14\" height=\"14\">";
				  //              case 2 : return "Cobrada";
	}
}

function pedido_incompleto(&$Sesion,&$aDatos) {
	//depurar_array($aDatos);
	if($aDatos["Pedidos.id_pedido_incompleto"] != 0)
		return 1;
}

function se_puede_borrar(&$Sesion,&$aDatos){

	if($aDatos["Pedidos.id_factura"] != 0){
		$consulta= "Select estado from Facturas where  id_factura = " . $aDatos["Pedidos.id_factura"];
		$resul =  $Sesion->query($consulta);
		$row =  $Sesion->fetch_array($resul);
		if($row['estado'] == 1)
			return 0;
	}
	return 1;
}

function cf_presupuesto(&$Sesion,&$aData) {
	// print_r($aData);
	$estado = $aData['Presupuestos.estado'];
	switch ($estado) {
		case -1:
			$aData['icono_estado'] = $Sesion->get_var('bad');
			break;

		case 0:
			$aData['icono_estado'] = $Sesion->get_var('none');
			break;

		case 1:
			$aData['icono_estado'] = $Sesion->get_var('do');
			break;

		case 2:
			$oDb = $Sesion->get_db('data');
			$tmprs = $oDb->query('SELECT id_pedido FROM Pedidos WHERE id_presupuesto = '.$aData['Presupuestos.id_presupuesto']);
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_assoc($tmprs);
				$aData['pedido_de_presupuesto'] = $aTmp['id_pedido'];
			} else $aData['icono_estado'] = $Sesion->get_var('ok');
			break;
	}
	return true;
}

function pre_presupuestos_ventas(&$Sesion) {
	$Confirmar=$Sesion->fetchVar('Confirmar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$id_serie_facturacion=$Sesion->fetchVar('id_serie_facturacion','POST');
	$id_rfq =$Sesion->fetchVar('id_rfq','GET');

	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';

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
		$articulos_precios=$Sesion->fetchVar('articulos_precios','POST');
		$articulos_precios_old=$Sesion->fetchVar('articulos_precios_old','POST');

		$oPedido = $Sesion->get_var($docvar);
		if (!is_object($oPedido)) {
			$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Budget'));
			return ;
		}
		$idped = $oPedido->getId();
		$last_id = $Sesion->get_var('last_id_pedido');
		if (is_numeric($last_id) AND $last_id == $idped) {
			return NULL;
		}
		$Sesion->set_var('last_id_pedido',$idped,'SECCION');

		if ($oPedido->debug) debug("en confirmados tenemos :");
		if ($oPedido->debug) print_r($articulos_confirmados);

		if (method_exists($oPedido,'set_reciever_address') AND !$oPedido->set_reciever_address($registro['id_direccion']))
			if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

		$oPedido->setAgent($agente,TRUE);
		$oPedido->set_payment_method($forma_pago);
		$oPedido->set_currency($divisa);
		$oPedido->set_name($registro['nombre']);
		$oPedido->set_comments($registro['observaciones']);

		if ($oPedido->debug) 
			debug("nos pateamos los detalles para establecer valores");
		for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
			if (!isset($articulos_confirmados[$idx])) 
				$oPedido->del_detail($idx);
			else {
				if (!empty($observaciones[$idx])) $oPedido->set_detail_comment($idx,$observaciones[$idx]);

				$precio = $oPedido->get_price($idx);
				if ($precio != $articulos_precios[$idx]) $oPedido->set_price($idx,$articulos_precios[$idx]);

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

		$oPedido->calculate();

		$linkcrm = $Sesion->get_var('LinkCRM');
		if (!empty($linkcrm)) {
			$oRFQ = $Sesion->get_var('_presupuesto_rfq');
			if (!is_object($oRFQ) OR !is_a($oRFQ,'RFQ')) {
				if (!is_numeric($id_rfq)) $id_rfq = $Sesion->get_var('_presupuesto_id_rfq');
				if (is_numeric($id_rfq)) {
					// debug("Construyendo ... ");
					$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
					if (!$oRFQ->dbFill($id_rfq)) {
						$oRFQ = NULL;
					}
				}
			}
					
			if (is_object($oRFQ) AND is_a($oRFQ,'RFQ')) {
				$oPedido->setHeaderAttribute('id_rfq',$oRFQ->getId());
			}
		}
		$Sesion->unset_var('_presupuesto_id_rfq');
		$Sesion->unset_var('_presupuesto_rfq');

		/** **/
		$oPedido->dbDump();
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');

		// Fixme: Comprobar estas variables!
		$Sesion->unset_var("id_direccion_cliente");
		$Sesion->unset_var("id_direccion");
		/** **/
	} else { //fin de confirmar  un pedido
		// debug("Borrando el pedido en curso");
		$Sesion->unset_var($docvar);
		$Sesion->unset_var('__document_iface_varname');
		$Sesion->unset_var('_presupuesto_id_rfq');
		$Sesion->unset_var('_presupuesto_rfq');
	}

	// debug("acc: $accion_ejecutar");
	switch($accion_ejecutar) {

		case 'Revisar' : 
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbFill($id_pedido)) {
							if ($oPedido->getStatus() == $oPedido->STDOC_NONE) {
								$oPedido->setStatus($oPedido->STDOC_REVIEWED);
								$oPedido->dbDump();
							}
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
		break;

		case 'Rechazar' : 
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbFill($id_pedido)) {
							if ($oPedido->getStatus() == $oPedido->STDOC_REVIEWED) {
								$oPedido->setStatus($oPedido->STDOC_REJECTED);
								$oPedido->dbDump();
							}
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
		break;

		case 'Aprobar' : 
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbFill($id_pedido)) {
							if ($oPedido->getStatus() == $oPedido->STDOC_REVIEWED) {
								$oPedido->setStatus($oPedido->STDOC_APPROVED);
								$oPedido->dbDump();
							}
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}
		break;

		case "Borrar" : 
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbFill($id_pedido)) {
							$oPedido->delete();
							$oPedido->dbDump();
						} else {
							$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido));
						}
						$oPedido = NULL;
						unset($oPedido);
					}//hay ke borrar
		break;

		case "Recalcular" :
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
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
						$Sesion->unset_var($docvar);
					}
			break;

		case "ConvertirProforma" :
			if(is_array($registro_borrar))
				foreach($registro_borrar as $id_pedido => $valor)
					if($valor == 1){
						$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
						if ($oPedido->dbfill($id_pedido)) {
							$aPeds = $oPedido->getOrders();
							if ( !$oPedido->isProforma() AND ($oPedido->getStatus() != $oPedido->STDOC_REJECTED) AND (!is_array($aPeds) OR !sizeof($aPeds)) ) {
								$oPedido->toProforma();
								$oPedido->dbDump();
							}
						}
					}
			break;

		default:
			$Sesion->unset_var($docvar);
			break;
	}//fin del caso ke te cagas

}//fin del precode

?>
