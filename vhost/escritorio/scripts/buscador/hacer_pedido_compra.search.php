<?php
include_inm("scripts/buscador/botonera.php");

function fd_hacer_pedido_compra(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $nombre_marca;
   global $nombre_grupo;
   global $id_empresa;
   global $id_proveedor_pedido;
   global $id;
   global $nid;
   global $hp;

   $usuario = identifica_usuarios($Sesion);

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }
   if (empty($id_proveedor_pedido)) {
      $id_proveedor_pedido =(int)$Sesion->get_var("id_proveedor_pedido");;
   }
   if (!empty($id)) {
		$st_id = $id;
		if (!strcmp(preg_replace('/[a-z,A-Z]/i','',$id),$id)) {
			$nid = $id;
			$id = NULL;
			$_GLOBAL['id'] = NULL;
			$_POST['id'] = NULL;
		}
   }

   $oSearch->add_select("ROUND(SUM(Localizacion_articulos.cantidad),2) as 'Localizacion_articulos.cantidad'","AND",false);
	$oSearch->_add_from('Localizacion_articulos');

   $oSearch->add_select("ROUND(Compra_articulos.precio,2) as 'Compra_articulos.precio'","AND");
   $oSearch->add_select('Divisa.leyenda as "Divisa.leyenda"',"AND",FALSE);

   // $oSearch->add_where('Divisa.id_divisa = Proveedores.id_divisa',"AND");
   $oSearch->add_where('Empresas_articulos.fecha_baja IS NULL');
   $oSearch->add_where('Compra_articulos.fecha_baja IS NULL');
	$oSearch->groupby('Articulos.id_articulo');
	$oSearch->useLeftJoin();

   // Almacenamos para los terminos de busqueda.
   $Sesion->set_var("_search_nombre_grupo",$nombre_grupo,"SUBSECCION");
   $Sesion->set_var("_search_nombre",$nombre,"SUBSECCION");
   $Sesion->set_var("_search_nombre_marca",$nombre_marca,"SUBSECCION");

   if (!empty($nombre)) {
      $st_nombre = $nombre;
   }

   if (!empty($st_nombre_marca)) {
      $Sesion->set_var('st_nombre_marca',$st_nombre_marca,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre_marca');
   }

   if (!empty($st_nombre)) {
      $Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_nombre');
   }
   if (!empty($st_id)) {
      $Sesion->set_var('st_id',$st_id,'SUBSECCION');
   } else {
      $Sesion->unset_var('st_id');
   }

   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }

}

?>
