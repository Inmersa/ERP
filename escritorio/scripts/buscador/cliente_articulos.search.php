<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_articulo  , id_empresa */
function fd_cliente_articulos(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $id_articulo;
	global $id_art;
	global $id_ag;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
	if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
		$id_ag = $usuario['valor'];
	}
	$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
	}
   if (empty($id_articulo)) {
      $id_articulo =(int)$id_articulo_sesion;
	}
   if (!empty($nombre)) {
      $st_nombre = $nombre;
		if (is_numeric($nombre)) {
			$id_cli = (int)$nombre;
			$nombre= NULL;
			unset($nombre);
		}
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
