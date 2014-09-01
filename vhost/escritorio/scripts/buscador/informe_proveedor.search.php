<?php
include_inm("scripts/buscador/botonera.php");
function fd_informe_proveedor(&$Sesion,&$oSearch){
	global $fecha_inicio;
	global $fecha_fin;
	global $id_empresa;
	global $id_proveedor;
	global $id_proveedor2;
	global $hp;

	$usuario = identifica_usuarios($Sesion);

	$id_proveedor=(int)$Sesion->get_var("id_proveedor_promocion");
	$id_proveedor2=(int)$Sesion->get_var("id_proveedor_promocion");

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio=NULL;
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
	$oSearch->set_distinct("ROW");
	$oSearch->add_select("SUM(Lineas_detalle.cantidad) as 'cantidad'",FALSE);
	$oSearch->add_select("SUM(Lineas_detalle.cantidad_recibida) as 'cantidad_recibida'",FALSE);
	$oSearch->add_where("Lineas_detalle.id_pedido = Pedidos.id_pedido AND Pedidos.id_proveedor = Compra_articulos.id_proveedor",
									"AND",FALSE);
	$oSearch->_add_from("Lineas_detalle");
	$oSearch->_add_from("Pedidos");

	$oSearch->add_select("SUM(Li.cantidad) as 'cantidad_cliente'",FALSE);
	$oSearch->add_select("SUM(Li.cantidad_recibida) as 'cantidad_recibida_cliente'",FALSE);
	$oSearch->add_where("Compra_articulos.id_articulo = Li.id_articulo AND Li.id_pedido = Ped.id_pedido AND Ped.id_direccion != 0",
									"AND",FALSE);
	$oSearch->_add_from("Lineas_detalle","Li");
	$oSearch->_add_from("Pedidos","Ped");


	// $oSearch->set_ruta_path(array(Facturas_detalle));
	$oSearch->groupby("Compra_articulos.id_articulo");

   if (!empty($nombre)) {
      $st_nombre = $nombre;
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
