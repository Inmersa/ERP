<?php

if (!defined('__inmersa_periodo_class_inc')) {
define('__inmersa_periodo_class_inc',TRUE);

class DiaPeriodo extends dbListItem {
}

class Periodo extends IndexList {
	var $f_ini = NULL;
	var $f_fin = NULL;
	var $t_ini = NULL;
	var $t_fin = NULL;

	var $aAnyos = NULL;
	var $aMeses = NULL;
	var $aTrimestres = NULL;
	var $aSemanas = NULL;
	var $aDias = NULL;

	var $aEntidades = array(
			'Albaranes' => array( array(0 => 'fecha', 1 => 'id_dia'), array(0 => 'fecha_envio', 1 => 'id_dia_envio'), array(0 => 'fecha_recepcion', 1 => 'id_dia_recepcion'), array(0 => 'fecha_preparado', 1 => 'id_dia_preparado' )),
			'Bajas_localizacion' => array( array(0 => 'fecha_baja', 1 => 'id_dia_baja') ),
			'Clientes_empresas' => array( array(0 => 'fecha_alta', 1 => 'id_dia_alta'), array(0 => 'fecha_baja', 1 => 'id_dia_baja') ),
			'Efectos' => array( array(0 => 'fecha_vencimiento', 1 => 'id_dia_vencimiento'), array(0 => 'fecha_abono', 1 => 'id_dia_abono'), 
					array(0 => 'fecha_devolucion', 1 => 'id_dia_devolucion') ),
			'Efectos_parciales' => array( array(0 => 'fecha', 1 => 'id_dia') ),
			'Empresas_articulos' => array( array(0 => 'fecha_alta', 1 => 'id_dia_alta'), array(0 => 'fecha_baja', 1 => 'id_dia_baja') ),
			'Facturas' => array( array(0 => 'fecha', 1 => 'id_dia'), array(0 => 'fecha_emision', 1=> 'id_dia_emision') ),
			'Pedidos' => array( array(0 => 'fecha', 1 => 'id_dia') ),
			'Presupuestos' => array( array(0 => 'fecha', 1 => 'id_dia') ),
			'Promociones' => array( array(0 => 'fecha_inicio', 1 => 'id_dia_inicio'), array(0 => 'fecha_fin', 1=> 'id_dia_fin') ),
			'Proveedores_empresas' => array( array(0 => 'fecha_alta', 1 => 'id_dia_alta'), array(0 => 'fecha_baja', 1 => 'id_dia_baja') ),
			'Recorridos' => array( array(0 => 'fecha', 1 => 'id_dia') )
			);

	function _DateRange($inicio = NULL,$fin = NULL) {
		if (is_numeric($inicio)) {
			$this->f_ini = $this->dia_primera_semana($inicio);
			$this->f_fin = $this->dia_ultima_semana($inicio);
		} elseif (!empty($fin) AND !empty($inicio)) {
			$fi = wol_db::formatear_fecha($inicio,false);
			$ff = wol_db::formatear_fecha($fin,false);
			if (!strcasecmp($fi,'null') OR !strcasecmp($ff,'null')) {
				debug("Formato erroneo de fechas ($inicio o $fin) ");
				return false;
			}
			list($this->f_ini,) = split(' ',$fi);
			list($this->f_fin,) = split(' ',$ff);
			// $this->f_ini = $this->dia_primera_semana(date('Y',strtotime($fi)));
			// $this->f_fin = $this->dia_ultima_semana(date('Y',strtotime($ff)));
		} elseif (!empty($inicio)) {
			$fi = wol_db::formatear_fecha($inicio,false);
			if ( !strcasecmp($fi,'null') ) {
				debug("Formato erroneo de fechas ($inicio) ");
				return false;
			}
			$this->f_ini = strftime('%Y-%m-%d',strtotime('-1 day',strtotime($fi)));
			$this->f_fin = strftime('%Y-%m-%d',strtotime('+1 day',strtotime($fi)));
		}

		if (!empty($this->f_ini)) $this->t_ini = strtotime($this->f_ini);
		if (!empty($this->f_fin)) $this->t_fin = strtotime($this->f_fin);
		// debug("Constructor:: Buscando las fechas de: ".$this->f_ini." y ".$this->f_fin);
		return true;
	}

	function Periodo ($app,$db = 'data',$inicio = NULL,$fin = NULL) {
		if (empty($app)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		if (empty($db)) $db = 'data';

		if (!$this->_DateRange($inicio,$fin)) return false;

		$aCampos['Dias:Dia'] = array('id_dia','id_mes','id_semana','fecha','nombre','num_dia_semana');
		// $aCampos['Semanas'] = array('id_semana','id_trimestre','numero','nombre','f_ini','f_fin','n_dias');
		// $aCampos['Trimestres'] = array('id_trimestre','id_anyo','nombre','f_ini','f_fin','n_semanas');
		// $aCampos['Anyos:Anyo'] = array('id_anyo','numero','nombre','f_ini','f_fin','n_trimestres');

		$retval = parent::IndexList($app,$db,'Dias',$aCampos,array('fecha'),'DiaPeriodo');

		if ($retval) $retval = $this->fillUp();
		else debug("Constructor ha petado!! con: $db y $app");

		return $retval;
	}

	function &factoryActivePeriod() {
		if (!is_a($GLOBALS[$GLOBALS['APP_NAME']],'wolSesion')) return NULL;
		$oP = &$GLOBALS[$GLOBALS['APP_NAME']]->getVarByRef('_periodificacion_draft_period');
		if (!is_a($oP,'Periodo')) {
			$oP = new Periodo($GLOBALS['APP_NAME']);
			$GLOBALS[$GLOBALS['APP_NAME']]->setVarByRef('_periodificacion_draft_period',&$oP,'NOEXPIRE');
		} 
		return $oP;
	}

	function getAssignments($aList,$entidad = NULL,$bMix = true) {
		// $this->debug("obteniendo las asignaciones : ",'getAssignments');
		if (!is_array($aList) OR !sizeof($aList)) return NULL;
		if (!isset($bMix) or !is_bool($bMix)) $bMix = true;
		$bPrependEntity = false;
		if (empty($entidad)) {
			foreach ($aList as $campo => $valor) 
				if ( (strstr($campo,'.')) ) {
					$aTmp = split('\.',$campo);
					if (empty($this->aEntidades[$aTmp[0]])) {
						debug("Entidad ".$aTmp[0]." no reconocida ");
						continue;
					}
					$entidad = $aTmp[0];
					$bPrependEntity = true;
					break;
				}
		} elseif (empty($this->aEntidades[$entidad])) {
			debug("Entidad $entidad no reconocida ");
			return $aList;
		}
		if (empty($entidad)) return $aList;
		if ($bMix) $aRetVal = $aList;

		foreach ($aList as $campo => $valor) {
			if ( (strstr($campo,'.')) ) {
				$aTmp = split('\.',$campo);
				if (empty($this->aEntidades[$aTmp[0]])) continue;
				$ent_act = $aTmp[0];
				$campo = $aTmp[1];
			} else $ent_act = $entidad;

			$bFound = false;
			$iIdx = -1;
			foreach ($this->aEntidades[$ent_act] as $i => $aFlds) 
				if ($aFlds[0] == $campo) {
					$bFound = true;
					$iIdx = $i;
					break;
				}

			if (!$bFound) continue;
			if ($bPrependEntity) $fldname = $ent_act.'.';
			else $fldname = '';
			$fldname .= $this->aEntidades[$ent_act][$iIdx][1];

			if (stristr($valor,'null')) {
				$aRetVal[$fldname] = 'null';
				continue;
			}

			// debug("a por en $ent_act campo $campo ... $valor ");
			if (!$this->countItems()) {
				$this->_DateRange($valor);
				$this->fillUp();
			}
			$idx = $this->findDay($valor);
			if (!$idx) {
				$valor = wol_db::formatear_fecha($valor,false);
				if ($this->t_ini < strtotime($valor)) {
					$this->_DateRange($this->f_ini,$valor);
					$this->fillUp();
				} else {
					$this->_DateRange($valor,$this->f_fin);
					$this->fillUp();
				}
				$idx = $this->findDay($valor);
			}
			// debug("la fecha esta en el index $idx .. ");
			if (!$idx) {
				debug("Error: No ha habido forma de encontrar el indice para $valor .. ");
				return $aRetVal;
			} else {
				$oDia = $this->getDay($idx);
				$aTmp = $oDia->getData();
				$aRetVal[$fldname] = $aTmp['id_dia'];
				// debug("Finally, el dia es: ");
				// print_r($aTmp);
			}
		}
		return $aRetVal;
	}

	function getFirstDay() {
		return $this->f_ini;
	}

	function getLastDay() {
		return $this->f_fin;
	}

	function fillUp($id = NULL, $tipo = 'Anyo') {
		$oDb = $this->getDb();
		if (!is_a($oDb,'wol_db')) {
			debug(" No existe la bdd ");
			return false;
		}

		if (is_numeric($id) AND !empty($tipo)) {
			switch ($tipo) {
				case 'Anyo':
					$entidad = 'Anyos';
					$clave = 'id_anyo';
					break;
				case 'Trimestre':
					$entidad = 'Trimestres';
					$clave = 'id_trimestre';
					break;
				case 'Mes':
					$entidad = 'Meses';
					$clave = 'id_mes';
					break;
				case 'Semana':
					$entidad = 'Semanas';
					$clave = 'id_semana';
					break;
			}
			if (!empty($entidad) AND !empty($clave)) {
				$cons = 'SELECT P.f_ini, P.f_fin FROM '.$entidad.' P WHERE '.$clave.' = '.$id;
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					$aTmp = $oDb->fetch_row($tmprs);
					$this->f_ini = $aTmp[0];
					$this->t_ini = strtotime($aTmp[0]);
					$this->f_fin = $aTmp[1];
					$this->t_fin = strtotime($aTmp[1]);
				}
			}
		}
		if (empty($this->f_ini) OR empty($this->f_fin)) return false;
		// debug("Buscando desde fillUp() ... ");

		$amin = date('Y',$this->t_ini);
		$amax = date('Y',$this->t_fin);
		$cons = 'SELECT A.* FROM Anyos A WHERE (A.numero >= "'.date('Y',$this->t_ini).'" OR A.numero <= "'.date('Y',$this->t_fin).'" ) ';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			while ($aTmp = $oDb->fetch_assoc($tmprs)) {
				$this->aAnyos[$aTmp['id_anyo']] = $aTmp;
			}
		}
		$oDb->libera($tmprs);

		$cons = 'SELECT M.*,A.numero as "num_anyo",A.id_anyo as "numid_anyo" FROM Meses M LEFT JOIN Anyos A ON (A.id_anyo=M.id_anyo) WHERE '.
					'(M.f_ini <= "'.$this->f_ini.'" AND M.f_fin >= "'.$this->f_ini.'") OR '.
					'(M.f_fin <= "'.$this->f_fin.'" AND M.f_ini >= "'.$this->f_ini.'") OR '.
					'(M.f_ini <= "'.$this->f_fin.'" AND M.f_fin >= "'.$this->f_fin.'") ';
		$aMeses = NULL;
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			while ($aTmpA = $oDb->fetch_assoc($tmprs)) {
				if (!is_numeric($aTmpA['num_anyo'])) {
					$aTmpA['num_anyo'] = date('Y',strtotime($aTmpA['f_ini']));
					if ($aTmpA['num_anyo'] != $aNuevo['numero']) {
						$tmpfini = $this->dia_primera_semana($aTmpA['num_anyo']);
						$tmpffin = $this->dia_ultima_semana($aTmpA['num_anyo']);
						$this->aAnyos[$aTmpA['id_anyo']] = array('id_anyo' => $aTmpA['id_anyo'], 'numero' => $aTmpA['num_anyo'], 
										'nombre' => $aTmpA['num_anyo'], 'f_ini' => $tmpfini, 'f_fin' => $tmpffin, 'n_trimestres' => 0);
						$oDb->tb_replace('Anyos',$this->aAnyos[$aTmpA['id_anyo']]);
					}
				}
				$this->aMeses[$aTmpA['id_mes']] = $aTmpA;
			}
		}
		$oDb->libera($tmprs);
		$retval = $this->dbFill();

		return $retval;
	}

	function dbFill() {
		$oDb = $this->getDb();
		$retval = false;

		if (empty($this->f_ini) OR empty($this->f_fin)) return false;

		$cons = 'SELECT '.
					'S.id_semana as "sem_id_semana", S.id_trimestre as "sem_id_trimestre", S.numero as "sem_numero", S.nombre as "sem_nombre", S.f_ini as "sem_f_ini", '.
					'S.f_fin as "sem_f_fin", S.n_dias as "sem_n_dias", T.id_trimestre as "tri_id_trimestre", T.id_anyo as "tri_id_anyo", T.nombre as "tri_nombre", '.
					'T.f_ini as "tri_f_ini", T.f_fin as "tri_f_fin", T.n_semanas as "tri_n_semanas", S.num_semana_trimestre as "sem_num_semana_trimestre", '.
					'T.num_trimestre_anyo as "tri_num_trimestre_anyo" '.
					'FROM Trimestres T LEFT JOIN Semanas S ON (T.id_trimestre=S.id_trimestre) '.
					'WHERE (S.f_ini <= "'.$this->f_ini.'" AND S.f_fin >= "'.$this->f_ini.'") OR '.
					'(S.f_fin <= "'.$this->f_fin.'" AND S.f_ini >= "'.$this->f_ini.'") OR '.
					'(S.f_ini <= "'.$this->f_fin.'" AND S.f_fin >= "'.$this->f_fin.'") OR ('.
					'(T.f_ini <= "'.$this->f_ini.'" AND T.f_fin >= "'.$this->f_ini.'") OR '.
					'(T.f_fin <= "'.$this->f_fin.'" AND T.f_ini >= "'.$this->f_ini.'") OR '.
					'(T.f_ini <= "'.$this->f_fin.'" AND T.f_fin >= "'.$this->f_fin.'") )';
		$tmprs = $oDb->query($cons);
		if ($oDb->num_rows($tmprs)) {
			$aListaS = array();
			while ($aTmp = $oDb->fetch_assoc($tmprs)) {
				$aTmpS = NULL;
				$aTmpT = NULL;
				foreach ($aTmp as $fld => $val) {
					if (empty($val) AND !is_numeric($val)) continue;
					if (!strcasecmp(substr($fld,0,4),'sem_')) {
						$aTmpS[substr($fld,4)] = $val;
					} elseif (!strcasecmp(substr($fld,0,4),'tri_')) {
						$aTmpT[substr($fld,4)] = $val;
					} else {
						debug("Algun fallo dado que $fld => $val no casa");
						continue;
					}
				}

				if (is_array($aTmpS) AND sizeof($aTmpS)) {
					if (!is_array($this->aSemanas[$aTmpS['id_semana']])) {
						$this->aSemanas[$aTmpS['id_semana']] = $aTmpS;
					}
					array_push($aListaS,$aTmpS['id_semana']);
				}
				if (!is_array($this->aTrimestres[$aTmpT['id_trimestre']])) {
					$this->aTrimestres[$aTmpT['id_trimestre']] = $aTmpT;
				}
			}
			$aTmp = array();
			if (is_array($aListaS) AND sizeof($aListaS)) {
				$aTmp['id_semana'] = $aListaS;
				$retval = parent::dbFill($aTmp,'fecha asc');
			}
		}
		return $retval;
	}

	function updateYear ($aAnyo) {
		if (!is_array($aAnyo) OR !sizeof($aAnyo)) return false;
		$oDb = $this->getDb();

		if (is_numeric($aAnyo['id_anyo'])) {
			$bFound = true;
		} else {
			$bFound = false;
			if (is_array($this->aAnyos) AND sizeof($this->aAnyos))
				foreach ($this->aAnyos as $aA) {
					if ($aA['numero'] == $aAnyo['numero']) {
						$bFound = true;
						$aAnyo['id_anyo'] = $aA['id_anyo'];
						break;
					}
				}
		}

		if ($bFound) {
			$oDb->tb_update('Anyos',$aAnyo);
			// Fixme: Falta hacer comprobacion de si procede
			debug("falta comprobar antes el trimestre... por si no hay que reconstruir. ");
			$aAnyo['_rebuild'] = true;
			$this->aAnyos[$aAnyo['id_anyo']] = $aAnyo;
			// Esto no se deberia necesitar, dado que el parametro al constructor ya es el numero de anyo.
			// Arreglarlo para que si no existe, cree el anyo, y el updateYear se haga sobre esa base.
		} else {
			$oDb->tb_replace('Anyos',$aAnyo);
			$aAnyo['id_anyo'] = $oDb->last_insert_id();
			$aAnyo['_rebuild'] = true;
			$this->aAnyos[$aAnyo['id_anyo']] = $aAnyo;
		}

		$this->build();
		$this->Dump('db');
	}

	function build() {
		$oDb = $this->getDb();
		if (is_array($this->aAnyos) AND sizeof($this->aAnyos)) 
			foreach ($this->aAnyos as $aAnyo) {
				if ($aAnyo['_rebuild'] AND $aAnyo['n_trimestres'] > 0) {
					// debug("Reconstruyendo para este... ");
					// print_r($aAnyo);
					$ffin = $aAnyo['f_fin'];
					$fini = $aAnyo['f_ini'];
					$nweeks = date('W',strtotime($ffin));
					$nt = $aAnyo['n_trimestres'];
					$nm = 12 / $nt;
					$nw = round($nweeks / $nt);
					// debug("Ok para generar .. de $fini a $ffin en $nt plazos, son $nm meses a $nw semanas por trimestre");

					$id_anyo = $aAnyo['id_anyo'];
					if ($nt > 1 AND $nm > 1) { // Si hay mas de un trimestre que generar, y tiene mas de un mes.
						// Iremos descontando los trimestres que recorramos
						$wleft = $nweeks;
						$last_tini = strtotime($fini);
						for ($i=1; $i<=$nt; $i++) {
							$aTrim = array();
							$lastw_tini = $last_tini;

							$trim_fini = date('Y-m-d',$last_tini);
							// Buscando una fecha final.
							$id_trim = $this->findTrimester($trim_fini);
							if (is_numeric($id_trim)) {
								$aT = $this->getTrimester($id_trim);
								$ns = $aT['n_semanas'];
							} elseif ($i==$nt) $ns = $wleft;
							else $ns = $nw;
							$id_trim = NULL;

							// La fecha final es el num de semanas, menos 1 dia (para caer en domingo)
							$trim_ffin = date('Y-m-d',strtotime("+$ns weeks -1 day",$last_tini));

							$id_trim = $this->findTrimester($trim_fini,$trim_ffin);
							if (!is_numeric($id_trim)) {
								// debug("No hemos encontrado nada ");

								$nom = 'T'.$i;
								$aTrim['nombre'] = $nom;
								$aTrim['id_anyo'] = $id_anyo;
								$aTrim['num_trimestre_anyo'] = $i;
								if ($i == $nt) {
									// En el ultimo trimestre, se descuentan las semanas que queden
									$ns = $aTrim['n_semanas'] = $wleft;
									$wleft -= $ns;
								} else {
									$ns = $aTrim['n_semanas'] = $nw;
									$wleft -= $nw;
								}

								$aTrim['f_ini'] = $trim_fini;
								$aTrim['f_fin'] = $trim_ffin;
								// debug("hasta ".$trim_ffin);
								$oDb->tb_replace('Trimestres',$aTrim);
								$aTrim['id_trimestre'] = $oDb->last_insert_id();
								$this->setTrimester($aTrim);
								// debug("<b>TRim</b>: ");
								// print_r($aTrim);
							} else {
								// debug("Es el trimestre $id_trim ");
								$aTrim = $this->getTrimester($id_trim);
								if ($id_anyo != $aTrim['id_anyo']) {
									$aTrim['id_anyo'] = $id_anyo;
									$aTrim['num_trimestre_anyo'] = $i;
									$oDb->tb_update('Trimestres',$aTrim);
									$this->setTrimester($aTrim);
								}
								$wleft -= $aTrim['n_semanas'];
							}
							$last_tini = strtotime("+$ns weeks",$last_tini);
							$id_trimestre = $aTrim['id_trimestre'];
					
							// Recorremos el numero de semanas que toquen 
							// debug("<br>Generando $ns semanas para el trimestre desde ".date('Y-m-d',$lastw_tini));
							for ($j = 1; $j <= $ns; $j++) {
								$ns_anual = (($nweeks-$wleft)+($j-$ns));

								$sem_fini = date('Y-m-d',$lastw_tini);
								$sem_ffin = date('Y-m-d',strtotime('+1 week -1 day',$lastw_tini));
								// debug("Semana relativa $j de $ns . quedan $wleft de ".$nweeks." = ".$ns_anual." En fechas, de: $sem_fini a $sem_ffin");

								$id_sem = $this->findWeek($sem_fini,$sem_ffin);
								if (!is_numeric($id_sem)) {
									$aSem = array();
									$aSem['id_trimestre'] = $id_trimestre;
									$aSem['numero'] = $ns_anual;
									$aSem['nombre'] = 'W'.$ns_anual;
									$aSem['n_dias'] = 7;
									$aSem['f_ini'] = $sem_fini;
									$aSem['f_fin'] = $sem_ffin;
									$aSem['num_semana_trimestre'] = $j;
									$oDb->tb_replace('Semanas',$aSem);
									$aSem['id_semana'] = $oDb->last_insert_id();
								} else {
									// debug("Es la semana $id_sem ");
									$aSem = $this->getWeek($id_sem);
									if ($id_trimestre != $aSem['id_trimestre']) {
										$aSem['id_trimestre'] = $id_trimestre;
										$aSem['num_semana_trimestre'] = $j;
										$oDb->tb_update('Semanas',$aSem);
										$this->setWeek($aSem);
									}
								}
								$id_sem = $aSem['id_semana'];

								$last_tdia = $lastw_tini;
								$lastw_tini = strtotime('+1 week',$lastw_tini);

								// print_r($aSem);

								// Generando los dias de Dicha semana.
								for ($k=1; $k <= 7; $k++) {
									$aDia = array();
									$bUpdate = false;

									$f = date('Y-m-d',$last_tdia);
									$n_mes = date('m',$last_tdia);
									$num_anyo = date('Y',strtotime($f));
									$idx = $this->findDay($f);
									if (!is_numeric($idx)) {
										$aDia['id_semana'] = $aSem['id_semana'];
										$aDia['fecha'] = $f;
										$aDia['num_dia_semana'] = date('w',$last_tdia);
										if (empty($aDia['num_dia_semana'])) $aDia['num_dia_semana'] = 7;

										// debug("No hemos encontrado dia: ");
										// print_r($aDia);
									} else {
										$oDia = &$this->getDay($idx);
										$aDia = $oDia->getData();
										if (!is_numeric($aDia['id_semana']) OR $aSem['id_semana'] != $aDia['id_semana']) {
											$aDia['id_semana'] = $aSem['id_semana'];
											$bUpdate = true;
										}
									}

									$id_mes = $this->findMonth($f);
									if (is_numeric($id_mes)) {
										$bFound = true;
										$aMes = $this->getMonth($id_mes);
										// debug("Hemos encontrado el mes! ");
										// print_r($aMes);
										if ($aDia['id_mes'] != $aMes['id_mes']) {
											// debug("Y los meses no coinciden.. update al canto. ");
											$aDia['id_mes'] = $aMes['id_mes'];
											$bUpdate = true;
										}
									} else {
										// debug("_NO_ hemos encontrado el mes .. ($n_mes del $num_anyo)");
										$aTmp = array();
										$aTmp['num'] = (int)$n_mes;
										$aTmp['f_ini'] = $num_anyo.'-'.$n_mes.'-01';
										$aTmp['f_fin'] = date('Y-m-d',strtotime('+1 month -1 day',strtotime($aTmp['f_ini'])));
										$aTmp['nombre'] = date('F',strtotime($aTmp['f_ini']));

										if ($num_anyo != $aAnyo['numero']) {
											// Sin usar FindYear, dado que queremos el numero de anyo nah mas.
											$ida = NULL;
											foreach ($this->aAnyos as $aA) if ($num_anyo == $aA['numero']) {
												$ida = $aA['id_anyo'];
												break;
											}
											// debug("Los anyos del mes no coinciden. Anyo nuevo!! - ".$ida." = ".$aTmp['f_ini']);
											if (!is_numeric($ida)) {
												$tmpcons = 'SELECT * FROM Anyos WHERE numero = "'.$num_anyo.'" ';
												$tmprs = $oDb->query($tmpcons);
												if ($oDb->num_rows($tmprs)) {
													$aTmpAnyo = $oDb->fetch_assoc($tmprs);
													$aTmp['id_anyo'] = $aTmpAnyo['id_anyo'];
												} else {
													$tmp_fini = $this->dia_primera_semana($num_anyo);
													$tmp_ffin = $this->dia_ultima_semana($num_anyo);
													$aTmpAnyo = array('numero' => $num_anyo,'nombre' => $num_anyo,'f_ini' => $tmp_fini, 'f_fin' => $tmp_ffin);
													$oDb->tb_replace('Anyos',$aTmpAnyo);
													$aTmpAnyo['id_anyo'] = $aTmp['id_anyo'] = $oDb->last_insert_id();
												}
												$oDb->libera($tmprs);
												$this->setYear($aTmpAnyo);
											} else {
												$aA = $this->getYear($ida);
												$aTmp['id_anyo'] = $aA['id_anyo'];
											}
										} else $aTmp['id_anyo'] = $aAnyo['id_anyo'];

										$oDb->tb_replace('Meses',$aTmp);
										$aTmp['id_mes'] = $oDb->last_insert_id();
										$aTmp['num_anyo'] = $num_anyo;
										$aDia['id_mes'] = $aTmp['id_mes'];
										$this->setMonth($aTmp);

										// debug("Nuevo mes!");
										// print_r($aTmp);
									} 

									if (!is_numeric($aDia['id_dia'])) {
										$this->insert($aDia);
									} elseif ($bUpdate) {
										// debug("Performing update ... ".get_class($oDia));
										$oDia->update($aDia);
										unset($oDia);
									}
									$last_tdia = strtotime('+1 day',$last_tdia);

									// debug("Dia: ");
									// print_r($aDia);
								} // Fin Numero de dia de la semana
							} // Fin Numero de Semanas
						} // Fin Numero de Trimestres
					} // Fin si existe algo que generar ..
				} // Fin si hay que reconstruir anyo
			} // Fin numero de anyo

		return true;
	}

	function restoreEntities($aE = NULL) {

		$oDb = $this->getDb();

		$aQs = array();
		if (is_array($this->aEntidades) AND sizeof($this->aEntidades)) 
			foreach ($this->aEntidades as $entidad => $aCampos) {
				if (is_array($aE) AND sizeof($aE) AND !in_array($entidad,$aE)) continue;
				if (!is_array($aCampos) OR !sizeof($aCampos)) continue;
				foreach ($aCampos as $aC) {
					for ($idx = $this->firstItem(); isset($idx); $idx = $this->nextItem()) {
						// if (!in_array($this->getAttribute($idx,'id_dia'),array(366,367))) continue;
						// if (strcasecmp($aC[1],'id_dia')) continue;
						array_push($aQs,'UPDATE LOW_PRIORITY '.$entidad.' SET '.$aC[1].' = '.$this->getAttribute('id_dia',NULL,$idx).
							' WHERE '.$aC[0].' BETWEEN "'.$this->getAttribute('fecha',NULL,$idx).' 00:00:00" AND "'.$this->getAttribute('fecha',NULL,$idx).' 23:59:59" ');
						$fullcons .= 'UPDATE '.$entidad.' SET '.$aC[1].' = '.$this->getAttribute('id_dia',NULL,$idx).
							' WHERE '.$aC[0].' BETWEEN "'.$this->getAttribute('fecha',NULL,$idx).' 00:00:00" AND "'.$this->getAttribute('fecha',NULL,$idx).' 23:59:59"; ';
					}
				}
			}

		// if (!empty($fullcons)) $oDb->unbuffered_query($fullcons);
		if (is_array($aQs) AND sizeof($aQs)) foreach ($aQs as $cons) $oDb->unbuffered_query($cons);
		// debug($fullcons);
	}

	/** Metodos de obtencion de valores totales **/
	function SQLCollectData($aEntid,$campo_union,$fecha,$agrupacion,$bCorrido = true,$bLimiteDia = true) {
		// debug("sqlCollectData ($aEntid,$campo_union,$fecha,$agrupacion) ");

		if (!isset($bCorrido)) $bCorrido = true;
		if (!isset($bLimiteDia)) $bLimiteDia = true;
		$oDb = &$this->getDb();

		if (!is_array($aEntid)) {
			if (empty($aEntid)) {
				debug("Error: Debe indicar alguna entidad a totalizar");
				return NULL;
			}
			$aE = array(array('campo' => $aEntid));
		} else {
			if (!empty($aEntid['campo'])) $aE = array($aEntid);
			else $aE = $aEntid;
		}

		$aTmp = split('\.',$campo_union);
		if (!strchr($campo_union,'.') OR sizeof($aTmp)!=2 ) {
			debug("Error: Debe indicar entidad _y_ campo a totalizar para $campo_union ");
			return NULL;
		}
		foreach ($aTmp as $j => $val) $aTmp[$j] = trim($val);
		$entidad = $aTmp[0];
		$campo_entidad = $aTmp[1];
		if (!is_array($this->aEntidades[$entidad])) {
			debug("Error: No reconozco la entidad ".$entidad.", no esta entre la lista de entidades periodificables. ");
			continue;
		}

		$aAgrup = array();
		switch ($agrupacion) {
			case 'Semana': $aAgrup['alias'] = 'S'; $aAgrup['tabla'] = 'Semanas'; $aAgrup['clave']='id_semana'; $aAgrup['campo_anu'] = 'numero'; break;
			case 'semana': $aAgrup['alias'] = 'S'; $aAgrup['tabla'] = 'Semanas'; $aAgrup['clave']='id_semana'; $aAgrup['campo_anu'] = 'numero'; break;
			case 'Mes': $aAgrup['alias'] = 'M'; $aAgrup['tabla'] = 'Meses'; $aAgrup['clave']='id_mes'; $aAgrup['campo_anu'] = 'num'; break;
			case 'mes': $aAgrup['alias'] = 'M'; $aAgrup['tabla'] = 'Meses'; $aAgrup['clave']='id_mes'; $aAgrup['campo_anu'] = 'num'; break;
			case 'Trimestre': $aAgrup['alias'] = 'T'; $aAgrup['tabla'] = 'Trimestres'; $aAgrup['clave']='id_trimestre'; $aAgrup['campo_anu'] = 'num_trimestre_anyo'; break;
			case 'trimestre': $aAgrup['alias'] = 'T'; $aAgrup['tabla'] = 'Trimestres'; $aAgrup['clave']='id_trimestre'; $aAgrup['campo_anu'] = 'num_trimestre_anyo'; break;
			case 'Anyo': $aAgrup['alias'] = 'A'; $aAgrup['tabla'] = 'Anyos'; $aAgrup['clave']='id_anyo'; break;
			case 'anyo': $aAgrup['alias'] = 'A'; $aAgrup['tabla'] = 'Anyos'; $aAgrup['clave']='id_anyo'; break;
			default: $aAgrup['alias'] = 'S'; $aAgrup['tabla'] = 'Semanas'; $aAgrup['clave']='id_semana'; $aAgrup['campo_anu'] = 'numero'; break;
		}

		foreach ($aE as $i => $aEnt) {
			if (is_array($aEnt)) {
				$ent = $aEnt['campo'];
				$alias = $aEnt['alias'];
				$full_entidad = $aEnt['entidad_from'];
				// $full_entidad = $aEnt['entidad'];
			} else {
				$ent = $aEnt;
				$alias = NULL;
			}
			$aTmp = NULL;
			if ( !empty($full_entidad) ) {
				$aTmp[1] = $ent;
			} else {
				// $aR = preg_split("/[\(\)]/",$ent);
				// debug("Split: ");
				// print_r($aR);
				if (preg_match("/[\(\)\+\-\*\/]/",$ent)) {
					// debug("Hay... existe. ");
					$aTmp[1] = $ent;
				} else {
					$aTmp = split('\.',$ent);
					if (strchr($ent,'.') OR sizeof($aTmp)==2 ) {
						foreach ($aTmp as $j => $val) $aTmp[$j] = trim($val);
					} else {
						$aTmp[0] = $entidad;
						$aTmp[1] = $ent;
					}
				}
			}
			// debug("ent: $ent ");
			// print_r($aTmp);

			/** **
			if (!is_array($this->aEntidades[$aTmp[0]])) {
				debug("Error: No reconozco la entidad ".$aTmp[0].", no esta entre la lista de entidades periodificables. ");
				continue;
			}
			/** **/

			$aE[$i] = array('entidad' => $aTmp[0], 'campo' => $aTmp[1], 'alias' => $alias, 'entidad_from' => $full_entidad);
		}

		if (!is_array($aE) OR !sizeof($aE)) {
			debug("Error: No hay campos a totalizar. ");
			return NULL;
		}

		$select = 'A.numero as "Anyo", '.$aAgrup['alias'].'.nombre, '.$aAgrup['alias'].'.f_ini as "fecha_ini", '.$aAgrup['alias'].'.f_fin as "fecha_fin", '.
					( ($aAgrup['alias']!='A') ? $aAgrup['alias'].'.'.$aAgrup['campo_anu'].' as "numero_relativo", ' : '');
		$i = 0;
		$aEntRuta = array();
		foreach ($aE as $aEnt) {
			// debug("Buscando entidad ".$aEnt['entidad']." (de momento solo aceptamos la entidad base) ");
			if (!empty($aEnt['entidad']) AND $aEnt['entidad'] != $entidad AND !in_array($aEnt['entidad'],$aEntRuta)) {
				// Si no es la entidad base, habra que buscar la ruta.
				array_push($aEntRuta,$aEnt['entidad']);
			} elseif (!empty($aEnt['entidad_from']) AND $aEnt['entidad_from']!=$entidad AND !in_array($aEnt['entidad_from'],$aEntRuta)) {
				array_push($aEntRuta,$aEnt['entidad_from']);
			}
			$select .= (($i++) ? ', ' : '').'SUM('.((!empty($aEnt['entidad'])) ? $aEnt['entidad'].'.' : '').$aEnt['campo'].') '.
							( (!empty($aEnt['alias'])) ? ' as "'.$aEnt['alias'].'" ' : '');
		}
		$cons = 'SELECT '.$select;

		if (sizeof($aEntRuta)) {
			$aR = $oDb->ruta($entidad,$aEntRuta,NULL,NULL,NULL,true);
			$from_base = $aR['join_from'].' ';
		} else $from_base = $entidad.' ';

		$idx = $this->findDay($fecha);
		if (!is_numeric($idx)) {
			debug("Error: No se ha encontrado el dia $fecha ");
			return NULL;
		}
		$oDia = $this->getDay($idx);
		$aDia = $oDia->getData();
		// Componemos la condicion para que no nos coga el periodo completo anterior, sino hasta el mismo dia que este
		if ($aAgrup['alias'] == 'M') {
			// Por meses va distinto.
			// debug("Haciendo consulta por Meses ... ");
			$time = strtotime(wol_db::formatear_fecha($fecha,false));
			if (!$bCorrido) {
				$str_cond = 'M.num <= '.date('m',$time).' ';
			}
			if ($bLimiteDia) 
				$str_cond .= ( (!empty($str_cond)) ? ' AND ' : ' ').'(DATE_FORMAT(D.fecha,"%d") <= '.date('d',$time).') ';
		} else {
			if ($bLimiteDia) $str_cond = 'D.num_dia_semana <= '.$aDia['num_dia_semana'];
			$aSem = $this->getWeek($aDia['id_semana']);
			if ($aAgrup['alias']!='S' AND is_numeric($aDia['id_semana'])) {
				$aTrim = $this->getTrimester($aSem['id_trimestre']);
				// Seguimos comprobando la semana.
				// debug("Seguimos la comprobacion por semanas ... ".$aDia['id_semana']);
				if ($bLimiteDia) $str_cond .= ((!empty($str_cond)) ? ' AND ' : ' ').'S.num_semana_trimestre = '.$aSem['num_semana_trimestre'];

				if ($aAgrup['alias'] == 'T') {
					$str_cond = ( (!$bCorrido AND is_array($aTrim) AND sizeof($aTrim))
										? 'T.num_trimestre_anyo <= '.$aTrim['num_trimestre_anyo'].(($bLimiteDia) ? ' AND ' : '')
										: ''
									).( ($bLimiteDia)
										?  ' (S.num_semana_trimestre < '.$aSem['num_semana_trimestre'].( (!empty($str_cond)) ? ' OR ('.$str_cond.')) ' : '')
										: ((!empty($str_cond)) ? $str_cond : '' ) );
					// debug("Cond Tri($bCorrido - ".sizeof($aTrim).")($bLimiteDia): ".$str_cond);

				} else {
					// debug("Seguimos mas alla de la semana ... ".$aSem['id_trimestre']);
					if ($bLimiteDia) 
						$str_cond .= ((!empty($str_cond)) ? ' AND ' : ' ').'T.num_trimestre_anyo = '.$aTrim['num_trimestre_anyo'];

					$str_cond = ( ($bLimiteDia)
										? '(T.num_trimestre_anyo < '.$aTrim['num_trimestre_anyo'].
										  ' OR (T.num_trimestre_anyo = '.$aTrim['num_trimestre_anyo'].' AND S.num_semana_trimestre < '.$aSem['num_semana_trimestre'].') '.
										  ( (!empty($str_cond)) ? 'OR ('.$str_cond.')) ' : '')
										: ((!empty($str_cond)) ? $str_cond : '' ) );
				}
			} else {
				if (!$bCorrido AND is_array($aSem) AND sizeof($aSem)) 
					$str_cond = 'S.numero <='.$aSem['numero'].( (!empty($str_cond)) ? ' AND ('.$str_cond.') ' : ' ');

				// debug("Cond Semana($bCorrido - ".sizeof($aTrim).")($bLimiteDia): ".$str_cond);
			}
		}

		$aRetVal = NULL;
		foreach ($this->aEntidades[$entidad] as $aFld) {
			if ($aFld[0] == $campo_entidad) {
				$from = $from_base.' JOIN Dias D ON ('.$entidad.'.'.$aFld[1].'=D.id_dia) '.
							( ($aAgrup['alias'] != 'M') 
							  ? 'JOIN Semanas S ON (D.id_semana=S.id_semana) JOIN Trimestres T ON (T.id_trimestre=S.id_trimestre) LEFT JOIN Anyos A ON (T.id_anyo=A.id_anyo) '
							  : 'JOIN Meses M ON (D.id_mes=M.id_mes) LEFT JOIN Anyos A ON (M.id_anyo=A.id_anyo) '
							);
				$where = 'D.fecha <= "'.$fecha.'" '.((!empty($str_cond)) ? 'AND ('.$str_cond.') ' : '');
				$groupby = $aAgrup['alias'].'.'.$aAgrup['clave'].' ';
				$orderby = 'D.fecha desc ';

				$cons .= 'FROM '.$from.' '.
							'WHERE '.$where.' '.
							'GROUP BY '.$groupby.' '.
							'ORDER BY '.$orderby;
				$aRetVal['select'] = $select;
				$aRetVal['from'] = $from;
				$aRetVal['where'] = $where;
				$aRetVal['groupby'] = $groupby;
				$aRetVal['orderby'] = $orderby;
				$aRetVal['query'] = $cons;
				break;
			}
		}

		return $aRetVal;
	}

	/** Metodos de Busqued, Get y Set **/
	function findYear ($fi,$ff = NULL) {
		if (empty($fi) OR !strcasecmp(wol_db::formatear_fecha($fi,false),'null')) return NULL;
		if (!is_array($this->aAnyos) OR !sizeof($this->aAnyos)) return NULL;

		if (!empty($ff)) {
			$ff = wol_db::formatear_fecha($ff,false);
			if (!strcasecmp($ff,'null')) $ff = NULL;
		}
		if (!empty($ff)) {
			$tf = strtotime($ff);
		}

		$fi = wol_db::formatear_fecha($fi,false);
		$ti = strtotime($fi);

		// debug("Buscando fecha entre $fi y $ff ");
		$retval = NULL;
		foreach ($this->aAnyos as $id => $aAnyo) {
			$tmp_ti = strtotime($aAnyo['f_ini']);
			$tmp_tf = strtotime($aAnyo['f_fin']);
			if (empty($ff)) {
				// debug("Compracion sin limites fijos en $id SI ( $tmp_ti <= $ti Y $tmp_tf >= $ti ) ES DECIR ( ".$aAnyo['f_ini']." <= $fi Y ".$aAnyo['f_fin']." >= $fi ) ");
				if ($tmp_ti <= $ti AND $tmp_tf >= $ti) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			} else {
				// debug("Clavando los limites de $id que va desde $tmp_ti hasta $tmp_tf con diferencias: ".($ti - $tmp_ti)." y ".($tf - $tmp_tf));
				$tdia = (24 * 3600);
				if ( ($ti >= $tmp_ti AND $tf >= $tmp_tf) AND ($ti - $tmp_ti) < $tdia AND ($tf - $tmp_tf) < $tdia) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			}
		}

		return $retval;
	}

	function getYear ($ida) {
		return $this->aAnyos[$ida];
	}

	function setYear ($aAnyo,$bForce = false) {
		if (!is_numeric($aAnyo['id_anyo'])) return false;
		if (!is_array($this->aAnyos[$aAnyo['id_anyo']]) OR $bForce) {
			$this->aAnyos[$aAnyo['id_anyo']] = $aAnyo;
			$retval = true;
		} else $retval = false;
		return $retval;
	}

	function findTrimester ($fi,$ff = NULL) {
		if (empty($fi) OR !strcasecmp(wol_db::formatear_fecha($fi,false),'null')) return NULL;
		if (!is_array($this->aTrimestres) OR !sizeof($this->aTrimestres)) return NULL;

		if (!empty($ff)) {
			$ff = wol_db::formatear_fecha($ff,false);
			if (!strcasecmp($ff,'null')) $ff = NULL;
		}
		if (!empty($ff)) {
			$tf = strtotime($ff);
		}

		$fi = wol_db::formatear_fecha($fi,false);
		$ti = strtotime($fi);

		// debug("Buscando fecha entre $fi y $ff ");
		$retval = NULL;
		foreach ($this->aTrimestres as $id => $aTrim) {
			$tmp_ti = strtotime($aTrim['f_ini']);
			$tmp_tf = strtotime($aTrim['f_fin']);
			if (empty($ff)) {
				// debug("Compracion sin limites fijos en $id ");
				if ($tmp_ti <= $ti AND $tmp_tf >= $ti) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			} else {
				// debug("Clavando los limites de $id que va desde $tmp_ti hasta $tmp_tf con diferencias: ".($ti - $tmp_ti)." y ".($tf - $tmp_tf));
				$tdia = (24 * 3600);
				if ( ($ti >= $tmp_ti AND $tf >= $tmp_tf) AND ($ti - $tmp_ti) < $tdia AND ($tf - $tmp_tf) < $tdia) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			}
		}

		return $retval;
	}

	function getTrimester ($id) {
		return $this->aTrimestres[$id];
	}

	function setTrimester ($aTrim,$bForce = false) {
		if (!is_numeric($aTrim['id_trimestre'])) return false;
		if (!is_array($this->aTrimestres[$aTrim['id_trimestre']]) OR $bForce) {
			$this->aTrimestres[$aTrim['id_trimestre']] = $aTrim;
			$retval = true;
		} else $retval = false;
		return $retval;
	}

	function findMonth ($fi,$ff = NULL) {
		if (empty($fi) OR !strcasecmp(wol_db::formatear_fecha($fi,false),'null')) return NULL;
		if (!is_array($this->aMeses) OR !sizeof($this->aMeses)) return NULL;

		if (!empty($ff)) {
			$ff = wol_db::formatear_fecha($ff,false);
			if (!strcasecmp($ff,'null')) $ff = NULL;
		}
		if (!empty($ff)) {
			$tf = strtotime($ff);
		}

		$fi = wol_db::formatear_fecha($fi,false);
		$ti = strtotime($fi);

		// debug("Buscando fecha entre $fi y $ff ");
		$retval = NULL;
		foreach ($this->aMeses as $id => $aMes) {
			$tmp_ti = strtotime($aMes['f_ini']);
			$tmp_tf = strtotime($aMes['f_fin']);
			if (empty($ff)) {
				// debug("Compracion sin limites fijos en $id ");
				if ($tmp_ti <= $ti AND $tmp_tf >= $ti) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			} else {
				// debug("Clavando los limites de $id que va desde $tmp_ti hasta $tmp_tf con diferencias: ".($ti - $tmp_ti)." y ".($tf - $tmp_tf));
				$tdia = (24 * 3600);
				if ( ($ti >= $tmp_ti AND $tf >= $tmp_tf) AND ($ti - $tmp_ti) < $tdia AND ($tf - $tmp_tf) < $tdia) {
					// debug("Encontrado Trimestre: ");
					// print_r($aTrim);
					$retval = $id;
					break;
				}
			}
		}

		return $retval;
	}

	function getMonth ($id) {
		return $this->aMeses[$id];
	}

	function setMonth ($aMes,$bForce = false) {
		if (!is_numeric($aMes['id_mes'])) return false;
		if (!is_array($this->aMeses[$aMes['id_mes']]) OR $bForce) {
			$this->aMeses[$aMes['id_mes']] = $aMes;
			$retval = true;
		} else $retval = false;
		return $retval;
	}

	function findWeek ($fi,$ff = NULL) {
		if (empty($fi) OR !strcasecmp(wol_db::formatear_fecha($fi,false),'null')) return NULL;
		if (!is_array($this->aSemanas) OR !sizeof($this->aSemanas)) return NULL;

		if (!empty($ff)) {
			$ff = wol_db::formatear_fecha($ff,false);
			if (!strcasecmp($ff,'null')) $ff = NULL;
		}
		if (!empty($ff)) {
			$tf = strtotime($ff);
		}

		$fi = wol_db::formatear_fecha($fi,false);
		$ti = strtotime($fi);

		// debug("Buscando fecha entre $fi y $ff ");
		$retval = NULL;
		foreach ($this->aSemanas as $id => $aSem) {
			$tmp_ti = strtotime($aSem['f_ini']);
			$tmp_tf = strtotime($aSem['f_fin']);
			if (empty($ff)) {
				// debug("Compracion sin limites fijos en $id ");
				if ($tmp_ti <= $ti AND $tmp_tf >= $ti) {
					// debug("Encontrado Semana ($id): ");
					// print_r($aSem);
					$retval = $id;
					break;
				}
			} else {
				// debug("Clavando los limites de $id que va desde $tmp_ti hasta $tmp_tf con diferencias: ".($ti - $tmp_ti)." y ".($tf - $tmp_tf));
				$tdia = (24 * 3600);
				if ( ($ti >= $tmp_ti AND $tf >= $tmp_tf) AND ($ti - $tmp_ti) < $tdia AND ($tf - $tmp_tf) < $tdia) {
					// debug("Encontrado Semana ($id): ");
					// print_r($aSem);
					$retval = $id;
					break;
				}
			}
		}

		return $retval;
	}

	function getWeek ($id) {
		return $this->aSemanas[$id];
	}

	function setWeek ($aSem,$bForce = false) {
		if (!is_numeric($aSem['id_semana'])) return false;
		if (!is_array($this->aSemanas[$aSem['id_semana']]) OR $bForce) {
			$this->aSemanas[$aSem['id_semana']] = $aSem;
			$retval = true;
		} else $retval = false;
		return $retval;
	}

	function findDay($f) {
		// $this->debug($f,'findDay');
		$tmpf = wol_db::formatear_fecha($f,false);
		if (!strcasecmp($tmpf,'NULL')) return NULL;
		list($tmpf,) = split(' ',$tmpf);
		$aIdx = $this->getFromIndex('fecha',$tmpf);
		// Solo puede haber un dia por fecha.
		if (!is_array($aIdx) OR !sizeof($aIdx)) return NULL;
		$idx = array_shift($aIdx);
		return $idx;
	}

	function &getDay($idx) {
		// $this->debug($idx,'getDay');
		return $this->getItem($idx);
	}

	function dia_primera_semana($anyo) {
		if (!is_numeric($anyo)) return NULL;
		$fini = wol_db::formatear_fecha($anyo.'-01-01',false);
		$tini = strtotime($fini);
		$dini = date('w',strtotime($fini));
		if ($dini != 1) {
			$tmpw = date('W',$tini);
			if ($tmpw > 52) {
				$sign = '+';
				// 8 = 7 dias de la semana (domingo) + 1 (hasta lunes)
				$diff = (8-$dini);
			} else {
				$sign = '-';
				$diff = (7-$dini);
			}
			$fini = date('Y-m-d',strtotime($sign.$diff." days",$tini));
			$dini = date('w',strtotime($fini));
		} 
		// debug("La f inicio = ".$fini." ($sign) ".$diff);
		return $fini;
	}

	function dia_ultima_semana($anyo) {
		if (!is_numeric($anyo)) return NULL;
		$ffin = wol_db::formatear_fecha($anyo.'-12-31',false);
		$tfin = strtotime($ffin);
		$dfin = date('w',strtotime($ffin));
		if ($dfin != 0) {
			$tmpw = date('W',$tfin);
			if ($tmpw > 51) {
				$sign = '+';
				// 8 = 7 dias de la semana (domingo) + 1 (hasta lunes)
				$diff = (7-$dfin);
			} else {
				$sign = '-';
				$diff = (8-$dfin);
			}
			$ffin = date('Y-m-d',strtotime($sign.$diff." days",$tfin));
			$dfin = date('w',strtotime($ffin));
		} 
		// debug("La f fin = ".$ffin." $dfin ($sign) ".$diff." ");
		return $ffin;
	}

}

}

?>
