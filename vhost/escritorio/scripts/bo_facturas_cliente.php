<?php

function pre_facturas(&$Sesion) {
	$id_cliente = $Sesion->fetchVar('id_cliente','GET POST SESSION');
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");

	//debug("glob  $id_cliente");
	//debug("ses $id_cliente_sesion");
	if(isset($id_cliente) AND $id_cliente_sesion != $id_cliente)
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	else {
		$id_cliente = $Sesion->get_var("id_cliente_promocion");
		if(!isset($id_cliente)) {
			//               debug("no hay cliente");
			return;
		}
	}
}//fin del precode


/** PHP es una kk , hay ke asignar a una variable el resultado de la evaluacion de una funcion
  o llamada a  metodo de un objeto para poder hacer algo con ese valor , tb para meter variables en sesion conviene justo
  despues de meterla ,m cogera automatikamente */
function pre_factura_cliente(&$Sesion) {
	$id_factura = $Sesion->fetchVar('id_factura','GET');
	$factura = $Sesion->fetchVar('factura','POST');
	$borrar_articulos = $Sesion->fetchVar('borrar_articulos','POST');
	$borrar_servicios = $Sesion->fetchVar('borrar_servicios','POST');
	$accion_ejecutar = $Sesion->fetchVar('accion_ejecutar','POST');
	if (!isset($accion_ejecutar)) $accion_ejecutar = $Sesion->fetchVar('accion_ejecutar','GET');
	$selecciones=$Sesion->fetchVar('selecciones','POST'); 

	$aUsr = identifica_usuarios($Sesion);
	$idfra_sess = $Sesion->get_var('id_factura');
	if(isset($id_factura))
		$Sesion->set_var("id_factura",$id_factura,'NOEXPIRE');
	elseif (is_numeric($idfra_sess)) $id_factura = $idfra_sess;
	else {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Facturas'),IM_FATALERROR);
		if (!strcasecmp($aUsr['desktop_name'],'Clientes') ) $retlnk = '?seccion=bo_facturas_cliente';
		else $retlnk = '?seccion=bo_facturas_venta';
		$Sesion->perror_link($retlnk);
		return ;
	}

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) return;
	$tmp_var = $Sesion->get_var('__document_iface_varname');
	if (!empty($tmp_var)) {
		//$oFactura = $Sesion->get_var($tmp_var);
		$oFactura = &$Sesion->getVarByRef($tmp_var);
		if (is_a($oFactura,'Invoice')) $id_fra_doc = $oFactura->getId();
	}
	$id_fra_doc = NULL;

	if (is_numeric($id_factura) AND (!is_numeric($id_fra_doc) OR $id_factura != $id_fra_doc) ) {
		$oFactura = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
		if (!$oFactura->dbFill($id_factura)) {
				$Sesion->lcMessage('INVOICE_DBFILL',array('id' => $id_factura),IM_FATALERROR);
				if (!strcasecmp($aUsr['desktop_name'],'Clientes') ) $retlnk = '?seccion=bo_facturas_cliente';
				else $retlnk = '?seccion=bo_facturas_venta';
				$Sesion->perror_link($retlnk);
				return ;
		} else {
			$Sesion->setVarByRef('oFactura_ficha',&$oFactura,'NOEXPIRE');
			$Sesion->set_var('__document_iface_varname','oFactura_ficha','NOEXPIRE');
		}
	}

	// Comprobacion de acceso al pedido:
	if (!strcasecmp($aUsr['desktop_name'],'Clientes') AND $aUsr['valor'] != $oFactura->get_reciever_id() ) {
		$Sesion->lcMessage('LCS_RECORD_ACCESS_DENIED',NULL,IM_FATALERROR);
		$Sesion->perror_link('?seccion=bo_pedidos_cliente');
		return;
	}

	$id_cliente = $oFactura->get_reciever_id();
	$Sesion->set_var('id_cliente_promocion',$id_cliente,'NOEXPIRE');
	$Sesion->set_var('id_cliente',$id_cliente,'NOEXPIRE');

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
					if (strcasecmp($factura['fecha'],$factura['fecha_old'])) $oFactura->setDate($factura['fecha']);
					if (!empty($factura['referencia_externa']) 
							AND strcasecmp($factura['referencia_externa'],$factura['referencia_externa_old']))
						$oFactura->set_ext_reference($factura['referencia_externa']);
					if (is_numeric($factura['id_forma_pago'])) $oFactura->set_payment_method($factura['id_forma_pago']);
					if (is_numeric($factura['id_agente'])) $oFactura->setAgent($factura['id_agente']);
					if (is_numeric($factura['id_serie'])) $oFactura->setSeries($factura['id_serie']);
					if (is_numeric($factura['factura_abono']) AND $factura['factura_abono']!=$factura['_old_factura_abono'] ) 
						$oFactura->setInstallment($factura['factura_abono']);
					if (!empty($factura['observaciones'])) $oFactura->set_comments($factura['observaciones']);
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
		//$Sesion->set_var('__document_iface_varname','oFactura_ficha','NOEXPIRE');
		//$Sesion->set_var('oFactura_ficha',$oFactura,'NOEXPIRE');
	} else {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Invoice'),IM_FATALERROR);
		return ;
	}

}

function emitida(&$Sesion,&$aDatos){
	$oFra = $Sesion->get_var("oFactura_ficha");
	$emitida = $oFra->getIssued();
	if ((int)$emitida) return 1;
	else return 0;
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

function post_factura_cliente(&$oSesion) {
	$total_lineas = (int)$oSesion->get_var("num_detalles")+(int)$oSesion->get_var("lineas_observaciones");
	$tmp = floor(($total_lineas / 33)); //(35 antes) Calculamos el numero de paginas (apuntando por abajo).
	if (((int)$oSesion->get_var("num_detalles") % 32)) $tmp++; // Si el resto es mayor que 0 (no es multiplo de 35) sumamos una
	// una pagina para poder visualizar las ultimas lineas, dado que antes hemos apuntado por abajo (=> 2.5 pagingas = 2 paginas
	$oSesion->set_var("paginas_totales",$tmp);
	// debug("paginas totales = $tmp");
}

function impresion_multiple_pedidos(&$Sesion) {
	static $stored;
	static $aIDs;
	static $aCfg;
	static $nCopia = 0;
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$emitir=$Sesion->fetchVar('emitir','GET');
	$factura=$Sesion->fetchVar('factura','POST');

	// debug("impresion_multiple_pedidos .. ");
	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');
	// Solo una copia si se va a mandar por email.
	$output = $Sesion->get_var('__output__name');
	if(!strcmp($output,'email')) {
		$aCfg['print_invoice_ncopies'] = NULL;
	}

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
			$oPedido = new Invoice($Sesion->App_Name,'data',inmPed_VENTA);
			$idped = array_shift($aIDs);
			if ($aCfg['print_invoice_ncopies'] > 0) {
				$nCopia++;
				$Sesion->set_var('_numero_copia',$nCopia,'INMED');
				if ($nCopia < $aCfg['print_invoice_ncopies']) array_unshift($aIDs,$idped);
				elseif ($nCopia == $aCfg['print_invoice_ncopies']) $nCopia = 0;
			} else $Sesion->unset_var('_numero_copia');

			if ($oPedido->dbfill($idped)) {
				if ((int)$emitir AND !$oPedido->getIssued()) {
					if ((int)$factura['factura_abono']) $oFactura->setInstallment($factura['factura_abono']);
					$oPedido->setIssued();
					$oPedido->dbDump();
				}
				$aInfo = $oPedido->get_info();
				if ((int)$aInfo['id_serie_contabilizable']) {
					$aEmp = $oPedido->get_issuer_info();
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
	} else {
		if ($aCfg['print_invoice_ncopies'] > 0) {
			$nCopia++;
			$Sesion->set_var('_numero_copia',$nCopia,'INMED');
			if ($nCopia <= $aCfg['print_invoice_ncopies']) {
				$oPedido = $Sesion->get_var($docvar);
			} 
		} else $Sesion->unset_var('_numero_copia');
	}

	if (is_a($oPedido,'Document')) $aInfo = $oPedido->get_info();
	return $aInfo;
}
		
function pre_imprimir(&$Sesion){
	$imprimir=$Sesion->fetchVar('imprimir','GET');
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','GET POST');
	$factura=$Sesion->fetchVar('factura','POST');
	$ticket=$Sesion->fetchVar('ticket','GET');

	if ($imprimir == 1) {
		$oFactura = $Sesion->get_var("oFactura_ficha");
		if (!is_object($oFactura) AND !is_array($registro_borrar)) return "bo_recarga_ventana.plt";
		if (is_object($oFactura)) {
			$aInfo = $oFactura->get_info();
			if ((int)$aInfo['id_serie_contabilizable']) {
				$aEmp = $oFactura->get_issuer_info();
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
		/** **
		if (!isset($ticket) OR empty($ticket)) {
			$aPlt = $Sesion->get_plt_array('print_document');
			return $aPlt[1];
		} elseif ($ticket == 1) {
			$aPlt = $Sesion->get_plt_array('print_ticket_document');
			return $aPlt[1];
		}
		/** **/
	}
	return;
}

?>
