<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_cliente  , id_empresa */
function fd_articulos_descuento(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_cliente;
   global $id_empresa;
	global $id_art;
	global $hp;

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}
   if (empty($id_cliente)) {
      $id_cliente= (int)$id_cliente_sesion;
	}
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
	}
   if (!empty($id_art)) {
      $st_id_art = $id_art;
	}

	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($st_id_art)) {
		$Sesion->set_var('st_id_art',$st_id_art,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_art');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

/** variables nombre , id_cliente  , id_empresa */
function fd_nuevo_articulos_descuento(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
	global $id_art;
	global $hp;

	$id_cliente = id_entidad($Sesion,'id_cliente');
	$usuario = identifica_usuarios($Sesion);

   if (!empty($nombre)) {
      $st_nombre = $nombre;
		if (is_numeric($nombre)) {
			$id_art = (int)$nombre;
			$nombre = NULL;
			unset($nombre);
		} else {
			unset($id_articulo);
		}
	}
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
	}

	$oSearch->useLeftJoin();

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
