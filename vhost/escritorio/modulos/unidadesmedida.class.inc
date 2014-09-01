<?php

class UnidadesMedida extends inmersaSerialize {
	var $_aUnidades = array();
	var $_aTipos = array();
	var $_aEscalas = array();

	function UnidadesMedida($AppName = NULL,$dbname = 'data') {
		if (!parent::inmersaSerialize($AppName,$dbname)) {
			debug("Instancia Corrupta!! ");
			return false;
		}
	}

	function &Factory($varname = NULL, $AppName = NULL, $dbname = NULL) {
		if ($this) {
			$AppName = $this->getAppName();
			$dbname = $this->getDbName();
			$oSesion = &$this->getApp();
			$oDb = &$this->getDb();
		} else {
			$dbname = 'data';
			$AppName = $GLOBALS['APP_NAME'];
			$oSesion = &$GLOBALS[$GLOBALS['APP_NAME']];
			if (!is_a($oSesion,'wolSesion')) return NULL;
			$oDb = &$oSesion->getDb($dbname);
		}
		if (!is_a($oSesion,'wolSesion') OR !is_a($oDb,'wol_db')) return NULL;
		$this->debug("OK!",'Factory');

		$oRet = NULL;
		if (empty($varname)) $varname = '__UnidadesDeMedida';
		$oRet = &$oSession->getVarByRef($varname);
		if (!$oRet) {
			$oRet = new UnidadesMedida();
			$oRet->init();
//			$oSesion->setVarByRef($varname,&$oRet);
			$oSesion->setVarByRef($varname,$oRet);
		}
		return $oRet;
	}

	function init() {
		$retval = parent::init();
		if ($retval) $retval = $this->dbFill();
		return $retval;
	}

	function dbFill($id = NULL) {
		// $this->debug("call",'dbFill');
		// Comprobar la necesidad de repoblar o no la instancia, de cualquier forma, true
		$bFill = true;
		$bRetVal = true;
		if (is_numeric($id)) {
			if (is_array($this->_aUnidades[$id])) {
				$bFill = false;
				if (!sizeof($this->_aUnidades[$id])) $bRetVal = false;
			}
		} else if (is_array($this->_aUnidades) and sizeof($this->_aUnidades)) {
			$bRetVal = $bFill = false;
		}

		if ($bFill) {
			if (is_numeric($id)) $str_id = 'U.id_unidad_medida = '.$id;
			$cons = 'SELECT U.id_unidad_medida as "ume_id_unidad_medida", '.
						'U.id_tipo_unidadmedida as "ume_id_tipo", '.
						'U.nombre as "ume_nombre", '.
						'TU.nombre as "ume_nombre_tipo", '.
						'U.leyenda as "ume_leyenda", '.
						'U.conversion_descompuesta as "ume_bDescompuesta", '.
						'U.num_decimales as "ume_num_decimales", '.
						'TU.id_tipo_unidadmedida as "tme_id_tipo_unidadmedida", '.
						'TU.nombre as "tme_nombre", '.
						'TU.otro_peso_cubicaje as "tme_otro_peso_cubicaje", '.
						'UE.id_unidad_medida as "eme_id_unidad_medida", '.
						'UE.id_escala_medida as "eme_id_escala_medida", '.
						'UE.nombre as "eme_nombre", '.
						'UE.leyenda as "eme_leyenda", '.
						'UE.alias_list as "eme_alias_list", '.
						'UE.factor_conversion as "eme_factor_conversion" '.
						'FROM Unidades_medida U LEFT JOIN Tipos_UnidadMedida TU ON (U.id_tipo_unidadmedida=TU.id_tipo_unidadmedida) '.
						'LEFT JOIN UnidadesMedida_Escalas UE ON (U.id_unidad_medida=UE.id_unidad_medida) '.
						( (!empty($str_id)) ? ' WHERE '.$str_id.' ' : '').
						'ORDER BY U.id_unidad_medida,UE.factor_conversion asc ';
			$oDb = &$this->getDb();
			$urs = $oDb->query($cons);
			// debug($cons);
			if ($oDb->num_rows($urs)) {
				while ($aTmp = $oDb->fetch_assoc($urs)) {
					$aTipo = $aUnidad = $aEscala = NULL;
					foreach ($aTmp as $k => $v) {
						switch (substr($k,0,4)) {
							case 'tme_':
								$aTipo[substr($k,4)] = $v;
								break;
							case 'ume_':
								$aUnidad[substr($k,4)] = $v;
								break;
							case 'eme_':
								$aEscala[substr($k,4)] = $v;
								break;
						}
					}
					if (is_numeric($aTipo['id_tipo_unidadmedida']) and !is_array($this->_aTipos[$aTipo['id_tipo_unidadmedida']])) 
						$this->_aTipos[$aTipo['id_tipo_unidadmedida']] = $aTipo; 
					if (is_numeric($aUnidad['id_unidad_medida']) and !is_array($this->_aUnidades[$aUnidad['id_unidad_medida']])) 
						$this->_aUnidades[$aUnidad['id_unidad_medida']] = $aUnidad; 
					if (is_numeric($aEscala['id_escala_medida']) and 
							(!is_array($this->_aEscalas[$aEscala['id_unidad_medida']]) or 
							 !is_array($this->_aEscalas[$aEscala['id_unidad_medida']][$aEscala['id_escala_medida']]))) {

						// debug("Insertando en ".$aEscala['id_unidad_medida']." el id escala ".$aEscala['id_escala_medida']);
						if (!is_array($this->_aEscalas[$aEscala['id_unidad_medida']][$aEscala['id_escala_medida']])) 
							$this->_aEscalas[$aEscala['id_unidad_medida']][$aEscala['id_escala_medida']] = array();
						$this->_aEscalas[$aEscala['id_unidad_medida']][$aEscala['id_escala_medida']] = $aEscala;
					}
				}
				$bFill = true;
			} else {
				$this->_aUnidades[$id] = array();
				$bRetVal = $bFill = false;
			}
		}
		return $bRetVal;
	}

	function lcToString($d,&$oS,$aP = NULL,$oSrc = NULL,$aPath = NULL) {
		// debug("lcToString: $d clase: ".get_class($oSrc->sesion)." parametros: ");

		// $oS = &$this->getApp();
		if (!is_a($oS,'wolSesion')) return NULL;
		$aCfg = $oS->get_var('_aAppConf');
		if (!is_numeric($nDecimales)) $nDecimales = (int)$aCfg['gnrl_frac_digits'];

		if (!empty($aP['dataname'])) $varname = $aP['dataname'];
		else $varname = 'cantidad';
		if (!empty($aP['datamatch'])) $id_name = $aP['datamatch'];
		else $id_name = 'id_unidad_medida';
		if (!empty($aP['num_decimales'])) $nDecimales = $aP['num_decimales'];

		$strExclude = $aP['excludeif'];
		if (!empty($strExclude)) {
			$aExclude = split(',',$strExclude);
			if (is_array($aExclude) and sizeof($aExclude)) 
				foreach ($aExclude as $fld) {
					$val = $oSrc->get_data($fld);
					if (!empty($val)) {
//						return lcdec($d,&$oS,array('num_decimales' => $nDecimales));
						return lcdec($d,$oS,array('num_decimales' => $nDecimales));
					}
				}
		}

		$id_unidad = $oSrc->get_data($id_name);
		// debug($varname." toString de $d con el id($id_name): $id_unidad ");
		$retval = $this->toString($d,$id_unidad,$nDecimales);

		return $retval;
	}

	function toString($d,$id = NULL,$nDecimales = NULL) {
		if (!is_numeric($id) or !is_array($this->_aUnidades[$id]) or !sizeof($this->_aUnidades[$id])){
			$oS = &$this->getApp();
//			return lcdec($d,&$oS,array('num_decimales' => $nDecimales));
			return lcdec($d,$oS,array('num_decimales' => $nDecimales));
		}

		$oS = &$this->getApp();
		if (is_numeric($this->_aUnidades[$id]['num_decimales'])) $nDecimales = (int)$this->_aUnidades[$id]['num_decimales'];
		$aE = $this->_aEscalas[$id];
//		if (!is_array($aE) or !sizeof($aE)) return lcdec($d,&$oS,array('num_decimales'=>$nDecimales));
		if (!is_array($aE) or !sizeof($aE)) return lcdec($d,$oS,array('num_decimales'=>$nDecimales));
		$bDesc = (bool)$this->_aUnidades[$id]['bDescompuesta'];

		$aESorted = array();
		foreach ($aE as $idx => $aEM) {
			if (!empty($aEM['leyenda'])) { 
				$aESorted[$aEM['id_escala_medida']] = $aEM['factor_conversion'];
			}
		}
		arsort($aESorted);

		$retval = '';
		$resto = $d;
		$i = 1;
		foreach ($aESorted as $ide => $factor) {
			// debug("El resto $resto , con factor $factor del id $id .. ");
			if ($resto >= $factor) {
				$num = floor($resto/$factor);
				if ($bDesc) {
					$resto -= ($factor*$num);
					// debug("Salida descompuesta ... ".$this->_aEscalas[$id][$ide]['leyenda']." resto: $resto ");
					if ($resto>0 and $i==sizeof($aESorted)) {
						// debug("Estando en la ultima, casi deberiamos sumarle: ".($resto/$factor)." a $nDecimales dec");
						$num += ($resto/$factor);
					}
//					$lcnum = lcdec($num,&$oS,array('num_decimales' => $nDecimales));
					$lcnum = lcdec($num,$oS,array('num_decimales' => $nDecimales));
					$retval .= ( (!empty($retval)) ? ' ' : '').$lcnum.' '.$this->_aEscalas[$id][$ide]['leyenda'];
				} else {
					// debug("Salida esdecimal, usaremos: ".$this->_aEscalas[$id][$ide]['leyenda']." resto: $resto ");
					// debug("Seria algo asi como: ".($resto/$factor)." ".$this->_aEscalas[$id][$ide]['leyenda']);
//					$retval = lcdec(($resto/$factor),&$oS,array('num_decimales' => $nDecimales)).' '.$this->_aEscalas[$id][$ide]['leyenda'];
					$retval = lcdec(($resto/$factor),$oS,array('num_decimales' => $nDecimales)).' '.$this->_aEscalas[$id][$ide]['leyenda'];
					break;
				}
			}
			$i++;
		}
		if (empty($retval)) {
			if (is_numeric($d)) 
				$retval = lcdec($d,$oS,array('num_decimales' => $nDecimales));
//				$retval = lcdec($d,&$oS,array('num_decimales' => $nDecimales));
			else $retval = $d;
		}	

		return $retval;
	}

	function lcToDecimal($d,&$oS,$aP = NULL,$src = NULL,$aPath = NULL) {
		if (!is_numeric($d) and empty($d)) return $d;
		// debug("<hr>var: $aPath[0] -> dato: $d ");

		if (!is_array($aPath) or !sizeof($aPath) or empty($src)) {
			// debug("lcToDecimal -> Error: No se indico ruta de origen. $src ");
			// print_r($aPath);
			// debug("--");
			return $d;
		}

		if (!empty($aP['dataname'])) $varname = $aP['dataname'];
		else $varname = 'cantidad';
		if (!empty($aP['datamatch'])) $id_name = $aP['datamatch'];
		else $id_name = 'id_unidad_medida';
		if (!empty($aP['num_decimales'])) $nDecimales = $aP['num_decimales'];

		if (sizeof($aPath)>1) {
			$aFuente = $oS->fetchVar($aPath[0],$src);
			$aOrig = &$aFuente;
			for ($i=1;$i<sizeof($aPath);$i++) {
				if ($aPath[$i]!=$varname) {
					$aOrig = &$aOrig[$aPath[$i]];
				} else {
					if (is_array($aOrig[$id_name]) and sizeof($aPath)>($i+1)) {
						$aTmp = &$aOrig[$id_name];
						for ($k=($i+1);$k<sizeof($aPath);$k++) {
							if ($k+1<sizeof($aPath)) {
								$aTmp = &$aTmp[$aPath[$k]];
							} else {
								$id_unidad = $aTmp[$aPath[$k]];
							}
						}
					} else $id_unidad = $aOrig[$id_name];
					break;
				}
			}
		}
		$bOk = $this->dbFill($id_unidad);
		// debug("ID: $id_unidad el dato $d Ok?: ".(int)$bOk);
		// debug("Con formato: ".$this->toDecimal($d,$id_unidad,$nDecimales));
		if ($bOk) $retval = $this->toDecimal($d,$id_unidad,$nDecimales);
		else $retval = lcundec($d,$oS,array('num_decimales' => $nDecimales));
//		else $retval = lcundec($d,&$oS,array('num_decimales' => $nDecimales));
		// debug("Fin Format: $retval ");

		return $retval;
	}

	function toDecimal($str,$id = NULL,$nDecimales = NULL) {
		if (!is_numeric($id)) return NULL;

		$oS = &$this->getApp();
		if (!is_a($oS,'wolSesion')) return NULL;

		$aCfg = $oS->get_var('_aAppConf');
		if (!is_numeric($nDecimales)) $nDecimales = (int)$aCfg['gnrl_frac_digits'];
		$sep_decimal = $aCfg['gnrl_decimal_point'];
		$sep_millar = $aCfg['gnrl_thousands_sep'];

		if (is_array($this->_aEscalas[$id])) {
			if (is_numeric($this->_aUnidades[$id]['num_decimales'])) $nDecimales = (int)$this->_aUnidades[$id]['num_decimales'];
			$aLeyList = array();
			foreach ($this->_aEscalas[$id] as $ide => $aE) {
				if (!is_array($aLey)) $aLey = array();
				if (!is_array($aLeyOrder)) $aLeyOrder = array();

				if (!empty($aE['leyenda'])) {
					$idx = sizeof($aLey);
					if (!in_array(trim($aE['leyenda']),$aLeyList)) {
						array_push($aLeyList,trim($aE['leyenda']));
						$leylong = strlen(trim($aE['leyenda']));
						array_push($aLey,array('leyenda' => trim($aE['leyenda']),'id_escala_medida' => $ide, 'leylong' => $leylong ));
						if (!is_array($aLeyOrder[$leylong])) $aLeyOrder[$leylong] = array();
						array_push($aLeyOrder[$leylong],$idx);
					}
				}

				if (!empty($aE['alias_list'])) {
					$aTmp = split('[ ,]',$aE['alias_list']);
					foreach ($aTmp as $tmp) 
						if (!empty($tmp)) {
							if (!in_array(trim($tmp),$aLeyList)) {
								array_push($aLeyList,trim($tmp));
								$idx = sizeof($aLey);
								$leylong = strlen($tmp);
								array_push($aLey,array('leyenda' => trim($tmp),'id_escala_medida' => $ide, 'leylong' => $leylong));
								if (!is_array($aLeyOrder[$leylong])) $aLeyOrder[$leylong] = array();
								array_push($aLeyOrder[$leylong],$idx);
							}
						}
				}
			}
		}

		$strreal = ereg_replace('[^0-9 '.$sep_decimal.$sep_millar.'-]*','',$str);
		if (strlen($str)==strlen($strreal)) {
			// debug("Seria bueno poner aqui la leyenda base adjunta?  $str contra $strreal ");
//			return lcundec($str,&$oS,array('num_decimales' => $nDecimales));
			return lcundec($str,$oS,array('num_decimales' => $nDecimales));
		}

		$aLeySorted = array();
		krsort($aLeyOrder);
		foreach ($aLeyOrder as $len => $aList) {
			if (is_array($aList) and sizeof($aList))
				foreach ($aList as $lidx)
					array_push($aLeySorted,$aLey[$lidx]);

		}
		if (is_array($aLeySorted) and sizeof($aLeySorted)) {
			foreach ($aLeySorted as $aL) {
				$reg .= ( (!empty($reg)) ? '|' : '').'([0-9 '.$sep_decimal.$sep_millar.']*)('.$aL['leyenda'].')';
			}
		}
			
		// debug("Regexp: ($reg)");
		$retval = 0;
		$aCortes = array();
		$bErr = false;
		if (preg_match_all('/'.$reg.'/',$str,$aCortes,PREG_PATTERN_ORDER)) {
			// Acceso: (ItemNo+1)*2 = leyenda ; (ItemNo+1)*2-1 = cantidad de la leyenda
			$total_len = 0;
			$unknown_str = $str;
			foreach ($aCortes[0] as $cut) {
				$total_len += strlen($cut);
				$unknown_str = str_replace($cut,'',$unknown_str);
			}
			if ($total_len != strlen($str)) {
				debug("<b>Error</b>: Ha introducido alguna leyenda desconocida. Revise la configuracion de las unidades de medida. La cadena desconocida es: ".$unknown_str);
				$bErr = true;
			}

			if (!$bErr) {
				$aDoneList = array();
				foreach ($aLeySorted as $i => $l) {
					$aTmp = $aCortes[(($i+1)*2-1)];
					if (!is_array($aTmp) or !sizeof($aTmp)) continue;
					// debug("<b>temp</b> i($i) Unidades en: ".(($i+1)*2-1)."  leyenda en: ".(($i+1)*2)." ");
					// print_r($l);
					$bCont = false;
					foreach ($aTmp as $tmpley) 
						if (!empty($tmpley)) { 
							if ($bCont) {
								debug("<b>Error</b>: la entrada de datos repite exactamente la misma leyenda ");
								$bErr = true;
								break 2;
							}
							$bCont = true; 
							$cantidad = $tmpley;
						}
					if (!$bCont) continue;

					if (in_array($l['id_escala_medida'],$aDoneList)) {
						debug("<b>Error</b>: la entrada de datos repite escala. ");
						$bErr = true;
						break;
					} else {
						array_push($aDoneList,$l['id_escala_medida']);
					}

//					$cantidad_real = lcundec($cantidad,&$oS,array('num_decimales' => $nDecimales));
					$cantidad_real = lcundec($cantidad,$oS,array('num_decimales' => $nDecimales));
					$retval += ($cantidad_real*$this->_aEscalas[$id][$l['id_escala_medida']]['factor_conversion']);
					// debug("$cantidad_real unidades de ".$l['leyenda']." con idescala: ".$l['id_escala_medida'].
								// " Factor de: ".$this->_aEscalas[$id][$l['id_escala_medida']]['factor_conversion']);
					// print_r($aCortes[(($i+1)*2)]);
					// debug("--");
					$bErr = false;
				}
			}
		} else {
			debug("<b>Error</b>: Formato no reconocido en '$str', revise la configuracion de las unidades de medida por si no existiese la leyenda. ");
		}
		return $retval;
	}

}

?>
