<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , nombre2 , id_empresa */

function fd_agentes($Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $nombre2;
   global $hp;

   $usuario = identifica_usuarios($Sesion);
   
   if(!empty($nombre2)) {
      $nombre2=(int)$nombre2;
      $st_nombre2 = $nombre2;
   }
   if(!empty($nombre)) {
      $st_nombre = $nombre;
   }
	$id_empresa =(int)$usuario[id];

	if (!empty($st_nombre2)) {
		$Sesion->set_var('st_nombre2',$st_nombre2,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre2');
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
