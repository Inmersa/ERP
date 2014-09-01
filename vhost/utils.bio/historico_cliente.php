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

global $data;

if (!isset($data) or !is_array($data) or empty($data['id_cliente']) or empty($data['Desde'])) {
	salida("Debe indicar ID cliente y rango de fechas.<br/>\n");
	exit;
}
if (empty($data['Hasta'])) $fdat['Hasta'] = '"'.date('Y-m-d 23:59').'"';
else $fdat['Hasta'] = wol_db::formatear_fecha($data['Hasta']);
$fdat['Desde'] = wol_db::formatear_fecha($data['Desde']);

$cons = 'SELECT C.id_cliente as "ID Cliente", C.razon_social as "NombreCliente", '.
	'DATE_FORMAT(MAX(t2.fecha),"%d/%m/%y") as "U. Compra", '.
	't1.id_articulo as "Ref", t4.codigo_barras as "Codigo de Barras", LEFT(t4.nombre,50) as "Nombre de Articulo", LEFT(t5.nombre,20) as "Marca", '.
	'ROUND(t6.unidades_bulto) as "U/C", ROUND(SUM( t1.cantidad )) as "Ud/Año" '.
	'FROM Lineas_detalle t1, Pedidos t2, Direcciones_entrega t3, Clientes C, Articulos t4, '.
	'Marcas t5, Empresas_articulos t6 '.
	'WHERE t1.id_pedido = t2.id_pedido AND ( t2.id_proveedor =0 OR '.
	't2.id_proveedor IS  NULL  ) AND t2.id_direccion = t3.id_direccion AND t3.id_cliente = C.id_cliente AND '.
	't1.id_articulo = t4.id_articulo AND t4.id_articulo = t6.id_articulo AND '.
	't4.id_marca = t5.id_marca AND t3.id_cliente = '.$data['id_cliente'].' AND '.
	't2.fecha >= '.$fdat['Desde'].' AND t2.fecha <= '.$fdat['Hasta'].
	' GROUP  BY t4.id_articulo '.
	'ORDER  BY t5.nombre, t4.nombre ';
$idrs = $db->query($cons);

if (!$db->num_rows($idrs)) {
	die("No se ha encontrado ningun resultado para el cliente ".$data['id_cliente']);
}
$aHeadderList = array('ID Cliente','NombreCliente','Desde','Hasta');
$nextra = $data['num_extra'];

$bHeadOn = false;
while ($aRec = $db->fetch_assoc($idrs)) {
	if (!$bHeadOn) {
		echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
		echo '<html><body><table style="border: 1px solid black; white-space: nowrap; border-collapse:collapse; padding: 3px;" cellspacing="0" ><caption>';
		foreach ($aHeadderList as $hn) {
			if (isset($aRec[$hn])) {
				echo '<span style="margin-right: 10px;" ><b>'.$hn.'</b> : '.$aRec[$hn].'</span>';
			} elseif (isset($data[$hn])) {
				echo '<span style="margin-right: 10px;" ><b>'.$hn.'</b> : '.$data[$hn].'</span>';
			}
		}
		$bHeadOn = true;
		echo '</caption><thead style="font-weight: bold;" ><tr>';
		$aHList = array_keys($aRec);
		foreach ($aHList as $hn) {
			if (!in_array($hn,$aHeadderList)) {
				echo '<td style="border: 1px solid black;" >'.$hn.'</td>';
			}
		}
		if (!empty($nextra)) 
			for ($i=0;$i<$nextra;$i++)
				echo '<td style="border: 1px solid black; width: 50px;" >&nbsp;</td>';
		echo '</tr></thead><tbody style="border: 1px solid black;" >';
	}
	echo '<tr style="border-bottom: 1px solid black;" >';
	foreach ($aRec as $hn => $val) {
		if (!in_array($hn,$aHeadderList)) {
			echo '<td style="border: 1px solid black;" >'.$val.'</td>';
		}
	}
	if (!empty($nextra)) 
		for($i=0;$i<$nextra;$i++)
			echo '<td style="border: 1px solid black; width: 25px;" >&nbsp;</td>';
	echo '</tr>';
}
echo "</tbody></table></body></html>";


?>
