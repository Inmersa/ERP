<?php

include("../escritorio/config.php");									/**	  StartUp Config **/
include("kernel_nocifrado.inc");

$BioMundoGestion = new wolSesion($APP_NAME,"BioMundoGestion"); 
$BioMundoGestion->init($seccion);
$oDb = $BioMundoGestion->get_db('data');

global $f;
global $s;

if (!isset($f) OR empty($f) OR !strcasecmp('null',wol_db::formatear_fecha($f,FALSE))) 
	$f = date('Y-m-d');

$cons = 'SELECT SUM(Facturas.base_imponible) as "base_imponible", '.
	'SUM(Facturas.total_impuestos) as "total_impuestos", '.
	'SUM(Facturas.monto_total) as "monto_total" '.
	'FROM Facturas '.
	'WHERE Facturas.id_cliente IS NOT NULL AND Facturas.id_cliente != 0 AND Facturas.id_serie = 0 '.
	'AND Facturas.fecha BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
$resfa = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$aTmp = $oDb->fetch_assoc($resfa);
?>
<CENTER><H4>Facturacion Serie A</H4></CENTER><br>
<br>
<b>Base Imponible</b>: <?php echo $aTmp['base_imponible']; ?><br>
<b>Total Impuestos</b>: <?php echo $aTmp['total_impuestos']; ?><br>
<b>Monto Total</b>: <?php echo $aTmp['monto_total']; ?><br>
<?php
} else {
?>
<CENTER>No hay Facturacion para la Serie 4 tal dia como <?php echo $f; ?></CENTER>
<?php
}

$cons = 'SELECT SUM(Facturas.base_imponible) as "base_imponible", '.
	'SUM(Facturas.total_impuestos) as "total_impuestos", '.
	'SUM(Facturas.monto_total) as "monto_total" '.
	'FROM Facturas '.
	'WHERE Facturas.id_cliente IS NOT NULL AND Facturas.id_cliente != 0 AND Facturas.id_serie = 7 '.
	'AND Facturas.fecha BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
$resfa = $oDb->query($cons);
if ($oDb->num_rows($resfa)) {
	$aTmp = $oDb->fetch_assoc($resfa);
?>
<CENTER><H4>Facturacion Serie E</H4></CENTER><br>
<br>
<b>Base Imponible</b>: <?php echo $aTmp['base_imponible']; ?><br>
<b>Total Impuestos</b>: <?php echo $aTmp['total_impuestos']; ?><br>
<b>Monto Total</b>: <?php echo $aTmp['monto_total']; ?><br>
<?php
} else {
?>
<CENTER>No hay Facturacion para la Serie 7 tal dia como <?php echo $f; ?></CENTER>
<?php
}


$aTmp = NULL;
$cons = 'SELECT SUM(monto) as "cobrados_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 1 AND pagado = 1 AND '.
	'fecha_abono BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
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
	'fecha_vencimiento > '.wol_db::formatear_fecha($f);
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
	'fecha_vencimiento BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
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
	'fecha_vencimiento < '.wol_db::formatear_fecha($f);
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
<table width="100%">
<tr><td colspan="2">
<CENTER><H4>Efectos</H4></CENTER><br>
</td></tr>
<tr><td width="50%" align="right">
<b>Cobrados Hoy</b>:
</td><td>
 <?php echo $aEfectos['cobrados_hoy']; ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Vencimiento <u>Mayor</u> que <?php echo $f; ?></b>:
</td><td>
 <?php echo $aEfectos['vto_mayor_hoy']; ?><br>
</td></tr>

<tr><td align="right">
<b>Cobrados con Vto <?php echo $f; ?></b>: 
</td><td>
<?php echo $aEfectos['vto_hoy']; ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Pendientes con Vto <u>Menor</u> que <?php echo $f; ?></b>: 
</td><td>
<?php echo $aEfectos['pte_vto_menor_hoy']; ?><br>
</td></tr>

<tr><td align="right">
<b>Pendientes de Cobro</b>: 
</td><td>
<?php echo $aEfectos['pendientes']; ?><br>
</td></tr>
</table>

<br><br>
<?php 

$aTmp = NULL;
$cons = 'SELECT SUM(monto) as "pagados_hoy" '.
	'FROM Efectos '.
	'WHERE pago_cobro = 0 AND pagado = 1 AND '.
	'fecha_abono BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
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
	'fecha_vencimiento > '.wol_db::formatear_fecha($f);
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
	'fecha_vencimiento BETWEEN '.wol_db::formatear_fecha($f).' AND DATE_ADD('.wol_db::formatear_fecha($f).',INTERVAL 1 DAY) ';
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
	'fecha_vencimiento < '.wol_db::formatear_fecha($f);
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
<table width="100%">
<tr><td colspan="2">
<CENTER><H4>Efectos</H4></CENTER><br>
</td></tr>
<tr><td width="50%" align="right">
<b>Pagados Hoy</b>:
</td><td>
 <?php echo $aEfectos['pagados_hoy']; ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Vencimiento <u>Mayor</u> que <?php echo $f; ?></b>:
</td><td>
 <?php echo $aEfectos['vto_mayor_hoy']; ?><br>
</td></tr>

<tr><td align="right">
<b>Cobrados con Vto <?php echo $f; ?></b>: 
</td><td>
<?php echo $aEfectos['vto_hoy']; ?><br>
</td></tr>

<tr bgcolor="#DDDDDD"><td align="right">
<b>Pendientes con Vto <u>Menor</u> que <?php echo $f; ?></b>: 
</td><td>
<?php echo $aEfectos['pte_vto_menor_hoy']; ?><br>
</td></tr>

<tr><td align="right">
<b>Pendientes de Pago</b>: 
</td><td>
<?php echo $aEfectos['pendientes']; ?><br>
</td></tr>
</table>

<br><br>
