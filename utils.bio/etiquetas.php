<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>INMERSA - MANAGEMENT</title>
<link rel="SHORTCUT ICON" href="../escritorio/imag/imagotipo.png">
<meta http-equiv="Content-Script-Type" content="text/javascript" >
<script type="text/javascript" src="../escritorio/modulos/temas/inmersa/Browsers.js" ></script>
<script type="text/javascript" src="../escritorio/modulos/temas/inmersa/IfaceActions.js" ></script>
<script type="text/javascript" src="../escritorio/modulos/temas/inmersa/Tabs.js" ></script>

<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/tablas.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/imagenes.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/iconografia.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/menus.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/formularios.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/fichas.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/bordescolores.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/tipografia.css" type="text/css" media="screen" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/graficas.css" type="text/css" media="screen" >
<!-- 
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/iconografia.css" type="text/css" media="print" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/bordesycolores.css" type="text/css" media="print" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/formularios.css" type="text/css" media="print" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/tipografia.css" type="text/css" media="print" >
<link rel="stylesheet" href="../escritorio/modulos/temas/inmersa/print/base.css" type="text/css" media="print" >
-->
<link rel="stylesheet" href="etiquetas.css" type="text/css" media="print" >
<link rel="stylesheet" href="etiquetas.css" type="text/css" media="screen" >

</head>
<body onload="window.print(); history.back();">
<?php

include("../escritorio/config.php");						/**	  StartUp Config **/
// include("../escritorio/kernel_nocifrado.inc");
include("kernel_nocifrado.inc");

$oSesion = new wolSesion($APP_NAME,"oSesion"); 
$seccion = "bo_home";
$oSesion->init($seccion);
$oDb = $oSesion->get_db('data');

$aRec = $oSesion->fetchVar('albaranes','POST');
if (!is_array($aRec) OR !sizeof($aRec)) exit;

foreach ($aRec as $n => $aAlb) {
	if (empty($aAlb['id']) AND empty($aAlb['referencia'])) continue;

	if (!empty($aAlb['id'])) $str_where .= ( (!empty($str_where)) ? ' OR ' : ' ').'A.id_albaran ='.$aAlb['id'];
	if (!empty($aAlb['referencia'])) $str_where .= ( (!empty($str_where)) ? ' OR ' : ' ').'A.referencia like "'.$aAlb['referencia'].'" ';
}

// debug("El where : ".$str_where);
$cons = 'SELECT A.id_albaran,A.referencia, A.bultos,A.fecha_envio, D.nombre, D.direccion, D.cp, D.poblacion, Pr.nombre as "provincia", D.telefono1, D.observaciones, '.
			'T.nombre as "nombre_transporte" FROM Albaranes A JOIN Pedidos P ON (P.id_pedido=A.id_pedido) JOIN Direcciones_entrega D ON (D.id_direccion=P.id_direccion) '.
			'JOIN Transportistas T ON (A.id_transportista=T.id_transportista) JOIN Provincias Pr ON (Pr.id_provincia=D.id_provincia) '.
			'WHERE '.$str_where;

$drs = $oDb->query($cons);

while ($aDir = $oDb->fetch_assoc($drs)) {
	$aParam = NULL;
	foreach ($aRec as $n => $aAlb) {
		if (empty($aAlb['id']) AND empty($aAlb['referencia'])) continue;
		if (!empty($aAlb['id']) AND $aAlb['id'] == $aDir['id_albaran']) {
			$aParam = $aAlb;
			break;
		} elseif (!empty($aAlb['referencia']) AND $aAlb['referencia'] == $aDir['referencia']) {
			$aParam = $aAlb;
			break;
		}
	}
	if (!is_array($aParam)) {
		// debug("No hemos encontrado el parametro del albaran. ");
		continue;
	}

	if (is_numeric($aParam['bultos'])) {
		if ($aParam['bultos'] != $aDir['bultos']) {
			$oDb->tb_update('Albaranes',array('bultos' => $aParam['bultos'], 'id_albaran' => $aDir['id_albaran']));
		}
		$bultos_alb = $aParam['bultos'];
	} else $bultos_alb = $aDir['bultos'];

	if ($bultos_alb > 0) {
		if (is_numeric($aParam['bultos_expedicion'])) $total_bultos = $aParam['bultos_expedicion'];
		else $total_bultos = $bultos_alb;

		// Obteniendo Los Rangos de etiquetas que hay que imprimir
		if (empty($aParam['etiquetas'])) $aParam['etiquetas'] = 1;
		$aTmp = split(',',$aParam['etiquetas']);
		$aLabels = array();
		$n_labels = $bultos_alb;
		foreach ($aTmp as $n => $np) {
			$aL = array();
			$aTmp2 = split('-',$np);
			if (sizeof($aTmp2) > 1) {
				if (is_numeric($aTmp2[0]) AND is_numeric($aTmp2[1])) {
					if ($aTmp2[0] >= $aTmp2[1]) {
						$aTmp2[1] = NULL;
						unset($aTmp2[1]);
					} else {
						$aL = array('ini' => $aTmp2[0], 'fin' => $aTmp2[1]);
					}
				}
			}
			if (sizeof($aTmp2) == 1) $aL['ini'] = $aTmp2[0];
			if (is_array($aL) AND sizeof($aL)) {
				if (!is_numeric($aL['fin'])) {
					if ( ($n+1) == sizeof($aTmp)) {
						$aL['fin'] = $aL['ini'] + ($n_labels-1);
					} else $aL['fin'] = $aL['ini'];
				}
				$n_labels -= ($aL['fin']-$aL['ini']+1);
				array_push($aLabels,$aL);
			}
		}

		if (!is_array($aLabels) OR !sizeof($aLabels)) {
			// debug("No hay rangos!");
			continue;
		}

		foreach ($aLabels as $aL) {
			for ($bn = $aL['ini']; $bn <= $aL['fin'] ; $bn++) {
?>
				<div class="Etiqueta" >
				<div class="fecha" >&nbsp;&nbsp;<?php echo $aDir['referencia']; ?> [<?php echo $aDir['fecha_envio']; ?>]</div>
				<div class="bultos" ><?php echo $bn; ?> / <?php echo $total_bultos; ?>&nbsp;&nbsp;</div>
				<div class="nombre_direccion" ><?php echo $aDir['nombre_transporte']; ?></div>
				<div class="nombre_direccion" ><?php echo $aDir['nombre']; ?> (<?php echo $aDir['telefono1']; ?>)</div>
				<div class="direccion" ><?php echo $aDir['direccion']; ?><br/>
				<?php echo $aDir['cp']; ?> <?php echo $aDir['poblacion']; ?> <?php echo $aDir['provincia']; ?></div>
				<div class="observaciones" ><?php echo $aDir['observaciones']; ?></div>
				</div>
<?php
			}
		}
	}
}

?>
</div>
</body>
</html>
