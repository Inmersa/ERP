<?php
include_inm("scripts/buscador/botonera.php");

/** variables nombre ,cantidad_inicio , cantidad_fin  , fecha , id_almacen_logico */
function fd_localizacion_articulos(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $cantidad_inicio;
   global $cantidad_fin;
   global $id_almacen_logico;
   global $fecha;
   global $hp;

   $id_almacen_logico_sesion = $Sesion->get_var("id_almacen_logico_promocion");
	if (!is_numeric($id_almacen_logico) AND is_numeric($id_almacen_logico_sesion)) {
		$id_almacen_logico = $id_almacen_logico_sesion;
	}

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}
   if (empty($cantidad_inicio)) {
      $cantidad_inicio="0";
	} else {
		$st_cantidad_inicio = $cantidad_inicio;
	}
   if (empty($cantidad_fin)) {
      $cantidad_fin ="1000000000000000";
	} else {
		$st_cantidad_fin = $cantidad_fin;
	}
   if (empty($id_almacen_logico)) {
      $id_almacen_logico =(int)$id_almacen_logico_sesion;
	}
	if (empty($fecha) OR $fecha=="dd-mm-aaaa") {
      $fecha=NULL;
		unset($fecha);
	} else {
		$st_fecha = $fecha;
		$fecha = descolocar_fecha($fecha);
	}

	if (!empty($st_cantidad_inicio)) {
		$Sesion->set_var('st_cantidad_inicio',$st_cantidad_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_cantidad_inicio');
	}
	if (!empty($st_cantidad_fin)) {
		$Sesion->set_var('st_cantidad_fin',$st_cantidad_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_cantidad_fin');
	}
	if (!empty($st_fecha)) {
		$Sesion->set_var('st_fecha',$st_fecha,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha');
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
