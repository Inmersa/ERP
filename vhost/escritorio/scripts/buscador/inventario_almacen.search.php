<?php
include_inm("scripts/buscador/botonera.php");

function fd_localizacion_articulos(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $cantidad_inicio;
   global $cantidad_fin;
   global $id_empresa;
   global $id_art;
   global $id_alml;
   global $excluir_bajas;
   global $cod_barras;
   global $fecha;
   global $fecha_inicio;
   global $fecha_fin;
   global $hp;

   $usuario = identifica_usuarios($Sesion);
   $id_almacen_logico_sesion = $Sesion->get_var("id_almacen_logico_promocion");

	$aSt = array();
   if (empty($id_empresa)) $id_empresa =(int)$usuario['id'];

	if (!$Sesion->bRecarga) {
		$id_tmp = $Sesion->fetchVar('id_articulo','GET POST SESSION');
		if (is_numeric($id_tmp)) $id_art = $id_tmp;
	}

   if (empty($id_alml) AND !$Sesion->bRecarga) {
      $id_almacen_logico =(int)$id_almacen_logico_sesion;
   } else $id_almacen_logico = $id_alml;

	if (is_numeric($id_almacen_logico)) {
		$Sesion->set_var('id_almacen_logico_promocion',$id_almacen_logico,'SECCION');
		$Sesion->set_var('id_almacen_logico',$id_almacen_logico,'SECCION');
		$aSt['id_alml'] = $id_almacen_logico;
	}

	if (is_numeric($excluir_bajas)) {
		$aSt['excluir_bajas'] = $excluir_bajas;
		$oSearch->add_where('Empresas_articulos.fecha_baja IS NULL','AND');
	}

	if (!empty($cod_barras)) {
		$aSt['cod_barras'] = $cod_barras;
	}

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,false)) ) {
		$fecha_inicio = NULL;
		unset($fecha_inicio);
	} else $aSt['fecha_inicio'] = $fecha_inicio;

	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,false)) ) {
		$fecha_fin = NULL;
		unset($fecha_fin);
	} else $aSt['fecha_fin'] = $fecha_fin;

	if ($fecha_inicio AND $fecha_fin AND wol_db::formatear_fecha($fecha_inicio,false) == wol_db::formatear_fecha($fecha_fin,false) ) {
		$fecha = $fecha_inicio;
		$fecha_inicio = $fecha_fin = NULL;
		unset($fecha_inicio);
		unset($fecha_fin);
      $aSt['fecha'] = $fecha;
	} else {
      $fecha=NULL;
      unset($fecha);
   }

   if (!empty($cantidad_inicio)) {
      $aSt['cantidad_inicio'] = $cantidad_inicio;
   }
   if (!empty($cantidad_fin)) {
      $aSt['cantidad_fin'] = $cantidad_fin;
   }
   if (!empty($nombre)) {
      $aSt['nombre'] = $nombre;
   }
   if (!empty($id_art)) {
      $aSt['id_art'] = $id_art;
   }

	$Sesion->set_var('st',$aSt,'SUBSECCION');

   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }

}

function fd_inventario_almacen(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $cantidad_inicio;
   global $cantidad_fin;
   global $excluir_bajas;
   global $id_empresa;
   global $id_almacen;
   global $fecha;
   global $fecha_inicio;
   global $fecha_fin;
   global $cod_barras;
   global $id_alml;
   global $id_art;
   global $precio;
   global $hp;

   $usuario = identifica_usuarios($Sesion);
   $id_almacen_sesion = $Sesion->fetchVar("id_almacen_promocion",'GET POST SESSION');
   if (!is_numeric($id_almacen_sesion)) $id_almacen_sesion = $Sesion->fetchVar("id_almacen",'GET POST SESSION');


   if (empty($id_almacen)) {
      $id_almacen =(int)$id_almacen_sesion;
   }
   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }

	$agrupacion = 'Localizacion_articulos.id_almacen_logico';
	$orden = 'Almacenes_logicos.nombre';
   $id_almacen_logico_sesion = $Sesion->get_var("id_almacen_logico_promocion");
   if (empty($id_alml) AND !$Sesion->bRecarga) {
      $id_almacen_logico =(int)$id_almacen_logico_sesion;
   } elseif ($id_alml > 0) $id_almacen_logico = $id_alml;
	else {
		if ($id_alml < 0) {
			$id_almacen_logico = NULL;
			$aSt['id_alml'] = -1;
			$id_alml = NULL;
			$_POST['id_alml'] = NULL;
			$agrupacion = NULL;
			$orden = NULL;
		}
	}

	if (is_numeric($id_almacen_logico)) {
		$Sesion->set_var('id_almacen_logico_promocion',$id_almacen_logico,'SECCION');
		$Sesion->set_var('id_almacen_logico',$id_almacen_logico,'SECCION');
		$aSt['id_alml'] = $id_almacen_logico;
		$agrupacion = 'Localizacion_articulos.id_almacen_logico';
	}

	if (is_numeric($excluir_bajas)) {
		$aSt['excluir_bajas'] = $excluir_bajas;
		$oSearch->add_where('Empresas_articulos.fecha_baja IS NULL','AND');
	}

	if (!empty($precio)) {
		$oSearch->add_select("SUM(Localizacion_articulos.cantidad) * Empresas_articulos.$precio as 'valor'");
		$aSt['precio'] = $precio;
	}

	if (!empty($cod_barras)) {
		$aSt['cod_barras'] = $cod_barras;
	}

   if (!empty($id_art)) {
      $aSt['id_art'] = $id_art;
   }

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,false)) ) {
		$fecha_inicio = NULL;
		unset($fecha_inicio);
	} else $aSt['fecha_inicio'] = $fecha_inicio;

	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,false)) ) {
		$fecha_fin = NULL;
		unset($fecha_fin);
	} else $aSt['fecha_fin'] = $fecha_fin;

	if ($fecha_inicio AND $fecha_fin AND wol_db::formatear_fecha($fecha_inicio,false) == wol_db::formatear_fecha($fecha_fin,false) ) {
		$fecha = $fecha_inicio;
		$fecha_inicio = $fecha_fin = NULL;
		unset($fecha_inicio);
		unset($fecha_fin);
      $aSt['fecha'] = $fecha;
	} else {
      $fecha=NULL;
      unset($fecha);
   }

   if (!empty($cantidad_inicio)) {
      $aSt['cantidad_inicio'] = $cantidad_inicio;
   }
   if (!empty($cantidad_fin)) {
      $aSt['cantidad_fin'] = $cantidad_fin;
   }
   if (!empty($nombre)) {
      $aSt['nombre'] = $nombre;
   }

	 // debug("anyadimos una select");
   $oSearch->add_select("SUM(Localizacion_articulos.cantidad) as 'cantidad'");
   $oSearch->add_select("MIN(Localizacion_articulos.fecha_caducidad) as 'caducidad'");
   $oSearch->add_select("MAX(Localizacion_articulos.fecha_caducidad) as 'caducidad_mayor'");
//	 debug("anyadimos el group by");
   $oSearch->groupby($agrupacion.( (!empty($agrupacion)) ? ', ' : '' )."Localizacion_articulos.id_articulo");
	if (!empty($orden)) $oSearch->orderby($orden.( (!empty($orden)) ? ', ' : '').'Marcas.nombre, Articulos.nombre');

	$Sesion->set_var('st',$aSt,'SUBSECCION');

   if (!empty($hp) AND is_numeric($hp)) {
      $Sesion->set_var('st_hp',$hp,'SUBSECCION');
      $oSearch->set_hits_page($hp);
   } else {
      $Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
   }

}

?>
