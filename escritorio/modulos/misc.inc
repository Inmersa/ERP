<?php
/** identificacion del usuario y grupo
 * metemos en la sesion 4 valores
 * usuario_id_usr
 * usuario_tabla
 * usuario_campo
 * usuario_id
 */

function pre_modulosasociados(&$Sesion) {
	$aNullPlt = $Sesion->getCfgPlt('null');
	$nullname =  $aNullPlt['nombre'];
	$aR = $Sesion->activeModuleCall('isRecordEntity',array('entity' => 'Articulos','action' => 'NEW'));
	$aModList = array();
	foreach ($aR as $mod => $bool) 
		if ($bool) {
			$idmod = $Sesion->_aModulos[$mod]['id_modulo'];
			$mask = $Sesion->_aModulos[$mod]['mascara'];
			$aTmp = array('nombre' => $mod, 'id_modulo' => $idmod, 'mascara' => $mask);
			array_push($aModList,$aTmp);
		}
	if (!is_array($aModList) or !sizeof($aModList)) return $nullname;
	$Sesion->set_var('__module_list',$aModList,'SUBSECCION');

}

function nodb_modulosasociados(&$Sesion) {
	static $aModList;
	if (!is_array($aModList)) {
		$aModList = $Sesion->get_var('__module_list');
	}
	$aRV = array_shift($aModList);
	return $aRV;
}

function lcredec($a,&$b,$c = NULL,$d = NULL) {
	return lcdec($a,$b,$c,$d);
}

function identifica_usuarios(&$Sesion)  {
	$RetVal = $Sesion->get_var("_AuthInfo");
	$oUsr = $Sesion->get_authed_user();
	if (!isset($RetVal) || !is_array($RetVal) || !sizeof($RetVal) || $oUsr->get_id()!=$RetVal['id_usr']) {
		$Desk = $oUsr->get_desktop();
		$aInfo = $oUsr->get_user();
		if (empty($Desk['extras']['nombre_usuario'])) {
			$RetVal['user_name'] = $aInfo['name'];
		} else $RetVal['user_name'] = $Desk['extras']['nombre_usuario'];

		$RetVal['id_usr'] = $aInfo['id_usr'];
		$RetVal['desktop_subsec'] = $Desk['subsec_name'];
		$RetVal['desktop_id_subsec'] = $Desk['trigger_subsec'];
		$RetVal['desktop_name'] = $Desk['nombre'];
		$RetVal['desktop_mask'] = $Desk['mask'];
		$RetVal['id'] = $Desk['extras']['id_empresa'];
		$RetVal['tabla'] = $Desk['table'];
		$RetVal['campo'] = $Desk['field'];
		$RetVal['valor'] = $Desk['value'];
		if (is_array($Desk['extras']))
			foreach ($Desk['extras'] as $campo => $valor) {
				if (strcmp($campo,'id_empresa')) {
					$RetVal[$campo] = $valor;
				}
			}

		identifica_usuarios_crm($Sesion,$RetVal);
		$Sesion->set_var("_AuthInfo",$RetVal,"NOEXPIRE");
		$Sesion->set_var("id_empresa",$RetVal['id'],"NOEXPIRE");
		$Sesion->set_var('idusr_desktop_'.$RetVal['desktop_name'],$RetVal['valor'],"NOEXPIRE");
		$Sesion->unset_var('_aSubsecGrants'); //Limpiando contendido para allowed_link()

		// Obteniendo configuracion de la aplicacion:
		$oDb = $Sesion->get_db('conf');
		$cons = 'SELECT nombre,valor FROM _main WHERE nombre like "cfg_app_%"';
		$cfgrs = $oDb->query($cons);
		if ($oDb->num_rows($cfgrs)) 
			while ($aTmp = $oDb->fetch_assoc($cfgrs)) 
				$aCfg[substr($aTmp['nombre'],8)] = ( (!is_numeric($aTmp['valor']) AND empty($aTmp['valor'])) ? '' : $aTmp['valor'] );

		$Sesion->set_var('_aAppConf',$aCfg,'NOEXPIRE');
	}
	// print_r($RetVal);

	return $RetVal;
}

function identifica_usuarios_crm(&$Sesion,$aUsr) {
	enlazar_crm(&$Sesion);
	if (!is_numeric($aUsr['crm_id_usuario']) AND !is_numeric($aUsr['crm_id_empleado']) AND strcasecmp($aUsr['desktop_name'],'Empresas') ) {
		$mask = (int)$aUsr['desktop_mask'];

		allowed_link($Sesion,array('nueva_incidencia_crm'));
		allowed_link($Sesion,array('asociar_incidencia_crm'));
		$aSecc = $Sesion->get_var('_aSubsecGrants');
		$aSecc['nueva_incidencia_crm'] &= ~$mask;
		settype($aSecc['nueva_incidencia_crm'],'integer');
		$aSecc['asociar_incidencia_crm'] &= ~$mask;
		settype($aSecc['asociar_incidencia_crm'],'integer');
		$Sesion->set_var('_aSubsecGrants',$aSecc,'NOEXPIRE');

		allowed_action($Sesion,array('Pedidos_Incidencias_CRM','del'));
		allowed_action($Sesion,array('Facturas_Incidencias_CRM','del'));
		allowed_action($Sesion,array('Albaranes_Incidencias_CRM','del'));
		$aAcc = $Sesion->get_var('_aActionGrants');
		if (is_array($aAcc['Pedidos_Incidencias_CRM']))
			foreach ($aAcc['Pedidos_Incidencias_CRM'] as $act => $acc) {
				$aAcc['Pedidos_Incidencias_CRM'][$act] &= ~$mask;
				settype($aAcc['Pedidos_Incidencias_CRM'][$act],'integer');
			}
		if (is_array($aAcc['Facturas_Incidencias_CRM']))
			foreach ($aAcc['Facturas_Incidencias_CRM'] as $act => $acc) {
				$aAcc['Facturas_Incidencias_CRM'][$act] &= ~$mask;
				settype($aAcc['Facturas_Incidencias_CRM'][$act],'integer');
			}
		if (is_array($aAcc['Albaranes_Incidencias_CRM']))
			foreach ($aAcc['Albaranes_Incidencias_CRM'] as $act => $acc) {
				$aAcc['Albaranes_Incidencias_CRM'][$act] &= ~$mask;
				settype($aAcc['Albaranes_Incidencias_CRM'][$act],'integer');
			}

		$Sesion->set_var('_aActionGrants',$aAcc,'NOEXPIRE');
	}
}

function pre_principal(&$sesion){
	global $id_lang;
	static $lang;
	static $sufijo;
	static $nsuf;

	$oU = &$sesion->getVarByRef('Medidas');
	if (!is_a($oU,'UnidadesMedida')) {
		$sesion->setVarByRef('Medidas',new UnidadesMedida(),'NOEXPIRE');
	}
	
	$sesion->set_var('ss_nm',$sesion->get_subsecc_name(),'INMED');
	$sesion->set_var('old_ss_nm',$sesion->get_old_subsecc_name(),'INMED');
	$sesion->set_var('ss_qs',$sesion->get_subsecc_querystring(),'INMED');
	$usr = $sesion->Access->oUsr->get_desktop();
	if (!is_array($usr)) return NULL;
	$sufijo = trim($usr['pii_prefix']);
	if (empty($sufijo)) return NULL;
	$nsuf = strlen($sufijo);
	$aPlts = $sesion->get_plt_array_all();
	foreach ($aPlts as $idx => $aPl) {
		$cacho = substr($aPl[0],0,$nsuf);
		if (!strcmp($cacho,$sufijo)) {
			$pto_info = substr($aPl[0],$nsuf);
			if ($sesion->add_plt($pto_info,$aPl[1],$aPl[2],$aPl[3],$aPl[4])==-1) {
				$sesion->change_plt_precode($pto_info,$aPl[1],$aPl[2],$aPl[3],$aPl[4]);
				debug("Plantilla cambiada by da face");
				print_r($aPl);
			} // else debug("punto informacion anyadio de pm");
		}
	}
}

function store_id(&$Sesion,$aParam) {
	$reset = $Sesion->get_var('_store_id_reset');
	if ((int)$reset) {
		$Sesion->unset_var('_store_id_reset');
		$Sesion->unset_var('_aStored_IDs');
	} else {
		$aStored = $Sesion->get_var('_aStored_IDs');
	}
	if (!is_array($aStored)) $aStored = array();

	if (!is_array($aParam) AND !empty($aParam)) $aParam = array($aParam);
	if (sizeof($aParam) AND is_array($aParam))
		foreach ($aParam as $id) {
			if (!in_array($id,$aStored)) $aStored[] = $id;
		}
	$Sesion->set_var('_aStored_IDs',$aStored,'SECCION');
}

function store_id_check(&$Sesion,$aParam) {
	$aStored = $Sesion->get_var('_aStored_IDs');
	if (!is_array($aStored) OR !sizeof($aStored)) return 0;
	if (!is_array($aParam) AND !empty($aParam)) $aParam = array($aParam);
	elseif (empty($aParam)) return 0;

	$estan = TRUE;
	if (sizeof($aParam) AND is_array($aParam))
		foreach ($aParam as $id) 
			if (!in_array($id,$aStored)) {
				$estan = FALSE;
				break;
			}
	if ($estan) return 1;
	else return 0;
}

function update_stock($Sesion,$dbname = 'data',$aLoc,$bUpdateEstimado = true, $bTryReLocate = true) {
	if (!is_object($Sesion)) return NULL;
	if (empty($dbname)) $dbname = 'data';
	$oDb = $Sesion->get_db($dbname);
	$aLocalizacion = $aLoc;
	if (!$bUpdateEstimado) $bUpdateEstimado = FALSE;

	// debug("update_stock() - first Try sql_update_stock() a pelo.. ");
	$affected_rows = sql_update_stock($oDb,$aLocalizacion);
	if (!$affected_rows) {
		// debug(".... meeeck!! ");

		$aLocIn['id_almacen_logico'] = $aLocalizacion['id_almacen_logico'];
		$aLocIn['planta'] = $aLocalizacion['planta'];
		$aLocIn['pasillo'] = $aLocalizacion['pasillo'];
		$aLocIn['fila'] = $aLocalizacion['fila'];
		$aLocIn['columna'] = $aLocalizacion['columna'];
		$aProdIn['lote'] = $aLocalizacion['lote'];
		$aProdIn['fecha_caducidad'] = wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false);
		if (!strcasecmp($aProdIn['fecha_caducidad'],'NULL')) $aProdIn['fecha_caducidad'] = '0000-00-00';

		$affected = 0;
		// debug("No existe esa localizacion? .. Buscamos por lote y/o la fecha ($bTryR");
		/** 
		 * Lo primero, buscamos esta misma referencia de producto, con fecha y lote, a ver si existe en alguna otra localizacion.
		 **/
		$cons = 'SELECT planta,pasillo,fila,columna,lote,fecha_caducidad,id_almacen_logico,cantidad '.
					'FROM Localizacion_articulos '.
					'WHERE id_articulo = '.$aLoc['id_articulo'].' AND (  ((lote = "'.$aLoc['lote'].'" AND lote != "") OR '.
					'(fecha_caducidad = '.wol_db::formatear_fecha($aLoc['fecha_caducidad']).' AND fecha_caducidad != 0)) '.
					( (!$bTryReLocate) 
					  ? ' AND ( 1 '.
						( (!empty($aLocalizacion['id_almacen_logico'])) ? ' AND id_almacen_logico = '.$aLocalizacion['id_almacen_logico'] : '').
						( (!empty($aLocalizacion['planta'])) ? ' AND planta = '.$aLocalizacion['planta'] : '').
						( (!empty($aLocalizacion['pasillo'])) ? ' AND pasillo = '.$aLocalizacion['pasillo'] : '').
						( (!empty($aLocalizacion['fila'])) ? ' AND fila = '.$aLocalizacion['fila'] : '').
						' ) '
					  : ''
					 ).' ) '.
					' ORDER  BY fecha_caducidad asc ';
		// debug($cons);
		$locrs = $oDb->query($cons);
		$n_rows = $oDb->num_rows($locrs);
		$aFinal = NULL;
		if ($n_rows > 1) {
			// debug("VARIAS ocurrencia encontrada. ");
			/**
			 * Hemos encontrado mas de un lote/fecha ... Comprobando almacen_logico
			 **/
			$i = 0;
			while ($aTmp = $oDb->fetch_assoc($locrs)) {
				if (!$i++) $aFirst = $aTmp;

				if ( vector_incluido($aTmp,$aLocIn) ) {
					// Si coincide la localizacion y estos no estan vacios (no son el cajon desastre). lo metemos aqui.
					if (!is_array($aFinal)) $aFinal = $aTmp;
					else {
						if (!strcasecmp($aLocalizacion['lote'],$aTmp['lote']) AND 
								!strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),wol_db::formatear_fecha($aTmp['fecha_caducidad'],false)) ) {
							// debug("pero si coinciden!! ");
							// Si Coincide fecha de caducidad y lote, nos da igual que ya hayamos encontrado una localizacion que cuadre, estos son los valores
							$aFinal = $aTmp;
							break;
						} elseif (!strcasecmp($aLocalizacion['lote'],$aTmp['lote']) OR 
								!strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),wol_db::formatear_fecha($aTmp['fecha_caducidad'],false)) ) {
							// Si coincide la fecha de caducidad o el lote, nos vale la localizacion, probablemente mejor que antes (nunca peor)
							$aFinal = $aTmp;
						}
					}
				} elseif ( ($aTmp['id_almacen_logico'] == $aLocalizacion['id_almacen_logico']) AND !is_array($aFinal)  ) {
					$aFinal = $aTmp;
				}
			}
			if ( (!is_array($aFinal) OR !sizeof($aFinal)) AND ( is_array($aFirst) AND sizeof($aFirst)) ) {
				// Si no hemos encontrado una localizacion en el almacen-logico actual, lo metemos en la primera localizcion
				$aFinal = $aFirst;
			} 
		} elseif ((int)$n_rows) {
			// debug("_una_ encontrada .. ");
			$aFinal = $oDb->fetch_assoc($locrs);
			$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
			// debug("update_stock(): _solo_ hemos encontrado una localizacion: ");
			// print_r($aFinal);
		}

		if (is_array($aFinal) AND sizeof($aFinal) AND (int)$n_rows) {
			$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
			$aFinal['id_empresa'] = $aLocalizacion['id_empresa'];

			// debug("Va a ser aquina eh : ");
			// print_r($aFinal);

			if ( ( ( !empty($aLocalizacion['lote']) AND $aFinal['lote'] != $aLocalizacion['lote'] )
					OR 
					( strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL')  
					  AND strcasecmp(wol_db::formatear_fecha($aFinal['fecha_caducidad']),wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'])) ) 
					) 
				) {
			
				/** 
				 * Dado que la localizacion actual tiene otro lote y/o fecha de caducidad
				 * En el mismo hueco, creamos una nueva entrada con este lote/fecha.
				 **/

				if ( vector_incluido($aFinal,$aLocIn) AND $aFinal['cantidad'] == 0) {
					// Si el hueco/localizacion actual, esta vacia, 
					// debug("Nuevo hueco ... ");
					//FixMe: _NUNCA_ actualizar cantidades por tb_update, hacer una SQL
					$oDb->tb_update('Localizacion_articulos',$aLocalizacion,$aFinal);
					$aRetVal = $aFinal;

					$aFinal['fcad'] = $aFinal['fecha_caducidad'];
					$Sesion->lcMessage('MISC_STOCK_LOC_MOVED',$aFinal);
				} else {
					if (!empty($aLocalizacion['lote'])) $aFinal['lote'] = $aLocalizacion['lote'];
					if (strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL')) $aFinal['fecha_caducidad'] = $aLocalizacion['fecha_caducidad'];
					$aFinal['cantidad'] = $aLocalizacion['cantidad'];

					// debug("Reemplazamos una localizacion en varias .... ");
					// print_r($aTmp);
					$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
					$oDb->tb_replace('Localizacion_articulos',$aFinal);
					$aRetVal = $aFinal;
					$affected = 1;

					$aFinal['fcad'] = $aFinal['fecha_caducidad'];
					$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aFinal);
				}
			} else {
				// debug("Actualizamos el stock.. ");
				$aFinal['cantidad'] = $aLocalizacion['cantidad'];
				$affected = sql_update_stock($oDb,$aFinal);
				$aRetVal = $aFinal;

				$aFinal['fcad'] = $aFinal['fecha_caducidad'];
				$Sesion->lcMessage('MISC_STOCK_LOC_MOVED',$aFinal);
			}

		} else {
			// debug("No hemos encontrado el lote/fecha ... no esta? Comprobando ");
			$cons = 'SELECT planta,pasillo,fila,columna,lote,fecha_caducidad,id_almacen_logico FROM Localizacion_articulos '.
						'WHERE id_articulo = '.$aLoc['id_articulo'].
						' ORDER by fecha_caducidad, lote asc ';
			$artrs = $oDb->query($cons);
			if (!$oDb->num_rows($artrs)) {
				/**
				 * No hemos encontrado la referencia de producto en _ninguna_ localizacion. Le damos esta.
				 **/
				if (empty($aLocalizacion['id_almacen_logico'])) {
					$cons = 'SELECT Almacenes_logicos.id_almacen,Almacenes_logicos.id_almacen_logico '.
							  'FROM Empresas , Almacenes , Almacenes_logicos '.
							  'WHERE Empresas.id_empresa= $usuario[id] and '.
							  'Almacenes.id_empresa = Empresas.id_empresa and '.
							  'Almacenes.id_almacen = Almacenes_logicos.id_almacen '.
							  ( (is_numeric($aLocalizacion['id_almacen'])) ? 'Almacenes.id_almacen = '.$aLocalizacion['id_almacen'] : '').
							  ' ORDER BY Almacenes.id_almacen asc, Almacenes_logicos.id_almacen_logico asc'.
							  ' limit 1';
					$idtmp = $oDb->query ($cons);
					if ($oDb->num_rows($idtmp)) {
						$aTmpLoc = $oDb->fetch_array ($idtmp);
						$aLocalizacion['id_almacen_logico'] = $aTmpLoc[0];
					}
				}
				// if (!is_numeric($aLocalizacion['planta'])) $aLocalizacion['planta'] = 0;
				// if (!is_numeric($aLocalizacion['pasillo'])) $aLocalizacion['pasillo'] = 0;
				// if (!is_numeric($aLocalizacion['fila'])) $aLocalizacion['fila'] = 0;
				// if (!is_numeric($aLocalizacion['columna'])) $aLocalizacion['columna'] = 0;

				// debug("No hemos encontrado la referencia, la creamos");
				if (!empty($aLocalizacion['id_almacen_logico'])) {
					$aLocalizacion['fecha_alta'] = date('Y-m-d H:i:s');
					$oDb->tb_replace('Localizacion_articulos',$aLocalizacion);
					$aRetVal = $aLocalizacion;
					$affected = 1;

					$aTmp = $aLocalizacion;
					$aTmp['fcad'] = $aTmp['fecha_caducidad'];
					$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
					// $localizacion = 'Pta: '.$aLocalizacion['planta'].' P: '.$aLocalizacion['pasillo'].' F: '.$aLocalizacion['fila'].' C: '.$aLocalizacion['columna'];
					// $producto = 'Lte/F.Cad: '.$aLocalizacion['lote'].' / '.colocar_fecha($aLocalizacion['fecha_caducidad']);
					// debug("Producto $producto colocado en una nueva localizacion : $localizacion");
				} else $affected = 0;
			} else {
				// debug("Pues no va a estar no... ");
				$i = 0;

				$bUpdate = false;

				while ($aTmp = $oDb->fetch_assoc($artrs)) {
					if (!$i++) $aFirst = $aTmp;

					/** **
					if ( ( !strcmp(wol_db::formatear_fecha($aTmp['fecha_caducidad']),wol_db::formatear_fecha($aLocalizacion['fecha_caducidad']))  
									AND strcasecmp(wol_db::formatear_fecha($aLocalizacion['fecha_caducidad'],false),'NULL'))  
							OR ($aTmp['lote']==$aLocalizacion['lote'] AND !empty($aLocalizacion['lote'])) ) 
					/** **/
					if (vector_incluido($aTmp,$aProdIn) AND vector_incluido($aTmp,$aLocIn) )
					{
						// Si coincide la fecha o el lote y estos no estan vacios (no son el cajon desastre). lo metemos aqui.
						// debug("Coincide lote y localizacion!!");
						$aFinal = $aTmp;
						$bUpdate = true;
						break;
					} elseif (vector_incluido($aTmp,$aProdIn)) {
						// debug("Coincide la fecha/lote solo .. ");
						// print_r($aProdIn);
						$aFinal = $aTmp;
					} elseif (vector_incluido($aTmp,$aLocIn)) {
						// debug("Coincide la localicacion solo .. ");
						// print_r($aLocIn);
						if ($aFinal['cantidad'] == 0) $aFinal = $aTmp;
					} elseif ($aTmp['id_almacen_logico'] == $aLocIn['id_almacen_logico']) {
						// Si no coinciden fechas ni lote , pero si el almacen, consideramos esta una buena opcion (a espera de seguir evaluando).
						// debug("Coincide tan solo la zona de almacen .. ");
						$aFinal = $aTmp;
					}
				}
				if ( (!is_array($aFinal) OR !sizeof($aFinal)) AND ( is_array($aFirst) AND sizeof($aFirst)) ) {
					// Si no hemos encontrado una localizacion en el almacen-logico actual, lo metemos en la primera localizcion
					$aFinal = $aFirst;
				} 
				if (is_array($aFinal) AND sizeof($aFinal)) {
					$aFinal['id_articulo'] = $aLocalizacion['id_articulo'];
					$aFinal['cantidad'] = $aLocalizacion['cantidad'];
					$aFinal['id_empresa'] = $aLocalizacion['id_empresa'];

					if ($bTryReLocate) {
						$aFinal['lote'] = $aLocalizacion['lote'];
						$aFinal['fecha_caducidad'] = $aLocalizacion['fecha_caducidad'];
					} else {
						$aFinal['lote'] = $aProdIn['lote'];
						$aFinal['fecha_caducidad'] = $aProdIn['fecha_caducidad'];

						$aFinal['id_almacen_logico'] = $aLocIn['id_almacen_logico'];
						$aFinal['planta'] = $aLocIn['planta'];
						$aFinal['pasillo'] = $aLocIn['pasillo'];
						$aFinal['fila'] = $aLocIn['fila'];
						$aFinal['columna'] = $aLocIn['columna'];
					}

					$aTmp = $aRetVal = $aFinal;

					if (!$bUpdate) {
						//FixMe: No usar tb_replace, es preferible la opcion del else
						$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
						$oDb->tb_replace('Localizacion_articulos',$aFinal);
						$aTmp['fcad'] = $aTmp['fecha_caducidad'];
						$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
					} else {
						if (!sql_update_stock($oDb,$aFinal)) {
							$aFinal['fecha_alta'] = date('Y-m-d H:i:s');
							$oDb->tb_replace('Localizacion_articulos',$aFinal);
							$aTmp['fcad'] = $aTmp['fecha_caducidad'];
							$Sesion->lcMessage('MISC_STOCK_LOC_NEW',$aTmp);
						}
					}
					$affected = 1;

				} else {
					// Error: Nos hemos hecho la picha un lio con las localizaciones
					debug("Error: Me he hecho la picha un lio ... ");
					$affected = 0;
				}
			}
			$oDb->libera($artrs);
		}
		$oDb->libera($locrs);
	} else {
		$affected = 1;
		$aRetVal = $aLoc;
	}

	if ($affected AND $bUpdateEstimado) {
		// debug("Actualizamos el stock estimado.");
		$cons = "UPDATE Empresas_articulos SET stock_ficticio = stock_ficticio + ".$aLocalizacion['cantidad'].
			" WHERE id_empresa = ".$aLocalizacion['id_empresa'].' AND id_articulo = '.$aLocalizacion['id_articulo'];
		// debug($cons);
		$oDb->query($cons);
	}
	return $aRetVal;
}

function sql_update_stock($oDb,$aLoc) {
	if (!is_object($oDb)) return 0;
	if (empty($aLoc['id_articulo']) OR !is_numeric($aLoc['id_articulo'])) return 0;
	if (empty($aLoc['id_almacen_logico']) OR !is_numeric($aLoc['id_almacen_logico'])) return 0;

	$fecha_fmt = wol_db::formatear_fecha($aLoc['fecha_caducidad'],false);
	if (!strcasecmp($fecha_fmt,'NULL')) $fecha_fmt = '"0000-00-00"';
	else $fecha_fmt = '"'.$fecha_fmt.'"';

	$cons = "UPDATE Localizacion_articulos SET cantidad = cantidad + ".$aLoc['cantidad']." WHERE ".
		"id_articulo = ".$aLoc['id_articulo']." AND ".
		"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
		( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
		( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
		( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
		( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." AND " : '').
		"lote = '".$aLoc['lote']."' AND ".
		"fecha_caducidad = ".$fecha_fmt;
	$idrs = $oDb->query($cons);
	$affected_rows = $oDb->affected_rows();

	if ($affected_rows == 1) {
		// Si hemos actualizado cantidades... borramos las que nos hayan quedado a 0
		$cntcons = "SELECT COUNT(*) FROM Localizacion_articulos WHERE ".
					"id_articulo = ".$aLoc['id_articulo']." AND ".
					"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
					"fecha_caducidad != '0000-00-00' AND ".
					( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
					( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
					( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
					( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." " : '');
		$cntrs = $oDb->query($cntcons);
		$aCnt = $oDb->fetch_row($cntrs);
		// debug("sql_update_stock() - Update ok.. ".$aCnt[0]." Localizaciones puras ");
		if ($aCnt[0]>1) {
			$cons = "DELETE FROM Localizacion_articulos WHERE ".
				"id_articulo = ".$aLoc['id_articulo']." AND ".
				"id_almacen_logico = ".$aLoc['id_almacen_logico']." AND ".
				( (is_numeric($aLoc['planta'])) ? "planta = ".$aLoc['planta']." AND " : '').
				( (is_numeric($aLoc['pasillo'])) ? "pasillo = ".$aLoc['pasillo']." AND " : '').
				( (is_numeric($aLoc['fila'])) ? "fila = ".$aLoc['fila']." AND " : '').
				( (is_numeric($aLoc['columna'])) ? "columna = ".$aLoc['columna']." AND " : '').
				"lote = '".$aLoc['lote']."' AND ".
				"fecha_caducidad = ".wol_db::formatear_fecha($aLoc['fecha_caducidad']).
				" AND cantidad = 0 ";
			$oDb->query($cons);
		}
	}

	return $affected_rows;
}

function albaran_stock_move(&$Sesion,$bVenta = true,$aDet,$aNewLoc,&$aFullDetails) {
	// debug("albaran_stock_move() ... ");
	// print_r($aNewLoc);
	if (empty($aNewLoc['cantidad'])) $aNewLoc['cantidad'] = $aDet['cantidad'];
	$oDb = $Sesion->get_db('data');

	// Devolvemos la mercaderia, que se vaya a desplazar, a donde estaba (sin actualizar el estimado)
	// Esto lo hacemos corrigiendo el stock del detalle, a la cantidad que se queda en dicha localizacion
	// El true, es para que si se queda vacia la localizacion, la borre del albaran. (recordar, que estamos desplazando)

	// debug("stock_move:: albaran_stock_fix de ".($aDet['cantidad']-$aNewLoc['cantidad']));
	albaran_stock_fix($Sesion,$bVenta,$aDet,($aDet['cantidad']-$aNewLoc['cantidad']),true);

	// Obtenemos, de la localizacion sugerida, la cantidad pedida 
	$aLoc = $aNewLoc;
	if ($bVenta) $aLoc['cantidad'] *= -1;
	$aLoc['id_articulo'] = $aDet['id_articulo'];

	/** **
	// Quitamos de aLoc los datos de localizacion que coincidan con la anterior, dado que de coincidir, es que
	//   nos da igual esa u otra localizacion, la tenemos que buscar, si -por contra- no coincide, es que queremos esa localizacion.
	if (empty($aLoc['id_almacen_logico']) OR $aLoc['id_almacen_logico'] == $aDet['id_almacen_logico']) $aLoc['id_almacen_logico'] = NULL;
	/** **/

	// Si no cambia la hubicacion, pediremos a update_stock que 'lo ponga con sus colegas'
	if ( (empty($aLoc['planta']) OR $aLoc['planta'] == $aDet['planta']) AND
			(empty($aLoc['pasillo']) OR $aLoc['pasillo'] == $aDet['pasillo']) AND
			(empty($aLoc['id_almacen_logico']) OR $aLoc['id_almacen_logico'] == $aDet['id_almacen_logico']) AND
			(empty($aLoc['fila']) OR $aLoc['fila'] == $aDet['fila']) AND 
			(empty($aLoc['columna']) OR $aLoc['columna'] == $aDet['columna']) ) $bTryRelocate = true;
	else $bTryRelocate = false;

	// debug("albaran_stock_move():: Sugerimos? ($bTryRelocate) : update_stock a la nueva localizcion: ");
	// print_r($aLoc);
	$aLocFinal = update_stock($Sesion,'data',$aLoc,false,$bTryRelocate);
	// debug("Sera en: $bTryRelocate ");
	// print_r($aLocFinal);

	if (!is_array($aLocFinal) OR !sizeof($aLocFinal)) {
		debug("La ostia!! que putada!! no hemos encontrado nueva localizacion ");
		return false;
	} else {

		$fmt_caducidad = wol_db::formatear_fecha($aLocFinal['fecha_caducidad']);
		if (!strcasecmp($fmt_caducidad,"null")) {
			$fmt_caducidad = '0000-00-00';
		}
		// Si resulta, que la localizacion de donde salio, ya existe en el elbaran, sumamos la cantidad a esta localizacion ya existente en el albaran
		$cons = 'UPDATE Detalles_albaran SET cantidad = cantidad + \''.$aNewLoc['cantidad'].'\' '.
					'WHERE id_detalle = '.$aDet['id_detalle'].
					' AND id_albaran='.$aDet['id_albaran'].
					' AND id_almacen_logico='.$aLocFinal['id_almacen_logico'].
					' AND planta='.$aLocFinal['planta'].
					' AND pasillo='.$aLocFinal['pasillo'].
					' AND columna='.$aLocFinal['columna'].
					' AND fila='.$aLocFinal['fila'].
					' AND lote=\''.$aLocFinal['lote'].'\' '.
					' AND fecha_caducidad='.$fmt_caducidad;
		// debug('albaran_stock_move():: Actualizado el Detalle con '.$aNewLoc['cantidad'].' : ');
		// print_r($aLocFinal);
		$dars = $oDb->query($cons);
		if (!$oDb->affected_rows($dars)) {
			// debug("Ninguna afectada!! ");
			$aLocFinal['cantidad'] = $aNewLoc['cantidad'];
			$aLocFinal['id_detalle'] = $aDet['id_detalle'];
			$aLocFinal['id_albaran'] = $aDet['id_albaran'];
			$oDb->tb_replace('Detalles_albaran',$aLocFinal);
		} else {

			// Actualizar la cantidad que tenga la linea de detalle que estemos recibiendo por post
			$aKs = array_keys($aFullDetails);
			for ($k=array_shift($aKs); is_numeric($k); $k=array_shift($aKs)) {
				$aV=$aFullDetails[$k];
				if ($aV['id_detalle'] == $aDet['id_detalle'] AND $aV['id_almacen_logico']==$aLocFinal['id_almacen_logico']
						AND $aV['planta']==$aLocFinal['planta'] AND $aV['pasillo']==$aLocFinal['pasillo'] AND $aV['columna']==$aLocFinal['columna']
						AND $aV['fila']==$aLocFinal['fila'] AND $aV['lote']==$aLocFinal['lote'] 
						AND wol_db::formatear_fecha($aV['fecha_caducidad'],false)==wol_db::formatear_fecha($aLocFinal['fecha_caducidad'],false) ) {
					// debug("Tambien en _este_ ($k) albaran.. ".$aFullDetails[$k]['cantidad']);
					$aFullDetails[$k]['cantidad'] += $aNewLoc['cantidad'];
					$aFullDetails[$k]['_relocated'] = true;
				}
			}
		}
	}
}

function albaran_stock_fix(&$Sesion,$bVenta = true,$aDet,$nueva_cantidad,$bDelete = false) {
	if (!is_numeric($nueva_cantidad)) return false;
	$oDb = $Sesion->get_db('data');
	if (empty($nueva_cantidad) AND $bDelete) {
		$aTmp['id_detalle'] = $aDet['id_detalle'];
		$aTmp['id_albaran'] = $aDet['id_albaran'];
		$aTmp['id_almacen_logico'] = $aDet['id_almacen_logico'];
		$aTmp['lote'] = $aDet['lote'];
		$aTmp['fecha_caducidad'] = $aDet['fecha_caducidad'];
		$aTmp['planta'] = $aDet['planta'];
		$aTmp['fila'] = $aDet['fila'];
		$aTmp['pasillo'] = $aDet['pasillo'];
		$aTmp['columna'] = $aDet['columna'];
		// debug("albaran_stock_fix(): tb_delete 'Detalles_albaran'");
		// print_r($aTmp);
		$oDb->tb_delete('Detalles_albaran',$aTmp);
	} else {
		$cons = 'UPDATE Detalles_albaran SET cantidad = cantidad + ('.$nueva_cantidad.' - '.$aDet['cantidad'].') '.
				'WHERE id_detalle = '.$aDet['id_detalle'].
				( (is_numeric($aDet['id_albaran'])) ? ' AND id_albaran='.$aDet['id_albaran'] : '').
				( (is_numeric($aDet['id_almacen_logico'])) ? ' AND id_almacen_logico='.$aDet['id_almacen_logico'] : '').
				( (is_numeric($aDet['planta'])) ? ' AND planta='.$aDet['planta'] : '').
				( (is_numeric($aDet['pasillo'])) ? ' AND pasillo='.$aDet['pasillo'] : '').
				( (is_numeric($aDet['columna'])) ? ' AND columna='.$aDet['columna'] : '').
				( (is_numeric($aDet['fila'])) ? ' AND fila='.$aDet['fila'] : '').
				( (!empty($aDet['lote'])) ? ' AND lote=\''.$aDet['lote'].'\' ' : '').
				( (!empty($aDet['fecha_caducidad'])) ? ' AND fecha_caducidad='.wol_db::formatear_fecha($aDet['fecha_caducidad']) : '');
		// debug('albaran_stock_fix(): '.$cons);
		$tmprs = $oDb->query($cons);
		if (!($tmprs)) return false;
	}

	$aDetStk = $aDet;
	$aDetStk['cantidad'] = $aDet['cantidad'] - $nueva_cantidad;
	if (!$bVenta) $aDetStk['cantidad'] *= -1;
	// debug('albaran_stock_fix(): llamando a update_stock :');
	// print_r($aDetStk);
	$aLoc = update_stock($Sesion,'data',$aDetStk,false,false);
	if (!is_array($aLoc) OR !sizeof($aLoc)) {
		debug("Ha petao la devolucion de stock, lo suyo es volver a dejar el albaran como estaba");
		return false;
	}

	return true;
}

function nombre_seccion(&$Sesion,$aParams){
	$secc_name = array_shift($aParams);
	$secc = $Sesion->get_section_name();
	if (!strcasecmp($secc_name,"NULL")) {
		if (empty($secc) OR !strcasecmp($secc,"backoffice")) $retval = 1;
		else $retval = 0;
	} else {
		if (!strcasecmp($secc_name,$secc)) $retval = 1;
		else $retval = 0;
	}
	return $retval;
}

function querystring_activa(&$Sesion,$aParam) {
	$qs = array_shift($aParam);
	$claseok = array_shift($aParam);
	$clasenook = array_shift($aParam);
	if (empty($qs)) return NULL;
	$lastrs = $Sesion->get_var('_qsactiva_last');
	$chg = (bool)$Sesion->fetchVar('_chgsm','GET');
	$querystring = $Sesion->get_subsecc_querystring();

	$retval = ((stristr($querystring,$qs)!==false) ? true : false);
	// debug("primera comprarativa entre $querystring y $qs ::: ".$retval);
	if ($retval) {
		$Sesion->set_var('_qsactiva_last',$qs,'NOEXPIRE');
		return 'class="'.$claseok.'"';
	} else {
		// debug("$lastrs con $qs es con $chg recarga ".$Sesion->bRecarga);
		if (!empty($lastrs) AND !strcasecmp($lastrs,$qs) AND !$chg AND $Sesion->bRecarga) {
			// debug("true de bellon");
			return 'class="'.$claseok.'"';
		} 
		return ( (!empty($clasenook)) ? 'class="'.$clasenook.'"' : null );
	}

}

function pre_cabecera(&$Sesion) {
	$desk_name = $Sesion->get_var('usr_desktop_name');
	if (empty($desk_name)) {
		$aUsr = identifica_usuarios($Sesion);
		$Sesion->set_var('usr_desktop_name',$aUsr['desktop_name'],'NOEXPIRE');
		if (strcmp($aUsr['desktop_name'],'Operador') AND strcmp($aUsr['desktop_name'],'Coordinador'))
			$Sesion->set_var('usr_ss_ficha',$aUsr['desktop_subsec'],'NOEXPIRE');
	}
}

function id_entidad(&$Sesion,$idname,$actval = NULL,$tipo = 'Any') {
	static $aVars = array (
			'id_coordinador' => array(
				'varname' => 'id_coordinador',
				'desktop' => 'Coordinador'
				),
			'id_operador' => array(
				'varname' => 'id_operador',
				'desktop' => 'Operador'
				),
			'id_agente' => array(
				'varname' => 'id_agente',
				'desktop' => 'Agentes'
				),
			'id_proveedor' => array(
				'varname' => 'id_proveedor',
				'desktop' => 'Proveedores'
				),
			'id_cliente' => array(
				'varname' => 'id_cliente',
				'desktop' => 'Clientes'
				),
			'id_almacen' => array(
				'varname' => 'id_almacen',
				'desktop' => 'Almacenes'
				)
			);
	if (!is_object($Sesion)) return NULL;

	$usuario = identifica_usuarios($Sesion);
	$idemp = $Sesion->get_var("id_empresa");
	if ($usuario['id'] != $idemp) $Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");

	if (!is_array($aVars[$idname])) return NULL;

	// debug("Tamo0s con $idname - ".$actval);
	if (!empty($aVars[$idname]['desktop']) AND !strcasecmp($aVars[$idname]['desktop'],$usuario['desktop_name'])) {
		$varval = $usuario['valor'];
		$Sesion->set_var($aVars[$idname]['varname'],$varval,'NOEXPIRE');
		$Sesion->set_var($aVars[$idname]['varname'].'_promocion',$varval,'NOEXPIRE');
		// debug($aVars[$idname]['varname'].'_promocion hasta las cejas con '.$varval);
	} elseif (!isset($actval)) {
		$varval = $Sesion->get_var($aVars[$idname]['varname']);
		$varval_old = $Sesion->get_var($aVars[$idname]['varname'].'_promocion');
		if (!is_numeric($varval)) $varval = $varval_old;
		if ($varval != $varval_old) $Sesion->set_var($aVars[$idname]['varname'].'_promocion',$varval);
		// debug("var: ".$aVars[$idname]['varname']."  varval = $varval");
	} else {
		$varval = $actval;
		$Sesion->set_var($aVars[$idname]['varname'],$varval,'NOEXPIRE');
		$Sesion->set_var($aVars[$idname]['varname'].'_promocion',$varval,'NOEXPIRE');
		// debug($aVars[$idname]['varname'].'_promocion hasta las cejas con '.$varval);
	}

	return $varval;
}

function document_emails(&$Sesion) {
	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';
	$oDoc = $Sesion->get_var($docvar);
	if (is_object($oDoc)) {
		$aRec = $oDoc->get_reciever_info();
		if (!empty($aRec['email'])) $retval .= ((!empty($retval)) ? ', ' : '').$aRec['email'];
		$aRec = $oDoc->get_issuer_info();
		if (!empty($aRec['email'])) $retval .= ((!empty($retval)) ? ', ' : '').$aRec['email'];
	} else {
		$id = $Sesion->fetchVar('id_albaran','GET');
		if (is_numeric($id)) {
			$cons = 'SELECT E.email,IF(P.id_direccion,IF(D.email,D.email,C.email),Pr.email) as "email_add" '.
						'FROM Empresas E, Albaranes A LEFT JOIN Pedidos P ON (A.id_pedido=P.id_pedido) '.
						'LEFT JOIN Proveedores Pr ON (Pr.id_proveedor=P.id_proveedor) '.
						'LEFT JOIN Direcciones_entrega D ON (P.id_direccion=D.id_direccion) LEFT JOIN Clientes C ON (D.id_cliente=C.id_cliente) '.
						'WHERE E.id_empresa=P.id_empresa AND A.id_albaran = '.$id;
			$oDb = $Sesion->get_db('data');
			$tmprs = $oDb->query($cons);
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_assoc($tmprs);
				$retval = '';
				if (!empty($aTmp['email'])) $retval .= ( (!empty($retval)) ? ', ' : '' ).$aTmp['email'];
				if (!empty($aTmp['email_add'])) $retval .= ( (!empty($retval)) ? ', ' : '' ).$aTmp['email_add'];
			}
		} else return NULL;
	}
	return $retval;
}

/** Functiones pre-kernel **/

function css_hacks(&$Sesion) {
	$browser = $_SERVER['HTTP_USER_AGENT'];
	if (strstr($browser,'MSIE')) {
		$retval = 'none.css';
	} elseif (strstr($browser,'Safari')) {
		$retval = 'none.css';
	} elseif (strstr($browser,'Mozilla')) {
		$retval = 'MozillaHacks.css';
	} else $retval = 'none.css';

	return $retval;
}

function class_searchsort(&$Sesion,$aParams) {
   if (!is_array($aParams) OR !sizeof($aParams)) return 'null';
	foreach ($aParams as $clave => $valor ) {
		if (is_numeric($clave)) $what = $valor;
		else $what = $clave;
		break;
	}

   $aOrder = $Sesion->get_var('_searchOrderRequest');
   if (!is_array($aOrder)) return 'null';
   if (!strcasecmp($aOrder['field'],$what)) {
		if (!strcasecmp($aOrder['type'],'asc')) $retval = 'ascendente';
		elseif (!strcasecmp($aOrder['type'],'desc')) $retval = 'descendente';
	} else $retval = 'null';
	return $retval;
}

function allowed_pii(&$Sesion,$aParam) {
	$retval = true;
	if (!is_array($aParam) OR !sizeof($aParam)) return false;
	$pii = array_shift($aParam);

	$aPii = $Sesion->get_plt_array($pii);
	if (!is_array($aPii) OR !sizeof($aPii)) return false;
	return true;

	return $retval;
}



function pre_menu_almacen (&$Sesion) {
	$id_almacen=$Sesion->fetchVar('id_almacen','GET');

	$id_almacen = id_entidad($Sesion,'id_almacen',$id_almacen);
	$id_empresa = $Sesion->get_var('id_empresa');
	if (is_numeric($id_almacen)) {
		$id_almacen_sess = $Sesion->get_var('id_almacen_promocion');
		if ($id_almacen != $id_almacen_sess) {
			$Sesion->set_var('id_almacen_promocion',$id_almacen);
			$Sesion->set_var('id_almacen',$id_almacen);
		}
	} elseif (is_numeric($id_empresa)) {
		$oDb = $Sesion->get_db('data');
		$cons = 'SELECT id_almacen FROM Almacenes WHERE id_empresa = '.$id_empresa.' ORDER BY id_almacen asc LIMIT 1';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			$aTmp = $oDb->fetch_row($tmprs);
			$id_almacen = $aTmp[0];
			$Sesion->set_var('id_almacen_promocion',$id_almacen);
			$Sesion->set_var('id_almacen',$id_almacen);
		}
	}
}

function poner_cabecera(&$Sesion,$aData){
	static $aBreaks;
	static $docvar;
	static $breakpoint = -1;
	$retval = false;

	if ( (!is_array($aBreaks) OR !sizeof($aBreaks)) AND $breakpoint == -1) {
		$aBreaks = $Sesion->get_var('aRupturasPagina');
		$docvar = $Sesion->get_var('__document_iface_varname');
		if (!is_array($aBreaks) OR !sizeof($aBreaks)) return false;
		$breakpoint = array_shift($aBreaks);
	}
	
	$oDoc = $Sesion->get_var($docvar);
	if (!is_object($oDoc)) {
		return false;
	} else {
		$idx = $oDoc->current_detail();
		if ($idx == $oDoc->last_detail(false)) {
			$breakpoint = -1;
			$retval = false;
		} else {
			// debug("$idx ..  $breakpoint ");
			if ($idx == $breakpoint) {
				if (sizeof($aBreaks)) $breakpoint = array_shift($aBreaks);
				// debug("Hemos roto en $idx ... y romperemos en $breakpoint ");
				$retval = true;
				// $npg = $Sesion->get_var('pagina_actual');
				// $Sesion->set_var('pagina_actual',++$npg,'INMED');
			}
		}
	}

	return $retval;
}

function poner_cabecera_albaran(&$Sesion,$aData){
	static $nSplit = 0;
	static $nSplitOrig = 0;

	static $nCarLinea = NULL;
	static $nLineasPrimera = NULL;
	static $nLineasPagina = NULL;
	static $nLineasTotales = NULL;

	if (!is_numeric($nCarLinea) OR !is_numeric($nLineasPrimera) OR !is_numeric($nLineasPagina) OR !is_numeric($nLineasTotales)) {
		$aCfg = $Sesion->get_var('_aAppConf');
		$nCarLinea = $aCfg['print_numcar_observaciones'];
		if (!is_numeric($nCarLinea)) $nCarLinea = 130;
		$nLineasPrimera = $aCfg['print_pgcabdoc_lineas'];
		if (!is_numeric($nLineasPrimera)) $nLineasPrimera = 49;
		$nLineasPagina = $aCfg['print_pgdoc_lineas'];
		if (!is_numeric($nLineasPagina)) $nLineasPagina = 76;
		$nLineasTotales = $aCfg['print_piedoc_lineas'];
		if (!is_numeric($nLineasTotales)) $nLineasTotales = 12;

		// Convertimos las lineas normales de los pedidos, a lineas con checkbox, las de pedido son un 24.48% mas grandes
		$nRatioDif = 24.48;
		$nLineasPrimera -= round($nLineasPrimera * ($nRatioDif/100),0);
		$nLineasPagina -= round($nLineasPagina * ($nRatioDif/100),0);
		$nLineasTotales -= round($nLineasTotales * ($nRatioDif/100),0);
	}

	static $n_det = 0;

	$retval = false;

	$reset = $Sesion->get_var('_reset_cabecera_albaran');
	if ( (int) $reset ) {
		$nSplit = 0;
		$n_det = 0;
		$Sesion->set_var('_reset_cabecera_albaran',0);
	}

	$n_det++;
	if (!$nSplit) {
		if (!sizeof($aRupturas)) {
			if ($nDetalles > $nLineasPrimera) $nSplit = $nLineasPrimera;
			else $nSplit = ($nLineasPrimera - $nLineasTotales);
			$nSplitOrig = $nSplit;
		} else {
			if ( ($nDetalles - $n_det) > $nLineasPagina) {
				$nSplitOrig = $nSplit = $nLineasPagina;
			} else {
				$nSplit = $nLineasPagina - $nLineasTotales;
			}
		}
	}

	$txt = $aData['observaciones'];
	if (!empty($txt)) {
		$ntmp = floor(strlen($txt)/$nCarLinea)+1;
		if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
		else $nSplit = 0;
	} else {
		$nSplit--;
	}

	$idx = $aData['num_detalle'];
	if ($nSplit OR $idx == $Sesion->get_var('total_detalles') ) {
		$retval = false;
	} else {
		$npg = $Sesion->get_var('pagina_actual');
		$Sesion->set_var('pagina_actual',round(++$npg,0),'INMED');
		$retval = true;
	}
	
	return $retval;
}

function page_std_invoice(&$Sesion) {
	$docvar = $Sesion->get_var('__document_iface_varname');
	$oPedido = $Sesion->get_var($docvar);

	if (is_object($oPedido)) {
		// Calcular el numero de paginas, y posiciones de ruptura.
		$aRupturas = array();
		$nSplit = 0;
		$nSplitOrig = 0;

		$aCfg = $Sesion->get_var('_aAppConf');
		$nCarLinea = $aCfg['print_numcar_observaciones'];
		if (!is_numeric($nCarLinea)) $nCarLinea = 130;
		$nLineasPrimera = $aCfg['print_pgcabdoc_lineas'];
		if (!is_numeric($nLineasPrimera)) $nLineasPrimera = 45;
		$nLineasPagina = $aCfg['print_pgdoc_lineas'];
		if (!is_numeric($nLineasPagina)) $nLineasPagina = 66;
		$nLineasTotales = $aCfg['print_piedoc_lineas'];
		if (!is_numeric($nLineasTotales)) $nLineasTotales = 12;
		$bObsEnLinea = (int)$aCfg['print_observaciones_enlinea'];
		$bProductIds = (int)$aCfg['print_invoice_productids'];
		if (method_exists($oPedido,'getInstallment') and $oPedido->getInstallment()) $bProductIds = false;

		$nDetalles = $oPedido->num_details();
		// debug("Tenemos que colocar $nDetalles a $nLineasPagina por pagina, salvo la primera que tiene $nLineasPrimera ");
		for($i = $oPedido->first_detail(),$n_det = 1,$n_obs = 0; isset($i); $i = $oPedido->next_detail(), $n_det++) {
			if (!$nSplit) {
				if (!sizeof($aRupturas)) {
					// Primera pagina del documento
					if ($nDetalles > $nLineasPrimera) $nSplit = $nLineasPrimera;
					else $nSplit = ($nLineasPrimera - $nLineasTotales);
					$nSplitOrig = $nSplit;
					// debug("Empezamos la pagina $nSplit lineas deseables ");
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
			if (is_array($aAlb) AND sizeof($aAlb) AND (!method_exists($oPedido,'getInstallment') or !$oPedido->getInstallment()) ) {
				// Las facturas de abono no llevan detalle de productos.
				$id_det = $oPedido->getDetailAttribute($oPedido->current_detail(),'id_detalle');
				$aAL = $oPedido->getDeliveryFromDbDet($id_det);
				$pidlen = 0;
				if (sizeof($aAL))
					foreach ($aAL as $ida) {
						if (!is_array($aServ)) $aServ=array();
						if (is_array($aAlb[$ida]['detalles'][$id_det]))
							foreach ($aAlb[$ida]['detalles'][$id_det] as $tmpidx => $aDet) {
								foreach ($aDet as $tmpdet) if (!empty($aDet['cantidad'])) $pidlen += strlen($tmpdet);
								// Numero de Caracteres de formato: 4 ' ' '[' ']' ' ' 
								$pidlen += 4;
							}
					}
			}

			// debug("Longitud del product id = $pidlen ; linea relativa $nSplit ");
			$txt = $oPedido->get_detail_comment($i);
			if (!empty($txt)) {
				// Si no van las observaciones en la misma linea que el nombre, restamos ya la linea del nombre.
				if (!$bObsEnLinea) $nSplit--;
				$ntmp = floor(strlen($txt)/$nCarLinea)+1;
				// debug(strlen($txt)." caracteres a $nCarLinea por linea son $ntmp lineas");
				if ($nSplit - $ntmp > 0) $nSplit -= $ntmp;
				else $nSplit = 0;
			} elseif ($bProductIds AND $pidlen) {
				$ntmp = floor($pidlen/$nCarLinea)+1;
				if ($nSplit - $ntmp > 0) {
					$nSplit--; // La que le corresponde por ser final de producto
					$nSplit -= $ntmp; // La que le corresponde por cada linea completa de prodids
				} else $nSplit = 0;
				// debug("Ahora debemos de descontar el futuro split $ntmp por id de producto -> $nSplit");
			} else {
				$nSplit--;
			}

			// No romperemos si es la primera pagina -sizeof()- y hemos recorrido menos lineas de las que compone una primera pagina
			if (!$nSplit AND ($nSplitOrig>=($nLineasPrimera-$nLineasTotales) OR sizeof($aRupturas)) ) array_push($aRupturas,$i);
		}

		// debug("Al final, split = $nSplit ");

		// debug("Romperemos en... ");
		// print_r($aRupturas);
		$Sesion->set_var('aRupturasPagina',$aRupturas,'SUBSECCION');
		$Sesion->set_var("paginas_totales",sizeof($aRupturas)+1);
		$Sesion->set_var("pagina_actual",1);
	}
}

function vector_incluido($aConjunto,$aParte) {
	if (!is_array($aParte) OR !sizeof($aParte)) return false;
	if (!is_array($aConjunto) OR !sizeof($aConjunto)) return false;
	foreach ($aParte as $clave => $valor) 
		if ($aConjunto[$clave] != $valor) 
			return false;
	return true;
}

function decimal_a_tiempo($dato) {
	// debug("decimal_a_tiempo($dato)");
	$minutos = floor($dato);
	$segundos = floor(($dato - $minutos)*60);

	$horas = floor($minutos / 60);
	if ($horas>0) $minutos -= ($horas * 60);

	$dias = floor($horas / 24);
	if ($dias>0) $horas -= ($dias * 24);

	$fmt = ( (!empty($dias)) ? $dias.'d ' : '').( (!empty($horas)) ? $horas.'h ' : '').( (!empty($minutos)) ? $minutos.'m ' : '').( (!empty($segundos)) ? $segundos.'s ' : '');
	return $fmt;
}

function tiempo_a_decimal($dato) {
	// debug("tiempo $dato a decimal ");
	$aTmp = array();
	if (preg_match_all('/[0-9]*d|[0-9]*h|[0-9]*m|[0-9]*s/',$dato,$aTmp)) {
		$aTime = array_shift($aTmp);
		$retval = 0;
		if (is_array($aTime) AND sizeof($aTime)) 
			foreach ($aTime as $tiempo) {
				if (strstr($tiempo,'d')) $retval += (24*60*preg_replace('/[^0-9]/','',$tiempo));
				if (strstr($tiempo,'h')) $retval += (60*preg_replace('/[^0-9]/','',$tiempo));
				if (strstr($tiempo,'m')) $retval += preg_replace('/[^0-9]/','',$tiempo);
				if (strstr($tiempo,'s')) $retval += (preg_replace('/[^0-9]/','',$tiempo)/60);
			}
	}
	if ($retval > 0) {
		settype($retval,'float');
		return $retval;
	} else return $dato;
}

function lcfecha($dato) {
	if (empty($dato)) return NULL;
	$ts = strtotime($dato);
	setlocale (LC_TIME,"spanish");
	return strftime('%a, %e %b',$ts);
}

function lchora($dato) {
	if (empty($dato)) return NULL;
	$aTmp = split(' ',$dato);
	return $aTmp[1];
}

function fmtCC($cc,$oS) {
	$rval = AccountEntry::filterAccount($cc);
	if ((int)$rval==0) return NULL;
	else return $rval;
}

function pre_grafico_barras(&$Sesion) {
	static $aColores = array( 'bc-inm', 'bc-rosaoscuro', 'bc-ocre', 'bc-rosa', 'bc-verdeoscuro', 'bc-amarillopastel', 'bc-lilapastel',
		'bc-grisfuerte', 'bc-marron', 'bc-azulpastel', 'bc-morado', 'bc-verdepastel', 'bc-violeta', 'bc-amarillo', 'bc-azulclaro',
		'bc-oro', 'bc-tinto', 'bc-violeta', 'bc-lila', 'bc-azul'
			);

	$aGraph = $Sesion->get_var('grafica');
	if (empty($aGraph['charts'])) {
		debug("Error: NO hay valores para las graficas ");
		return NULL;
	}
	$str_graph = $aGraph['charts'];
	$aGrI = split(' ',$str_graph);

	// Asignacion de colores por cliente, y leyenda:
	$aLey = $Sesion->get_var('leyenda');
	$aLeyenda = array();
	$i = 0;
	$max_leyname = 0;
	$max_items = sizeof($aColores);
	$max_items = (int)$aGraph['limit'];
	if (!$max_items) $max_items = 5;
	foreach ($aLey as $idx => $aVal) {
		if ($i >= $max_items) {
			// debug("No se pueden tener mas de $i colores ");
			break;
		}
		if (empty($aVal['nombre'])) continue;
		if (strlen($aVal['nombre']) > $max_leyname) $max_leyname = strlen($aVal['nombre']);
		$aLeyenda[$idx] = array('nombre' => $aVal['nombre'], 'color' => $aColores[$i++], 'link' => $aVal['link']);
	}
	$Sesion->set_var('leyenda',$aLeyenda,'INMED');

	// Dimensiones de los Graficos:
	$cfg_ancho = $Sesion->get_var('grfx_ancho_total');
	if (!is_numeric($cfg_ancho)) $ancho_total = 1000;
	else $ancho_total = $cfg_ancho;
	$ancho_ejey = 70;
	// Base: numero de items de leyenda por tamanyo de cada item mas el alto del titulo mas la distancia
	$altoleyenda = (sizeof($aLeyenda) * 22);
	// Alto minimo del grafico
	if ($altoleyenda < 185) $altoleyenda = 185;

	$altobase = ($altoleyenda) + 30;
	// Grafico: alto de la leyenda, menos el hueco que ocupa el primer item del ejeY, que sobresale por arriba de la capa del ejeY
	$altografico = ($altoleyenda - 22);
	$ancho_ley = (int)(5.7 * $max_leyname) + 2 + 20;
	// El 10 representa los 5px de margen izdo  y dcho que tiene cada grafica
	$ancho_gris = ( ($ancho_total - $ancho_ley - 5) -  (sizeof($aGrI) * ($ancho_ejey+10))  );
	$ancho_gri = (int) ( ($ancho_gris) / sizeof($aGrI));

	// $ancho_barra = 30;
	// 4 es el numero de pixeles horizontales de borde (2px por borde):
	$ancho_barra = (($ancho_gri-4)/sizeof($aLeyenda))-4;
	// debug("Tenemos(".sizeof($aLeyenda).") un maximo de $max_leyname caracteres en la leyenda de $ancho_ley donde entre todas se repartiran ".
				// "$ancho_gris = $ancho_gri es decir, una barra de $ancho_barra ");

	$Sesion->set_var('base_alto',$altobase,'INMED');
	$Sesion->set_var('graf_alto',$altografico,'INMED');
	$Sesion->set_var('graf_ancho',$ancho_gri,'INMED');


	// Graficas
	$aGraficas = array();
	foreach ($aGrI as $nombre_grafica) {
		$aGrf = NULL;
		$aG = $Sesion->get_var($nombre_grafica);
		$max_val = NULL;
		$min_val = NULL;
		foreach ($aG as $id => $aV) {
			// debug("id: $id val: ".$aV['data']." act: $max_val ");
			if (!is_numeric($max_val)) $max_val = $aV['data'];
			if (!is_numeric($min_val)) $min_val = $aV['data'];
			if (!is_numeric($id)) continue; 
			elseif (!is_array($aLeyenda[$id])) continue;
			elseif ($aV['data']>$max_val) $max_val = $aV['data'];
			elseif ($aV['data']<$min_val) $min_val = $aV['data'];
		}
		if (abs($max_val) > 0) {
			if ($max_val >0) $max_val *= 1.10;
			else $max_val *= 0.90;
		} elseif (empty($max_val)) {
			continue;
		}
		/** **/
		if (is_numeric($max_val)) {
			if ($max_val<0) $max_val = 0;
			else $max_val = ceil($max_val);
		}
		if (is_numeric($min_val)) {
			if ($min_val>0) $min_val = 0;
			else $min_val = floor($min_val);
		}
		/** **/
		$aG['valor_maximo'] = $max_val;
		$aG['valor_minimo'] = $min_val;

		$i = 0;
		$dist = round( ( ($ancho_gri ) / sizeof($aLeyenda) ),1);
		// debug("Dist sobre $ancho_gri con ".sizeof($aLeyenda)." barras de $ancho_barra = $dist ");
		// $dist = $ancho_barra+4;
		// debug("Distancia: $dist ");
		if ($min_val != 0) $valor_cero = (abs($min_val)*100/(abs($max_val)+abs($min_val)));
		else $valor_cero = 0;
		if ($valor_cero>90) $valor_cero = 90;
		// debug("maxval de $nombre_grafica es $max_val y un minval de $min_val y el cero vale $valor_cero ");
		// debug("valor cero: $valor_cero ");
		foreach ($aG as $id => $aVal) {
			if (!is_numeric($id)) {
				$aGrf[$id] = $aVal;
			} else {
				if (!is_array($aLeyenda[$id])) continue;
				$aGrf[$id]['nombre'] = $nombre_grafica;
				$aGrf[$id]['color'] = $aLeyenda[$id]['color'];
				$aGrf[$id]['valor'] = $aVal['data'];
				$aGrf[$id]['etiqueta'] = $aVal['label'];
				$aGrf[$id]['link'] = $aVal['link'];

				if (!$i) $aGrf[$id]['left'] = 0;
				else $aGrf[$id]['left'] = ($dist)*$i;

				if ($valor_cero>0) {
					$numinf = abs($min_val-$aVal['data']);
					// debug("Tenemos $numinf puntos debajo de ".$aVal['data']." para llegar a $min_val ");
					$pto_inf = $numinf * 100/ (abs($max_val)+abs($min_val));
					// debug($aVal['data']." esta a $pto_inf % del borde inferior y a ".($valor_cero-$pto_inf)." % del 0 ");
					// $aGrf[$id]['pto'] = abs($valor_cero - $pto_inf);
					if ($aVal['data'] < $valor_cero) {
						$aGrf[$id]['pto_inf'] = $pto_inf;
						$aGrf[$id]['pto'] = abs($valor_cero - $pto_inf);
					} else {
						$aGrf[$id]['pto_inf'] = $valor_cero;
						$aGrf[$id]['pto'] = abs($valor_cero - $pto_inf) - $valor_cero;
						$aGrf[$id]['pto'] = abs($valor_cero - $pto_inf);
					}
				} elseif ($max_val != 0) {
					$aGrf[$id]['pto'] = round(($aVal['data']/$max_val)*100,2);
				} else $aGrf[$id]['pto'] = 0;

				$aGrf[$id]['ancho'] = $ancho_barra;
				$aGrf[$id]['zindex'] = sizeof($aLeyenda)-$i;
				$i++;
			}
		}
		array_push($aGraficas,$aGrf);
	}
	$Sesion->set_var('_graph_data',$aGraficas,'INMED');

	$Sesion->set_var('_graph_data_reset',1,'INMED');
	$Sesion->set_var('_graph_yaxis_reset',1,'INMED');
	$Sesion->set_var('_graph_leyenda_reset',1,'INMED');

}

function nodb_leyenda_grafico(&$Sesion) {
	static $aLey;
	$reset = $Sesion->get_var('_graph_leyenda_reset');
	if (!is_array($aLey) OR (int)$reset) {
		$aLey = $Sesion->get_var('leyenda');
		if (!is_array($aLey)) return NULL;
		$Sesion->set_var('_graph_leyenda_reset',0,'INMED');
	}
	$retval = array_shift($aLey);
	if (is_array($retval)) return $retval;
	else return NULL;
}

function nodb_graph_list(&$Sesion) {
	static $aGList;
	$reset = $Sesion->get_var('_graph_data_reset');
	if (!is_array($aGList) OR (int)$reset) {
		$aGList = $Sesion->get_var('_graph_data');
		if (!is_array($aGList)) return NULL;
		$Sesion->set_var('_graph_data_reset',0,'INMED');
	}
	$aG = array_shift($aGList);
	if (is_array($aG) AND sizeof($aG)) {
		$aTmp['titulo'] = $aG['titulo'];
		$aG['titulo'] = NULL;
		unset($aG['titulo']);
		$Sesion->set_var('_graphi_data',$aG);

		$Sesion->set_var('_graphi_yaxis',array('max' => $aG['valor_maximo'], 'num_points' => 5, 'min' => $aG['valor_minimo']));
		$aG['valor_maximo'] = NULL;
		unset($aG['valor_maximo']);

		$Sesion->set_var('_graphi_data_reset',1,'INMED');
		$Sesion->set_var('_graphi_yaxis_reset',1,'INMED');
	} else $aTmp = NULL;

	return $aTmp;
}

function nodb_graph_data(&$Sesion) {
	static $aData;
	$reset = $Sesion->get_var('_graphi_data_reset');
	if (!is_array($aData) OR (int)$reset ) {
		$aData = $Sesion->get_var('_graphi_data');
		if (!is_array($aData)) return NULL;
		$Sesion->set_var('_graphi_data_reset',0,'INMED');
	}
	$retval = array_shift($aData);
	if (is_array($retval)) return $retval;
	else return NULL;
}

function nodb_graph_yaxis(&$Sesion) {
	static $aData;
	$reset = $Sesion->get_var('_graphi_yaxis_reset');

	if (!is_array($aData) OR (int)$reset ) {
		$aEje = $Sesion->get_var('_graphi_yaxis');
		if (!is_array($aEje) OR !is_numeric($aEje['max']) OR !is_numeric($aEje['num_points']) ) return NULL;
		$aData = array();

		if ($aEje['min'] != 0) $valor_cero = (abs($aEje['min'])*100/(abs($aEje['max'])+abs($aEje['min'])));
		else $valor_cero = 0;
		if ($valor_cero>90) $valor_cero = 90;
		$valor_diff = abs(abs($aEje['max'])-abs($aEje['min']));

		$incvalor = abs($aEje['max']-$aEje['min']) / $aEje['num_points'];
		if ( abs($aEje['max'])-abs($aEje['num_points']) < abs($aEje['min'])) $n_puntos = abs(ceil($aEje['max']-$aEje['min']));
		else $n_puntos = $aEje['num_points'];
		$n_puntos = $aEje['num_points'];
		// debug("Incremento: $incvalor pto del 0 = $valor_cero puntos $n_puntos diff $valor_diff I: $i");
		for ($i = 0; $i < $n_puntos; $i++) {
			if (!$i) {
				$aTmp['valor'] = $aEje['min'];
				$last_val = $aEje['min'];
				$aTmp['pto'] = 0;
			} else {
				$last_val = $aTmp['valor'] = $last_val + $incvalor;
				if ($aTmp['valor']==0) $aTmp['pto'] = $valor_cero;
				else $aTmp['pto'] = round( (( abs($aTmp['valor'])/$valor_diff) * 90) ,2);
			}
			// debug("Valor: ".$aTmp['valor']." pto: ".$aTmp['pto']);
			array_push($aData,$aTmp);
		}

		array_push($aData,array('pto' => 90, 'valor' => $aEje['max']));
		$Sesion->set_var('_graphi_yaxis_reset',0,'INMED');
	}
	$retval = array_shift($aData);
	if (is_array($retval)) return $retval;
	else return NULL;
}

class ModoSeleccion extends inmersaSerialize {
	var $activo = NULL;
	var $target = NULL;
	var $bMultiple = NULL;
	var $multi_last_target = NULL;

	function Factory() {
		$oS = &$GLOBALS[$GLOBALS['APP_NAME']];
		if (!is_a($oS,'wolSesion')) {
			debug("oS es ".get_class($oS)." no vale ");
			return NULL;
		}
		$oMod = $oS->get_var('oModoSeleccion');
		$bModo = (bool)$oS->fetchVar('modo_seleccion','GET POST');
		if (!$oMod or $bModo) {
			debug("El oMod no es .. ".get_class($oMod));
			$oMod = new ModoSeleccion();
			debug("Ahora vamos a buscar si hay que enlazar uno tras otro ... ");
			$aSel = $oS->fetchVar('seleccion_multiple','POST GET');
			if (is_array($aSel) and sizeof($aSel)) {
				foreach ($aSel as $idx => $aS) {
					if (!is_numeric($idx)) {
						$aOpts[$idx] = $aS;
						continue;
					}
					if (!is_array($aS)) {
						$aTmpSel[$idx]['entidad'] = $aS;
						$aTmpSel[$idx]['varios'] = false;
						debug("Tmp sel con varios a false! ");
					} else {
						debug("Asignando por eggs esto: ");
						print_r($aS);
						$aTmpSel[$idx] = $aS;
						if (!$aTmpSel[$idx]['varios']) $aTmpSel[$idx]['varios'] = false;
					}
					$aTmp = $oS->_VerifyAction($aTmpSel[$idx]['entidad']);
					debug("Acciones de ".$aTmpSel[$idx]['entidad']);
					print_r($aTmp);
					if ( (!is_array($aTmp) and !sizeof($aTmp)) or empty($aTmp['SEL_ss_name']) ) {
						$aTmpSel[$idx] = NULL;
						unset($aTmpSel[$idx]);
						debug("A tomar pol <b>saco</b>!!!");
						continue;
					}
					$tmp_ss = $aTmp['SEL_ss_name'];
					$ss = array_shift(split(' ',$tmp_ss));
					$aTmpSel[$idx]['ss_name'] = $ss;
				}
				$oMod->aMultiple = $aTmpSel;
				$oMod->multi_last_target = $oS->fetchVar('target','GET POST');
				debug("Hemos almacenado de target multi: ".$oMod->multi_last_target);
				print_r($oMod->aMultiple);
				// if (is_arra
				$oMod->activo = true;
			} else $oMod->aMultiple = NULL;
		} 
		debug("Return de ".get_class($oMod));
		return $oMod;
	}

	function Seek() {
		$oS = &$this->getApp();
		debug("En seek sess = ".get_class($oS)." Activo: ".$this->activo);

		if (!is_bool($this->activo)) {
			$this->activo = (bool)$oS->fetchVar('modo_seleccion','GET POST');
		}

		if ($this->activo) {

			debug("Comprobando si hay multiples entidades: ".sizeof($this->aMultiple));
			if (is_array($this->aMultiple)) {
				debug("pues eso... que tamos activos y multiplexaos ... ");
				print_r($this->aMultiple[$idx]);

				$aKs = array_keys($this->aMultiple);
				$ss_prev = $oS->get_old_subsecc_name();
				$ss = $oS->get_subsecc_name();
				$idx_act = $idx_prev = NULL;
				foreach ($aKs as $k) {
					if ($ss == $this->aMultiple[$k]['ss_name']) $idx_act = $k;
					if ($ss_prev == $this->aMultiple[$k]['ss_name']) $idx_prev = $k;
				}

				if (is_numeric($idx_prev)) {
					$aList = $oS->get_var('_oModoSeleccion_container');
					$value = $oS->fetchVar('selecciones','POST GET SESSION');
					$aList[$this->aMultiple[$idx_prev]['entidad']] = $value;
					$oS->set_var('_oModoSeleccion_container',$aList);
					debug("Contenedor! ");
					print_r($aList);
					$this->aMultiple[$idx_prev] = NULL;
					unset($this->aMultiple[$idx_prev]);
				}

				if (is_numeric($idx_act)) {
					if ((bool)$this->aMultiple[$idx_act]['varios']) {
						debug("SI es multiple eh... ");
						$this->bMultiple = true;
					} else $this->bMultiple = false;

					if (sizeof($aKs) > 1) {
						foreach ($aKs as $k) 
							if ($k != $idx_act) {
								$idx = $k;
								break;
							}
						$this->target = $this->aMultiple[$idx]['ss_name'];
					} else $this->target = $this->multi_last_target;
					debug("_EL_ target va a ser: ".$this->target);
				}

			} else {
				$target = $oS->fetchVar('target','GET');
				if (!empty($target)) $this->target = $target;
				elseif (empty($this->target)) {
					$this->target = $oS->get_var('_krn_ss_name');
				}
			}

			if (!is_bool($this->bMultiple)) $this->bMultiple = (bool)$oS->fetchVar('many','GET');

			/** **
			if ($modo_seleccion) {
				$Sesion->set_var('modo_seleccion',$modo_seleccion,'SUBSECCION');
				$Sesion->set_var('modo_seleccion_varios',(int)$sel_many,'SUBSECCION');
			} else {
				$Sesion->unset_var('modo_seleccion');
				$Sesion->unset_var('modo_seleccion_varios');
			}
			if (!empty($target)) $Sesion->set_var('form_target',$target,'SUBSECCION');
			/** **/
		}

		debug("de nuevo, _EL_ target va a ser: ".$this->target);
		debug("Estableciendo la puta variable de los putos cojones: ".get_class($this));
		$oS->setVarByRef('oModoSeleccion',&$this);
		return true;
	}

	function isActive() {
		return (bool)$this->activo;
	}

	function getFormTarget() {
		// debug("Obteniendo target: ".$this->target." contra ".$this->multi_last_target);
		// print_r($this->aMultiple);
		return $this->target;
	}

	function getSelectionType() {
		return (($this->bMultiple) ? 'checkbox' : 'radio');
	}

	function getSelectionName() {
		return (($this->bMultiple) ? 'selecciones[]' : 'selecciones');
	}

}

?>
