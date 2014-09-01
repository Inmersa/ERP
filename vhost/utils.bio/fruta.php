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

$DEBUG="ON";

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$db = $Sesion->get_db('data');
$dbcfg = $Sesion->get_db('conf');

/** **
$cons = 'SELECT id_articulo FROM Articulos WHERE id_marca = 107';
$idrs = $db->query($cons);

if (!$db->num_rows($idrs)) {
	echo "No hay _ningun_ articulo de la marca 107";
	exit;
}

while ($aTmp = $db->fetch_row($idrs)) $strids .= ( (!empty($strids)) ? ' OR ' : '' ).' id_articulo = '.$aTmp[0];
$db->libera($idrs);
/** **/
	
$cons = 'UPDATE Articulos A JOIN Empresas_articulos EA ON (EA.id_articulo=A.id_articulo AND A.id_articulo) JOIN Compra_articulos Ca ON (A.id_articulo=Ca.id_articulo) '.
	'SET EA.precio_costo=Ca.precio, '.
	'EA.precio_standard=Ca.precio*1.335, '.
	'EA.precio_venta=Ca.precio*1.782, '.
	'EA.precio_4=Ca.precio*1.853, '.
	'EA.precio_5=Ca.precio*1.335, '.
	'EA.precio_6=Ca.precio*1.782 '.
	'WHERE A.id_marca = 107 AND Ca.id_proveedor = 77';
$db->query($cons);
echo "Hecho.";

?>
