<?php

function voip_ahorro_competencia(&$Sesion) {
	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';

	$oPedido = $Sesion->get_var($docvar);
	if (!is_object($oPedido)) return NULL;
	$aCfg = $Sesion->get_var('_aAppConf');
	$n_dec = $aCfg['gnrl_totdoc_digits'];

	$aIdxList = $oPedido->_aIndices['marca']->get();
	if (!is_array($aIdxList) OR !sizeof($aIdxList)) return 0;

	// Recolectando porcentajes por marca:
	foreach ($aIdxList as $idx => $aIdx) {
		$idxdet = array_shift($aIdx['values']);
		$id = $oPedido->getDetailAttribute($idxdet,'id_marca');
		if (!is_array($aMarcas[$id])) {
			$aMarcas[$id]['values'] = $aIdxList[$idx]['values'];
		}
		$idxdet = $id = NULL;
	}

	$consumo_timo = 0;
	$aIds = array_keys($aMarcas);
	if (is_array($aIds) AND sizeof($aIds)) {
		$oDb = $Sesion->get_db('data');

		foreach ($aIds as $idm ) {
			$str_where .= ( (!empty($str_where)) ? ' OR ' : '' ).' id_marca = '.$idm; 
		}

		$cons = 'SELECT id_marca,nombre,observaciones FROM Marcas WHERE '.$str_where;
		$mrs = $oDb->query($cons);
		if ($oDb->num_rows($mrs)) {
			while ($aTmp = $oDb->fetch_assoc($mrs)) {
				if (is_array($aMarcas[$aTmp['id_marca']])) {
					$aMarcas[$aTmp['id_marca']]['data'] = $aTmp;
				}
			}
		}

		foreach ($aMarcas as $id => $aM) {
			if (is_array($aM['values']) AND sizeof($aM['values'])) {
				$dto = $consumo_base = $descuento = $bruto = $base = $cant = 0;
				foreach ($aM['values'] as $i => $idx) {
					$aDet = $oPedido->get_detail($idx);

					$cant += $oPedido->get_quantity($idx);
					$base += $oPedido->getDetailAttribute($idx,'base_imponible');

					$dto = 0;
					if ($oPedido->have_discount($idx)) {
						$aDto = $oPedido->get_detail_discount($idx);
						if ($aDto['porciento'] != 0) {
							if ($aDto['porciento'] >= 100) $dto = $aDet['base_imponible'];
							else $dto = ($aDto['porciento']*$aDet['base_imponible']) / (100 - $aDto['porciento']);
						} else {
							$dto = $aDto['monto'];
						}
						$descuento += $dto;
					}
					$consumo_base += ($aDet['base_imponible']+$dto);
				}

				if (is_numeric($aM['data']['observaciones'])) {
					$consumo_timo += ($consumo_base * $aM['data']['observaciones'] / 100);
				}
			}
		}
	}
	$ahorro = lcdec($consumo_timo,$Sesion);
	return $ahorro;
}

?>
