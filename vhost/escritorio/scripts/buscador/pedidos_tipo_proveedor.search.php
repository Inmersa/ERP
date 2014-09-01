<?php
include_inm("scripts/buscador/botonera.php");
function fd_pedidos_tipo_proveedor(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_proveedor;
   global $id_empresa;
   global $hp;

   $usuario = identifica_usuarios($Sesion);
   $id_proveedor_sesion = $Sesion->get_var("id_proveedor_promocion");

   if (empty($id_proveedor)) {
      $id_proveedor=(int)$id_proveedor_sesion;
   }
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
	}

   if (!empty($nombre)) {
      $st_nombre = $nombre;
   }

   /** ** No se ven los pedidos sin lineas de iva! :O **/
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
