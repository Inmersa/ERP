<?php
include_inm("scripts/buscador/botonera.php");
function fd_pedidos_tipo_cliente(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_cliente;
   global $id_cliente2;
   global $id_empresa;
	global $hp;

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);

   if (empty($id_cliente)) {
      $id_cliente=(int)$id_cliente_sesion;
	}
   if (empty($id_cliente2)) {
      $id_cliente2=(int)$id_cliente_sesion;
	}
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
	}
   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	$oSearch->add_select("SUM(IVAs.monto) as 'monto_pedido'");
	$oSearch->add_where("IVAs.id_pedido = Pedidos.id_pedido","AND",FALSE);
	$oSearch->groupby("Pedidos.id_pedido");

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
