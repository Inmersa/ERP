<?php

function checkbox_mark(&$Sesion,$aParam) {
	if (sizeof($aParam)!=3) return NULL;
	$aTot = $Sesion->get_var('TotalesInforme');
	$grp_fld = array_shift($aParam);
	if (!is_array($aTot[$grp_fld])) return NULL;
	$fld = array_shift($aParam);
	$fnc = array_shift($aParam);
	foreach ($aTot[$grp_fld] as $aFldTot) {
		if (!strstr($aFldTot['field'],$fld)) continue;
		if (!strcasecmp($aFldTot['fnc'],$fnc)) return ' checked="checked" ';
	}
	return NULL;
}

function cambia_ruptura(&$Sesion,$aParam) {
	static $aLast_val = array();
	$forzar = (int)$Sesion->get_var('cambia_ruptura_forzado');
	$campo = key($aParam);
	if (is_numeric($campo)) return FALSE;

	$val = array_shift($aParam);
	$bool = array_shift($aParam);
	if (!(int)$bool) return false;

	if ($aLast_val[$campo] != $val) {
		$retval = TRUE;
		$aLast_val[$campo] = $val;
		$Sesion->unset_var('cambia_ruptura_forzado');
	} elseif ($forzar) {
		// debug("ruptura forzada ...");
		$Sesion->unset_var('cambia_ruptura_forzado');
		$retval = TRUE;
	} else $retval = FALSE;

	if ($retval) $Sesion->set_var('cambio_ruptura',1,'INMED');
	else $Sesion->set_var('cambio_ruptura',0,'INMED');

	return $retval;
}

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
			$cons .= ' GROUP BY '.$fld;
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

?>
