<?php

function pre_rutas(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$clientes_seleccionados=$Sesion->fetchVar('clientes_seleccionados','POST');
	$cli=$Sesion->fetchVar('cli','POST');
	$borrar_clientes=$Sesion->fetchVar('borrar_clientes','POST');
	$bo_rutas=$Sesion->fetchVar('bo_rutas','POST');
	$bo_rutas_values=$Sesion->fetchVar('bo_rutas_values','POST');
	$id_ruta=$Sesion->fetchVar('id_ruta','GET');
	$generar_desde=$Sesion->fetchVar('generar_desde','POST');
	$generar_hasta=$Sesion->fetchVar('generar_hasta','POST');

	if (empty($estado)) $estado = 0;

	$usuario = identifica_usuarios($Sesion);
	$db_conf = $Sesion->get_db('conf');
	$grp_mask = $Sesion->get_var("empresario_mask");
	if (empty($grp_mask) AND strcasecmp($usuario['desktop_name'],'Empresario')) {
		$rstmp = $db_conf->query("SELECT mask FROM Desktops WHERE nombre like '%Empresario%'");
		if ($db_conf->num_rows($rstmp)) {
			$aTmp = $db_conf->fetch_row($tmprs);
			$grp_mask = $aTmp[0];
		} else $grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
		$db_conf->libera($tmprs);
	} elseif (empty($grp_mask)) {
		$grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
	}

	$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
	$oDb = $Sesion->get_db('data');
	$id_ruta_sess = $Sesion->get_var('id_ruta');
	if (is_numeric($id_ruta)) {
		$Sesion->set_var('id_ruta',$id_ruta,"NOEXPIRE");
	} elseif (is_numeric($id_ruta_sess)) {
		$id_ruta = $id_ruta_sess;
	}

	switch ($accion_ejecutar) {
		case 'Guardar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (!(int)$registro['id_ruta']) $oDb->tb_replace("Rutas",$registro);
				else $oDb->tb_update("Rutas",$registro);
			}
			break;

		case 'Borrar' : //borrado
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(!$oDb->tb_delete('Rutas',array('id_ruta' => $registro['id_ruta']))){
			  		$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Rutas'),IM_FATALERROR);
					return;
				}
			}
			break;

		case 'Seleccion_clientes' :
			if ($Sesion->verifyVar('clientes_seleccionados',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('clientes_seleccionados',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($clientes_seleccionados))
					foreach ($clientes_seleccionados as $id)
						$oDb->tb_replace('Rutas_clientes',array('id_cliente' => $id, 'id_ruta' => $id_ruta));
			}
			break;

		case 'Borrar_clientes' :
			if (is_array($borrar_clientes))
				foreach ($borrar_clientes as $id => $bool)
					$oDb->tb_delete('Rutas_clientes',array('id_cliente' => $id, 'id_ruta' => $id_ruta));
			break;

		case 'Guardar_clientes': 
			if ($Sesion->verifyVar('cli ',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cli ',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($cli))
					foreach($cli as $id_cli => $aTmp) 
						$oDb->tb_update('Rutas_clientes',array('id_ruta' => $id_ruta,'id_cliente' => $id_cli,
									'id_medio_cto' => $aTmp['id_medio_cto'], 'orden' => $aTmp['orden']));
			}
			break;

		case 'Borrar_rutas' : //borrado
			if (is_array($bo_rutas))
				foreach($bo_rutas as $idr => $bool) {
					if(!$oDb->tb_delete('Rutas',array('id_ruta' => $idr))){
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Rutas'),IM_FATALERROR);
						return;
					}
					$oDb->tb_update('Recorridos',array('id_ruta' => 0),array('id_ruta' => $idr));
				}

			break;

		case 'Generar': 
			if (is_array($bo_rutas)) {
				$desde = wol_db::formatear_fecha($generar_desde,FALSE);
				if ($desde == 'NULL') $desde = NULL;
				$hasta = wol_db::formatear_fecha($generar_hasta,FALSE);
				if ($hasta == 'NULL') $hasta = NULL;
				$str_where = NULL;
				foreach($bo_rutas as $idr => $bool) 
					if ($bool) {
						$str_where .= ( (!empty($str_where)) ? ' OR ' : ' ').'id_ruta = '.$idr; 
					}

				// Obteniendo la ultima_fecha de recorrido
				$cons = "SELECT MAX(Recorridos.fecha) as 'ultima_fecha',Recorridos.id_ruta as 'id_ruta' ".
					"FROM Recorridos WHERE Recorridos.fecha < NOW() AND (".$str_where." ) GROUP BY id_ruta ";
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					while ($aTmp = $oDb->fetch_assoc($tmprs)) {
						if (!empty($aTmp['id_ruta'])) 
							$bo_rutas_values[$aTmp['id_ruta']]['ultima_fecha'] = $aTmp['ultima_fecha'];
						// debug("ultima: Metiendo en ".$aTmp['id_ruta']." - ".$aTmp['ultima_fecha']);
					}
				}
				$oDb->libera($tmprs);

				// Obteniendo la fecha de recorrido _mas_ lejana a futuro, la ultima a realizar
				$cons = "SELECT MAX(Recorridos.fecha) as 'proxima_fecha',Recorridos.id_ruta as 'id_ruta' ".
					"FROM Recorridos WHERE Recorridos.fecha >= NOW() AND (".$str_where." ) GROUP BY id_ruta ";
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					while ($aTmp = $oDb->fetch_assoc($tmprs)) {
						if (!empty($aTmp['id_ruta'])) 
							$bo_rutas_values[$aTmp['id_ruta']]['proxima_fecha'] = $aTmp['proxima_fecha'];
						// debug("Metiendo en ".$aTmp['id_ruta']." - ".$aTmp['proxima_fecha']);
					}
				}
				$oDb->libera($tmprs);

				foreach($bo_rutas as $idr => $bool) {
					if ($bool) {
						$d_frecuencia = $bo_rutas_values[$idr]['d_frecuencia'];
						$s_frecuencia = $d_frecuencia  * 24 * 3600;
						// debug("<HR>".$bo_rutas_values[$idr]['d_frecuencia']);
						if (empty($bo_rutas_values[$idr]['d_frecuencia'])) continue;
						$t_desde = $f_desde = $t_hasta = $f_hasta = NULL;
						// Buscando fecha de inicio
						if (!$desde) {
							// debug("No hay desde, Buscando ...");
							if (!empty($bo_rutas_values[$idr]['proxima_fecha'])) {
								$t_desde = strtotime($bo_rutas_values[$idr]['proxima_fecha']);
								$t_desde = strtotime("+$d_frecuencia day",$t_desde);
								// debug("Hay mas todavia... buscando via SQL (".$f_desde.")");
							} elseif (!empty($bo_rutas_values[$idr]['ultima_fecha'])) {
								// debug("Ahora es: ".$bo_rutas_values[$idr]['ultima_fecha']);
								$t_desde = strtotime($bo_rutas_values[$idr]['ultima_fecha']);
								$t_desde = strtotime("+$d_frecuencia day",$t_desde);
							} else {
								$t_desde = time(NULL);
								// debug("ponemos la de hoy: ".$f_desde);
							}
							$f_desde = strftime('%Y-%m-%d',$t_desde);
						} else {
							// $t_desde = strtotime($desde) - $s_frecuencia;
							$t_desde = strtotime($desde) ;
							$f_desde = strftime('%Y-%m-%d',$t_desde);
							// debug('Tu masdixo'.$desde.':-o casi-'.$f_desde);
						}
						if ($t_desde == -1) {
							// debug("No se pudo generar recorrido $idr");
							continue;
						}

						// Buscando fecha de fin
						if (!$hasta) {
							// debug("No hay _hasta_, Buscando ...");
							if (!empty($bo_rutas_values[$idr]['proxima_fecha']) OR empty($bo_rutas_values[$idr]['ultima_fecha'])) {
								// debug("Hay mas todavia(o no)... 1 Mes");
								//TODO: Permitir configurar para cuanto tiempo se generan las rutas (predefinido) -ahora 1vez, antes 1mes-
								$t_hasta = strtotime('+1 month',$t_desde);
								//$t_hasta += $s_frecuencia;
								$f_hasta = strftime("%Y-%m-%d",$t_hasta);
							} elseif (!empty($bo_rutas_values[$idr]['ultima_fecha'])) {
								$f_hasta = date('Y-m-d');
								// debug("Ahora es _hoy_: ".$f_hasta);
							} else {
								$f_hasta = date('Y-m-d');
								// debug("ponemos la de hoy: ".$f_hasta);
							}
							if (empty($t_hasta)) $t_hasta = strtotime($f_hasta);
						} else {
							$f_hasta = $hasta;
							$t_hasta = strtotime($f_hasta);
						}
						if ($t_hasta == -1) {
							// debug("No se pudo generar recorrido $idr");
							continue;
						}

						$num_recorridos = floor(($t_hasta - $t_desde)/($s_frecuencia));
						// debug( (($t_hasta - $t_desde) / 60)." Mins = ".
						//		( ($t_hasta-$t_desde) / (60 * 60))." Hrs = ".( ($t_hasta-$t_desde) / (60 * 60 * 24))." Dias ");
						// debug("Generando recorrido($num_recorridos) de $idr desde $f_desde($t_desde) hasta $f_hasta($t_hasta) = ".($t_hasta - $t_desde));
						$ultimo_time = $t_desde;
						for ($i=0; $i <= $num_recorridos; $i++) {
							$fecha_recorrido = strftime('%Y-%m-%d',$ultimo_time);
							$str_extra_vals = $str_extra_flds = $aTmp = NULL;
							if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
							if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments(array('fecha'=>$fecha_recorrido),'Recorridos',false);
							if (is_array($aTmp) and sizeof($aTmp))
								foreach (array_keys($aTmp) as $tmpfld) {
									if (empty($tmpfld)) continue;
									$str_extra_flds .= ','.$tmpfld;
									$str_extra_vals .= ',"'.$aTmp[$tmpfld].'"';
								}
							// debug("El $i .. desde el ".strftime('%Y-%m-%d',$ultimo_time)." (cada $d_frecuencia Dias = $s_frecuencia secs ) es ".$fecha_recorrido);
							$cons = "INSERT INTO Recorridos (id_ruta,id_agente,fecha".$str_extra_flds.") ".
								"SELECT id_ruta,id_agente,'".$fecha_recorrido."' ".$str_extra_vals." FROM Rutas WHERE id_ruta = $idr";
							$oDb->query($cons);
							// debug($cons);

							$id_recorrido = $oDb->last_insert_id();
							if (!$oDb->affected_rows()) {
								$oDb->tb_delete('Recorridos',array('id_recorrido' => $id_recorrido));
							} else {
								$cons = "INSERT INTO Citas (id_recorrido,id_cliente,id_medio_cto) ".
									"SELECT $id_recorrido,id_cliente,id_medio_cto FROM Rutas_clientes ".
									"WHERE id_ruta = $idr ORDER BY orden asc ";
								$oDb->query($cons);
							}
							// debug($cons);
							$ultimo_time = strtotime("+$d_frecuencia day",$ultimo_time);
						}
					}
				}
			}
			break;
			// print_r($cli);
	}//fin del switch
}

function pre_recorridos(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$clientes_seleccionados=$Sesion->fetchVar('clientes_seleccionados','POST');
	$cli=$Sesion->fetchVar('cli','POST');
	$borrar_clientes=$Sesion->fetchVar('borrar_clientes','POST');
	$id_recorrido=$Sesion->fetchVar('id_recorrido','GET POST');
	$gastos=$Sesion->fetchVar('gastos','POST');
	$recorridos_gastos=$Sesion->fetchVar('recorridos_gastos','POST');
	if (empty($estado)) $estado = 0;

	$usuario = identifica_usuarios($Sesion);
	$db_conf = $Sesion->get_db('conf');

	$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
	$oDb = $Sesion->get_db('data');
	$id_recorrido_sess = $Sesion->get_var('id_recorrido');
	if (is_numeric($id_recorrido)) {
		$Sesion->set_var('id_recorrido',$id_recorrido,"NOEXPIRE");
	} elseif (is_numeric($id_recorrido_sess)) {
		$id_recorrido = $id_recorrido_sess;
	}
		/** **
	} else {
		$Sesion->lcMessage('LCS_NOID',array('entidad'=>'Recorridos'),IM_FATALERROR);
		return;
	}
	/** **/

	switch ($accion_ejecutar) {
		case 'Guardar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (empty($registro['h_inicio'])) $registro['h_inicio'] = 'null';
				if (empty($registro['h_fin'])) $registro['h_fin'] = 'null';
				if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
				if (is_a($oPer,'Periodo')) $registro = $oPer->getAssignments($registro,'Recorridos');
				if (!(int)$registro['id_recorrido']) $oDb->tb_replace("Recorridos",$registro);
				else $oDb->tb_update("Recorridos",$registro);
			}
			if ($Sesion->verifyVar('gastos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('gastos',IKRN_VAR_CRC_AUTHED)) {
				// debug("Guarda los gastos!");
				if (is_array($gastos)) 
					foreach($gastos as $idg => $aTmp) {
						$aTmp['id_gasto'] = $idg;
						$oDb->tb_update('Recorridos_gastos',$aTmp);
					}
			}
			if ($Sesion->verifyVar('recorridos_gastos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('recorridos_gastos',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($recorridos_gastos) AND sizeof($recorridos_gastos) ) 
					foreach ($recorridos_gastos as $idx => $aRec) {
						if (!strcasecmp($idx,'new') AND is_numeric($aRec['importe']) AND is_numeric($aRec['id_gasto']) ) {
							$aRec['id_recorrido'] = $id_recorrido;
							$oDb->tb_replace('Recorridos_gastos',$aRec);
						}
					}
			}
			break;

		case 'Borrar' : //borrado
			if ($Sesion->verifyVar('registro_borrar',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro_borrar',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($registro_borrar))
					foreach ($registro_borrar as $id_recorrido)
						if(!$oDb->tb_delete('Recorridos',array('id_recorrido'=>$id_recorrido))){
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Recorridos'));
							return;
						} else {
							if(!$oDb->tb_delete('Recorridos_gastos',
										array('id_recorrido'=>$id_recorrido))){
								$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Recorridos_gastos'));
								return;
							}
							if(!$oDb->tb_delete('Citas',
										array('id_recorrido'=>$id_recorrido))){
								$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Citas'));
								return;
							}
						}
			}
			break;

		case 'Iniciar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$oDb->tb_update('Recorridos',array('id_recorrido' => $id_recorrido,'h_inicio' => date('H:i:s')));
			}
			break;

		case 'Finalizar': /* modificacion de Empresas como empresario */
			if (is_numeric($id_recorrido)) {
				if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
					if (empty($registro['h_fin'])) $registro['h_fin'] = date('H:i:s');
					$registro['id_recorrido'] = $id_recorrido;
					$oDb->tb_update('Recorridos',$registro);
				}
				if ($Sesion->verifyVar('gastos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('gastos',IKRN_VAR_CRC_AUTHED)) {
					// debug("Guarda los gastos!");
					if (is_array($gastos)) 
						foreach($gastos as $idg => $aTmp) {
							$aTmp['id_gasto'] = $idg;
							$oDb->tb_update('Recorridos_gastos',$aTmp);
						}
				}
				if ($Sesion->verifyVar('recorridos_gastos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('recorridos_gastos',IKRN_VAR_CRC_AUTHED)) {
					if (is_array($recorridos_gastos) AND sizeof($recorridos_gastos) ) 
						foreach ($recorridos_gastos as $idx => $aRec) {
							if (!strcasecmp($idx,'new') AND is_numeric($aRec['importe']) AND is_numeric($aRec['id_gasto']) ) {
								$aRec['id_recorrido'] = $id_recorrido;
								$oDb->tb_replace('Recorridos_gastos',$aRec);
							}
						}
				}
			}
			break;

		case 'Seleccion_clientes' :
			if ($Sesion->verifyVar('clientes_seleccionados',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('clientes_seleccionados',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($clientes_seleccionados))
					foreach ($clientes_seleccionados as $id)
						$oDb->tb_replace('Citas',array('id_cliente' => $id, 'id_recorrido' => $id_recorrido));
			}
			break;

		case 'Borrar_clientes' :
			if (is_array($borrar_clientes))
				foreach ($borrar_clientes as $id => $bool)
					$oDb->tb_delete('Citas',array('id_cliente' => $id, 'id_recorrido' => $id_recorrido));
			break;

		case 'Cambio_fechas': 
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($registro))
					foreach($registro as $idr => $aTmp) {
						$aRec = array('id_recorrido' => $idr,'fecha' => $aTmp['fecha']);
						if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
						if (is_a($oPer,'Periodo')) $aRec = $oPer->getAssignments($aRec,'Recorridos');
						$oDb->tb_update('Recorridos',$aRec);
					}
			}
			break;
	}//fin del switch
}

function pre_cita(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_cita=$Sesion->fetchVar('id_cita','GET');
	$efectos=$Sesion->fetchVar('efectos','POST');
	$selecciones=$Sesion->fetchVar('selecciones','POST'); //Form Array

	$usuario = identifica_usuarios($Sesion);
	$db_conf = $Sesion->get_db('conf');
	$grp_mask = $Sesion->get_var("empresario_mask");
	if (empty($grp_mask) AND strcasecmp($usuario['desktop_name'],'Empresario')) {
		$rstmp = $db_conf->query("SELECT mask FROM Desktops WHERE nombre like '%Empresario%'");
		if ($db_conf->num_rows($rstmp)) {
			$aTmp = $db_conf->fetch_row($tmprs);
			$grp_mask = $aTmp[0];
		} else $grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
		$db_conf->libera($tmprs);
	} elseif (empty($grp_mask)) {
		$grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
	}

	$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
	$oDb = $Sesion->get_db('data');
	$id_cita_sess = $Sesion->get_var('id_cita');
	if (is_numeric($id_cita)) {
		$Sesion->set_var('id_cita',$id_cita,"NOEXPIRE");
	} elseif (is_numeric($id_cita_sess)) {
		$id_cita = $id_cita_sess;
	}

	switch ($accion_ejecutar) {
		case 'Guardar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro['visitado'] = (int)$registro['visitado'];
				if (!(int)$registro['id_cita']) $oDb->tb_replace("Citas",$registro);
				else $oDb->tb_update("Citas",$registro);
			}
			break;

		case 'Iniciar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($id_cita)) {
					$oDb->tb_update("Citas",array('id_cita' => $id_cita, 'h_inicio' => date('H:i:s')) );
				}
			}
			break;

		case 'Finalizar': /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($id_cita)) {
					$registro['visitado'] = (int)$registro['visitado'];
					$registro['h_fin_sys'] = date('H:i:s');
					$registro['id_cita'] = $id_cita;
					$oDb->tb_update("Citas",$registro);
				}
			}
			break;
			
		case 'AbonarEfectos':
			if ($Sesion->verifyVar('efectos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('efectos',IKRN_VAR_CRC_AUTHED)) {
				$aCfg = $Sesion->get_var('_aAppConf');
				foreach ($efectos as $id_efecto => $aEff) {
					if (is_numeric($aEff['importe']) AND is_numeric($id_efecto)) {
						$oEfecto = new Draft ($Sesion->App_Name);
						$oEfecto->dbFill($id_efecto);
						$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio']);
						$oEff = &$oEfecto->getPartialDrafts();
						if (is_object($oEff)) {
							$aTmp['id_efecto'] = $id_efecto;
							$aTmp['monto_satisfecho'] = $aEff['importe'];
							$aTmp['medio_pago'] = $aEff['medio_pago'];
							$aTmp['notas'] = $aEff['notas'];
							$aTmp['id_cita'] = $id_cita;
							$oEff->insert($aTmp);
						}
						$oEfecto->Dump();
						$oEff = NULL;
						$oEfecto = NULL;
					}
				}
			}
			break;

		case 'seleccionar_incidencias':
			if (is_array($selecciones) OR is_numeric($selecciones)) {
				if (is_numeric($selecciones)) $aSel = array($selecciones);
				else $aSel = $selecciones;

				if (is_numeric($id_cita)) {
					$oDb = $Sesion->get_db('data');
					foreach ($aSel as $id) 
						$oDb->tb_replace('Citas_Incidencias_CRM',array('id_cita' => $id_cita, 'id_incidencia' => $id));
				}
			}
			break;

		case 'ConfirmarDocumentoValorado':
			if (is_numeric($id_cita)) {
				$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
				$docvar = $Sesion->get_var('__document_iface_varname');
				if (empty($docvar)) $docvar = 'oPedido_en_curso';

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
					$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
					return ;
				}
				$idped = $oPedido->getId();
				$last_id = $Sesion->get_var('last_id_pedido');
				if (is_numeric($last_id) AND $last_id == $idped) {
					return NULL;
				}
				$Sesion->set_var('last_id_pedido',$idped,'SECCION');

				if (method_exists($oPedido,'set_reciever_address') AND !$oPedido->set_reciever_address($registro['id_direccion']))
					if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

				$oPedido->set_agent($agente,TRUE);
				$oPedido->set_payment_method($forma_pago);
				$oPedido->set_currency($divisa);
				$oPedido->set_name($registro['nombre']);
				$oPedido->set_comments($registro['observaciones']);

				for ($idx=$oPedido->first_detail(); isset($idx); $idx=$oPedido->next_detail()) {
					if (!isset($articulos_confirmados[$idx])) 
						$oPedido->del_detail($idx);
					else {
						if (!empty($observaciones[$idx]))
							$oPedido->set_detail_comment($idx,$observaciones[$idx]);

						if (is_array($articulos_precios[$idx]) AND sizeof($articulos_precios[$idx]) AND 
								(!empty($articulos_precios[$idx]) OR is_numeric($articulos_precios[$idx])) ) {
							$precio = $oPedido->get_price($idx);
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
				/** **/
				$oPedido->dbDump();
				$id_pedido = $oPedido->getId();
				if (is_numeric($id_pedido)) $oDb->tb_update('Citas',array('id_pedido' => $id_pedido, 'id_cita' => $id_cita));

				$Sesion->unset_var($docvar);
				$Sesion->unset_var('__document_iface_varname');

				// Fixme: Comprobar estas variables!
				$Sesion->unset_var("id_direccion_cliente");
				$Sesion->unset_var("id_direccion");
			}

			break;

	} //fin del switch
}

?>
