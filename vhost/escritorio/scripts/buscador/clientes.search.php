<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_empresa */
function fd_clientes(&$Sesion,&$oSearch){
	global $nom_bus;
   global $nombre;
   global $id_cli;
   global $id_empresa;
	global $id_ag;
	global $id;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
   if (empty($id_empresa)) $id_empresa =(int)$usuario['id'];

	if (!strcasecmp($usuario['desktop_name'],"Agentes")) $id_ag = $usuario['valor'];

	if (!empty($nombre)) {
		$st_nombre = $nombre;
	}
	if (!empty($id_cli)) {
		$st_id_cli = $id_cli;
	}


	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}

	if (!empty($st_id_cli)) {
		$Sesion->set_var('st_id_cli',$st_id_cli,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_cli');
	}

	$oSearch->add_where('Clientes_empresas.fecha_baja IS NULL','AND',FALSE);
	$oSearch->groupby('Clientes.id_cliente');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

function fd_envios(&$Sesion,&$oSearch){
	global $nom_bus;
   global $nombre;
   global $id_cli;
   global $id_empresa;
	global $id_ag;
	global $id;
	global $hp;

	global $id_cli;
	$id_cli = 843;
	global $id_art;
	$id_art = '1133 / 1134 / 1135 / 1136';

	$usuario = identifica_usuarios($Sesion);
   if (empty($id_empresa)) $id_empresa =(int)$usuario['id'];

	if (!strcasecmp($usuario['desktop_name'],"Agentes")) $id_ag = $usuario['valor'];

	if (!empty($nombre)) {
		$st_nombre = $nombre;
	}
	if (!empty($id_cli)) {
		$st_id_cli = $id_cli;
	}


	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}

	if (!empty($st_id_cli)) {
		$Sesion->set_var('st_id_cli',$st_id_cli,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_cli');
	}

	$oSearch->useLeftJoin();
	// $oSearch->add_where('Clientes_empresas.fecha_baja IS NULL','AND',FALSE);
	// $oSearch->groupby('Clientes.id_cliente');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}


/** **
select STRAIGHT_JOIN count(*)
	FROM Articulos
	LEFT JOIN Marcas  ON (Articulos.id_marca=Marcas.id_marca)
	LEFT JOIN Familia_articulos  ON (Articulos.id_familia=Familia_articulos.id_familia)
	LEFT JOIN Lineas_detalle  ON (Articulos.id_articulo=Lineas_detalle.id_articulo)
	LEFT JOIN Pedidos  ON (Lineas_detalle.id_pedido=Pedidos.id_pedido)
	LEFT JOIN Direcciones_entrega  ON (Pedidos.id_direccion=Direcciones_entrega.id_direccion)
	LEFT JOIN Detalles_albaran  ON (Lineas_detalle.id_detalle=Detalles_albaran.id_detalle )
	LEFT JOIN Albaranes  ON (Detalles_albaran.id_albaran=Albaranes.id_albaran)
	LEFT JOIN Transportistas  ON (Albaranes.id_transportista=Transportistas.id_transportista)
	LEFT JOIN Facturas_detalle  ON (Lineas_detalle.id_detalle=Facturas_detalle.id_detalle )
	LEFT JOIN Facturas  ON (Facturas_detalle.id_factura=Facturas.id_factura)
	WHERE Direcciones_entrega.id_cliente = 843 AND
	(Articulos.id_articulo = 1133 OR Articulos.id_articulo = 1134 OR Articulos.id_articulo = 1135 OR Articulos.id_articulo = 1136 );

	Ld.id_articulo,Ld.cantidad as "CantidadPedida", P.referencia as
	"ReferenciaPedido", P.fecha as "FechaPedido", Ld.cantidad_recibida as
	"TotalCantidadServida",
	Fd.cantidad as "CantidadFacturada", F.referencia as "ReferenciaFactura",
	F.fecha as "FechaFactura", Da.cantidad as "CantidadEnAlbaran", Da.cantidad_devuelta as "CantidadDevuelta",
	Da.fecha_caducidad as "FechaDeCaducidad", Da.lote as "LoteDelProducto",
	A.referencia as "ReferenciaAlbaran", A.fecha as "FechaDelAlbaran",
	T.nombre as "NombreDeTransportista"
/** **/

?>
