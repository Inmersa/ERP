<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.																								 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y							  **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre				**
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo	 **
**    hiciese.																																																												**
**																																																																																		  **
** Para mas informacion referente a la licencia de esta											 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	 **
**    Line Studios S.L. para recibir una copia del mismo											 **
**																																																																										  **
** Informacion de Contacto																																										  **
**    Josafat Moragrega Fernandez																																		 **
**    Engineering																																																								 **
**    Director Tecnico																																														 **
**    tite@wolstudios.com																																																					 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España														 **
**																																																																																		  **
**										  (c) Web On Line Studios S.L.																																	 **
**                                                              **
******************************************************************
*****************************************************************/


include("../escritorio/config.php");									/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");
include("../escritorio/modulos/misc.inc");
include("../escritorio/modulos/document.class.inc");
include("../escritorio/modulos/order.class.inc");
include("../escritorio/modulos/invoice.class.inc");
include("../escritorio/modulos/asiento.class.inc");

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$db = $Sesion->get_db('data');
$dbcfg = $Sesion->get_db('conf');

$cons = 'SELECT P.id_pedido FROM Pedidos P, Pedidos_facturas PF '.
			'WHERE P.id_pedido = PF.id_pedido AND P.preparado = 1 AND P.fecha > DATE_SUB(NOW(),INTERVAL 1 MONTH)';
// debug($cons);
$idrs = $db->query($cons);
$strids = NULL;

if ($db->num_rows($idrs)) while ($aTmp = $db->fetch_assoc($idrs)) $strids .= ( (!empty($strids)) ? ' AND ' : '' ).' id_pedido != '.$aTmp['id_pedido'];
$db->libera($idrs);

$consf = 'SELECT id_pedido,id_direccion,id_proveedor,referencia,fecha '.
			'FROM Pedidos WHERE preparado = 1 AND (id_proveedor=0 OR id_proveedor IS NULL) '.
			( (!empty($strids)) ? ' AND ( '.$strids.' ) ' : '' ).'AND fecha > DATE_SUB(NOW(),INTERVAL 1 MONTH) ORDER BY fecha desc ';
$idrs = $db->query($consf);
while ($aPed = $db->fetch_assoc($idrs)) {
	//print_r($aPed);
	if (empty($aPed['id_direccion'])) $bVenta = FALSE;
	else $bVenta = TRUE;
	if ($bVenta) { 
		$tipopedido = inmPed_VENTA;
	} else {
		$tipopedido = inmPed_COMPRA;
	}
		
	$oPedido = new Order ($Sesion->App_Name,'data',$tipopedido);
	$oPedido->dbfill($aPed['id_pedido']);

	$aTot =$oPedido->get_totals();
	if ($bVenta) {
		$aCli = $oPedido->get_reciever_info();
	} else {
		$aCli = $oPedido->get_issuer_info();
	}
	$aDir = $oPedido->get_reciever_address();
	$aDir = array_shift($aDir);

	salida('Facturando pedido '.( ($bVenta) ? ' de venta ' : ' de compra ').'(ID:'.$aPed['id_pedido'].') (REF:'.$aPed['referencia'].") <br>\n");
	salida('Fecha: '.$aPed['fecha']." <br>\n");
	if ($bVenta) salida('Cliente: '.$aCli['razon_social']." <br>\n");
	else salida('Proveedor : '.$aCli['razon_social']." <br>\n");
	salida('Direccion de Entrega ('.$aDir['nombre'].') : '.$aDir['direccion'].' '.$aDir['codigo_postal'].' '.$aDir['poblacion'].' '.$aDir['provincia']." <br>\n");
	salida('Base Imponible : '.$aTot['base_imponible']." <br>\n");
	salida('Total Impuestos : '.$aTot['total_impuestos']." <br>\n");
	salida('Importe Total : '.$aTot['importe']." <br>\n");

	$oFactura = new Invoice(NULL,'data',$tipopedido);
	$oFactura->fillFromOrder($oPedido);
	$oFactura->dbdump();

	salida("<br>\n");
	$oPedido = NULL;
	$oFactura = NULL;
}



?>
