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
$DEBUG='ON';

$Sesion = new wolSesion($APP_NAME,"Sesion"); 
$Sesion->init($seccion);
$db = $Sesion->get_db('data');

global $crear;
global $sep;

// global $_FILES;
if (empty($sep)) $sep = "\t";
else if (!strcasecmp($sep,"\\\\t")) {
	$sep = "\t";
}

$file_name = $_FILES['localizaciones']['tmp_name'];

if (empty($file_name) ) {
	salida("Debe indicar todos los campos del formulario.<br/>\n");
	exit;
}
$id_empresa = 1;
$crear = (int)$crear;
	
$aStock = file($file_name);

parse_csvline(NULL,NULL,array('id_marca','nombre','id_almacen_logico','planta','pasillo','columna','fila'));
// $fmtfecha = wol_db::formatear_fecha($fecha);
?>
<hr>
<?php
$i = 0;
foreach ($aStock as $linea) {

	$aArt = parse_csvline($linea,$sep);
	if (!is_numeric($aArt['id_marca'])) continue;
	if (!is_numeric($aArt['id_almacen_logico'])) {
		debug('La Marca '.$aArt['nombre'].' _no_ tiene id Almacen logico');
		continue;
	}

	$cons = 'SELECT Ea.id_articulo, Ea.stock_ficticio '.
		'FROM Empresas_articulos Ea, Articulos A '.
		'WHERE A.id_articulo=Ea.id_articulo AND A.id_marca='.$aArt['id_marca'].' AND Ea.id_empresa = '.$id_empresa;
	$idrs = $db->query($cons);
	// debug($cons.' - '.$idrs);
	$numero_articulos = $db->num_rows($idrs);
	$numero_actualizaciones = 0;
	$numero_creaciones = 0;
	// $aArt['cantidad'] = 0;
	if ($db->num_rows($idrs)) {
		while($aTmp = $db->fetch_assoc($idrs)) {
			$aArt['id_articulo'] = $aTmp['id_articulo'];
			if (!$crear) {
				$tmprs = $db->tb_update('Localizacion_articulos',$aArt,array('id_articulo' => $aTmp['id_articulo']));
				if ($db->affected_rows($tmprs)) $numero_actualizaciones++;
			} else {
				$rs = $db->query('SELECT * FROM Localizacion_articulos WHERE id_articulo = '.$aArt['id_articulo']);
				if (!$db->num_rows($rs)) {
					$tmprs = $db->tb_replace('Localizacion_articulos',$aArt);
					if ($db->affected_rows($tmprs)) $numero_creaciones++;
				} else {
					$tmprs = $db->tb_update('Localizacion_articulos',$aArt,array('id_articulo' => $aTmp['id_articulo']));
					if ($db->affected_rows($tmprs)) $numero_actualizaciones++;
				}
			}
			$aArt['id_articulo'] = NULL;
		}
	}

	?>
<table >
<tr><td align="right"> 
Marca </td>
<td align="right">
<?php echo $aArt['nombre']; ?></td>
</tr>

<tr bgcolor="#DDDDDD" ><td align="right"> 
Numero de Registros </td>
<td align="right">
<?php echo $numero_articulos; ?>
</td>
</tr>

<tr><td align="right"> 
Registros Actualizados </td>
<td align="right">
<?php echo $numero_actualizaciones; ?>
</tr>

<tr><td align="right"> 
Registros Insertados </td>
<td align="right">
<?php echo $numero_creaciones; ?>
</tr>

<tr bgcolor="#DDDDDD" ><td align="right"> 
Nueva Localizacion </td>
<td align="right">
<?php if (is_numeric($aArt['id_almacen_logico'])) echo 'Alm: '.$aArt['id_almacen_logico']; ?>
<?php if (is_numeric($aArt['planta'])) echo 'Pta: '.$aArt['planta']; ?>
<?php if (is_numeric($aArt['pasillo'])) echo 'P: '.$aArt['pasillo']; ?>
<?php if (is_numeric($aArt['columna'])) echo 'C: '.$aArt['columna']; ?>
<?php if (is_numeric($aArt['fila'])) echo 'F: '.$aArt['fila']; ?>
</td>
</td>
</tr>

</table>
<hr>
	<?php

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
