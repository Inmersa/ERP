<?php 

include_inm('scripts/bo_albaranes_venta.php');

/** Presentacion de albaran
 * meter en la sesion almacen y numero de paginas para la impresion */

function pre_albaran (&$Sesion) {
	$id_albaran=$Sesion->fetchVar('id_albaran','GET');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST SESSION');
	$aDetalles=$Sesion->fetchVar('detalles_albaran','POST SESSION',NULL,'Detalles_albaran');
	$registro=$Sesion->fetchVar('registro','POST',NULL,'Albaranes');

	$detalle_devuelto=$Sesion->fetchVar('detalle_devuelto','POST');
	$detalle=$Sesion->fetchVar('detalle','POST');
	$selecciones=$Sesion->fetchVar('selecciones','POST');
	$aDetallesCheck = $Sesion->fetchVar('detalle_devuelto','POST');

	$usr = identifica_usuarios($Sesion);
	$id_empresa = $usr['id'];

	$oDb = $Sesion->get_db ('data');
	if (is_numeric($id_albaran))
		$Sesion->set_var ("id_albaran", $id_albaran,'NOEXPIRE');
	else {
		$id_albaran = $Sesion->get_var ("id_albaran");
		if (!is_numeric($id_albaran)) {
			$Sesion->lcMessage('LCS_NOID',array('entidad'=>'Albaranes','id'=>$id_albaran),IM_FATALERROR);
			return;
		}
		// Para el buscador?
		$i = $id_albaran;
		global $id_albaran;
		$id_albaran = $i;
	}

	//$oAlb = $Sesion->get_var('oAlbaran');
	$oAlb = &$Sesion->getVarByRef('oAlbaran');
	if (!is_a($oAlb,'DeliveryNote') OR $id_albaran != $oAlb->getId()) {
//		 debug("Ojo, _siempre_ poblamos : Creando _nueva_ instancia a partir de los valores en la bdd");
		$oAlb = new DeliveryNote();
		$oAlb->dbFill($id_albaran);
		$Sesion->setVarByRef('oAlbaran',$oAlb,'SECCION');
	} else {
//		debug("Instancia recuperada ... ");
		$id_albaran = $oAlb->getId();
	}

	switch ($accion_ejecutar) {
		case "Rellenar" :
			$oAlb->LocateProduct(NULL,true);
			$oAlb->Dump();
			break;

		case "GenerarLocalizaciones" :
			debug("Generando Localizaciones ... ");
			$oAlb->LocateProduct();
			$oAlb->Dump();
			break;

		case "Modificar":
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro['preparado'] = (int)$registro['preparado'];
				$registro['enviado'] = (int)$registro['enviado'];
				$registro['confirmacion'] = (int)$registro['confirmacion'];
				debug("Reg: ");
				print_r($registro);
				$oAlb->update($registro);

				if (is_array($aDetalles) and sizeof($aDetalles)) {
					$oAlb->updateDetails($aDetalles);
				}
				// debug("<b>_no_ volcamos</b> pero probamos el post ");
				// $oAlb->postDump(true,'db');
				$oAlb->Dump();
			} // else debug("No hay var registro... no hacemos nada. Tite");
			break;

		case "Confirmar" :
			if (is_array($aDetallesCheck) and sizeof($aDetallesCheck)) {
				$oDet = &$oAlb->getDetails();
				foreach ($aDetallesCheck as $idx => $aDet) {
					debug("confirmacion de detalles ($idx) cantidad : ".$aDetalles[$idx]['cantidad']);
					$oDet->setVerified($aDetalles[$idx]['cantidad'],$idx);
				}
				$oDet->Dump();
				// debug("De momento _no_ volcamos ... ");
				// debug(" .. Pero Imitamos ! ");
				// $oAlb->postDump(true,'db');
			}
			break;

		case "Borrar":
			if (is_array($aDetallesCheck) and sizeof($aDetallesCheck)) {
				$oDet = &$oAlb->getDetails();
				foreach ($aDetalles as $idx => $aDet) {
					//debug("Borrado de detalles <b>deshabilitado</b> temporalmente ... ");
					//$oDet->delete($idx);
				}
				$oDet->Dump();
			}
			break;

		case "seleccionar_incidencias" :
			if (is_array($selecciones) OR is_numeric($selecciones)) {
				if (is_numeric($selecciones)) $aSel = array($selecciones);
				else $aSel = $selecciones;

				if (is_numeric($id_albaran)) {
					foreach ($aSel as $id) 
						$oDb->tb_replace('Albaranes_Incidencias_CRM',array('id_albaran' => $id_albaran, 'id_incidencia' => $id));
				}
			}
			break;

	}

	//$Sesion->set_var('oAlbaran',$oAlb);
	$Sesion->set_var('__dbItemMultiEntity_varname','oAlbaran','SUBSECCION');
	$Sesion->set_var('__IndexList_varname','oAlbaran','SUBSECCION');
	$Sesion->set_var('__IndexList_method','getDetails','SUBSECCION');

}

function pre_albaran_localizaciones(&$Sesion) {
	$id_albaran=$Sesion->fetchVar('id_albaran','SESSION GET');
	$detalle_devuelto=$Sesion->fetchVar('detalle_devuelto','POST');
	$record=$Sesion->fetchVar('oldrecord','POST',NULL,'Detalles_albaran');
	$accion_ejecutar=$Sesion->fetchVar('accion','POST');
	$detalles=$Sesion->fetchVar('detalles_localizacion','POST',NULL,'Localizacion_articulos');

	$aPlt = $Sesion->get_plt_array('cerrar_ventana');
	if (!is_array($aPlt) OR !sizeof($aPlt)) {
		$Sesion->lcMessage('LCS_PLT_MISCONF',array('msg' => 'Plantilla de cierre de ventana'));
		$Sesion->perror_link('javascript: window.close()');
		return;
	} else {
		$close_plt = $aPlt[1];
	}

	switch ($accion_ejecutar) {
		case 'Localizaciones':
			$Sesion->set_var('accion_ejecutar','Modificar','INMED');
			if (is_array($record) AND sizeof($record)) {
				if (!is_array($aDets)) $aDets = array();
				$aAgrupar = array();

				foreach ($record as $idx => $aOld) {
					if (is_numeric($detalles[$idx]['num'])) {
						foreach ($detalles[$idx][$detalles[$idx]['num']] as $campo => $valor) {
							$aDets[$idx][$campo] = $valor;
						}
						if ((int)$detalles[$idx]['agrupar'] OR (int)$detalles[$idx]['agrupar_albaranes']) {
							$bMatch = true;
							foreach ($detalles[$idx][$detalles[$idx]['num']] as $campo => $valor) {
								if ($record[$idx][$campo]!=$valor) {
									$bMatch = false;
									break;
								}
							}
							if (!$bMatch) {
								// Si no son iguales, las localizaciones, es cuando agruparemos.
								$aTmp['agrupar'] = (int)$detalles[$idx]['agrupar'];
								$aTmp['agrupar_albaranes'] = (int)$detalles[$idx]['agrupar_albaranes'];
								$aTmp['origen'] = $record[$idx];
								$aTmp['destino'] = $aDets[$idx];
								array_push($aAgrupar,$aTmp);
							}
						}
					}
				}
				$Sesion->set_var('detalles_albaran',$aDets,'INMED');

				pre_albaran($Sesion);

				if (is_array($aAgrupar) AND sizeof($aAgrupar)) {
					$oDb = $Sesion->get_db('data');
					foreach ($aAgrupar as $aGrupo) {

						$fecha_fmt = wol_db::formatear_fecha($aGrupo['origen']['fecha_caducidad'],false);
						if (!strcasecmp($fecha_fmt,'NULL')) $fecha_fmt = '"0000-00-00"';
						else $fecha_fmt = '"'.$fecha_fmt.'"';
						$aGrupo['origen']['fecha_fmt'] = $fecha_fmt;

						$fecha_fmt = wol_db::formatear_fecha($aGrupo['destino']['fecha_caducidad'],false);
						if (!strcasecmp($fecha_fmt,'NULL')) $fecha_fmt = '"0000-00-00"';
						else $fecha_fmt = '"'.$fecha_fmt.'"';
						$aGrupo['destino']['fecha_fmt'] = $fecha_fmt;

						if ($aGrupo['agrupar']) {
							$cons = 'SELECT cantidad FROM Localizacion_articulos WHERE '.
									"id_articulo = ".$aGrupo['origen']['id_articulo']." AND ".
									"id_almacen_logico = ".$aGrupo['origen']['id_almacen_logico']." AND ".
									( (is_numeric($aGrupo['origen']['planta'])) ? "planta = ".$aGrupo['origen']['planta']." AND " : '').
									( (is_numeric($aGrupo['origen']['pasillo'])) ? "pasillo = ".$aGrupo['origen']['pasillo']." AND " : '').
									( (is_numeric($aGrupo['origen']['fila'])) ? "fila = ".$aGrupo['origen']['fila']." AND " : '').
									( (is_numeric($aGrupo['origen']['columna'])) ? "columna = ".$aGrupo['origen']['columna']." AND " : '').
									"lote = '".$aGrupo['origen']['lote']."' AND ".
									"fecha_caducidad = ".$aGrupo['origen']['fecha_fmt'];
							// debug($cons);
							$origrs = $oDb->query($cons);
							if ($oDb->num_rows($origrs)) {
								$aOrig = $oDb->fetch_row($origrs);
								$oDb->libera($origrs);

								if ($aOrig[0] != 0) {

									$cons = 'SELECT cantidad FROM Localizacion_articulos WHERE '.
											"id_articulo = ".$aGrupo['destino']['id_articulo']." AND ".
											"id_almacen_logico = ".$aGrupo['destino']['id_almacen_logico']." AND ".
											( (is_numeric($aGrupo['destino']['planta'])) ? "planta = ".$aGrupo['destino']['planta']." AND " : '').
											( (is_numeric($aGrupo['destino']['pasillo'])) ? "pasillo = ".$aGrupo['destino']['pasillo']." AND " : '').
											( (is_numeric($aGrupo['destino']['fila'])) ? "fila = ".$aGrupo['destino']['fila']." AND " : '').
											( (is_numeric($aGrupo['destino']['columna'])) ? "columna = ".$aGrupo['destino']['columna']." AND " : '').
											"lote = '".$aGrupo['destino']['lote']."' AND ".
											"fecha_caducidad = ".$aGrupo['destino']['fecha_fmt'];
									// debug($cons);
									$destrs = $oDb->query($cons);
										

									if ($oDb->num_rows($destrs)) {
										$aGrupo['destino']['cantidad'] = $aOrig[0];
										sql_update_stock($oDb,$aGrupo['destino']);

										// debug("Hacemos aqui LOS sql_update_stock de ".$aOrig[0]." En : ");
										// print_r($aGrupo['destino']);
									} else {
										$aGrupo['destino']['fecha_alta'] = date('Y-m-d H:m:i');
										$oDb->tb_replace('Localizacion_articulos',$aGrupo['destino']);

										// debug("Hacemos aqui LOS tb_replace de ".$aOrig[0]." En : ");
										// print_r($aGrupo['destino']);
									}

									$aGrupo['origen']['cantidad'] = $aOrig[0] * -1;
									sql_update_stock($oDb,$aGrupo['origen']);
									// print_r($aGrupo['origen']);

									$oDb->libera($destrs);
								}
							} else $oDb->libera($origrs);
						}
						if ($aGrupo['agrupar_albaranes']) {
							$cons = 'SELECT P.id_direccion,P.id_proveedor FROM Pedidos P, Albaranes A WHERE A.id_pedido = P.id_pedido AND A.id_albaran = '.$id_albaran;
							$tmprs = $oDb->query($cons);
							if ($oDb->num_rows($tmprs)) {
								$aTmp = $oDb->fetch_row($tmprs);
								if (!empty($aTmp[0])) $bVenta = true;
								else $bVenta = false;
								$oDb->libera($tmprs);

								$cons = 'SELECT Da.id_detalle FROM Detalles_albaran Da, Lineas_detalle Ld, Albaranes A, Pedidos P WHERE '.
										'A.id_albaran = Da.id_albaran AND Ld.id_detalle=Da.id_detalle AND A.id_pedido = P.id_pedido '.
										'AND A.preparado = 0 AND A.enviado = 0 AND A.confirmacion = 0 AND '.
										( ($bVenta) ? 'P.id_direccion IS NOT NULL AND P.id_direccion != 0' : 'P.id_proveedor IS NOT NULL AND P.id_proveedor != 0' ).
										' AND Ld.id_articulo = '.$aGrupo['origen']['id_articulo'].' AND '.
										"Da.id_almacen_logico = ".$aGrupo['origen']['id_almacen_logico']." AND ".
										( (is_numeric($aGrupo['origen']['planta'])) ? "Da.planta = ".$aGrupo['origen']['planta']." AND " : '').
										( (is_numeric($aGrupo['origen']['pasillo'])) ? "Da.pasillo = ".$aGrupo['origen']['pasillo']." AND " : '').
										( (is_numeric($aGrupo['origen']['fila'])) ? "Da.fila = ".$aGrupo['origen']['fila']." AND " : '').
										( (is_numeric($aGrupo['origen']['columna'])) ? "Da.columna = ".$aGrupo['origen']['columna']." AND " : '').
										"Da.lote = '".$aGrupo['origen']['lote']."' AND ".
										"Da.fecha_caducidad = ".$aGrupo['origen']['fecha_fmt'];
								// debug($cons);
								$origrs = $oDb->query($cons);
								if ($oDb->num_rows($origrs)) {
									while ( $aOrig = $oDb->fetch_row($origrs)) {
										$str_detalles .= ( (empty($str_detalles)) ? ' ( ' : ' OR ' ).'id_detalle='.$aOrig[0];
									}
									$str_detalles .= ' ) ';

									$cons = 'UPDATE Detalles_albaran SET '.
											"id_almacen_logico = ".$aGrupo['destino']['id_almacen_logico']." , ".
											( (is_numeric($aGrupo['destino']['planta'])) ? "planta = ".$aGrupo['destino']['planta']." , " : '').
											( (is_numeric($aGrupo['destino']['pasillo'])) ? "pasillo = ".$aGrupo['destino']['pasillo']." , " : '').
											( (is_numeric($aGrupo['destino']['fila'])) ? "fila = ".$aGrupo['destino']['fila']." , " : '').
											( (is_numeric($aGrupo['destino']['columna'])) ? "columna = ".$aGrupo['destino']['columna']." , " : '').
											"lote = '".$aGrupo['destino']['lote']."' , ".
											"fecha_caducidad = ".$aGrupo['destino']['fecha_fmt'].
											' WHERE '.
											"id_almacen_logico = ".$aGrupo['origen']['id_almacen_logico']." AND ".
											( (is_numeric($aGrupo['origen']['planta'])) ? "planta = ".$aGrupo['origen']['planta']." AND " : '').
											( (is_numeric($aGrupo['origen']['pasillo'])) ? "pasillo = ".$aGrupo['origen']['pasillo']." AND " : '').
											( (is_numeric($aGrupo['origen']['fila'])) ? "fila = ".$aGrupo['origen']['fila']." AND " : '').
											( (is_numeric($aGrupo['origen']['columna'])) ? "columna = ".$aGrupo['origen']['columna']." AND " : '').
											"lote = '".$aGrupo['origen']['lote']."' AND ".
											"fecha_caducidad = ".$aGrupo['origen']['fecha_fmt'].
											' AND '.$str_detalles;
									// debug($cons);
									$destrs = $oDb->query($cons);
								}
								$oDb->libera($origrs);
							}
						}

					}
				}

				return $close_plt;

			}
			break;

		default:
			// debug("Las referencias: ");
			// print_r($detalle_devuelto);
			$Sesion->set_var('referencias',$detalle_devuelto,'SUBSECCION');
			$Sesion->set_var('localizaciones_oldrecord',$record,'SUBSECCION');
			break;
	}

}

function cf_localizaciones_albaran(&$Sesion,$aData) {
	static $aCampos = array('id_albaran','id_detalle','id_almacen_logico','planta','pasillo','fila','columna','lote','fecha_caducidad');

	$aDets = $Sesion->get_var('referencias');
	if (!is_array($aDets) OR !sizeof($aDets)) return false;
	$aRec = $Sesion->get_var('localizaciones_oldrecord');
	if (!is_array($aRec) OR !sizeof($aRec)) return false;

	$Sesion->unset_var('idx_albaran');
	foreach ($aDets as $idx => $idart) {
		$bFound = true;
		foreach ($aCampos as $fld) {
			if (strstr($fld,'fecha')) {
				if (isset($aRec[$idx][$fld]))
					$aRec[$idx][$fld] = wol_db::formatear_fecha($aRec[$idx][$fld],false);
				if (isset($aData['Detalles_albaran.'.$fld]))
					$aData['Detalles_albaran.'.$fld] = wol_db::formatear_fecha($aData['Detalles_albaran.'.$fld],false);
			}
			if ($aRec[$idx][$fld] != $aData['Detalles_albaran.'.$fld]) {
				$bFound = false;
				break;
			}
		}
		if ($bFound) {
			$Sesion->set_var('idx_albaran',$idx);
			break;
		}
	}

	return $bFound;
}

function cf_match_localizacion(&$Sesion,$aData) {
	$id = $Sesion->get_var('id_art');
	$idx = $Sesion->get_var('idx_albaran');
	$aDets = $Sesion->get_var('referencias');
	$record = $Sesion->get_var('localizaciones_oldrecord');

	$Sesion->unset_var('check_match_localizacion');
	if ( $record[$idx]['planta'] == $aData['Localizacion_articulos.planta'] AND
			$record[$idx]['pasillo'] == $aData['Localizacion_articulos.pasillo'] AND
			$record[$idx]['columna'] == $aData['Localizacion_articulos.columna'] AND
			$record[$idx]['fila'] == $aData['Localizacion_articulos.fila'] AND
			$record[$idx]['lote'] == $aData['Localizacion_articulos.lote'] AND
			wol_db::formatear_fecha($record[$idx]['fecha_caducidad'],false) == wol_db::formatear_fecha($aData['Localizacion_articulos.fecha_caducidad'],false) ) {
		$Sesion->set_var('check_match_localizacion','checked="checked"');
	}

	return true;
}


function pre_albaran_envio (&$Sesion) {
	$id_albaran=$Sesion->fetchVar('id_albaran','GET POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$enviar=(int)$Sesion->fetchVar('enviar','GET POST');

	if (is_numeric($id_albaran)) {
		$Sesion->set_var('id_albaran',$id_albaran,'SECCION');
		$Sesion->set_var('albaranes_list',' Albaranes.id_albaran = '.$id_albaran,'SECCION');
	} else {
		if (is_array($registro_borrar) AND sizeof($registro_borrar)) {
			foreach ($registro_borrar as $idalb => $anah) {
				$str_where .= (!empty($str_where) ? ' OR ' : ' ').'Albaranes.id_albaran = '.$idalb;
			}
			$Sesion->set_var('albaranes_list',$str_where,'SECCION');
		} else {
			$Sesion->set_var('albaranes_list',' Albaranes.id_albaran = 0 ','SECCION');
		}
		$alblist = $Sesion->get_var('albaranes_list');
		if ($enviar AND !empty($alblist)) {
			$oDb = $Sesion->get_db('data');
			$cons = 'UPDATE Albaranes set fecha_envio=IF(enviado,fecha_envio,NOW()),enviado = 1 WHERE '.$alblist;
			$oDb->query($cons);
		}
	}
}

function cf_calcular_paginado(&$Sesion,$aData) {
	if (!is_numeric($aData['Albaranes.id_albaran'])) return false;

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) return true;
	$solo_devueltos = (int)$Sesion->get_var('solo_detalles_devueltos');
	// 30 Lineas por pagina y 130 caracteres de observaciones por linea
	$cons = 'SELECT Da.id_detalle, Da.observaciones, Da.id_almacen_logico, Da.planta, Da.pasillo, Da.columna, Da.fila, Da.lote, Da.fecha_caducidad '.
				'FROM Detalles_albaran Da '.
				'WHERE Da.id_albaran = '.$aData['Albaranes.id_albaran'].
				( ($solo_devueltos)
				  ? ' AND Da.cantidad_devuelta != 0 '
				  : ''
				);
	$tmprs = $oDb->query($cons);

	$nDetalles = $oDb->num_rows($tmprs);
	if (!$nDetalles) return false;

	$Sesion->set_var('_reset_cabecera_albaran',1);

	// Calcular el numero de paginas, y posiciones de ruptura.
	$aCfg = $Sesion->get_var('_aAppConf');
	$aRupturas = array();
	$nSplit = 0;
	$nRatioDif = 24.48;
	$nCarLinea = $aCfg['print_ncar_linea'];
	if (!is_numeric($nCarLinea)) $nCarLinea = 130;
	$nLineasPagina = $aCfg['print_pgdoc_lineas'];
	if (!is_numeric($nLineasPagina)) $nLineasPagina = 76;
	$nLineasTotales = $aCfg['print_piedoc_lineas'];
	if (!is_numeric($nLineasTotales)) $nLineasTotales = 12;
	$nLineasPrimera = $aCfg['print_pgcabdoc_lineas'];
	if (!is_numeric($nLineasPrimera)) $nLineasPrimera = 49;

	// Convertimos las lineas normales de los pedidos, a lineas con checkbox, las de pedido son un 24.48% mas grandes
	$nLineasPrimera -= round($nLineasPrimera * ($nRatioDif/100),0);
	$nLineasPagina -= round($nLineasPagina * ($nRatioDif/100),0);
   $nLineasTotales -= round($nLineasTotales * ($nRatioDif/100),0);

	// debug("Tenemos que sacar $nDetalles lineas, en la primera caben $nLineasPrimera ".($nLineasPrimera - $nLineasTotales));
	for ($n_det = 1,$n_obs = 0; $aTmp = $oDb->fetch_assoc($tmprs); $n_det++) {
		if (!$nSplit) {
			if (!sizeof($aRupturas)) {
				// Primera pagina del documento
				if ($nDetalles > $nLineasPrimera) $nSplit = $nLineasPrimera;
				else $nSplit = ($nLineasPrimera - $nLineasTotales);
				$nSplitOrig = $nSplit;
				// debug("primera pagina: ".$nSplit);
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

		$txt = $aTmp['observaciones'];
		if (!empty($txt)) {
			$ntmp = floor(strlen($txt)/$nCarLinea)+1;
			// debug(strlen($txt)." caracteres a $nCarLinea por linea son $ntmp lineas");
			if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
			else{
				$nSplit = 0;
			}
		} else {
			$nSplit--;
		}
		// debug("Al final, split: ".$nSplit." de $nSplitOrig cuando $nLineasPrimera ");

		// No se usa aRupturas, en los albaranes, se vuelve a comprobar la ruptura, dado que la ordenacion es vinculante.
		if (!$nSplit AND ($nSplitOrig>=$nLineasPrimera OR sizeof($aRupturas)) ) {
			// debug("Metiendo referencia de ruptura ... ");
			array_push($aRupturas,
					array('Detalles_albaran.id_almacen_logico' => $aTmp['id_almacen_logico'], 'Detalles_albaran.id_detalle' => $aTmp['id_detalle'], 
						'Detalles_albaran.planta' => $aTmp['planta'], 'Detalles_albaran.pasillo' => $aTmp['pasillo'], 
							'Detalles_albaran.fila' => $aTmp['fila'], 'Detalles_albaran.columna' => $aTmp['columna'],
						'Detalles_albaran.lote' => $aTmp['lote'], 'Detalles_albaran.fecha_caducidad' => $aTmp['fecha_caducidad'] ) 
					);
		}
	}

	$Sesion->set_var('aRupturasPagina',$aRupturas,'SUBSECCION');
	$Sesion->set_var("paginas_totales",sizeof($aRupturas)+1);
	$Sesion->set_var("pagina_actual",1);
	$Sesion->set_var("total_detalles",$nDetalles);

	return true;
}

function cf_albaran_valorado(&$Sesion,&$aData) {
	static $aCfg;
	static $docvar = '_oPedido_albaran';

	cf_calcular_paginado($Sesion,$aData);
	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');
	if ((int)$aCfg['deliverynote_priced'] AND !empty($aData['Pedidos.id_pedido'])) {
		$Sesion->unset_var($docvar);
		if ((int)$aData['Pedidos.id_proveedor']) {
			$tipo = inmPed_COMPRA;
			$bVenta = false;
		} else {
			$tipo = inmPed_VENTA;
			$bVenta = true;
		}
		$oPed = new Order($Sesion->App_Name,'data',$tipo);
		$oPedTmp = new Order($Sesion->App_Name,'data',$tipo);
		if ($oPed->dbFill($aData['Pedidos.id_pedido'])) {
			$Sesion->set_var('_pedido_origen_albaran',$oPed,'SUBSECICON');
			$oPedTmp->set_issuer($oPed->get_issuer_id());
			$oPedTmp->set_reciever($oPed->get_reciever_id());
			$aDir = $oPed->get_reciever_address();
			if (is_array($aDir) AND is_numeric($aDir[0]['id_direccion'])) {
				$aDir = array_shift($aDir);
				$oPedTmp->set_reciever_address($aDir['id_direccion']);

				$aDto = $oPed->get_discounts();
				if (is_array($aDto['detalle']) AND sizeof($aDto['detalle'])) 
					foreach ($aDto['detalle'] as $ord => $aD) {
						$oPedTmp->set_discount($ord,$aD['descuento'],$aD['nombre']);
					}
				else $oPedTmp->clean_discounts();

				$Sesion->set_var('__document_iface_varname',$docvar,'SUBSECCION');
				$Sesion->set_var($docvar,$oPedTmp,'SUBSECCION');
				$Sesion->set_var('valorar_detalle_albaran',1,'INMED');
			} else $Sesion->unset_var('valorar_detalle_ablaran');
		} else $Sesion->unset_var('valorar_detalle_ablaran');
	}

	return true;
}

function cf_detallealbaran_valorado(&$Sesion,$aData) {
	static $docvar = '_oPedido_albaran';
	static $docvar_orig = '_pedido_origen_albaran';
	$bValorar = false;

	if (!is_array($aCfg) OR !sizeof($aCfg)) $aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aDetalles)) $aDetalles = array();

	if ((int)$aCfg['deliverynote_priced'] AND !empty($aData['Detalles_albaran.id_detalle'])) {
		$oPed = $Sesion->get_var($docvar);
		$oPedOrig = $Sesion->get_var($docvar_orig);
		if (is_a($oPed,'Order') AND is_a($oPedOrig,'Order') AND !empty($aData['Articulos.id_articulo']) ) {
			$bValorar = true;
			// Si es un albaran valorado, usamos un pedido para relizar los calculos -no se va a volcar a la bbdd-
			$idx = $oPed->add_detail($aData['Articulos.id_articulo'],$aData['Detalles_albaran.cantidad'],NULL,false);
			// debug("Anyadido id $idx .. ".$aData['Articulos.id_articulo']." Con ".$aData['Detalles_albaran.cantidad']." y ".$oPed->get_price($idx));
			if (is_numeric($aData['Detalles_albaran.id_detalle'])) {
				$tmpidx = $oPedOrig->get_idxdetail_db($aData['Detalles_albaran.id_detalle']);
				// Si el id_detalle de la bbdd existe en el pedido original ..
				if (is_numeric($tmpidx) AND $oPedOrig->verifyDetail($tmpidx)) {
					// Es el mismo detalle, asi que a nuestro pedido le ponemos _exactamente_ las mismas condiciones de venta
					$price = $oPedOrig->get_price($tmpidx);
					$oPed->set_price($idx,$price);
					if ($oPedOrig->have_discount($tmpidx)) {
						$aDto = $oPedOrig->get_detail_discount($tmpidx);
						if ($aDto['porciento'] != 0) {
							$dto = $aDto['porciento'];
							$bPto = true;
						} else {
							$dto = $aDto['monto'];
							$bPto = false;
						}
						$oPed->set_detail_discount($idx,$dto,$bPto,$aDto['tipo'],true);
					} else $oPed->set_detail_discount($idx,0,1,NULL,true);
				}
			}
			$aDet = $oPed->get_detail($idx);
			$aTmp['precio'] = $oPed->get_price($idx);
			$aTmp['descuento'] = $aDet['tipo_descuento'];
			$aTmp['iva'] = $aDet['porcentaje'];
			$aTmp['importe'] = $aDet['base_imponible'];
			$Sesion->set_var('detalle_albaran_valorado',$aTmp,'INMED');

		} else $bValorar = false;
	} else $bValorar = false;

	if (!$bValorar) {
		$Sesion->unset_var('detalle_albaran_valorado');
	} elseif ( is_a($oPed,'Order') AND is_a($oPedOrig,'Order') ) {
		$Sesion->set_var($docvar,$oPed);
		$Sesion->set_var($docvar_orig,$oPedOrig);
	}

	return true;
}

function calculate_delivery_totals(&$oSesion) {
	static $docvar = '_oPedido_albaran';
	static $docvar_orig = '_pedido_origen_albaran';

	$oPed = $oSesion->get_var($docvar);
	if (is_a($oPed,'Order')) {
		$oPed->calculate();
		$oSesion->set_var($docvar,$oPed);
	}
}

function pre_imprimir (&$Sesion) {
	$imprimir=$Sesion->fetchVar('imprimir','GET');
	$id_albaran=$Sesion->fetchVar('id_albaran','GET SESSION');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$enviar=(int)$Sesion->fetchVar('enviar','GET POST');
	$accion=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_transportista = $Sesion->fetchVar('id_transportista','POST');

	$aPlt = $Sesion->get_plt_array('cerrar_ventana');
	if (!is_array($aPlt) OR !sizeof($aPlt)) {
		$Sesion->lcMessage('LCS_PLT_MISCONF',array('msg' => 'Plantilla de cierre de ventana'));
		$Sesion->perror_link('javascript: window.close()');
		return;
	} else {
		$close_plt = $aPlt[1];
	}
	$aPlt = $Sesion->get_plt_array('base_print_start');
	if (!is_array($aPlt) OR !sizeof($aPlt)) {
		$Sesion->lcMessage('LCS_PLT_MISCONF',array('msg' => 'Plantilla de cierre de ventana'));
		$Sesion->perror_link('javascript: window.close()');
		return;
	} else {
		$print_plt = $aPlt[1];
	}

	if ($imprimir == 1) {
		switch ($accion) {
			case 'GenerarAlbaranes':
				// Meter variables Generar y identificador_pedido
				if (is_array($registro_borrar) AND !sizeof($registro_borrar)) return $close_plt;
				$Sesion->set_var('Generar',1,'INMED');
				$Sesion->set_var('LocalizarProducto',1,'INMED');

				if (is_array($registro_borrar) AND sizeof($registro_borrar)) {
					foreach ($registro_borrar as $idped => $anah) {
						$Sesion->set_var('identificador_pedido',$idped,'INMED');
						pre_albaranes_venta($Sesion);
						$str_where .= (!empty($str_where) ? ' OR ' : ' ').'Albaranes.id_pedido = '.$idped;
					}
					$Sesion->set_var('albaranes_list',$str_where,'SECCION');
				}
				break;

			default:
				if (is_array($registro_borrar) AND sizeof($registro_borrar)) {
					foreach ($registro_borrar as $idalb => $anah) {
						$str_where .= (!empty($str_where) ? ' OR ' : ' ').'Albaranes.id_albaran = '.$idalb;
					}
					$Sesion->set_var('albaranes_list',$str_where,'SECCION');
				} else {
					if (is_numeric($id_albaran)) {
						$Sesion->set_var('id_albaran',$id_albaran,'SECCION');
						$Sesion->set_var('albaranes_list',' Albaranes.id_albaran = '.$id_albaran,'SECCION');
					} else {
						$Sesion->set_var('albaranes_list',' Albaranes.id_albaran = 0 ','SECCION');
					}
				}
				break;
		}

		return $print_plt;
	}
}

function pre_imprimir2 (&$Sesion) {
	$imprimir=$Sesion->fetchVar('imprimir','GET');
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	if ($imprimir == 1) {
		if ((int) $id_pedido) $Sesion->set_var ("id_pedido", $id_pedido);
		return "bo_albaranes_pedido2.plt";
	}
}

/** Presentacion de todos los albaranes de un pedido
  Mete en la sesion el numero de lineas de detalle para la impresion */

function pre_albaranes_pedido (&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$oDb = $Sesion->get_db ('data');
	if (isset ($id_pedido)) $Sesion->set_var ("id_pedido", $id_pedido, "SUBSECCION");
}

function calcular_total_peso (&$Sesion, $aDatos) {
	$id_pedido = (int) $Sesion->get_var ("id_pedido");
	$oDb = $Sesion->get_db ('data');
	if (!($id_pedido))
		return NULL;
	$usuario = identifica_usuarios ($Sesion);
	$cons = "SELECT SUM(EmpArt.peso_unidad) ".
		"FROM Empresas_articulos EmpArt, Articulos Art, Lineas_detalle Det ".
		"WHERE Det.id_pedido = $id_pedido AND Det.id_articulo = Art.id_articulo AND ".
		"Art.id_articulo=EmpArt.id_articulo AND EmpArt.id_empresa = $usuario[id]";
	$rs = $oDb->query ($cons);
	$aTmp = NULL;
	if ($oDb->num_rows ($rs)) {
		$aTmp = $oDb->fetch_row ($rs);
		$retval = $aTmp[0];
	}
	$oDb->libera ($rs);
	if ($retval)
		$Sesion->set_var ("total_peso", $retval, "SUBSECCION");
	return $retval;
}

function tipo_albaran (&$Sesion, &$aDatos) {
	if ($aDatos["Pedidos.id_direccion"])
		return "Venta";
	else
		return "Compra";
}

function estado_albaran (&$Sesion, &$aDatos) {
	//depurar_array($aDatos);
	$es = "";

	if ($aDatos["Albaranes.devolucion"] == 1) $es .= " Devuelto";
	elseif ($aDatos["Albaranes.confirmacion"] == 1) $es .= " Confirmado";
	elseif ($aDatos["Albaranes.enviado"] == 1) $es .= " Enviado";
	elseif ($aDatos["Albaranes.preparado"] == 1) $es .= "Listo";
	else $es = ' No preparado';
	return $es;
}

function es_cliente ($Sesion, $aDatos) {
	if ($aDatos["Pedidos.id_direccion"] != 0)
		return 1;

}

?>
