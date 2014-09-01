<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.		        				 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y 		 **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre 	 **
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo  **
**    hiciese.       														 **
**																					 **
** Para mas informacion referente a la licencia de esta 			 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On 	 **
**    Line Studios S.L. para recibir una copia del mismo			 **
**							        												 **
** Informacion de Contacto				        							 **
**    Josafat Moragrega Fernandez			        					 **
**    Engineering					        									 **
**    Director Tecnico 					        							 **
**    tite@wolstudios.com													 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España		        		 **
**																					 **
** 				(c) Web On Line Studios S.L. 							 **
**                                                              **
******************************************************************
*****************************************************************/

function include_inm($file) {
  return	include($file);
}

function file_inm($file) {
	return file($file);
}

/** **/
include("kernel_nocifrado.inc");
/** **
include("kernel/db.inc");                  //** Motores SQL **
include("kernel/sesiones.inc");            //** Modulo de Comunicaciones **
include("kernel/errores.inc");             //** Deteccion y Gestion de Errores **
include("kernel/misc.inc");                //** varios **
include("kernel/plantillas.inc");          //** Motor de Plantillas **
include("kernel/buscador.inc");            //** Modulo de Busquedas **
include("kernel/menus.inc");               //** Gestion de Menus **
//include("notifica.inc");                    //** Noticiaciones **
include("kernel/accesos.inc");             //** Jerarquia de Accesos *
/** **/

?>
