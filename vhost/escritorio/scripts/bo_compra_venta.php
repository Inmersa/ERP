<?php
function pre_compra_venta(&$Sesion) {
}

/** funcion encargada de ir acumulando los totales por cliente y proveedor para el informe de compra venta
 */
function acumula(&$Sesion,&$aDatos) {
	//$Sesion->set_var("monto_cuenta",$aDatos["Facturas.descuento"] +$Sesion->get_var("monto_cuenta"),"SUBSECCION");
	if($aDatos["Facturas.id_cliente"] != 0){
		$Sesion->set_var("cdescuento",$aDatos["Facturas.descuento"] + $Sesion->get_var("cdescuento"),"SUBSECCION");
		$Sesion->set_var("cbase_imponible",$aDatos["Facturas.base_imponible"] + $Sesion->get_var("cbase_imponible"),"SUBSECCION");
		$Sesion->set_var("ctotal_impuestos",$aDatos["Facturas.total_impuestos"] + $Sesion->get_var("ctotal_impuestos"),"SUBSECCION");
		$Sesion->set_var("cretenido",$aDatos["Facturas.retenido"] + $Sesion->get_var("cretenido"),"SUBSECCION");
		$Sesion->set_var("cmonto_total",$aDatos["Facturas.monto_total"] + $Sesion->get_var("cmonto_total") ,"SUBSECCION");
	}
	elseif($aDatos["Facturas.id_proveedor"] != 0){
		$Sesion->set_var("pdescuento",$aDatos["Facturas.descuento"] + $Sesion->get_var("pdescuento"),"SUBSECCION");
		$Sesion->set_var("pbase_imponible",$aDatos["Facturas.base_imponible"] + $Sesion->get_var("pbase_imponible"),"SUBSECCION");
		$Sesion->set_var("ptotal_impuestos",$aDatos["Facturas.total_impuestos"] + $Sesion->get_var("ptotal_impuestos"),"SUBSECCION");
		$Sesion->set_var("pretenido",$aDatos["Facturas.retenido"] + $Sesion->get_var("pretenido"),"SUBSECCION");
		$Sesion->set_var("pmonto_total",$aDatos["Facturas.monto_total"] + $Sesion->get_var("pmonto_total") ,"SUBSECCION");
	}
}
function nombre_proveedor_o_cliente($Sesion,$aDatos){
	if($aDatos["Facturas.id_cliente"] != 0)
		$consulta2="select nombre from Clientes where id_cliente =".$aDatos["Facturas.id_cliente"];
	if($aDatos["Facturas.id_proveedor"] != 0)
		$consulta2="select nombre from Proveedores where id_proveedor =".$aDatos["Facturas.id_proveedor"];
	$rs2 = $Sesion->query($consulta2);
	$row2=$Sesion->fetch_array($rs2);
	return $row2[0];
}
function cambia_a_proveedor($Sesion,$aDatos){
	static $unica;
	if($aDatos["Facturas.id_proveedor"] != 0 AND $unica != 1){
		$unica=1;
		return 1;
	}
}
//Proveedor
/** coger descuento proveedor de informe compra venta */
function pdescuento($Sesion){
	return $Sesion->get_var("pdescuento");
}
/** coger pbase_imponible proveedor de informe compra venta */
function pbase_imponible($Sesion){
	return $Sesion->get_var("pbase_imponible");
}
/** coger ptotal_impuestos proveedor de informe compra venta */
function ptotal_impuestos($Sesion){
	return $Sesion->get_var("ptotal_impuestos");
}
/** coger pretenido proveedor de informe compra venta */
function pretenido($Sesion){
	return $Sesion->get_var("pretenido");
}
/** coger pmonto_total proveedor de informe compra venta */
function pmonto_total($Sesion){
	return $Sesion->get_var("pmonto_total");
}
//Cliente
/** coger cdescuento cliente de informe compra venta */
function cdescuento($Sesion){
	return $Sesion->get_var("cdescuento");
}
/** coger cbase_imponible cliente de informe compra venta */
function cbase_imponible($Sesion){
	return $Sesion->get_var("cbase_imponible");
}
/** coger ctotal_impuestos cliente de informe compra venta */
function ctotal_impuestos($Sesion){
	return $Sesion->get_var("ctotal_impuestos");
}
/** coger cretenido cliente de informe compra venta */
function cretenido($Sesion){
	return $Sesion->get_var("cretenido");
}
/** coger cmonto_total cliente de informe compra venta */
function cmonto_total($Sesion){
	return $Sesion->get_var("cmonto_total");
}
//Totales
/** coger total de informe compra venta */
function monto_total($Sesion){
	return $Sesion->get_var("cmonto_total") - $Sesion->get_var("pmonto_total");
}
?>
