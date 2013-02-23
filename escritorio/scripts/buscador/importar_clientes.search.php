<?php
include_inm("scripts/buscador/botonera.php");
function fd_importar_clientes(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
	global $hp;
	global $id_empresa;

	$usuario = identifica_usuarios($Sesion);
   if (empty($id_empresa)) $id_empresa =(int)$usuario['id'];

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}

	$oSearch->add_where('Clientes_empresas.fecha_baja IS NOT NULL','AND',FALSE);

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}
?>
