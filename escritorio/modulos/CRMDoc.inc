<?php

class CRMDoc {
	var $ST_CORRUPT	=	1;
	var $ST_MODIFIED	=	2;
	var $ST_DELETED	=	4;

	var $status = 0;

	var $_aNames = array (
			'sesion' => NULL,		//Nombre de variable de sesion o aplicacion
			'data'	=>	NULL,		// Nombre (dentro de la sesion) del conector de datos
			'conf'	=>	NULL		// Nombre (dentro de la sesion) del conector de configuracion
			);
	var $sesion = NULL;			// wolSesion 
	var $db 		= NULL;			// Instancia db para datos
	var $db_cfg = NULL;			// Instancia db para la configuraicon

	var $_aCfg = array(								// Configuracion de documentos.
			'document_root' => NULL,				// Directorio _raiz_ de la aplicaicon donde residen los documentos
			'document_path' => 'documentos/',	// Directorio _relativo_ donde residen los documentos
			'id_tipodoc_defecto' => NULL			// Tipo de documento por defecto, cuano no existe otro.
			);

	var $aDoc = array(			// Atributos de un documento.
			'id_documento'	=> 0	// Clave primaria del documento
			);			

	function CRMDoc ($AppName,$dataconn,$cfgconn,$oUsr = NULL) {
		$Ses = &$GLOBALS[$AppName];
		if (is_object($Ses)) {
			$this->sesion = $Ses;
			$this->_aNames['sesion'] = $AppName;

			$this->db = &$Ses->get_db($dataconn);
			if (is_object($this->db)) $this->_aNames['data'] = $dataconn;
			else {
				$this->setStatus($this->ST_CORRUPT);
				return false;
			}
			$this->db_cfg = &$Ses->get_db($cfgconn);
			if (is_object($this->db_cfg)) $this->_aNames['conf'] = $cfgconn;
			else {
				$this->setStatus($this->ST_CORRUPT);
				return false;
			}
			$this->clear();
			$this->Setup();
		}
		$this->setUser($oUsr);
	}

	function setUser($oUsr = NULL) {
		if (!is_object($oUsr)) return false;

		$aDesk = $oUsr->get_desktop();
		if (!strcasecmp($aDesk['nombre'],'Gerente') OR !strcasecmp($aDesk['nombre'],'Coordinador') OR !strcasecmp($aDesk['nombre'],'Empleado')) {
			$this->aDoc['id_empleado'] = $aDesk['value'];
		} else {
			$this->aDoc['id_usuario'] = $aDesk['value'];
		}
		return true;
	}

	function Setup() {
		if (is_array($this->_aCfg) AND sizeof($this->_aCfg)) {
			$this->_aCfg['document_root'] = $this->db_cfg->read_main_value('krncfg_doc_root');
			if (empty($this->_aCfg['document_root'])) {
				// $this->sesion->lcMessage('NO_DOCROOT',array(),IM_WARNING);
				$this->sesion->lcMessage('DOC_NO_DOCROOT');
				return false;
			}
			if ( $this->_aCfg['document_root'][strlen($this->_aCfg['document_root'])-1]!='/') $this->_aCfg['document_root'] .= '/';
			$this->_aCfg['document_path'] = 'documentos/';

			if (is_array($this->_aCfg) AND sizeof($this->_aCfg)) {
				foreach ($this->_aCfg as $var => $val) {
					if (strcasecmp('document_',substr($var,0,9))){ 
						$tmpcons .= ((!empty($tmpcons)) ? ' OR ' : ' ').'nombre = "appcfg_'.$var.'"';
					}
				}
				if (!empty($tmpcons)) {
					$tmpcons = 'SELECT nombre,valor FROM _main WHERE '.$tmpcons;
					$tmprs = $this->db_cfg->query($tmpcons);
					if ($this->db_cfg->num_rows($tmprs)) 
						while ($aTmp = $this->db_cfg->fetch_assoc($tmprs)) 
							$this->_aCfg[substr($aTmp['nombre'],7)] = $aTmp['valor'];
				}
			}

			$cons = 'SELECT * FROM Tipos_documento ';
			$rs = $this->db->query($cons);
			if (!$this->db->num_rows($rs)) {
				$this->_aTipos=NULL;
			} else {
				while ($aTmp = $this->db->fetch_assoc($rs)) {
					if (!empty($aTmp['path']) AND $aTmp['path'][strlen($aTmp['path'])-1]!='/')
						$aTmp['path'] .= '/';
					$this->_aTipos[$aTmp['id_tipo_documento']] = $aTmp;
				}
			}
		}
		return true;
	}

	function clear() {
		$id_emp = $this->_aDoc['id_empleado'];
		$id_usr = $this->_aDoc['id_usuario'];
		$this->aDoc = array(
			'id_documento' => NULL,
			'id_agrupacion_documentos' => NULL,
			'id_tipo_documento' => NULL,
			'id_usuario' => $id_usr,
			'id_empleado' => $id_emp,
			'nombre' => NULL,
			'referencia' => NULL,
			'ultima_modificacion' => 'null',
			'antetitulo' => NULL,
			'sinopsis' => NULL,
			'titulo' => NULL,
			'autor' => NULL,
			'fecha' => NULL,
			'file_name' => NULL,
			'file_size' => 0,
			'publicado' => 0
				);
	}

	function getId() {
		return $this->aDoc['id_documento'];
	}

	function dbFill($id) {
		if (!is_numeric($id)) return false;
		$cons = 'SELECT D.id_documento, '.
					'D.id_agrupacion_documentos , '.
					'D.id_tipo_documento , '.
					'D.id_usuario , '.
					'D.id_empleado , '.
					'D.nombre , '.
					'D.referencia , '.
					'D.antetitulo , '.
					'D.sinopsis , '.
					'D.titulo , '.
					'D.autor , '.
					'D.fecha , '.
					'D.ultima_modificacion as "timestamp" , '.
					'D.file_name, '.
					'D.file_size, '.
					'D.publicado, '.
					'CONCAT("'.$this->_aCfg['document_root'].$this->_aCfg['document_path'].'",T.path) as "path" '.
					'FROM Documentos D LEFT JOIN Tipos_documento T ON (D.id_tipo_documento = T.id_tipo_documento) '.
					'LEFT JOIN Agrupaciones_documentos A ON (D.id_agrupacion_documentos=A.id_agrupacion_documentos) '.
					'WHERE D.id_documento = '.$id;
		$rs = $this->db->query($cons);
		if (!$this->db->num_rows($rs)) return false;
		$this->aDoc = $this->db->fetch_assoc($rs);
		return true;
	}

	function edit($aDoc) {
		if (is_array($this->aDoc) AND sizeof($this->aDoc)) {
			// Caso de estar editando uno existente..
			foreach ($this->aDoc as $clave => $valor) {
				if (!isset($aDoc[$clave]) OR $this->aDoc[$clave]==$aDoc[$clave]) continue;

				switch ($clave) {
					// No se puede editar la clave primaria
					case 'id_documento' :
						continue;
						break;

					case 'id_usuario' :
						if (is_numeric($this->aDoc['id_usuario']) OR is_numeric($this->aDoc['id_empleado']) ) continue;
						$this->aDoc[$clave] = $aDoc[$clave];
						$this->setStatus($this->ST_MODIFIED);
						break;

					case 'id_empleado' :
						if (is_numeric($this->aDoc['id_usuario']) OR is_numeric($this->aDoc['id_empleado']) ) continue;
						$this->aDoc[$clave] = $aDoc[$clave];
						$this->setStatus($this->ST_MODIFIED);
						break;

					case 'ultima_modificacion' :
						continue;
						break;

					// Si el tipo de documento que recibidmos es distinto del que hay, llamamos a un metodo especifico
					case 'id_tipo_documento':
						if ( is_numeric($aDoc['id_tipo_documento']) AND $aDoc['id_tipo_documento']!=$this->aDoc['id_tipo_documento']) {
							if ($this->changeDocumentType($aDoc['id_tipo_documento'])) $this->setStatus($this->ST_MODIFIED);
						}
						break;

					case 'fecha':
						if (!empty($aDoc['fecha'])) {
							if (empty($this->aDoc['fecha']) 
									OR strcasecmp(wol_db::formatear_fecha($aDoc['fecha']),wol_db::formatear_fecha($this->aDoc['fecha'])) ) {
								// debug("Cambiando la fecha ".wol_db::formatear_fecha($this->aDoc['fecha']).' con '.wol_db::formatear_fecha($aDoc['fecha']));
								$this->aDoc['fecha'] = $aDoc['fecha'];
								$this->setStatus($this->ST_MODIFIED);
							}
						} else {
							if (!empty($this->aDoc['fecha'])) {
								$this->aDoc['fecha'] = 'null';
								$this->setStatus($this->ST_MODIFIED);
							}
						}
						break;

					case 'file_name':
						if (is_numeric($this->aDoc['id_documento'])) {
							$renamed = $this->renameFile($aDoc[$clave]);
							if (!empty($renamed)) {
								$this->aDoc['file_name'] = $renamed;
								$this->setStatus($this->ST_MODIFIED);
							}
						} elseif (!is_numeric($this->aDoc['id_documento'])) {
							$this->aDoc[$clave] = $aDoc[$clave];
							$this->setStatus($this->ST_MODIFIED);
						}
						break;

					default:
						$this->aDoc[$clave] = $aDoc[$clave];
						$this->setStatus($this->ST_MODIFIED);
						break;
				}
			}
		}
	}

	function delete() {
		$this->setStatus($this->ST_DELETED);
	}

	function renameFile($dest) {
		if (empty($dest)) return false;
		if (empty($this->aDoc['file_name'])) return NULL;

		$path_old = $this->_aCfg['document_root'].$this->_aCfg['document_path'].$this->_aTipos[$this->aDoc['id_tipo_documento']]['path'];
		if (!is_dir($path_old)) {
			$this->sesion->lcMessage('DOC_PATH_NOTFOUND',array('path' => $path_old));
			return NULL;
		}

		$orig = $path_old.$this->aDoc['file_name'];
		if (!is_file($orig)) {
			$this->sesion->lcMessage('DOC_FILE_NOTFOUND',array('file' => $orig));
			return NULL;
		}

		if ($dest[0]!='/') {
			$dest_path = $this->_aCfg['document_root'].$this->_aCfg['document_path'].$this->_aTipos[$this->aDoc['id_tipo_documento']]['path'];
		}
		if (is_file($dest_path.$dest)) {
			for ($i=0;$i<10;$i++) {
				$tmpfile = rand(0,9999).$dest;
				if (!is_file($dest_path.$tmpfile)) {
					$renamed = $dest;
					$dest = $tmpfile;
					break;
				}
			}
			if ($i==10) {
				$this->sesion->lcMessage('DOC_FILE_NOTRENAMED',array('origen'=>$dest));
				return NULL;
			} else 
				$this->sesion->lcMessage('DOC_FILE_RENAMED',array('origen'=>$renamed,'destino' => $dest));
		} 
		if (!@rename($orig,$dest_path.$dest)) {
			$this->sesion->lcMessage('DOC_RENAME_FAILED',array('origen' =>$orig,'destino'=>$dest_path.$dest));
			return NULL;
		}
		$this->aDoc['path'] = $dest_path;
		return $dest;
	}

	function findMime($mimetype) {
		if (empty($mimetype)) return NULL;
		if (is_numeric($mimetype)) return NULL;
		if (!is_array($this->_aTipos) OR !sizeof($this->_aTipos)) return NULL;

		foreach ($this->_aTipos as $id => $aTipo) if (!strcasecmp($mimetype,$aTipo['mime_type'])) return $id;
		$this->sesion->lcMessage('DOC_MIME_NOTFOUND',array('mime' =>$mimetype));
		return NULL;
	}

	function changeDocumentType($id) {
		if (!is_array($this->_aTipos) OR !sizeof($this->_aTipos)) return false;
		if (!is_numeric($id) OR !is_array($this->_aTipos[$id])) return false;

		if ($id == $this->aDoc['id_tipo_documento']) return true;

		if (is_array($this->_aTipos[$this->aDoc['id_tipo_documento']]) AND !empty($this->aDoc['file_name'])) {
			$path = $this->_aCfg['document_root'].$this->_aCfg['document_path'].$this->_aTipos[$id]['path'];
			if (!is_dir($path)) {
				$this->sesion->lcMessage('DOC_PATH_NOTFOUND',array('path' =>$path));
				return false;
			}
			$file = $path.$this->aDoc['file_name'];
			if ($this->renameFile($file)) {
				$this->aDoc['id_tipo_documento'] = $id;
				$this->aDoc['path'] = $path;
			} else return false;
		} else {
			$this->aDoc['id_tipo_documento'] = $id;
		}
		return true;
	}

	function getData($grupo = 'main') {
		if (!strcasecmp($grupo,'main') OR empty($grupo)) $grupo = 'main';
		switch ($grupo) {
			case 'main':
				$retval = $this->aDoc;
				break;

			case 'tipo':
				$retval = $this->_aTipos[$this->aDoc['id_tipo_documento']];
				break;
		}
		return $retval;
	}


	function uploadFile($aFile) {
		if (!is_array($aFile) OR !sizeof($aFile)) return false;

		if (is_numeric($aDoc['id_tipo_documento'])) $old_id_tipo = $this->aDoc['id_tipo_documento'];
		if (!empty($aFile['type'])) {
			$id_tipo = $this->findMime($aFile['type']);
		} elseif (is_numeric($this->aDoc['id_tipo_documento'])) {
			$id_tipo = $this->aDoc['id_tipo_documento'];
		} 

		if (empty($id_tipo) OR !is_numeric($id_tipo)) {
			$id_tipo = $this->_aCfg['id_tipodoc_defecto'];
			if (!is_numeric($id_tipo)) {
				$this->sesion->lcMessage('DOC_NO_DEFAULTDOCTYPE');
				return false;
			}
		}

		if (is_numeric($this->_aTipos[$id_tipo]['max_size']) AND !empty($this->_aTipos[$id_tipo]['max_size']) 
				AND $aFile['size']>$this->_aTipos[$id_tipo]['max_size']) {
			if (is_numeric($this->_aTipos[$id_tipo]['max_size']) AND !empty($this->_aTipos[$id_tipo]['max_size'])) {
				$size = $this->_aTipos[$id_tipo]['max_size'];
				$size = $size / 1024;
			} else $size = 0;
			$this->sesion->lcMessage('DOC_MAXSIZE_EXCEEDED',array('size'=>$size));
			return false;
		}
		if (is_numeric($id_tipo) AND !$this->changeDocumentType($id_tipo)) {
			$this->sesion->lcMessage('DOC_DOCTYPE_UNCHANGEd',array('id'=>$id_tipo));
			return false;
		}

		if (!empty($this->aDoc['file_name'])) $file_name = $this->aDoc['file_name'];
		else $file_name = $aFile['name'];

		$path = $this->_aCfg['document_root'].$this->_aCfg['document_path'].$this->_aTipos[$this->aDoc['id_tipo_documento']]['path'];
		if (!is_dir($path)) {
			$this->sesion->lcMessage('DOC_PATH_NOTFOUND',array('path' =>$path));
			return false;
		}
			
		/** **
		if (is_file($path.$file_name)) {
			debug("Error: El destino ya existe (ya sabes, a renombrar)");
			return false;
		}
		/** **/

		if (is_uploaded_file($aFile['tmp_name'])) {
			$oldumask = umask();
			umask(0111);
			if (!@move_uploaded_file($aFile['tmp_name'],$path.$file_name)) {
				$this->sesion->lcMessage('DOC_UPLOAD_FAILED',array('file' =>$path.$file_name));
				umask($oldumask);
				if (is_numeric($old_id_tipo)) $this->changeDocumentType($old_id_tipo);
				return false;
			}
			umask($oldumask);
		}
		if (strcmp($file_name,$this->aDoc['file_name'])) {
			$this->aDoc['file_name'] = $file_name;
			$this->aDoc['file_size'] = $aFile['size'];
			$this->aDoc['path'] = $path;
			$this->setStatus($this->ST_MODIFIED);
		}

		return true;
	}

	function dbDump() {
		if ($this->checkStatus($this->ST_DELETED)) {
			$bUpdate = true;
			if (is_numeric($this->aDoc['id_documento'])) {
				$bDel = true;
				if (!empty($this->aDoc['file_name'])) {
					$path = $this->_aCfg['document_root'].$this->_aCfg['document_path'].$this->_aTipos[$this->aDoc['id_tipo_documento']]['path'];
					$file = $path.$this->aDoc['file_name'];
					if (is_file($file) AND !@unlink($file)) {
						$this->sesion->lcMessage('DOC_FILE_NOTDELETED',array('file' =>$file));
						$bDel = false;
					}
				}
				if ($bDel AND !$this->db->tb_delete('Documentos',array('id_documento' => $this->aDoc['id_documento']))) {
					$bUpdate = false;
					$this->sesion->lcMessage('IKRN_DB_DELETEFAILED',array('entity' =>'Documentos','id'=>$this->aDoc['id_documento']));
				}
			}
			if ($bUpdate) $this->status &= ~$this->ST_DELETED;
		} elseif ($this->checkStatus($this->ST_MODIFIED)) {
			$bUpdate = true;
			if (!is_numeric($this->aDoc['id_tipo_documento']) OR empty($this->aDoc['id_tipo_documento'])) {
				if (!is_numeric($this->_aCfg['id_tipodoc_defecto'])) {
					$this->sesion->lcMessage('DOC_NO_DEFAULTDOCTYPE');
					return false;
				} 
				$this->changeDocumentType($this->_aCfg['id_tipodoc_defecto']);
			}
			if (is_numeric($this->aDoc['id_documento'])) $this->db->tb_update('Documentos',$this->aDoc);
			else {
				if ($this->db->tb_insert('Documentos',$this->aDoc))
					$this->aDoc['id_documento'] = $this->db->last_insert_id();
				else {
					$this->sesion->lcMessage('IKRN_DB_INSERTFAILED',array('entity'=>'Documentos'));
				}
			}
			if ($bUpdate) $this->status &= ~$this->ST_MODIFIED;
		} 
		return true;
	}


	function init() {
		if (!is_object($this->sesion)) {
			if (empty($this->_aNames['sesion'])) return false;
			$this->sesion = &$GLOBALS[$AppName];
			if (!is_object($this->sesion)) return false;
		}
		if (!is_object($this->db)) {
			if (empty($this->_aNames['data'])) return false;
			$this->db = &$this->sesion->get_db($this->_aNames['data']);
			if (!is_object($this->db)) return false;
		}
		if (!is_object($this->db_cfg)) {
			if (empty($this->_aNames['conf'])) return false;
			$this->db_cfg = &$this->sesion->get_db($this->_aNames['conf']);
			if (!is_object($this->db_cfg)) return false;
		}
		$this->clear();
		$this->Setup();
		return true;
	}

	function cerrar() {
		unset($this->sesion);
		unset($this->db);
		unset($this->db_cfg);
	}

	function setStatus($flag) {
		if (is_numeric($flag)) $this->status |= $flag;
	}

	function checkStatus($flag) {
		return ($this->status & $flag);
	}
}

?>
