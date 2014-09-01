<?php
/** Funciones accesibles desde la ficha de pedido de venta
global $id_pedido;
global $registro;
global $Generar;

Acciones : Generar a partir de un presupuesto un pedido
*/
function pre_pedido_proveedor(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$pedido=$Sesion->fetchVar('pedido','POST'); //Form Array
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST'); //Form string
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST'); //Form Array
	$selecciones=$Sesion->fetchVar('selecciones','POST'); 

	$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
	if(isset($id_pedido)) {
		$Sesion->set_var("id_pedido",$id_pedido);
		$oPedido = $Sesion->get_var('oPedido_ficha');
		if (!is_object($oPedido) OR $id_pedido != $oPedido->get_id() OR strcasecmp($Sesion->get_subsecc_name(),$Sesion->get_old_subsecc_name()) ) {
			$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
			if (!$oPedido->dbfill($id_pedido)) {
				$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido),IM_FATALERROR);
				return ;
			}
		}
	} else {
		// debug("Recogiendo el pedido de la sesion...");
		$oPedido = $Sesion->get_var("oPedido_ficha");
		if (!is_object($oPedido)) {
			$id_pedido = $Sesion->get_var("id_pedido");
			$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
			if (!$oPedido->dbfill($id_pedido)) {
				$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido),IM_FATALERROR);
				return ;
			}
		} else $id_pedido = $oPedido->get_id();
		$Sesion->set_var("id_pedido",$id_pedido);
	}
	$Sesion->set_var("id_empresa",$oPedido->get_reciever_id());
	$id_proveedor = $oPedido->get_issuer_id();
	$id_proveedor_sesion = $Sesion->get_var("id_proveedor_pedido");
	if (empty($id_proveedor_sesion)) {
		$Sesion->set_var("id_proveedor_pedido",$id_proveedor,"SECCION");
	}
	if (is_numeric($id_proveedor)) {
		$Sesion->set_var('id_proveedor',$id_proveedor,'NOEXPIRE');
		$Sesion->set_var('id_proveedor_promocion',$id_proveedor,'NOEXPIRE');
	}

	if(isset($accion_ejecutar)) {
		switch ($accion_ejecutar) {
			case "Borrar" :
				if ($Sesion->verifyVar('borrar_articulos ',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos ',IKRN_VAR_CRC_AUTHED)) {
					if (!is_array($borrar_articulos)) break;
					foreach ($borrar_articulos as $idx)
						$oPedido->del_detail($idx);
					$oPedido->calculate();
				}
			break;

			case "Modificar":
				if ($Sesion->verifyVar('pedido',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('pedido',IKRN_VAR_CRC_AUTHED)) {
					// Estas grabando la secuencia que inserta el verify a partir de 1 reg de verifyVar
					if (!is_array($pedido)) break;
					if (!empty($pedido['referencia_externa'])) $oPedido->set_ext_reference($pedido['referencia_externa']);
					if (isset($pedido['id_agente'])) $oPedido->set_agent($pedido['id_agente']);
					if (isset($pedido['fecha'])) $oPedido->setDate($pedido['fecha']);
					if (is_numeric($pedido['id_direccion'])) $oPedido->set_reciever_address($pedido['id_direccion']);
					if (isset($pedido['id_forma_pago'])) $oPedido->set_payment_method($pedido['id_forma_pago']);
					if (!empty($pedido['observaciones'])) $oPedido->set_comments($pedido['observaciones']);

					$oPedido->dbdump();
				}
			break;

			case "seleccionar_incidencias" :
				if (is_array($selecciones) OR is_numeric($selecciones)) {
					if (is_numeric($selecciones)) $aSel = array($selecciones);
					else $aSel = $selecciones;

					if (is_numeric($id_pedido)) {
						$oDb = $Sesion->get_db('data');
						foreach ($aSel as $id) 
							$oDb->tb_replace('Pedidos_Incidencias_CRM',array('id_pedido' => $id_pedido, 'id_incidencia' => $id));
					}
				}
				break;
		}
	}
	$Sesion->set_var("oPedido_ficha",$oPedido,"NOEXPIRE");
	// $Sesion->unset_var("oPedido_en_curso");
}//fin del precode

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

function post_pedido_proveedor(&$oSesion) {
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
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');

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

	if (empty($docvar)) $docvar = 'oPedido_ficha';

	if (is_array($aIDs) AND sizeof($aIDs)) {
		while(is_array($aIDs) AND sizeof($aIDs)) {
			$espre = $Sesion->get_var('es_presupuesto');
			if ((int)$espre) {
				$oPedido = new Budget($Sesion->App_Name,'data',inmPed_COMPRA);
				$docvar = 'oPre_ficha';
			} else {
				$oPedido = new Order($Sesion->App_Name,'data',inmPed_COMPRA);
				$docvar = 'oPedido_ficha';
			}
			$idped = array_shift($aIDs);
			if ($oPedido->dbfill($idped)) {
				$aEmp = $oPedido->get_reciever_info();
				$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");

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
		$nDetalles = $oPedido->num_details();
		for($i = $oPedido->first_detail(),$n_det = 1,$n_obs = 0; isset($i); $i = $oPedido->next_detail(), $n_det++) {
			if (!$nSplit) {
				if (!sizeof($aRupturas)) {
					// Primera pagina del documento
					if ($nDetalles > $nLineasPrimera) $nSplit = $nLineasPrimera;
					else $nSplit = ($nLineasPrimera - $nLineasTotales);
					$nSplitOrig = $nSplit;
				} else {
				}
			} elseif ($nSplitOrig != 0 AND ( $nSplit == ($nSplitOrig - $nLineasTotales)) ) {
				// debug("Estamos en($n_det) el linde de lo que seria una ultima pagina... comprobando ($nDetalles)");
			}

			$txt = $oPedido->get_detail_comment($i);
			if (!empty($txt)) {
				// Si no van las observaciones en la misma linea que el nombre, restamos ya la linea del nombre.
				if (!$bObsEnLinea) $nSplit--;
				$ntmp = floor(strlen($txt)/$nCarLinea)+1;
				// debug(strlen($txt)." caracteres a $nCarLinea por linea son $ntmp lineas");
				if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
				else $nSplit = 0;
			} else {
				$nSplit--;
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
	} else return NULL;

}

function pre_imprimir(&$Sesion){
	$imprimir=$Sesion->fetchVar('imprimir','GET');
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	if ($imprimir == 1) {
		$docvar = $Sesion->get_var('__document_iface_varname');
		if (empty($docvar)) {
			$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
			$docvar='oPedido_ficha';
		}
		$oPedido = $Sesion->get_var($docvar);
		if (!is_object($oPedido) AND !is_array($registro_borrar)) return "bo_recarga_ventana.plt";
		if (is_object($oPedido)) {
			$aEmp = $oPedido->get_reciever_info();
			$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");
		}
		$Sesion->set_var("pagina_actual",1,"INMED");
		$Sesion->set_var("lineas_observaciones",0,"INMED");
		$aPlt = $Sesion->get_plt_array('print_document');
		return $aPlt[1];
		// return "bo_pedido_cliente2.plt";
	}
	return;
}

function pre_pedido_tipo(&$Sesion) {
	$id_pedido=$Sesion->get_var("id_pedido");
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);

	$Sesion->set_var("id_cliente",$id_cliente_sesion);
	$Sesion->set_var("id_pedido",$id_pedido);
	$Sesion->set_var("id_empresa",$usuario['id']);

	//debug("cli : $id_cliente_sesion , ped $id_pedido , emp $usuario[id]");
}

function nomodificar_detalles(&$Sesion,&$aDatos){
	$docvar = $Sesion->get_var('__document_iface_varname');
	$oPedido = $Sesion->get_var($docvar);
	if (!is_object($oPedido)) return 1;
	if (!strcasecmp(get_class($oPedido),'Order')) {
		$aFact = $oPedido->get_invoices();
	} elseif (!strcasecmp(get_class($oPedido),'Budget')) {
		$aFact = $oPedido->getOrders();
		$Sesion->set_var('id_pedido_presupuesto',$aFac['id_pedido'],'INMED');
		if ($oPedido->getStatus() != 0 AND !is_array($aFact)) $aFact = array('id'=>0);
	}

	if (is_array($aFact)) return 1;
	else return 0;
}

function hay_albaran(&$Sesion,&$aDatos){
	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) return NULL;
	$oPedido = $Sesion->get_var($docvar);
	$aAlb = $oPedido->get_deliveries();
	if (is_array($aAlb)) return 1;
	else return 0;
}

function hay_factura(&$Sesion,&$aDatos){
	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) return NULL;
	$oPedido = $Sesion->get_var($docvar);
	$aFact = $oPedido->get_invoices();
	if (is_array($aFact)) return 1;
	else return 0;
}

function hay_factura_o_albaran(&$Sesion,&$aDatos){
	$oPedido = $Sesion->get_var("oPedido_en_curso");
	$aFact = $oPedido->get_invoices();
	if (is_array($aFact)) return 1;

	$aAlb = $oPedido->get_deliveries();
	if (is_array($aAlb)) return 1;
	else return 0;
}

?>
