<?php

include("../escritorio/config.php");									/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");
// include("../escritorio/modulos/misc.inc");
include("../escritorio/modulos/enlace_crm.inc");
include("../escritorio/modulos/ModuleAPI.inc");
include("../escritorio/modulos/efectos.inc");
include("../escritorio/modulos/document.class.inc");
include("../escritorio/modulos/order.class.inc");
include("../escritorio/modulos/invoice.class.inc");
include("../escritorio/modulos/asiento.class.inc");

/** **/

/** **/
$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$DEBUG = "ON";

if (empty($sep)) $sep = "\t";
else if (!strcasecmp($sep,"\\\\t")) {
	$sep = "\t";
}

$oDbGestion = $Sesion->get_db('data');
$oDbcfg = $Sesion->get_db('conf');

$cons = "SELECT F.id_factura,F.id_serie ".
			"FROM Facturas F ".
			"WHERE F.id_serie = 11 OR F.id_serie = 6 ORDER BY F.fecha asc ";
$idrs = $oDbGestion->query($cons);
if (!$oDbGestion->num_rows($idrs)) {
	salida("No existen productos facturables.");
	exit;
}
debug("Renumerando ... ");
while ($aTmp = $oDbGestion->fetch_assoc($idrs)) {
	$oFra = new Invoice(NULL,'data',inmPed_COMPRA);
	$oFra->dbFill($aTmp['id_factura']);
	$oldref = $oFra->getReference();
	$oFra->setReference(NULL,true);
	debug($oldref." ahora es ".$oFra->getReference());
	$oFra->dbdump();
	$oFra = NULL;
}

?>
