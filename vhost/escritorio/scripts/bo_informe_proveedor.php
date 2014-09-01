<?php

function pre_informe_proveedor(&$Sesion) {
}//fin del precode

/** saca la suma de articulo comprados por los clientes
*/
function cantidad_clientes(&$Sesion,&$aDatos) {
   $oDb = $Sesion->get_db('data');
   $consulta = "select sum(Lineas_detalle.cantidad) FROM Lineas_detalle , Facturas , Pedidos
		where Lineas_detalle.id_articulo =".$aDatos["Compra_articulos.id_articulo"] .
		"and Facturas.id_factura = Pedidos.id_factura and Pedidos.id_pedido = Lineas_detalle.id_pedido ".
		"  GROUP BY Lineas_detalle.id_articulo";
   $resul=$oDb->query($consulta);
   $row=$oDb->fetch_array($resul);
   $Sesion->set_var("cantidad_clientes",$row[0],"INMED");
   return $row[0];
}
/** saca la suma de articulo recibidos por los clientes
*/
function cantidad_clientes_recibida(&$Sesion,&$aDatos) {
   $oDb = $Sesion->get_db('data');
   $consulta = "select sum(Lineas_detalle.cantidad_recibida) from Lineas_detalle , Facturas , Pedidos
		where Lineas_detalle.id_articulo =".$aDatos['Compra_articulos.id_articulo'] ."
		      and Facturas.id_factura = Pedidos.id_factura and Pedidos.id_pedido = Lineas_detalle.id_pedido
		      GROUP BY Lineas_detalle.id_articulo";
   $resul=$oDb->query($consulta);
   $row=$oDb->fetch_array($resul);
   $Sesion->set_var("cantidad_clientes_recibida",$row[0],"INMED");
   return $row[0];
}

function cantidad_diferencial(&$Sesion,&$aDatos) {
   $total = $aDatos['cantidad'] + $Sesion->get_var("cantidad_clientes") - 
      		($aDatos['cantidad_recibida'] +  $Sesion->get_var('cantidad_clientes_recibida'));
   return $total;
}

?>
