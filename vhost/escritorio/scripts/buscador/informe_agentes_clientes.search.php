<?php
include_inm("scripts/buscador/botonera.php");

function fd_informe_agentes_clientes(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_agente;
   global $id_agcli;
	global $fecha_inicio;
	global $fecha_fin;
	global $solopropios;
	global $hp;
  
	$id_agente=(int)$Sesion->get_var("id_agente_promocion");

	if ((int)$solopropios) {
		$st_solopropios = (int)$solopropios;
		$id_agcli = $id_agente;
	}

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

	$oSearch->add_select("SUM(Agentes_facturas.monto) as 'comision'",FALSE);
	$oSearch->add_select("COUNT(Agentes_facturas.id_factura) as 'num_facturas'",FALSE);
	$oSearch->add_select("SUM(Agentes_facturas.monto)/SUM(Facturas.base_imponible)*100 as 'comision_media'",FALSE);
	$oSearch->add_select(" SUM(IF(Facturas.factura_abono,(Facturas.base_imponible*-1), Facturas.base_imponible)) as 'total_facturas'",FALSE);
	$oSearch->add_select("SUM(IF(Facturas.factura_abono,(Efectos.monto_pagado*-1), Efectos.monto_pagado)) as 'monto_pagado'",FALSE);
	$oSearch->_add_from('Efectos');
	//$oSearch->add_where("Facturas.id_factura = Efectos.id_factura","AND");
	// $oSearch->useLeftJoin();
	$oSearch->groupby("Clientes.id_cliente");

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_solopropios)) {
		$Sesion->set_var('st_solopropios',$st_solopropios,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_solopropios');
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
