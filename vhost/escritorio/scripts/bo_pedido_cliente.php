<?php
/** Funciones accesibles desde la ficha de pedido de venta
  global $id_pedido;
  global $registro;
  global $Generar;

  Acciones : Generar a partir de un presupuesto un pedido
 */
function pre_pedido_cliente(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$pedido=$Sesion->fetchVar('pedido','POST'); //Form Array
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST'); //Form string
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST'); //Form Array
	$selecciones=$Sesion->fetchVar('selecciones','POST'); //Form Array

	$aUsr = identifica_usuarios($Sesion);
	if(isset($id_pedido)) {
		$Sesion->set_var("id_pedido",$id_pedido);
		$oPedido = &$Sesion->getVarByRef('oPedido_ficha');
		//debug("id: $id_pedido contra byRef ".$oPedido->getId());
		if (!is_object($oPedido) OR strcasecmp(get_class($oPedido),'Order')
				OR $id_pedido != $oPedido->getId() OR strcasecmp($Sesion->get_subsecc_name(),$Sesion->get_old_subsecc_name()) ) {
			$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
			if (!$oPedido->dbfill($id_pedido)) {
				$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido),IM_FATALERROR);
				if (!strcasecmp($aUsr['desktop_name'],'Clientes') ) $retlnk = '?seccion=bo_pedidos_cliente';
				else $retlnk = '?seccion=bo_pedidos_venta';
				$Sesion->perror_link($retlnk);
				return ;
			} else {
				$Sesion->setVarByRef("oPedido_ficha",$oPedido,"NOEXPIRE");
				$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
			}
			// Comprobacion de acceso al pedido:
			if (!strcasecmp($aUsr['desktop_name'],'Clientes') AND $aUsr['valor'] != $oPedido->get_reciever_id() ) {
				$Sesion->lcMessage('LCS_RECORD_ACCESS_DENIED',NULL,IM_FATALERROR);
				$Sesion->perror_link('?seccion=bo_pedidos_cliente');
				return;
			}

			$Sesion->set_var('id_cliente_promocion',$oPedido->get_reciever_id(),'NOEXPIRE');
		}
	} else {
		//$oPedido = $Sesion->get_var("oPedido_ficha");
		$oPedido = $Sesion->getVarByRef("oPedido_ficha");
		if (!is_object($oPedido)) {
			$id_pedido = $Sesion->get_var("id_pedido");
			$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
			if (!$oPedido->dbfill($id_pedido)) {
				$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_pedido),IM_FATALERROR);
			} else {
				$Sesion->setVarByRef("oPedido_ficha",&$oPedido,"NOEXPIRE");
				$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
			}
			return ;
		} else $id_pedido = $oPedido->get_id();
		$Sesion->set_var("id_pedido",$id_pedido);
	}
	$Sesion->set_var("id_empresa",$oPedido->get_issuer_id());
	$Sesion->set_var("id_cliente",$oPedido->get_reciever_id());
	$Sesion->set_var("id_cliente_promocion",$oPedido->get_reciever_id());

	/** **
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	if (empty($id_cliente_sesion)) {
		$id_cliente = $oPedido->get_reciever_id();
		$Sesion->set_var("id_cliente_promocion",$id_cliente,"SECCION");
		$Sesion->set_var("id_cliente",$id_cliente,"SECCION");
	}
	/** */

	if(isset($accion_ejecutar)) {
		switch ($accion_ejecutar) {

			case "Borrar" :
				if (!is_array($borrar_articulos)) break;
				if ($Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_AUTHED)) {
					foreach ($borrar_articulos as $idx)
						$oPedido->del_detail($idx);
					$oPedido->calculate();
					$oPedido->dbdump();
				}
			break;

			case "Modificar":
				if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
					if (!is_array($pedido)) break;
					$oPedido->set_ext_reference($pedido['referencia_externa']);
					if (isset($pedido['id_agente'])) $oPedido->set_agent($pedido['id_agente']);
					if (isset($pedido['fecha'])) $oPedido->setDate($pedido['fecha']);
					if (is_numeric($pedido['id_direccion'])) $oPedido->set_reciever_address($pedido['id_direccion']);
					if (is_numeric($pedido['id_forma_pago'])) $oPedido->set_payment_method($pedido['id_forma_pago']);
					$oPedido->set_comments($pedido['observaciones']);

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
	//$Sesion->set_var("oPedido_ficha",$oPedido,"NOEXPIRE");
	//$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
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

function post_pedido_cliente(&$oSesion) {
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
		//$oPedido = $Sesion->get_var($docvar);
		$oPedido = &$Sesion->getVarByRef($docvar);
		$stored = 1;
		$aIDs = array();
		if (is_array($registro_borrar))
			foreach ($registro_borrar as $idped => $bool) array_push($aIDs,$idped);
		if (!sizeof($aIDs)) $aIDs = NULL;
		if (!is_object($oPedido) AND !is_array($registro_borrar)) return NULL;
	} 

	// debug("docvar: $docvar .. Pre? ".$Sesion->get_var('es_presupuesto') );
	if (empty($docvar)) $docvar = 'oPedido_ficha';

	if (is_array($aIDs) AND sizeof($aIDs)) {
		while(is_array($aIDs) AND sizeof($aIDs)) {
			$espre = $Sesion->get_var('es_presupuesto');
			if ((int)$espre) {
				$oPedido = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
				$docvar = 'oPre_ficha';
			} else {
				$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA);
				$docvar = 'oPedido_ficha';
			}
			$idped = array_shift($aIDs);
			if ($oPedido->dbfill($idped)) {
				$aEmp = $oPedido->get_issuer_info();
				$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");

				if (empty($docvar)) { $docvar = 'oPedido_ficha'; }
				$Sesion->setVarByRef($docvar,&$oPedido,'SUBSECCION');
				$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
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
					// debug(" Ruptura de pagina : $n_det ");
					if ( ($nDetalles - $n_det) > $nLineasPagina) {
						$nSplitOrig = $nSplit = $nLineasPagina;
					} else {
						// debug("Nos queda ($n_det - $nDetalles) _menos_ de una pagina ".($nDetalles - $n_det)." ... ");
						// no cabe el resto de lineas en una pagina normal, rompemos en el minimo de una pagina normal. 
						$nSplit = $nLineasPagina - $nLineasTotales;
					}
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
				else {
					$nSplit = 0;
				}
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
	$id_presupuesto=$Sesion->fetchVar('id_presupuesto','GET');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$ticket=$Sesion->fetchVar('ticket','GET');
	$es_pedido=$Sesion->fetchVar('es_pedido','GET POST SESSION');
	$es_presupuesto=$Sesion->fetchVar('es_presupuesto','GET POST SESSION');

	if (1 OR (empty($es_pedido) AND empty($es_presupuesto)) ) {
		if (!empty($id_presupuesto) AND empty($id_pedido)) {
			$es_presupuesto = 1;
			$es_pedido = 0;
		} elseif (!empty($id_pedido) AND empty($id_presupuestos)) {
			$es_presupuesto = 0;
			$es_pedido = 1;
		} else {
			$ssname = $Sesion->get_subsecc_name();
			if (stristr($ssname,'presupuesto')) {
				$es_presupuesto = 1;
				$es_pedido = 0;
			} else {
				$es_presupuesto = 0;
				$es_pedido = 1;
			}
		}
		$Sesion->set_var('es_pedido',$es_pedido,'SECCION');
		$Sesion->set_var('es_presupuesto',$es_presupuesto,'SECCION');
	} 

	if ($imprimir == 1) {
		if ($es_presupuesto) {
			$Sesion->set_var('id_serie_contabilizable',1,'SUBSECCION');
		}

		if (!isset($ticket) OR empty($ticket)) {
			$aPlt = $Sesion->get_plt_array('print_document');
			return $aPlt[1];
		} elseif ($ticket == 1) {
			$aPlt = $Sesion->get_plt_array('print_ticket_document');
			return $aPlt[1];
		}

		/** **
		$docvar = $Sesion->get_var('__document_iface_varname');
		debug("docvar = $docvar ; $es_pedido y $es_presupuesto para $id_pedido");
		if (empty($docvar) AND (int)$es_pedido) {
			$Sesion->set_var('__document_iface_varname','oPedido_ficha','NOEXPIRE');
			$Sesion->set_var('es_prespuesto',0,'NOEXPIRE');
			$docvar='oPedido_ficha';
		}
		$oPedido = $Sesion->get_var($docvar);

		if (!is_object($oPedido) AND (!(int)$es_pedido OR (int)$es_presupuesto) ) {
			$docvar='oPre_ficha';
			$Sesion->set_var('__document_iface_varname',$docvar,'NOEXPIRE');
			$Sesion->set_var('es_presupuesto',1,'NOEXPIRE');
		}
		$oPedido = $Sesion->get_var($docvar);
		debug("ped: $oPEdido de $docvar");

		if (!is_object($oPedido) AND !is_array($registro_borrar)) {
			return "bo_recarga_ventana.plt";
		}

		if (is_object($oPedido)) {
			$aEmp = $oPedido->get_issuer_info();
			$Sesion->set_var("nombre_empresa",$aEmp['razon_social'],"INMED");
		}
		$Sesion->set_var("pagina_actual",1,"INMED");
		$Sesion->set_var("lineas_observaciones",0,"INMED");
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

function pre_pedido_tipo(&$Sesion) {
	$id_pedido=$Sesion->get_var("id_pedido");
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);

	$Sesion->set_var("id_cliente",$id_cliente_sesion);
	$Sesion->set_var("id_pedido",$id_pedido);
	$Sesion->set_var("id_empresa",$usuario['id']);

	//debug("cli : $id_cliente_sesion , ped $id_pedido , emp $usuario[id]");
}

function hay_albaran(&$Sesion,&$aDatos){
	$oPedido = $Sesion->get_var("oPedido_ficha");
	$aAlb = $oPedido->get_deliveries();
	if (is_array($aAlb)) return 1;
	else return 0;
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

function hay_factura_o_albaran(&$Sesion,&$aDatos){
	$oPedido = $Sesion->get_var("oPedido_ficha");
	$aFact = $oPedido->get_invoices();
	if (is_array($aFact)) return 1;

	$aAlb = $oPedido->get_deliveries();
	if (is_array($aAlb)) return 1;
	else return 0;
}

function pre_presupuesto_cliente(&$Sesion) {
	$id_presupuesto=$Sesion->fetchVar('id_presupuesto','GET');
	$pedido=$Sesion->fetchVar('pedido','POST'); //Form Array
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST'); //Form string
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST'); //Form Array
	$documento=$Sesion->fetchVar('documento','POST'); //Form Array
	$selecciondocs=$Sesion->fetchVar('selecciones','POST'); //Form Array

	$aUsr = identifica_usuarios($Sesion);
	if(isset($id_presupuesto)) {
		$Sesion->set_var("id_presupuesto",$id_presupuesto);
		$oPre = $Sesion->get_var('oPre_ficha');
		if (!is_object($oPre) OR strcasecmp(get_class($oPre),'Budget')
				OR $id_presupuesto != $oPre->getId()) {
			$oPre = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
			if (!$oPre->dbfill($id_presupuesto)) {
				$Sesion->lcMessage('BUDGET_DBFILL',array('id' => $id_presupuesto),IM_FATALERROR);
				if (!strcasecmp($aUsr['desktop_name'],'Clientes') ) $retlnk = '?seccion=bo_pedidos_cliente';
				else $retlnk = '?seccion=bo_presupuestos_venta';
				$Sesion->perror_link($retlnk);
				return ;
			}
			// Comprobacion de acceso al pedido:
			if (!strcasecmp($aUsr['desktop_name'],'Clientes') AND $aUsr['valor'] != $oPre->get_reciever_id() ) {
				$Sesion->lcMessage('LCS_RECORD_ACCESS_DENIED',NULL,IM_FATALERROR);
				$Sesion->perror_link('?seccion=bo_pedidos_cliente');
				return;
			}

			$Sesion->set_var('id_cliente_promocion',$oPre->get_reciever_id(),'NOEXPIRE');
		}
	} else {
		$oPre = $Sesion->get_var("oPre_ficha");
		if (!is_object($oPre)) {
			$id_presupuesto = $Sesion->get_var("id_presupuesto");
			$oPre = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
			if (!$oPre->dbfill($id_presupuesto))
				$Sesion->lcMessage('BUDGET_DBFILL',array('id' => $id_presupuesto),IM_FATALERROR);
			return ;
		} else $id_presupuesto = $oPre->getId();
		$Sesion->set_var("id_presupuesto",$id_presupuesto);
	}
	$Sesion->set_var("id_empresa",$oPre->get_issuer_id());
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	if (empty($id_cliente_sesion)) {
		$id_cliente = $oPre->get_reciever_id();
		$Sesion->set_var("id_cliente_promocion",$id_cliente,"SECCION");
	}

	if(isset($accion_ejecutar)) {
		switch ($accion_ejecutar) {

			case "Revisar" :
				if ($Sesion->verifyVar('pedido',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('pedido',IKRN_VAR_CRC_AUTHED)) {
					if ($oPre->getStatus() == $oPre->STDOC_NONE) {
						$oPre->setStatus($oPre->STDOC_REVIEWED);
						$oPre->dbDump();
					}
				}
			break;

			case "Aprobar" :
				if ($Sesion->verifyVar('pedido',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('pedido',IKRN_VAR_CRC_AUTHED)) {
					if ($oPre->getStatus() == $oPre->STDOC_REVIEWED) {
						$oPre->setStatus($oPre->STDOC_APPROVED);
						$oPre->dbDump();
					}
				}
			break;

			case "Rechazar" :
				if ($Sesion->verifyVar('pedido',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('pedido',IKRN_VAR_CRC_AUTHED)) {
					if ($oPre->getStatus() == $oPre->STDOC_REVIEWED) {
						$oPre->setStatus($oPre->STDOC_REJECTED);
						$oPre->dbDump();
					}
				}
			break;

			case "Borrar" :
				if (!is_array($borrar_articulos)) break;
				if ($Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_AUTHED)) {
					foreach ($borrar_articulos as $idx)
						$oPre->del_detail($idx);
					$oPre->calculate();
					$oPre->dbDump();
				}
			break;

			case "Modificar":
				if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
					if (!is_array($pedido)) break;
					$oPre->set_ext_reference($pedido['referencia_externa']);
					if (isset($pedido['id_agente'])) $oPre->setAgent($pedido['id_agente']);
					if (isset($pedido['fecha'])) $oPre->setDate($pedido['fecha']);
					if (is_numeric($pedido['id_forma_pago'])) $oPre->set_payment_method($pedido['id_forma_pago']);
					$oPre->set_comments($pedido['observaciones']);
					$oPre->dbDump();
				}
			break;

			case 'Consolidar':
				if ($Sesion->verifyVar('pedido',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('pedido',IKRN_VAR_CRC_AUTHED)) {
					if (!is_array($pedido) OR !is_numeric($pedido['id_direccion']) ) break;
					if ($oPre->getStatus() == $oPre->STDOC_APPROVED) {
						if (!empty($pedido['referencia_externa'])) $oPre->set_ext_reference($pedido['referencia_externa']);
						if (isset($pedido['id_agente'])) $oPre->setAgent($pedido['id_agente']);
						if (isset($pedido['fecha'])) $oPre->setDate($pedido['fecha']);
						if (is_numeric($pedido['id_forma_pago'])) $oPre->set_payment_method($pedido['id_forma_pago']);
						if (is_numeric($pedido['id_direccion'])) $oPre->makeOrder($pedido['id_direccion']);
						$oPre->set_comments($pedido['observaciones']);
						$oPre->dbDump();
					}
				}
				break;

			case 'Seleccionar_rfq':
				if (is_numeric($selecciondocs) AND is_a($oPre,'Budget')) {
					$oPre->setHeaderAttribute('id_rfq',$selecciondocs);
					$oPre->dbDump();
				}
				break;

			case 'NuevoDocumento':
				$id_presupuesto = $oPre->getId();
				if (is_array($documento) AND sizeof($documento) AND 
						is_array($_FILES['document_file']) AND sizeof($_FILES['document_file']) AND is_numeric($id_presupuesto) ) {
					$oDoc = new CRMDoc($Sesion->App_Name,'crm','crmcfg',NULL);
					$documento['publicado'] = 0;
					if (is_numeric($aUsr['id_usuario']) AND !empty($aUsr['id_usuario'])) {
						$documento['id_usuario'] = $aUsr['crm_id_usuario'];
					} else {
						$documento['id_empleado'] = $aUsr['crm_id_empleado'];
					}
					if (empty($documento['nombre'])) $documento['nombre'] = $_FILES['document_file']['name'];
					$oDoc->edit($documento);
					$oDoc->uploadFile($_FILES['document_file']);
					$oDoc->dbDump();
					$iddoc = $oDoc->getId();
					if (is_numeric($iddoc)) {
						$oDb = $Sesion->get_db('data');
						$oDb->tb_replace('Presupuestos_Documentos_CRM',
								array('id_presupuesto' => $id_presupuesto, 'id_documento' => $iddoc, 'nota' => $documento['sinopsis'] ));
						$oDoc = NULL;
						break;
					}
				}
				break;

			case 'ModificarDocumentos':
				$id_presupuesto = $oPre->getId();
				if (is_array($documento) AND sizeof($documento) AND is_numeric($id_presupuesto) ) {
					$oDb = $Sesion->get_db('data');
					foreach ($documento as $iddoc => $aDoc) {
						$aDoc['id_documento'] = $iddoc;
						$aDoc['id_presupuesto'] = $id_presupuesto;
						if (is_numeric($aDoc['id_documento'])) $oDb->tb_update('Presupuestos_Documentos_CRM',$aDoc);
					}
				}
				break;

			case 'BorrarDocumentos':
				$id_presupuesto = $oPre->getId();
				if (is_array($documento) AND sizeof($documento) AND is_numeric($id_presupuesto) ) {
					$oDb = $Sesion->get_db('data');
					foreach ($documento as $iddoc => $aDoc) {
						if (is_numeric($aDoc['id_documento'])) 
							$oDb->tb_delete('Presupuestos_Documentos_CRM',array('id_presupuesto' => $id_presupuesto, 'id_documento' => $iddoc));
					}
				}
				break;

			case 'Seleccion_documentos_crm':
				$id_presupuesto = $oPre->getId();
				if (is_array($selecciondocs) AND sizeof($selecciondocs) AND is_numeric($id_presupuesto) ) {
					$oDb = $Sesion->get_db('data');
					foreach ($selecciondocs as $iddoc) {
						$oDb->tb_insert('Presupuestos_Documentos_CRM',array('id_presupuesto' => $id_presupuesto, 'id_documento' => $iddoc));
					}
				}
				break;

			case 'ConvertirProforma':
				$id_presupuesto = $oPre->getId();
				$aPeds = $oPedido->getOrders();
				if ( !$oPre->isProforma() AND ($oPre->getStatus() != $oPre->STDOC_REJECTED) AND (!is_array($aPeds) OR !sizeof($aPeds)) ) {
					$oPre->toProforma();
					$oPre->dbDump();
				}
				break;

		}
	}
	$Sesion->set_var("oPre_ficha",$oPre,"NOEXPIRE");
	$Sesion->set_var('__document_iface_varname','oPre_ficha','NOEXPIRE');

	prueba_multipart($Sesion);

	// $Sesion->unset_var("oPre_en_curso");
}//fin del precode

function prueba_multipart(&$Sesion) {
	// debug("Probando el multipart ... ");
}

?>
