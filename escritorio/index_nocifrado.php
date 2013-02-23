<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.																			 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y					 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre	  **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.																																							**
**																																																								 **
** Para mas informacion referente a la licencia de esta									**
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	  **
**    Line Studios S.L. para recibir una copia del mismo									**
**																																																					  **
** Informacion de Contacto																																 **
**    Josafat Moragrega Fernandez																								**
**    Engineering																																								  **
**    Director Tecnico																																	 **
**    tite@wolstudios.com																																			**
**    C/Alcala 18 3º Izda, 28014 Madrid, España												**
**																																																								 **
**										  (c) Web On Line Studios S.L.																	  **
**                                                              **
******************************************************************
*****************************************************************/

include("config.php");									/**	  StartUp Config **/
include("kernel_nocifrado.php");

include_inm("modulos/ModuleAPI.inc");

include_inm("modulos/misc.inc");
include_inm("modulos/document.class.inc");
include_inm("modulos/budget.class.inc");
include_inm("modulos/order.class.inc");
include_inm("modulos/invoice.class.inc");
include_inm("modulos/document.iface.inc");
include_inm("modulos/CRMDoc.inc");
include_inm("modulos/enlace_crm.inc");
include_inm("modulos/incidencias.inc");
include_inm("modulos/asiento.class.inc");
include_inm("modulos/efectos.inc");
include_inm("modulos/notificaciones.inc");
include_inm("modulos/periodificacion.inc");
include_inm("modulos/unidadesmedida.class.inc");

include_inm("modulos/module_list.inc");

session_start();

if(isset($logout)){
		  $$APP_NAME = NULL;
		  unset($$APP_NAME);
}

inmersa_session_recover();

$GLOBALS[$GLOBALS['APP_NAME']]->init($seccion);

$GLOBALS[$GLOBALS['APP_NAME']]->cerrar();

?>
