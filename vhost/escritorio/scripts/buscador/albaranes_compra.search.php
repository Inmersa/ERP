<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , fecha_inicio , fecha_fin  , id_empresa */
function fd_albaranes_compra($Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $fecha_inicio;
   global $fecha_fin;
   global $id_empresa;
	global $hp;

	$usuario = identifica_usuarios($Sesion);

	switch ($usuario['desktop_name']) {
		case 'Almacenes':
			$id_alm = $usuario['valor'];
			break;
	}

	if (!empty($nombre)) {
		$st_nombre = $nombre;
	}
	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio =NULL;
		unset($fecha_inicio);
	} else {
		$st_fecha_inicio = $fecha_inicio;
	}
	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =NULL;
		unset($fecha_fin);
	} else {
		$st_fecha_fin = $fecha_fin;
	}

   if (empty($id_empresa)) {
      $id_empresa =(int) $usuario['id'];
	}
	$oSearch->set_not_ruta_path(array('Provincias'));
	//$oSearch->add_where('Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL','AND',false);
	// $oSearch->add_where('(Albaranes.id_direccion = 0 OR Pedidos.id_direccion = 0) AND Albaranes.id_direccion IS NULL','AND',false);
	$oSearch->add_where('(Albaranes.id_direccion=0 OR Albaranes.id_direccion IS NULL) AND '.
								' (Pedidos.id_direccion=0 OR Pedidos.id_direccion IS NULL)','AND',false);
	$oSearch->useLeftJoin();

	if (!empty($st_fecha_inicio)) {
		$Sesion->set_var('st_fecha_inicio',$st_fecha_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_inicio');
	}
	if (!empty($st_fecha_fin)) {
		$Sesion->set_var('st_fecha_fin',$st_fecha_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_fin');
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
