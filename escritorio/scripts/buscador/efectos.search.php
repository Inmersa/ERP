<?php
include_inm("scripts/buscador/botonera.php");

/** variables nombre , fecha_inicio , fecha_fin  , id_empresa , id_proveedor*/
function fd_efectos(&$Sesion,&$oSearch){
	global $id_emp;
  	global $fecha_inicio;
  	global $fecha_fin;
	global $medio_pago;
	global $nombre;
	global $id_cli;
	global $id_prov;
	global $id_ag;

	global $estado;
	global $emitido;
	global $devuelto;
	global $pagado;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
	$id_emp = (int)$usuario['id'];
	if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
		$id_ag = $usuario['valor'];
		$oSearch->set_not_ruta_path(array("Facturas.id_agente"));
	}

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio=NULL;
		unset($fecha_inicio);
	} else {
		$st_fecha_inicio = $fecha_inicio;
	}
	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin = NULL;
		unset($fecha_fin);
	} else {
		$st_fecha_fin = $fecha_fin;
	}

	if (is_numeric($id_ag)) $st_id_ag = $id_ag;
	else $st_id_ag = NULL;

	$medio_pago = trim($medio_pago);
	if (!isset($medio_pago) OR empty($medio_pago)) {
		$medio_pago = NULL;
		unset($medio_pago);
	} else $st_medio_pago = $medio_pago;

	$estado = (int)$estado;
	if (!$estado) {
		$estado = NULL;
		unset($estado);
	}
	switch($estado) {
		case 1: //Sin emitir
			$st_status = 1;
			$emitido = 0;
			break;

		case 2: // Pago parcial
			$oSearch->add_where("Efectos.monto > Efectos.monto_pagado AND Efectos.monto_pagado > 0","AND");
			$st_status = 2;
			$emitido = NULL;
			unset($emitido);
			break;

		case 3: //Abonado
			$pagado = 1;
			$devuelto = 0;
			$st_status = 3;
			break;

		case 4: //Devuelto
			$devuelto = 1;
			$pagado = 0;
			$st_status = 4;
			break;

		case 5: //No Abonados
			$pagado = 0;
			$emitido = NULL;
			unset($emitido);
			$st_status = 5;
			break;

		default:
			break;
	}

	if (!empty($nombre)) {
		$st_nombre = $nombre;
	} else {
		$nombre = NULL;
		unset($nombre);
	}

	// Almacenando las condiciones de Busqueda.
	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($st_id_cli)) {
		$Sesion->set_var('st_id_cli',$st_id_cli,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_cli');
	}
	if (!empty($st_id_prov)) {
		$Sesion->set_var('st_id_prov',$st_id_prov,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_prov');
	}
	if (!empty($st_id_ag)) {
		$Sesion->set_var('st_id_ag',$st_id_ag,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_ag');
	}
	if (!empty($st_status)) {
		$Sesion->set_var('st_estado',$st_status,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_estado');
	}
	if (!empty($st_fecha_inicio)) {
		$Sesion->set_var('st_fecha_inicio',$st_fecha_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_inicio');
	}
	if (!empty($st_fecha_fin)) {
		$Sesion->set_var('st_fecha_fin',$st_fecha_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_fin');
	}
	if (!empty($st_medio_pago)) {
		$Sesion->set_var('st_medio_pago',$st_medio_pago,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_medio_pago');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
