<?php 

function include_inm($file) {
  return			 include($file);
}

function file_inm($file) {
		  return file($file);
}

require('config.php');
$DEBUG='ON';

include("kernel/db.inc");                  //** Motores SQL **
include("kernel/sesiones.inc");            //** Modulo de Comunicaciones **
include("kernel/errores.inc");             //** Deteccion y Gestion de Errores **
include("kernel/misc.inc");                //** varios **
include("kernel/plantillas.inc");          //** Motor de Plantillas **
include("kernel/buscador.inc");            //** Modulo de Busquedas **
include("kernel/menus.inc");               //** Gestion de Menus **
include("kernel/accesos.inc");             //** Jerarquia de Accesos *

include_inm("modulos/misc.inc");
include_inm("modulos/document.class.inc");
include_inm("modulos/order.class.inc");
include_inm("modulos/ModuleAPI.inc");

include_inm("modulos/wherehouse.class.inc");
include_inm("modulos/deliverynote.class.inc");

session_start();

if(isset($logout)){
		  // $$APP_NAME = new wolSesion($APP_NAME,$APP_NAME);
		  $GLOBALS[$GLOBALS['APP_NAME']] = NULL;
		  unset($GLOBALS[$GLOBALS['APP_NAME']]);
}

inmersa_session_recover();

$oAlb = new DeliveryNote();

// Albaran de Venta:
// $oAlb->dbFill(array('id_albaran' => 23337));
// Albaran de Compra:
// $oAlb->dbFill(array('id_albaran' => 23327));
//

debug("Insertando datos en la instancia ...  ");
// $oAlb->update(array('id_pedido'=>46318));
$oAlb->factoryFromDocument(46337);

debug("\n<hr>Revisando datos .. ");

debug("Albaran: ");
$aD = $oAlb->getData();
print_r($aD);

debug("\nTransportista: ");
$aD = $oAlb->getData('Transportista');
print_r($aD);

debug("\nPedido: ");
$aD = $oAlb->getData('Pedido');
print_r($aD);

debug("\nEmpresa: ");
$aD = $oAlb->getData('Empresa');
print_r($aD);

debug("\nDireccion Entrega: ");
$aD = $oAlb->getData('Direccion');
print_r($aD);

debug("\nCliente: ");
$aD = $oAlb->getData('Cliente');
print_r($aD);

debug("\nProveedor: ");
$aD = $oAlb->getData('Proveedor');
print_r($aD);

debug("\nAlmacen: ");
$aD = $oAlb->getData('Almacen');
print_r($aD);

debug("\nProcediendo a modificar transportista al 6 .. ");
$oAlb->update(array('id_transportista' => 6));
debug("\nNUEVO Transportista: ");
$aD = $oAlb->getData('Transportista');
print_r($aD);
debug("\nCambio Albaran: ");
$aD = $oAlb->getData();
print_r($aD);
debug("\n Estado Modificado ? ".$oAlb->checkFlag($oAlb->ST_EDIT));
/** **
debug("\n <hr>");
debug("N Dets: ".$oAlb->countDetails());
for ($idx = $oAlb->firstDetail(); is_numeric($idx); $idx = $oAlb->nextDetail()) {
	debug("<hr>idx: $idx .. ");
	debug("Modificado?: ".$oAlb->checkDetailFlag($oAlb->ST_EDIT));

	debug("\nDetalle del albaran: ");
	$aData = $oAlb->getDetailData();
	print_r($aData);
	debug("\nDetalle del Pedido: ");
	$aData = $oAlb->getDetailData('DetallePedido');
	print_r($aData);
	debug("\nProducto: ");
	$aData = $oAlb->getDetailData('Producto');
	print_r($aData);
	debug("\nFamilia: ");
	$aData = $oAlb->getDetailData('Familia');
	print_r($aData);
	debug("\nMarca: ");
	$aData = $oAlb->getDetailData('Marca');
	print_r($aData);
}
/** **/

debug("<hr> Volcando bdd .. ");
// $oAlb->Dump();

$GLOBALS[$GLOBALS['APP_NAME']]->quit();

?>
