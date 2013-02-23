<?php
include_inm("scripts/buscador/botonera.php");

function fd_presupuestos_ventas(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $fecha_inicio;
   global $fecha_fin;
   global $id_empresa;
   global $id_prov;
	global $hp;

	global $proforma;
	global $id_cli;
   global $id_ag;

	$usuario = identifica_usuarios($Sesion);
	switch ($usuario['desktop_name']) {
		case 'Clientes' :
			$id_cli = $usuario['valor'];
			break;

		case 'Agentes' :
			$id_ag = $usuario['valor'];
			$oSearch->set_not_ruta_path(array("Presupuestos.id_agente"));
			break;
	}

	$ss = $Sesion->get_subsecc_name();
	if (!strcasecmp($ss,'bo_proformas_venta') ) {
		$proforma = 1;
	} else $proforma = 0;
		

	if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
      $fecha_inicio=NULL;
		unset($fecha_inicio);
	} else {
		$st_fecha_inicio = $fecha_inicio;
		$fecha_inicio = descolocar_fecha($fecha_inicio);
	}
	if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
      $fecha_fin =NULL;
		unset($fecha_fin);
	} else {
		$st_fecha_fin=$fecha_fin;
		$fecha_fin = descolocar_fecha($fecha_fin);
	}

   $id_prov =0;

   if (empty($id_empresa)) {
      $id_empresa =(int) $usuario['id'];
	}
   if (!empty($nombre)) {
      $st_nombre = $nombre;
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
