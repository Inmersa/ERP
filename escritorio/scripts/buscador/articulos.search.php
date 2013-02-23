<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_empresa */
function fd_articulos(&$Sesion,&$oSearch){
   $nom_bus=$Sesion->fetchVar('nom_bus','POST');
   $nombre=$Sesion->fetchVar('nombre','POST');
   $nombre_marca=$Sesion->fetchVar('nombre_marca','POST');
   $nombre_grupo=$Sesion->fetchVar('nombre_grupo','POST');
   $id_empresa=$Sesion->fetchVar('id_empresa','POST');
   $recursos=$Sesion->fetchVar('recursos','POST GET SESSION');
	global $id;
	global $nid;

	$hp=$Sesion->fetchVar('hp','POST');
	$usuario = identifica_usuarios($Sesion);
	if (!strcasecmp($usuario['desktop_name'],'Clientes') AND (int)$usuario['referencias_propias'] ) {
		$Sesion->set_var('id_cli',$usuario['valor'],'SUBSECCION');
		$Sesion->set_var('id_empcli',$usuario['id'],'SUBSECCION');
	}

	if (!empty($nombre)){
		$st_nombre = $nombre;
	}
   if (empty($id_empresa)) $Sesion->set_var('id_empresa',$usuario['id']);
   if (!empty($id)) {
		$st_id = $id;
		if (!strcmp(preg_replace('/[a-z,A-Z]/i','',$id),$id)) {
			$nid = $id;
			$id = '';
			$Sesion->unset_var('id');
			$_GLOBAL['id'] = NULL;
			$_POST['id'] = NULL;
		}
   }

	if (!empty($nombre_marca)) {
		$Sesion->set_var('nombre_grupo',$nombre_marca,'SUBSECCION');
		$st_nombre_marca = $nombre_marca;
	}
	// debug("nombre_grupo = $nombre_grupo");

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

	$oSearch->add_where('Empresas_articulos.fecha_baja IS NULL','AND',FALSE);

	if (!empty($recursos)) {
		switch ($recursos) {
			case 'NOTNULL':
				$oSearch->set_distinct('Articulos.id_articulo');
				$oSearch->add_where('Articulos_recursos.id_articulo IS NOT NULL','AND',true);
				break;

			case 'NULL':
				$oSearch->add_where('Articulos_recursos.id_articulo IS NULL','AND',true);
				break;
		}
		$Sesion->set_var('recursos',$recursos,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}
?>
