<?php
include_inm("scripts/buscador/botonera.php");
function fd_hacer_pedido(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $nombre_marca;
   global $nombre_grupo;
   global $id_empresa;
   global $id;
   global $nid;
   global $hp;

   $usuario = identifica_usuarios($Sesion);
	if (!strcasecmp($usuario['desktop_name'],'Clientes') AND (int)$usuario['referencias_propias'] ) {
		$Sesion->set_var('id_cli',$usuario['valor'],'SUBSECCION');
		$Sesion->set_var('id_empcli',$usuario['id'],'SUBSECCION');
	}

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }

   if (!empty($nombre_marca)) {
      $nombre_grupo = $nombre_marca;
      $st_nombre_marca = $nombre_marca;
   }

   // Almacenamos para los terminos de busqueda.
   $Sesion->set_var("_search_nombre_grupo",$nombre_grupo,"SUBSECCION");
   $Sesion->set_var("_search_nombre",$nombre,"SUBSECCION");
   $Sesion->set_var("_search_nombre_marca",$nombre_marca,"SUBSECCION");
   if (!empty($nombre)) {
      $st_nombre = $nombre;
   }
   if (!empty($id)) {
		if (!strcmp(preg_replace('/[a-z,A-Z]/i','',$id),$id)) {
			$nid = $id;
			$id = NULL;
			$Sesion->unset_var('id');
			$_GLOBAL['id'] = NULL;
			$_POST['id'] = NULL;
		}
		$st_id = $id;
   }
   $oSearch->add_where('Empresas_articulos.fecha_baja IS NULL');

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
