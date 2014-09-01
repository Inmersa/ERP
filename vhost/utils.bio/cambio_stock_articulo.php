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

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$db = $Sesion->get_db('data');

global $antiguo;
global $nuevo;

if (!isset($antiguo) OR !isset($nuevo)) {
	salida("Debe indicar ID anterior e ID nuevo.<br/>\n");
	exit;
}

if (!is_array($antiguo)) $antiguo = array($antiguo);
if (!is_array($nuevo)) $nuevo = array($nuevo);

foreach ($antiguo as $idx => $clave) {
	if (!(int)$clave) {
		// salida("($clave) No es un id valido<br/>\n");
		continue;
	}
	$idrs = $db->query("SELECT id_articulo, nombre, descripcion FROM Articulos WHERE id_articulo = $clave");
	if (!$db->num_rows($idrs)) {
		salida("El id Articulo $clave no existe<br/>\n");
		continue;
	}
	$db->libera($idrs);

	$clave_new = $nuevo[$idx];
	if (!isset($clave_new)) {
		salida("($clave_new) No es un stock valido<br/>\n");
		continue;
	}

	$cons = "Update Empresas_articulos set stock_ficticio=$clave_new WHERE id_articulo=$clave";
	$db->query($cons);
	salida("El ID Articulo $clave ha pasado a tener un Stock de $clave_new<br/><br/>\n");
}


?>
