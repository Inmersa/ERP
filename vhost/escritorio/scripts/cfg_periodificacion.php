<?php

function pre_anyos(&$Sesion) {
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$aNuevo = $Sesion->fetchVar('nuevo_anyo','POST');
	$aDelList = $Sesion->fetchVar('registro_borrar','POST');
	$aAnyos = $Sesion->fetchVar('anyos','POST');
	$aAnyosOld = $Sesion->fetchVar('old_anyos','POST');

	$oDb = $Sesion->get_db('data');

	switch ($accion) {
		case 'Nuevo':
			if (!empty($aNuevo['numero'])) {
				$oPer = new Periodo($Sesion->App_Name,'data',$aNuevo['numero']);
				debug("Construido .. ");
				// Esto no se deberia necesitar, dado que el parametro al constructor ya es el numero de anyo.
				// Arreglarlo para que si no existe, cree el anyo, y el updateYear se haga sobre esa base.
				$aNuevo['f_ini'] = $oPer->getFirstDay();
				$aNuevo['f_fin'] = $oPer->getLastDay();
				$oPer->updateYear($aNuevo);
				break;
			}
			break;

		case 'Modificar':
			if (is_array($aAnyos) AND sizeof($aAnyos)) 
				foreach ($aAnyos as $id_anyo => $aA) {
					if ($aAnyosOld[$id_anyo]['nombre'] != $aA['nombre']) {
						$oDb->tb_update('Anyos',array('id_anyo' => $id_anyo,'nombre' => $aA['nombre']));
					}
					if (is_numeric($aA['n_trimestres']) AND $aA['n_trimestres'] > 0 AND $aA['n_trimestres'] != $aAnyosOld[$id_anyo]['n_trimestres']) {
						$aA['id_anyo'] = $id_anyo;
						$aA['numero'] = $aAnyosOld[$id_anyo]['numero'];
						$aA['f_ini'] = $aAnyosOld[$id_anyo]['f_ini'];
						$aA['f_fin'] = $aAnyosOld[$id_anyo]['f_fin'];
						$oPer = new Periodo($Sesion->App_Name,'data',$aA['numero']);
						$oPer->updateYear($aA);
						unset($oPer);
					}
				}
			break;

		case 'Reconstruir':
			debug("Reconstruyendo: ");
			if (is_array($aDelList) AND sizeof($aDelList))
				foreach ($aDelList as $ida ) {
					$oPer = new Periodo($Sesion->App_Name,'data');
					$oPer->fillUp($ida,'Anyo');
					// $oPer->restoreEntities(array('Albaranes'));
					$oPer->restoreEntities();
					unset($oPer);
				}
			break;

		case 'Borrar':
			debug("Borrando ... ");
			print_r($aDelList);
			if (is_array($aDelList) AND sizeof($aDelList))
				foreach ($aDelList as $ida => $bool) {
					if (is_numeric($ida)) {
						$cons = 'DELETE Anyos.*,Trimestres.*,Semanas.* '.
									'FROM Anyos LEFT JOIN Trimestres ON (Anyos.id_anyo=Trimestres.id_anyo) LEFT JOIN Semanas ON (Trimestres.id_trimestre=Semanas.id_trimestre) '.
									'WHERE Anyos.id_anyo = '.$ida;
						$oDb->query($cons);
					}
				}
			break;
	}
}

?>
