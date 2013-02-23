<?php
include_inm("scripts/buscador/botonera.php");

function fd_pedidos_ventas(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $razons;
   global $ref;
   global $fecha_inicio;
   global $fecha_fin;
   global $preparado;
   global $id_empresa;
   global $id_proveedor;
   global $id_ag;
   global $residuales;
   global $sin_residuales;
   global $sin_consolidados;
	global $hp;

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);
	if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
		$id_ag = $usuario['valor'];
		$oSearch->set_not_ruta_path(array("Pedidos.id_agente"));
	}

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
		if ($Sesion->bRecarga) {
			$fecha_inicio=NULL;
			unset($fecha_inicio);
		} else {
			$fecha_inicio = strftime('%Y-%m-%d', strtotime('last week') );
		}
	} else {
		$st['fecha_inicio'] = $fecha_inicio;
	}

	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =NULL;
		unset($fecha_fin);
	} else {
		$st['fecha_fin']=$fecha_fin;
	}
	$id_proveedor =0;
   if (empty($id_empresa)) {
      $id_empresa =(int) $usuario['id'];
	}

 	if(is_numeric($preparado)) {
		$preparado = (int)$preparado;
		$st['preparado'] = $preparado;
	} else {
		$preparado = NULL;
		unset($preparado);
	}

	if (!empty($residuales)) {
		$st['residuales'] = $residuales;
		$sin_residuales = 0;
		$oSearch->add_where('Pedidos.residual = 1','AND',false);
	}

	if (!empty($sin_residuales)) {
		$st['sin_residuales'] = $sin_residuales;
		$oSearch->add_where('Pedidos.residual = 0','AND',false);
	}

	if (!empty($sin_consolidados)) {
		$st['sin_consolidados'] = $sin_consolidados;
		$oSearch->add_select("COUNT(Pedidos_facturas.id_factura) as 'num_facturas'");
		$oSearch->add_where("Pedidos_facturas.id_factura IS NULL","AND",false);
		$oSearch->useLeftJoin();
	}

	// $oSearch->set_distinct("Lineas_detalle.id_pedido");
	// $oSearch->set_distinct("Pedidos.id_pedido");

	/** Puede haber pedidos sin lineas de detalle (borradas) **/
	$oSearch->add_select("SUM(IVAs.monto) as 'monto_pedido'");
	$oSearch->add_where("IVAs.id_pedido = Pedidos.id_pedido","AND",false);
	$oSearch->groupby("Pedidos.id_pedido");
	/** **/

	$oSearch->set_ruta_path(array("Direcciones_entrega"));

   if (!empty($nombre)) {
      $st['nombre'] = $nombre;
	}
   if (!empty($razons)) {
      $st['razons'] = $razons;
	}
   if (!empty($ref)) {
      $st['ref'] = $ref;
	}

	$Sesion->set_var('st',$st,'SUBSECCION');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
