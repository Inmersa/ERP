<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre  */
function fd_articulos_proveedor(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $hp;

   $usuario = identifica_usuarios($Sesion);

   if (empty($nombre)) {
      $st_nombre = $nombre;
   }
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }
	$id_proveedor = id_entidad($Sesion,'id_proveedor');

	$oSearch->useLeftJoin();
   $oSearch->set_distinct('Articulos.id_articulo');
   // $oSearch->add_where('Empresas_articulos.fecha_baja IS NULL');
	// $oSearch->add_where('Empresas_articulos.id_articulo = Articulos.id_articulo');
	// $oSearch->orderby('Compra_articulos.fecha_baja desc, Articulos.nombre asc');
	if (is_numeric($id_proveedor)) {
   	$oSearch->add_where(' IF(Compra_articulos.id_proveedor,(Compra_articulos.fecha_baja IS NOT NULL AND Compra_articulos.id_proveedor = '.$id_proveedor.
						') OR Compra_articulos.id_proveedor != '.$id_proveedor.',(Empresas_articulos.fecha_baja IS NULL AND Empresas_articulos.id_articulo IS NOT NULL))');
	}

   if (!empty($st_nombre)) {
      $Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre');
   }

   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }

}

?>
