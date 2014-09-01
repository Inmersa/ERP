<?php
include_inm("scripts/buscador/botonera.php");

function fd_ventas_detallado(&$Sesion,&$oSearch) {
	global $hp;
	global $ag_search;
	global $ag_id;
	global $ag_nombre;
	global $ag_tipo;
	global $id_empresa;

	global $cl_id;
	global $cl_nombre;
	global $cl_tipo;
	global $fr_ref;
	global $fr_ref_ext;
	global $fr_serie;
	global $fr_fecha_inicio;
	global $fr_fecha_fin;
	global $fr_basei;

	global $ef_search;
	global $ic_search;

	global $totales;

	$aSt = array();
	$id_empresa = $Sesion->get_var('id_empresa');

	if (!(int)$ag_search) {
		if (!empty($ag_id) OR !empty($ag_nombre) OR !empty($ag_tipo)) $ag_search = 1;
	}
	if (!(int)$ef_search) {
		if (!empty($ef_id) OR !empty($ef_nombre) OR !empty($ef_tipo)) $ef_search = 1;
	}
	if ((int)$ag_search) {
		if (!empty($ag_nombre)) {
			$aSt['ag_nombre'] = $ag_nombre;
		}
		if (!empty($ag_id)) {
			$aSt['ag_id'] = $ag_id;
		}
		if (!empty($ag_tipo)) {
			$aSt['ag_tipo'] = $ag_tipo;
		}
		$aSt['ag_search'] = 1;
		// debug("Por agente ... mejor con ");
		$oSearch->add_select('Agentes.nombre as "Agentes.nombre"',FALSE);
		$oSearch->add_select('Agentes.id_agente as "Agentes.id_agente"',FALSE);
		$oSearch->add_select('Agentes.apellidos as "Agentes.apellidos"',FALSE);
		$oSearch->_add_from('Agentes');
		$oSearch->_add_from('Agentes_facturas');
		$oSearch->add_where('Agentes_facturas.id_factura = Facturas.id_factura AND Agentes.id_agente = Agentes_facturas.id_agente','AND',FALSE);
		$oSearch->orderby('Agentes.nombre, Clientes.razon_social, Facturas.fecha desc');

		// debug("Metiendo agentes-facturas ..");
		// $oSearch->set_ruta_path(array('Agentes_facturas'));
		// $oSearch->set_not_ruta_path(array('Agentes_clientes'));
		// $oSearch->set_not_ruta_path(array('Presupuestos'));
	} else {
		$oSearch->orderby('Clientes.razon_social, Facturas.fecha desc');
		$aSt['ag_search'] = 0;
	}

	if ((int)$ef_search) {
		$aSt['ef_search'] = 1;
		$oSearch->add_select('SUM(Efectos.monto_pagado) as "Efectos.monto_pagado"');
		$oSearch->add_select('SUM(Efectos.monto) as "Efectos.monto"');
		$oSearch->add_where('Efectos.id_factura = Facturas.id_factura');
	} else $aSt['ef_search'] = 0;

	if ((int)$ic_search) {
		$aSt['ic_search'] = 1;
		$oSearch->add_select('COUNT(Facturas_Incidencias_CRM.id_incidencia) as "numero_incidencias"');
		$oSearch->add_where('Facturas.id_factura = Facturas_Incidencias_CRM.id_factura');
	} else $aSt['ic_search'] = 0;

	$oSearch->groupby('Facturas.id_factura');

	// Preparamos los vectores para los calculos de Totales.
	$aTotalizar = array();
	if (is_array($totales)) {
		foreach ($totales as $grp_fld => $aTot) {
			if (!is_array($aTot)) continue;
			// debug("De $grp_fld");
			if (!is_array($aTotalizar[$grp_fld])) $aTotalizar[$grp_fld] = array();
			foreach ($aTot as $name => $aFld) {
				if (empty($aFld['field'])) continue;
				$field_name = $aFld['field'];
				$aFld['field'] = NULL;
				unset($aFld['field']);
				$round_to = $aFld['round'];
				$aFld['round'] = NULL;
				unset($aFld['round']);
				$opt_erase = $aFld['erase_without'];
				if (!empty($opt_erase)) {
					$aFld['erase_without'] = NULL;
					unset($aFld['erase_without']);
					if (!(int)$$opt_erase) {
						continue;
					}
				}

				if (!is_array($aFld)) continue;
				// debug("para $name : $opt_erase ");

				foreach ($aFld as $nombre => $funcion) {
					// debug("$nombre es $funcion");
					$aTmp = array('field' => $field_name,'fnc' => $funcion, 'name' => $nombre.' ('.$name.')');
					if (is_numeric($round_to)) $aTmp['round'] = $round_to;
					array_push($aTotalizar[$grp_fld],$aTmp);
					$aTmp = NULL;
				}
			}
		}
		// debug("totales");
		// print_r($aTotalizar);
		$Sesion->set_var('TotalesInforme',$aTotalizar);
	} else $Sesion->unset_var('Totales_informe');

	// Variables _base_
	if (!empty($cl_id)) {
		$aSt['cl_id'] = $cl_id;
	}
	if (!empty($cl_nombre)) {
		$aSt['cl_nombre'] = $cl_nombre;
	}
	if (is_numeric($cl_tipo)) {
		$aSt['cl_tipo'] = $cl_tipo;
	}
	if (!empty($fr_ref)) {
		$aSt['fr_ref'] = $fr_ref;
	}
	if (!empty($fr_ref_ext)) {
		$aSt['fr_ref_ext'] = $fr_ref_ext;
	}
	if (is_numeric($fr_serie)) {
		$aSt['fr_serie'] = $fr_serie;
	} else $fr_serie = NULL;
	if (!empty($fr_fecha_inicio) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_inicio,FALSE)) ) {
		$aSt['fr_fecha_inicio'] = $fr_fecha_inicio;
	} else $fr_fecha_inicio = NULL;
	if (!empty($fr_fecha_fin) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_fin,FALSE)) ) {
		$aSt['fr_fecha_fin'] = $fr_fecha_fin;
	} else $fr_fecha_fin = NULL;
	if (is_numeric($fr_basei)) {
		$aSt['fr_basei'] = $fr_basei;
	} else $fr_basei=NULL;


	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

function fd_producto_detallado(&$Sesion,&$oSearch) {
	global $hp;
	global $id_proveedor;
	global $id_empresa;

	global $mc_search;
	global $mc_id;
	global $mc_nombre;

	global $fm_search;
	global $fm_id;
	global $fm_nombre;

	global $ar_nombre;
	global $ar_id;

	global $fr_ref;
	global $fr_ref_ext;
	global $fr_serie;
	global $fr_fecha_inicio;
	global $fr_fecha_fin;
	global $fr_basei;

	global $ag_search;
	global $ag_id;
	global $ag_nombre;
	global $ag_tipo;

	global $cl_search;
	global $cl_id;
	global $cl_nombre;
	global $cl_tipo;

	global $totales;
	global $orden;

	$id_proveedor = 0;
	$id_empresa = $Sesion->get_var('id_empresa');
	if (!(int)$mc_search) {
		if (!empty($mc_id) OR !empty($mc_nombre)) $mc_search = 1;
	}
	if (!(int)$fm_search) {
		if (!empty($fm_id) OR !empty($fm_nombre)) $fm_search = 1;
	}
	if (!(int)$cl_search) {
		if (!empty($cl_id) OR !empty($cl_nombre) OR !empty($cl_tipo)) $cl_search = 1;
	}
	$aRutaPath = array();
	$aNotRutaPath = array();

	if ((int)$mc_search) {
		if (!empty($mc_nombre)) {
			$aSt['mc_nombre'] = $mc_nombre;
		}
		if (!empty($mc_id)) {
			$aSt['mc_id'] = $mc_id;
		}
		$aSt['mc_search'] = 1;
		$oSearch->add_select('Marcas.nombre as "Marcas.nombre"',TRUE);
		$oSearch->add_select('Marcas.id_marca as "Marcas.id_marca"',FALSE);
		// $oSearch->add_where('Marcas.id_marca = Articulos.id_marca','AND',FALSE);
		$orderby .= ((!empty($orderby)) ? ', ' : '').'Marcas.nombre';
	} else $aSt['mc_search'] = 0;

	if ((int)$fm_search) {
		if (!empty($fm_nombre)) {
			$aSt['fm_nombre'] = $fm_nombre;
		}
		if (!empty($fm_id)) {
			$aSt['fm_id'] = $fm_id;
		}
		$aSt['fm_search'] = 1;
		$oSearch->add_select('Familia_articulos.nombre as "Familia_articulos.nombre"',TRUE);
		$oSearch->add_select('Familia_articulos.id_familia as "Familia_articulos.id_familia"',FALSE);
		// $oSearch->add_where('Familia_articulos.id_familia = Articulos.id_familia','AND',FALSE);
		$orderby .= ((!empty($orderby)) ? ', ' : '').'Familia_articulos.nombre';
	} else $aSt['fm_search'] = 0;

	// Agentes
	if ((int)$ag_search) {
		if (!empty($ag_nombre)) {
			$aSt['ag_nombre'] = $ag_nombre;
		}
		if (!empty($ag_id)) {
			$aSt['ag_id'] = $ag_id;
		}
		if (is_numeric($ag_tipo)) {
			$aSt['ag_tipo'] = $ag_tipo;
		}
		$aSt['ag_search'] = 1;
		$oSearch->add_select('Agentes.id_agente as "Agentes.id_agente"',TRUE);
		$oSearch->add_select('Agentes.nombre as "Agentes.nombre"',FALSE);
		$oSearch->add_select('Agentes.apellidos as "Agentes.apellidos"',FALSE);
		// $oSearch->add_where('Agentes.id_agente = Agentes_facturas.id_agente AND Agentes_facturas.id_factura = Facturas.id_factura','AND',FALSE);

		array_push($aRutaPath,'Agentes_facturas');
		array_push($aNotRutaPath,'Agentes_cliente');

		$groupby .= ((!empty($groupby)) ? ', ' : '').'Agentes.id_agente';
		$orderby .= ((!empty($orderby)) ? ', ' : '').'Agentes.nombre';
	} else $aSt['ag_search'] = 0;

	// Clientes
	if ((int)$cl_search) {
		if (!empty($cl_nombre)) {
			$aSt['cl_nombre'] = $cl_nombre;
		}
		if (!empty($cl_id)) {
			$aSt['cl_id'] = $cl_id;
		}
		if (is_numeric($cl_tipo)) {
			$aSt['cl_tipo'] = $cl_tipo;
		}
		$aSt['cl_search'] = 1;
		/** **
		$oSearch->add_select('Clientes.id_cliente as "Clientes.id_cliente"',TRUE);
		$oSearch->add_select('Clientes.razon_social as "Clientes.razon_social"',FALSE);
		$oSearch->add_select('Clientes.nombre as "Clientes.nombre"',FALSE);
		$oSearch->add_select('Clientes.apellidos as "Clientes.apellidos"',FALSE);
		$oSearch->add_select('Clientes.cif as "Clientes.cif"',FALSE);
		$oSearch->add_select('Clientes.prefijo_cif as "Clientes.prefijo_cif"',FALSE);
		$oSearch->add_select('Clientes.direccion_facturacion as "Clientes.direccion_facturacion"',FALSE);
		$oSearch->add_select('Clientes.cp as "Clientes.cp"',FALSE);
		$oSearch->add_select('Clientes.poblacion as "Clientes.poblacion"',FALSE);

		$oSearch->add_select('Provincias.nombre as "Clientes.provincia"',FALSE);
		$oSearch->add_where('Clientes.id_provincia=Provincias.id_provincia','AND',FALSE);
		$oSearch->_add_from('Provincias','Provincias');
		// $oSearch->_add_from('Clientes');
		// $oSearch->_add_from('Clientes_empresas');
				// 'Clientes_empresas.id_cliente = Clientes.id_cliente AND Clientes.id_cliente = Facturas.id_cliente '.
		/** **/
		$groupby .= ((!empty($groupby)) ? ', ' : '').'Clientes.id_cliente';
		$orderby .= ((!empty($orderby)) ? ', ' : '').'Clientes.razon_social';
	} else $aSt['cl_search'] = 0;

	// Articulos
	if (!empty($ar_nombre)) {
		$aSt['ar_nombre'] = $ar_nombre;
	}
	if (!empty($ar_id)) {
		$aSt['ar_id'] = $ar_id;
	}

	$oSearch->add_select('ROUND(SUM(Lineas_detalle.cantidad),2) as "cantidad_pedida"',FALSE);
	$oSearch->add_select('ROUND(SUM(IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)),2) as "cantidad_facturada"',FALSE);
	$oSearch->add_select('ROUND(SUM(Lineas_detalle.cantidad_recibida),2) as "cantidad_recibida"',FALSE);
	$oSearch->add_select('ROUND(AVG(Lineas_detalle.precio_articulo),2) as "precio_medio"',FALSE);
	$oSearch->add_select('ROUND(MIN(Lineas_detalle.precio_articulo),2) as "precio_minimo"',FALSE);
	$oSearch->add_select('ROUND(MAX(Lineas_detalle.precio_articulo),2) as "precio_maximo"',FALSE);
	$oSearch->_add_from('Lineas_detalle');
	$oSearch->_add_from('Facturas_detalle');
	$oSearch->_add_from('Facturas');
	// $oSearch->add_where('Lineas_detalle.id_detalle = Facturas_detalle.id_detalle '.
								// 'AND Facturas_detalle.id_factura = Facturas.id_factura AND Lineas_detalle.id_articulo = Articulos.id_articulo','AND',FALSE);
	// $oSearch->useLeftJoin();

	// array_push($aRutaPath,'Lineas_detalle');
	// array_push($aRutaPath,'Facturas_detalle');

	// array_push($aNotRutaPath,'Empresas_articulos');

	if (sizeof($aRutaPath)) $oSearch->set_ruta_path($aRutaPath);
	if (sizeof($aNotRutaPath)) $oSearch->set_not_ruta_path($aNotRutaPath);
	// $oSearch->useLeftJoin();

	// debug("ruta: ");
	// print_r($aRutaPath);
	// debug("no-ruta: ");
	// print_r($aNotRutaPath);
	// $oSearch->set_not_ruta_path(array('Agentes_clientes','Empresas','Cliente_articulos'));

	$groupby .= ((!empty($groupby)) ? ', ' : '').'Articulos.id_articulo';

	if (!empty($groupby)) $oSearch->groupby($groupby);

	// Preparamos los vectores para los calculos de Totales.
	$aTotalizar = array();
	if (is_array($totales)) {
		foreach ($totales as $grp_fld => $aTot) {
			if (!is_array($aTot)) continue;
			// debug("De $grp_fld");
			if (!is_array($aTotalizar[$grp_fld])) $aTotalizar[$grp_fld] = array();
			foreach ($aTot as $name => $aFld) {
				if (empty($aFld['field'])) continue;
				$field_name = $aFld['field'];
				$aFld['field'] = NULL;
				unset($aFld['field']);
				$round_to = $aFld['round'];
				$aFld['round'] = NULL;
				unset($aFld['round']);
				$opt_erase = $aFld['erase_without'];
				if (!empty($opt_erase)) {
					$aFld['erase_without'] = NULL;
					unset($aFld['erase_without']);
					if (!(int)$$opt_erase) {
						continue;
					}
				}

				if (!is_array($aFld)) continue;
				// debug("para $name : $opt_erase ");

				foreach ($aFld as $nombre => $funcion) {
					// debug("$nombre es $funcion");
					$aTmp = array('field' => $field_name,'fnc' => $funcion, 'name' => $nombre.' ('.$name.')');
					if (is_numeric($round_to)) $aTmp['round'] = $round_to;
					array_push($aTotalizar[$grp_fld],$aTmp);
					$aTmp = NULL;
				}
			}
		}
		// debug("totales");
		// print_r($aTotalizar);
		$Sesion->set_var('TotalesInforme',$aTotalizar);
	} else $Sesion->unset_var('Totales_informe');

	$aOrden = array();
	$orden_sesion = array();
	if (is_array($orden) AND sizeof($orden)) {
		foreach ($orden as $campo => $aOrd) {
			if (!(int)$aOrd['accion']) continue;
			$aOrden[$aOrd['posicion']] = $aOrd['field'].' '.$aOrd['direccion'];
			$orden_sesion[$campo] = $aOrd['direccion'];
			$orden_sesion[$campo.'_posicion'] = $aOrd['posicion'];
		}
		$Sesion->unset_var('orden');
		if (is_array($orden_sesion) AND sizeof($orden_sesion)) {
			$Sesion->set_var('orden',$orden_sesion,'SUBSECCION');
		} 
	}

	if (is_array($aOrden) AND sizeof($aOrden)) {
		sort($aOrden);
		foreach ($aOrden as $campo)
			$orderby .= ((!empty($orderby)) ? ', ' : '').$campo;
	}


	if (!empty($orderby)) $oSearch->orderby($orderby);

	// Facturas
	if (!empty($fr_ref)) {
		$aSt['fr_ref'] = $fr_ref;
	}
	if (!empty($fr_ref_ext)) {
		$aSt['fr_ref_ext'] = $fr_ref_ext;
	}
	if (is_numeric($fr_serie)) {
		$aSt['fr_serie'] = $fr_serie;
	} else $fr_serie = NULL;
	if (!empty($fr_fecha_inicio) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_inicio,FALSE)) ) {
		$aSt['fr_fecha_inicio'] = $fr_fecha_inicio;
	} else $fr_fecha_inicio = NULL;
	if (!empty($fr_fecha_fin) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_fin,FALSE)) ) {
		$aSt['fr_fecha_fin'] = $fr_fecha_fin;
	} else $fr_fecha_fin = NULL;
	if (is_numeric($fr_basei)) {
		$aSt['fr_basei'] = $fr_basei;
	} else $fr_basei=NULL;


	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

function fd_compras_detallado(&$Sesion,&$oSearch) {
	global $hp;
	global $id_empresa;

	global $pr_id;
	global $pr_nombre;

	global $fr_ref;
	global $fr_ref_ext;
	global $fr_serie;
	global $fr_fecha_inicio;
	global $fr_fecha_fin;
	global $fr_basei;

	global $ef_search;
	global $ic_search;

	global $totales;

	$aSt = array();
	$id_empresa = $Sesion->get_var('id_empresa');

	if (!(int)$ef_search) {
		if (!empty($ef_id) OR !empty($ef_nombre) OR !empty($ef_tipo)) $ef_search = 1;
	}

	if ((int)$ef_search) {
		$aSt['ef_search'] = 1;
		$oSearch->add_select('SUM(Efectos.monto_pagado) as "Efectos.monto_pagado"');
		$oSearch->add_select('SUM(Efectos.monto) as "Efectos.monto"');
		$oSearch->add_where('Efectos.id_factura = Facturas.id_factura');
	} else $aSt['ef_search'] = 0;

	if ((int)$ic_search) {
		$aSt['ic_search'] = 1;
		$oSearch->add_select('COUNT(Facturas_Incidencias_CRM.id_incidencia) as "numero_incidencias"');
		$oSearch->add_where('Facturas.id_factura = Facturas_Incidencias_CRM.id_factura');
	} else $aSt['ic_search'] = 0;

	$oSearch->orderby('Proveedores.nombre');
	$oSearch->groupby('Facturas.id_factura');

	// Preparamos los vectores para los calculos de Totales.
	$aTotalizar = array();
	if (is_array($totales)) {
		foreach ($totales as $grp_fld => $aTot) {
			if (!is_array($aTot)) continue;
			// debug("De $grp_fld");
			if (!is_array($aTotalizar[$grp_fld])) $aTotalizar[$grp_fld] = array();
			foreach ($aTot as $name => $aFld) {
				if (empty($aFld['field'])) continue;
				$field_name = $aFld['field'];
				$aFld['field'] = NULL;
				unset($aFld['field']);
				$round_to = $aFld['round'];
				$aFld['round'] = NULL;
				unset($aFld['round']);
				$opt_erase = $aFld['erase_without'];
				if (!empty($opt_erase)) {
					$aFld['erase_without'] = NULL;
					unset($aFld['erase_without']);
					if (!(int)$$opt_erase) {
						continue;
					}
				}

				if (!is_array($aFld)) continue;
				// debug("para $name : $opt_erase ");

				foreach ($aFld as $nombre => $funcion) {
					// debug("$nombre es $funcion");
					$aTmp = array('field' => $field_name,'fnc' => $funcion, 'name' => $nombre.' ('.$name.')');
					if (is_numeric($round_to)) $aTmp['round'] = $round_to;
					array_push($aTotalizar[$grp_fld],$aTmp);
					$aTmp = NULL;
				}
			}
		}
		// debug("totales");
		// print_r($aTotalizar);
		$Sesion->set_var('TotalesInforme',$aTotalizar);
	} else $Sesion->unset_var('Totales_informe');

	// Variables _base_
	if (!empty($pr_id)) {
		$aSt['pr_id'] = $pr_id;
	}
	if (!empty($pr_nombre)) {
		$aSt['pr_nombre'] = $pr_nombre;
	}
	if (!empty($fr_ref)) {
		$aSt['fr_ref'] = $fr_ref;
	}
	if (!empty($fr_ref_ext)) {
		$aSt['fr_ref_ext'] = $fr_ref_ext;
	}
	if (is_numeric($fr_serie)) {
		$aSt['fr_serie'] = $fr_serie;
	} else $fr_serie = NULL;
	if (!empty($fr_fecha_inicio) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_inicio,FALSE)) ) {
		$aSt['fr_fecha_inicio'] = $fr_fecha_inicio;
	} else $fr_fecha_inicio = NULL;
	if (!empty($fr_fecha_fin) AND strcasecmp('null',wol_db::formatear_fecha($fr_fecha_fin,FALSE)) ) {
		$aSt['fr_fecha_fin'] = $fr_fecha_fin;
	} else $fr_fecha_fin = NULL;
	if (is_numeric($fr_basei)) {
		$aSt['fr_basei'] = $fr_basei;
	} else $fr_basei=NULL;


	if (is_array($aSt)) {
		$Sesion->set_var('st',$aSt,'SUBSECCION');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
