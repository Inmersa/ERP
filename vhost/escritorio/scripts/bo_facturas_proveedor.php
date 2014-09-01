<?php

function pre_facturas(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");

	//debug("glob  $id_cliente");
	//debug("ses $id_cliente_sesion");
	if(isset($id_cliente) AND $id_cliente_sesion != $id_cliente)
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	else {
		$id_cliente = $Sesion->get_var("id_cliente_promocion");
		if(!isset($id_cliente)){
			//               debug("no hay cliente");
			return;
		}
	}
}//fin del precode

function pre_factura_proveedor(&$Sesion) {
	$id_factura=$Sesion->fetchVar('id_factura','GET');
	$factura=$Sesion->fetchVar('factura','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$selecciones=$Sesion->fetchVar('selecciones','POST');

	$idfra_sess = $Sesion->get_var('id_factura');
	if(isset($id_factura)) $Sesion->set_var("id_factura",$id_factura,'NOEXPIRE');
	elseif (is_numeric($idfra_sess)) $id_factura = $idfra_sess;
	else {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Facturas'));
		$Sesion->perror_link('?seccion=bo_facturas_venta');
		return ;
	}

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) return;

	if (is_numeric($id_factura)) {
		$oFactura = new Invoice($Sesion->App_Name,'data',inmPed_COMPRA);
		$oFactura->dbFill($id_factura);
		$id_proveedor = $oFactura->get_issuer_id();
	}

	switch ($accion_ejecutar) {
		case 'Emitir' :
			if (is_object($oFactura) AND !$oFactura->getIssued()) {
				if ((int)$factura['factura_abono']) $oFactura->setInstallment($factura['factura_abono']);
				$oFactura->setIssued();
				$oFactura->dbDump();
			}
			break;

		case 'DesEmitir':
			if (is_object($oFactura) AND $oFactura->getIssued()) {
				$oFactura->setUnIssued();
				$oFactura->dbDump();
			}
			break;

		case 'Modificar':
			if ($Sesion->verifyVar('factura',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('factura',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($factura)) {
					if (strcasecmp($factura['fecha'],$factura['fecha_old'])) $oFactura->set_date($factura['fecha']);
					if (!empty($factura['referencia_externa']) 
							AND strcasecmp($factura['referencia_externa'],$factura['referencia_externa_old']))
						$oFactura->set_ext_reference($factura['referencia_externa']);
					if (strcasecmp($factura['fecha'],$factura['fecha_old'])) $oFactura->set_date($factura['fecha']);
					if (is_numeric($factura['id_forma_pago'])) $oFactura->set_payment_method($factura['id_forma_pago']);
					if (is_numeric($factura['id_agente'])) $oFactura->setAgent($factura['id_agente']);
					if (is_numeric($factura['id_serie'])) $oFactura->setSeries($factura['id_serie']);
					if (is_numeric($factura['factura_abono']) AND $factura['factura_abono']!=$factura['_old_factura_abono'] ) 
						$oFactura->setInstallment($factura['factura_abono']);
					if (!empty($factura['observaciones'])) {
						$oFactura->set_comments($factura['observaciones']);
					}
					$oFactura->dbDump();
				}
			}
			break;

		case 'CargarCuenta':
			$cuenta = $oFactura->get_totals('monto_cuenta');
			if ($cuenta > 0 ) $oFactura->doChargeToAccount();
			else $oFactura->doChargeFromAccount();
			break;

		case 'Borrar':
			if (is_object($oFactura) AND !$oFactura->getIssued()) {
				if (!is_array($borrar_articulos)) {
					break;
				}
				foreach ($borrar_articulos as $idx => $bool) {
					$oFactura->del_detail($idx,NULL, ( ($borrar_servicios[$idx]) ? TRUE : FALSE ) );
				}
				if (!$oFactura->num_details()) {
					$oFactura->delete();
					$oFactura->dbDump();
					$oFactura = NULL;
				} else {
					$oFactura->dbDump();
				}
			}
			break;

		case "seleccionar_incidencias" :
			if (is_array($selecciones) OR is_numeric($selecciones)) {
				if (is_numeric($selecciones)) $aSel = array($selecciones);
				else $aSel = $selecciones;

				if (is_numeric($id_factura)) {
					foreach ($aSel as $id) 
						$oDb->tb_replace('Facturas_Incidencias_CRM',array('id_factura' => $id_factura, 'id_incidencia' => $id));
				}
			}
			break;
	}

	if (is_object($oFactura) AND !strcasecmp(get_class($oFactura),'Invoice')) {
		$Sesion->set_var('__document_iface_varname','oFactura_ficha','NOEXPIRE');
		$Sesion->set_var('oFactura_ficha',$oFactura,'NOEXPIRE');
	} else {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Invoice'));
		$Sesion->perror_link('?seccion=bo_facturas_compra');
		return;
	}
	$Sesion->set_var('id_proveedor',$id_proveedor,'SECCION');
	$Sesion->set_var('id_proveedor_promocion',$id_proveedor,'SECCION');

}

function medir_observaciones($observacion,&$Sesion) {
	$max_length = (int)$Sesion->get_var("caracteres_linea_observaciones");
	if ($max_length) $nl = ceil(strlen($observacion)/$max_length);
	if ($nl) {
		$lineas_observaciones = $Sesion->get_var("lineas_observaciones");
		$lineas_observaciones += $nl;
		$Sesion->set_var("lineas_observaciones",$lineas_observaciones,"SUBSECCION");
	}
	return $nl;
}

function hay_comentario($Sesion,$aData) {
	$tmp = trim($aData['observaciones']);
	return (!empty($tmp));
}

function pre_imprimir(&$Sesion){
	$imprimir=$Sesion->fetchVar('imprimir','GET');
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$factura=$Sesion->fetchVar('factura','POST');
	$accion_ejecutar= $Sesion->fetchVar('accion_ejecutar','POST GET');

	if ($imprimir == 1) {
		$oFactura = $Sesion->get_var("oFactura_ficha");
		if (!is_object($oFactura) AND !is_array($registro_borrar)) return "bo_recarga_ventana.plt";
		if (is_object($oFactura)) {
			$aInfo = $oFactura->get_info();
			if ((int)$aInfo['id_serie_contabilizable']) {
				$aEmp = $oFactura->get_reciever_info();
				$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");
			}
		}
		if (!strcasecmp($accion_ejecutar,'Emitir')) {
			if (is_object($oFactura) AND !$oFactura->getIssued()) {
				if ((int)$factura['factura_abono']) $oFactura->setInstallment($factura['factura_abono']);
				$oFactura->setIssued();
				$oFactura->dbDump();
				$Sesion->set_var('oFactura_ficha',$oFactura,'NOEXPIRE');
				$Sesion->set_var('__document_iface_varname','oFactura_ficha','NOEXPIRE');
			}
		}
		$Sesion->set_var("pagina_actual",1,"INMED");
		$Sesion->set_var("lineas_observaciones",0,"INMED");
		$aPlt = $Sesion->get_plt_array('print_document');
		return $aPlt[1];
	}
	return;
}

function impresion_multiple_pedidos(&$Sesion) {
	static $stored;
	static $aIDs;
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$emitir=$Sesion->fetchVar('emitir','GET');

	if (!$stored) {
		$docvar = $Sesion->get_var('__document_iface_varname');
		$oPedido = $Sesion->get_var($docvar);
		$stored = 1;
		$aIDs = array();
		if (is_array($registro_borrar))
			foreach ($registro_borrar as $idped => $bool) array_push($aIDs,$idped);
		if (!sizeof($aIDs)) $aIDs = NULL;
		if (!is_object($oPedido) AND !is_array($registro_borrar)) return NULL;
	} 

	if (empty($docvar)) $docvar = 'oFactura_ficha';

	if (is_array($aIDs) AND sizeof($aIDs)) {
		while(is_array($aIDs) AND sizeof($aIDs)) {
			$oPedido = new Invoice($Sesion->App_Name,'data',inmPed_COMPRA);
			$idped = array_shift($aIDs);
			if ($oPedido->dbfill($idped)) {
				if ((int)$emitir AND !$oPedido->getIssued()) {
					$oPedido->setIssued();
					$oPedido->dbDump();
				}
				$aInfo = $oPedido->get_info();
				if ((int)$aInfo['id_serie_contabilizable']) {
					$aEmp = $oPedido->get_reciever_info();
					$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");
				}

				if (!empty($docvar)) {
					$Sesion->set_var($docvar,$oPedido,'SUBSECCION');
					$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
				} else {
					$Sesion->set_var($docvar,$oPedido,'SUBSECCION');
					$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
				}
				break;
			} 
		}
	} 

	if (is_object($oPedido)) {
		// Calcular el numero de paginas, y posiciones de ruptura.
		$aRupturas = array();
		$nSplit = 0;
		$nSplitOrig = 0;

		$aCfg = $Sesion->get_var('_aAppConf');
		$nCarLinea = $aCfg['print_numcar_observaciones'];
		if (!is_numeric($nCarLinea)) $nCarLinea = 130;
		$nLineasPrimera = $aCfg['print_pgcabdoc_lineas'];
		if (!is_numeric($nLineasPrimera)) $nLineasPrimera = 49;
		$nLineasPagina = $aCfg['print_pgdoc_lineas'];
		if (!is_numeric($nLineasPagina)) $nLineasPagina = 76;
		$nLineasTotales = $aCfg['print_piedoc_lineas'];
		if (!is_numeric($nLineasTotales)) $nLineasTotales = 12;
		$bProductIds = (int)$aCfg['print_invoice_productids'];
		if ($oPedido->getInstallment()) $bProductIds = false;

		$nDetalles = $oPedido->num_details();
		for($i = $oPedido->first_detail(),$n_det = 1,$n_obs = 0; isset($i); $i = $oPedido->next_detail(), $n_det++) {
			if (!$nSplit) {
				if (!sizeof($aRupturas)) {
					// Primera pagina del documento
					if ($nDetalles > $nLineasPrimera) $nSplit = $nLineasPrimera;
					else $nSplit = ($nLineasPrimera - $nLineasTotales);
					$nSplitOrig = $nSplit;
				} else {
					// debug(" Ruptura de pagina : $n_det ");
					if ($nDetalles - $n_det > $nLineasPagina) {
						$nSplitOrig = $nSplit = $nLineasPagina;
					} else {
						if ( ($nDetalles - $n_det) > $nLineasPagina) {
							$nSplitOrig = $nSplit = $nLineasPagina;
						} else {
							$nSplit = $nLineasPagina - $nLineasTotales;
						}
					}
				}
			} elseif ($nSplitOrig != 0 AND ( $nSplit == ($nSplitOrig - $nLineasTotales)) ) {
				// debug("Estamos en($n_det) el linde de lo que seria una ultima pagina... comprobando ($nDetalles)");
			}

			// Medimos el temanyo del detalle de producto
			$aAlb = $oPedido->getDeliveryOrders();
			if (is_array($aAlb) AND sizeof($aAlb)) {
				$id_det = $oPedido->getDetailAttribute($oPedido->current_detail(),'id_detalle');
				$aAL = $oPedido->getDeliveryFromDbDet($id_det);
				$pidlen = 0;
				if (sizeof($aAL))
					foreach ($aAL as $ida) {
						if (!is_array($aServ)) $aServ=array();
						if (is_array($aAlb[$ida]['detalles'][$id_det]))
							foreach ($aAlb[$ida]['detalles'][$id_det] as $tmpidx => $aDet) {
								foreach ($aDet as $tmpdet) $pidlen += strlen($tmpdet);
								// Numero de Caracteres de formato: 4 ' ' '[' ']' ' ' 
								$pidlen += 4;
							}
					}
			}

			$txt = $oPedido->get_detail_comment($i);
			if (!empty($txt)) {
				if (!$bObsEnLinea) $nSplit--;
				$ntmp = floor(strlen($txt)/$nCarLinea)+1;
				// debug(strlen($txt)." caracteres a $nCarLinea por linea son $ntmp lineas");
				if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
				else $nSplit = 0;
			} else $nSplit--;
			if ($bProductIds AND $pidlen) {
				$ntmp = floor($pidlen/$nCarLinea)+1;
				if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
				else $nSplit = 0;
			}

			// No romperemos si es la primera pagina -sizeof()- y hemos recorrido menos lineas de las que compone una primera pagina
			if (!$nSplit AND ($nSplitOrig>=$nLineasPrimera OR sizeof($aRupturas)) ) array_push($aRupturas,$i);
		}

		// debug("Al final, split = $nSplit ");

		// debug("Romperemos en... ");
		// print_r($aRupturas);
		$Sesion->set_var('aRupturasPagina',$aRupturas,'SUBSECCION');
		$Sesion->set_var("paginas_totales",sizeof($aRupturas)+1);
		$Sesion->set_var("pagina_actual",1);

		return 1;
	}

}

function post_factura_proveedor(&$oSesion) {
	$total_lineas = (int)$oSesion->get_var("num_detalles")+(int)$oSesion->get_var("lineas_observaciones");
	$tmp = floor(($total_lineas / 33)); //(35 antes) Calculamos el numero de paginas (apuntando por abajo).
	if (((int)$oSesion->get_var("num_detalles") % 32)) $tmp++; // Si el resto es mayor que 0 (no es multiplo de 35) sumamos una
	// una pagina para poder visualizar las ultimas lineas, dado que antes hemos apuntado por abajo (=> 2.5 pagingas = 2 paginas
	$oSesion->set_var("paginas_totales",$tmp);
	// debug("paginas totales = $tmp");
}

function emitida(&$Sesion,&$aDatos){
	$oFra = $Sesion->get_var("oFactura_ficha");
	$emitida = $oFra->getIssued();
	if ((int)$emitida) return 1;
	else return 0;
}

?>
