<?php

function nuevo_cliente(&$Sesion,&$aData) {
	static $id_cli;

	if (!isset($id_cli) OR empty($id_cli)) {
		$id_cli = (int)$aData["Clientes.id_cliente"];
		return 1;
	} elseif ($id_cli == (int)$aData["Clientes.id_cliente"]) {
		return 0;
	} else {
		$id_cli = (int)$aData["Clientes.id_cliente"];
		return 1;
	}
}

function pre_efectos(&$Sesion) {
	$efecto=$Sesion->fetchVar('efecto','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$id_efecto=$Sesion->fetchVar('id_efecto','GET');
	$efecto_parcial=$Sesion->fetchVar('efecto_parcial','POST');
	$borrar_parciales=$Sesion->fetchVar('borrar_parciales','POST');
	$usar_vencimiento=(int)$Sesion->fetchVar('usar_vencimiento','POST');
	$efectos=$Sesion->fetchVar('efectos','POST');
	$cc_efectos=$Sesion->fetchVar('cc_efectos','POST');
	$venta=$Sesion->fetchVar('venta','POST');

	if (!empty($accion_ejecutar)) {
		$oDb = $Sesion->get_db('data');
		$oDbCfg = $Sesion->get_db('conf');
	}
	if (is_numeric($id_efecto) AND !empty($id_efecto)) {
		$Sesion->set_var("id_efecto",$id_efecto,"SECCION");
	} else {
		$id = $Sesion->get_var("id_efecto");
		if (is_numeric($id) AND !empty($id)) {
			$Sesion->set_var("id_efecto",$id,"SECCION");
			$id_efecto = $id;
		}
	}
	$aCfg = $Sesion->get_var('_aAppConf');
	$aEfectosList = array();
	$bUpdate = false;
	switch($accion_ejecutar) {
		case "Emitir" :
			if (is_array($registro['efectos'])) {
				foreach ($registro['efectos'] as $id_efecto => $bool) {
					if ((int)$bool) {
						$oEfecto = new Draft ($Sesion->App_Name);
						$oEfecto->dbFill($id_efecto);
						$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio']);
						$oEfecto->Issue();
						unset($oEfecto);
					}
				}
			}
			break;

		case "Modificar" :
			if (is_array($efectos) AND sizeof($efectos)) {
				$bUpdate = false;
				foreach ($efectos as $id_efecto => $aEfectosChk) {
					if (!empty($aEfectosChk['fecha_vencimiento']) AND $aEfectosChk['old_fecha'] != $aEfectosChk['fecha_vencimiento']) {
						$oEfecto = new Draft ($Sesion->App_Name);
						if ($oEfecto->dbFill($id_efecto)) {
							$bUpdate = true;
							$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],$aCfg['iconta_diario'],$aCfg['iconta_canal']);
							$oEfecto->update(array('fecha_vencimiento' => $aEfectosChk['fecha_vencimiento']));
							array_push($aEfectosList,$oEfecto);
							unset($oEfecto);
						}
					}
				}
			}
			break;

		case "Abonar" :
			if (is_array($registro['efectos']) AND sizeof($registro['efectos'])) {
				foreach ($registro['efectos'] as $id_efecto => $bool) {
					$oEfecto = new Draft ($Sesion->App_Name);
					if ($oEfecto->dbFill($id_efecto)) {
						$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],$aCfg['iconta_diario'],$aCfg['iconta_canal']);

						$aEfectosChk = $registro['efectos'];
						$id_banco = $registro['id_banco'];
						$bUpdate = true;
						if (!empty($efectos[$id_efecto]['fecha_vencimiento']) AND $efectos[$id_efecto]['old_fecha'] != $efectos[$id_efecto]['fecha_vencimiento']) {
							$oEfecto->update(array('fecha_vencimiento' => $efectos[$id_efecto]['fecha_vencimiento']));
						}
						if ($usar_vencimiento) {
							$oEfecto->setDate($efectos[$id_efecto]['fecha_vencimiento'],'abono');
						}
						if (!$oEfecto->isPaid()) {
							$oEfecto->Pay(array('id_banco' => $id_banco));
						}
						array_push($aEfectosList,$oEfecto);
						unset($oEfecto);
					} else $bUpdate = false;
				}
			}
			break;

		case "Devolver":
			if (is_array($registro['efectos'])) {
				foreach ($registro['efectos'] as $id_efecto => $bool) {
					$oEfecto = new Draft ($Sesion->App_Name);
					if ($oEfecto->dbFill($id_efecto)) {
						$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],$aCfg['iconta_diario'],$aCfg['iconta_canal']);

						$aEfectosChk = $registro['efectos'];
						$bUpdate = true;
						if ($oEfecto->isPaid()) {
							debug("Si ta pagao joer.. ");
							$oEfecto->setNotPaid();
						}
						array_push($aEfectosList,$oEfecto);
						unset($oEfecto);
					} else $bUpdate = false;
				}
			}
			break;

		// Casos de la Ficha de Efecto:
		case "Ficha_Efecto" :
			if (is_array($efecto) AND sizeof($efecto) AND $efecto['id_efecto'] == $id_efecto) {
				$oEfecto = new Draft ($Sesion->App_Name);
				if ($oEfecto->dbFill($id_efecto)) {
					$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],$aCfg['iconta_diario'],$aCfg['iconta_canal']);

					$aOld = $efecto['old'];
					$efecto['old'] = NULL;
					$efecto['emitido'] = (int)$efecto['emitido'];
					$efecto['pagado'] = (int)$efecto['pagado'];
					$efecto['devuelto'] = (int)$efecto['devuelto'];
					$efecto['id_banco'] = (int)$efecto['id_banco'];

					if ($efecto['id_banco'] != $oEfecto->getAttribute('id_banco') ) $aTmpChg['id_banco'] = $efecto['id_banco'];
					if (strcmp(wol_db::formatear_fecha($efecto['fecha_vencimiento'],false),wol_db::formatear_fecha($oEfecto->getDate('vencimiento'),false)) )
						$aTmpChg['fecha_vencimiento'] = $efecto['fecha_vencimiento'];
					if (strcmp(wol_db::formatear_fecha($efecto['fecha_abono'],false),wol_db::formatear_fecha($oEfecto->getDate('abono'),false)) OR
							((int)$efecto['pagado'] AND $efecto['pagado']!=$oEfecto->getAttribute('pagado')) )
						$aTmpChg['fecha_abono'] = $efecto['fecha_abono'];

					if (is_array($aTmpChg) AND sizeof($aTmpChg)) $oEfecto->update($aTmpChg);

					if (!$oEfecto->isPaid() AND $efecto['pagado']) $oEfecto->Pay($efecto['id_banco']);
					elseif ($oEfecto->isPaid() AND (!$efecto['pagado'] OR $efecto['devuelto']) ) {
						$oEfecto->setNotPaid( (($efecto['devuelto']) ? true : false) );
					}

					if ($Sesion->verifyVar('efecto_parcial',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('efecto_parcial',IKRN_VAR_CRC_AUTHED)) {
						// Query para pagos parciales:
						if (is_array($efecto_parcial) AND sizeof($efecto_parcial) AND $efecto_parcial['id_efecto']==$id_efecto 
								AND is_numeric($efecto_parcial['monto_satisfecho']) AND abs($efecto_parcial['monto_satisfecho'])>0) {
							$oParciales = &$oEfecto->getPartialDrafts();
							$oParciales->insert($efecto_parcial);
							unset($oParciales);
						}
					}
					$bUpdate = true;
					array_push($aEfectosList,&$oEfecto);
				}
				unset($oEfecto);
			}
			break;

		case "Borrar_parciales" :
			if ($Sesion->verifyVar('borrar_parciales',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_parciales',IKRN_VAR_CRC_CHANGE)) {
				if (is_array($borrar_parciales) AND sizeof($borrar_parciales) AND is_numeric($id_efecto) ) {
					foreach ($borrar_parciales as $id_efecto_parcial) {
						$oEfecto = new Draft ($Sesion->App_Name);
						if ($oEfecto->dbFill($id_efecto)) {
							$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio'],$aCfg['iconta_diario'],$aCfg['iconta_canal']);
							$oParciales = &$oEfecto->getPartialDrafts();
							$aIms = $oParciales->getFromIndex('id_efecto_parcial',$id_efecto_parcial);
							if (is_array($aIms) AND sizeof($aIms)) 
								foreach ($aIms as $idx)
									$oParciales->delete($idx);
							unset($oParciales);
						}

						$bUpdate = true;
						array_push($aEfectosList,&$oEfecto);
						unset($oEfecto);
					}
				}
			}
			break;
	}

	if ($bUpdate AND is_array($aEfectosList) AND sizeof($aEfectosList)) {
		foreach ($aEfectosList as $idx => $oE) {
			if (is_a($oE,'Draft')) {
				$aEfectosList[$idx]->Dump();
			}
		}
	}

	$Sesion->set_var('totalizar_campo','1','SUBSECCION');
	$Sesion->set_var('totalizar_valor','1','SUBSECCION');
	// $Sesion->unset_var('totalizar_campo');
	$oMsg = $Sesion->getMsgs();
	$temsg = $oMsg->rawMsg('MISC_EFLBL_TOTAL');
	$mpmsg = $oMsg->rawMsg('MISC_EFLBL_PAGADO');
	$aTmpTot = array(
			'1' => array(
				array( 'field' => 'IF(Efectos.pago_cobro,Efectos.monto,-1*Efectos.monto)', 'fnc' => 'SUM', 'name' => $temsg['msg']),
				array( 'field' => 'IF(Efectos.pago_cobro,Efectos.monto_pagado,-1*Efectos.monto_pagado)', 'fnc' => 'SUM', 'name' => $mpmsg['msg'])
				) );
	$Sesion->set_var('TotalesInforme',$aTmpTot,'SUBSECCION');

}

function nuevo_proveedor(&$Sesion,&$aData) {
	static $id_cli;

	if (!isset($id_cli) OR empty($id_cli)) {
		$id_cli = (int)$aData["Proveedores.id_proveedor"];
		return 1;
	} elseif ($id_cli == (int)$aData["Proveedores.id_proveedor"]) {
		return 0;
	} else {
		$id_cli = (int)$aData["Proveedores.id_proveedor"];
		return 1;
	}
}

function estado_efecto(&$Sesion,$Params) {
	// debug("Estado...");
	// print_r($Params);
	if ($Params["Efectos.emitido"]==0 AND $Params["Efectos.pagado"]==0 AND $Params["Efectos.devuelto"]==0) 
		return $Params['noemitido'];
	elseif ($Params["Efectos.pagado"] == 0 AND $Params["Efectos.emitido"] == 1 AND $Params["Efectos.devuelto"]==0)
		return $Params['emitido'];
	elseif ($Params["Efectos.pagado"] == 1 )
		return $Params['abonado'];
	elseif ($Params["Efectos.devuelto"] == 1)
		return $Params['devuelto'];
}

function tipo_efecto($dato) {
	if ($dato == 0) return "A Pagar";
	else return "A Cobrar";
}

/** OJO: Esta funcion esta capada para que funcione bien en esta seccion de efectos:
  * 	se le ha eliminado la composicion de la clausula group by.
  **/
function nodb_totalizar(&$Sesion) {
	static $aRec = array();
	static $bNotDone = TRUE;
	/** **
	static $aTot = array(
		'Clientes.id_cliente' => array(
			array( 'field' => 'Facturas.base_imponible', 'fnc' => 'SUM', 'name' => 'Facturacion (ojo idiomas)'),
			array( 'field' => 'Facturas.total_impuestos', 'fnc' => 'SUM', 'name' => 'Impuestos (ojo idiomas)'),
			array( 'field' => 'Facturas.id_factura', 'fnc' => 'COUNT', 'name' => 'No Fras (ojo idiomas)')
			),
		'Agentes.id_agente' => array(
			array( 'field' => 'Facturas.base_imponible', 'fnc' => 'SUM', 'name' => 'Ag-Facturacion (ojo idiomas)'),
			array( 'field' => 'Facturas.total_impuestos', 'fnc' => 'SUM', 'name' => 'Ag-Impuestos (ojo idiomas)', 'round' => 2),
			array( 'field' => 'Facturas.id_factura', 'fnc' => 'COUNT', 'name' => 'Ag-No Fras (ojo idiomas)')
			)
			);
	/** **/
	$aTot = $Sesion->get_var('TotalesInforme');

	if (!sizeof($aRec) AND $bNotDone) {
		$aCond = array();
		$fld = $Sesion->get_var('totalizar_campo');
		$fld = str_replace(',','.',$fld);
		$val = $Sesion->get_var('totalizar_valor');
		// debug("Cond-fld: $fld_cond  Cond-val: $val_cond");

		$aTmpfld_cond = $Sesion->get_var('totalizar_cond_campo');
		$aTmpval_cond = $Sesion->get_var('totalizar_cond_valor');
		if (is_array($aTmpfld_cond) AND is_array($aTmpval_cond))
			foreach ($aTmpfld_cond as $idx => $fld_cond) {
				$fld_cond = str_replace(',','.',$fld_cond);
				$val_cond = $aTmpval_cond[$idx];
				// Si no ha habido un error, y no este disponible el valor (es decir, haya llegado con texto clavao al nombre de campo)
				if (strcmp($val_cond,$fld_cond)) {
					array_push($aCond,array($fld_cond,$val_cond));
				}
			}

		$oDb = $Sesion->get_db('data');
		$oBuscador = $Sesion->b_activa;
		$from = $oBuscador->cons_secc[0]['from'];
		$where = $oBuscador->cons_secc[0]['where'];

		// debug("tot:".is_object($oBuscador));
		// print_r($aTot[$fld]);
		if (is_array($aTot[$fld])) {
			foreach ($aTot[$fld] as $aInfo) {
				// debug("campo $campo funcion $fnc");
				// print_r($aInfo);
				if (empty($aInfo['field'])) continue;
				$strselect .= ((!empty($strselect)) ? ', ' : '').
									( (is_numeric($aInfo['round'])) ? 'ROUND(' : '' ).
									$aInfo['fnc'].'('.$aInfo['field'].')'.
									( (is_numeric($aInfo['round'])) ? ','.$aInfo['round'].')' : '' ).
									' as "'.$aInfo['name'].'"';
			}
		}
		if (!empty($strselect)) {
			$cons = 'SELECT '.$strselect.' '.$from.' '.$where.( (!empty($where)) ? ' AND (' : ' WHERE (').$fld.' = "'.$val.'") ';
			if (is_array($aCond) AND sizeof($aCond))
				foreach ($aCond as $aC) {
					$cons .= ( (isset($aC[0]) AND isset($aC[1])) ? ' AND ( '.$aC[0].' = "'.$aC[1].'") ' : '');
				}
			// $cons .= ' GROUP BY '.$fld;
			// debug($cons);
			$idrs = $oDb->query($cons);
			if ($oDb->num_rows($idrs)) {
				$aRec = $oDb->fetch_assoc($idrs);
			} else $aRec = array();
			$oDb->libera($idrs);

		}
		$Sesion->unset_var('totalizar_cond_valor');
		$Sesion->unset_var('totalizar_cond_campo');
		$bNotDone = FALSE;
	}

	$aRetVal = NULL;
	if (sizeof($aRec)) {
		$nombre = key($aRec);
		$aRetVal['nombre_campo'] = $nombre;
		$aRetVal['valor_campo'] = $aRec[$nombre];
		array_shift($aRec);
	} else {
		$bNotDone = TRUE;
	}

	return $aRetVal;
}

function pre_imprimir(&$Sesion) {
	$imprimir = $Sesion->fetchVar('imprimir','GET');
	$id_efecto = $Sesion->fetchVar('id','GET');
	$efectos_parciales = $Sesion->fetchVar('borrar_parciales','POST');
	$efectos_list = $Sesion->fetchVar('registro','POST');

	if (!is_numeric($id_efecto)) $id_efecto = $Sesion->get_var('id_efecto');

	if (is_numeric($id_efecto)) {
		$Sesion->set_var('id_efecto',$id_efecto,'SUBSECCION');
		$Sesion->set_var('str_where_efectos','Efectos.id_efecto='.$id_efecto,'SUBSECCION');
		if (is_array($efectos_parciales) AND sizeof($efectos_parciales)) {
			$Sesion->set_var('id_efecto_parcial',array_shift($efectos_parciales),'SUBSECCION');
		} else $Sesion->unset_var('id_efecto_parcial');
	} else {
		if (is_array($efectos_list['efectos']) AND sizeof($efectos_list['efectos']))
			foreach ($efectos_list['efectos'] as $id => $bool) {
				if ((int)$bool) {
					$str_where .= ( (!empty($str_where)) ? ' OR ' : '' ).' Efectos.id_efecto = '.$id;
				}
			}
		if (!empty($str_where)) $Sesion->set_var('str_where_efectos',$str_where,'SUBSECCION');
		else {
			// Bonito error
			return NULL;
		}
	}



	if ((int)$imprimir ) {
		$aPlt = $Sesion->get_plt_array('print_document');
		return $aPlt[1];
	}
}

function cf_impresion_efectos(&$Sesion,&$aData) {

	if (!is_numeric($aData['Efectos.id_factura'])) return false;

	if ((int)$aData['Facturas.id_proveedor']) $tipo = inmPed_COMPRA;
	else $tipo = inmPed_VENTA;

	$oFra = new Invoice($Sesion->App_Name,'data',$tipo);
	if (!$oFra->dbFill($aData['Efectos.id_factura'])) return false;

	$Sesion->set_var('__document_iface_varname','oFacturaEfecto','SUBSECCION');
	$Sesion->set_var('oFacturaEfecto',$oFra,'SUBSECCION');

	return true;
}

?>
