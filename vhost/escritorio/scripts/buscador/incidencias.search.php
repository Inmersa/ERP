<?php
include_inm("scripts/buscador/botonera.php");

function fd_incidencias(&$Sesion,&$Search) {
   global $nom_bus;
   global $nombre;
   global $fecha_inicio;
   global $fecha_fin;
   global $estado;
   global $id_usuario;
   global $id_tipo_incidencia;
   global $implicado;
	global $hp;
	$modosel = $Sesion->fetchVar('modo_seleccion','GET SESSION');
	
	$aUsr = identifica_usuarios($Sesion);
	$id_usuario_implicado = $Sesion->get_var('id_usuario_implicado');
	if (!is_numeric($id_usuario_implicado)) {
		$id_usuario_implicado = obtener_implicado_documento($Sesion);
		if (is_numeric($id_usuario_implicado)) {
			$Sesion->set_var('id_usuario_implicado',$id_usuario_implicado,'SUBSECCION');
		} else {
			$id_cl = id_entidad($Sesion,'id_cliente');
			if (is_numeric($id_cl)) {
				$id_usuario_implicado = obtener_implicado_cliente($Sesion,$id_cl);
			}
				
			// if (!(int)$modosel) $id_usuario_implicado = 0;
			$Sesion->set_var('id_usuario_implicado',(int)$id_usuario_implicado,'SUBSECCION');
			// debug("id cliente en $modosel .. $id_cl $id_usuario_implicado");
		}
	} 

	if (!$id_usuario_implicado AND $modosel AND 
			(!strcasecmp($aUsr['desktop_name'],'Empresas') OR !strcasecmp($aUsr['desktop_name'],'Coordinador'))
			 ) {
		// debug("Habilito busqueda de todas las incidencias... pero solo por ser tu. ");
		$Sesion->unset_var('id_usuario_implicado');
		$_GLOBAL['id_usuario_implicado'] = NULL;
	}

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) return NULL;
	$Search->set_db('crm');

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio=NULL;
		unset($fecha_inicio);
	} else {
		$st_fecha_inicio = $fecha_inicio;
	}

	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =NULL;
		unset($fecha_fin);
	} else {
		$st_fecha_fin = $fecha_fin;
	}

	// Por defecto, se muestran las abiertas.
	if (!$Sesion->bRecarga AND !is_numeric($estado)) $estado=1;

   //cerrado y gestionado por
	if ($estado == 1) {
		$st_estado = $estado;
		$estado = '-1 / 0 / 1 / 2 / 3';
		$fechacierre_fin = NULL;
		$Search->add_where('Incidencias.fecha_cierre IS NULL OR Incidencias.fecha_cierre = 0');
	} elseif ($estado == 2) {
		$estado = NULL;
		$st_estado = 2;
		$fechacierre_fin = Incidencia::getDate('now');
	} elseif (is_numeric($estado)) {
		$estado = 0;
		$st_estado = $estado;
	} else {
		$estado = NULL;
		$st_estado = NULL;
	}


   if ($id_tipo_incidencia == 0) {
		$id_tipo_incidencia = NULL;
      unset($id_tipo_incidencia);
   } else {
		$id_tipo_incidencia = (int)$id_tipo_incidencia;
		$st_id_tipo_incidencia = $id_tipo_incidencia;
	}


   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_implicado)) {
		$Sesion->set_var('st_implicado',$st_implicado,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_implicado');
	}
	if (!empty($st_fecha_fin)) {
		$Sesion->set_var('st_fecha_fin',$st_fecha_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_fin');
	}
	if (!empty($st_fecha_inicio)) {
		$Sesion->set_var('st_fecha_inicio',$st_fecha_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_inicio');
	}
	if (!empty($st_id_tipo_incidencia)) {
		$Sesion->set_var('st_id_tipo_incidencia',$st_id_tipo_incidencia,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_tipo_incidencia');
	}
	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (is_numeric($st_estado)) {
		$Sesion->set_var('st_estado',$st_estado,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_estado');
	}

	$Search->set_not_ruta_path(array('Empleados.id_departamento'));
	// $Search->useLeftJoin();

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}

}

function fd_crm_usuarios(&$Sesion,&$Search) {
	global $hp;

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) return NULL;
	$Search->set_db('crm');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}

	
}

function fd_crm_documentos(&$Sesion,&$Search) {
	global $texto;
	global $id_tipo_documento;
	global $id_agrupacion_documentos;

	global $hp;

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) return NULL;
	$Search->set_db('crm');

	$aUsr = identifica_usuarios($Sesion);
	switch ($aUsr['desktop_name']) {
		case 'Clientes':
			if (is_numeric($aUsr['crm_id_usuario'])) {
				$id_user = $aUsr['crm_id_usuario'];
				$Search->add_where('Documentos.id_usuario = '.$id_user,'OR');
				$Search->add_where('Documentos.publicado = 1 ','OR');
			}
			break;
	}

	if (is_numeric($id_tipo_documento)) {
		$aSt['id_tipo_documento'] = $id_tipo_documento;
	}
	if (is_numeric($id_agrupacion_documentos)) {
		$aSt['id_tipo_documento'] = $id_agrupacion_documentos;
	}
	if (!empty($texto)) {
		$aSt['texto'] = $texto;
	}

	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}

	
}

function fd_rfqs(&$Sesion,&$Search) {
   global $nombre;

   global $fecha_ini;
   global $fecha_fin;
   global $fechacierre_ini;
   global $fechacierre_fin;

   global $id_tipo_incidencia;
   global $id_implicado;
   global $gestor;

	global $estado;
	global $hp;

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	$oDb_crm = &$Sesion->get_db('crm');
	if (!is_object($oDb_crm)) return NULL;
	$Search->set_db('crm');

	$aSt = array();

	if ($estado == 1) {
		$estado = 1;
		$st_estado = $estado;
	} elseif ($estado == 2) {
		$estado = NULL;
		$st_estado = 2;
		$fechacierre_fin = CRMEvent::getDate('now');
	} elseif (is_numeric($estado)) {
		$estado = 0;
		$st_estado = $estado;
	} else {
		$estado = NULL;
		$st_estado = NULL;
	}
	$aSt['estado'] = $estado;

	if (is_numeric($solo_propias)) $aSt['solo_propias'] = $solo_propias;

	if (!empty($nombre)) $aSt['nombre'] = $nombre;
	if (!empty($gestor)) $aSt['gestor'] = $gestor;

   if (!isset($id_tipo_incidencia) OR empty($id_tipo_incidencia)) {
		$id_tipo_incidencia = NULL;
      unset($id_tipo_incidencia);
	} else {
		$id_tipo_incidencia = (int)$id_tipo_incidencia;
		$aSt['id_tipo_incidencia'] = $id_tipo_incidencia;
	}


   if (empty($fecha_ini) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_ini,FALSE)) ) {
      $fecha_ini=NULL;
		unset($fecha_ini);
	} else {
		$aSt['fecha_ini'] = $fecha_ini;
	}

   if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =NULL;
	} else {
		$aSt['fecha_fin'] = $fecha_fin;
	}

	$Search->add_select("DtoGestor.nombre as 'departamento_gestor'",FALSE);
	$Search->add_where("Empleados.id_departamento = DtoGestor.id_departamento ","AND",FALSE);
	$Search->_add_from("Departamentos","DtoGestor");

	$usuario = identifica_usuarios($Sesion);
	switch ($usuario['desktop_name']) {
		case 'Clientes':
			$id_implicado = $usuario['crm_id_usuario'];
			break;

		default:
			$id_implicado = $Sesion->get_var('id_usuario_implicado');
			if (!is_numeric($id_implicado)) {
				$id_implicado = obtener_implicado_cliente($Sesion);
				if (is_numeric($id_implicado)) $Sesion->set_var('id_usuario_implicado',$id_implicado,'SUBSECCION');
			}
			break;
	}

	$Search->set_not_ruta_path(array("RMAs",'Incidencias','Empleados.id_departamento'));

	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}
}

?>
