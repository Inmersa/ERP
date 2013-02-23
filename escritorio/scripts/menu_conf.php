<?php
/* Fichero menu_conf.php */
// Precodigo del menu.
function pre_menu_conf(&$Sesion){
  // Variables globales que nos pasasn a traves de formularios
  global $id_sec; // Identificador de la seccion actual
  global $id_sub; // Identificador de la seccion actual

 // Conseguimos el nombre de la subseccion de la que venimos
 $nombre_subsecc = $Sesion->get_subsecc_name();
//debug("nombre subseccion $nombre_subsecc"); 
 if ($nombre_subsecc == "sec_conf"){
        // Venimos del listado de secciones
// debug ("Venimos de la subseccion sec_conf");
				$Sesion->set_var("mi_sec",$id_sec);
debug ("identificador $id_sec");				
 
 }
 if ($nombre_subsecc == "subsec_conf"){
 // Venimos del listado de subseciones
// debug ("Venimos de la subseccion subsec_conf");
				$Sesion->set_var("mi_subsec",$id_sub);
 }

}
