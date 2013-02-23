<?php
if (!defined('__inmersa_module_api')) {
define('__inmersa_module_api',true);

class inmersaSerialize {
	var $ST_CORRUPT = 16;

	var $_dbItem_status = 0;

	var $_aNames = array(
			'sesion' => NULL,		// Nombre de Aplicacion, y variable global de sesion
			'data' => NULL			// Nombre de conector de datos
			);

	var $_aTmpVars = array();

	function inmersaSerialize ($AppName = NULL,$dbname = 'data') {
		if (is_object($AppName)) {
			if (!is_a($AppName,'inmersaSerialize') and !is_a($AppName,'wolSesion')) {
				$this->setFlag($this->ST_CORRUPT);
				return false;
			}
			if (is_a($AppName,'inmersaSerialize')) {
				$this->_aNames['sesion'] = $AppName->getAppName();
				$this->_aNames['data'] = $AppName->getDbName();
			} else {
				$this->_aNames['sesion'] = $AppName->App_Name;
				$this->_aNames['data'] = $dbname;
			}
		} else {
			if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
			if (empty($dbname)) $dbname = 'data';
			if (empty($this->_aNames['sesion'])) $this->_aNames['sesion'] = $AppName;
			if (empty($this->_aNames['data'])) {
				$this->_aNames['data'] = $dbname;
			}
		}
		if (!$this->_setUp()) return false;
		return true;
	}

        function __toString() {
		$tmpid = md5(implode(':',$this->_aTmpVars).'/'.implode(':',array_keys($this->_aTmpVars)));
                return '<'.get_class($this).':'.$this->_aNames['sesion'].'>'.$this->_aNames['data'].'/'.$tmpid;
        }

	function _setUp() {
		if (empty($this->_aNames['data']) OR empty($this->_aNames['sesion'])) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		$oSes = &$GLOBALS[$this->_aNames['sesion']];
		if (!is_a($oSes,'wolSesion')) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		$this->_oSesion=&$oSes;

		$this->_oDb = &$this->_oSesion->get_db($this->_aNames['data']);
		if (!is_object($this->_oDb)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		return true;
	}

	function &getDb() {
		return $this->_oDb;
	}

	function getDbName() {
		return $this->_aNames['data'];
	}

	function getAppName() {
		return $this->_aNames['sesion'];
	}

	function &getApp() {
		return $this->_oSesion;
	}

	function init() {
		if (!is_object($this->_oDb) AND !$this->_setUp()) return false;

		// debug("Detalle::init()");
		return true;
	}

	function cerrar() {
		unset($this->_oDb);
		unset($this->_oSesion);
		// $this->debug("Punto FiNAL tERMINAL! .. ",'cerrar');
	}

	function setVar($varname,$value) {
		$rval = false;
		if (!empty($varname)) {
			$this->_aTmpVars[$varname] = $value;
			$rval = true;
		}
		return $rval;
	}

	function getVar($varname) {
		return $this->_aTmpVars[$varname];
	}

	function unsetVar($varname) {
		unset($this->_aTmpVars[$varname]);
		return true;
	}

	function debug($msg,$method = '', $aP = NULL, $lev = 1) {
		// if (!$this->debug) return;
		if (is_array($aP) and sizeof($aP)) foreach ($aP as $k => $v) $plist .= ((!empty($plist)) ? ' , ' : ' ').$k.' = '.$v;
		if (is_array($msg) and sizeof($msg))
			foreach ($msg as $n => $m) {
				if (!is_array($m)) debug(get_class($this)."::".$method.((!empty($plist)) ? '( '.$plist.' ) ' : '() ').((!empty($n)) ? $n.' => ' : '').$m);
				else {
					debug(get_class($this)."::".$method.((!empty($plist)) ? '( '.$plist.' ) ' : '() ').((!empty($n)) ? $n.' : ' : '').' Array Below ');
					if ($GLOBALS['DEBUG']=='ON') {
						print_r($m);
						salida("<br/>\n");
					}
				}
			}
		else debug(get_class($this)."::".$method.((!empty($plist)) ? '('.$plist.') ' : '()').' => '.$msg);
		// if (1 OR $this->debug) debug(get_class($this).( (!empty($methodname)) ? '::'.$methodname.'() ' : ' ').$msg);
	}

	/** Control de Estado de la instancia **/
	function setFlag($flag) {
		if (is_numeric($flag)) $this->_dbItem_status |= $flag;
	}

	function unsetFlag($flag) {
		if (is_numeric($flag)) $this->_dbItem_status &= ~$flag;
	}

	function checkFlag($flag) {
		return ($this->_dbItem_status & $flag);
	}

}

class dbItem extends inmersaSerialize {
	var $ST_NEW = 1;
	var $ST_EDIT = 2;
	var $ST_DEL = 4;
	var $ST_OK = 8;

	// Variable de estados movica a la clase inmersaSerialize

	var $_tabla;
	var $_aCampos;
	var $_aClavesPrimarias;

	var $_aRecord;
	var $_aRecordPKs; // Claves primarias onLoad (constructor o dbFill)
	var $_aRecordMethods;
	var $_aRecordExclude;
	var $_aRecordNull = array();

	function dbItem ($appname,$dataconn,$tabla,$aData = NULL,$aActions = NULL) {
		if (is_object($appname)) {
			if (!is_a($appname,'inmersaSerialize')) {
				$this->setFlag($this->ST_CORRUPT);
				return false;
			}
			if (!parent::inmersaSerialize($appname->getAppName(),$appname->getDbName())) {
				$this->setFlag($this->ST_CORRUPT);
				return false;
			}
			if (is_a($appname,'dbItem')) {
				$this->_tabla = $appname->_tabla;
				$this->_aCampos = $appname->_aCampos;
				$this->_aRecordMethods = $appname->_aRecordMethods;
				$this->_aRecordExclude = $appname->_aRecordExclude;
			}
		} else {
			if (!parent::inmersaSerialize($appname,$dataconn)) {
				$this->setFlag($this->ST_CORRUPT);
				return false;
			}
		}

		if (empty($this->_tabla)) {
			$this->_tabla = $tabla;
			$oDb = $this->getDb();
			$aTmp = $oDb->get_fields($this->_tabla);
			foreach ($aTmp as $aFld) $this->_aCampos[$aFld['name']] = $aFld;
			$oS = &$this->getApp();
			$oS->setEntityDataType($tabla,$this->_aCampos);

			// Por defecto, comprobamos las acciones y exclusiones para los campos que estan en la bbdd.
			foreach ($this->_aCampos as $aFld) {
				if (is_array($aActions) AND sizeof($aActions) AND !empty($aActions[$aFld['name']])) {
					if (is_array($aActions[$aFld['name']]) AND sizeof($aActions[$aFld['name']])) {
						// Comprobamos si se ha indicado valores de exclusion
						if (isset($aActions[$aFld['name']]['exclude'])) {
							if (!is_array($aActions[$aFld['name']]['exclude'])) {
								$aTmpAcc[$aFld['name']]['new'] = (bool)$aActions[$aFld['name']]['exclude'];
								$aTmpAcc[$aFld['name']]['edit'] = (bool)$aActions[$aFld['name']]['exclude'];
							} else {
								if (isset($aActions[$aFld['name']]['exclude']['new'])) {
									$aTmpAcc[$aFld['name']]['new'] = (bool)$aActions[$aFld['name']]['exclude']['new'];
								}
								if (isset($aActions[$aFld['name']]['exclude']['edit']))
									$aTmpAcc[$aFld['name']]['edit'] = (bool)$aActions[$aFld['name']]['exclude']['edit'];
							}
						} // Fin de si hay exclusiones mentadas
					}
				} // Fin de si hay acciones para este campo
			} // Fin de la travesia por campos 

			// Si en la lista de metodos de tratamiento de campos, existen algunos que no esten en la bbdd. Lo permitimos tambien (si el metodo existe)
			if (is_array($aActions) AND sizeof($aActions)) 
				foreach ($aActions as $campo => $aAcc) {
					if (isset($aAcc['method']) AND method_exists($this,$aAcc['method']) ) {
						//Comprobamos si se indica nombre de metodo de tratamiento del campo.
						$aTmpMeth[$campo] = $aAcc['method'];
						if (!$this->_isField($campo) AND isset($aAcc['exclude']) ) {
							if (!is_array($aAcc['exclude'])) {
								$aTmpAcc[$campo]['new'] = (bool)$aAcc['exclude'];
								$aTmpAcc[$campo]['edit'] = (bool)$aAcc['exclude'];
							} else {
								if (isset($aAcc['exclude']['new'])) {
									$aTmpAcc[$campo]['new'] = (bool)$aAcc['exclude']['new'];
								}
								if (isset($aAcc['exclude']['edit']))
									$aTmpAcc[$campo]['edit'] = (bool)$aAcc['exclude']['edit'];
							}
						}
					}
				}

			if (is_array($aTmpAcc) AND sizeof($aTmpAcc)) {
				$this->_aRecordExclude = $aTmpAcc;
			}
			if (is_array($aTmpMeth) AND sizeof($aTmpMeth)) {
				$this->_aRecordMethods = $aTmpMeth;
			}
		}

		if (!is_array($aData) OR !sizeof($aData)) $this->setFlag($this->ST_NEW);
		//Siempre se han de registrar las claves primarias.
		$totpks = 0;
		$aTmp = array();
		$donepks = 0;
		foreach ($this->_aCampos as $aFld) {
			if (!empty($aFld['flags']) AND strstr($aFld['flags'],'primary_key')) {
				$totpks++;
				$bPK = true;
			} else $bPK = false;
			$fld = NULL;
			$bEmpty = false;
			if (is_numeric($aData[$aFld['name']]) OR !empty($aData[$aFld['name']])) {
				$fld = $aFld['name'];
			} elseif (is_numeric($aData[$this->_tabla.'.'.$aFld['name']]) OR !empty($aData[$this->_tabla.'.'.$aFld['name']])) {
				$fld = $this->_tabla.'.'.$aFld['name'];
			} else $bEmpty = true;; 

			if (!empty($aFld['flags']) AND strstr($aFld['flags'],'primary_key')) {
				$donepks++;
				if ($bEmpty) $fld = $aFld['name'];
			} elseif ($bEmpty) continue;

			if (is_array($aData) AND sizeof($aData)) $aTmp[$aFld['name']] = $aData[$fld];
			if ($bPK) $aTmpPK[$aFld['name']] = $aData[$fld];
		}
		$this->_aRecordPKs = $aTmpPK;
		if (is_array($aTmp) AND sizeof($aTmp) ) { $this->_aRecord = $aTmp; }
		return true;
	}

	function dbFill($aIdx) {
		if (is_numeric($aIdx)) {
			$aKs = $this->listPrimaryKeys();
			if (!is_array($aKs) or !sizeof($aKs)) return false;
			$k = array_shift($aKs);
			$aIdx = array($k => $aIdx);
		}
		if (!is_array($aIdx) OR !sizeof($aIdx)) return false;
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return false;

		$oDb = $this->getDb();

		$tabla = ( (!empty($this->_AliasEntidad)) ? $this->_AliasEntidad : $this->getEntityName() );
		foreach ($this->_aCampos as $campo => $aK) {
			$cons .= ( (!empty($cons)) ? ', ' : '' ).$tabla.'.'.$campo.' as "'.( (!strcmp($this->_AliasEntidad,$tabla)) ? $campo : $tabla.'.'.$campo ).'" ';
		}
		$cons = 'SELECT '.$cons;
		$cons .= 'FROM '.$this->getEntityName().( (!empty($this->_AliasEntidad)) ? ' as '.$this->_AliasEntidad : '' );
		$cons .= ' WHERE ';
		foreach ($aIdx as $campo => $valor) {
			$cons.= ( (!strchr($campo,'\.')) 
							? ( (!empty($this->_AliasEntidad)) ? $this->_AliasEntidad : $this->getEntityName() ).'.'
							: ''
							).$campo .' = '.( (is_numeric($valor)) ? $valor : '"'.$valor.'"' );
		}
		$retval = false;
		$rs = $oDb->query($cons);
		if (!$oDb->num_rows($rs)) {
			$this->_aRecord = NULL;
		} else {
			if ($oDb->num_rows($rs)>1) {
				debug("dbItemMultiEntity::dbFill() More than one row fetched");
			} else {
				$this->_aRecord = array();
				$retval = true;

				while ($aData = $oDb->fetch_assoc($rs)) {
					$aMain = array();

					foreach ($aData as $campo => $valor) {
						if (strchr($campo,'.')) {
							$aTmp = split('\.',$campo);
							$tb = $aTmp[0];
							$campo = $aTmp[1];
						}
						if (is_numeric($valor) OR !empty($valor)) $aMain[$campo] = $valor;
						if ($this->isPrimaryKey($campo)) $aMainPKs[$campo] = $valor;
					}
					if (!is_array($aMain) OR !sizeof($aMain)) continue;

					$this->_aRecord = $aMain;
					if (is_array($aMainPKs) and sizeof($aMainPKs)) $this->_aRecordPKs = $aMainPKs;
				}
				if (method_exists($this,'postFill')) {
					$retval = $this->postFill($retval);
					if (!isset($retval)) $retval = true;
					elseif (!$retval) {
						$this->_aRecord = NULL;
					}
				}
			}
		}
		if ($retval) $this->unsetFlag($this->ST_NEW);

		return $retval;
	}

	function getData() {
		return $this->_aRecord;
	}

	function update($aData,$bForce = false) {
		if (!is_array($aData) OR !sizeof($aData)) return false;
		if (!isset($bForce)) $bForce = false;

		if (method_exists($this,'preUpdate')) $retval = $this->preUpdate($aData,$bForce);
		else $retval = true;

		if ($retval) {
			$retval = false;
			$bModified = false;
			$aOrig = $this->getData();
			foreach ($aData as $campo => $valor) {
				if (!$this->_isField($campo)) continue;

				if (!$bForce and !$this->_verifyFieldAccess($campo)) continue;

				$method = $this->_findMethodForField($campo);

				if (!empty($method)) {
					// $this->debug('llamando a '.$method." para $campo con $valor ",'update');
					$tmprval = $this->$method ($valor,$campo);
				} else {
					$tmprval = $this->_setAttribute($campo,$valor);
				}
				if ($tmprval) {
					// debug("MARCANDO como modificado por $campo ");
					$bModified = true;
				}
			}
			
			if (method_exists($this,'postUpdate')) {
				$retval = $this->postUpdate($bModified);
				if (!$retval) {
					$this->_aRecord = $aOrig;
				}
			} elseif ($bModified) $retval = true;
			else $retval = false;

			if ($retval) {
				$this->setFlag($this->ST_EDIT);
			} 
		}
		return $retval;
	}

	function delete() {
		$this->setFlag($this->ST_DEL);
		return true;
	}

	function isDeleted() {
		return $this->checkFlag($this->ST_DEL);
	}

	function undelete() {
		$this->unsetFlag($this->ST_DEL);
		return true;
	}

	function setAttribute($campo,$valor,$bForce = false,$bMarkIfChanged = true) {
		if (!isset($bMarkIfChanged)) $bMarkIfChanged = true;
		if (!isset($bForce)) $bForce = false;

		$retval = false;
			
		if ($bForce OR $this->_verifyFieldAccess($campo)) {
			if ($bForce OR $this->_isField($campo)) {
				$retval = $this->_setAttribute($campo,$valor);
				/** Si alguiere que se llame al metodo, que lo llame el. 
				  y si no lo conoce, que use el metodo update() 
				  NOTA 6/8/05: Mejor que no conozca los metodos de estado. Insertada opcion bMarkIfChanged
				  NOTAII 6/8/05: Marcar el registro modificado, solo funciona para la tabla base (de momento), que la unica con simetria db
					  **/
				if ($retval AND $bMarkIfChanged) $this->setFlag($this->ST_EDIT);
			}
		}
		return $retval;
	}

	function getAttribute($campo) {
		return $this->_aRecord[$campo];
	}

	function _verifyFieldAccess($campo) {
		if (empty($campo)) return true;
		if ($this->checkFlag($this->ST_NEW)) {
			if (is_array($this->_aRecordExclude[$campo]) AND isset($this->_aRecordExclude[$campo]['new']) AND $this->_aRecordExclude[$campo]['new']) return false;
		} else {
			if (is_array($this->_aRecordExclude[$campo]) AND isset($this->_aRecordExclude[$campo]['edit']) AND $this->_aRecordExclude[$campo]['edit']) return false;
		}
		return true;
	}

	function _findMethodForField($campo) {
		if (empty($campo)) return NULL;
		return $this->_aRecordMethods[$campo];
	}

	function _setAttribute($campo,$valor) {
		$retval = false;
		// $this->debug("campo $campo ",'_setAttribute');
		if ( (!isset($this->_aRecord[$campo]) and (is_numeric($valor) or !empty($valor))) or $this->_aRecord[$campo] != $valor) {
			// debug("campo $campo => Valor ($valor) en el registro (".$this->_aRecord[$campo].") Existe? ".isset($this->_aRecord[$campo]));
			if (!isset($valor)) { 
				$this->_aRecord[$campo] = NULL;
				if (!is_array($this->_aRecordNull)) $this->_aRecordNull = array();
				if (!in_array($campo,$this->_aRecordNull)) array_push($this->_aRecordNull,$campo);
			} elseif (!isset($this->_aRecord[$campo]) AND in_array($campo,$this->_aRecordNull)) {
				$aKs = array_keys($this->_aRecordNull,$campo);
				if (sizeof($aKs))
					foreach ($aKs as $key) {
						$this->_aRecordNull[$key] = NULL;
						unset($this->_aRecordNull[$key]);
					}
			}
			$this->_aRecord[$campo] = $valor;
			// debug(get_class($this)."::_setAttribute($campo,$valor)");
			$retval = true;
		}
		return $retval;
	}

	function _cleanAttribute($campo) {
		if (empty($campo)) return false;
		if (!isset($this->_aRecord[$campo])) return true;
		$this->_aRecord[$campo] = NULL;
		unset($this->_aRecord[$campo]);
		return true;
	}

	function Dump($type = 'db') {
		static $aDumpTypes = array('db' => 'dbDump');

		if (empty($type)) $type = 'db';
		$dumpmethod = $aDumpTypes[$type];
		if (empty($dumpmethod)) return false;

		$retval = false;
		if (method_exists($this,'preDump')) $retval = $this->preDump($type);
		else $retval = true;
		if ($retval) {
			switch ($type) {
				case 'db':
					$retdump = $this->$dumpmethod();

					if (method_exists($this,'postDump') AND !$this->postDump($retdump,$type)) {
						// FixMe: Cuando exista el soporte de transacciones, aqui va un rollback
						$retval = false;
					} else $retval = true;

					if ($retval) $this->unsetFlag($this->ST_NEW | $this->ST_EDIT);
					break;
			}
		}
		return $retval;
	}

	function _isField($campo) {
		if (empty($campo)) return false;
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return false;
		foreach ($this->_aCampos as $aFld) if (!strcmp($aFld['name'],$campo)) return true;
		if (isset($this->_aRecordMethods[$campo])) return true;
		return false;
	}

	function dbDump() {
		if (!is_array($this->_aRecord) OR !sizeof($this->_aRecord)) {
			$this->debug("Error: _aRecord not found ",'dbDump');
			return false;
		}
		$oDb = &$this->getDb();
		$retval = false;
		if ($this->checkFlag($this->ST_NEW)) {
			if ($this->checkFlag($this->ST_DEL)) {
				debug("Intentando borrar uno que es nuevo ");
				return true;
			}
			$this->debug("tb_insert ... ".$this->_tabla,'dbDump');
			if (is_array($this->_aRecordNull) AND sizeof($this->_aRecordNull))
				foreach ($this->_aRecordNull as $fld)
					$this->_aRecord[$fld] = 'null';
			$oDb->tb_insert($this->_tabla,$this->_aRecord);
			//dbdumprecord!!
			// print_r($this->_aRecord);
			$retval = true;

			$aTmp = $oDb->get_keys($this->_tabla);
			if (sizeof($aTmp) == 1) {
				$tmpkey = array_shift($aTmp);
				if ($this->isPrimaryKey($tmpkey,true)) {
					$this->_aRecord[$tmpkey] = $oDb->last_insert_id();
					$this->debug("last insert id $tmpkey = ".$this->_aRecord[$tmpkey],'dbDump');
				}
			}
			foreach ($this->_aRecord as $fld => $val)
				if (!strcasecmp($val,'null')) {
					$this->_aRecord[$fld] = NULL;
					unset($this->_aRecord[$fld]);
				}
		} elseif ($this->checkFlag($this->ST_DEL)) {
			$this->debug("tb_delete ... Completo? ".(int)$this->isComplete(),'dbDump');
			if ($this->isComplete()) {
				$aTmp = $oDb->get_keys($this->_tabla);
				if (is_array($aTmp) AND sizeof($aTmp)) {
					foreach ($aTmp as $fld) $aKeys[$fld] = $this->getAttribute($fld);
				} else $aKeys = $this->_aRecord;
				if (is_array($this->_aRecordPKs) and sizeof($this->_aRecordPKs)) {
					$oDb->tb_delete($this->_tabla,$this->_aRecordPKs);
				} else $oDb->tb_delete($this->_tabla,$aKeys);
				$retval = true;
				// $this->unsetFlag($this->ST_DEL);
			}
		} elseif ($this->checkFlag($this->ST_EDIT)) {
			if ($this->isComplete()) {
				$this->debug(array('tb_update. Claves'=>$this->_aRecordPKs),'dbDump');
				if (is_array($this->_aRecordNull) AND sizeof($this->_aRecordNull))
					foreach ($this->_aRecordNull as $fld)
						$this->_aRecord[$fld] = 'null';
				if (is_array($this->_aRecordPKs) and sizeof($this->_aRecordPKs)) {
					$oDb->tb_update($this->_tabla,$this->_aRecord,$this->_aRecordPKs);
				} else $oDb->tb_update($this->_tabla,$this->_aRecord);

				$retval = true;
				foreach ($this->_aRecord as $fld => $val)
					if (!strcasecmp($val,'null')) {
						$this->_aRecord[$fld] = NULL;
						unset($this->_aRecord[$fld]);
					}
			}
		}
		return $retval;
	}

	function isComplete() {
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return false;
		if (!is_array($this->_aRecord) OR !sizeof($this->_aRecord)) return false;

		$bAllowEmpty = false;
		$bEmpty = false;
		foreach ($this->_aCampos as $aFld) {
			if (strstr($aFld['flags'],'primary_key')) {
				if (strstr($aFld['flags'],'multiple_key')) $bAllowEmpty = true;
				if ((!is_numeric($this->_aRecord[$aFld['name']]) AND empty($this->_aRecord[$aFld['name']])) ) $bEmpty = true;
			}
		}
		if ( ($bEmpty and $bAllowEmpty) or (!$bEmpty) ) $retval = true;
		else $retval = false;
		return $retval;
	}

	function isPrimaryKey($campo,$bAuto = false) {
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return NULL;

		$retval = false;
		if (sizeof($this->_aCampos[$campo]) AND strstr($this->_aCampos[$campo]['flags'],'primary_key')) {
			if ($bAuto) {
				if (strstr($this->_aCampos[$campo]['flags'],'auto_increment')) $retval = true;
				else $retval = false;
			} else $retval = true;
		}

		return $retval;
	}

	function listPrimaryKeys() {
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return NULL;

		if (!is_array($this->_aClavesPrimarias) OR !is_array($this->_aClavesPrimarias)) 
			foreach ($this->_aCampos as $fldname => $aFld) 
				if (strstr($aFld['flags'],'primary_key')) {
					if (!is_array($this->_aClavesPrimarias)) $this->_aClavesPrimarias = array();
					array_push($this->_aClavesPrimarias,$fldname);
				}

		return $this->_aClavesPrimarias;
	}

	function getEntityName() {
		return $this->_tabla;
	}

	function getEntityDesc($campo = NULL) {
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return NULL;
		if (empty($campo)) return $this->_aCampos;
		foreach ($this->_aCampos as $aFld) if (!strcmp($aFld['name'],$campo)) return $aFld;
		return NULL;
	}

	/** Metodos Abstractos **/
	function preDump() {
		return true;
	}

	function postDump($retval = NULL,$type = NULL) {
		return true;
	}

	function preUpdate() {
		return true;
	}

	function postUpdate($retval = NULL) {
		return true;
	}

	/** Control de Estado de la instancia **/
	function setFlag($flag) {
		// debug(get_class($this)."::<b>set</b>Flag($flag): ".$this->_dbItem_status);
		if (is_numeric($flag)) $this->_dbItem_status |= $flag;
	}

	function unsetFlag($flag) {
		// debug(get_class($this)."::<u>unset</u>Flag($flag): ".$this->_dbItem_status);
		if (is_numeric($flag)) $this->_dbItem_status &= ~$flag;
	}

	function checkFlag($flag) {
		// debug(get_class($this)."::checkFlag($flag): ".$this->_dbItem_status);
		return ($this->_dbItem_status & $flag);
	}

}

class dbItemMultiEntity extends dbItem {

	var $_AliasEntidad;
	var $_aCamposEntidades;
	var $_aDescEntidades;
	var $_aDestinosRuta;
	var $_aAuxRecord;

	function dbItemMultiEntity ($appname,$dataconn,$tabla,$aCampos,$aData = NULL,$aActions = NULL) {

		if (!parent::dbItem($appname,$dataconn,$tabla,$aData,$aActions)) return false;

		if (is_object($appname) AND (is_a($appname,'dbItemMultiEntity') OR is_a($appname,'IndexList')) ) {
			$this->_AliasEntidad = $appname->_AliasEntidad;
			$this->_aCamposEntidades = $appname->_aCamposEntidades;
			$this->_aDescEntidades = $appname->_aDescEntidades;
			$this->_aDestinosRuta = $appname->_aDestinosRuta;
		} else {
			$aTmp = $this->_getDestinosRuta($tabla,$aCampos);
			$this->_AliasEntidad = $aTmp[0];
			$this->_aDestinosRuta = $aTmp[1];
			$this->_aCamposEntidades = $aTmp[2];
			$this->_aDescEntidades = $aTmp[3];
		}

		if (is_array($aData) AND sizeof($aData)) {
			foreach ($aData as $index => $values) {
				if (is_array($values)) {
					if (!is_array($this->_aCamposEntidades[$index])) continue;
					$bDoIt = false;
					foreach ($values as $tmpval) 
						if (is_numeric($tmpval) OR !empty($tmpval)) {
							$bDoIt = true;
							break;
						}
					if (!$bDoIt) continue;

					if (!strcmp($this->_AliasEntidad,$index)) $this->_aRecord = $values;
					else $this->_aAuxRecord[$index] = $values;
				} else {
					if (!is_numeric($index) AND !empty($index) AND (is_numeric($values) OR !empty($values)) ) {
				
						if (strstr($index,'.') ) {
							$aTmp = split('\.',$index);

							if (!strcmp($this->_AliasEntidad,$aTmp[0])) $this->_aRecord[$aTmp[1]] = $values;
							else $this->_aAuxRecord[$aTmp[0]][$aTmp[1]] = $values;
						} else {
							$this->_aRecord[$index] = $values;
						}
					}
				}
			}
		}
		return true;
	}

	function _getDestinosRuta($tabla,$aCampos) {
		if (empty($tabla)) return NULL;
		if (is_array($aCampos) AND sizeof($aCampos)) {
			$oS = &$this->getApp();
			foreach ($aCampos as $tb => $aFlds) {
				if (strstr($tb,':')) {
					$aTmp = split('\:',$tb);
					$tbsinalias = $aTmp[0];
					$tablita = $aTmp[1];
				} else $tablita = $tb;
				if (!empty($tbsinalias) AND !strcmp($tbsinalias,$tabla)) {
					$AliasEntidad = $tablita;
				} elseif (empty($tbsinalias)) $tbsinalias = $tablita;
				if (!is_array($aDestinosRuta)) $aDestinosRuta = array();
				array_push($aDestinosRuta,$tb);
				$aCamposEntidades[$tablita] = $aFlds;
				// Obteniendo la descripcion de las tablas auxiliares.
				$aCamposEntidadesDesc[$tablita] = array();
				if (!empty($tbsinalias)) {
					$oDb = &$this->getDb();
					$aTmpFlds = $oDb->get_fields($tbsinalias);
					foreach ($aTmpFlds as $atmpv) $aTmp2[$atmpv['name']] = $atmpv;
					$oS->setEntityDataType($tablita,$aTmp2);
					// if ($tablita!=$tbsinalias) $oS->setEntityDataLink($tablita,$tbsinalias,$truefield);

					if (is_array($aTmpFlds) AND sizeof($aTmpFlds)) 
						foreach ($aTmpFlds as $aTmp) {
							if (in_array($aTmp['name'],$aFlds)) {
								$aCamposEntidadesDesc[$tablita][$aTmp['name']] = $aTmp;
							}
						}
				}
			}
			if (empty($AliasEntidad)) $AliasEntidad = $tabla;
		}
		return array($AliasEntidad,$aDestinosRuta,$aCamposEntidades,$aCamposEntidadesDesc);
	}

	function _splitEntityField($campo,$entidad = 'main') {
		if (!is_array($this->_aCampos) OR !sizeof($this->_aCampos)) return NULL;
		if (strchr($campo,'.')) {
			$aTmp = split('\.',$campo);
			$entidad = $aTmp[0];
			$campo = $aTmp[1];
		}

		if (empty($entidad) OR !strcasecmp($entidad,'main') OR !strcmp($entidad,$this->_AliasEntidad) 
				OR !is_array($this->_aCamposEntidades[$entidad]) ) $entidad = '__main__';
		if (empty($entidad)) return NULL;
		return array('entity' => $entidad, 'field' => $campo);
	}

	function listEntities($bFilled = false) {
		if (!is_array($this->_aCamposEntidades) OR !sizeof($this->_aCamposEntidades)) return NULL;
		if ($bFilled)
			$retval =  array_diff(array_keys($this->_aAuxRecord),array($this->_AliasEntidad,$this->getEntityName()));
		else 
			$retval =  array_diff(array_keys($this->_aCamposEntidades),array($this->_AliasEntidad,$this->getEntityName()));
		return $retval;
	}

	function getEntityDesc($campo = NULL, $entidad = 'main') {
		$aE = $this->_splitEntityField($campo,$entidad);
		if (!is_array($aE)) return NULL;
		$entidad = $aE['entity'];
		$campo = $aE['field'];
		$retval = NULL;

		// $this->debug("($campo,$entidad)",'getEntityDesc');
		if ($entidad == '__main__') {
			$retval = parent::getEntityDesc($campo);
		} else {
			if (!is_array($this->_aDescEntidades[$entidad]) OR !sizeof($this->_aDescEntidades[$entidad])) return NULL;
			if (empty($campo)) return $this->_aDescEntidades[$entidad];
			else return $this->_aDescEntidades[$entidad][$campo];
		}

		return $retval;
	}

	function isPrimaryKey($campo,$entidad = 'main',$bAuto = false) {
		$aE = $this->_splitEntityField($campo,$entidad);
		if (!is_array($aE)) return NULL;
		$entidad = $aE['entity'];
		$campo = $aE['field'];
		$retval = false;
		if ($entidad == '__main__') {
			$retval = parent::isPrimaryKey($campo,$bAuto);
		} else {
			$aDesc = $this->getEntityDesc($campo,$entidad);
			if (!is_array($aDesc) OR !sizeof($aDesc)) $retval = false;
			else {
				if (strstr($aDesc['flags'],'primary_key')) {
					if ($bAuto) {
						if (strstr($aDesc['flags'],'auto_increment')) $retval = true;
						else $retval = false;
					} else $retval = true;
				}
			}
		}
		return $retval;
	}

	function dbFill($aIdx) {
		if (is_numeric($aIdx)) {
			$aKs = $this->listPrimaryKeys();
			if (!is_array($aKs) or !sizeof($aKs)) return false;
			$k = array_shift($aKs);
			$aIdx = array($k => $aIdx);
		}
		if (!is_array($aIdx) OR !sizeof($aIdx)) return false;
		if (!is_array($this->_aCamposEntidades) OR !sizeof($this->_aCamposEntidades)) return false;

		// $this->sesion->setEntityDataType($aTablas[$i],$this->db->get_fields($aTablas[$i]));
		// if (!empty($fromas)) $this->parent->sesion->setEntityDataLink($fromas,$from,$truefield);

		$oDb = $this->getDb();
		$aRet = $oDb->ruta($this->getEntityName(),$this->_aDestinosRuta);

		foreach ($this->_aCamposEntidades as $tabla => $aClaves) {
			foreach ($aClaves as $campo)
				$cons .= ( (!empty($cons)) ? ', ' : '' ).$tabla.'.'.$campo.' as "'.( (!strcmp($this->_AliasEntidad,$tabla)) ? $campo : $tabla.'.'.$campo ).'" ';
		}
		$cons = 'SELECT '.$cons;
		$cons .= 'FROM '.$aRet['left_join_from'];
		$cons .= ' WHERE ';
		foreach ($aIdx as $campo => $valor) {
			$cons.= ( (!strchr($campo,'\.')) 
							? ( (!empty($this->_AliasEntidad)) ? $this->_AliasEntidad : $this->getEntityName() ).'.'
							: ''
							).$campo .' = '.( (is_numeric($valor)) ? $valor : '"'.$valor.'"' );
		}
		$cons .= ' LIMIT 1';

		$retval = false;
		$rs = $oDb->query($cons);
		if (!$oDb->num_rows($rs)) {
			$this->_aRecord = NULL;
			$this->_aAuxRecord = NULL;
		} else {
			if ($oDb->num_rows($rs)>1) {
				$this->debug("More than one row fetched",'dbFill');
			} else {
				$this->_aRecord = array();
				$this->_aAuxRecord = array();
				$retval = true;

				while ($aData = $oDb->fetch_assoc($rs)) {
					$aMain = array();
					$aExtras = array();

					foreach ($aData as $campo => $valor) {
						if (strchr($campo,'.')) {
							$aTmp = split('\.',$campo);
							if (is_numeric($valor) OR !empty($valor)) $aExtras[$aTmp[0]][$aTmp[1]] = $valor;
						} else {
							if (is_numeric($valor) OR !empty($valor)) $aMain[$campo] = $valor;
							if ($this->isPrimaryKey($campo)) $aMainPKs[$campo] = $valor;
						}
					}
					if (!is_array($aMain) OR !sizeof($aMain)) continue;
					$this->_aRecord = $aMain;
					$this->_aAuxRecord = $aExtras;
					if (is_array($aMainPKs) and sizeof($aMainPKs)) $this->_aRecordPKs = $aMainPKs;
				}
				if (method_exists($this,'postFill')) {
					$retval = $this->postFill($retval);
					if (!isset($retval)) $retval = true;
					elseif (!$retval) {
						$this->_aRecord = NULL;
						$this->_aAuxRecord = NULL;
					}
				}
			}
		}
		if ($retval) $this->unsetFlag($this->ST_NEW);

		return $retval;
	}

	function dbFillEntity($aIdx,$entidad = NULL) {
		if (is_numeric($aIdx)) {
			// FixMe: Falta extraer claves primarias
			$aIdx = array($aIdx);
		}
		if (!is_array($aIdx) OR !sizeof($aIdx)) return false;
		$bOk = false;
		// $this->debug(array("ent: $entidad => "=>$aIdx),'dbFillEntity');
		foreach ($aIdx as $fld => $val) 
			if (!empty($val) OR is_numeric($val)) {
				$bOk = true; 
				break;
			}
		if (!$bOk) return false;
		if (!is_array($this->_aCamposEntidades) OR !sizeof($this->_aCamposEntidades[$entidad])) return false;

		$tabla = $this->findTbFromAlias($entidad);
		if (empty($tabla)) return false;
		$oDb = $this->getDb();

		$aClaves = $this->_aCamposEntidades[$entidad];
		foreach ($aClaves as $campo)
			$cons .= ( (!empty($cons)) ? ', ' : '' ).$entidad.'.'.$campo.' as "'.( (!strcmp($this->_AliasEntidad,$entidad)) ? $campo : $entidad.'.'.$campo ).'" ';

		$cons = 'SELECT '.$cons;
		$cons .= 'FROM '.$tabla.' as '.$entidad.' ';
		$cons .= ' WHERE ';
		foreach ($aIdx as $campo => $valor) {
			$cons.= $campo .' = '.( (is_numeric($valor)) ? $valor : '"'.$valor.'"' );
		}

		$retval = false;
		if (!empty($this->_AliasEntidad)) $aliasbase = $this->_AliasEntidad;
		else $aliasbase = $this->getEntityName();

		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			if ($oDb->num_rows($rs)>1) {
				$this->debug("More than one row fetched",'dbFillEntity');
			} else {

				$retval = true;
				while ($aData = $oDb->fetch_assoc($rs)) {
					$aMain = array();
					$aExtras = array();

					foreach ($aData as $campo => $valor) {
						if (strchr($campo,'.')) {
							$aTmp = split('\.',$campo);
							if (is_numeric($valor) OR !empty($valor)) $aExtras[$aTmp[0]][$aTmp[1]] = $valor;
						} else {
							if (is_numeric($valor) OR !empty($valor)) $aExtras[$aliasbase][$campo] = $valor;
						}
					}

					if (is_array($aExtras) AND sizeof($aExtras))
						foreach ($aExtras as $tb => $aVal) {
							if (!strcmp($tb,$aliasbase)) {
								foreach ($aVal as $fld => $val) $this->_aRecord[$fld] = $val;
							} else {
								foreach ($aVal as $fld => $val) $this->_aAuxRecord[$tb][$fld] = $val;
							}
						}
				}
			}
		}

		return $retval;
	}

	function findTbFromAlias($alias) {
		if (!strcmp($alias,$this->getEntityName()) OR !strcmp($alias,$this->_AliasEntidad)) 
			return $this->getEntityName();
		if (is_array($this->_aDestinosRuta)) 
			foreach ($this->_aDestinosRuta as $tb) {
				if (strchr($tb,':')) {
					$aTmp = split(':',$tb);
					if (!strcmp($aTmp[1],$alias)) return $aTmp[0];
					elseif (!strcmp($aTmp[0],$alias)) $retval = $aTmp[0];
				} elseif (!strcmp($tb,$alias)) return $tb;
			}
		return $retval;
	}

	function getData($what = '__main__') {
		if (empty($what) OR !strcasecmp($what,'main') OR !strcmp($what,$this->_AliasEntidad) ) $what = '__main__';
		elseif (!strcasecmp($what,'full') OR !strcasecmp($what,'all')) $what = NULL;

		if ($what) {
			if ($what == '__main__') $aRetVal = parent::getData();
			else $aRetVal = $this->_aAuxRecord[$what];
		} else {
			$aRetVal = $this->_aAuxRecord;
			$aRetVal[$this->_AliasEntidad] = parent::getData();
		}
		return $aRetVal;
	}

	function update($aVal,$entity = '__main__',$bForce = false) {
		if (empty($entity) OR !strcasecmp($entity,'main') OR !strcmp($entity,$this->_AliasEntidad) ) $entity = '__main__';
		if (empty($entity)) return false;

		if ($entity == '__main__') $retval = parent::update($aVal,$bForce);
		else {
			if ($bForce) $this->_aAuxRecord[$entity] = $aVal;
			else {
				$aDesc = $this->getEntityDesc(NULL,$entity);
				foreach ($aDesc as $fld => $aTipo) $this->_aAuxRecord[$entity][$fld] = $aVal[$fld];
			}
			$retval = true;
		}
		return $retval;
	}

	function setAttribute($campo,$valor,$entidad = '__main__',$bForce = false,$bMarkIfChanged = true) {
		if (empty($entidad) OR !strcasecmp($entidad,'main') OR !strcmp($entidad,$this->_AliasEntidad) ) $entidad = '__main__';
		if (empty($entidad)) return false;
		if (!isset($bMarkIfChanged)) $bMarkIfChanged = true;
		if (!isset($bForce)) $bForce = false;

		$retval = false;
			
		// debug("dbItemMultiEntity::setAttribute() ($campo,$valor,$entidad,$bForce)");
		if ($bForce OR $this->_verifyFieldAccess($campo)) {
			if ($entidad == '__main__') {
				if ($bForce OR $this->_isField($campo)) {
					$retval = parent::_setAttribute($campo,$valor);
					/** Si alguiere que se llame al metodo, que lo llame el. 
					  y si no lo conoce, que use el metodo update() 
					  NOTA 6/8/05: Mejor que no conozca los metodos de estado. Insertada opcion bMarkIfChanged
					  NOTAII 6/8/05: Marcar el registro modificado, solo funciona para la tabla base (de momento), que la unica con simetria db
						  **/
					if ($retval AND $bMarkIfChanged) $this->setFlag($this->ST_EDIT);
				}
			} else {
				if (is_array($this->_aAuxRecord[$entidad]) AND sizeof($this->_aAuxRecord[$entidad]) 
						AND $this->_aAuxRecord[$entidad][$campo] != $valor) {
					$this->_aAuxRecord[$entidad][$campo] = $valor;
					$retval = true;
				}
			}
		}
		return $retval;
	}

	function getAttribute($campo,$entidad = NULL) {
		if (empty($entidad) AND strchr($campo,'.')) {
			$aTmp = split('\.',$campo);
			$entidad = $aTmp[0];
			$campo = $aTmp[1];
		}
		if (empty($entidad) OR !strcasecmp($entidad,'main') OR !strcmp($entidad,$this->_AliasEntidad) 
				OR !is_array($this->_aCamposEntidades[$entidad]) ) $entidad = '__main__';
		if (empty($entidad)) return false;
		$retval = false;
		if ($entidad == '__main__') {
			$retval = parent::getAttribute($campo);
		} else {
			if (is_array($this->_aAuxRecord[$entidad]) AND sizeof($this->_aAuxRecord[$entidad]) AND $this->_aAuxRecord[$entidad][$campo] != $valor) {
				$retval = $this->_aAuxRecord[$entidad][$campo];
			}
		}
		return $retval;
	}

	function updateForeignKey($valor,$campo,$bForce = false) {
		$val = $this->getAttribute($campo);
		//$this->debug("param a ($valor / $val) y b $campo ",'<b>updateForeignKey</b>');
		if (!$bForce and $val==$valor) return false;
		$rval = false;
		$aEList = $this->listEntities();
		foreach ($aEList as $entidad) {
			//$this->debug("Comprobando si $campo es clave de $entidad ... ",'updateForeignKey');
			if ($this->isPrimaryKey($campo,$entidad)) {
				$this->debug(" $campo ES clave de $entidad ... ",'updateForeignKey');
				$rval = $this->dbFillEntity(array($campo => $valor),$entidad);
				if ($rval) $r = $this->setAttribute($campo,$valor);
				break;
			}
		}
		return $rval;
	}

}

class dbListItem extends dbItemMultiEntity {
	var $_oList = NULL;
	var $_iIdx = NULL;

	function dbListItem (&$oList,$idx = NULL ,$aData = NULL,$aActions = NULL) {
		if (!is_object($oList) OR !is_a($oList,'IndexList')) return false;

		$this->_oList = &$oList;
		if (is_numeric($idx)) $this->_setPositionInList($idx);

		if (sizeof($this->_oList->aoItems)) {
			$this->_oList->firstItem();
			return parent::dbItemMultiEntity($this->_oList->getItem(),NULL,NULL,NULL,$aData);
		} else {
			// debug("<b>dbListItem</b> - constructur - ".get_class($this->_oList));
			// print_r(array_keys($this->_oList->_aCamposEntidades));
			// return parent::dbItemMultiEntity($this->_oList->getAppName(),$this->_oList->getDbName(),$this->_oList->tabla,$this->_oList->aCampos,$aData,$aActions);
			return parent::dbItemMultiEntity($this->_oList,NULL,$this->_oList->tabla,$this->_oList->_aCamposEntidades,$aData,$aActions);
		}
	}

	function _setPositionInList($idx) {
		if (!is_numeric($idx)) return false;
		$this->_iIdx = $idx;
		return true;
	}

	function getPositionInList() {
		return $this->_iIdx;
	}

	function &getList() {
		return $this->_oList;
	}

	function _setAttribute($campo,$valor) {
		// Si se ha cambiado, llamamos a desindexar este campo, y lo reindexamos
		$retval = false;
		if (parent::_setAttribute($campo,$valor)) {
			$oList = &$this->getList();
			$oList->unindexItem($this->getPositionInList(),$campo);
			$oList->indexItem($this->getPositionInList(),$campo);
			$retval = true;
		}
		return $retval;
	}

	function delete() {
		$retval = false;
		if (parent::delete()) {
			$this->debug('Pos: '.$this->getPositionInList(),'delete');
			$oList = &$this->getList();
			$oList->unindexItem($this->getPositionInList());
			$retval = true;
		}
		return $retval;
	}

	function undelete() {
		$retval = false;
		if (parent::undelete()) {
			$oList = &$this->getList();
			$oList->indexItem($this->getPositionInList());
			$retval = true;
		}
		return $retval;
	}

	function preDump($tipo,$bLinkParent = true) {
		if ($bLinkParent) {
			$oL = &$this->getList();
			$oP = &$oL->getParentHook();
			if ($oP) {
				$aKeys = $this->listPrimaryKeys();
				if (is_array($aKeys) AND sizeof($aKeys))
					foreach ($aKeys as $key) {
						$val = $oP->getAttribute($key);
						$actval = $this->getAttribute($key);
						if ( (!empty($actval) or is_numeric($actval)) and $val == $actval) continue;
						if (!empty($val) OR is_numeric($val)) {
							$this->debug("Asignando para la clave $key el valor $val ",'preDump');
							$this->_setAttribute($key,$val);
						}
					}
			}
		}
		$rval = parent::preDump($tipo);
		return $rval;
	}

	/** Metodos de API **/
	function init(&$oList) {
		$this->_oList = &$oList;
		parent::init();
	}

	function cerrar() {
		unset($this->_oList);
		// $this->debug("Llamando a Padre .. ",'cerrar');
		parent::cerrar();
	}

}

class IndexList extends inmersaSerialize {
	var $tabla = NULL;

	var $_AliasEntidad = NULL;
	var $_aDestinosRuta = NULL;
	var $_aCamposEntidades;
	var $aCampos = NULL;

	var $aIndices = NULL;

	var $aoItems = array();				// Vector de elementos.
	var $classname = NULL;

	var $_ItemPointer = 0;				// Indice de detalle actualmente en curso (modificandose).
	var $_oParent = NULL;

	function IndexList ($AppName,$dataconn,$tabla,$aCampos = array(),$aIdx = array(),$classname = 'dbListItem') {

		if (!parent::inmersaSerialize($AppName,$dataconn)) return false;
		$this->aoItems = NULL;

		if (!empty($classname)) {
			$oTmp = @new $classname();
			if (is_a($oTmp,'dbListItem')) $this->classname = $classname;
			else $this->classname = 'dbListItem';
			$oTmp = NULL;
		} else $this->classname = 'dbListItem';

		if (!empty($tabla)) $this->tabla = $tabla;

		$aTmp = dbItemMultiEntity::_getDestinosRuta($tabla,$aCampos);
		$this->_AliasEntidad = $aTmp[0];
		$this->_aDestinosRuta = $aTmp[1];
		$this->_aCamposEntidades = $aTmp[2];
		$this->_aDescEntidades = $aTmp[3];
		//Dejamos que el constructor dbItem de la clase IndexListItem se encarge de _tabla y _aCampos
		// $this->aCampos = $aTmp[2];

		if (is_array($aIdx) AND sizeof($aIdx)) {
			foreach ($aIdx as $campo) {
				if (strstr($campo,'.')) {
					$aTmp = split('\.',$campo);
					$tb = $aTmp[0];
					$fld = $aTmp[1];
				} else {
					$tb = $this->_AliasEntidad;
					$fld = $campo;
				}
				$this->aIndices[$tb][$fld] = array();
			}
		}

		return true;
	}

	function setParentHook(&$oInstance) {
		$rval = false;
		if (is_a($oInstance,'dbItem')) {
			$this->_oParent = &$oInstance;
			$rval = true;
		}
		return $rval;
	}

	function &getParentHook() {
		if (is_a($this->_oParent,'dbItem')) return $this->_oParent;
		return NULL;
	}

	function unsetParentHook() {
		$rval = false;
		if (is_a($this->_oParent,'dbItem')) {
			unset($this->_oParent);
			$rval = true;
		}
		return $rval;
	}

	function insert($aData,$bUpdate = true) {
		$idx = $this->lastItem();
		foreach ($aData as $campo => $valor) {
			if (strchr($campo,'.')) {
				$aTmp = split('\.',$campo);
				if (is_numeric($valor) OR !empty($valor)) $aExtras[$aTmp[0]][$aTmp[1]] = $valor;
			} else {
				if (is_numeric($valor) OR !empty($valor)) $aMain[$campo] = $valor;
			}
		}
		if (!is_array($aMain) OR !sizeof($aMain)) return NULL;
		if (!isset($bUpdate)) $bUpdate = true;

		if ($bUpdate) $oItem = &$this->ListItemFactory();
		else {
			$oItem = &$this->ListItemFactory($aData);
			$oItem->setFlag($oItem->ST_NEW);
		}
		$idx = $oItem->getPositionInList();
		// $this->debug('La nueva posicion en la lista es: '.$idx,'insert');
		if (!is_numeric($idx)) return false;

		$this->aoItems[$idx] = &$oItem;
		if ($bUpdate) $retval = $this->aoItems[$idx]->update($aMain);
		else $retval = true;
		//$this->debug(array("retval del update($idx) es $retval . bUpdate = $bUpdate y Main: "=>$aMain),'insert');
		if (!$retval) {
			$this->aoItems[$idx] = NULL;
			return $retval;
		}
		if ($bUpdate) if (is_array($aExtras) AND sizeof($aExtras)) foreach ($aExtras as $tb => $aTb) $this->aoItems[$idx]->update($aTb,$tb);

		$this->setActiveItem($idx);
		$this->indexItem($idx);
		return $idx;
	}

	function dbFill($aIdx,$order = NULL) {
		if (!is_array($aIdx) OR !sizeof($aIdx)) return false;
		if (!is_array($this->_aCamposEntidades) OR !sizeof($this->_aCamposEntidades)) return false;

		$oDb = $this->getDb();
		$aRet = $oDb->ruta($this->tabla,$this->_aDestinosRuta);

		foreach ($this->_aCamposEntidades as $tabla => $aClaves) {
			foreach ($aClaves as $campo)
				$cons .= ( (!empty($cons)) ? ', ' : '' ).$tabla.'.'.$campo.' as "'.( (!strcmp($this->_AliasEntidad,$tabla)) ? $campo : $tabla.'.'.$campo ).'" ';
		}
		$cons = 'SELECT '.$cons;
		$cons .= ' FROM '.$aRet['left_join_from'];
		$cons .= ' WHERE ';
		foreach ($aIdx as $campo => $valor) {
			if (empty($campo) OR is_numeric($campo)) continue;
			if (!strchr($campo,'\.')) {
				$campo = ((!empty($this->_AliasEntidad)) ? $this->_AliasEntidad : $this->getEntityName()).'.'.$campo;
			}

			if (!is_array($valor)) {
				$str_where .= ( (!empty($str_where)) ? ' AND ' : '').$campo .' = '.( (is_numeric($valor)) ? $valor : '"'.$valor.'"' );
			} else {
				if (sizeof($valor)) {
					$tmp_where = '';
					foreach ($valor as $idval)
						$tmp_where .= ( (!empty($tmp_where)) ? ' OR ' : '').$campo .' = '.( (is_numeric($idval)) ? $idval : '"'.$idval.'"' );

					$str_where .= ( (!empty($str_where)) ? ' AND ( ' : ' ( ').$tmp_where.' ) ';
				}
			}
		}
		$cons .= $str_where.( (!empty($order)) ? ' ORDER BY '.$order : '');

		$retval = false;
		$rs = $oDb->query($cons);
		if (!$oDb->num_rows($rs)) {
			$this->aoItems = NULL;
		} else {
			$retval = true;
			$this->aoItems = array();
			while ($aData = $oDb->fetch_assoc($rs)) {

				$oItem = &$this->ListItemFactory($aData);
				$idx = $oItem->getPositionInList();
				if (!is_numeric($idx)) continue;

				$this->aoItems[$idx] = &$oItem;
				$this->indexItem($idx);
			}

			if (method_exists($this,'postFill')) $retval = $this->postFill($retval);
			if (!isset($retval)) $retval = true;
			if ($retval) $this->unsetFlag($this->ST_NEW);
		}

		return $retval;
	}

	function update($aValores,$entidad = 'main',$idx = NULL,$bForce = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (empty($entidad) OR !strcasecmp($entidad,'main')) {
			$aEnt = $this->aoItems[$idx]->getData();
			if (!$this->aoItems[$idx]->checkFlag($this->aoItems[$idx]->ST_NEW) AND !empty($aEnt) ) 
				$this->unindexItem($idx);
			$this->aoItems[$idx]->update($aValores,$entidad,$bForce);
			if (!empty($aValores)) $this->indexItem($idx);
		} elseif (!isset($this->_aCamposEntidades[$entidad])) {
			return false;
		} else {
			$aEnt = $this->aoItems[$idx]->getData($entidad);
			if (!$this->aoItems[$idx]->checkFlag($this->aoItems[$idx]->ST_NEW) AND !empty($aEnt) ) 
				$this->unindexItem($idx,$entidad);
			$this->aoItems[$idx]->update($aValores,$entidad,$bForce);
			if (!empty($aValores)) $this->indexItem($idx,$entidad);
		}

		return true;
	}

	function delete($idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!is_numeric($idx)) return false;
		$retval = true;
		if ($idx == -1) {
			for ($idx = $this->firstItem(); isset($idx); $idx = $this->nextItem()) {
				$tmpret = $this->aoItems[$idx]->delete();
				if (!$tmpret) $retval = false;
			}
		} else return $this->aoItems[$idx]->delete();
		return $retval;
	}

	function undelete($idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!is_numeric($idx)) return false;

		return $this->aoItems[$idx]->undelete();
	}

	function isDeleted($idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!is_numeric($idx)) return false;

		return $this->aoItems[$idx]->isDeleted();
	}

	function Dump($type = 'db') {
		if (empty($type)) $type = 'db';

		if (method_exists($this,'preDump') AND !$this->preDump()) return false;

		$retval = true;
		for ($idx =$this->firstItem(true,true); isset($idx); $idx = $this->nextItem(true,true)) {
			$tmpret = $this->aoItems[$idx]->Dump($type);
			if ($retval) $retval = $tmpret;
			if ($this->aoItems[$idx]->isDeleted()) {
				$this->unindexItem($idx);
				$this->aoItems[$idx] = NULL;
				unset($this->aoItems[$idx]);
			}
		}

		if (method_exists($this,'postDump')) 
			$retval = $this->postDump($retval,$type);

		return $retval;
	}

	function &getItem($idx = NULL, $what = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		return $this->aoItems[$idx];
	}

	function &ListItemFactory($StartUpData = NULL) {
		if (!is_array($this->aoItems) OR !sizeof($this->aoItems)) $idx = 0;
		else { 
			$aKs = array_keys($this->aoItems);
			sort($aKs);
			$idx = array_pop($aKs); 
			$this->debug(array("aoItems Ultima Clave: ".$idx." ListaClaves: "=>$aKs),'ListItemFactory');
		}
		//TMPnot else $idx = ($this->lastItem(false,true));
		$idx++;
		// $this->debug('New IDX '.$idx,'ListItemFactory');
		return new $this->classname($this,$idx,$StartUpData);
	}

	function getFromIndex($indice,$value) {
		if (!is_array($this->aIndices) OR !sizeof($this->aIndices)) return NULL;
		if (empty($indice) OR (!is_numeric($value) AND empty($value)) ) return NULL;

		if (strstr($indice,'.')) {
			$aTmp = split('\.',$indice);
			$tb = $aTmp[0];
			$fld = $aTmp[1];
		} else {
			$tb = $this->_AliasEntidad;
			$fld = $indice;
		}

		return $this->aIndices[$tb][$fld][$value];
	}

	function getIndexKeys($indice) {
		if (!is_array($this->aIndices) OR !sizeof($this->aIndices)) return NULL;

		if (strstr($indice,'.')) {
			$aTmp = split('\.',$indice);
			$tb = $aTmp[0];
			$fld = $aTmp[1];
		} else {
			$tb = $this->_AliasEntidad;
			$fld = $indice;
		}

		// $this->debug(array("Lista de indices: ",'tb'=>$tb,'fld'=>$fld,array_keys($this->aIndices[$tb][$fld])),'getIndexKeys',array($indice));
		return array_keys($this->aIndices[$tb][$fld]);
	}

	function indexItem($idx = NULL,$indice = NULL,$forcevalor = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!is_numeric($idx)) return false;
		if (!$this->checkItemPosition($idx,false)) return false;
		if (!is_array($this->aIndices) OR !sizeof($this->aIndices)) return true;

		if (!empty($indice)) {
			if (strstr($indice,'.')) {
				$aTmp = split('\.',$indice);
				$forcetb = $aTmp[0];
				$forcefld = $aTmp[1];
			} else {
				if (isset($this->aIndices[$indice])) {
					$forcetb = $indice;
				} else {
					$forcetb = $this->_AliasEntidad;
					$forcefld = $indice;
				}
			}

			if (!isset($this->aIndices[$forcetb])) {
				return true;
			}
			if (!empty($forcefld) AND !isset($this->aIndices[$forcetb][$forcefld])) {
				return true;
			}
		}
		//$this->debug("Indexing $idx .. $indice valforzado: $forcevalor ",'indexItem');
		foreach ($this->aIndices as $tabla => $aCampos) {
			if (!empty($forcetb)) if (strcmp($tabla,$forcetb)) continue;
			if (is_array($aCampos) AND sizeof($aCampos))
				foreach ($aCampos as $campo => $aIdx) {
					if (!empty($forcefld)) if (strcmp($campo,$forcefld)) continue;
					if (isset($forcevalor) AND (is_numeric($forcevalor) OR !empty($forcevalor))) {
						$valor = $forcevalor;
						// debug("dbList::indexItem($idx,$indice,$forcevalor) ==force== $tabla $forcefld = $forcevalor ");
					} else {
						$oItem = $this->getItem($idx);
						$valor = $oItem->getAttribute($campo,$tabla);
						// debug("dbList::indexItem($idx,$indice,$forcevalor) == $tabla $campo = $valor");
					}
					if (is_numeric($valor) OR !empty($valor)) {
						if (!is_array($this->aIndices[$tabla][$campo][$valor])) 
							$this->aIndices[$tabla][$campo][$valor] = array();
						if (!in_array($idx,$this->aIndices[$tabla][$campo][$valor])) 
							array_push($this->aIndices[$tabla][$campo][$valor],$idx);
					}
				}
		}
						
	}

	function unindexItem($idx = NULL,$indice = NULL,$forcevalor = NULL) {
		// $this->debug('desIndexando idx '.$idx,'unindexItem');
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!is_numeric($idx)) return false;
		if (!$this->checkItemPosition($idx,false)) return false;
		if (!is_array($this->aIndices) OR !sizeof($this->aIndices)) return true;
		// $this->debug('pasada la comprobacion del item indice ('.$indice.') ','unindexItem');

		if (!empty($indice)) {
			if (strstr($indice,'.')) {
				$aTmp = split('\.',$indice);
				$forcetb = $aTmp[0];
				$forcefld = $aTmp[1];
			} else {
				if (isset($this->aIndices[$indice])) {
					$forcetb = $indice;
				} else {
					$forcetb = $this->_AliasEntidad;
					$forcefld = $indice;
				}
			}

			// $this->debug("Tabla: $forcetb y campo0 $forcefld ",'unindexItem');
			if (!isset($this->aIndices[$forcetb])) {
				// $this->debug('No encuentro el indice para '.$forcetb,'unindexItem');
				return true;
			}
			if (!empty($forcefld) AND !isset($this->aIndices[$forcetb][$forcefld])) {
				// $this->debug('No encuentro el indice para '.$forcetb." con $forcefld ",'unindexItem');
				return true;
			}
		}

		foreach ($this->aIndices as $tabla => $aCampos) {
			if (!empty($forcetb)) if (strcmp($tabla,$forcetb)) continue;
			// $this->debug("La tabla $tabla nos sirve con : ".sizeof($aCampos),'unindexItem');
			if (is_array($aCampos) AND sizeof($aCampos))
				foreach ($aCampos as $campo => $aIdx) {
					// $this->debug("La tabla $tabla con campo $campo ($forcevalor) srviria con : ".sizeof($aIdx),'unindexItem');
					if (!empty($forcefld)) if (strcmp($campo,$forcefld)) continue;
					if (isset($forcevalor) AND (is_numeric($forcevalor) OR !empty($forcevalor))) {
						$valor = $forcevalor;
					} else {
						if (!strcmp($tabla,$this->_AliasEntidad)) {
							$oItem = $this->getItem($idx);
							$valor = $oItem->getAttribute($campo);
						} else {
							$aItem = $this->getData($tabla,$idx);
							$valor = $aItem[$campo];
						}
					}
					// $this->debug("BIS: La tb $tabla con campo $campo($valor) puede servir con : ".sizeof($aIdx),'unindexItem');
					if (is_numeric($valor) OR !empty($valor)) {
						// $this->debug("idx: $idx tabla: $tabla campo: $campo valor: $valor",'unindexItem');
						if (is_array($this->aIndices[$tabla][$campo][$valor])) {
							// $this->debug("el valor existe .. ",'unindexItem');
							if (in_array($idx,$this->aIndices[$tabla][$campo][$valor])) {
								$this->aIndices[$tabla][$campo][$valor] = array_diff($this->aIndices[$tabla][$campo][$valor],array($idx));
								// $this->debug("array diff contra $idx aplicado ",'unindexItem');
							}
						}
					}
				}
		}
	}

	function getAttribute($campo = NULL,$entidad = NULL, $idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		$oI = &$this->getItem($idx);
		if (!is_a($oI,$this->classname)) {
			$this->debug(get_class($oI)." no pertenece a nuestra clase ".$this->classname,'getAttribute');
			return NULL;
		}
		return $oI->getAttribute($campo,$entidad);
	}

	function setAttribute($campo,$valor,$entidad = NULL, $idx = NULL, $bForce = NULL, $bMarkIfChanged = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		$oI = &$this->getItem($idx);
		if (!is_a($oI,$this->classname)) {
			debug("no pertenece a nuestra clase ");
			return NULL;
		}
		return $oI->setAttribute($campo,$valor,$entidad,$bForce,$bMarkIfChanged);
	}

	function getData($entidad = NULL, $idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		$oI = &$this->getItem($idx);
		if (!is_a($oI,$this->classname)) {
			debug("no pertenece a nuestra clase ");
			return NULL;
		}
		return $oI->getData($entidad);
	}


	/** Metodos ABSTRACTOS **/
	function preDump() {
		return true;
	}

	function postDump() {
		return true;
	}

	function postFill() {
		return true;
	}

	/** Metodos de navegacion **/

	/**
	  * Comprueba si una posicion existe o no
	  **/
	function checkItemPosition($idx,$bCheckDeleted = true) {
		if (!is_numeric($idx)) return false;
		if (isset($this->aoItems[$idx]) AND (!$bCheckDeleted OR !$this->aoItems[$idx]->checkFlag($this->aoItems[$idx]->ST_DEL)) ) return true;
		return false;
	}

	/**
	  * Metodo encargado de establecer el puntero activo a las lineas de detalle.
	  **/
	function setActiveItem($idx_det) {
		if (!$this->checkItemPosition($idx_det)) return false;
		$this->_ItemPointer = $idx_det;
		return true;
	}

	function getActiveItem() {
		return $this->_ItemPointer;
	}

	/**
	  * Este metodo obtiene el actual detalle indicado por el puntero a las lineas de detalle.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function currentItem() {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		// debug("current_detail(".$this->_ItemPointer.")");
		if (!is_array($this->aoItems)) return NULL;
		if (!isset($this->_ItemPointer)) return NULL;
		if (is_object($this->aoItems[$this->_ItemPointer]))
			return $this->_ItemPointer;
		else return NULL;
	}

	function countItems($bIncludeDeleted = false) {
		if (!is_array($this->aoItems) OR !sizeof($this->aoItems)) return 0;
		$num = 0;
		foreach ($this->aoItems as $idx => $aFullItem) if ($this->checkItemPosition($idx,!$bIncludeDeleted)) $num++;
		return $num;
	}

	/**
	  * Metodo encargado de devolver el puntero al primer detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function firstItem($bSetPointer = TRUE, $bIncludeDeleted = false) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		//$this->debug("set = $bSetPointer, withDeleted = $bIncludeDeleted size: ".sizeof($this->aoItems),'firstItem');
		if (is_array($this->aoItems)) {
			reset($this->aoItems);
			list($clave,$valor) = each($this->aoItems);
			reset($this->aoItems);

			if ($bSetPointer AND isset($clave)) {
				$this->_ItemPointer = $clave;
				// Si esta borrado, o no vale, pillamos el siguiente.
				if (!$this->checkItemPosition($clave,!$bIncludeDeleted)) $clave = $this->nextItem($bSetPointer,$bIncludeDeleted);
			} elseif (isset($clave) AND !$this->checkItemPosition($clave,!$bIncludeDeleted)) {
				$oldptr = $this->_ItemPointer;
				$this->_ItemPointer = $clave;
				$clave = $this->nextItem($bSetPointer,!$bIncludeDeleted);
				$this->_ItemPointer = $oldptr;
			}

			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;

		return $clave;
	}

	/**
	  * Este metodo obtiene el siguiente detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function nextItem($bSetPointer = true,$bIncludeDeleted = false) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->aoItems)) return NULL;
		if (!isset($this->_ItemPointer)) return NULL;
		if (!isset($bSetPointer)) $bSetPointer = true;
		$aKeys = array_keys($this->aoItems);
		$continuar = TRUE;
		$retval = NULL;
		foreach ($aKeys as $key) {
			if ( ($key > $this->_ItemPointer) AND $this->checkItemPosition($key,!$bIncludeDeleted) ) {
				if ($bSetPointer) $this->_ItemPointer = $key;
				$retval = $key;
				break;
			} 
		}

		return $retval;
	}

	/**
	  * Metodo encargado de devolver el puntero al ultimo detalle
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function lastItem($bSetPointer = TRUE,$bIncludeDeleted = false) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		if (is_array($this->aoItems)) {
			end($this->aoItems);
			list($clave,$valor) = each($this->aoItems);
			reset($this->aoItems);

			if ($bSetPointer AND isset($clave)) {
				$this->_ItemPointer = $clave;
				// Si esta borrado, o no vale, pillamos el anterior.
				if (!$this->checkItemPosition($clave,!$bIncludeDeleted)) $clave = $this->previousItem($bSetPointer,!$bIncludeDeleted);
			} elseif (isset($clave) AND !$this->checkItemPosition($clave,!$bIncludeDeleted)) {
				$oldptr = $this->_ItemPointer;
				$this->_ItemPointer = $clave;
				$clave = $this->previousItem($bSetPointer,!$bIncludeDeleted);
				$this->_ItemPointer = $oldptr;
			}

			if (!isset($clave)) $clave = NULL;
		} else $clave = NULL;

		return $clave;
	}

	/**
	  * Este metodo obtiene el anterior detalle al actualmente indicado por el puntero a las lineas de detalle.
	  * @param $bSetPointer	-	Booleano indicativo de si se ha de modificar el puntero a los detalles o no.
	  * @return idx or NULL	-	Si la operacion se ha realizado con exito.
	  **/
	function previousItem($bSetPointer = TRUE,$bIncludeDeleted = false) {
		/** ** (permitimos _ver_ detalles aunque este bloqueado **
		if ($this->_aFlags[pedido] & inmPed_LOCKED) {
			$this->error(inmPed_LOCKED,"Pedido bloqueado. Proporcione los datos del Emisor y el Receptor.");
			return NULL;
		}
		/** **/
		if (!is_array($this->aoItems)) return NULL;
		if (!isset($this->_ItemPointer)) return NULL;
		if (!isset($bSetPointer)) $bSetPointer = TRUE;
		$aKeys = array_keys($this->aoItems);
		$continuar = TRUE;
		$retval = NULL;
		while ( ($key=array_pop($aKeys)) ) {
			if ( ($key < $this->_ItemPointer) AND $this->checkItemPosition($key,!$bIncludeDeleted) ) {
				if ($bSetPointer) $this->_ItemPointer = $key;
				$retval = $key;
				break;
			}
		}
		return $retval;
	}

	/** Metodos de estado, permeados de la instancia elemento de lista **/
	function setFlag($flag,$idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!$this->checkItemPosition($idx,false)) return NULL;
		return $this->aoItems[$idx]->setFlag($flag);
	}

	function unsetFlag($flag,$idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!$this->checkItemPosition($idx,false)) return NULL;
		return $this->aoItems[$idx]->unsetFlag($flag);
	}

	function checkFlag($flag,$idx = NULL) {
		if (!is_numeric($idx)) $idx = $this->currentItem();
		if (!$this->checkItemPosition($idx,false)) return NULL;
		return $this->aoItems[$idx]->checkFlag($flag);
	}

	/** Metodos de API **/
	function init($oHook = NULL) {
		if ($oHook) $this->setParentHook(&$oHook);
		for ($idx = $this->firstItem(true,true); isset($idx); $idx = $this->nextItem(true,true)) {
			$oItem = &$this->getItem();
			$oItem->init($this);
		}
		parent::init();
	}

	function cerrar() {
		for ($idx = $this->firstItem(true,true); isset($idx); $idx = $this->nextItem(true,true)) {
			$oItem = &$this->getItem();
			// $this->debug("Llamando a Sig-Hijo .. ",'cerrar');
			$oItem->cerrar();
		}
		// $this->debug("DesEnganchando al Padre .. ",'cerrar');
		$this->unsetParentHook();
		parent::cerrar();
	}


}

class FieldIndexer {
	var $aIndices;
	var $aValores;
	var $campo;
	var $orden;

	function FieldIndexer($key_name,$aCampos,$tipo = 'Asc') {
		$this->aIndices = $aCampos;
		if (!is_array($key_name)) $this->campo = array($key_name);
		else $this->campo = $key_name;
		$this->orden = $tipo;
	}

	function Index($aVal) {
		if (!is_array($this->aIndices)) return false;
		// if (!isset($aVal[$this->campo])) return false;

		$curBranch = &$this->aValores;
		foreach ($this->aIndices as $fld) {
			if (empty($fld) AND !is_numeric($fld)) $fld = '';
			if (!isset($aVal[$fld])) $aVal[$fld] = '';

			if (!is_array($curBranch[$aVal[$fld]])) $curBranch[$aVal[$fld]] = array();
			if (!strcasecmp($this->orden,'Desc')) krsort($curBranch);
			else ksort($curBranch);
			$curBranch = &$curBranch[$aVal[$fld]];
		}
		// Podemos indicar varios campos => valores multiples
		$aTmp = array();
		foreach ($this->campo as $fld) if (isset($aVal[$fld]))  $aTmp[$fld] = $aVal[$fld];
		if (is_array($aTmp) and sizeof($aTmp) and !in_array($aTmp,$curBranch)) array_push($curBranch,$aTmp);
		return true;
	}

	function unIndex($aVal) {
		if (!is_array($this->aIndices)) return false;
		if (!isset($aVal[$this->campo])) return false;

		$curBranch = &$this->aValores;
		foreach ($this->aIndices as $fld) {
			if (empty($fld) AND !is_numeric($fld)) $fld = '';
			if (!isset($aVal[$fld])) $aVal[$fld] = '';

			if (!is_array($curBranch[$aVal[$fld]])) $curBranch[$aVal[$fld]] = array();
			ksort($curBranch);
			$curBranch = &$curBranch[$aVal[$fld]];
		}
		if (in_array($aVal[$this->campo],$curBranch)) {
			debug("Eliminando : ".$aVal[$this->campo]);
			// array_push($curBranch,$aVal[$this->campo]);
		}
		return true;
	}

	function getKeyValues($aVal = NULL) {
		if (!is_array($this->aIndices)) return false;
		// if (!isset($aVal[$this->campo])) return false;

		$curBranch = &$this->aValores;
		foreach ($this->aIndices as $fld) {
			if (empty($fld) AND !is_numeric($fld)) $fld = '';
			if (!isset($aVal[$fld])) {
				$key = $fld;
				break;
			} else $aRef[$fld] = $aVal[$fld];

			if (!is_array($curBranch[$aVal[$fld]])) $curBranch[$aVal[$fld]] = array();
			if (!strcasecmp($this->orden,'Desc')) krsort($curBranch);
			else ksort($curBranch);
			$curBranch = &$curBranch[$aVal[$fld]];
		}
		return array('ref' => $aRef, 'name' => $key, 'values' => array_keys($curBranch)) ;
	}

	/**
	  * Obtiene los valores.
	  * @param	$aCampos		-	Array asociativo de los valores de las claves
	  * @param	$bAgrupado			-	Modo de obtencion (0: Plano -sin agrupar-; 1-Agrupado)
	  **/
	function get($aCampos = NULL,$bAgrupado = true) {
		if (!is_array($this->aValores) OR !sizeof($this->aValores)) return NULL;
		if (!isset($bAgrupado)) {
			debug("Setup as true");
			$bAgrupado = true;
		}
		if (!is_array($aCampos) OR !sizeof($aCampos)) {
			// debug("Devolviendo valores completos... ");
			//return $this->aValores;
		}

		$aRetVal = array();

		$curBranch['content'] = $this->aValores;
		$stIndices = array();
		$num = -1;
		$bCont = true;
		$stPointer = array();
		$stLocation = array();
		$bStack = NULL;
		while ($bCont) {
			// Si ya hemos apilado cosas, es decir, hemos bajado, y ahora estamos arriba, hemos terminado
			if ($num<0 AND isset($bStack)) {
				$bCont = false;
				continue;
			} 
				
			$keyName = $this->aIndices[$num+1];

			if (sizeof($stPointer[$num])) {
				// Si hay elementos en la pila correspondiente a este nivel de profundidad... Extraemos un elemento para procesarlo
				$curBranch = array_pop($stPointer[$num]);
			} elseif (isset($bStack)) {
				// Si no quedan elementos de pila, y no estamos empezando, subimos de nivel, que aqui ya no queda nada.
				$num--;
				array_pop($stLocation);
				continue;
			} 

			if ( $num < (sizeof($this->aIndices)-1) ) {
				// Si no estamos en la maxima profundiad posible ... Bajamos mas ==> Apilar el contenido del indice
				if (!empty($curBranch['branch']) or is_numeric($curBranch['branch'])) {
					array_push($stLocation,$curBranch['branch']);
				}
				$num++;
				$bStack = true;
			} else {
				// Si estamos ya en el maximo nivel de produndidad, comprobamos elemento, y si no quedan mas, subimos.

				$aTmp = $stLocation;
				array_push($aTmp,$curBranch['branch']);

				// Si solo hay una clave, limpiamos el contenido del nombre de campo. Sino, lo dejamos para saber que valor es
				if (sizeof($this->campo)==1) {
					$aCnt = array();
					foreach ($curBranch['content'] as $vl) 
						if (is_array($vl)) {
							$aT = array_values($vl);
							array_push($aCnt,$aT[0]);
						}
				} else $aCnt = $curBranch['content'];

				if ($bAgrupado) {
					array_push($aRetVal,array('index' => $aTmp, 'values' => $aCnt));
				} else {
					foreach ($aCnt as $vl) if (!in_array($vl,$aRetVal)) array_push($aRetVal,$vl);
				}

				if (!sizeof($stPointer[$num])) {
					$num--;
					$tmp = array_pop($stLocation);
					// debug("Subiendo a $num y Sacando $tmp ");
					$bStack = false;
				} else $bStack = false;
			}

			if ($bStack ) {
				// Si estamos en un nivel intermedio, apilamos los elementos que nos valgan 
				foreach ( $curBranch['content'] as $key => $aVal ) {
					// debug("Comprobando Nivel $num: Item $key de ".$keyName);
					if (isset($aCampos[$keyName])) {
						if (strcmp($aCampos[$keyName],$key)) {
							// debug("_no_ coincide ".$key." con ".$aCampos[$keyName]);
							continue;
						}
					}
					// debug("Coincidencia en Nivel $num: apilando Item $key de ".$keyName);

					if (!is_array($stPointer[$num])) $stPointer[$num] = array();
					array_unshift($stPointer[$num],array('branch' => $key, 'content' => &$curBranch['content'][$key]));
				}
			}
		}

		if (!sizeof($aRetVal)) return NULL;
		else return $aRetVal;
	}

	/**  INDICE BINARIO  **/
	function searchBinaryOnVector($aIdx,$search,$bIns = false) {
		$aTmp = array_keys($aIdx);
		foreach ($aTmp as $k) {
			if (!isset($i)) $i = $k;
			else {
				// Las claves tienen que ser numerales en secuencia
				if ($k > ($i+1)) return -1;
				$i = $k;
			}
		}
		$bBreak = false;
		$i = array_shift(array_keys($aIdx))-1;
		$n = array_pop(array_keys($aIdx))+1;
		$j = ceil($i+(($n-$i)/2)); // Empezamos en el medio
		while (!$bBreak) {
			// debug("probando con ini: $i hasta: $n y ahora en $j rs:".strcmp($search,$aIdx[$j]));
			if ($j==$i or $j==$n) {
				// debug("<b>Limites</b> alcanzados. ");
				if ($bIns) return $j;
				else return NULL;
			}
			switch (true) {
				case (!strcmp($search,$aIdx[$j])):
					// Coincide:
					return $j;
					break;

				case (strcmp($search,$aIdx[$j]) < 0):
					// search es menor que idxval actual
					$n = $j;
					$j = round($i+round(($j-$i)/2));
					// debug("Hay que bajar mas .. ahora ini: $i tamosen: $j ");
					break;

				case (strcmp($search,$aIdx[$j]) > 0):
					// search es mayor que idxval actual
					$i = $j;
					$j = round($j+(round($n-$j)/2));
					// debug("Hay que subir mas .. ahora ini: $i tamosen: $j ");
					break;
			}
		}
		return NULL;
	}

	function insertBinaryOnVector($aIdx,$search) {
		$idx = FieldIndexer::searchBinaryOnVector($aIdx,$search,true);
		$bDone = false;
		foreach ($aIdx as $k => $v) {
			if ($idx==$k) {
				$aRetval[$idx] = $search;
				$bDone = true;
			}
			if ($bDone) $aRetval[($k+1)] = $v;
			else $aRetval[$k] = $v;
		}
		return $aRetval;
	}

	function deleteBinaryOnVector($aIdx,$search) {
		$idx = FieldIndexer::searchBinaryOnVector($aIdx,$search);
		if (!is_numeric($idx)) return $aIdx;
		$bDone = false;
		$aRetval = $aIdx;
		$lastk = array_pop(array_keys($aRetval));
		foreach ($aIdx as $k => $v) {
			if ($idx==$k and !$bDone) {
				$aRetval[$k] = NULL;
				$bDone = true;
				continue;
			}
			if ($bDone) {
				$aRetval[($k-1)] = $v;
				if ($k==$lastk) unset($aRetval[$k]);
			} else $aRetval[$k] = $v;
		}
		return $aRetval;
	}

}

function class_dbItemMultiEntity_iface(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
		$docvar = $Sesion->get_var('__dbItemMultiEntity_varname');
		if (empty($docvar)) $docvar = 'oIncidencia_en_curso';
		$obj_var = $docvar;
	}

	if (!$done OR $reset) {
		$done = 1;
		$oME = $Sesion->get_var($obj_var);
		if (!is_object($oME) OR !is_a($oME,'dbItemMultiEntity')) return NULL;
		$aEnts = $oME->listEntities();

		$aRetVal = $oME->getData();
		if (is_array($aEnts) AND sizeof($aEnts)) {
			foreach ($aEnts as $entidad) {
				$aData = $oME->getData($entidad);
				if (is_array($aData) AND sizeof($aData)) 
					foreach ($aData as $campo => $valor) {
						// debug("Entidad $entidad Campo $campo con valor $valor ");
						$aRetVal[$entidad.'.'.$campo] = $valor;
					}
			}
		}
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;

}

function class_dbItemMultiEntity_method_iface(&$Sesion,$block_name) {
	static $obj_var;
	static $obj_method_iface;
	static $aMethodResults;

	if (empty($obj_var)) {
		$docvar = $Sesion->get_var('__dbItemMultiEntity_varname');
		$methodiface = $Sesion->get_var('__dbItemMultiEntity_method_iface');
		if (empty($docvar)) $docvar = 'oIncidencia_en_curso';

		$obj_var = $docvar;
		$obj_method_iface = $methodiface;
	}

	if (!isset($aMethodResults) OR !is_array($aMethodResults)) {
		$aMethodResults = array();

		$oME = $Sesion->get_var($obj_var);
		if (!is_object($oME) OR !is_a($oME,'dbItemMultiEntity')) return NULL;

		if (method_exists($oME,$obj_method_iface)) {
			$aMethodResults = $oME->$obj_method_iface();
		}
	}

	if (is_array($aMethodResults) AND sizeof($aMethodResults)) $aRetVal = array_shift($aMethodResults);
	else $aRetVal = NULL;

	if (!$aRetVal) $aMethodResults = NULL;

	return $aRetVal;
}

function class_IndexList_iface(&$Sesion,$block_name) {
	static $aBlocks;
	static $obj_var;
	static $obj_method;
	static $idx;

	if (empty($block_name)) $block_name = 0;
	if (is_array($aBlocks[$block_name]) AND sizeof($aBlocks[$block_name])) {
		$done = $aBlocks[$block_name]['done'];
		$reset = $aBlocks[$block_name]['reset'];
	}
	if (empty($obj_var)) {
		$docvar = $Sesion->get_var('__IndexList_varname');
		$varmethod = $Sesion->get_var('__IndexList_method');
		if (empty($docvar)) $docvar = 'oIncidencia_en_curso';

		$obj_var = $docvar;
		$obj_method = $varmethod;
	}

	if (!$done OR $reset) {
		if ($reset) $idx = NULL;
		$oRoot = $Sesion->get_var($obj_var);
		if (empty($obj_method)) $oList = $oRoot;
		else {
			if (!method_exists($oRoot,$obj_method)) return NULL;
			$oList = &$oRoot->$obj_method();
		}
		if (!is_object($oList) OR !is_a($oList,'IndexList')) return NULL;

		if (!is_numeric($idx)) {
			$oList->firstItem();
			$idx = $oList->currentItem();
		} else {
			$idx = $oList->nextItem();
		}
		$Sesion->set_var($obj_var,$oRoot);
		if (!is_numeric($idx)) {
			$done = 1;
			return NULL;
		}
		$oItem = &$oList->getItem();

		$aEnts = $oItem->listEntities();
		$aRetVal = $oItem->getData();
		$aRetVal['idx'] = $idx;
		if (is_array($aEnts) AND sizeof($aEnts)) {
			foreach ($aEnts as $entidad) {
				$aData = $oItem->getData($entidad);
				if (is_array($aData) AND sizeof($aData)) 
					foreach ($aData as $campo => $valor) {
						$aRetVal[$entidad.'.'.$campo] = $valor;
					}
			}
		}
	} else {
		$reset = 1;
		$aRetVal = NULL;
	}
	$aBlocks[$block_name]['done'] = $done;
	$aBlocks[$block_name]['reset'] = $reset;
	return $aRetVal;
}

function class_IndexItem_method_iface(&$Sesion,$block_name) {
	static $obj_var;
	static $obj_method;
	static $obj_method_iface;
	static $aMethodResults;

	if (empty($obj_var)) {
		$docvar = $Sesion->get_var('__IndexList_varname');
		$varmethod = $Sesion->get_var('__IndexList_method');
		$methodiface = $Sesion->get_var('__IndexItem_method_iface');
		if (empty($docvar)) $docvar = 'oIncidencia_en_curso';

		$obj_var = $docvar;
		$obj_method = $varmethod;
		$obj_method_iface = $methodiface;
	}

	if (!isset($aMethodResults) OR !is_array($aMethodResults)) {
		$aMethodResults = array();
		$oRoot = $Sesion->get_var($obj_var);
		if (empty($obj_method)) $oList = $oRoot;
		else {
			if (!method_exists($oRoot,$obj_method)) return NULL;
			$oList = &$oRoot->$obj_method();
		}
		if (!is_object($oList) OR !is_a($oList,'IndexList')) return NULL;

		$oItem = &$oList->getItem();

		if (method_exists($oItem,$obj_method_iface)) {
			$aMethodResults = $oItem->$obj_method_iface();
		}
	}

	if (is_array($aMethodResults) AND sizeof($aMethodResults)) $aRetVal = array_shift($aMethodResults);
	else $aRetVal = NULL;

	if (!$aRetVal) $aMethodResults = NULL;

	return $aRetVal;
}

class AppModule extends inmersaSerialize {
	var $_aInfo = array();
	var $_aFields = array();
	var $activo = false;  		// a Extender
	var $own_mask = NULL; 		// a Extender
	var $entActiva = NULL; 		// a Extender

	function AppModule (&$oApp,$modname) {
		if (!parent::inmersaSerialize($oApp,'conf')) {
			debug("Error creando la instancia inmersaSerialize ");
			return false;
		}
		// debug("Poblando el modulo .. ".$modname);
		if (is_array($oApp->_aModulos[$modname]) and sizeof($oApp->_aModulos[$modname])) 
			$this->_aInfo = $oApp->_aModulos[$modname];

		if (!is_numeric($this->_aInfo['id_modulo'])) {
			debug("Error: al obtener info del modulo ");
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

		$this->_setUp();
	}

	function _setUp() {
		if (!parent::_setUp()) return false;
		if (is_array($this->_aInfo) and sizeof($this->_aInfo) and (!is_array($this->_aFields) or !sizeof($this->_aFields))) {
			$oDb = &$this->getDb();
			$cons = 'SELECT '.
						'ME.hide_show, '.
						'E.nombre as "entidad" '.
						'FROM Modulos_entities as ME JOIN Entity_format_style as E ON (ME.id_entity_field=E.id_entity_field) '.
						'WHERE ME.id_modulo = '.$this->_aInfo['id_modulo'];
			$ers = $oDb->query($cons);
			if ($oDb->num_rows($ers)) 
				while ($aEnt = $oDb->fetch_assoc($ers)) {
					$this->_aFields[$aEnt['entidad']] = $aEnt;
				}
		}
		return true;
	}

	/**
	 * Este metodo se llama una vez reconocida la subseccion por la aplicacion.
	 * En este metodo se puede comprobar si la ss esta realizando alguna accion(EDIT,NEW,DEL) sobre una entidad, para saber si se ha de activar el modulo.
	 * El modulo se activa si el valor de retorno es true, a veces tb es interesante tener un atributo 'activo'
	 * En este metodo, se puede acceder a la busqueda activa, antes de ser disparada. pudiendo llamar a su metodo registerModule(instancia,metodo) para que
	 * 	este sea llamado junto con la funcion de parseo de datos, con la SearchAPI como parametro, y altere las busquedas.
	**/
	function SectionStart() {
		return true;
	}

	/**
	 * Este metodo es el equivalente al precode de las plantillas, se llema _ademas_ del precode original.
	 * Se puede obtener la instancia raiz del template, e ir navegando por los distintos bloques, modificando los parametros del tag 'where'
	 * Nota: En este momento no soporta cosas que deberia soportar como son:
	 * 	- Forma de parar la ejecucion del resto de modulos (cierto?)
	 * 	- Forma de cambiar el pii que se va a renderizar, por otro.
	 * 	- Forma de _no_ renderizar este pii en absoluto, ni llamar al precode
	**/
	function triggerPII($pii) {
	}

	/**
	 * Este metodo es llamado justo antes de renderizar el pii, pero despues de conocer su estructura, de tal forma que se puede
	 * 	obtener la instancia raiz del template, e ir navegando por los distintos bloques, modificando los parametros del tag 'where'
	 **/
	function preRenderPII($pii) {
	}

	/**
	 * Esta llamada se produce para todos los campos, cuando el modulo esta activo en este pii. Se comprueba si se quiere visualizar el campo/valor o no, o
	 *  	si se quieren modificar los estilos tanto de la etiqueta de campo, como de su valor.
	**/
	function fldAvailable($fld) {
		if (is_array($this->_aFields[$fld]) and sizeof($this->_aFields[$fld])) {
			return (bool)$this->_aFields[$fld]['hide_show'];
		}
		debug("AppModule::fldAvailable($fld) devuelve true por defecto. ");
		return true;
	}

	function registerCheckRecord($pii) {
	}

	/**
	* Metodo encargado de comprobar si la mascara de modulo de la entidad actual tiene _este_ modulo.
	**/
	function checkRecord(&$oB) {
		// debug("Comprobando registro .... en : ".get_class($this));
		if (!$this->activo) return true;

		$fld = $oB->sesion->_aAcciones[$this->entActiva]['module_field'];
		if (empty($this->entActiva) or empty($fld)) {
			$this->__deactivate();
			return true;
		}
		if (!strchr($fld,'.')) $fld = $this->entActiva.'.'.$fld;
		$val = $oB->get_data($fld);
		if (empty($val)) {
			$this->__deactivate();
			return true;
		}
		if ( !($val & $this->own_mask) ) {
			$this->__deactivate();
			return true;
		}
		// debug("prueba superada!: ".$this->entActiva" campo: ".$fld." val: $val ");
		// print_r($aData);
		return true;
	}

	function __deactivate() {
		$this->activo = false;
		$oS = &$this->getApp();
		if (!is_a($oS,'wolSesion')) {
			debug("Que mal rollo... no tenemos aplicacion. ");
			return false;
		}
		return true;
	}
}

}

?>
