<?php
include_inm("scripts/buscador/botonera.php");
function fd_servicios(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
	global $not_serv;
	global $hp;

	$not_serv = 0;

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

function fd_recursos(&$Sesion,&$oSearch) {
	global $hp;
	global $texto;
	global $id_tipo;

	if (!empty($texto)) $aSt['texto'] = $texto;
	if (is_numeric($id_tipo)) $aSt['id_tipo'] = $id_tipo;

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

?>
