<?php
include_inm("scripts/buscador/botonera.php");
function fd_localizacion_articulos(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_articulo;
	global $hp;

	$id_articulo = $Sesion->fetchVar('id_articulo','GET POST SESSION');
	if (!is_numeric($id_articulo)) $id_articulo = $Sesion->fetchVar('id_articulo_promocion','GET POST SESSION');
	if (is_numeric($id_articulo)) {
		$Sesion->set_var('id_articulo',$id_articulo);
		$Sesion->set_var('id_articulo_promocion',$id_articulo);
	}

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
?>
