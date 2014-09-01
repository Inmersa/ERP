<?php
include_inm("scripts/buscador/botonera.php");
/** variables  fecha_inicio , fecha_fin  , id_empresa , estado = 1*/
function fd_compra_venta(&$Sesion,&$oSearch){
	global $fecha_inicio;
	global $fecha_fin;
	global $id_empresa;
	global $estado;
	global $hp;

	$usuario = identifica_usuarios($Sesion);

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio= date ("Y-m-d", mktime (0,0,0, date("m")-1, date("d"), date("Y")));
	} else $fecha_inicio = descolocar_fecha($fecha_inicio);
	$st_fecha_inicio = $fecha_inicio;

	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =date("Y-m-d");
	} else $fecha_fin = descolocar_fecha($fecha_fin);
	$st_fecha_fin = $fecha_fin;

	if (empty($id_empresa)) {
      $id_empresa =(int) $usuario[id];
	}
	$estado =1;
	$st_estado = $estado;

	if (!empty($st_estado)) {
		$Sesion->set_var('st_estado',$st_estado,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_estado');
	}
	if (!empty($st_fecha_fin)) {
		$Sesion->set_var('st_fecha_fin',$st_fecha_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_fin');
	}
	if (!empty($st_fecha_inicio)) {
		$Sesion->set_var('st_fecha_inicio',$st_fecha_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_inicio');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
