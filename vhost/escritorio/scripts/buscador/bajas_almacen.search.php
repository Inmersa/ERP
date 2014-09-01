<?php
include_inm("scripts/buscador/botonera.php");

function fd_bajas_almacen(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $fecha_inicio;
   global $fecha_fin;
   global $id_alml;
   global $id_almacen;
   global $id_baja;
   global $hp;

   $id_almacen_logico_sesion = $Sesion->get_var("id_almacen_logico_promocion");
   if (empty($id_alml) AND !$Sesion->bRecarga) {
      $id_almacen_logico =(int)$id_almacen_logico_sesion;
   } else $id_almacen_logico = $id_alml;
	if (is_numeric($id_almacen_logico)) {
		$Sesion->set_var('id_almacen_logico_promocion',$id_almacen_logico,'SECCION');
		$Sesion->set_var('id_almacen_logico',$id_almacen_logico,'SECCION');
		$st_id_alml = $id_almacen_logico;
	}

   if(!empty($nombre)) {
      $st_nombre = $nombre;
   }
   if(!empty($id_baja)) {
      $st_id_baja = $id_baja;
   }
	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio=NULL;
      unset($fecha_inicio);
   } else {
      $st_fecha_inicio = $fecha_inicio;
   }
	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin=NULL;
      unset($fecha_fin);
   } else {
      $st_fecha_fin = $fecha_fin;
   }

	$oSearch->useLeftJoin();


   if (!empty($st_nombre)) {
      $Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre2');
   }
   if (!empty($st_id_baja)) {
      $Sesion->set_var('st_id_baja',$st_id_baja,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_id_baja');
   }
   if (!empty($st_id_alml)) {
      $Sesion->set_var('st_id_alml',$st_id_alml,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_id_alml');
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
