<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.																								 **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y							  **
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre				**
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo	 **
**    hiciese.																																																												**
**																																																																																		  **
** Para mas informacion referente a la licencia de esta											 **
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On	 **
**    Line Studios S.L. para recibir una copia del mismo											 **
**																																																																										  **
** Informacion de Contacto																																										  **
**    Josafat Moragrega Fernandez																																		 **
**    Engineering																																																								 **
**    Director Tecnico																																														 **
**    tite@wolstudios.com																																																					 **
**    C/Alcala 18 3º Izda, 28014 Madrid, España														 **
**																																																																																		  **
**										  (c) Web On Line Studios S.L.																																	 **
**                                                              **
******************************************************************
*****************************************************************/


include("../escritorio/config.php");									/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$db = $Sesion->get_db('data');
$DEBUG = "ON";

global $fecha;
global $fecha_fin;
global $sep;
global $usar_facturas;
global $solo_estimado;

// global $_FILES;
if (empty($sep)) $sep = "\t";
else if (!strcasecmp($sep,"\\\\t")) {
	$sep = "\t";
}

if (!isset($fecha) OR !strcasecmp(wol_db::formatear_fecha($fecha),'null') ) {
	salida("Debe indicar todos los campos del formulario.<br/>\n");
	exit;
}
$id_empresa = 1;
if (!isset($fecha_fin) OR !strcasecmp(wol_db::formatear_fecha($fecha_fin),'null') ) {
	$fecha_fin = 'now()';
} else $fecha_fin = wol_db::formatear_fecha($fecha_fin);
	
$file_name = $_FILES['inventario']['tmp_name'];
if (!empty($file_name)) {
	$aStock = file($file_name);
} else {
	$solo_estimado = 1;
	$cons = 'SELECT A.id_articulo,SUM(L.cantidad) as "stock" FROM Articulos A LEFT JOIN Localizacion_articulos L ON (L.id_articulo=A.id_articulo) GROUP BY A.id_articulo ';
	$rs = $db->query($cons);
	if (!$db->num_rows($rs)) die("No hay stock en la bdd ");
	$sep = ',';
	while ($aTmp = $db->fetch_assoc($rs)) {
		$aStock[$aTmp['id_articulo']] = $aTmp['id_articulo'].','.(float)$aTmp['stock'];
	}
}

$usar_facturas = (int)$usar_facturas;

parse_csvline(NULL,NULL,array('id_articulo','stock'));
$fmtfecha = wol_db::formatear_fecha($fecha);
?>
<html>
<head>
</head>
<body>
<?php

	echo 'id_articulo,';
	echo 'AntiguoStockEstimado,'; 
	echo 'Recibido,'; 
	echo 'Enviado,'; 
	echo 'StockInventariado,'; 
	echo 'StockActual,'; 
	echo 'CompradoPendiente,'; 
	echo 'VendidoPendiente,'; 
	echo 'StockEstimado<br>'; 

foreach ($aStock as $linea) {

	$aArt = parse_csvline($linea,$sep);
	if (!is_numeric($aArt['stock'])) {
		debug('El articulo '.$aArt['id_articulo'].' _no_ tiene stock ');
		continue;
	}

	$idrs = $db->query('SELECT Articulos.id_articulo, Articulos.nombre, Articulos.descripcion, Empresas_articulos.stock_ficticio FROM Articulos, Empresas_articulos '.
								'WHERE Articulos.id_articulo = '.$aArt['id_articulo'].
								' AND Empresas_articulos.id_articulo = Articulos.id_articulo AND Empresas_articulos.id_empresa = '.
								$id_empresa);
	if (!$db->num_rows($idrs)) {
		// salida("El id Articulo ".$aArt['id_articulo']." _no_ existe en la empresa $id_empresa <hr/>\n");
		continue;
	} else {
		$aTmp = $db->fetch_assoc($idrs);
		$aArt['nombre'] = $aTmp['nombre'];
		$aArt['descripcion'] = $aTmp['descripcion'];
		$aArt['antiguo_stock'] = $aTmp['stock_ficticio'];
	}
	$db->libera($idrs);

	if (!(int)$solo_estimado) {
		// Calculamos Compras.
		if ($usar_facturas) {
			$cons = 'SELECT SUM(Fd.cantidad) as "cantidad" '.
						'FROM Facturas_detalle Fd, Lineas_detalle Ld, Facturas F '.
						'WHERE Fd.id_detalle = Ld.id_detalle AND (F.id_cliente = 0 OR F.id_cliente IS NULL) AND Fd.id_factura = F.id_factura '.
						'AND F.fecha >= '.$fmtfecha.' AND F.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' '.
						'GROUP BY Ld.id_articulo ';
			$idrs = $db->query($cons);
		} else {
			$cons = 'SELECT SUM(Da.cantidad) as "cantidad" '.
						'FROM Detalles_albaran Da, Lineas_detalle Ld, Albaranes A, Pedidos P '.
						'WHERE Da.id_detalle = Ld.id_detalle AND Da.id_albaran=A.id_albaran AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.
						'AND A.id_pedido = P.id_pedido AND A.fecha >= '.$fmtfecha.' AND A.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' '.
						'GROUP BY Ld.id_articulo ';
			$idrs = $db->query($cons);
		}
		// debug($cons);

		if ($db->num_rows($idrs)) {
			$aTmp = $db->fetch_row($idrs);
			$compra = $aTmp[0];
		} else {
			$compra = 0;
		}
		$db->libera($idrs);

		// Calculamos Ventas.
		if ($usar_facturas) {
			$cons = 'SELECT SUM(Fd.cantidad) '.
						'FROM Facturas_detalle Fd, Lineas_detalle Ld, Facturas F '.
						'WHERE Fd.id_detalle = Ld.id_detalle AND (F.id_proveedor = 0 OR F.id_proveedor IS NULL) AND Fd.id_factura = F.id_factura '.
						'AND F.fecha >= '.$fmtfecha.' AND F.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' '.
						'GROUP BY Ld.id_articulo ';
			$idrs = $db->query($cons);
		} else {
			$cons = 'SELECT SUM(Da.cantidad) as "cantidad" '.
						'FROM Detalles_albaran Da, Lineas_detalle Ld, Albaranes A, Pedidos P '.
						'WHERE Da.id_detalle = Ld.id_detalle AND Da.id_albaran=A.id_albaran AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.
						'AND A.id_pedido = P.id_pedido AND A.fecha >= '.$fmtfecha.' AND A.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' '.
						'GROUP BY Ld.id_articulo ';
			$idrs = $db->query($cons);
		}

		if ($db->num_rows($idrs)) {
			$aTmp = $db->fetch_row($idrs);
			$venta = $aTmp[0];
		} else {
			$venta = 0;
		}
		$db->libera($idrs);

		$cantidad_act = $aArt['stock'] + ($compra - $venta);

		// Calculamos _estimacion_ de Compras.
		if ($usar_facturas) {
			$cons_real = 'SELECT SUM(Fd.cantidad) as "cantidad" '.
						'FROM Facturas_detalle Fd, Lineas_detalle Ld, Facturas F '.
						'WHERE Fd.id_detalle = Ld.id_detalle AND (F.id_cliente = 0 OR F.id_cliente IS NULL) AND Fd.id_factura = F.id_factura '.
						'AND F.fecha >= '.$fmtfecha.' AND F.fecha <= '.$fecha_fin.' AND Pf.id_factura=F.id_factura AND Pf.id_pedido=P.id_pedido '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 '.
						'GROUP BY Ld.id_articulo ';
		} else {
			$cons_real = 'SELECT SUM(Da.cantidad) as "cantidad" '.
						'FROM Detalles_albaran Da, Lineas_detalle Ld, Albaranes A, Pedidos P '.
						'WHERE Da.id_detalle = Ld.id_detalle AND Da.id_albaran=A.id_albaran AND (P.id_direccion = 0 OR P.id_direccion IS NULL) '.
						'AND A.id_pedido = P.id_pedido AND A.fecha >= '.$fmtfecha.' AND A.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 '.
						'GROUP BY Ld.id_articulo ';
		}
		// debug($cons_real);
	} else $cantidad_act = $aArt['stock'];

	$cons = 'SELECT SUM(Ld.cantidad) as "cantidad" '.
				'FROM Lineas_detalle Ld, Pedidos P LEFT JOIN Pedidos_facturas PF ON (P.id_pedido=PF.id_pedido) '.
				'WHERE (P.id_direccion = 0 OR P.id_direccion IS NULL) AND Ld.id_pedido = P.id_pedido '.
				'AND P.fecha >= '.$fmtfecha.' AND P.fecha <= '.$fecha_fin.' '.
				'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 AND PF.id_factura IS NULL '.
				'GROUP BY Ld.id_articulo ';
	$idrs_tot = $db->query($cons);
	// debug($cons);

	if ($db->num_rows($idrs_tot)) {
		$aTmp = $db->fetch_row($idrs_tot);
		if (!empty($cons_real)) {
			$idrs_real = $db->query($cons_real);
			$aTmpR = $db->fetch_row($idrs_real);
		}
		$estimado_compra = $aTmp[0] - $aTmpR[0];
		if (!empty($cons_real)) $db->libera($idrs_real);
	} else {
		$estimado_compra = 0;
	}
	$db->libera($idrs_tot);

	if (!(int)$solo_estimado) {
		// Calculamos _estimacion_ de Ventas.
		if ($usar_facturas) {
			$cons_real = 'SELECT SUM(Fd.cantidad) as "cantidad" '.
						'FROM Facturas_detalle Fd, Lineas_detalle Ld, Facturas F '.
						'WHERE Fd.id_detalle = Ld.id_detalle AND (F.id_proveedor = 0 OR F.id_proveedor IS NULL) AND Fd.id_factura = F.id_factura '.
						'AND F.fecha >= '.$fmtfecha.' AND F.fecha <= '.$fecha_fin.' AND Pf.id_factura=F.id_factura AND Pf.id_pedido=P.id_pedido '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 '.
						'GROUP BY Ld.id_articulo ';
		} else {
			$cons_real = 'SELECT SUM(Da.cantidad) as "cantidad" '.
						'FROM Detalles_albaran Da, Lineas_detalle Ld, Albaranes A, Pedidos P '.
						'WHERE Da.id_detalle = Ld.id_detalle AND Da.id_albaran=A.id_albaran AND (P.id_proveedor = 0 OR P.id_proveedor IS NULL) '.
						'AND A.id_pedido = P.id_pedido AND A.fecha >= '.$fmtfecha.' AND A.fecha <= '.$fecha_fin.' '.
						'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 '.
						'GROUP BY Ld.id_articulo ';
		}
		// debug($cons_real);
	}

	$cons = 'SELECT SUM(Ld.cantidad) as "cantidad" '.
				'FROM Lineas_detalle Ld, Pedidos P '.
				'WHERE (P.id_proveedor = 0 OR P.id_proveedor IS NULL) AND P.id_pedido = Ld.id_pedido '.
				'AND P.fecha >= '.$fmtfecha.' AND P.fecha <= '.$fecha_fin.' '.
				'AND Ld.id_articulo = '.$aArt['id_articulo'].' AND P.preparado = 0 '.
				'GROUP BY Ld.id_articulo ';
	$idrs_tot = $db->query($cons);
	// debug($cons);

	if ($db->num_rows($idrs_tot)) {
		$aTmp = $db->fetch_row($idrs_tot);
		if (!empty($cons_real)) {
			$idrs_real = $db->query($cons_real);
			$aTmpR = $db->fetch_row($idrs_real);
		}
		$estimado_venta = $aTmp[0] - $aTmpR[0];
		if (!empty($cons_real)) $db->libera($idrs_real);
	} else {
		$estimado_venta = 0;
	}
	$db->libera($idrs_tot);
	$stock_estimado = $cantidad_act + ($estimado_compra - $estimado_venta);

	echo $aArt['id_articulo'].',';
	echo $aArt['antiguo_stock'].','; 
	echo $compra.','; 
	echo $venta.','; 
	echo $aArt['stock'].','; 
	echo $cantidad_act.','; 
	echo $estimado_compra.','; 
	echo $estimado_venta.','; 
	echo $stock_estimado.'<br>'; 

	$cons = 'Update Empresas_articulos set stock_ficticio='.$stock_estimado.' '.
				'WHERE id_articulo='.$aArt['id_articulo'].' AND id_empresa = '.$id_empresa;
	// debug($cons);
	$db->query($cons);

	if (!(int)$solo_estimado) {
		// $cons = 'UPDATE Localizacion_articulos SET cantidad = 0 WHERE id_articulo = '.$aArt['id_articulo'];
		$cons = 'SELECT id_articulo FROM Localizacion_articulos WHERE id_articulo = '.$aArt['id_articulo'];
		$tmprs = $db->query($cons);
		if (!$db->num_rows($tmprs)) {
			// debug("Referencia inexistente ... creando una. ");
			$db->tb_insert('Localizacion_articulos',array('id_articulo' => $aArt['id_articulo'],'id_almacen_logico' => 1, 'cantidad' => $cantidad_act));
		} else {
			$db->query('UPDATE Localizacion_articulos SET cantidad = 0 WHERE id_articulo = '.$aArt['id_articulo']);
			$cons = 'UPDATE Localizacion_articulos SET cantidad = '.$cantidad_act.
						' WHERE id_articulo = '.$aArt['id_articulo'].' LIMIT 1';
			$db->query($cons);
		}
	}

	$cantidad_act = 0;
	$compra = 0;
	$vanta = 0;
	$estimado_compra = 0;
	$estimado_venta = 0;
	$stock_estimado = 0;
}

function parse_csvline($cdrline,$sep = ',',$aStruct = NULL) {
	static $aOrden;
	if (!is_array($aOrden) AND is_array($aStruct)) $aOrden=$aStruct;
	elseif (!is_array($aOrden) AND !is_array($aStruct)) {
		salida("Error: No hay estructura");
		return NULL;
	}
	if (empty($cdrline)) return NULL;
	// 0 	=> 'accountcode',
	// 9 	=> 'Fecha Inicio',
	$aCDR = array();
	$i = 0;

	$line = trim($cdrline);
	if (empty($line)) return NULL;

	$aLine = split($sep,$line);
	foreach ($aLine as $i => $term) {
		if ($term{0} == '"') $term = substr($term,1);
		if ($term{strlen($term)-1} == '"') $term = substr($term,0,-1);
		$aCDR[$aOrden[$i]] = $term;
	}

	return $aCDR;
}

?>
</body>
</html>
