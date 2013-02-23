<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , fecha_inicio , fecha_fin  , id_cliente ,  id_empresa */
function fd_facturas_compra(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $fecha_inicio;
   global $fecha_fin;
   global $id_empresa;
   global $id_cliente;
   global $id_serie;
   global $estado;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
 
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
	if (is_numeric($id_serie)) {
		$st_id_serie = $id_serie;
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

	$id_cliente =0;
   if (empty($id_empresa)) {
      $id_empresa =(int) $usuario['id'];
	}
	if (!empty($st_estado)) {
		$Sesion->set_var('st_estado',$st_estado,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_estado');
	}
	if (is_numeric($st_id_serie)) {
		$Sesion->set_var('st_id_serie',$st_id_serie,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_serie');
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
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
