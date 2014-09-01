<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_empresa */
function fd_composicion_articulos(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $es_materiaprima;
   global $hp;

   $usuario = identifica_usuarios($Sesion);

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }
   if (!empty($nombre)) {
      $st_nombre = $nombre;
   }
   $es_materiaprima = 1;

   if (!empty($st_nombre)) {
      $Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre');
   }

   $oSearch->add_where('Empresas_articulos.fecha_baja IS NULL','AND',FALSE);
   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }
}
?>
