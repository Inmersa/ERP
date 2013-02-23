<?php

function pre_pda_principal(&$Sesion) {
	$tmpvar = $Sesion->fetchVar('__ajax_token','POST GET');
	if (!empty($tmpvar)) {
		debug("Setting up Ajax request on ");
		$Sesion->set_var('_Ajax_request',true,'INMED');
	}
}

function pre_albaranes_venta(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	debug("Los albaranes estos de venta: $accion ");

	switch ($accion) {
		case 'Confirmar':
			$oAlm = $Sesion->get_var('oAlmacen');
			if (is_a($oAlm,'Wherehouse')) {
				$aTmp = $oAlm->getNoteList();
				foreach ($aTmp as $idxa) {
					$oAlb = &$oAlm->getDeliveryNote($idxa);
					$oAlb->update(array('preparado' => 1));
					$oAlb->Dump();
					$oAlb = NULL;
				}
				$oAlm = NULL;
				$Sesion->unset_var('oAlmacen');
			}
			break;
	}

	return ;
}

function pre_preparar(&$Sesion) {
	$aAlb = $Sesion->fetchVar('albaranes','POST');
	$accion = $Sesion->fetchVar('accion','POST');

	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = $Sesion->get_var('oAlmacen');
	$aExcedidos = array();
	$codigo_albaran = $Sesion->fetchVar('IDAlbaran','POST GET');

	if ((!is_array($aAlb) or !sizeof($aAlb)) and !empty($codigo_albaran)) {
		if ($codigo_albaran[0] == 'A') {
			$aAlb = array();
			$aAlb[] = substr($codigo_albaran,1);
		}
	}

	debug("prepreparar: $accion ");
	switch ($accion) {
		case 'Preparar':
			// debug("Preparando .. ");
			// print_r($_POST);
			if (is_array($aAlb) and sizeof($aAlb)) {
				if (!is_a($oAlm,'Wherehouse') or $id_alm!=$oAlm->getId()) {
					$oAlm = new Wherehouse();
					if ($oAlm->dbFill($id_alm)) {
						$oAlm->makeNotesPack($aAlb);
						debug("Post make notes ... ");
					}
				} else {
					$oAlm->makeNotesPack($aAlb);
				}
				$Sesion->unset_var('__pack_locations');
			}
			break;

		case 'Confirmar':
			if ($GLOBALS['DEBUG']=='ON') {
				debug("Confirmando registros y cantidades ... ");
				print_r($aR);
			}
			$aR = $Sesion->fetchVar('rec','POST');
			if (is_array($aR) and sizeof($aR))
				foreach ($aR as $idxa => $aDetalle) {
					$oAlb = &$oAlm->getDeliveryNote($idxa);
					foreach ($aDetalle as $idx => $aD) {
						if (is_numeric($aD['cantidad']) and $aD['cantidad'] == 0) {
							debug("Ignorando $idxa / $idx .. ");
							$oAlm->setIgnoredForNotes($idxa,$idx);
							$aDetalle[$idx] = NULL;
							unset($aDetalle[$idx]);
							continue;
						}
						/** **
						// Esta comprobacion solo funciona en ventas
						if (is_numeric($aD['cantidad']) and ($aD['cantidad']+$oAlb->getDetailAttribute('cantidad'))>$oAlb->getDetailAttribute('stock_previsto')) {
						/** Soporte Compras/Ventas **/
						$aFullDetail = $oAlb->getDetailVector($idx);
						debug("for fun: cantidad ".$aD['cantidad']." pendiente: ".$aFullDetail['Detalle.cantidad_pendiente']);
						if (is_numeric($aD['cantidad']) and ($aD['cantidad']>$aFullDetail['Detalle.cantidad_pendiente']) ) {
							debug("Se sale (".$aD['cantidad'].") contra lo total: ".$aFullDetail['Detalle.cantidad_pendiente']);
							if (!is_array($aExcedidos[$idxa])) $aExcedidos[$idxa] = array();
							array_push($aExcedidos[$idxa],$idx);
						} elseif (is_numeric($aD['cantidad']) and ($aD['cantidad']<$aFullDetail['Detalle.cantidad_pendiente'])) {
							debug("Ignorando $idxa / $idx .. pendiente de configurar ->mostrar <u>otra vez</u> cantidades no satisfechas ?");
							$oAlm->setIgnoredForNotes($idxa,$idx);
						}
						$aTmpF = $aD['fecha_caducidad'];
						if (!empty($aTmpF['dia']) and is_numeric($aTmpF['dia']) and !empty($aTmpF['mes']) and is_numeric($aTmpF['mes']) and
							!empty($aTmpF['ano']) and is_numeric($aTmpF['ano']) ) {
							$aDetalle[$idx]['fecha_caducidad'] = $aTmpF['dia'].'/'.$aTmpF['mes'].'/'.$aTmpF['ano'];
						}
						$aDetalle[$idx]['__add'] = true;
					}
					if (is_array($aDetalle) and sizeof($aDetalle)) $oAlm->checkItemList($idxa,$aDetalle);
				}
			break;
	}
	
	if (false and is_array($aExcedidos) and sizeof($aExcedidos)) {
		debug("Revisando Excedidos del albaran albaran ... ");
	} else {
		if (is_a($oAlm,'Wherehouse') ) {
			$aLocs = $oAlm->previewNotes();
			if (is_array($aLocs) and sizeof ($aLocs)) {
				$Sesion->set_var('__notespack_locations_var','__pack_locations','SUBSECCION');
				$Sesion->set_var('__pack_locations',$aLocs,'SUBSECCION');
			} else {
				$Sesion->unset_var('__pack_locations');
			}
		}
	}
	if (is_object($oAlm)) $Sesion->set_var('oAlmacen',$oAlm,'SECCION');
	return;
}

function pre_revisar_venta(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	debug("Pre reviar venta no? $accion");

	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = $Sesion->get_var('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
		return;
	}

	switch ($accion) {
		case 'Revisar':
			debug("Instancia de clase: ".get_class($oAlm));
			$aTmp = $oAlm->getNoteList();
			foreach ($aTmp as $idxa) {
				$oAlb = &$oAlm->getDeliveryNote($idxa);
				debug("La nota $idxa tiene una instancia : ".get_class($oAlb));

				/** **/
				for ($i=0, $idx = $oAlb->firstDetail(); isset($idx); $idx = $oAlb->nextDetail(), $i++) {

					$aFullRef[$i] = $oAlb->getDetailVector();
					$aFullRef[$i]['idx_albaran'] = $idxa;
					$aFullRef[$i]['idx'] = $idx;
					$cnt = $oAlb->getDetailAttribute('cantidad');
					$cnt_previsto = $oAlb->getDetailAttribute('stock_previsto');
					if ($cnt_previsto > $cnt) {
						if (abs($cnt) < pow(10,-6)) {
							debug("No hay genero para idx $idx ");
						} else {
							debug("No hay _SUFICIENTE_ genero para idx $idx ");
						}
						$aFaltas[$aFullRef[$i]['Producto.id_articulo']][] = $aFullRef[$i];
					} elseif ( $cnt_previsto<$cnt ) {
						debug("Estamos sirviendo _MAS_ en $idx de lo previsto ");
						$aExcedentes[$aFullRef[$i]['Producto.id_articulo']] = $aFullRef[$i];
					}
					// print_r($aFullRef[$i]);
				}
				
				// Primero Buscamos las Localizaciones _extra_ de las referencias que no se sirvieron.
				debug("Excedentes! en : ");
				if (is_array($aExcedentes) and sizeof($aExcedentes)) foreach ($aExcedentes as $ida => $aFA) debug("id: $ida con size: ".sizeof($aFA));
				debug("Faltas! en : ");
				if (is_array($aFaltas) and sizeof($aFaltas)) foreach ($aFaltas as $ida => $aFA) debug("id: $ida con size: ".sizeof($aFA));

				/** **/
			}
			if (is_array($aExcedentes) and sizeof($aExcedentes)) {
				$Sesion->set_var('__notespack_locations_var','__pack_excedentes','SUBSECCION');
				$Sesion->set_var('__pack_excedentes',$aExcedentes,'SUBSECCION');
			} else $Sesion->unset_var('__pack_excedentes');
			if (is_array($aFaltas) and sizeof($aFaltas)) {
				$Sesion->set_var('__pack_faltas_articulos',$aFaltas,'SUBSECCION');
			} else $Sesion->unset_var('__pack_faltas_articulos');

			break;

		case 'ConfirmarExcedentes':
			$aRec = $Sesion->fetchVar('rec','POST');

			debug("Confirmando los excedentes : ");
			print_r($aRec);
			if (is_array($aRec) and sizeof($aRec)) {
				foreach ($aRec as $idxa => $aDetalle) {
					foreach ($aDetalle as $idx => $aD) {
						$aTmpF = $aD['fecha_caducidad'];
						if (!empty($aTmpF['dia']) and is_numeric($aTmpF['dia']) and !empty($aTmpF['mes']) and is_numeric($aTmpF['mes']) and
							!empty($aTmpF['ano']) and is_numeric($aTmpF['ano']) ) {
							$aDetalle[$idx]['fecha_caducidad'] = $aTmpF['dia'].'/'.$aTmpF['mes'].'/'.$aTmpF['ano'];
						}
					}
					if (is_array($aDetalle) and sizeof($aDetalle)) $oAlm->checkItemList($idxa,$aDetalle);
				}
				$Sesion->unset_var('__pack_excedentes');
			}
			break;

		case 'ConfirmarFaltas':
			$aRec = $Sesion->fetchVar('rec','POST');
			$aIndice = $Sesion->fetchVar('indice','POST');

			debug("Confirmando Las Faltas : ");
			print_r($aRec);
			debug("Indices: ");
			print_r($aIndice);
			if (is_array($aRec) and sizeof($aRec) and is_array($aIndice) and sizeof($aIndice)) {
				$mDetalles = array();
				foreach ($aIndice as $idart => $aI) {
					if (is_array($aRec[$idart]) and sizeof($aRec[$idart]) ) {
						debug("Vamos a revisar la ref $idart ");
						foreach ($aI as $idx_albaran => $aIdx) {
							$oAlb = &$oAlm->getDeliveryNote($idx_albaran);
							foreach ($aIdx as $idx => $cnt) {
								debug("Alb $idx_albaran -> $idx necesitamos $cnt ... ");
								if (is_array($aRec[$idart]) and sizeof($aRec[$idart]))
									foreach ($aRec[$idart] as $n => $aR) {
										if (is_numeric($aR['cantidad']) and !empty($aR['cantidad'])) {
											debug("Y en $n tenemos : ".$aR['cantidad']);
											if (!is_array($mDetalles[$idx_albaran][$idx])) $mDetalles[$idx_albaran][$idx] = array();
											$i = sizeof($mDetalles[$idx_albaran][$idx]);
											$aTmpF = $aR['fecha_caducidad'];
											if (!empty($aTmpF['dia']) and is_numeric($aTmpF['dia']) and !empty($aTmpF['mes']) and is_numeric($aTmpF['mes']) and
												!empty($aTmpF['ano']) and is_numeric($aTmpF['ano']) ) {
												$aR['fecha_caducidad'] = $aTmpF['dia'].'/'.$aTmpF['mes'].'/'.$aTmpF['ano'];
											}
											$mDetalles[$idx_albaran][$idx][$i] = $aR;
											$mDetalles[$idx_albaran][$idx][$i]['cantidad'] = $oAlb->getDetailAttribute('cantidad',NULL,$idx);
											if ($aR['cantidad'] > $cnt) {
												debug("Dejamos los restos ... de quitar $cnt a ".$aRec[$idart][$n]['cantidad']);
												$mDetalles[$idx_albaran][$idx][$i]['cantidad'] += $cnt;
												$aRec[$idart][$n]['cantidad'] -= $cnt;
											} else {
												debug("Ya no quedan cantidad en $n .. cepillamos ");
												$mDetalles[$idx_albaran][$idx][$i]['cantidad'] += $aR['cantidad'];
												$cnt -= $aR['cantidad'];
												$aRec[$idart][$n] = NULL;
												unset($aRec[$idart][$n]);
											}
										}
									}
							}
						}
					}
				}

				// debug("Matriz de Detalles!! ");
				// print_r($mDetalles);
				foreach ($mDetalles as $idxa => $aDetalle) if (is_array($aDetalle) and sizeof($aDetalle)) $oAlm->checkItemList($idxa,$aDetalle);
			}
			break;
	}

	$aF = $Sesion->get_var('__pack_faltas_articulos');
	debug("Revision de faltas : ");
	if (is_array($aF) and sizeof($aF)) foreach ($aF as $ida => $aFA) debug("id: $ida con size: ".sizeof($aFA));

	return;
}

function pre_moverstock_buscar(&$Sesion) {
	$rec = $Sesion->fetchVar('rec','POST');

	debug("Buscando localizacion ... ");
	print_r($rec);
	if (is_array($rec) and sizeof($rec)) 
		foreach ($rec as $fld => $val) {
			$cons .= ( (!empty($cons)) ? ' AND ' : '');
			$cons .= 'Localizacion_articulos.'.$fld.' = '.$val;
		}
	// debug("La condicion : $cons ");
	$Sesion->set_var('where_localizacion',$cons,'SUBSECCION');
}

function pre_moverstock_confirmar(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	debug("Confirmando scotk ... ".$accion);

	switch ($accion) {
		case 'Confirmar':
			debug("Confirmando: ");
			$bDo = !(bool)$Sesion->get_var('__stock_allready_moved');
			if (true or $bDo) {
				$aFrom = $Sesion->fetchVar('from','POST');
				$aDest = $Sesion->fetchVar('dst','POST');
				$aChk = $Sesion->fetchVar('chx','POST');
				$aUsr = identifica_usuarios($Sesion);
				if (!is_array($aUsr) or !sizeof($aUsr)) {
					debug("Error: No user ");
					return false;
				}
				if (!is_numeric($aUsr['id_almacen']) or empty($aUsr['id_almacen'])) {
					debug("Error: No Wherehouse ID on User ");
					return false;
				}
				$oAlm = new Wherehouse();
				if (!$oAlm->dbFill($aUsr['id_almacen'])) {
					debug("Error: Wrong Wherehouse ID on User ");
					return false;
				}
				if (!is_array($aFrom) or !sizeof($aFrom)) {
					debug("Error: No Location List ");
					return false;
				}
				$aOrig = array();

				$aDestinos = array();
				foreach ($aFrom as $idx => $aF) {
					if (is_array($aDest[$idx]) and sizeof($aDest[$idx]) and !empty($aDest[$idx]['planta']) and !empty($aDest[$idx]['pasillo']) 
							and !empty($aDest[$idx]['columna']) and !empty($aDest[$idx]['fila'])) {
						$bFound = false;
						foreach ($aDestinos as $i => $aDst) {
							if (Wherehouse::__compareLocation($aDst['loc'],$aDest[$idx],false)) {
								if (!is_array($aDestinos[$i]['from'])) $aDestinos[$i]['from'] = array();
								array_push($aDestinos[$i]['from'],$idx);
								$bFound = true;
							}
						}
						if (!$bFound) {
							$aDestinos[] = array('loc' => $aDest[$idx], 'from' => array($idx));
						}
					}
				}
				foreach ($aDestinos as $idx => $aD) {
					$aOrig = array();
					debug("Inyectando en destino: ");
					print_r($aD);
					if (is_array($aD['from']) and sizeof($aD['from'])) {
						foreach ($aD['from'] as $i) { if (is_array($aFrom[$i]) and sizeof($aFrom[$i])) { array_push($aOrig,$aFrom[$i]); } }

						if (is_array($aOrig) and sizeof($aOrig)) {
							$Sesion->set_var('__stock_allready_moved',true,'SUBSECCION');
							debug("Movimiento temporalmente deshabilitado . ");
							debug("Seria desde: ");
							print_r($aOrig);
							debug("Hacia: ");
							print_r($aD['loc']);
							if (!$oAlm->stockMovement($aOrig,$aD['loc'])) {
								debug("Error: No se ha podido desplazar el stock. ");
								return;
							}
							if (!is_array($aDList)) $aDList = array();
							$aDList[] = $aD['loc'];
							$aDList[sizeof($aDList)-1]['es_destino'] = 1;
							foreach ($aOrig as $aO) array_push($aDList,$aO);
						}

					}
				}
				$Sesion->set_var('movimientos_realizados',array($aDList),'SUBSECCION');
			}
			break;
	}
}

function pre_moverstock_menu(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');

	debug("acc: $accion ");
	switch ($accion) {
		case 'NoEncontrado':
			$aFails[] = array('code' => 'NOT_FOUND', 'msg' => 'La localizacion indicada no contiene referencias');
			break;

		case 'Seleccionar':
			$aR = $Sesion->fetchVar('rec','POST');
			$aLocList = $Sesion->get_var('__aLocList');
			if (!is_array($aLocList)) $aLocList = array();
			if (is_array($aR) and sizeof($aR)) 
				foreach ($aR as $aL) { if (is_numeric($aL['cantidad']) and !empty($aL['cantidad'])) { array_push($aLocList,$aL); } }
			$Sesion->set_var('__aLocList',$aLocList,'SECCION');
			break;

		case 'Confirmado':
			debug("OK");
			// $Sesion->unset_var('__aLocList');
			break;
	}
	$Sesion->set_var('__notespack_locations_var','__aLocList','SUBSECCION');

	if (is_array($aFails) and sizeof($aFails)) $Sesion->set_var('_elementos_fail',$aFails,'SUBSECCION');
}

function pre_tpv_inicio(&$Sesion) {
	debug("Iniciando modo TPV ... ");
	$accion = (bool)$Sesion->fetchVar('accion','POST');

	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = $Sesion->getVarByRef('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$oAlm = new Wherehouse();
		if (!$id_alm or !$oAlm->dbFill($id_alm)) {
			$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
			return;
		}
		$Sesion->setVarByRef('oAlmacen',$oAlm);
	}
	$id_direccion = $Sesion->fetchVar('id_direccion','GET POST');

	$bAddOnNew = $Sesion->fetchVar('tpvopt_addnew','POST');
	if (isset($bAddOnNew)) {
		debug("estableciendo el add new .. ");
		$Sesion->set_var('__tpv_addnew',(int)$bAddOnNew,'SECCION');
	}

	switch ($accion) {
		case 'New':
			debug("La accion era new! ");
			$bAddOnNew = (bool)$Sesion->fetchVar('tpvopt_addnew','POST');
			$Sesion->set_var('__tpv_addnew',$bAddOnNew,'SECCION');
			break;
	}

	$aAlb = $oAlm->getNoteList();
	if (!empty($id_direccion) OR (!is_array($aAlb) or !sizeof($aAlb))) {
		$id_direccion = $Sesion->fetchVar('id_direccion','GET POST SESSION');
		if (empty($id_direccion)) $id_direccion = 646;
		$Sesion->set_var('id_direccion',$id_direccion,'SECCION');
		//debug("Vamos a crear el albaran, desde 0 -no hay notas- dir $id_direccion");
		//print_r($aAlb);
		$oAlb = new DeliveryNote($GLOBALS['APP_NAME'],'data');
		$oAlb->update(array('id_almacen'=>$oAlm->getID(),'id_direccion'=>$id_direccion));
		$oAlm->makeNotesPack($oAlb);
		$Sesion->setVarByRef('oAlmacen',&$oAlm);
	}
}

function pre_tpv(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	$seccion_retorno = $Sesion->fetchVar('tpvopt_return_section','POST');
	$bAddOnNew = (bool)$Sesion->fetchVar('tpvopt_addnew','POST');
	debug("Pre revisar algo no? $accion");
	if (!empty($seccion_retorno)) {
		$Sesion->set_var('__tpv_sendto',$seccion_retorno,'SECCION');
	}
	//TODO: Falta parametro para mostrar o no localizaciones en negativo (para cuando no hay)
	//TODO: Falta parametro para anyadir la ref cuando falta en el elbaran, y en en que indices

	$aReturnStat = array();
	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = &$Sesion->getVarByRef('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
		return;
	}
	//FixME: SOLO permitir un albaran. O escoger uno, o que solo haya uno
	$albaranes = $oAlm->getNoteList();
	$idx_alb = array_shift($albaranes);
	$cbarras = $Sesion->fetchVar('CodigoBarras','POST');
	if (!isset($cbarras)) { $cbarras = $Sesion->get_var('CodigoBarras');
	} else { $Sesion->set_var('CodigoBarras',$cbarras,'SUBSECCION'); }
	$oAlb = &$oAlm->getDeliveryNote($idx_alb);

	switch ($accion) {
		case 'Info':
			debug("Info OK $cbarras ");
			$Sesion->set_var('__tpv_soloinfo',1,'INMED');
			break;

		case 'SeleccionarCBarras':
			debug("El codigo: $cbarras addOnNew: $bAddOnNew");
			if (!is_array($oAlm->idxCodBarras[$cbarras]) and $bAddOnNew) {
				$oAlb = &$oAlm->getDeliveryNote($idx_alb);
				$oDb = $Sesion->get_db('data');
				$id_emp = $oAlm->getAttribute('id_empresa');
				debug(" NO existe el codigo en el albaran. Buscando por fuera emp: ".$id_emp);
				$cons = "SELECT IF(A.codigo_barras='$cbarras',A.codigo_barras,NULL) as 'cbarras_unidad', ".
				"IF(A.codigo_barras_bulto='$cbarras',A.codigo_barras_bulto,NULL) as 'cbarras_bulto', ".
				"IF(A.codigo_barras_palet='$cbarras',A.codigo_barras_palet,NULL) as 'cbarras_palet', ".
				"Ea.unidades_bulto, Ea.bultos_capa_palet, Ea.capas_palet,A.id_articulo,A.nombre ";
				$cons .= "FROM Articulos A JOIN Empresas_articulos Ea ON (A.id_articulo=Ea.id_articulo AND Ea.id_empresa=$id_emp) ";
				$cons .= "WHERE A.codigo_barras='$cbarras' OR A.codigo_barras_bulto='$cbarras' OR A.codigo_barras_palet='$cbarras' ";
				$cons .= "LIMIT 10 ";
				$rs = $oDb->query($cons);
				if ($oDb->num_rows($rs)) {
					debug("Hay ".$oDb->num_rows($rs)." resultados ");
					while ($aTmp = $oDb->fetch_assoc($rs)) {;
						$aCnt = array();
						$aCnt[$aTmp['id_articulo']] = 1;
						if ($oAlb->isSale()) 
							$aNewLocs = $oAlm->getLocationsForCheckOut($aCnt,NULL,NULL,NULL,true,array('stock_negativo'=>true));
						else $aNewLocs = $oAlm->getLocationsForCheckIn($aCnt,NULL,NULL,NULL,true,array('stock_negativo'=>true));
						$aTmp2 = array_shift($aNewLocs);
						$aRec = $aTmp2[$aTmp['id_articulo']]['localizaciones'][0];
						if (!is_array($aRec) or !sizeof($aRec)) { 
							$aRec = array('cantidad'=>0,'stock_previsto'=>1,'id_articulo'=>$aTmp['id_articulo']);
						} else {
							$aRec['cantidad'] = 0;
							$aRec['stock_previsto'] = 1;
						}
						$idx = $oAlb->newDetail($aRec);
						$aD = $oAlb->getDetailData('DetallePedido',$idx);
						debug("Hay ".$oAlb->countDetails()." detalles metios .. este: $idx ");
						$oAlm->__buildNotesIndex();
					}
				} else {
					$Sesion->set_var('__tpv_resultados','1','INMED');
				}
			}
			$aTmp = $oAlm->idxCodBarras[$cbarras];
			if ($GLOBALS['DEBUG']=='ON') {
				debug("Las ref con este cod $cbarras : ");
				print_r($aTmp);
			}
			if (!is_array($aTmp)) $cnt = 1;
			elseif (!isset($aTmp['cnt'])) $cnt = 1;
			else $cnt = $aTmp['cnt'];
			$Sesion->set_var('tpv_cbarras_cantidad',$cnt,'SUBSECCION');
			break;

		case 'Confirmar':
			$aRec = $Sesion->fetchVar('rec','POST');
			$aNew = $Sesion->fetchVar('nloc','POST');
			if ($GLOBALS['DEBUG']=='ON') {
				debug("Confirmando, pero habra que ver de que indice ");
				print_r($aRec);
			}
			$oAlb = &$oAlm->getDeliveryNote($idx_alb);
			if (is_array($aRec) and sizeof($aRec)) 
				foreach ($aRec as $aL) 
					foreach ($aL as $idx => $aR) {
						// Esta es facil, con actualizar la linea, ya esta.
						if (is_numeric($aR['cantidad'])) $oAlb->updateDetail($aR,NULL,$idx);
					}
			$aLoc = array();
			if (is_array($aNew) and sizeof($aNew))
				foreach($aNew as $id => $aTmp)
					foreach ($aTmp as $n => $aL) {
						if (!is_numeric($aL['cantidad'])) continue;
						$aL['id_articulo'] = $id;
						if (is_array($aL['fecha_caducidad'])) 
							$aL['fecha_caducidad'] = 
								$aL['fecha_caducidad']['ano'].'-'.$aL['fecha_caducidad']['mes'].'-'.$aL['fecha_caducidad']['dia'];
						if ($GLOBALS['DEBUG']=='ON') {
							debug("Metiendo en las aLoc: ");
							print_r($aL);
						}
						array_push($aLoc,$aL);
					}
			if (is_array($aLoc) and sizeof($aLoc)) {
				$oAlb->debug(array("oAlbaran->completeWithSKU"=>$aLoc),'script->completeWithSKU');
				$oAlb->completeWithSKU($aLoc);
				$oAlm->__buildNotesIndex();
			}
			$Sesion->set_var('__tpv_resultados','1','INMED');
			$oAlb->Dump();
	}
	// $aFullRef[$i] = $oAlb->getDetailVector();
	// $aFullRef[$i]['idx_albaran'] = $idxa;
	// $aFullRef[$i]['idx'] = $idx;
	// $aFaltas[$aFullRef[$i]['Producto.id_articulo']][] = $aFullRef[$i];
	if (is_array($aFaltas) and sizeof($aFaltas)) {
		$Sesion->set_var('__pack_faltas_articulos',$aFaltas,'SUBSECCION');
	} else $Sesion->unset_var('__pack_faltas_articulos');

	if (is_a($oAlm,'Wherehouse') ) {
		debug("Almacen ok, vamos a por preview con $cbarras . ");
		// Antes del preview ... bloquear por referencia!!
		//$aLocs = $oAlm->previewNotes($cbarras);
		//$oAlm->unlockNotes();

		$oAlb = &$oAlm->getDeliveryNote($idx_alb);
		$oDet = &$oAlb->getDetails();
		$oDet->buildIndex();
		$aTT = $oDet->idxCBToRef[$cbarras];
		debug("CBarras sera: ");
		print_r($aTT);
		if (is_array($aTT) and sizeof($aTT)) {
			$aLocs = array();
			foreach ($aTT as $aTRef) {
				$aIdx = $oDet->idxRef[$aTRef['id']];
				debug("La lista de los ".$aTRef['id']);
				print_r($aIdx);
				debug("OTRA lista de los ".$aTRef['id']);
				print_r($oDet->ixReferencia($aTRef['id']));
				foreach ($aIdx as $idx) {
					$aTRec = $oAlb->getDetailVector($idx);
					$aTRec['idx'] = $idx;
					$aTRec['idx_a'] = $idx_alb;
					$aLocs[] = $aTRec;
				}
			}
		}

		debug(" Contador de localizaciones:  ".sizeof($aLocs));
		if (is_array($aLocs) and sizeof ($aLocs)) {
			//$Sesion->set_var('__notespack_locations_var','__pack_locations','SUBSECCION');
			//$Sesion->set_var('__pack_locations',$aLocs,'SUBSECCION');
			$aFaltas = array();
			//$aFaltas[] = array('key'=>$aLocs[0]['DetallePedido.id_articulo'],'value'=>$aLocs);
			$aFaltas[$aLocs[0]['DetallePedido.id_articulo']] = $aLocs;
			$Sesion->set_var('__pack_faltas_articulos',$aFaltas,'SUBSECCION');
		} else {
			$aTmp['msg'] = "No se ha encontrado ninguna referencia en el albaran para el codigo: $cbarras ";
			array_push($aReturnStat,$aTmp);
			$Sesion->set_var('__tpv_resultados','1','INMED');
			$Sesion->unset_var('__pack_locations');
		}
	}
	if (sizeof($aReturnStat)) {
		$Sesion->set_var('__tpv_return_status',$aReturnStat,'INMED');
	}
	//debug("guardando todo ..  ");
	//$Sesion->setVarByRef('oAlmacen',&$oAlm);
	// $Sesion->set_var('oAlmacen',$oAlm);
}

function pre_bajas(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	debug("Acc: $accion ");
	switch ($accion) {
		case 'CausarBaja':
			$aRec = $Sesion->fetchVar('baja','POST');
			if (is_array($aRec) and sizeof($aRec) and !empty($aRec['id_baja_almacen']))  {
				$aRec['causar_baja'] = true;
				if ($GLOBALS['DEBUG']=="ON") {
					debug("Causando baja: ");
					print_r($aRec);
				}
				$oB = new BajaAlmacen();
				$oB->update($aRec);
				$oB->Dump();
			}
			break;

		case 'SeleccionarLocalizacion':
			$aRec = $Sesion->fetchVar('localizacion_articulos','POST');
			if ($GLOBALS['DEBUG']=="ON") {
				debug("La Loca baja: ");
				print_r($aRec);
			}
			$aRecF = array();
			foreach ($aRec as $ida => $nLoc) {
				foreach ($nLoc as $j => $aLoc) {
					if (!is_numeric($aLoc['cantidad'])) continue;
					$aTmp = $aLoc;
					$aTmp['id_articulo'] = $ida;
					$aRecF[] = $aTmp;
				}
			}
			$Sesion->set_var('__notespack_locations_var','__bajas_referencia');
			$Sesion->set_var('__bajas_referencia',$aRecF);
			break;
	}
}

function pre_inventario(&$Sesion) {
	$accion = $Sesion->fetchVar('accion','POST');
	$seccion_retorno = $Sesion->fetchVar('invent_return_section','POST');
	if (!empty($seccion_retorno)) {
		$Sesion->set_var('__inventario_sendto',$seccion_retorno,'SECCION');
	}
	pre_pda_principal($Sesion);

	$cbarras = $Sesion->fetchVar('CodigoBarras','POST');
	if (!isset($cbarras)) { $cbarras = $Sesion->get_var('CodigoBarras');
	} else { $Sesion->set_var('CodigoBarras',$cbarras,'SUBSECCION'); }

	switch ($accion) {
		case 'Info':
			debug("Info OK $cbarras ");
			$Sesion->set_var('__tpv_soloinfo',1,'INMED');
			break;

		case 'SeleccionarCBarras':
			//debug("El codigo: $cbarras ");
			$Sesion->set_var('codigo_barras',$cbarras,'SUBSECCION');
			//$Sesion->set_var('invent_cbarras_cantidad',$cnt,'SUBSECCION');
			$tmp = $Sesion->get_var('_Ajax_request');
			if (!empty($tmp) and (bool)$tmp) {
				$cons = "SELECT CONCAT(LPAD(L.id_almacen_logico,2,'0'),'-',LPAD(L.planta,2,'0'),':',LPAD(L.pasillo,2,'0'),':',LPAD(L.columna,2,'0'),':',LPAD(L.planta,2,'0')) as 'localizacion', ".
							"CONCAT(L.fecha_caducidad,'*',L.lote) as 'sku', L.id_almacen_logico as 'zona', L.planta, L.pasillo, ".
							"L.columna, L.fila, L.fecha_caducidad, L.id_almacen_logico, L.id_articulo, A.nombre as 'articulo', ".
							"M.nombre as 'marca' FROM Localizacion_articulos L JOIN Articulos A ON (A.id_articulo=L.id_articulo) ".
							"JOIN Marcas M ON (M.id_marca=A.id_marca) ".
							"WHERE A.codigo_barras='".$cbarras."' OR A.codigo_barras_bulto='".$cbarras.
							"' OR A.codigo_barras_palet='".$cbarras."' ";
				$oDb = $Sesion->get_db('data');
				$rs = $oDb->query($cons);
				if ($oDb->num_rows($rs)) {
					$aJSon = array();
					while ($aTmp = $oDb->fetch_assoc($rs)) {
						array_push($aJSon,$aTmp);
					}
					header("X-JSON: ".toJSON($aJSon));
				}
				//debug("A guevo! tal con $cbarras ");
				//print_r($aJSon);
			}
			break;

	}

}

function toJSON($aVar) {
	$retval = '';
	foreach ($aVar as $key => $var) {
		if (is_array($var)) $strVal = toJSON($var);
		else {
			for ($j = 0;$j<strlen($var);$j++) { if (ord($var[$j])>128) $var[$j]='?'; }
			$strVal = '"'.$var.'"';
		}
		if (!strlen($retval)) $retval .= '{';
		else $retval .= ', ';
		$retval .= '"'.$key.'": '.$strVal;
	}
	$retval .= '}';
	return $retval;
}

function pre_albaran_search(&$Sesion) {
	$GLOBALS['DEBUG'] = "Off";
	//$GLOBALS['DEBUG'] = "ON";
	//header("X-JSON: {'var2': 'test', 'este': 'perro'}");
	$accion = $Sesion->fetchVar('accion','POST');
	$seccion_retorno = $Sesion->fetchVar('tpvopt_return_section','POST');
	$bAddOnNew = (bool)$Sesion->fetchVar('tpvopt_addnew','POST');
	debug("Pre revisar algo no? $accion");
	if (!empty($seccion_retorno)) {
		$Sesion->set_var('__tpv_sendto',$seccion_retorno,'SECCION');
	}
	//TODO: Falta parametro para mostrar o no localizaciones en negativo (para cuando no hay)
	//TODO: Falta parametro para anyadir la ref cuando falta en el elbaran, y en en que indices

	$aReturnStat = array();
	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = &$Sesion->getVarByRef('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
		return;
	}
	//FixME: SOLO permitir un albaran. O escoger uno, o que solo haya uno
	$albaranes = $oAlm->getNoteList();
	$idx_alb = array_shift($albaranes);
	$cbarras = $Sesion->fetchVar('CodigoBarras','POST');
	if (!isset($cbarras)) { $cbarras = $Sesion->get_var('CodigoBarras');
	} else { $Sesion->set_var('CodigoBarras',$cbarras,'SUBSECCION'); }
	$oAlb = &$oAlm->getDeliveryNote($idx_alb);

	if (is_a($oAlm,'Wherehouse') ) {
		$aJSon = array();
		debug("Almacen ok, vamos a por preview con $cbarras . ");
		// Antes del preview ... bloquear por referencia!!
		//$aLocs = $oAlm->previewNotes($cbarras);
		//$oAlm->unlockNotes();
		$oAlb = &$oAlm->getDeliveryNote($idx_alb);
		$aJSon['albaran'] = $oAlb->getAttribute('referencia');
		$oDet = &$oAlb->getDetails();
		$oDet->buildIndex();
		$aTT = $oDet->idxCBToRef[$cbarras];
		if ($GLOBALS['DEBUG']=="ON") {
			debug("CBarras sera: ");
			print_r($aTT);
		}
		if (is_array($aTT) and sizeof($aTT)) {
			$aLocs = array();
			foreach ($aTT as $aTRef) {
				$aIdx = $oDet->idxRef[$aTRef['id']];
				if ($GLOBALS['DEBUG']=="ON") {
					debug("La lista de los ".$aTRef['id']);
					print_r($aIdx);
					debug("OTRA lista de los ".$aTRef['id']);
					print_r($oDet->ixReferencia($aTRef['id']));
				}
				foreach ($aIdx as $idx) {
					$aTRec = $oAlb->getDetailVector($idx);
					$aTRec['idx'] = $idx;
					$aTRec['idx_a'] = $idx_alb;
					$aLocs[] = $aTRec;
				}
			}
		}

		debug(" Contador de localizaciones:  ".sizeof($aLocs));
		if (is_array($aLocs) and sizeof ($aLocs)) {
			$aJSon['detalles'] = array();
			$pte_total = 0;
			$aFLoc = array();
			$aFSKU = array();
			foreach (array_keys($aLocs) as $j) {
				$aTmp = array();
				$aTmp['id_articulo']=$aLocs[$j]['DetallePedido.id_articulo'];
				$aTmp['cantidad_pendiente']=$aLocs[$j]['Detalle.cantidad_pendiente'];
				$aTmp['cantidad']=$aLocs[$j]['Detalle.cantidad'];
				$aTmp['stock_previsto']=$aLocs[$j]['Detalle.stock_previsto'];
				$pte_total += $aTmp['cantidad_pendiente'];
				array_push($aJSon['detalles'],$aTmp);
				if (!is_array($aJSon['referencia'])) {
					$aTmp = array();
					$aTmp['id_articulo'] = $aLocs[$j]['DetallePedido.id_articulo'];
					$aTmp['nombre'] = $aLocs[$j]['Producto.nombre'];
					$aTmp['marca'] = $aLocs[$j]['Marca.nombre'];
					$aTmp['cbarras'] = $cbarras;
					$aJSon['referencia'] = $aTmp;
				}
				$tmpLoc = DeliveryEntry::strLoc($aLocs[$j]);
				if (!empty($tmpLoc) and !is_array($aFLoc[$tmpLoc])) {
					$aFLoc[$tmpLoc] = DeliveryEntry::strLoc($aLocs[$j],true);
					ksort($aFLoc);
				}
				$tmpLoc = '';
				$tmpLoc = DeliveryEntry::strFromAny($aLocs[$j],'fecha_caducidad')."*".
							DeliveryEntry::strFromAny($aLocs[$j],'lote');
				if (!empty($tmpLoc) and !is_array($aFSKU[$tmpLoc])) {
					$aTmp = split('-',DeliveryEntry::strFromAny($aLocs[$j],'fecha_caducidad'));
					$aFSKU[$tmpLoc] = array('anyo'=>$aTmp[0],'mes'=>$aTmp[1],'dia'=>$aTmp[2],'lote'=>DeliveryEntry::strFromAny($aLocs[$j],'lote'));
					ksort($aFSKU);
				}
			}
			if (is_array($aJSon) and sizeof($aJSon)) {
				if (is_array($aFLoc) and sizeof($aFLoc)) { $aJSon['localizaciones'] = $aFLoc; }
				if (is_array($aFSKU) and sizeof($aFSKU)) { $aJSon['skus'] = $aFSKU; }
				$aJSon['referencia']['cantidad_pendiente'] = $pte_total;
				header("X-JSON: ".toJSON($aJSon));
				echo "Tst: ".toJSON($aJSon);
			}
			//$Sesion->set_var('__notespack_locations_var','__pack_locations','SUBSECCION');
			//$Sesion->set_var('__pack_locations',$aLocs,'SUBSECCION');
			$aFaltas = array();
			//$aFaltas[] = array('key'=>$aLocs[0]['DetallePedido.id_articulo'],'value'=>$aLocs);
			$aFaltas[$aLocs[0]['DetallePedido.id_articulo']] = $aLocs;
			$Sesion->set_var('__pack_faltas_articulos',$aFaltas,'SUBSECCION');
		} else {
			$aTmp['msg'] = "No se ha encontrado ninguna referencia en el albaran para el codigo: $cbarras ";
			array_push($aReturnStat,$aTmp);
			$Sesion->set_var('__tpv_resultados','1','INMED');
			$Sesion->unset_var('__pack_locations');
		}
	}
	if (sizeof($aReturnStat)) {
		$Sesion->set_var('__tpv_return_status',$aReturnStat,'INMED');
	}
	//debug("guardando todo ..  ");
	//$Sesion->setVarByRef('oAlmacen',&$oAlm);
	// $Sesion->set_var('oAlmacen',$oAlm);
}

function pre_albaran_ajax(&$Sesion) {
	$GLOBALS['DEBUG'] = "Off";
	//$GLOBALS['DEBUG'] = "ON";
	$accion = $Sesion->fetchVar('accion','POST');
	$seccion_retorno = $Sesion->fetchVar('tpvopt_return_section','POST');
	$bAddOnNew = (bool)$Sesion->fetchVar('tpvopt_addnew','POST');
	if (!empty($seccion_retorno)) {
		$Sesion->set_var('__tpv_sendto',$seccion_retorno,'SECCION');
	}
	//TODO: Falta parametro para mostrar o no localizaciones en negativo (para cuando no hay)
	//TODO: Falta parametro para anyadir la ref cuando falta en el elbaran, y en en que indices

	$aReturnStat = array();
	$aUsr = identifica_usuarios($Sesion);
	$id_alm = $aUsr['id_almacen'];
	$oAlm = &$Sesion->getVarByRef('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
		return;
	}
	//FixME: SOLO permitir un albaran. O escoger uno, o que solo haya uno
	$albaranes = $oAlm->getNoteList();
	$idx_alb = array_shift($albaranes);
	$cbarras = $Sesion->fetchVar('CodigoBarras','POST');
	if (!isset($cbarras)) { $cbarras = $Sesion->get_var('CodigoBarras');
	} else { $Sesion->set_var('CodigoBarras',$cbarras,'SUBSECCION'); }
	$oAlb = &$oAlm->getDeliveryNote($idx_alb);

	$tmp = $Sesion->fetchVar('__ajax_token','POST GET');
	$aJSon['token'] = $tmp;
	switch ($accion) {
		case 'Info':
			debug("Info OK $cbarras ");
			$Sesion->set_var('__tpv_soloinfo',1,'INMED');
			break;

		case 'Confirmar':
			$aRec = $Sesion->fetchVar('rec','POST');
			if (is_array($aRec) and sizeof($aRec))
				if (!is_numeric(array_shift(array_keys($aRec)))) {
					$aRec = array(array($aRec));
				}
			$aNew = $Sesion->fetchVar('nloc','POST');
			if (is_array($aNew) and sizeof($aNew))
				if (!is_numeric(array_shift(array_keys($aNew)))) {
					$aNew = array(array($aNew));
				}
			if (false && $GLOBALS['DEBUG']=='ON') {
				debug("Confirmando, pero habra que ver de que indice ");
				print_r($aRec);
				debug("los Nuevos : ");
				print_r($aNew);
			}
			$oAlb = &$oAlm->getDeliveryNote($idx_alb);
			$oDet = &$oAlb->getDetails();
			if (is_array($aRec) and sizeof($aRec)) 
				foreach ($aRec as $aL) {
					foreach ($aL as $idx => $aR) {
						// Esta es facil, con actualizar la linea, ya esta.
						if (is_numeric($aR['cantidad'])) $oAlb->updateDetail($aR,NULL,$idx);
					}
				}
			$aLoc = array();
			if (is_array($aNew) and sizeof($aNew))
				foreach($aNew as $id => $aTmp)
					foreach ($aTmp as $n => $aL) {
						if (!is_numeric($aL['cantidad'])) continue;
						if (empty($aL['id_articulo']) and !empty($id)) $aL['id_articulo'] = $id;
						else {
							if (is_numeric($cbarras) and is_array($oDet->ixCodigoBarras($cbarras)) ) {
								$tmp = array_shift($oDet->ixCodigoBarras($cbarras));
								debug("Ref de cbarras: $tmp ");
								$aL['id_articulo'] = $oDet->getAttribute('id_articulo','DetallePedido',$tmp);
							}
						}
						if (empty($aL['id_articulo'])) {
							debug("Referencia desconocida!! ");
							continue;
						}
						if (is_array($aL['fecha_caducidad'])) 
							$aL['fecha_caducidad'] = 
								$aL['fecha_caducidad']['ano'].'-'.$aL['fecha_caducidad']['mes'].'-'.$aL['fecha_caducidad']['dia'];
						if ($GLOBALS['DEBUG']=='ON') {
							debug("Metiendo en las aLoc: ");
							print_r($aL);
						}
						array_push($aLoc,$aL);
					}
			if (is_array($aLoc) and sizeof($aLoc)) {
				$oAlb->debug(array("oAlbaran->completeWithSKU"=>$aLoc),'script->completeWithSKU');
				$aJSon['albaran'] = $oAlb->getAttribute('referencia');
				$oAlb->completeWithSKU($aLoc);
				$oAlm->__buildNotesIndex();
				$idx = NULL;
				$ndet = $oDet->countItems();
				$nnew = 0;
				$nedit = 0;
				$ndel = 0;
				for ($idx = $oDet->firstItem(); isset($idx); $idx = $oDet->nextItem()) {
					if ($oDet->checkFlag($oAlb->ST_NEW,$idx)) $nnew++;
					elseif ($oDet->checkFlag($oAlb->ST_DEL,$idx)) $ndel++;
					elseif ($oDet->checkFlag($oAlb->ST_EDIT,$idx)) $nedit++;
				}
				$aJSon['ndet_new'] = $nnew;
				$aJSon['ndet_edi'] = $nedit;
				$aJSon['ndet_del'] = $ndel;
			}
			$Sesion->set_var('__tpv_resultados','1','INMED');
			$oAlb->Dump();
	}
	header("X-JSON: ".toJSON($aJSon));
}


function nodb_notespack_article_faults(&$Sesion) {
	static $aLocs;

	$oAlm = $Sesion->get_var('oAlmacen');
	if (!is_a($oAlm,'Wherehouse')) {
		$Sesion->lcMessage('LCS_NOID',array('class' => 'Wherehouse'),IM_FATALERROR);
		return NULL;
	}

	if (is_array($aLocs) and !sizeof($aLocs)) { return NULL; }
	if (!is_array($aLocs)) {
		$aLocs = $Sesion->get_var('__pack_faltas_articulos');
		if (!is_array($aLocs) or !sizeof($aLocs)) return NULL;
	}
	reset($aLocs);
	$aTmp = each($aLocs);
	$aL = $aTmp['value'];
	$id_art = $aTmp['key'];
	if (is_array($aL) and sizeof($aL)) {
		foreach ($aL as $aRef) {
			foreach ($aRef as $key => $val) {
				if (!strcasecmp($key,'Detalle.cantidad_pendiente')) {
					$aCnt[$id_art] += $val;
					$aR['Producto.cantidad_pendiente'] = $val;
				}
				if (!strcasecmp(substr($key,0,strlen('Producto.')),'Producto.')) {
					$aR[$key] = $val;
				}
			}
			break;
		}
	}
	if (is_array($aR) and sizeof($aR)) {
		$Sesion->set_var('__notespack_locations_var','__pack_faults');
		$Sesion->set_var('__pack_faults',$aL);

		$aLocs[$id_art] = NULL;
		unset($aLocs[$id_art]);
		reset($aLocs);
		$Sesion->set_var('__pack_faltas_articulos',$aLocs);

		$id_alm = $oAlm->getId();
		//FixMe: Permitir revisar las compras!!
		$idx_alb = @array_shift($oAlm->getNoteList());
		if (is_numeric($idx_alb)) {
				$oAlb = &$oAlm->getDeliveryNote($idx_alb);
				$bVenta = $oAlb->isSale();
		} else $bVenta = true;
		if ($GLOBALS['DEBUG']=='ON') {
			debug("Buscando localizaciones para (idx_alb:$idx_alb): id_alm:".$id_alm);
			print_r($aCnt);
			if ($bVenta) debug("ALBARAN DE VENTA!!! ");
			else debug("ALBARAN DE COMPRA !! ");
		}

		$aStP = array('stock_negativo'=>true);
		$nl = $Sesion->get_var('__notespack_articlefaults_wherehouseparam_limit');
		if (is_numeric($nl)) $aStP['nocnt_loclimit'] = (int)$nl;
		$nadd = $Sesion->get_var('__notespack_articlefaults_addempty');
		if (is_numeric($nadd)) { $bAdd = true; }

		if ($bVenta) $aNewLocs = $oAlm->getLocationsForCheckOut($aCnt,NULL,NULL,NULL,true,$aStP);
		else $aNewLocs = $oAlm->getLocationsForCheckIn($aCnt,NULL,NULL,NULL,true,$aStP);
		$aTmp = $aNewLocs[$id_alm][$id_art]['localizaciones'];
		if ($bAdd) {
			if (!is_array($aTmp)) $aTmp = array();
			$aTmpRec = array('id_almacen_logico'=>0,'planta'=>0,'pasillo'=>0,'columna'=>0,'fila'=>0,'fecha_caducidad'=>'0000-00-00');
			$aTmpRec['cantidad_pendiente'] = 1;
			$aTmpRec['stock'] = 2;
			$aTmpRec['id_articulo'] = $id_art;
			array_push($aTmp,$aTmpRec);
		}
		if (is_array($aTmp) and sizeof($aTmp)) {
			foreach ($aTmp as $idx => $aT) {
				$aTmp[$idx]['cantidad_pendiente'] = $aNewLocs[$id_alm][$id_art]['total_solicitado'];
				$aFmt['fecha'] = $aT['fecha_caducidad'];
				$aTmpF = split("-",$aFmt['fecha']);
				if (is_array($aTmpF) and sizeof($aTmpF)>1) {
					$aTmp[$idx]['fmt_fecha_caducidad_ano'] = $aTmpF[0];
					$aTmp[$idx]['fmt_fecha_caducidad_mes'] = $aTmpF[1];
					$aTmp[$idx]['fmt_fecha_caducidad_dia'] = $aTmpF[2];
					$aTmp[$idx]['fmt_fecha_caducidad'] = $aFmt['fecha'];
				}
			}
			$Sesion->set_var('__pack_otherlocations',$aTmp,'SUBSECCION');
		} else {
			$Sesion->unset_var('__pack_otherlocations');
		}
		$aLocs = array();
	}
	if ($GLOBALS['DEBUG']=='ON') {
		debug("Retorno de faults: ");
		print_r($aR);
	}
	return $aR;
}

function nodb_notespack_locations (&$Sesion,$block_name) {
	static $aBlocks;
	static $aLocs;
	static $done;

	$bReset = $Sesion->get_var('__notespack_locations_reset');
	if ( (!is_array($aLocs) or $bReset)) {
		$var = $Sesion->get_var('__notespack_locations_var');
		if (!empty($var)) $aLocs = $Sesion->get_var($var);
		else $aLocs = $Sesion->get_var('__pack_locations');

		$Sesion->set_var('__notespack_locations_reset',0);
		$done = true;
		if (!is_array($aLocs) or !sizeof($aLocs)) return array();
	}
	if (!sizeof($aLocs)) return NULL;
	$aR = array_shift($aLocs);

	return $aR;
}


?>
