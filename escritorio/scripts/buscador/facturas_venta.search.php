<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , fecha_inicio , fecha_fin  , id_empresa , id_proveedor*/
function fd_facturas_venta(&$Sesion,&$oSearch){
  	global $nom_bus;
   global $nombre;
   global $series;
	global $series_ventas;
   global $fecha_inicio;
   global $fecha_fin;
   global $id_empresa;
   global $id_proveedor;
   global $id_serie;
   global $id_ag;
   global $estado;
   global $abonos;
	global $ref;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
	if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
		$id_ag = $usuario['valor'];
		$oSearch->set_not_ruta_path(array("Facturas.id_agente"));
	}

 	if(!empty($estado)) {
		  $st_estado = $estado;
		  if ($estado == 3) {
			  $oSearch->add_where("Facturas.referencia = ''","AND");
			  $oSearch->add_where("Facturas.id_factura","AND");
			  $estado = '-1 / 0 / 1 / 2';
			  // unset($estado);
		  } else {
			  $oSearch->add_where("Facturas.referencia != ''","AND");
			  $estado = (int)$estado - 1;
		  }
   } else {
		$oSearch->add_where("Facturas.referencia != ''","AND");
		$estado = NULL;
		unset($estado);
   }

	if (!empty($series)) {
		$st_series = $series;
		$series_ventas = 1;
	} else {
		$series = NULL;
		$series_ventas = NULL;
		unset($series);
		unset($series_ventas);
	}

	if (!empty($abonos)) {
		$oSearch->add_where('Facturas_abonos.id_factura IS NOT NULL','AND',false);
		$oSearch->add_where('Facturas_abonos.id_factura_abono=Facturas.id_factura ','AND',false);
		$oSearch->_add_from('Facturas_abonos','Facturas_abonos');
		$st_abonos = $abonos;
	} else $oSearch->_add_from('Facturas_abonos');

	$oSearch->useLeftJoin();
	$oSearch->add_select('count(Facturas_abonos.id_factura) as "num_abonos" ',false);
	$oSearch->set_distinct('Facturas.id_factura');
	$oSearch->groupby('Facturas.id_factura');

	if (is_numeric($id_serie)) {
		$st_id_serie = $id_serie;
	}
	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,false)) ) {
      $fecha_inicio=NULL;
		unset($fecha_inicio);
	} else {
		$st_fecha_inicio = $fecha_inicio;
	}
	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,false)) ) {
      $fecha_fin=NULL;
		unset($fecha_fin);
	} else {
		$st_fecha_fin = $fecha_fin;
	}

	$id_proveedor =0;
   if (empty($id_empresa)) {
      $id_empresa =(int) $usuario['id'];
	}

	if (is_numeric($st_id_serie)) {
		$Sesion->set_var('st_id_serie',$st_id_serie,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_serie');
	}
	if (!empty($st_estado)) {
		$Sesion->set_var('st_estado',$st_estado,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_estado');
	}
	if (!empty($st_abonos)) {
		$Sesion->set_var('st_abonos',$st_abonos,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_abonos');
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
   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($st_series)) {
		$Sesion->set_var('st_series',$st_series,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_series');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
