<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_empresa */
function fd_descuento_familia(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
	global $hp;

	$usuario = identifica_usuarios($Sesion);

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
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
