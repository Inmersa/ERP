<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/formularios.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/fichas.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/bordescolores.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/tipografia.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/print/base.css" type="text/css" media="print" >

</head>
<body>
<?php
    
function lcredec($dato,&$Sesion) {
	static $lcfmt;
	if (!is_array($lcfmt)) $lcfmt = localeconv();
	if (!is_numeric($dato) AND empty($dato)) return $dato;
	// debug('lcdec('.$dato.') ..');
	$lcfmt['frac_digits'] = 2;
	$lcfmt['decimal_point'] = ',';
	$lcfmt['thousands_sep'] = '.';
	return number_format($dato,$lcfmt['frac_digits'],$lcfmt['decimal_point'],$lcfmt['thousands_sep']);
}


include("../escritorio/config.php");									/**	  StartUp Config **/
// include("../escritorio/kernel_nocifrado.inc");
include("kernel_nocifrado.inc");
$DEBUG='ON';

$BioMundoGestion = new wolSesion($APP_NAME,"BioMundoGestion"); 
$BioMundoGestion->init($seccion);
$oDb = $BioMundoGestion->get_db('data');

global $f;
global $mi;
global $mf;
global $s;

if (!isset($f) OR empty($f) OR !strcasecmp('null',wol_db::formatear_fecha($f,FALSE))) 
	$f = date('Y-m-d');
else $f = wol_db::formatear_fecha($f,false);

$time = strtotime($f);
if (!empty($a)) $anyo = $a;
if (empty($anyo)) $anyo = date('Y',$time);
if (empty($mi) and empty($mf)) {
	$mesi = $mesf = $mes = date('m',$time);
} else {
	if (empty($mi)) $mesi = date('m',$time);
	else $mesi = $mi;
	if (empty($mf)) $mesf = date('m',$time);
	else $mesf = $mf;
}

$f_ini = $anyo.'-'.$mesi.'-00 00:00:00';
$f_fin = $anyo.'-'.$mesf.'-31 23:59:59';
$n_dec = 2;
$campo_precio = 'precio_costo';

?>
<table class="full">
<thead style="background-color: #DDDDDD;" ><tr>
<td>Serie de Facturacion</td>
<td>Base Imponible</td>
<td>Total Impuestos</td>
<td>Monto Total</td>
</tr></thead>
<tbody>
<?php
$cons = 'SELECT ROUND(SUM(IF((Facturas.factura_abono>0),(Facturas.base_imponible*-1),Facturas.base_imponible)),'.$n_dec.') as "base_imponible", '.
	'ROUND(SUM(IF((Facturas.factura_abono>0),(Facturas.total_impuestos*-1),Facturas.total_impuestos)),'.$n_dec.') as "total_impuestos", '.
	'ROUND(SUM(IF((Facturas.factura_abono>0),(Facturas.monto_total*-1),Facturas.monto_total)),'.$n_dec.') as "monto_total", '.
	'S.id_serie, S.nombre, S.ventas '.
	'FROM Facturas JOIN Series_facturacion S ON (S.id_serie=Facturas.id_serie) '.
	'WHERE '.
	'Facturas.fecha BETWEEN "'.$f_ini.'" AND "'.$f_fin.'" '.
	'GROUP BY S.id_serie '.
	'ORDER BY S.ventas desc, S.id_serie asc ';
// debug($cons);
$last_tipo = NULL;
$resfa = $oDb->query($cons);
$n_r = $oDb->num_rows($resfa);
$aTotales = array();
if ($oDb->num_rows($resfa)) {
	while ($aTmp = $oDb->fetch_assoc($resfa)) {
		if ($aTmp['base_imponible'] != 0) {
			?>
			<tr>
			<td>Serie <?php echo $aTmp['nombre']; ?> (ID:<?php echo $aTmp['id_serie']; ?> - DeVenta: <?php echo (($aTmp['ventas']) ? 'Si' : 'No'); ?>)</td>
			<td><?php echo lcredec($aTmp['base_imponible'],$BioMundoGestion); ?></td>
			<td><?php echo lcredec($aTmp['total_impuestos'],$BioMundoGestion); ?></td>
			<td><?php echo lcredec($aTmp['monto_total'],$BioMundoGestion); ?></td>
			</tr>
			<?php
			$aTotales[$aTmp['ventas']]['base_imponible'] += $aTmp['base_imponible'];
			$aTotales[$aTmp['ventas']]['total_impuestos'] += $aTmp['total_impuestos'];
			$aTotales[$aTmp['ventas']]['monto_total'] += $aTmp['monto_total'];
		} else {
			?>
			<tr><td colspan="4">No hay Facturacion para la Serie <?php echo $aTmp['nombre']; ?> (<?php echo $aTmp['id_serie']; ?>) 
			tal mes como el <?php echo $mes." del ".$anyo; ?></td></tr>
			<?php
		}
	}
}
?>
<tr>
<td style="font-weight: bold;" >Total en Ventas</td>
<td><?php echo lcredec($aTotales[1]['base_imponible'],$BioMundoGestion); ?></td>
<td><?php echo lcredec($aTotales[1]['total_impuestos'],$BioMundoGestion); ?></td>
<td><?php echo lcredec($aTotales[1]['monto_total'],$BioMundoGestion); ?></td>
</tr>
<tr>
<td style="font-weight: bold;" >Total en Compras</td>
<td><?php echo lcredec($aTotales[0]['base_imponible'],$BioMundoGestion); ?></td>
<td><?php echo lcredec($aTotales[0]['total_impuestos'],$BioMundoGestion); ?></td>
<td><?php echo lcredec($aTotales[0]['monto_total'],$BioMundoGestion); ?></td>
</tr>
<tr>
<?php $beneficio = ($aTotales[1]['base_imponible'] - $aTotales[0]['base_imponible']); ?>
<td style="font-weight: bold;" >Beneficio Bruto</td>
<td><?php echo lcredec($beneficio,$BioMundoGestion); ?></td>
<td><?php echo (($aTotales[1]['base_imponible']!=0) ? round(($beneficio*100/$aTotales[1]['base_imponible']),$n_dec) : 0);?> % Sobre Ventas</td>
<td><?php echo (($aTotales[0]['base_imponible']!=0) ? round(($beneficio*100/$aTotales[0]['base_imponible']),$n_dec) : 0);?> % Sobre Compras</td>
</tr>
</tbody></table>

<?php

$aTmp = NULL;
$cons = 'SELECT SUM(monto) as "cobrados_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 1 AND '.
	'fecha_abono BETWEEN "'.$f_ini.'" AND "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['cobrados_hoy'] = $aTst['cobrados_hoy'];
} else $aEfectos['cobrados_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "vto_mayor_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 1 AND '.
	'fecha_vencimiento > "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['vto_mayor_hoy'] = $aTst['vto_mayor_hoy'];
} else $aEfectos['vto_mayor_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "vto_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 1 AND '.
	'fecha_vencimiento BETWEEN "'.$f_ini.'" AND "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['vto_hoy'] = $aTst['vto_hoy'];
} else $aEfectos['vto_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "pte_vto_menor_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 0 AND '.
	'fecha_vencimiento <= "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['pte_vto_menor_hoy'] = $aTst['pte_vto_menor_hoy'];
} else $aEfectos['pte_vto_menor_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "pendientes" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 0 ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['pendientes'] = $aTst['pendientes'];
} else $aEfectos['pendientes'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

?>
<table class="full">
<caption class="titulotb" >Efectos a Cobrar</caption>
<tr><td width="50%" align="right">
<b>Cobrados Este Mes (<?php echo $mes.'/'.$anyo; ?>)</b>:
</td><td>
 <?php echo lcredec($aEfectos['cobrados_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Vencimiento <u>Mayor</u> que <?php echo $f_fin; ?></b>:
</td><td>
 <?php echo lcredec($aEfectos['vto_mayor_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr><td align="right">
<b>Cobrados con Vto (<?php echo $mes.'/'.$anyo; ?>)</b>: 
</td><td>
<?php echo lcredec($aEfectos['vto_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Pendientes con Vto <u>Menor</u> que <?php echo $f_fin; ?></b>: 
</td><td>
<?php echo lcredec($aEfectos['pte_vto_menor_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr><td align="right">
<b>Total Pendientes de Cobro</b>: 
</td><td>
<?php echo lcredec($aEfectos['pendientes'],$BioMundoGestion); ?><br>
</td></tr>
</table>

<?php 

$aTmp = NULL;
$cons = 'SELECT SUM(monto) as "pagados_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 1 AND '.
	'fecha_abono BETWEEN "'.$f_ini.'" AND "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['pagados_hoy'] = $aTst['pagados_hoy'];
} else $aEfectos['pagados_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "vto_mayor_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 1 AND '.
	'fecha_vencimiento > "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['vto_mayor_hoy'] = $aTst['vto_mayor_hoy'];
} else $aEfectos['vto_mayor_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "vto_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 1 AND '.
	'fecha_vencimiento BETWEEN "'.$f_ini.'" AND "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['vto_hoy'] = $aTst['vto_hoy'];
} else $aEfectos['vto_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "pte_vto_menor_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 0 AND '.
	'fecha_vencimiento <= "'.$f_fin.'" ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['pte_vto_menor_hoy'] = $aTst['pte_vto_menor_hoy'];
} else $aEfectos['pte_vto_menor_hoy'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

$cons = 'SELECT SUM(monto) as "pendientes" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 0 ';
$resef = $oDb->query($cons);
if ($oDb->num_rows($resef)) {
	$aTst = $oDb->fetch_assoc($resef);
	$aEfectos['pendientes'] = $aTst['pendientes'];
} else $aEfectos['pendientes'] = 0;
$oDb->libera($resef);
$aCons[] = $cons;

?>
<table class="full">
<caption class="titulotb" >Efectos a Pagar</caption>
<tr><td width="50%" align="right">
<b>Pagados Este Mes (<?php echo $mes.'/'.$anyo; ?>)</b>:
</td><td>
 <?php echo lcredec($aEfectos['pagados_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Vencimiento <u>Mayor</u> que <?php echo $f_fin; ?></b>:
</td><td>
 <?php echo lcredec($aEfectos['vto_mayor_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr><td align="right">
<b>Pagados con Vto (<?php echo $mes.'/'.$anyo; ?>)</b>: 
</td><td>
<?php echo lcredec($aEfectos['vto_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Pendientes con Vto <u>Menor</u> que <?php echo $f_fin; ?></b>: 
</td><td>
<?php echo lcredec($aEfectos['pte_vto_menor_hoy'],$BioMundoGestion); ?><br>
</td></tr>

<tr><td align="right">
<b>Total Pendientes de Pago</b>: 
</td><td>
<?php echo lcredec($aEfectos['pendientes'],$BioMundoGestion); ?><br>
</td></tr>
</table>
<br>

<?php
$cons = "SELECT BA.nombre,ROUND(SUM(B.cantidad*EA.".$campo_precio."),$n_dec) as 'Value'  ".
			"FROM Bajas_localizacion B JOIN Articulos A ON (B.id_articulo=A.id_articulo) JOIN Empresas_articulos EA ON (A.id_articulo=EA.id_articulo AND EA.id_empresa=1) ".
			"LEFT JOIN Bajas_almacen BA ON (B.id_baja_almacen=BA.id_baja_almacen) ".
			"WHERE B.fecha_baja BETWEEN '".$f_ini."' AND '".$f_fin."' ".
			"GROUP BY B.id_baja_almacen ";
$resba = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$total_bajas = 0;
	?>
	<table class="full">
	<caption class="titulotb" >Bajas de Inventario (todas)</caption>
	<thead style="background-color: #DDDDDD; font-weight: bold; " ><tr>
	<td style="width: 50%; text-align: right;" >Tipo de Baja</td>
	<td>Valor</td>
	</tr></thead><tbody>
	<?php	while ($aTmp = $oDb->fetch_assoc($resba)) { 
		$total_bajas += $aTmp['Value'];
		?>
		<tr><td style="text-align: right; "><?php echo $aTmp['nombre']; ?>: </td>
			<td><?php echo lcredec($aTmp['Value'],$BioMundoGestion); ?></td></tr>
	<?php } ?>
	<tr><td style="text-align: right; font-weight: bold;">Total Bajas de Inventario: </td><td><?php echo lcredec($total_bajas,$BioMundoGestion); ?></td></tr>
	</tbody></table><br/>
<?php } ?>

<?php
$cons = "SELECT BA.nombre,ROUND(SUM(B.cantidad*EA.".$campo_precio."),$n_dec) as 'Value'  ".
			"FROM Bajas_localizacion B JOIN Articulos A ON (B.id_articulo=A.id_articulo) JOIN Empresas_articulos EA ON (A.id_articulo=EA.id_articulo AND EA.id_empresa=1) ".
			"LEFT JOIN Bajas_almacen BA ON (B.id_baja_almacen=BA.id_baja_almacen) ".
			"WHERE B.fecha_baja BETWEEN '".$f_ini."' AND '".$f_fin."' AND B.id_albaran IS NOT NULL ".
			"GROUP BY B.id_baja_almacen ";
$resba = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$total_bajas = 0;
	?>
	<table class="full">
	<caption class="titulotb" >Bajas de Inventario por Devolución en Albaranes</caption>
	<thead style="background-color: #DDDDDD; font-weight: bold; " ><tr>
	<td style="width: 50%; text-align: right;" >Tipo de Baja</td>
	<td>Valor</td>
	</tr></thead><tbody>
	<?php	while ($aTmp = $oDb->fetch_assoc($resba)) { 
		$total_bajas += $aTmp['Value'];
		?>
		<tr><td style="text-align: right; "><?php echo $aTmp['nombre']; ?>: </td>
			<td><?php echo lcredec($aTmp['Value'],$BioMundoGestion); ?></td></tr>
	<?php } ?>
	<tr><td style="text-align: right; font-weight: bold;">Total Bajas de Inventario: </td><td><?php echo lcredec($total_bajas,$BioMundoGestion); ?></td></tr>
	</tbody></table><br/>
<?php } ?>

<?php
$cons = "SELECT BA.nombre,ROUND(SUM(B.cantidad*EA.".$campo_precio."),$n_dec) as 'Value'  ".
			"FROM Bajas_localizacion B JOIN Articulos A ON (B.id_articulo=A.id_articulo) JOIN Empresas_articulos EA ON (A.id_articulo=EA.id_articulo AND EA.id_empresa=1) ".
			"LEFT JOIN Bajas_almacen BA ON (B.id_baja_almacen=BA.id_baja_almacen) ".
			"WHERE B.fecha_baja BETWEEN '".$f_ini."' AND '".$f_fin."' AND B.id_albaran IS NULL ".
			"GROUP BY B.id_baja_almacen ";
$resba = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$total_bajas = 0;
	?>
	<table class="full">
	<caption class="titulotb" >Bajas de Inventario desde Almacén</caption>
	<thead style="background-color: #DDDDDD; font-weight: bold; " ><tr>
	<td style="width: 50%; text-align: right;" >Tipo de Baja</td>
	<td>Valor</td>
	</tr></thead><tbody>
	<?php	while ($aTmp = $oDb->fetch_assoc($resba)) { 
		$total_bajas += $aTmp['Value'];
		?>
		<tr><td style="text-align: right; "><?php echo $aTmp['nombre']; ?>: </td>
			<td><?php echo lcredec($aTmp['Value'],$BioMundoGestion); ?></td></tr>
	<?php } ?>
	<tr><td style="text-align: right; font-weight: bold;">Total Bajas de Inventario: </td><td><?php echo lcredec($total_bajas,$BioMundoGestion); ?></td></tr>
	</tbody></table><br/>
<?php } ?>

<?php
$cons = "SELECT A.nombre as 'almacen',AL.nombre,SUM(L.cantidad*EA.".$campo_precio.") as 'Value'  ".
			"FROM Localizacion_articulos L JOIN Articulos Ar ON (L.id_articulo=Ar.id_articulo) ".
			"JOIN Empresas_articulos EA ON (Ar.id_articulo=EA.id_articulo AND EA.id_empresa = 1) ".
			"LEFT JOIN Almacenes_logicos AL ON (L.id_almacen_logico=AL.id_almacen_logico) JOIN Almacenes A ON (AL.id_almacen=A.id_almacen) ".
			"WHERE EA.fecha_baja IS NULL ".
			"GROUP BY L.id_almacen_logico ".
			"ORDER BY AL.nombre asc ";
// echo ($cons);
$resba = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$total_bajas = 0;
	?>
	<table class="full">
	<caption class="titulotb" >Valoracion de Inventario</caption>
	<thead style="background-color: #DDDDDD; font-weight: bold; " ><tr>
	<td style="text-align: center;" >Almacen</td>
	<td style="width: 25%; text-align: right;" >Zona</td>
	<td>Valor</td>
	</tr></thead><tbody>
	<?php	while ($aTmp = $oDb->fetch_assoc($resba)) { 
		$total_bajas += $aTmp['Value'];
		?>
		<tr><td ><?php echo $aTmp['almacen']; ?>: </td>
		<td style="text-align: right; "><?php echo $aTmp['nombre']; ?>: </td>
			<td><?php echo lcredec($aTmp['Value'],$BioMundoGestion); ?></td></tr>
	<?php } ?>
	<tr><td style="text-align: right; font-weight: bold;" colspan="2">Total Valor de Inventario: </td><td><?php echo lcredec($total_bajas,$BioMundoGestion); ?></td></tr>
	</tbody></table><br/>
<?php } ?>

<?php
$cons = "SELECT M.nombre,SUM(L.cantidad*EA.".$campo_precio.") as 'Value'  ".
			"FROM Localizacion_articulos L JOIN Articulos Ar ON (L.id_articulo=Ar.id_articulo) ".
			"JOIN Empresas_articulos EA ON (Ar.id_articulo=EA.id_articulo AND EA.id_empresa = 1) JOIN Marcas M ON (Ar.id_marca=M.id_marca) ".
			"LEFT JOIN Almacenes_logicos AL ON (L.id_almacen_logico=AL.id_almacen_logico) JOIN Almacenes A ON (AL.id_almacen=A.id_almacen) ".
			"WHERE EA.fecha_baja IS NULL ".
			"GROUP BY Ar.id_marca ".
			"ORDER BY M.nombre asc ";
// echo ($cons);
$resba = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$total_bajas = 0;
	$i = -1;
	?>
	<table class="full">
	<caption class="titulotb" >Valoracion de Inventario por Marca</caption>
	<thead style="background-color: #DDDDDD; font-weight: bold; " ><tr>
	<td style="text-align: right;" >Marca</td>
	<td>Valor</td>
	<td style="text-align: right;" >Marca</td>
	<td>Valor</td>
	</tr></thead><tbody><tr>
	<?php	while ($aTmp = $oDb->fetch_assoc($resba)) { 
		$total_bajas += $aTmp['Value'];
		$i++;
		?>
		<td style="text-align: right; "><?php echo $aTmp['nombre']; ?>: </td>
			<td><?php echo lcredec($aTmp['Value'],$BioMundoGestion); ?></td>
		<?php if ($i%2) { ?>
		</tr><tr>
		<?php } 
	} ?>
	<tr><td style="text-align: right; font-weight: bold;" colspan="2">Total Valor de Inventario: </td>
		<td colspan="2"><?php echo lcredec($total_bajas,$BioMundoGestion); ?></td></tr>
	</tbody></table><br/>
<?php } ?>

<br><br>
</body>
</html>
