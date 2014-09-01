<?php
include_inm("scripts/buscador/botonera.php");
function fd_importar_articulos_seleccion(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $hp;
   global $idarticulo;

   $usuario = identifica_usuarios($Sesion);
  
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }

   if (!empty($nombre)) {
      $st_nombre = $nombre;
   }

   if (!empty($idarticulo)) {
      $st_idarticulo = $idarticulo;
   } else {
      $idarticulo = NULL;
      unset($idarticulo);
   }

   if (!empty($st_nombre)) {
      $Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre');
   }
   if (!empty($st_idarticulo)) {
      $Sesion->set_var('st_idarticulo',$st_idarticulo,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_idarticulo');
   }

   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }
}
?>
