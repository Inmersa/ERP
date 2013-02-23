<?php

// require_once "config.php";
// inmersa_session_recover();

include("../escritorio/config.php");									/**	  StartUp Config **/
include("../escritorio/kernel_nocifrado.inc");
$DEBUG='ON';

if (!is_object($GLOBALS[$GLOBALS['APP_NAME']])) {
	$GLOBALS[$GLOBALS['APP_NAME']] = new wolSesion($GLOBALS['APP_NAME'],"Sesion"); 
}
$GLOBALS[$GLOBALS['APP_NAME']]->init($seccion);
$Sesion = &$GLOBALS[$GLOBALS['APP_NAME']];
$oDb = &$Sesion->get_db();
$aTiposFam = array('urbana' => 3, 'provincial' => 9, 'interprovincial' => 4, 'internacional' => 5, 'movil' => 6);
$aFamMca = array(3 => 8, 9 => 9, 4 => 10, 5 => 10, 6 => 11);


$accion = $Sesion->fetchVar('accion','POST');
$aPrecios = $Sesion->fetchVar('precios','POST');
$iSubir = $Sesion->fetchVar('subir_a_costo','POST');
$aPos = $Sesion->fetchVar('pos','POST');
$id = $Sesion->fetchVar('id','POST');
if (is_numeric($id)) {
	$id_proveedor = $id;
	$Sesion->set_var('id_proveedor',$id_proveedor);
} else {
	$id_sess = $Sesion->get_var('id_proveedor');
	if (is_numeric($id_sess) and !empty($id_sess)) $id_proveedor = $id_sess;
}
$DEBUG = "ON";

if (empty($sep)) $sep = "\t";
else if (!strcasecmp($sep,"\\\\t")) {
	$sep = "\t";
}


$bDebug = false;

if ((int)$iSubir) $bSubirPreciosACosto = true;
else $bSubirPreciosACosto = false;

$id_familia = 5;
$id_marca = 7;
$id_iva = 2;
$id_unidad_medida = 3;
$id_empresa = 1;

$oDb = $Sesion->get_db('data');
$oDbcfg = $Sesion->get_db('conf');

switch ($accion) {
	case 'Importar Tarifa':
		if (!is_numeric($id_proveedor)) {
			echo "Debe indicar el proveedor al que pertenece la tarifa. ($prefijo_salida)";
			exit;
		}

		$file_name = $_FILES['file_articulos']['tmp_name'];
		if (!isset($file_name) OR empty($file_name)) {
			salida("Debe indicar todos los campos(Fichero Articulos) del formulario.<br/>\n");
			exit;
		}

		$aArticulos = array();
		$aCDR = file($file_name);
		debug("Articulos contiene: ".count($aCDR));
		foreach ($aCDR as $cdrline) {
			$bNext = false;
			$aLine = parse_csvline($cdrline,$sep);
			if (empty($aLine['A.id_articulo'])) $bNext = true;
			else {
				$id_art = $aLine['A.id_articulo'];
			}
			if (!is_array($aLine) or !sizeof($aLine)) $bNext = true;
			if ($bNext) {
				echo("<b>Warning</b> No reconozco la linea: $cdrline<br/>\n");
				continue;
			}
			if (!is_array($aArticulos[$id_art])) $aArticulos[$id_art] = array();
			$i++;
			foreach ($aLine as $k => $v) {
				if (substr($k,0,2)=='A.') {
					$fld = substr($k,2);
				} else $fld = $k;
				$aArticulos[$id_art]['Articulos'][$fld] = $v;
			}
		}
		debug("aArticulos ahora contiene: ".count($aArticulos)." y deberia: $i ");

		parse_csvline(NULl,NULL,array());
		$file_name = $_FILES['file_empresasarticulos']['tmp_name'];
		if (isset($file_name) AND !empty($file_name)) {
			$aCDR = file($file_name);
			foreach ($aCDR as $cdrline) {
				$bNext = false;
				$aLine = parse_csvline($cdrline,$sep);
				if (empty($aLine['A.id_articulo'])) $bNext = true;
				else {
					$id_art = $aLine['A.id_articulo'];
				}
				if (!is_array($aLine) or !sizeof($aLine)) $bNext = true;
				if ($bNext) {
					echo("<b>Warning</b> No reconozco la linea: $cdrline<br/>\n");
					continue;
				}
				if (!is_array($aArticulos[$id_art])) $aArticulos[$id_art] = array();
				foreach ($aLine as $k => $v) {
					if (substr($k,0,2)=='A.') {
						$fld = substr($k,2);
					} elseif (substr($k,0,3)=='EA.') {
						$fld = substr($k,3);
					} elseif (substr($k,0,3)=='CA.') {
						$fld = substr($k,3);
					} else $fld = $k;
					$aArticulos[$id_art]['Empresas_articulos'][$fld] = $v;
				}
				if (!is_numeric($aArticulos[$id_art]['Empresas_articulos']['id_empresa']))
					$aArticulos[$id_art]['Empresas_articulos']['id_empresa'] = 1;
			}
		}

		parse_csvline(NULl,NULL,array());
		$aArtP = array();
		$file_name = $_FILES['file_compraarticulos']['tmp_name'];
		if (isset($file_name) AND !empty($file_name)) {
			$aCDR = file($file_name);
			foreach ($aCDR as $cdrline) {
				$bNext = false;
				$aLine = parse_csvline($cdrline,$sep);
				if (empty($aLine['A.id_articulo'])) $bNext = true;
				else {
					$id_art = $aLine['A.id_articulo'];
				}
				if (!is_array($aLine) or !sizeof($aLine)) $bNext = true;
				if ($bNext) {
					echo("<b>Warning</b> No reconozco la linea: $cdrline<br/>\n");
					continue;
				}
				if (!is_array($aArticulos[$id_art])) $aArticulos[$id_art] = array();
				foreach ($aLine as $k => $v) {
					if (substr($k,0,2)=='A.') {
						$fld = substr($k,2);
					} elseif (substr($k,0,3)=='EA.') {
						$fld = substr($k,3);
					} elseif (substr($k,0,3)=='CA.') {
						$fld = substr($k,3);
					} else $fld = $k;
					$aArticulos[$id_art]['Compra_articulos'][$fld] = $v;
					if ($fld == 'referencia') { $aArtP[$v] = $id_art; }
				}
				if (!is_numeric($aArticulos[$id_art]['Compra_articulos']['id_proveedor']))
					$aArticulos[$id_art]['Compra_articulos']['id_proveedor'] = $id_proveedor;
			}
		}

		debug("Comprobando ficheros auxiliares ... ");
		parse_csvline(NULl,NULL,array());
		$file_name = $_FILES['file_detalle1']['tmp_name'];
		if (isset($file_name) AND !empty($file_name)) {
			$tb = $Sesion->fetchVar('file_detalle1_tabla','POST');
			$aCDR = file($file_name);
			foreach ($aCDR as $cdrline) {
				$bNext = false;
				$aLine = parse_csvline($cdrline,$sep);
				if (!empty($aLine['A.id_articulo'])) {
					$id_art = $aLine['A.id_articulo'];
				} elseif (!empty($aLine['CA.referencia'])) {
					$id_art = $aArtP[$aLine['CA.referencia']];
				} elseif (!empty($aLine['referencia'])) {
					$id_art = $aArtP[$aLine['referencia']];
				}
				if (empty($id_art) or !is_numeric($id_art)) $bNext = true;
				if (!is_array($aLine) or !sizeof($aLine)) $bNext = true;
				if ($bNext) {
					echo("<b>Warning</b> No reconozco la linea: $cdrline<br/>\n");
					continue;
				}
				if (!is_array($aArticulos[$id_art])) {
					debug("No existe articulo $id_art ");
					print_r($aLine);
					continue;
				}
				if (!is_array($aArticulos[$id_art][$tb])) {
					debug("No existe $tb para el articulo $id_art ");
					// print_r($aLine);
					continue;
				}
				foreach ($aLine as $k => $v) {
					if (substr($k,0,2)=='A.') {
						$fld = substr($k,2);
					} elseif (substr($k,0,3)=='EA.') {
						$fld = substr($k,3);
					} elseif (substr($k,0,3)=='CA.') {
						$fld = substr($k,3);
					} else $fld = $k;
					$aArticulos[$id_art][$tb][$fld] = $v;
					if ($fld == 'referencia') { $aArtP[$v] = $id_art; }
				}
				if (!is_numeric($aArticulos[$id_art]['Compra_articulos']['id_proveedor']))
					$aArticulos[$id_art]['Compra_articulos']['id_proveedor'] = $id_proveedor;
			}
		}

		parse_csvline(NULl,NULL,array());
		$file_name = $_FILES['file_detalle2']['tmp_name'];
		if (isset($file_name) AND !empty($file_name)) {
			$tb = $Sesion->fetchVar('file_detalle2_tabla','POST');
			$aCDR = file($file_name);
			foreach ($aCDR as $cdrline) {
				$bNext = false;
				$aLine = parse_csvline($cdrline,$sep);
				if (!empty($aLine['A.id_articulo'])) {
					$id_art = $aLine['A.id_articulo'];
				} elseif (!empty($aLine['CA.referencia'])) {
					$id_art = $aArtP[$aLine['CA.referencia']];
				} elseif (!empty($aLine['referencia'])) {
					$id_art = $aArtP[$aLine['referencia']];
				}
				if (empty($id_art) or !is_numeric($id_art)) $bNext = true;
				if (!is_array($aLine) or !sizeof($aLine)) $bNext = true;
				if ($bNext) {
					echo("<b>Warning</b> No reconozco la linea: $cdrline<br/>\n");
					continue;
				}
				if (!is_array($aArticulos[$id_art])) {
					debug("No existe articulo $id_art ");
					print_r($aLine);
					continue;
				}
				if (!is_array($aArticulos[$id_art][$tb])) {
					debug("No existe $tb para el articulo $id_art ");
					// print_r($aLine);
					continue;
				}
				foreach ($aLine as $k => $v) {
					if (substr($k,0,2)=='A.') {
						$fld = substr($k,2);
					} elseif (substr($k,0,3)=='EA.') {
						$fld = substr($k,3);
					} elseif (substr($k,0,3)=='CA.') {
						$fld = substr($k,3);
					} else $fld = $k;
					$aArticulos[$id_art][$tb][$fld] = $v;
					if ($fld == 'referencia') { $aArtP[$v] = $id_art; }
				}
				if (!is_numeric($aArticulos[$id_art]['Compra_articulos']['id_proveedor']))
					$aArticulos[$id_art]['Compra_articulos']['id_proveedor'] = $id_proveedor;
			}
		}
		unset($aArtP);

		$aList = array_keys($aArticulos);
		$strWhere = '';
		foreach ($aList as $id) { $strWhere .= ((!empty($strWhere)) ? ' OR ' : '').'A.id_articulo = '.$id; }
		$cons = 'SELECT A.id_articulo as "art_id", Ea.id_articulo as "emp_id", Ca.id_articulo as "prv_id" '.
			'FROM Articulos A LEFT JOIN Empresas_articulos Ea ON (A.id_articulo=Ea.id_articulo) '.
			'LEFT JOIN Compra_articulos Ca ON (Ca.id_articulo = A.id_articulo) '.
			'WHERE '.$strWhere;
		// debug($cons);
		$artrs = $oDb->query($cons);
		$aArtArt = $aArtEmp = $aArtProv = array();
		if ($oDb->num_rows($artrs)) {
			while ($aTmp = $oDb->fetch_assoc($artrs)) {
				foreach ($aTmp as $k => $v) {
					if (substr($k,0,4) == 'art_') { $aArtArt[$v] = $v; }
					elseif (substr($k,0,4) == 'emp_') { $aArtEmp[$v] = $v; }
					elseif (substr($k,0,4) == 'prv_') { $aArtProv[$v] = $v; }
				}
			}
			$aTmp = NULL;
			unset($aTmp);
		}
		$oDb->libera($artrs);

		debug("Lista de referencias: ".count($aList));
		foreach ($aArticulos as $id => $aA) {
			debug("ID: $id");
			// print_r($aA);
			foreach ($aA as $tb => $aRec) {
				switch ($tb) {
					case 'Articulos':
						if (!empty($aArtArt[$id])) {
							debug("El id de articulo $id ya existia en la tabla $tb , _NO_ se va a modificar.");
							continue 2;
						} else {
							$aRec['id_imagen'] = 617;
						}
						break;
					case 'Empresas_articulos':
						if (!empty($aArtEmp[$id])) {
							debug("El id de articulo $id ya existia en la tabla $tb , _NO_ se va a modificar.");
							continue 2;
						}
						break;
					case 'Compra_articulos':
						if (!empty($aArtProv[$id])) {
							debug("El id de articulo $id ya existia en la tabla $tb , _NO_ se va a modificar.");
							continue 2;
						}
						break;
				}
				debug("Procedemos a insertar en $tb el registro ($id): ");
				print_r($aRec);
				$oDb->tb_replace($tb,$aRec);
			}
		}
		break;
		// $oDb->tb_replace('Compra_articulos',$aTmp);

	case 'Cambiar Precios':
		if (is_array($aPrecios) and sizeof($aPrecios) and is_numeric($id_proveedor) and !empty($id_proveedor) ) 
			foreach ($aPrecios as $tipo => $aP) {
				if (is_numeric($aP['normal']) or is_numeric($aP['reducido']) or is_numeric($aP['normal2']) or is_numeric($aP['reducido2']) or is_numeric($aP['establecimiento'])) {
					$cons = 'UPDATE Compra_articulos Ca JOIN Articulos A ON (Ca.id_articulo=A.id_articulo AND Ca.id_proveedor = '.$id_proveedor.') SET ';
					$bFirst = true;
					foreach ($aP as $pr => $val) {
						if (is_numeric($val)) 
							switch ($pr) {
								case 'normal':
									$cons .= ( (!$bFirst) ? ',' : '').' Ca.precio = '.(float)$val;
									$bFirst = false;
									break;
								case 'reducido':
									$cons .= ( (!$bFirst) ? ',' : '').' Ca.PV_oficial = '.(float)$val;
									$bFirst = false;
									break;
								case 'normal2':
									$cons .= ( (!$bFirst) ? ',' : '').' Ca.precio = '.(float)$val;
									$bFirst = false;
									break;
								case 'reducido2':
									$cons .= ( (!$bFirst) ? ',' : '').' Ca.PV_oficial = '.(float)$val;
									$bFirst = false;
									break;
								case 'establecimiento':
									$cons .= ( (!$bFirst) ? ',' : '').' Ca.PVP_oficial = '.(float)$val;
									$bFirst = false;
									break;
							}
					}
					if (!$bFirst) {
						$cons .= ' WHERE A.mascara_modulo & 2 AND A.id_familia = '.$aTiposFam[$tipo];
						$cons_ins = 'REPLACE INTO Compra_articulos (id_articulo,id_proveedor,precio,PV_oficial,PVP_oficial,referencia) SELECT Ea.id_articulo,'.$id_proveedor.
										',Ca.precio,Ca.PV_oficial,Ca.PVP_oficial,Ca.referencia '.
										'FROM Empresas_articulos Ea JOIN Articulos A ON (A.id_articulo=Ea.id_articulo AND Ea.id_empresa = '.
										$id_empresa.' ) LEFT JOIN Compra_articulos Ca ON (A.id_articulo=Ca.id_articulo AND Ca.id_proveedor = '.$id_proveedor.') '.
										'WHERE Ea.fecha_baja IS NULL AND A.mascara_modulo & 2 AND A.id_familia = '.$aTiposFam[$tipo];
						$oDb->query($cons_ins);
						$oDb->query($cons);
						// debug($cons_ins);
						// debug($cons);
					}
				}
			}
		break;
}

function parse_csvline($cdrline,$sep = ',',$aStruct = NULL) {
	static $aOrden;

	$aCDR = array();
	$line = trim($cdrline);
	$i = 0;

	if (!is_array($aOrden) AND is_array($aStruct)) $aOrden=$aStruct;
	elseif (is_array($aStruct)) {
		$aOrden = $aStruct;
	} elseif ((!is_array($aOrden) OR !sizeof($aOrden)) AND !is_array($aStruct)) {
		// Tomamos la primera como nombres de campo.
		$aOrden = split($sep,$line);
		return NULL;
	}
	if (!is_array($aOrden) AND !is_array($aStruct)) {
		salida("Error: No hay estructura");
		return NULL;
	}

	if (empty($cdrline)) return NULL;
	if (empty($line)) return NULL;

	$aLine = split($sep,$line);
	foreach ($aLine as $i => $term) {
		if ($term{0} == '"') $term = substr($term,1);
		if ($term{strlen($term)-1} == '"') $term = substr($term,0,-1);
		$aCDR[$aOrden[$i]] = trim($term);
	}

	return $aCDR;
}

if (is_numeric($id_proveedor) and !empty($id_proveedor)) {
	$cons = 'SELECT A.id_familia as "id", AVG(Ca.precio) as "normal",AVG(Ca.PV_oficial) as "reducido", AVG(Ca.PVP_oficial) as "establecimiento", '.
				'AVG(Ca.precio) as "normal2",AVG(Ca.PV_oficial) as "reducido2" '.
				'FROM Articulos A JOIN Compra_articulos Ca ON (A.id_articulo=Ca.id_articulo AND Ca.id_proveedor = '.$id_proveedor.' ) WHERE ';
	$bFirst = true;
	if (is_array($aTiposFam) and sizeof($aTiposFam))
		foreach ($aTiposFam as $id) {
			$cons .= ((!$bFirst) ? ' OR ' : ' ').' A.id_familia = '.$id;
			$bFirst = false;
		}
	if (!$bFirst) {
		$cons .= ' GROUP BY A.id_familia ';
	}
	$aFamList = array();
	$rs = $oDb->query($cons);
	if ($oDb->num_rows($rs)) 
		while ($aTmp = $oDb->fetch_assoc($rs)) {
			$k = array_search($aTmp['id'],$aTiposFam);
			if (!empty($k)) $aPrecios[$k]=$aTmp;
		}
}

?>
<html>
<head>
<title>Importar Tarifa de Proveedor</title>
</head>
<body>
<h1>Tarifa/Catalogo de Proveedor</h1>

<fieldset class="fsficha" >
<legend>Tarifa en CSV</legend>
<form action="importar_tarifa.php" method="post" enctype="multipart/form-data">
Proveedor: <select name="id_proveedor" ><?php
$cons = 'SELECT id_proveedor,razon_social FROM Proveedores ORDER BY razon_social asc ';
$prs = $oDb->query($cons);
if (!$oDb->num_rows($prs)) {
   echo "Error: No hay Proveedores en la BBDD<br/>\n";
   exit();
}
while ($aP = $oDb->fetch_assoc($prs)) {?>
	<option value="<?php echo $aP['id_proveedor']; ?>" <?php echo (($id_proveedor==$aP['id_proveedor']) ? 'selected="selected"' : ''); ?> 
	/><?php echo $aP['razon_social']; ?></option>
<?php }
$oDb->libera($prs);
?></select><br/>
Tabla Articulos: <input type="file" name="file_articulos" > <br/>
Texto separado por :
<input type="radio" name="sep" value="\t" selected="selected" >Tabulador
<input type="radio" name="sep" value="," >Coma
<input type="radio" name="sep" value=";" >Punto y Coma (;)<br/>
<br/>
Tabla Empresas_articulos: <input type="file" name="file_empresasarticulos" > <br/>
Texto separado por :
<input type="radio" name="sep" value="\t" selected="selected" >Tabulador
<input type="radio" name="sep" value="," >Coma
<input type="radio" name="sep" value=";" >Punto y Coma (;)<br/>
<br/>
Tabla Compra_articulos: <input type="file" name="file_compraarticulos" > <br/>
Texto separado por :
<input type="radio" name="sep" value="\t" selected="selected" >Tabulador
<input type="radio" name="sep" value="," >Coma
<input type="radio" name="sep" value=";" >Punto y Coma (;)<br/>
<br/>
Detalles por Referencia de Proveedor #1: <input type="file" name="file_detalle1" > <br/>
Tabla que aplica: <select name="file_detalle1_tabla" >
<option value="Articulos" >Articulos</option>
<option value="Empresas_articulos" >Empresas_articulos</option>
<option value="Compra_articulos" >Compra_articulos</option>
</select><br/>
Texto separado por :
<input type="radio" name="sep" value="\t" selected="selected" >Tabulador
<input type="radio" name="sep" value="," >Coma
<input type="radio" name="sep" value=";" >Punto y Coma (;)<br/>
<br/>
Detalles por Referencia de Proveedor #2: <input type="file" name="file_detalle2" > <br/>
Tabla que aplica: <select name="file_detalle2_tabla" >
<option value="Articulos" >Articulos</option>
<option value="Empresas_articulos" >Empresas_articulos</option>
<option value="Compra_articulos" >Compra_articulos</option>
</select><br/>
Texto separado por :
<input type="radio" name="sep" value="\t" selected="selected" >Tabulador
<input type="radio" name="sep" value="," >Coma
<input type="radio" name="sep" value=";" >Punto y Coma (;)<br/>
<br/>

<input type="submit" name="accion" value="Importar Tarifa" />
<input type="reset" value="Reset">
</fieldset>
</form>

</body>
</html>
