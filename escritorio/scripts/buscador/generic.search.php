<?php
include_inm("scripts/buscador/botonera.php");

function fd_generic_form(&$Sesion) {
	$oSearch = &$Sesion->getSearch();
	if (!is_a($oSearch,'wol_search')) {
		//FixME: Aqui, un mensaje de error, seria oportuno.
		$Sesion->set_var('__fdgeneric_omitir',1,'INMED');
		return;
	}
	$sname = $oSearch->get_search_name();
	$Sesion->set_var('__fdgeneric_searchname',$sname,'SUBSECCION');
}

function fd_generic(&$Sesion,&$oSearch) {
	$hp=$Sesion->fetchVar('hp','POST');
	$ids=$Sesion->fetchVar('ids','POST');
	$texto=$Sesion->fetchVar('texto','POST');
	$id_tipo = $Sesion->fetchVar('id_tipo','POST');
	$fecha_inicio=$Sesion->fetchVar('fecha_inicio','POST');
	$fecha_fin=$Sesion->fetchVar('fecha_fin','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	debug("FixMe: Incluir variable de metodo/clase para llamada adicional (agrupaciones, etc .. ) ");

	if (!empty($texto)) $aSt['texto'] = $texto;
	if (!empty($ids)) $aSt['ids'] = $ids;
	if (is_numeric($id_tipo)) $aSt['id_tipo'] = $id_tipo;
	if (is_numeric($estado)) $aSt['estado'] = $estado;
	if (!empty($fecha_inicio)) $aSt['fecha_inicio'] = $fecha_inicio;
	if (!empty($fecha_fin)) $aSt['fecha_fin'] = $fecha_fin;

	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

function fd_generic_leftjoin(&$Sesion,&$oSearch) {
	fd_generic(&$Sesion,&$oSearch);
	$oSearch->useLeftJoin(true);
}

?>
