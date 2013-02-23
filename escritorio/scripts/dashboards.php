<?php

function pre_fb_dsb_ventas(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  // debug("pre_fb_dsb_ventas .. de $fecha limitar $bHastaDia");
		  if (!empty($fecha)) $Sesion->set_var('dsb_fecha',$fecha,'SUBSECCION');
		  if (isset($bHastaDia)) $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');
}

function pre_dsb_ventas(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																		  'alias' => 'ventas'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $aQPed = $oPer->SQLCollectData(array('campo' => 'IVAs.monto', 'alias' => 'pedidos'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL)'.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'ventas';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $cons = 'SELECT '.$aQPed['select'].' FROM '.$aQPed['from'].
										  'WHERE ('.$aQPed['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL)'.
										  ' GROUP BY '.$aQPed['groupby'].'ORDER BY '.$aQPed['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  if (strcasecmp($periodo,'anyo')) {
					 // Indicadores Comprarados.
					 $aRes = NULL;
					 $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																					 'alias' => 'ventas'),'Facturas.fecha',$fecha,$periodo,false,$bHastaDia);
					 $aQEff = $oPer->SQLCollectData(array('campo' => 'IF(Efectos.pago_cobro,Efectos.monto_pagado,(Efectos.monto_pagado*-1))', 
																																					 'alias' => 'cobrado'),'Efectos.fecha_abono',$fecha,$periodo,false,$bHastaDia);
					 $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
													 'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.
													 ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
					 $aRes[0]['indicador'] = 'ventas';
					 $aRes[0]['periodo'] = 'nombre';
					 $aRes[0]['res'] = $oDb->query($cons);

					 $cons = 'SELECT '.$aQEff['select'].' FROM '.$aQEff['from'].' JOIN Facturas F ON (Efectos.id_factura=F.id_factura) '.
													 'WHERE ('.$aQEff['where'].') AND (F.id_proveedor = 0 OR F.id_proveedor IS NULL) '.
													 ' GROUP BY '.$aQEff['groupby'].'ORDER BY '.$aQEff['orderby'];
					 $aRes[1]['indicador'] = 'cobrado';
					 $aRes[1]['periodo'] = 'nombre';
					 $aRes[1]['res'] = $oDb->query($cons);
					 $Sesion->set_var('dsb_rs_comparadas',$aRes,'SUBSECCION');
		  }

		  $aRes = NULL;
		  $indicador = 'top_clientes';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																		  'alias' => $indicador),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', C.razon_social as "razon_social" FROM '.$aQFra['from'].' JOIN Clientes C ON (Facturas.id_cliente=C.id_cliente) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY C.id_cliente ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'razon_social';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_agentes';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																					 'alias' => $indicador),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ag.nombre as "nombre_agente" FROM '.$aQFra['from'].' JOIN Agentes_facturas AF ON (Facturas.id_factura=AF.id_factura) '.
										  ' JOIN Agentes Ag ON (AF.id_agente=Ag.id_agente) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ag.id_agente ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_agente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																					 'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', Ma.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Marcas Ma ON (Ar.id_marca=Ma.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ma.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_compras(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																		  'alias' => 'compras'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $aQPed = $oPer->SQLCollectData(array('campo' => 'IVAs.monto', 'alias' => 'pedidos'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL)'.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'compras';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $cons = 'SELECT '.$aQPed['select'].' FROM '.$aQPed['from'].
										  'WHERE ('.$aQPed['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL)'.
										  ' GROUP BY '.$aQPed['groupby'].'ORDER BY '.$aQPed['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  if (strcasecmp($periodo,'anyo')) {
					 // Indicadores Comprarados.
					 $aRes = NULL;
					 $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																					 'alias' => 'compras'),'Facturas.fecha',$fecha,$periodo,false,$bHastaDia);
					 $aQEff = $oPer->SQLCollectData(array('campo' => 'monto_pagado', 'alias' => 'cobrado'),'Efectos.fecha_abono',$fecha,$periodo,false,$bHastaDia);
					 $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
													 'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) '.
													 ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
					 $aRes[0]['indicador'] = 'compras';
					 $aRes[0]['periodo'] = 'nombre';
					 $aRes[0]['res'] = $oDb->query($cons);

					 $cons = 'SELECT '.$aQEff['select'].' FROM '.$aQEff['from'].' JOIN Facturas F ON (Efectos.id_factura=F.id_factura) '.
													 'WHERE ('.$aQEff['where'].') AND (F.id_cliente = 0 OR F.id_cliente IS NULL) '.
													 ' GROUP BY '.$aQEff['groupby'].'ORDER BY '.$aQEff['orderby'];
					 $aRes[1]['indicador'] = 'cobrado';
					 $aRes[1]['periodo'] = 'nombre';
					 $aRes[1]['res'] = $oDb->query($cons);
					 $Sesion->set_var('dsb_rs_comparadas',$aRes,'SUBSECCION');
		  }

		  $aRes = NULL;
		  $indicador = 'top_proveedores';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas.base_imponible*-1),Facturas.base_imponible)', 
																																		  'alias' => $indicador),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', P.razon_social as "razon_social" FROM '.$aQFra['from'].' JOIN Proveedores P ON (Facturas.id_proveedor=P.id_proveedor) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) '.$where_agrup.' '.
										  'GROUP BY P.id_proveedor ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'razon_social';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																		  'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ma.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Marcas Ma ON (Ar.id_marca=Ma.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ma.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																		  'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_almacenes(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  // Indicadores generales
		  $aResG = NULL;
		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => 'Lineas_detalle.monto_total', 'alias' => 'ventas'), 
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*Detalles_albaran.cantidad', 'alias' => 'servido_ventas'),
										  array('campo' => 'Ea.'.$campo_valoracion.'*Detalles_albaran.cantidad', 'alias' => 'valor_stk_ventas')
										  ),'Albaranes.fecha',$fecha_hoy,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  'JOIN Empresas_articulos Ea ON (Lineas_detalle.id_articulo=Ea.id_articulo AND Ea.id_empresa ='.$id_empresa.') '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) AND Albaranes.id_almacen = '.$id_almacen.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aResG[0]['indicador'] = 'ventas';
		  $aResG[0]['periodo'] = 'nombre';
		  $aResG[0]['res'] = $oDb->query($cons);

		  $aQPed = $oPer->SQLCollectData(array(
										  array('campo' => 'Lineas_detalle.monto_total', 'alias' => 'compras'), 
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*Detalles_albaran.cantidad', 'alias' => 'servido_compras'),
										  array('campo' => 'Ea.'.$campo_valoracion.'*Detalles_albaran.cantidad', 'alias' => 'valor_stk_compras')
										  ),'Albaranes.fecha',$fecha_hoy,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQPed['select'].' FROM '.$aQPed['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  'JOIN Empresas_articulos Ea ON (Lineas_detalle.id_articulo=Ea.id_articulo AND Ea.id_empresa ='.$id_empresa.') '.
										  'WHERE ('.$aQPed['where'].') AND (P.id_direccion = 0 OR P.id_direccion IS NULL) AND Albaranes.id_almacen = '.$id_almacen.
										  ' GROUP BY '.$aQPed['groupby'].'ORDER BY '.$aQPed['orderby'];
		  $aResG[1]['indicador'] = 'compras';
		  $aResG[1]['periodo'] = 'nombre';
		  $aResG[1]['res'] = $oDb->query($cons);

		  // Stock

		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas_stock', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha_hoy,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE '.$aQFra['where'].
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'bajas_stock';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $indicador = 'abonos_ventas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'Facturas_detalle.importe*(Empresas_articulos.'.$campo_valoracion.')', 
																																		  'alias' => $indicador, 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha_hoy,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Empresas_articulos ON (Lineas_detalle.id_articulo=Empresas_articulos.id_articulo AND Empresas_articulos.id_empresa='.$id_empresa.') '.
										  'WHERE Facturas.factura_abono > 0 AND ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[3]['indicador'] = $indicador;
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $cons_stock = 'SELECT SUM(L.cantidad*Ea.precio_costo) '.
																'FROM Localizacion_articulos L JOIN Almacenes_logicos Al ON (Al.id_almacen_logico=L.id_almacen_logico) '.
																'JOIN Empresas_articulos Ea ON (Ea.id_articulo=L.id_articulo) '.
																'WHERE Al.id_almacen = '.$id_almacen;
		  $stk_rs = $oDb->query($cons_stock);
		  if ($oDb->num_rows($stk_rs)) {
					 $aStk = $oDb->fetch_row($stk_rs);
					 $valor_stock = $aStk[0];
		  }

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $idx_hoy = $oPer->findDay($fecha_hoy);
		  $oDiaHoy = $oPer->getDay($idx_hoy);
		  $aDiaHoy = $oDiaHoy->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  $aMes = $oPer->getMonth($aDia['id_mes']);
		  if (is_array($aSem) AND sizeof($aSem)) $aTrim = $oPer->getTrimester($aSem['id_trimestre']);
		  if (is_array($aTrim) AND sizeof($aTrim)) $aAnyo = $oPer->getYear($aTrim['id_anyo']);
		  $aSemHoy = $oPer->getWeek($aDiaHoy['id_semana']);
		  $aMesHoy = $oPer->getMonth($aDiaHoy['id_mes']);
		  if (is_array($aSemHoy) AND sizeof($aSemHoy)) $aTrimHoy = $oPer->getTrimester($aSemHoy['id_trimestre']);
		  if (is_array($aTrimHoy) AND sizeof($aTrimHoy)) $aAnyoHoy = $oPer->getTrimester($aTrimHoy['id_trimestre']);
		  $numero_relativo = NULL;
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								$numero_relativo = $aSem['numero'];
								break;
					 case 'id_mes':
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								$numero_relativo = $aMes['num'];
								break;
					 case 'id_trimestre':
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								$numero_relativo = $aTrim['num_trimestre_anyo'];
								break;
					 case 'id_anyo':
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								// $numero_relativo = $aAnyo['numero'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  if ($fecha != $fecha_hoy) {
					 // debug("$fecha No coincide con la fecha de hoy ($fecha_hoy)... nuemro_relativo: $numero_relativo ");
					 $time = strtotime($fecha);
					 $aAcumulados = array();
					 foreach ($aResG as $p => $aR) {
								$bBreak = false;
								$i = 0;
								while (!$bBreak) {
										  $aQR = $oDb->fetch_assoc($aR['res']);
										  // debug("Obtenemos: ");
										  // print_r($aQR);
										  if (!$aQR OR !is_array($aQR) OR !sizeof($aQR)) $bBreak = true;
										  else {
													 if ($aQR['Anyo'] != date('Y',$time) OR $aQR['numero_relativo'] > $numero_relativo) {
																if (is_numeric($aQR['valor_stk_ventas'])) {
																		  // debug("Aculando ventas: ".$aAcumulados['stock_ventas']." + ".$aQR['valor_stk_ventas']);
																		  $aAcumulados['stock_ventas'] += $aQR['valor_stk_ventas'];
																}
																if (is_numeric($aQR['valor_stk_compras'])) {
																		  // debug("Aculando compras: ".$aAcumulados['stock_compras']." + ".$aQR['valor_stk_compras']);
																		  $aAcumulados['stock_compras'] += $aQR['valor_stk_compras'];
																}
													 } else {
																// debug("Resetearemos en $i ");
																$aResG[$p]['reset_rs'] = true;
																$aResG[$p]['reset_rs_start'] = $i;
																$bBreak = true;
													 }
										  }
										  $i++;
								}
					 }
					 foreach ($aRes as $p => $aR) {
								$bBreak = false;
								$i = 0;
								while (!$bBreak) {
										  $aQR = $oDb->fetch_assoc($aR['res']);
										  // debug("Obtenemos: ");
										  // print_r($aQR);
										  if (!$aQR OR !is_array($aQR) OR !sizeof($aQR)) $bBreak = true;
										  else {
													 if ($aQR['Anyo'] != date('Y',$time) OR $aQR['numero_relativo'] > $numero_relativo) {
																if (is_numeric($aQR['bajas_stock'])) {
																		  // debug("Aculando bajas: ".$aAcumulados['bajas']." + ".$aQR['bajas_stock']);
																		  $aAcumulados['bajas'] += $aQR['bajas_stock'];
																}
																if (is_numeric($aQR['abonos_ventas'])) {
																		  // debug("Aculando abonos: ".$aAcumulados['abonos']." + ".$aQR['abonos_ventas']);
																		  $aAcumulados['abonos'] += $aQR['abonos_ventas'];
																}
													 } else {
																// debug("Asignamos reset a: ".$i);
																$aRes[$p]['reset_rs'] = true;
																$aRes[$p]['reset_rs_start'] = $i;
																$bBreak = true;
													 }
										  }
										  $i++;
								}
					 }
					 // debug("Acumulados: ".$valor_stock);
					 // print_r($aAcumulados);
					 $valor_stock = $valor_stock + $aAcumulados['bajas'] + $aAcumulados['stock_ventas'] - $aAcumulados['abonos'] - $aAcumulados['stock_compras'];
		  }

		  $aRes[0] = $aResG[0];
		  $aRes[1] = $aResG[1];

		  if ($fecha == $fecha_hoy) {
					 $aRes[0]['reset_rs'] = true;
					 $aRes[1]['reset_rs'] = true;
		  }

		  $Sesion->set_var('dsb_rs_general',$aResG,'SUBSECCION');
		  $Sesion->set_var('dsb_rs_stock',$aRes,'SUBSECCION');
		  // debug("Valor del stock: $valor_stock ");
		  if (is_numeric($valor_stock)) $Sesion->set_var('_dsb_stock_inicial',$valor_stock,'SUBSECCION');

		  return;
}

function dsb_almacenes_valor_stock (&$Sesion,&$aData) {
		  $aStk = $Sesion->get_var('_dsb_almacenes_valor_stock_rec');
		  if (!is_array($aStk) OR !sizeof($aStk)) {
					 $stk = $Sesion->get_var('_dsb_stock_inicial');
					 $valor_stock = (float)$stk;
					 // debug("Data: $stk - $valor_stock");
					 // print_r($aData);
					 $aStk['valor_stock'] = $valor_stock;
					 $aStk['data'] = $aData;
		  } else {
					 // debug("Posteriores: ");
					 // print_r($aStk);
					 // debug(" valor_stock = ".$aStk['valor_stock']." + ".$aStk['data']['bajas_stock']." + ".$aStk['data']['valor_stk_ventas'].
																					 // " - ".$aStk['data']['abonos_ventas']." - ".$aStk['data']['valor_stk_compras']);
					 $valor_stock = $aStk['valor_stock'] + $aStk['data']['bajas_stock'] + $aStk['data']['valor_stk_ventas'] 
																					 - $aStk['data']['abonos_ventas'] - $aStk['data']['valor_stk_compras'];
					 $aStk['valor_stock'] = $valor_stock;
					 $aStk['data'] = $aData;
		  }

		  $aData['valor_stock'] = $valor_stock;

		  $Sesion->set_var('_dsb_almacenes_valor_stock_rec',$aStk,'INMED');
		  return true;
}

function pre_dsb_almacenes_faltas(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  $aRes = NULL;
		  $indicador = 'general';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', M.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Marcas M ON (Ar.id_marca=M.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY M.id_marca HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_clientes';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', C.razon_social as "nombre_cliente" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Direcciones_entrega De ON (P.id_direccion=De.id_direccion) JOIN Clientes C ON (C.id_cliente=De.id_cliente) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY C.id_cliente HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_cliente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  return;
}

function pre_dsb_almacenes_faltas_compras (&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  $aRes = NULL;
		  $indicador = 'general';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', M.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Marcas M ON (Ar.id_marca=M.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.$where_agrup.' '.
										  'GROUP BY M.id_marca HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_proveedores';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Lineas_detalle.cantidad-Detalles_albaran.cantidad)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', Pr.razon_social as "nombre_proveedor" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Proveedores Pr ON (Pr.id_proveedor=P.id_proveedor) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY Pr.id_proveedor HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_proveedor';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  return;
}

function pre_dsb_almacenes_devoluciones_venta(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  $aRes = NULL;
		  $indicador = 'general';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', M.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Marcas M ON (Ar.id_marca=M.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.$where_agrup.' '.
										  'GROUP BY M.id_marca HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_clientes';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_venta', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', C.razon_social as "nombre_cliente" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Direcciones_entrega De ON (P.id_direccion=De.id_direccion) JOIN Clientes C ON (C.id_cliente=De.id_cliente) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY C.id_cliente HAVING indicador_venta !=0 ORDER BY indicador_venta desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_cliente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  return;
}

function pre_dsb_almacenes_devoluciones_compra (&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  $aRes = NULL;
		  $indicador = 'general';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', M.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Marcas M ON (Ar.id_marca=M.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.$where_agrup.' '.
										  'GROUP BY M.id_marca HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_proveedores';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'indicador_compra', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', Pr.razon_social as "nombre_proveedor" FROM '.$aQFra['from'].' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  ' JOIN Proveedores Pr ON (Pr.id_proveedor=P.id_proveedor) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY Pr.id_proveedor HAVING indicador_compra !=0 ORDER BY indicador_compra desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_proveedor';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  return;
}

function pre_dsb_almacenes_bajas(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  $fecha_hoy = date('Y-m-d');
		  $time_hoy = strtotime($fecha_hoy);
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time_hoy));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = $fecha_hoy;
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  if (empty($periodo)) $periodo = 'Semana';
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia)");

		  $id_empresa = $Sesion->get_var('id_empresa');
		  $id_almacen = $Sesion->get_var('id_almacen');
		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SECCION');

		  $aRes = NULL;
		  $indicador = 'general';
		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas_stock', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Ba.nombre as "nombre_tipo_baja" FROM '.$aQFra['from'].' '.
										  ' JOIN Bajas_almacen Ba ON (Bajas_localizacion.id_baja_almacen=Ba.id_baja_almacen) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY Ba.id_baja_almacen HAVING bajas_stock !=0 ORDER BY bajas_stock desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_tipo_baja';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas_stock', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' '.
										  ' JOIN Articulos Ar ON (Bajas_localizacion.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo HAVING bajas_stock !=0 ORDER BY bajas_stock desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas_stock', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', M.nombre as "nombre_marca" FROM '.$aQFra['from'].' '.
										  ' JOIN Articulos Ar ON (Bajas_localizacion.id_articulo=Ar.id_articulo) JOIN Marcas M ON (Ar.id_marca=M.id_marca) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY M.id_marca HAVING bajas_stock !=0 ORDER BY bajas_stock desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_clientes';
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Ld.monto_total/Ld.cantidad)*(Bajas_localizacion.cantidad)', 
																																'alias' => 'bajas_stock', 'entidad_from' => 'Detalles_albaran'),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].', C.razon_social as "nombre_cliente" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Detalles_albaran.id_detalle=Ld.id_detalle) '.
										  'JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  'JOIN Direcciones_entrega De ON (P.id_direccion=De.id_direccion) JOIN Clientes C ON (C.id_cliente=De.id_cliente) '.
										  'WHERE ('.$aQFra['where'].') '.$where_agrup.' '.
										  'GROUP BY C.id_cliente HAVING bajas_stock !=0 ORDER BY bajas_stock desc ';
		  // debug("query: ".$cons);
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_cliente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  return;
}

function pre_dsb_marcas(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Facturas_detalle.cantidad)', 
																																'alias' => 'indicador_base', 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

}

function pre_dsb_marcas_pedido(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Lineas_detalle.monto_total', 
																																'alias' => 'pedidos', 'entidad_from' => 'Lineas_detalle'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResPC[0] = $aRes[1];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

}

function pre_dsb_marcas_venta_devoluciones(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle'))
										  ,'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].' '.
										  ' JOIN Articulos Ar ON (Bajas_localizacion.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND Ar.id_marca = '.$id_marca.' '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  // debug("query: ".$cons);
		  $aRes[3]['indicador'] = 'bajas';
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResSC[0] = $aRes[2];
		  $aResSC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResSC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResBC[0] = $aRes[3];
		  $aResBC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_bajas_comparadas',$aResBC,'SUBSECCION');

}

function pre_dsb_marcas_compra(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Facturas_detalle.cantidad)', 
																																'alias' => 'indicador_base', 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

}

function pre_dsb_marcas_compra_pedido(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Lineas_detalle.monto_total', 
																																'alias' => 'pedidos', 'entidad_from' => 'Lineas_detalle'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResPC[0] = $aRes[1];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

}

function pre_dsb_marcas_compra_devuelto(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_marca = $Sesion->get_var('id_marca');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_marca)) return NULL;
		  debug("DEVUELTO Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_marca ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle'))
								,'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_marca = '.$id_marca.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'servido';
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResDC,'SUBSECCION');

}

function pre_dsb_cliente(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_cliente = $Sesion->get_var('id_cliente');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_cliente)) return NULL;
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Cliente: $id_cliente ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'indicador_base' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = '.$id_cliente.') AND Facturas.factura_abono = 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'abonos' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = '.$id_cliente.') AND Facturas.factura_abono > 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'abonos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'IVAs.monto', 
																																'alias' => 'pedidos', 'entidad_from' => 'IVAs'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Direcciones_entrega Dr ON (Dr.id_direccion=Pedidos.id_direccion) '.
										  'WHERE ('.$aQFra['where'].') AND (Dr.id_cliente = '.$id_cliente.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'pedidos';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( 
								array(array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
								array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle')),
								'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) JOIN Direcciones_entrega Dir ON (P.id_direccion=Dir.id_direccion) '.
										  'WHERE ('.$aQFra['where'].') AND (Dir.id_cliente = '.$id_cliente.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[3]['indicador'] = 'albaranes';
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResAC[0] = $aRes[1];
		  $aResAC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_abonos_comparados',$aResAC,'SUBSECCION');

		  $aResPC[0] = $aRes[2];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[3];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'devoluciones';
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResDC[0] = $aRes[3];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'servido';
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResDC,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = '.$id_cliente.') '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Mr.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Marcas Mr ON (Mr.id_marca=Ar.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = '.$id_cliente.') '.$where_agrup.' '.
										  'GROUP BY Mr.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_articulos_venta(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_articulo = $Sesion->get_var('id_articulo');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_articulo)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_articulo ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Facturas_detalle.cantidad)', 
																																'alias' => 'indicador_base', 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  /** **/
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) AND Lineas_detalle.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

}

function pre_dsb_articulos_venta_servido(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_articulo = $Sesion->get_var('id_articulo');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_articulo)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_articulo ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Lineas_detalle.monto_total', 
																																'alias' => 'pedidos', 'entidad_from' => 'Lineas_detalle'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  /** **/
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL) AND Lineas_detalle.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array(
								array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
								array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle'))
								,'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL) AND Lineas_detalle.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);
		  /** **/

		  $aQFra = $oPer->SQLCollectData(array(
										  array('campo' => '(Empresas_articulos.'.$campo_valoracion.')*Bajas_localizacion.cantidad', 'alias' => 'bajas', 'entidad_from' => 'Empresas_articulos')
										  ),'Bajas_localizacion.fecha_baja',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].' '.
										  'WHERE ('.$aQFra['where'].') AND Bajas_localizacion.id_articulo = '.$id_articulo.' '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  // debug("query: ".$cons);
		  $aRes[3]['indicador'] = 'bajas';
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResPC[0] = $aRes[1];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResSC[0] = $aRes[2];
		  $aResSC[0]['reset_rs'] = true;
		  $aResSC[0]['indicador'] = 'servido';
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResSC,'SUBSECCION');

		  $aResBC[0] = $aRes[3];
		  $aResBC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_bajas_comparadas',$aResBC,'SUBSECCION');

		  $aRes = NULL;
}

function pre_dsb_articulos_venta_tops(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_articulo = $Sesion->get_var('id_articulo');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_articulo)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_articulo ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;

		  $indicador = 'top_clientes';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].', Cl.razon_social as "nombre_cliente" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Clientes Cl ON (Facturas.id_cliente=Cl.id_cliente)  '.
										  'WHERE ('.$aQFra['where'].') AND (Ld.id_articulo = '.$id_articulo.') '.$where_agrup.' '.
										  'GROUP BY Cl.id_cliente ORDER BY nombre_cliente desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_cliente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');
		  /** **/

		  $aRes = NULL;
		  $indicador = 'top_agentes';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', AgF.id_agente as "nombre_agente" FROM '.$aQFra['from'].
										  ' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Agentes_facturas AgF ON (Facturas.id_factura=AgF.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (Ld.id_articulo = '.$id_articulo.') '.$where_agrup.' '.
										  'GROUP BY AgF.id_agente ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_agente';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_articulos_compra(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_articulo = $Sesion->get_var('id_articulo');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_articulo)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_articulo ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Facturas_detalle.cantidad)', 
																																'alias' => 'indicador_base', 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  /** **/
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Lineas_detalle.monto_total', 
																																'alias' => 'pedidos', 'entidad_from' => 'Lineas_detalle'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
										  array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle')
										  ),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);
		  /** **/

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResPC[0] = $aRes[1];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResSC[0] = $aRes[2];
		  $aResSC[0]['reset_rs'] = true;
		  $aResSC[0]['indicador'] = 'servido';
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResSC,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_proveedores';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Pr.razon_social as "nombre_proveedor" FROM '.$aQFra['from'].
										  ' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Proveedores Pr ON (Facturas.id_proveedor=Pr.id_proveedor)  '.
										  'WHERE ('.$aQFra['where'].') AND (Ar.id_articulo = '.$id_articulo.') '.$where_agrup.' '.
										  'GROUP BY Pr.id_proveedor ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_proveedor';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_articulos_compra_servido(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_articulo = $Sesion->get_var('id_articulo');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_articulo)) return NULL;
		  debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Marca: $id_articulo ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Facturas_detalle.cantidad)', 
																																'alias' => 'indicador_base', 'entidad_from' => 'Lineas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  /** **/
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_cliente = 0 OR Facturas.id_cliente IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Lineas_detalle.monto_total', 
																																'alias' => 'pedidos', 'entidad_from' => 'Lineas_detalle'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'pedidos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Articulos Ar ON (Lineas_detalle.id_articulo=Ar.id_articulo) JOIN Pedidos ON (Albaranes.id_pedido=Pedidos.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_direccion = 0 OR Pedidos.id_direccion IS NULL) AND Ar.id_articulo = '.$id_articulo.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);
		  /** **/

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResPC[0] = $aRes[1];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_proveedores';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Pr.razon_social as "nombre_proveedor" FROM '.$aQFra['from'].
										  ' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Proveedores Pr ON (Facturas.id_proveedor=Pr.id_proveedor)  '.
										  'WHERE ('.$aQFra['where'].') AND (Ar.id_articulo = '.$id_articulo.') '.$where_agrup.' '.
										  'GROUP BY Pr.id_proveedor ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_proveedor';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_proveedor(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_proveedor = $Sesion->get_var('id_proveedor');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_proveedor)) return NULL;
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Cliente: $id_cliente ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'indicador_base' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = '.$id_proveedor.') AND Facturas.factura_abono = 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'abonos' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = '.$id_proveedor.') AND Facturas.factura_abono > 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'abonos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'IVAs.monto', 
																																'alias' => 'pedidos', 'entidad_from' => 'IVAs'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = '.$id_proveedor.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'pedidos';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( 
								array(array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),
								array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad)', 
																																'alias' => 'servido', 'entidad_from' => 'Lineas_detalle')),
								'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = '.$id_proveedor.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[3]['indicador'] = 'albaranes';
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResAC[0] = $aRes[1];
		  $aResAC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_abonos_comparados',$aResAC,'SUBSECCION');

		  $aResPC[0] = $aRes[2];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[3];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'devoluciones';
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aResDC[0] = $aRes[3];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'servido';
		  $Sesion->set_var('dsb_rs_servido_comparados',$aResDC,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = '.$id_proveedor.') '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Mr.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Marcas Mr ON (Mr.id_marca=Ar.id_marca) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = '.$id_proveedor.') '.$where_agrup.' '.
										  'GROUP BY Mr.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_agente(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_agente = $Sesion->get_var('id_agente');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_agente)) return NULL;
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Cliente: $id_cliente ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'indicador_base' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Agentes_facturas AgF ON (Facturas.id_factura=AgF.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (AgF.id_agente = '.$id_agente.') AND Facturas.factura_abono = 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'indicador_base';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'Facturas.base_imponible', 
																																'alias' => 'abonos' ),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Agentes_facturas AgF ON (Facturas.id_factura=AgF.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (AgF.id_agente = '.$id_agente.') AND Facturas.factura_abono > 0 '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'abonos';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => 'IVAs.monto', 
																																'alias' => 'pedidos', 'entidad_from' => 'IVAs'),'Pedidos.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  'WHERE ('.$aQFra['where'].') AND (Pedidos.id_proveedor = 0 OR Pedidos.id_proveedor IS NULL) AND Pedidos.id_agente = '.$id_agente.' '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'pedidos';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array('campo' => '(Lineas_detalle.monto_total/Lineas_detalle.cantidad)*(Detalles_albaran.cantidad_devuelta)', 
																																'alias' => 'devoluciones', 'entidad_from' => 'Lineas_detalle'),'Albaranes.fecha',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Pedidos P ON (Albaranes.id_pedido=P.id_pedido) '.
										  'WHERE ('.$aQFra['where'].') AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) AND P.id_agente = '.$id_agente.' '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[3]['indicador'] = 'albaranes';
		  $aRes[3]['periodo'] = 'nombre';
		  $aRes[3]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_ventas_comparadas',$aResVC,'SUBSECCION');

		  $aResAC[0] = $aRes[1];
		  $aResAC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_abonos_comparados',$aResAC,'SUBSECCION');

		  $aResPC[0] = $aRes[2];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pedidos_comparados',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[3];
		  $aResDC[0]['reset_rs'] = true;
		  $aResDC[0]['indicador'] = 'devoluciones';
		  $Sesion->set_var('dsb_rs_devoluciones_comparadas',$aResDC,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_articulos';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Ar.nombre as "nombre_articulo" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  ' JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Agentes_facturas AgF ON (AgF.id_factura=Facturas.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor = 0 OR Facturas.id_proveedor IS NULL) AND (AgF.id_agente = '.$id_agente.') '.$where_agrup.' '.
										  'GROUP BY Ar.id_articulo ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_articulo';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

		  $aRes = NULL;
		  $indicador = 'top_marcas';
		  $aQFra = $oPer->SQLCollectData(array('campo' => 'IF(Facturas.factura_abono,(Facturas_detalle.importe*-1),Facturas_detalle.importe)', 
																																'alias' => $indicador, 'entidad_from' => 'Facturas_detalle'),'Facturas.fecha',$fecha,$periodo,true,$bHastaDia);

		  $cons = 'SELECT '.$aQFra['select'].', Mr.nombre as "nombre_marca" FROM '.$aQFra['from'].' JOIN Lineas_detalle Ld ON (Facturas_detalle.id_detalle=Ld.id_detalle) '.
										  'JOIN Articulos Ar ON (Ld.id_articulo=Ar.id_articulo) JOIN Marcas Mr ON (Mr.id_marca=Ar.id_marca) '.
										  'JOIN Agentes_facturas AgF ON (AgF.id_factura=Facturas.id_factura)'.
										  'WHERE ('.$aQFra['where'].') AND (Facturas.id_proveedor=0 OR Facturas.id_proveedor IS NULL) AND (AgF.id_agente = '.$id_agente.') '.$where_agrup.' '.
										  'GROUP BY Mr.id_marca ORDER BY '.$indicador.' desc ';
		  $aRes[0]['indicador'] = $indicador;
		  $aRes[0]['periodo'] = 'nombre_marca';
		  $aRes[0]['res'] = $oDb->query($cons);
		  $Sesion->set_var('dsb_rs_'.$indicador,$aRes,'SUBSECCION');

}

function pre_dsb_tesoreria(&$Sesion) {
		  $fecha = $Sesion->fetchVar('fecha','POST');
		  $periodo = $Sesion->fetchVar('periodo','POST GET SESSION');
		  $bHastaDia = (bool)$Sesion->fetchVar('limitardia','POST');
		  $campo_valoracion = 'precio_costo';

		  $prev_fecha = $Sesion->get_var('_dsb_fecha');
		  // debug("fecha: $fecha contra $prev_fecha ");
		  if (empty($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha,false),'null') OR $prev_fecha != $fecha) {
					 if (!empty($prev_fecha)) {
								if (empty($fecha)) $fecha = $prev_fecha;
								$fecha = wol_db::formatear_fecha($fecha,false);
								// debug("Nueva fecha: $fecha ");
								$time = strtotime(wol_db::formatear_fecha($fecha,false));
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 } else {
								$fecha = date('Y-m-d');
								$time = strtotime($fecha);
								$fini = date('Y-m-d',strtotime("-1 day",$time));
								$ffin = date('Y-m-d',strtotime("+1 day",$time));
								$oPer = new Periodo($Sesion->App_Name,NULL,$fini,$ffin);
								$Sesion->set_var('dsb_Periodo',$oPer,'SUBSECCION');
					 }
					 $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  } else $oPer = $Sesion->get_var('dsb_Periodo');
		  $oDb = &$Sesion->get_db('data');

		  $id_empresa = $Sesion->get_var('id_empresa');
		  if (empty($periodo)) $periodo = 'Semana';
		  if (!is_numeric($id_empresa)) return NULL;
		  // debug("Periodo= $periodo  de $fecha Y Limitando ($bHastaDia) Cliente: $id_cliente ");

		  $fecha = wol_db::formatear_fecha($fecha,false);
		  $Sesion->set_var('dsb_term',$periodo,'SUBSECCION');
		  $Sesion->set_var('_dsb_fecha',$fecha,'SUBSECCION');
		  $Sesion->set_var('dsb_limitedia',(int)$bHastaDia,'SUBSECCION');

		  // Indicadores generales
		  $aRes = NULL;
		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => 'IF(Efectos.pago_cobro,Efectos.monto,0)', 'alias' => 'vencimiento_cobros', 'entidad' => 'Efectos' ),
										  array('campo' => 
													 'IF((Efectos.pago_cobro=1 AND (Efectos.fecha_abono>Efectos.fecha_vencimiento OR Efectos.fecha_abono IS NULL)),(Efectos.monto-Efectos.monto_pagado),0)',
													 'alias' => 'pendiente_cobros', 'entidad' => 'Efectos' ),
										  array('campo' => 'IF(Efectos.pago_cobro,0,Efectos.monto)', 'alias' => 'vencimiento_pagos', 'entidad' => 'Efectos' ),
										  array('campo' => 
													 'IF((Efectos.pago_cobro=0 AND (Efectos.fecha_abono>Efectos.fecha_vencimiento OR Efectos.fecha_abono IS NULL)),(Efectos.monto-Efectos.monto_pagado),0)',
													 'alias' => 'pendiente_pagos', 'entidad' => 'Efectos' )
										  )
								,'Efectos.fecha_vencimiento',$fecha,$periodo,true,$bHastaDia);

		  // Esto solo lo hacemos una vez.
		  $idx = $oPer->findDay($fecha);
		  if (empty($idx)) return NULL;
		  $oDia = $oPer->getDay($idx);
		  $aDia = $oDia->getData();
		  $groupby = $aQFra['groupby'];
		  $aTmp = split('\.',$groupby);
		  foreach ($aTmp as $k => $v) $aTmp[$k] = trim($v);
		  $aSem = $oPer->getWeek($aDia['id_semana']);
		  switch ($aTmp[1]) {
					 case 'id_semana':
								$nombre_periodo = $aSem['nombre'].' ['.colocar_fecha($aSem['f_ini'],$Sesion).' - '.colocar_fecha($aSem['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_semana = '.$aDia['id_semana'];
								break;
					 case 'id_mes':
								$aMes = $oPer->getMonth($aDia['id_mes']);
								$nombre_periodo = $aMes['nombre'].' ['.colocar_fecha($aMes['f_ini'],$Sesion).' - '.colocar_fecha($aMes['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_mes = '.$aDia['id_mes'];
								break;
					 case 'id_trimestre':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$nombre_periodo = $aTrim['nombre'].' ['.colocar_fecha($aTrim['f_ini'],$Sesion).' - '.colocar_fecha($aTrim['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_trimestre = '.$aSem['id_trimestre'];
								break;
					 case 'id_anyo':
								$aTrim = $oPer->getTrimester($aSem['id_trimestre']);
								$aAnyo = $oPer->getYear($aTrim['id_anyo']);
								$nombre_periodo = $aAnyo['nombre'].' ['.colocar_fecha($aAnyo['f_ini'],$Sesion).' - '.colocar_fecha($aAnyo['f_fin'],$Sesion).']';
								$where_agrup = ' AND '.$aTmp[0].'.id_anyo = '.$aTrim['id_anyo'];
								break;
		  }
		  if (!empty($nombre_periodo)) $Sesion->set_var('nombre_periodo_actual',$nombre_periodo);

		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Facturas F ON (F.id_factura=Efectos.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (F.id_empresa = '.$id_empresa.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[0]['indicador'] = 'vencimiento_cobro';
		  $aRes[0]['periodo'] = 'nombre';
		  $aRes[0]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => 'IF(Efectos.pago_cobro,Efectos.monto_pagado,0)', 'alias' => 'abonos_cobrados' ),
										  array('campo' => 'IF(Efectos.pago_cobro,0,Efectos.monto_pagado)', 'alias' => 'abonos_pagados') 
										  ),'Efectos.fecha_abono',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Facturas F ON (F.id_factura=Efectos.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (F.id_empresa = '.$id_empresa.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[1]['indicador'] = 'abonos_cobrados';
		  $aRes[1]['periodo'] = 'nombre';
		  $aRes[1]['res'] = $oDb->query($cons);

		  $aQFra = $oPer->SQLCollectData( array(
										  array('campo' => 'IF(Efectos.pago_cobro,Efectos.monto-Efectos.monto_pagado,0)', 'alias' => 'devoluciones_cobros', 'entidad_from' => 'Efectos'),
										  array('campo' => 'IF(Efectos.pago_cobro,0,Efectos.monto-Efectos.monto_pagado)', 'alias' => 'devoluciones_pagos', 'entidad_from' => 'Efectos')
										  ),'Efectos.fecha_devolucion',$fecha,$periodo,true,$bHastaDia);
		  $cons = 'SELECT '.$aQFra['select'].' FROM '.$aQFra['from'].
										  ' JOIN Facturas F ON (F.id_factura=Efectos.id_factura) '.
										  'WHERE ('.$aQFra['where'].') AND (F.id_empresa = '.$id_empresa.') '.
										  ' GROUP BY '.$aQFra['groupby'].'ORDER BY '.$aQFra['orderby'];
		  $aRes[2]['indicador'] = 'devoluciones_cobros';
		  $aRes[2]['periodo'] = 'nombre';
		  $aRes[2]['res'] = $oDb->query($cons);

		  $Sesion->set_var('dsb_rs_general',$aRes,'SUBSECCION');

		  $aResVC[0] = $aRes[0];
		  $aResVC[0]['reset_rs'] = true;

		  $Sesion->set_var('dsb_rs_vencimientos',$aResVC,'SUBSECCION');

		  $aResAC[0] = $aRes[1];
		  $aResAC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_abonos_comparados',$aResAC,'SUBSECCION');

		  $aResPC[0] = $aRes[0];
		  $aResPC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_pendiente',$aResPC,'SUBSECCION');

		  $aResDC[0] = $aRes[2];
		  $aResDC[0]['reset_rs'] = true;
		  $Sesion->set_var('dsb_rs_devoluciones',$aResDC,'SUBSECCION');

		  return;
}



function nodb_dsb_resultados_horizontal(&$Sesion) {
		  static $aRs;
		  static $n_limit;
		  static $n = 0;
		  static $last_var;
		  static $aExclude = array('Anyo', 'nombre', 'fecha_ini', 'fecha_fin', 'numero_relativo');
		  static $graph_field;
		  // static $numero_relativo;

		  // debug("<hr/>");
		  $oDb = &$Sesion->get_db('data');

		  $var = $Sesion->get_var('dsb_resultados');
		  if (!is_array($aRs) OR $var != $last_var) {
					 $aRs = $Sesion->get_var('dsb_rs_'.$var);
					 $last_var = $var;
					 if (!is_array($aRs) OR !sizeof($aRs)) return NULL;
					 $n = 0;
					 $graph_field = $Sesion->get_var('dsb_grfx_field');
					 $n_limit = NULL;
					 $numero_relativo = NULL;
		  }

		  if (!is_numeric($n_limit)) {
					 $n_limit = $Sesion->get_var('dsb_rs_limit');
					 if (!is_numeric($n_limit)) $n_limit = 5;
		  }
		  if ($n >= $n_limit) return NULL;

		  $aRetVal = NULL;
		  $bStore = false;
		  foreach ($aRs as $p => $aR) {
					 if (!is_numeric($aRs[$p]['row_num'])) $aRs[$p]['row_num'] = 0;
					 // debug("Pos $p row_num: ".$aRs[$p]['row_num']);
					 if ($aR['reset_rs']) {
								// debug("Reseteando... ".((is_numeric($aR['reset_rs_start'])) ? $aR['reset_rs_start'] : $aRs[$p]['row_num'] ));
								$oDb->data_seek($aR['res'], ((is_numeric($aR['reset_rs_start'])) ? $aR['reset_rs_start'] : $aRs[$p]['row_num'] ));
					 } else $oDb->data_seek($aRs[$p]['res'],$aRs[$p]['row_num']);
					 $aTmp = $oDb->fetch_assoc($aR['res']);
					 // debug("Comprobando : $p ");
					 // print_r($aTmp);
					 if (!is_numeric($numero_relativo) OR (is_numeric($aTmp['numero_relativo']) AND $numero_relativo < $aTmp['numero_relativo']) ) {
								$bStore = true;
								$numero_relativo = $aTmp['numero_relativo'];
								// debug("Numero relativo sacado: $numero_relativo ");
					 }
					 // debug("DataSeek de $p a ".$aRs[$p]['row_num']);
					 $oDb->data_seek($aRs[$p]['res'],$aRs[$p]['row_num']);
		  }
		  if ($bStore) {
					 $Sesion->set_var('dsb_rs_'.$last_var,$aRs);
		  }

		  // debug("Buscaremos el numero relativo $numero_relativo ");
		  foreach ($aRs as $p => $aR) {
					 if ($aR['reset_rs']) {
								// debug("Reset! para $last_var [$p] (".$aR['indicador'].") ".$aR['reset_rs_start']);
								$aRs[$p]['row_num'] = ((is_numeric($aR['reset_rs_start'])) ? $aR['reset_rs_start'] : 0 );
								$oDb->data_seek($aR['res'],$aRs[$p]['row_num']);
								$aRs[$p]['reset_rs'] = false;
								$Sesion->set_var('dsb_rs_'.$last_var,$aRs);
					 } 
					 $aTmp = $oDb->fetch_assoc($aR['res']);
					 if (!is_numeric($aTmp['numero_relativo']) OR ($aTmp['numero_relativo'] == $numero_relativo)) {
								// debug("Incrementando contador .. ");
								$aRs[$p]['row_num']++;
					 } else {
								continue;
					 }

					 if (!is_numeric($aRetVal['_periodo']) AND empty($aRetVal['_periodo']) AND 
										  (!empty($aTmp[$aR['periodo']]) OR is_numeric($aTmp[$aR['periodo']]))) $aRetVal['_periodo'] = $aTmp[$aR['periodo']];
					 if (!is_numeric($aRetVal['_periodo']) AND empty($aRetVal['_anyo']) AND 
										  (!empty($aTmp[$aR['Anyo']]) OR is_numeric($aTmp[$aR['Anyo']]))) $aRetVal['_anyo'] = $aTmp['Anyo'];
					 if (!is_numeric($aRetVal['_periodo']) AND empty($aRetVal['_inicio']) AND !empty($aTmp['fecha_ini'])) $aRetVal['_inicio'] = $aTmp['fecha_ini'];
					 if (!is_numeric($aRetVal['_periodo']) AND empty($aRetVal['_fin']) AND !empty($aTmp['fecha_fin'])) $aRetVal['_fin'] = $aTmp['fecha_fin'];

					 if (sizeof($aRetVal) OR is_numeric($aR['indicador'])) {
								if (is_array($aTmp) AND sizeof($aTmp)) {
										  foreach ($aTmp as $fld => $val) {
													 if (!in_array($fld,$aExclude)) $aRetVal[$fld] = $val;
										  }
										  if (!empty($graph_field)) {
													 $aG[$graph_field] = $aTmp[$graph_field];
										  } else $aG[$aR['indicador']] = $aTmp[$aR['indicador']];
								} else {
										  $aRetVal[$aR['indicador']] = 0;
								}
					 }
		  }

		  if (is_array($aG) AND sizeof($aG)) {
					 // Preparando Grafica:
					 $aGraficas = $Sesion->get_var('dsb_graficas_lineal');
					 if (!is_array($aGraficas)) $aGraficas = array();
					 foreach ($aG as $indicador => $valor) {
								$aGraficas[$indicador][$aRetVal['_periodo']] = $valor;
					 }
					 $aGraficas = $Sesion->set_var('dsb_graficas_lineal',$aGraficas,'INMED');

					 $Sesion->set_var('mostrar_grafica',1,'INMED');
		  } else {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
		  }


		  $n++;
		  return $aRetVal;
}

function nodb_dsb_resultados_anual(&$Sesion) {
		  static $aRs;
		  static $aStatus;
		  static $n = 0;
		  static $aGraphField;
		  static $aExclude = array('Anyo', 'nombre', 'fecha_ini', 'fecha_fin', 'numero_relativo');

		  $oDb = &$Sesion->get_db('data');
		  // debug("<hr>");

		  $aRetVal = NULL;
		  $var = $Sesion->get_var('dsb_resultados');

		  if (!is_numeric($aStatus['a_limit'])) {
					 $aStatus['a_limit'] = $Sesion->get_var('dsb_an_limit');
					 if (!is_numeric($aStatus['a_limit'])) $aStatus['a_limit'] = 3;
		  }

		  if (!is_array($aRs) OR $var != $aStatus['last_var']) {
					 // debug("Reseteando el numero relativo actual .. ");
					 $aStatus['numero_relativo_actual'] = NULL;
					 $aStatus['fecha'] = $Sesion->get_var('_dsb_fecha');
					 if (empty($aStatus['fecha'])) return NULL;
					 $aStatus['time'] = strtotime(wol_db::formatear_fecha($aStatus['fecha'],false));
					 $aStatus['anyo_inicial'] = date('Y',$aStatus['time']);

					 // Preparamos para que se muestre la cabecera con los anyos
					 $aRetVal['poner_cabecera'] = 1;
					 $Sesion->set_var('_iterate_reset',1,'INMED');
					 $Sesion->set_var('_iterate_times',$aStatus['a_limit'],'INMED');
					 for ($i = 0; $i < $aStatus['a_limit']; $i++) $aAnyos[$i] = ($aStatus['anyo_inicial']-$i);
					 $Sesion->set_var('_dsb_resultados_anual_anyos',$aAnyos,'INMED');
					 $aStatus['lista_anyos'] = $aAnyos;

					 $aGraphField = $Sesion->get_var('dsb_grfx_field');
					 $aRs = $Sesion->get_var('dsb_rs_'.$var);
					 $aStatus['last_var'] = $var;
					 if (!is_array($aRs) OR !sizeof($aRs)) return NULL;

					 $n = 0;
					 $aStatus['n_limit'] = NULL;
		  }

		  // Comprobamos los limites
		  if (!is_numeric($aStatus['n_limit'])) {
					 $aStatus['n_limit'] = $Sesion->get_var('dsb_rs_limit');
					 if (!is_numeric($aStatus['n_limit'])) $aStatus['n_limit'] = 5;
		  }
		  if ($n >= $aStatus['n_limit']) return NULL;

		  // Primero buscamos a ver cual es el siguiente numero de grupo, y si alguno la tiene
		  $bPrimeraVez = false;
		  $bBreak = false;
		  $aNumRel = array(); // Lista de los numeros relativos siguientes.
		  foreach ($aRs as $p => $aR) {
					 if (!is_numeric($aR['row_num'])) $aRs[$p]['row_num'] = 0;
					 $oDb->data_seek($aRs[$p]['res'],$aRs[$p]['row_num']);

					 // debug("Pos $p .. de ".sizeof($aRs));
					 // Obtenemos el Siguiente registro:
					 while ($aTmp = $oDb->fetch_assoc($aR['res'])) {
								if (!is_numeric($aStatus['numero_relativo_actual']) OR !is_numeric($aNumRel[$p])) {
										  // La primera vez, y no tenemos un numero en curso, asignamos el primero.
										  if (!is_numeric($aStatus['numero_relativo_actual'])) {
													 // debug("La primera vez, asignamos el numero relativo: ".$aTmp['numero_relativo']);
													 $aStatus['numero_relativo_actual'] = $aTmp['numero_relativo'];
													 $aStatus['anyo_relativo_actual'] = $aTmp['Anyo'];
													 $bPrimeraVez = true;
										  }
										  // debug("A falta de seguir mirando(".$aRs[$p]['row_num'].") .. asignamos($p) el numero relativo: ".$aTmp['numero_relativo']);
										  // print_r($aTmp);
										  $aNumRel[$p] = $aTmp['numero_relativo'];
								} else {
										  //debug("(PV:$bPrimeraVez)Analizando(".$aTmp['numero_relativo'].") en la posicion($p) tenemos ".$aNumRel[$p]." con un top de ".$aStatus['numero_relativo_actual']);
										  // Si es la primera vez: Buscamos el numero relativo mas alto. (Si el que hay para esta pos no es ya menor)
										  // Si _no_ es la primera vez: Buscamos el numero relativo mas bajo. (Si el que hay para esta pos no es ya mayor)
										  if ( ($bPrimeraVez AND $aStatus['anyo_relativo_actual']==$aTmp['Anyo'] AND $aStatus['numero_relativo_actual'] >= $aNumRel[$p] 
																					 AND $aNumRel[$p] < $aTmp['numero_relativo'] ) OR
																(!$bPrimeraVez AND $aStatus['numero_relativo_actual'] > $aTmp['numero_relativo']
																 AND ($aNumRel[$p]-$aStatus['numero_relativo']) < ($aTmp['numero_relativo']-$aStatus['numero_relativo'])) ) {
													 // debug("(PV:$bPrimeraVez) asignamos en posicion($p); ".$aTmp['numero_relativo']);
													 $aNumRel[$p] = $aTmp['numero_relativo'];
										  }
								}
					 }

					 // Restauramos puntero al resultado.
					 // debug("Res $p re-colocado en : ".$aRs[$p]['row_num']);
					 $oDb->data_seek($aRs[$p]['res'],$aRs[$p]['row_num']);
		  }
		  if (sizeof($aNumRel)) {
					 arsort($aNumRel);
					 reset($aNumRel);
					 list($pos,$numr) = each($aNumRel);
					 reset($aNumRel);
					 // debug("PrimeraVez($bPrimeraVez) RelativoActual(".$aStatus['numero_relativo_actual'].") ");
										  
					 if (!$bPrimeraVez AND $aStatus['numero_relativo_actual']==1) return NULL;
					 elseif ( $numr != $aStatus['numero_relativo_actual']) {
								// debug("asignamos el $numr cuando teniamos: ".$aStatus['numero_relativo_actual']);
								$aStatus['numero_relativo_actual'] = $numr;
					 } elseif (!$bPrimeraVez) {
								// debug("Repetimos el numero relativo? ");
								return NULL;
					 }
		  }
		  // debug("Numero Actual: ".$aStatus['numero_relativo_actual']);
		  if (!is_numeric($aStatus['numero_relativo_actual'])) return NULL;

		  foreach ($aRs as $p => $aR) {
					 // Por cada indicador(consulta), buscamos los X anyos, y por consiguiente sus valores.
					 $bDesplazar = true;
					 foreach ($aStatus['lista_anyos'] as $i => $anyo) {
								// debug("Anyo $i -> $anyo ");
								$bFound = false;
								$bYearFound = false;
								while ($aTmp = $oDb->fetch_assoc($aR['res'])) {
										  if ($aTmp['Anyo'] != $anyo) continue;
										  $bYearFound = true;
										  // debug("($p) Comprarando relativo ".$aStatus['numero_relativo_actual']." con ".$aTmp['numero_relativo']);
										  if ($aTmp['numero_relativo'] != $aStatus['numero_relativo_actual']) continue;
										  $bFound = true;
										  break;
								}
								// debug("Encontrado: $bFound, idxanual($i) ");
								// Si no hemos encontrado el valor para el primer anyo, no desplzamos resultado.
								if (!$bFound AND $i == 0 AND $bYearFound) $bDesplazar = false;

								if (!$bFound) {
										  $aVal[$aR['indicador']][$i]['value'] = '--';
										  $aG[$aR['indicador']][$anyo]['value'] = 0;
								} else {
										  if (empty($aRetVal['_periodo'])) {
													 $aRetVal['_periodo'] = $aTmp[$aR['periodo']];
										  }
										  if (empty($aRetVal['_anyo'])) $aRetVal['_anyo'] = $aTmp['Anyo'];
										  if (empty($aRetVal['_inicio'])) $aRetVal['_inicio'] = $aTmp['fecha_ini'];
										  if (empty($aRetVal['_fin'])) $aRetVal['_fin'] = $aTmp['fecha_fin'];

										  // Almacenando valores para este indicador .. 
										  if (is_array($aTmp) AND sizeof($aTmp)) {
													 foreach ($aTmp as $fld => $val) {
																if (!in_array($fld,$aExclude)) {
																		  $aVal[$fld][$i]['value'] = $val;
																		  $aG[$fld][$anyo]['value'] = $val;
																}
													 }
													 /** **
													 debug("graph field: $aGraphField ");
													 if (!empty($graph_field)) {
																$aG[$graph_field][$anyo]['value'] = $aTmp[$graph_field];
													 } else $aG[$aR['indicador']][$anyo]['value'] = $aTmp[$aR['indicador']];
													 /** **/

													 // $aVal[$aR['indicador']][$i]['value'] = $aTmp[$aR['indicador']];
													 // $aG[$aR['indicador']][$anyo]['value'] = $aTmp[$aR['indicador']];
										  } else {
													 $aRetVal[$aR['indicador']][$i]['value'] = 0;
										  }
								}
								$oDb->data_seek($aRs[$p]['res'],$aRs[$p]['row_num']);
					 }
					 // Solo avanzamos el cursor si hemos encontrado resultado.
					 // debug("Hemos encontrado algo? ($bDesplazar) ");
					 if ($bDesplazar) $aRs[$p]['row_num']++;
		  }

		  if (is_array($aVal) AND sizeof($aVal)) {
					 // Calculamos los percentiles deferenciales entre valores.
					 foreach ($aVal as $f => $aV) {
								if (is_array($aV) AND sizeof($aV)) {
										  foreach ($aV as $ia => $aVl) {
													 if (is_array($aV[$ia+1]) AND sizeof($aV[$ia+1]) AND is_numeric($aV[$ia]['value']) AND is_numeric($aV[$ia+1]['value'])) {
																if ($aV[$ia]['value'] != 0) {
																		  // $aVal[$f][$ia]['pto'] = ( ($aV[$ia]['value']-$aV[$ia+1]['value'])*100 / $aV[$ia]['value'] );
																		  // $aG[$f][$aStatus['lista_anyos'][$ia]]['pto'] = ( ($aV[$ia]['value']-$aV[$ia+1]['value'])*100 / $aV[$ia]['value'] );
																		  $aVal[$f][$ia]['pto'] = ( ($aV[$ia]['value']/$aV[$ia+1]['value']) - 1 ) * 100;
																		  $aG[$f][$aStatus['lista_anyos'][$ia]]['pto'] = ( ($aV[$ia]['value']/$aV[$ia+1]['value']) - 1 ) * 100;
																} else {
																		  $aVal[$f][$ia]['pto'] = 0;
																		  $aG[$f][$aStatus['lista_anyos'][$ia]]['pto'] = 0;
																}
													 }
										  }
								}
					 }

					 $Sesion->set_var('_dsb_resultados_anual_indicadores',$aVal,'SUBSECCION');

					 if (is_array($aG) AND sizeof($aG)) {
								// Preparando Grafica:
								$aGraficas = $Sesion->get_var('dsb_graficas');
								if (!is_array($aGraficas)) $aGraficas = array();
								foreach ($aG as $indicador => $aGra) {
										  foreach ($aGra as $anyo => $valor) {
													 $aGraficas[$indicador][$anyo][$aRetVal['_periodo']] = $valor;
										  }
								}
								$aGraficas = $Sesion->set_var('dsb_graficas',$aGraficas,'INMED');

								$Sesion->set_var('mostrar_grafica',1,'INMED');
					 } else {
								$Sesion->set_var('mostrar_grafica',0,'INMED');
					 }

		  }

		  $n++;
		  return $aRetVal;
}

function dsb_grfx_comparadas (&$Sesion,$aParam) {
		  if (!is_array($aParam) OR !sizeof($aParam)) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $indicador = array_shift($aParam);
		  $campo = array_shift($aParam);
		  $aG = $Sesion->get_var('dsb_graficas');
		  if (!is_array($aG[((!empty($campo)) ? $campo : $indicador)]) OR !sizeof($aG[((!empty($campo)) ? $campo : $indicador)])) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $Sesion->set_var('mostrar_grafica',1,'INMED');

		  $aGrupos = array();
		  $aGrafica = array();
		  if (!empty($campo)) $fld = $campo;
		  else $fld = $indicador;
		  // print_r($aG);
		  foreach ($aG[$fld] as $anyo => $aGr) {
					 // $grf_name = $indicador.$anyo;
					 $grf_name = $fld.$anyo;
					 // Vamos a hacer una grafica por anyo. La leyenda/colores seran las agrupaciones.
					 $aGrafica['charts'] .= ((!empty($aGrafica['charts'])) ? ' ' : '').$grf_name;

					 $aGrfx = NULL;
					 foreach ($aGr as $grupo => $aV) {
								if (!in_array($grupo,$aGrupos)) array_push($aGrupos,$grupo);
								$idx = array_search($grupo,$aGrupos);
								$aGrfx[$idx]['data'] = $aV['value'];
								if (!empty($aV['pto'])) {
										  $aGrfx[$idx]['label'] = lcdec($aV['value'],$Sesion).' ('.lcpto($aV['pto'],$Sesion).'%)';
								}
					 }

					 $aGrfx['titulo'] = $anyo;
					 $Sesion->set_var($grf_name,$aGrfx,'INMED');
		  }
		  if (!is_array($aGrupos) OR !sizeof($aGrupos)) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $Sesion->set_var('grafica',$aGrafica,'INMED');

		  if (!is_array($aLeyenda) OR !sizeof($aLeyenda)) {
					 $aLeyenda = array();
					 foreach ($aGrupos as $idx => $val) {
								$aLeyenda[$idx]['nombre'] = $val;
					 }
					 $Sesion->set_var('leyenda',$aLeyenda);
		  }

		  // $Sesion->unset_var('dsb_graficas');
		  return NULL;
}

function dsb_grfx_horizontal (&$Sesion,$aParam) {
		  if (!is_array($aParam) OR !sizeof($aParam)) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $indicador = array_shift($aParam);
		  $campo = array_shift($aParam);
		  $aG = $Sesion->get_var('dsb_graficas_lineal');
		  if (!is_array($aG[((!empty($campo)) ? $campo : $indicador)]) OR !sizeof($aG[((!empty($campo)) ? $campo : $indicador)])) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $Sesion->set_var('mostrar_grafica',1,'INMED');

		  $aGrupos = array();
		  $aGrafica = array();

		  $grf_name = 'graph_'.$indicador;
		  // debug("indicador ($indicador) campo ($campo) ");
		  if (!empty($campo)) $indicador = $campo;
		  // Vamos a hacer una grafica por anyo. La leyenda/colores seran las agrupaciones.
		  $aGrafica['charts'] .= ((!empty($aGrafica['charts'])) ? ' ' : '').$grf_name;
		  foreach ($aG[$indicador] as $grupo => $valor) {
					 if (!in_array($grupo,$aGrupos)) array_push($aGrupos,$grupo);
					 $idx = array_search($grupo,$aGrupos);
					 $aGrfx[$idx]['data'] = $valor;
					 // $aGrfx[$idx]['label'] = $valor.' (+-X%)';
		  }
		  $Sesion->set_var($grf_name,$aGrfx,'INMED');

		  if (!is_array($aGrupos) OR !sizeof($aGrupos)) {
					 $Sesion->set_var('mostrar_grafica',0,'INMED');
					 return NULL;
		  }
		  $Sesion->set_var('grafica',$aGrafica,'INMED');

		  if (!is_array($aLeyenda) OR !sizeof($aLeyenda)) {
					 $aLeyenda = array();
					 foreach ($aGrupos as $idx => $val) {
								$aLeyenda[$idx]['nombre'] = $val;
					 }
					 $Sesion->set_var('leyenda',$aLeyenda);
		  }

		  // $Sesion->unset_var('dsb_graficas_lineal');
		  return NULL;
}

function dsb_resultados_anual_anyo($pos,&$Sesion){
		  $aV = $Sesion->get_var('_dsb_resultados_anual_anyos');
		  if (!is_array($aV) OR !sizeof($aV) OR !isset($aV[($pos-1)]) ) return NULL;
		  return $aV[$pos-1];
}

function dsb_resultados_anual_valor($pos,&$Sesion){
		  $indicador = $Sesion->get_var('_dsb_resultados_anual_valor');
		  if (empty($indicador)) return NULL;
		  $aV = $Sesion->get_var('_dsb_resultados_anual_indicadores');
		  if (!is_array($aV) OR !sizeof($aV)) return NULL;
		  $retval = $aV[$indicador][($pos-1)]['value'];
		  if (!empty($aV[$indicador][($pos-1)]['pto'])) {
					 $retval = lcdec($retval,$Sesion).' ('.lcpto($aV[$indicador][($pos-1)]['pto'],$Sesion).'%) ';
		  }
		  return ((is_numeric($retval)) ? lcdec($retval,$Sesion) : $retval);
}

?>
