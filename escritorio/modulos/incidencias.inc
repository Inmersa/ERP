<?php

class CRMComment extends dbListItem {
	var $aDocumentos;
	var $aDeletedDocs;

	var $cfgConnName;

	function CRMComment (&$oComentarios,$idx = NULL,$aData = NULL) {

		if (!is_object($oComentarios) OR !is_a($oComentarios,'CRMEventComments')) return false;

		$aAcciones[$oComentarios->clave_evento] = array('exclude' => array('new' => false, 'edit' => false) );
		//This was to test: $aAcciones['id_documento'] = array('method' => 'updateDocument', 'exclude' => array('new'=>false));
		$aAcciones['id_usuario'] = array('method' => 'updateUser');
		$aAcciones['id_empleado'] = array('method' => 'updateUser');
		return parent::dbListItem($oComentarios,$idx,$aData,$aAcciones);
	}

	function setCfgConnectionName($name) {
		$retval = false;
		$oApp = &$this->getApp();
		if (!$oApp) return false;
		$oTmpDb = &$oApp->get_db($name);
		if (is_object($oTmpDb) AND is_a($oTmpDb,'wol_db')) {
			$this->cfgConnName = $name;
			$retval = true;
		}
		return $retval;
	}

	function findUser($que,$id = NULL,$oDb = NULL) {
		if (!is_object($oDb) OR !is_a($oDb,'wol_db')) {
			if (method_exists($this,'getDb')) $oDb = @$this->getDb();
			else return NULL;
			if (!is_object($oDb) OR !is_a($oDb,'wol_db')) return NULL;
		}
		if (is_object($que)) {
			if (is_a($que,'wolUsr')) $oUsr = $que;
			else return NULL;
			$aTmp = $oUsr->get_desktop();
			if (!strcasecmp($aTmp['field'],'id_usuario')) {
				$tabla = 'Usuarios';
				$campo = 'id_usuario';
				$id = $aTmp['value'];
				$usuario_empleado = 0;
			} elseif ($strcasecmp($aTmp['field'],'id_empleado')) {
				$tabla = 'Empleados';
				$campo = 'id_empleado';
				$id = $aTmp['value'];
				$usuario_empleado = 1;
			} else $id = NULL;
		} elseif (!strcasecmp($que,'Usuarios') OR !strcasecmp($que,'id_usuario')) {
			$tabla = 'Usuarios';
			$campo = 'id_usuario';
			$usuario_empleado = 0;
		} elseif (!strcasecmp($que,'Empleados') OR !strcasecmp($que,'id_empleado')) {
			$tabla = 'Empleados';
			$campo = 'id_empleado';
			$usuario_empleado = 1;
		}
		if (!is_numeric($id) OR empty($id)) return NULL;

		$cons = 'SELECT '.
					'Ape.nombre as "nombre", '.
					'Ape.apellidos as "apellidos", '.
					( ($usuario_empleado) 
					  ?	'Ape.cargo as "cargo", '.
							'Ape.id_empleado as "id", '.
							'Ape.id_empleado as "id_empleado", '.
							'Ape.comentarios_publicos as "comentarios_publicos", '.
							'1 as "comentarios_privados" , '.
							'Ape.incidencias_departamentales as "incidencias_departamentales", '
					  :	'Ape.id_usuario as "id", '.
							'Ape.id_usuario as "id_usuario", '.
							'1 as "comentarios_publicos", '.
							'0 as "comentarios_privados", '
					).
					'Ape.email as "email" '.
					( ($usuario_empleado)
					  ?  'FROM Empleados Ape WHERE Ape.id_empleado = '.$id
					  :  'FROM Usuarios Ape WHERE Ape.id_usuario = '.$id
					  );
		$imprs = $oDb->query($cons);
		if (!$oDb->num_rows($imprs)) {
			$oApp = $this->getApp();
			$oApp->lcMessage('INC_USER_NOTFOUND',array('entity' => $tabla, 'id' => $id));
			return NULL;
		}
		$aTmp = $oDb->fetch_assoc($imprs);
		return $aTmp;
	}

	function updateUser($id,$campo) {
		if (!is_numeric($id)) {
			return false;
		}
		$retval = false;
		switch ($campo) {
			case 'id_usuario':
				$aUsuario = $this->findUser('Usuarios',$id);
				if (is_array($aUsuario) AND sizeof($aUsuario)) {
					$retval = true;
					$this->_setAttribute('id_usuario',$aUsuario['id']);
					$oComms = &$this->getList();
					if ($oComms->update($aUsuario,'Usuarios',$this->getPositionInList()) AND !$this->checkFlag($this->ST_NEW)) {
						$oComms->update(NULL,'Empleados',$this->getPositionInList());
						$this->_setAttribute('id_empleado',NULL);
					}
				}
				break;
			case 'id_empleado':
				$aEmpleado = $this->findUser('Empleados',$id);
				if (is_array($aEmpleado) AND sizeof($aEmpleado)) {
					$retval = true;
					$this->_setAttribute('id_empleado',$aEmpleado['id']);
					$oComms = &$this->getList();
					if ($oComms->update($aEmpleado,'Empleados',$this->getPositionInList()) AND !$this->checkFlag($this->ST_NEW)) {
						$oComms->update(NULL,'Usuarios',$this->getPositionInList());
						$this->_setAttribute('id_usuario',NULL);
					}
				}
				break;

			default:
				debug($campo." Desconocido ");
				break;
		}
		return $retval;
	}


	function addDocument($id) {
		$oList = &$this->getList();
		if (is_numeric($id)) {
			$aOther = $oList->getFromIndex('id_documento',$id);

			// Si no podemos crear una instancia por no tener conector de cfg, confiamos que el id este bien.
			if ( (is_array($aOther) AND sizeof($aOther)) OR empty($this->cfgConnName) ) $iddoc = $id;
			else {
				$tmpDoc = new CRMDoc($this->getAppName(),$this->getDbName(),$this->cfgConnName);
				if ($tmpDoc->dbFill($id)) $iddoc = $id;
				else {
					return false;
				}
			}

		} elseif(is_object($id) AND is_a($id,'CRMDoc')) {
			$iddoc = $id->getId();
			if (empty($iddoc)) {
				return false;
			}
		} else return false;
		if (!is_array($this->aDocumentos)) $this->aDocumentos = array();

		if (!isset($this->aDocumentos[$iddoc])) {
			$this->aDocumentos[$iddoc] = false;
			$oList->indexItem($this->getPositionInList(),'id_documento',$iddoc);
		}
		return true;
	}

	function getDocuments() {
		if (!is_array($this->aDocumentos)) return NULL;
		return array_keys($this->aDocumentos);
	}

	function getRelatedDocuments($bInst = false) {
		$id = $this->getAttribute('id_comentario');
		$pub = (int)$this->getAttribute('documento_publico');
		$aDocs = $this->getDocuments();
		$aRetVal = NULL;
		if (is_array($aDocs) AND sizeof($aDocs))
			foreach ($aDocs as $iddoc) {
				$aRetVal[$iddoc]['id_comentario'] = $id;
				$aRetVal[$iddoc]['documento_publico'] = $pub;
				$aRetVal[$iddoc]['id_documento'] = $iddoc;
				if ($bInst) {
					$aRetVal[$iddoc]['object'] = new CRMDoc($this->getAppName(),$this->getDbName(),$this->cfgConnName);
					if (!$aRetVal[$iddoc]['object']->dbFill($iddoc)) $aRetVal[$iddoc]['object'] = NULL;
				}
			}
		return $aRetVal;
	}

	function delete() {
		$retval = parent::delete();
		if ($retval) {
			$aDocs = $this->getRelatedDocuments();
			if (is_array($aDocs) AND sizeof($aDocs)) foreach ($aDocs as $iddoc => $aDoc) $this->delDocument($iddoc);
		}
		return $retval;
	}

	function delDocument($id) {
		$oList = &$this->getList();
		if (is_numeric($id)) $iddoc = $id;
		elseif(is_object($id) AND is_a($id,'CRMDoc')) $iddoc = $id->getId();
		else return false;
		if (!is_array($this->aDeletedDocs)) $this->aDeletedDocs = array();

		if (isset($this->aDocumentos[$iddoc])) {
			// Si el valor del indice por id, es true, esta ya en la bbdd y lo listamos para borrar
			if ($this->aDocumentos[$iddoc]) array_push($this->aDeletedDocs,$iddoc);

			$this->aDocumentos[$iddoc] = NULL;
			unset($this->aDocumentos[$iddoc]);

			$oList->unindexItem($this->getPositionInList(),'id_documento',$iddoc);
		}
		return true;
	}

	function postDump() {
		$id = $this->getAttribute('id_comentario');
		if ( (is_array($this->aDocumentos) OR is_array($this->aDeletedDocs)) AND 
				( sizeof($this->aDocumentos) OR sizeof($this->aDeletedDocs) ) AND !empty($id)) {
			$oDb = &$this->getDb();
			if (is_array($this->aDocumentos) AND sizeof($this->aDocumentos)) 
				foreach ($this->aDocumentos as $iddoc => $bInDb)
					if (!$bInDb) {
						$oDb->tb_replace('Comentarios_documentos',array('id_comentario' => $id, 'id_documento' => $iddoc));
					}

			if (is_array($this->aDeletedDocs) AND sizeof($this->aDeletedDocs)) 
				foreach ($this->aDeletedDocs as $iddoc) 
					$oDb->tb_delete('Comentarios_documentos',array('id_comentario' => $id, 'id_documento' => $iddoc));
		}
	}

}

class CRMEventComments extends IndexList {
	var $id_evento;
	var $clave_evento;
	var $cfgConnName;

	function CRMEventComments($oInc) {
		if (!is_object($oInc)) return false;

		$aCampos['Comentarios']=array('id_comentario','id_incidencia','id_rfq','id_rma','id_usuario','id_empleado','texto_publico','texto_privado','fecha','documento_publico');
		$aCampos['Usuarios'] = array('id_usuario','nombre','apellidos','email');
		$aCampos['Empleados'] = array('id_empleado','nombre','apellidos','cargo','email','comentarios_publicos','incidencias_departamentales');

		$aIndices = array('id_comentario','id_documento','Usuarios.id_usuario','Empleados.id_empleado');
		$itemclass = 'CRMComment';

		$this->cfgConnName = $oInc->getCfgDbName();
		$this->id_evento = $oInc->getId();
		$this->clave_evento = $oInc->getKeyField();

		return parent::IndexList($oInc,NULL,'Comentarios',$aCampos,$aIndices,$itemclass);
	}

	function dbFill() {
		// return parent::dbFill(array($this->tabla.'.'.$this->clave_evento => $this->id_evento));
		return parent::dbFill(array($this->clave_evento => $this->id_evento));
	}

	function postFill() {
		$cons = 'SELECT '.
					'Comentarios_documentos.id_comentario as "id_comentario", '.
					'Comentarios_documentos.id_documento as "id_documento" '.
					'FROM Comentarios, Comentarios_documentos '.
					'WHERE Comentarios.id_comentario = Comentarios_documentos.id_comentario '.
					'AND Comentarios.'.$this->clave_evento.' = '.$this->id_evento;

		$oDb = &$this->getDb();
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs)) {
			while ($aDoc = $oDb->fetch_assoc($rs)) {
				if (!is_numeric($aDoc['id_comentario']) OR !is_numeric($aDoc['id_documento'])) continue;

				$aPos = $this->getFromIndex('id_comentario',$aDoc['id_comentario']);
				if (sizeof($aPos) == 1) {
					$idx = array_shift($aPos);
					$oItem = &$this->getItem($idx);
					$oItem->aDocumentos[$aDoc['id_documento']] = true;
					$this->indexItem($idx,'id_documento',$aDoc['id_documento']);
				}
			}
		}
		return true;
	}

	function insert($oUser,$aData) {
		if ( (!is_object($oUser) OR !is_a($oUser,'wolUsr')) AND !is_numeric($aData['id_usuario']) AND !is_numeric($aData['id_empleado']) ) {
			return false;
		}
		if (!is_numeric($this->id_evento)) {
			return false;
		}
		if ( (is_object($oUser) AND is_a($oUser,'wolUsr')) ) {
			$aUsr = $oUser->get_desktop();
			$aData[$aUsr['field']] = $aUsr['value'];
		}
		$aData[$this->clave_evento] = $this->id_evento;
		return parent::insert($aData);
	}

	function &ListItemFactory($StartUpData = NULL) {
		$oItem = &parent::ListItemFactory($StartUpData);
		$oItem->setCfgConnectionName($this->cfgConnName);
		return $oItem;
	}

}

class CRMEvent extends dbItemMultiEntity {
	var $ST_ACCESSDENIED	=	32;

	var $EV_PENDING	=	1;
	var $EV_STARTED	=	2;
	var $EV_CLOSED	=	4;
	var $EV_DUE		=	8;

	var $istatus = 0;

	var $db_cfg = NULL;			// Instancia db para la configuraicon
	var $_cfgdb_name = NULL;

	var $oUsr = NULL;				// Usuarios que esta manejando la instancia.

	var $oRecord;
	var $oComentarios;

	var $aUsuarios = array(
			'exgestor' => NULL,
			);

	function CRMEvent ($AppName,$dataconn,$cfgconn,$oUsr,$tabla,$aCampos = NULL,$aAcciones = NULL) {

		$aCampos['Departamentos:Departamento'] = array(
			'id_departamento', 'nombre','horas_jornada','hora_inicio_jornada','dia_primero','dia_ultimo'
			);
		$aCampos['Tipo_incidencia:Tipo'] = array(
			'id_tipo_incidencia', 'nombre', 'id_departamento', 'id_prioridad_defecto', 'tipo'
			);
		$aCampos['Prioridades:Prioridad'] = array(
			'id_prioridad', 'nombre'
			);
		$aCampos['Margenes_tiempo:Timing'] = array(
			'id_prioridad', 'id_tipo_incidencia', 'horas_estimadas'
			);
		$aCampos['Usuarios:Implicado'] = array(
			'id_usuario', 'nombre', 'apellidos', 'email'
				);
		$aCampos['Empleados:Gestor'] = array(
			'id_empleado', 'nombre', 'apellidos', 'email', 'cargo', 'comentarios_publicos', 'incidencias_departamentales'
				);

		$aAcciones['id_usuario_apertura'] = array('method' => 'updateOpener');
		$aAcciones['id_usuario_gestor'] = array('method' => 'updateManager');
		$aAcciones['id_usuario_implicado'] = array('method' => 'updateInvolved');
		$aAcciones['id_prioridad'] = array('method' => 'updatePriority');
		$aAcciones['id_tipo_incidencia'] = array('method' => 'updateType');

		if (!parent::dbItemMultiEntity($AppName,$dataconn,$tabla,$aCampos,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

		$this->setCfgDb($cfgconn);

		$this->setUser($oUsr);

	}


	function verifyAccess() {
		if ( ($this->status & $this->ST_CORRUPT) OR ($this->status & $this->ST_ACCESSDENIED) )
			return false;
		else return true;
	}

	/** 
	  * Metodo encargado de comprobar si el usuario tiene acceso a esta incidencia (obligatorio)
	  */
	function setUser($oUsr) {
		if (!is_object($oUsr)) $this->setFlag($this->ST_CORRUPT);
		$this->oUser = $oUsr;
	}

	function setStatus($estado = 0) {
		$retval = false;
		if (is_numeric($estado) ) {
			// debug("cambiando estado de la incidencia... ".$estado);
			$oApp = &$this->getApp();

			switch ($estado) {
				case $this->EV_PENDING:
					if ($this->istatus & $this->EV_PENDING) return true;
					if ($this->istatus & $this->EV_CLOSED) {
						$oApp->lcMessage('INC_STATUS_MISSUSE');
						return false;
					}
					$this->istatus = 0;
					$this->istatus |= $this->EV_PENDING;
					$this->setAttribute('estado',0);
					$this->setAttribute('fecha_inicio',NULL);
					$this->setAttribute('fecha_estimada',NULL);
					$this->setFlag($this->ST_EDIT);
					$retval = true;
					break;

				case $this->EV_STARTED:
					if ($this->checkStatus($this->EV_STARTED)) return true;
					if ($this->setAttribute('estado',1)) $this->setFlag($this->ST_EDIT);

					$checkdate = $this->getDate('estimada');
					if (empty($checkdate)) {
						$fecha = $this->DueDate(NULL,NULL,true);
						// debug("Estimando fecha de cierre ... ".$fecha);
						if (!empty($fecha)) {
							$this->setDate(NULL,'cierre');
							$this->istatus &= ~$this->EV_PENDING;
						}
					}

					$this->istatus |= $this->EV_STARTED;
					$checkdate = $this->getDate('estimada');
					if (!empty($checkdate)) 
						if (!$this->fechaMayor($checkdate,NULL)) {
							$this->istatus |= $this->EV_DUE;
						} else {
							$this->istatus &= ~$this->EV_DUE;
						}
					$retval = true;
					break;

				case $this->EV_CLOSED:
					if (!$this->checkStatus($this->EV_STARTED)) return true;
					if ($this->setAttribute('estado',2)) $this->setFlag($this->ST_EDIT);

					$checkdate = $this->getDate('cierre');
					if (empty($checkdate)) {
						$this->setDate('now','cierre');
						$this->istatus &= ~$this->EV_PENDING;
					}
					$this->istatus |= $this->EV_CLOSED;
					$checkdate = $this->getDate('estimada');
					if (!empty($checkdate)) 
						if (!$this->fechaMayor($checkdate,NULL)) {
							$this->istatus |= $this->EV_DUE;
						} else {
							$this->istatus &= ~$this->EV_DUE;
						}
					$retval = true;
					break;

				case $this->EV_DUE:
					// debug("Vencida! a copon macho ");
					$this->istatus |= $this->EV_DUE;
					$retval = true;
					break;

				default:
					debug("Ni puta idea del estado $esatado ");
					break;
			}
		}
		return $retval;
	}

	function getStatus() {
		return $this->istatus;
	}

	function checkStatus($flag = 0) {
		if (empty($flag) OR !is_numeric($flag)) return false;
		if ($this->istatus & $flag) return true;
		else return false;
	}


	/** Metodos generales **/

	function &getComments() {
		$this->_factoryComments();
		return $this->oComentarios;
	}

	function newComment($aCom) {
		if (!is_array($aCom) OR !sizeof($aCom)) return NULL;

		$this->_factoryComments();

		$aCom['fecha'] = $this->getDate('now');
		$idx = $this->oComentarios->insert($this->oUser,$aCom);

		return $idx;
	}

	function delComment($idx) {
		if (!is_numeric($idx)) return false;

		$this->_factoryComments();
		$retval = $this->oComentarios->delete($idx);

		return $retval;
	}

	function attachDocument($idx,$oDoc) {
		if (is_object($oDoc) AND !is_a($oDoc,'CRMDoc')) return false;
		elseif (!is_numeric($oDoc) AND !is_a($oDoc,'CRMDoc') ) return false;
		if (!is_numeric($idx)) $idx = $this->oComentarios->currentItem();
		if (!is_numeric($idx)) return false;
		
		$this->_factoryComments();
		$oComentario = &$this->oComentarios->getItem($idx);
		return $oComentario->addDocument($oDoc);
	}

	function getRelatedDocuments() {
		$this->_factoryComments();

		$aRetVal = NULL;
		$aDocs = array();
		for ($idx = $this->oComentarios->firstItem(); isset($idx); $idx = $this->oComentarios->nextItem()) {
			$oItem = $this->oComentarios->getItem();
			$aComDocs = $oItem->getDocuments();
			if (is_array($aComDocs) AND sizeof($aComDocs)) 
				foreach ($aComDocs as $iddoc) {
					if (!in_array($iddoc,$aDocs)) array_push($aDocs,$iddoc);
				}
		}
		if (sizeof($aDocs)) foreach ($aDocs as $iddoc) $aRetVal[]['id_documento'] = $iddoc;
		return $aRetVal;
	}


	/** Metodos sobre Atributos **/

	function getId() {
		return $this->getAttribute('id');
	}

	function setDate($fecha = NULL,$tipo = 'entrada') {
		if (empty($tipo)) return false;
		if (!strcasecmp($fecha,'now')) $fecha = $this->getDate('now');
		$retval = false;

		switch ($tipo) {
			case 'entrada':
				if (wol_db::formatear_fecha($fecha,false) == wol_db::formatear_fecha($this->getAttribute('fecha'),false)) continue;
				$this->setAttribute('fecha',$fecha);
				$retval = true;
				break;

			case 'inicio':
				if ($fecha == $this->getAttribute('fecha_inicio')) continue;
				$this->setAttribute('fecha_inicio',$fecha);
				$retval = true;
				break;

			case 'estimada':
				if ($fecha == $this->getAttribute('fecha_estimada')) continue;
				$this->setAttribute('fecha_estimada',$fecha);
				$retval = true;
				break;

			case 'cierre':
				if ($fecha == $this->getAttribute('fecha_cierre')) continue;
				$this->setAttribute('fecha_cierre',$fecha);
				$retval = true;
				break;

		}

		return $retval;
	}

	function getDate($tipo = 'entrada') {
		if (empty($tipo)) return NULL;
		$retval = NULL;
		switch ($tipo) {
			case 'entrada':
				$retval = $this->getAttribute('fecha');
				break;

			case 'inicio':
				$retval = $this->getAttribute('fecha_inicio');
				break;

			case 'estimada':
				$retval = $this->getAttribute('fecha_estimada');
				break;

			case 'cierre':
				$retval = $this->getAttribute('fecha_cierre');
				break;

			case 'now':
				$retval = date('Y-m-d H:i:s');
				break;
		}

		return $retval;
	}

	function update($aUpt,$destino = NULL) {
		if (is_numeric($aUpt['usuario_empleado']) AND !is_numeric($this->getAttribute('usuario_empleado')) ) 
			parent::update(array('usuario_empleado' => $aUpt['usuario_empleado']),$destino);
		return parent::update($aUpt,$destino);
	}

	function updatePriority($valor,$campo = NULL) {
		$oApp = &$this->getApp();
		$aPri = $this->getData('Prioridad');

		if (!is_numeric($valor)) {
			if (!is_array($Pri) OR !sizeof($Pri)) $oApp->lcMessage('INC_PRIORITY_NOTFOUND');
			return false;
		}

		$retval = false;
		if (!is_array($aPri) OR !sizeof($aPri) OR $this->getAttribute('id','Prioridad')!=$valor) {
			$aTipo = $this->getData('Tipo');
			$id = (int)$aTipo['id'];
			$oDb = &$this->getDb();
			$cons = 'SELECT '.
					'Pri.id_prioridad as "id", '.
					'Pri.id_prioridad as "id_prioridad", '.
					( ($id)
					  ?  'Timing.horas_estimadas as "horas", '
					  : '' ).
					'Pri.nombre as "nombre" '.
					'FROM Prioridades Pri '.
					( ($id)
					  ? 'LEFT JOIN Margenes_tiempo Timing ON (Pri.id_prioridad=Timing.id_prioridad AND Timing.id_tipo_incidencia='.$id.') '
					  : '' ).
					'WHERE Pri.id_prioridad = '.$valor;
			$prs = $oDb->query($cons);
			if ($oDb->num_rows($prs)) {
				$aTmp = $oDb->fetch_assoc($prs);
				$this->update($aTmp,'Prioridad');
				if ($this->setAttribute('id_prioridad',$aTmp['id'])) $retval = true;
				$retval = true;
			} else {
				$oApp->lcMessage('INC_PRIORITY_NOTFOUND',array('id' => $valor));
			}
		}
		return $retval;
	}

	function updateType($valor,$campo = NULL) {
		$oApp = &$this->getApp();
		if (!is_numeric($valor)) {
			$aInc = $this->getData();
			if (!is_array($aInc) OR !sizeof($aInc)) $oApp->lcMessage('INC_TYPE_NOTFOUND');
			return false;
		}

		$retval = false;
		$aTipo = $this->getData('Tipo');
		if (!is_array($aTipo) OR !sizeof($aTipo) OR $this->getAttribute('id','Tipo')!=$valor) {
			$aPri = $this->getData('Prioridad');
			$id = (int)$aPri['id'];
			$oDb = &$this->getDb();
			$cons = 'SELECT '.
						'TInc.id_tipo_incidencia as "tip_id", '.
						'TInc.nombre as "tip_nombre", '.
						'TInc.id_departamento as "tip_id_departamento", '.
						'TInc.tipo as "tip_tipo", '.
						'DTInc.nombre as "tip_nombre_departamento", '.
						'DTInc.id_agrupacion_documentos as "tip_id_agrupacion_documentos_internos", '.
						'DTInc.id_agrupacion_documentos_externos as "tip_id_agrupacion_documentos_externos", '.
						'DTInc.id_coordinador as "tip_id_coordinador", '.
						// Coordinador
						'Coo.id_empleado as "coo_id", '.
						'Coo.id_empleado as "coo_id_coordinador", '.
						'Coo.nombre as "coo_nombre", '.
						'Coo.apellidos as "coo_apellidos", '.
						'Coo.cargo as "coo_cargo", '.
						'Coo.email as "coo_email", '.
						'Coo.comentarios_publicos as "coo_comentarios_publicos", '.
						'Coo.incidencias_departamentales as "coo_incidencias_departamentales", '.
						( ($id)
						  ?  'Timing.horas_estimadas as "pri_horas", '
						  : '').
						'TInc.id_prioridad_defecto as "tip_id_prioridad_defecto" '.
						'FROM Tipo_incidencia TInc LEFT JOIN Departamentos DTInc ON (TInc.id_departamento=DTInc.id_departamento) '.
						'LEFT JOIN Empleados Coo ON (DTInc.id_coordinador=Coo.id_empleado) '.
						( ($id)
						  ? 'LEFT JOIN Margenes_tiempo Timing ON (TInc.id_tipo_incidencia=Timing.id_tipo_incidencia AND Timing.id_prioridad = '.$id.') '
						  : '').
						'WHERE TInc.id_tipo_incidencia = '.$valor;
			$tirs = $oDb->query($cons);
			if ($oDb->num_rows($tirs)) {
				$aTipo = $oDb->fetch_assoc($tirs);
				foreach ($aTipo as $campo => $valor) {
					switch (substr($campo,0,4)) {
						case 'pri_':
							if (!empty($valor)) $this->setAttribute(substr($campo,4),$valor,'Prioridad');
							break;
						case 'tip_':
							if (is_numeric($valor) OR !empty($valor)) $aT[substr($campo,4)] = $valor;
							break;
						case 'coo_':
							if (is_numeric($valor) OR !empty($valor)) $aC[substr($campo,4)] = $valor;
							break;
					}
				}
				if (is_array($aT) AND sizeof($aT)) {
					$this->update($aT,'Tipo');
					$this->setAttribute('id_tipo_incidencia',$aT['id']);
					if (empty($id) AND !empty($aT['id_prioridad_defecto'])) {
						// No hay prioridad establecida ... 
						$this->updatePriority($aT['id_prioridad_defecto']);
					}
				}
				if (is_array($aC) AND sizeof($aC)) {
					$this->update($aC,'Coordinador');
				}
				$retval = true;
			} else {
				$oApp->lcMessage('INC_TYPE_NOTFOUND');
			}
		}

		return $retval;
	}


	function updateOpener($valor = NULL,$campo = NULL) {
		$oApp = &$this->getApp();

		if (!is_numeric($valor) AND !is_object($this->oUser)) {
			$oApp->lcMessage('INC_OPENNING_NOTFOUND');
			return false;
		}
		// debug("updateOpener($valor) ");

		$retval = false;
		$aO = $this->getData('Apertura');
		if ($this->checkFlag($this->ST_NEW) OR (is_numeric($valor) AND !$aO) ) {
			$retval = true;
			$aIntDesk = array('Gerente','Empleado','Coordinador');
			$aExtDesk = array('Cliente','Proveedor');

			// Averiguamos si va a ser usuario o empleado. 
			$usuario_empleado = (int)$this->getAttribute('usuario_empleado');

			if (!isset($usuario_empleado) AND is_object($this->oUser)) {
				$aDesk = $this->oUser->get_desktop();
				if (!in_array($aDesk['nombre'],$aExtDesk)) $usuario_empleado = 1;
				else $usuario_empleado = 0;
			} elseif (!isset($usuario_empleado)) {
				$oApp->lcMessage('INC_OPENNING_NOTFOUND',array('id' => $valor));
				return false;
			}

			if ( !is_numeric($valor)) {
				if (!is_array($aDesk)) {
					if (!is_a($this->oUser,'wolUsr')) {
						debug("de mierda hasta el cuello");
						return false;
					} else $aDesk = $this->oUser->get_desktop();
				}
				$valor = $aDesk['value'];
			} 

			$aO = CRMComment::findUser(( ($usuario_empleado) ? 'Empleados' : 'Usuarios' ),$valor,$this->getDb());
			// $this->setData('Apertura',$aO);

			if (!$aO) $retval = false;
			else {
				$this->setAttribute('id_usuario_apertura',$aO['id'],NULL,true);
				$this->setAttribute('usuario_empleado',$usuario_empleado,NULL,true);
				// debug("Usuario apertura : ");
				// print_r($aO);
				$this->update($aO,'Apertura');
				$retval = true;
			}
		} else {
			$oApp->lcMessage('INC_OPENNING_NOTFOUND',array('id' => $valor));
		}
		return $retval;
	}

	function updateInvolved($valor,$campo = NULL) {
		$oApp = &$this->getApp();
		$aImp = $this->getData('Implicado');

		if (!is_numeric($valor)) {
			if (!is_array($aImp) OR !sizeof($aImp)) $oApp->lcMessage('INC_INVOLVED_NOTFOUND');
			return false;
		}

		$retval = false;
		if ($this->checkFlag($this->ST_NEW)) {
			$retval = true;
			if ( !is_array($aImp) OR !sizeof($aImp) OR ($this->getAttribute('id','Implicado')!=$valor) ) {
				$oDb = &$this->getDb();
				$aRet = CRMComment::findUser('Usuarios',$valor,$this->getDb());
				if (!is_array($aRet) OR !sizeof($aRet)) {
					$oApp->lcMessage('INC_INVOLVED_NOTFOUND',array('id' => $valor));
				} else {
					$this->update($aRet,'Implicado');
					if ($this->setAttribute('id_usuario_implicado',$aRet['id'])) $retval = true;
				}
			} else {
				$retval = false;
			}
		}
		return $retval;
	}

	function updateManager($valor = NULL,$campo = NULL) {
		$oApp = &$this->getApp();
		$aGes = $this->getData('Gestor');
		$aCoo = $this->getData('Coordinador');

		if (!is_numeric($valor)) {
			if (!is_array($aCoo) OR !sizeof($aCoo)) {
				$oApp->lcMessage('INC_MANAGER_NOTFOUND');
				return false;
			} else {
				$valor = $aCoo['id'];
			}
		}
		$retval = false;
		if (!is_array($aGes) OR !sizeof($aGes) OR ($this->getAttribute('id','Gestor')!=$valor) ) {
			$oDb = &$this->getDb();

			$cons = 'SELECT '.
						'Ges.id_empleado as "ges_id", '.
						'Ges.id_empleado as "ges_id_empleado", '.
						'Ges.nombre as "ges_nombre", '.
						'Ges.apellidos as "ges_apellidos", '.
						'Ges.cargo as "ges_cargo", '.
						'Ges.email as "ges_email", '.
						'Ges.comentarios_publicos as "ges_comentarios_publicos", '.
						'1 as "ges_comentarios_privados", '.
						'Ges.incidencias_departamentales as "ges_incidencias_departamentales", '.
						'D.id_departamento as "dep_id_departamento", '.
						'D.nombre as "dep_nombre", '.
						'D.horas_jornada as "dep_horas_jornada", '.
						'D.hora_inicio_jornada as "dep_hora_inicio_jornada", '.
						'D.dia_primero as "dep_primer_dia_semana", '.
						'D.dia_ultimo as "dep_ultimo_dia_semana" '.
						'FROM Empleados Ges LEFT JOIN Departamentos D ON (Ges.id_departamento = D.id_departamento) '.
						'WHERE D.id_departamento IS NOT NULL AND Ges.id_empleado = '.$valor;
			$mid = $oDb->query($cons);
			if ($oDb->num_rows($mid)) {
				$aData = $oDb->fetch_assoc($mid);
				foreach ($aData as $campo => $valor) {
					switch (substr($campo,0,4)) {
						case 'ges_':
							if (is_numeric($valor) OR !empty($valor))  $aG[substr($campo,4)] = $valor;
							break;
						case 'dep_':
							if (is_numeric($valor) OR !empty($valor))  $aD[substr($campo,4)] = $valor;
							break;
					}
				}

				if (is_array($aG) AND sizeof($aG)) {
					$this->update($aGes,'ExGestor');
					$this->update($aG,'Gestor');
					if ($this->setAttribute('id_usuario_gestor',$aG['id'])) $retval = true;
				}
				if (is_array($aD) AND sizeof($aD)) {
					$this->update($aD,'Departamento');
				}
				$retval = true;
			} else {
				$oApp->lcMessage('INC_MANAGER_NOTFOUND',array('id' => $valor));
			}
		}
		return $retval;
	}



	/** Metodos de apoyo **/

	function _factoryComments() {
		if (!is_object($this->oComentarios)) {
			$this->oComentarios = new CRMEventComments($this);
			$this->oComentarios->dbFill();
		}
	}

	function DueDate($fecha_inicio=NULL,$bForce = false,$bSetValues = false) {
		// debug("Estimando fecha de cierr... jas");
		if (empty($fecha_inicio)) $fecha_inicio = $this->getDate('inicio');

		$fecha_estimada = $this->getAttribute('fecha_estimada');
		if (empty($fecha_estimada) OR $bForce) {
			if (!empty($fecha_inicio)) $fecha_ini = $fecha_inicio;
			else $fecha_ini = $this->getDate('now');
			// $fecha_ini = $this->getDate();
			if (empty($fecha_ini)) $this->setDate();
			$oApp = &$this->getApp();
			$aDep = $this->getData('Departamento');
			if (!is_array($aDep) OR !sizeof($aDep)) {
				$oApp->lcMessage('INC_MDEP_NOTFOUND',array('id'=>$this->getId()));
				return false;
			}
			if (empty($aDep['horas_jornada'])) {
				$oApp->lcMessage('INC_MDEPHOURS_NOTFOUND',array('dep'=>$this->aDepartamento['nombre']));
				return false;
			}
			$hjornada = $aDep['horas_jornada'];
			$aPri = $this->getData('Prioridad');
			if (empty($aPri['horas'])) {
				$oApp->lcMessage('INC_PRIORITY_TIME',array('prioridad'=>$aPri['nombre']));
				return false;
			}
			$hresolucion = $aPri['horas'];

			$ts_ini = strtotime($fecha_ini);
			$aDiaIni = getdate($ts_ini);
			$aTmp = split(':',$aDep['hora_inicio_jornada']);
			$horafinjornada = $hjornada;
			$horafinjornada += array_shift($aTmp);
			if (sizeof($aTmp)) {
				$horafinjornada .= ':'.implode(':',$aTmp);
			} else $horafinjornada .= ':00';

			//debug("Vamos a tardar $hresolucion horas en jornadas de $hjornada . Terminamos a las $horafinjornada");
			// print_r($aDep);

			if ($aDep['primer_dia_semana']==$aDep['ultimo_dia_semana']) {
				$diasbreak = 0;
			} else {
				$diasbreak = 7 - $this->numLaborDays();
			}
			// debug("<b>DESCANSO</b> en dias = $diasbreak siendo hoy el ".$aDiaIni['wday']);
					
			$duetime = $aDiaIni[0];
			$diasemanainicial = $aDiaIni['wday'];
			$diadescansoprimero = $aDep['ultimo_dia_semana'] + 1;
			if ($diadescansoprimero>6) $diadescansoprimero = 0;

			if ( $diasbreak AND (!$this->testLaborDay($aDiaIni['wday']) OR (!$this->testLaborDay($diasemanainicial+1) AND $this->horaMayor($aDiaIni,$horafinjornada))) ) {
				$tmp = ($diasbreak-abs(($diadescansoprimero)-$diasemanainicial));
				$duetime = strtotime("+$tmp day",$duetime);
				// Empezamos ese dia a la hora de entrada.
				$duetime = strtotime(strftime('%Y-%m-%d '.$aDep['hora_inicio_jornada'],$duetime));
			} elseif ($this->horaMayor($aDiaIni,$horafinjornada)) {
				// Si ya hemos pasado el fin de la jornada..
				$duetime = strtotime("+1 day",$duetime);
				$duetime = strtotime(strftime('%Y-%m-%d '.$aDep['hora_inicio_jornada'],$duetime));
			}
			$starttime = $duetime;
			// debug("Empezamos en ".strftime('%c',$duetime));
			// debug("se tardan $hresolucion horas en jornadas de $hjornada horas, esto son:  ".$hresolucion/$hjornada." Dias ");

			// Sumamos el numero de dias de resolucion de incidencia
			$ndias = floor($hresolucion / $hjornada);
			if (!empty($ndias)) $duetime = strtotime("+$ndias day",$duetime);
			// debug("Ya estamos, $ndias dias mas, en ".strftime('%c',$duetime));

			// Sumamos el numero de fines de semana intermedios en estos dias.
			$nbreaks = floor( $ndias/(7-$diasbreak) );
			// debug("han pasado $nbreaks findes de $diasbreak dias de descanso. (".(7-$diasbreak)." de curro) ");
			if (!empty($ndias)) {
				$duetime = strtotime("+".($nbreaks*$diasbreak)." day",$duetime);
				// debug("Saltando los findes son ".($nbreaks*$diasbreak)." dias mas, en ".strftime('%c',$duetime));
			}

			$nrestan = round($hresolucion % $hjornada,2);
			if (!empty($nrestan)) {
				$duetime = strtotime("+$nrestan hours",$duetime);
				//debug("le faltaban $nrestan horas.. : ".strftime('%c',$duetime));
				$mashoras = 0;
				if ($this->horaMayor( $duetime, $horafinjornada) ) {
					$duetime = strtotime('+'.(24-$hjornada).' hours',$duetime);
					//debug("Encima se le pasa la hora (+".(24-$hjornada)."): ".strftime('%c',$duetime));
				}
				$aTmp = getdate($duetime);
				if ( $diasbreak AND (!$this->testLaborDay($aTmp['wday'])) ) {
					$tmp = ($diasbreak-abs(($diadescansoprimero)-$aTmp['wday']));
					$duetime = strtotime("+$tmp day",$duetime);
					//debug("juas! va y cae en finde ($tmp) : ".strftime('%c',$duetime));
				} 
			}
			$retval = strftime('%Y-%m-%d %H:%M:%S',$duetime);
			if ($bSetValues AND !empty($starttime) AND !empty($duetime)) {
				$this->setDate(strftime('%Y-%m-%d %H:%M:%S',$starttime),'inicio');
				$this->setDate(strftime('%Y-%m-%d %H:%M:%S',$duetime),'estimada');
			}
		}
		return $retval;
	}

	function fechaMayor($prime = NULL,$segu = NULL) {
		if (empty($prime)) $prime = time();
		elseif ( ($prime = strtotime($prime)) === -1 ) return -1;
		if (empty($segu)) $segu = time();
		elseif ( ($segu = strtotime($segu)) === -1 ) return -1;

		if ($prime > $segu) return true;
		else return false;
	}

	function horaMayor($prime,$segu) {

		if (is_array($prime) AND is_numeric($prime['hours']) ) {
			$aTimePrime = $prime;
		} elseif (is_numeric($prime)) {
			$aTimePrime = getdate($prime);
		} elseif (strchr($prime,':')) {
			$aTmp = split(' ',$prime);
			foreach ($aTmp as $tst) 
				if (strchr($tst,':')) {
					$aT = split(':',$tst);
					$aTimePrime['hours'] = (int)$aT[0];
					$aTimePrime['minutes'] = (int)$aT[1];
					$aTimePrime['seconds'] = (int)$aT[2];
				}
		} else return -1;

		if (is_array($segu) AND is_numeric($segu['hours']) ) {
			$aTimeSegu = $segu;
		} elseif (is_numeric($segu)) {
			$aTimeSegu = getdate($segu);
		} elseif (strchr($segu,':')) {
			$aTmp = split(' ',$segu);
			foreach ($aTmp as $tst) 
				if (strchr($tst,':')) {
					$aT = split(':',$tst);
					$aTimeSegu['hours'] = (int)$aT[0];
					$aTimeSegu['minutes'] = (int)$aT[1];
					$aTimeSegu['seconds'] = (int)$aT[2];
				}
		} else return -1;

		if ($aTimePrime['hours'] > $aTimeSegu['hours']) return true;
		elseif ($aTimePrime['hours'] < $aTimeSegu['hours']) return false;
		elseif ($aTimePrime['minutes'] > $aTimeSegu['minutes']) return true;
		elseif ($aTimePrime['minutes'] < $aTimeSegu['minutes']) return false;
		elseif ($aTimePrime['seconds'] > $aTimeSegu['seconds']) return true;
		elseif ($aTimePrime['seconds'] < $aTimeSegu['seconds']) return false;
		else return false;
	}

	function numLaborDays($primero = NULL,$ultimo = NULL) {
		if (!is_numeric($primero)) $primero = $this->getAttribute('primer_dia_semana','Departamento');
		if (!is_numeric($primero)) return NULL;
		if (!is_numeric($ultimo)) $ultimo = $this->getAttribute('ultimo_dia_semana','Departamento');
		if (!is_numeric($ultimo)) return NULL;
				
		if ($primero == $ultimo) {
			$dias= 7;
		} elseif ($primero>$ultimo) {
			$dias = 7 - abs( ($ultimo+1) - ($primero));
		} else {
			$dias = abs(($ultimo+1) - $primero);
		}
		return $dias;
	}

	function testLaborDay($dia,$primero = NULL,$ultimo = NULL) {
		if (!is_numeric($primero)) $primero = $this->getAttribute('primer_dia_semana','Departamento');
		if (!is_numeric($primero)) return -1;
		if (!is_numeric($ultimo)) $ultimo = $this->getAttribute('ultimo_dia_semana','Departamento');
		if (!is_numeric($ultimo)) return -1;
		if (!is_numeric($dia)) return -1;

		// debug("testLaborDay $primero a $ultimo de $dia");
		if ($primero == $ultimo) { 
			return true;
		} elseif ($primero>$ultimo) {
			if ($dia < $primero AND $dia > $ultimo) return false;
			else return true;
		} else {
			if ($dia >= $primero AND $dia <= $ultimo) return true;
			else return false;
		}
	}

	/** Metodos de flujo y pueble de estructuras **/

	function postFill() {

		if (!$this->updateOpener($this->getAttribute('id_usuario_apertura'))) {
			debug("Usuario de apertura no encontrado ... ".$this->getAttribute('id_usuario_apertura'));
			return false;
		}

		$id_tipo = $this->getAttribute('id_tipo_incidencia');
		if (!is_numeric($id_tipo)) $id_tipo = $this->getAttribute('id_tipo');
		if (!$this->updateType($id_tipo)) return false;
		$this->setAttribute('id',$id_tipo,'Tipo');

		$aT = $this->getData('Timing');
		if (is_array($aT) AND sizeof($aT)) $this->setAttribute('horas',$aT['horas_estimadas'],'Prioridad');

		$this->setAttribute('id',$this->getAttribute('id_prioridad','Prioridad'),'Prioridad');
		$this->setAttribute('id',$this->getAttribute('id_empleado','Gestor'),'Gestor');
		$this->setAttribute('id',$this->getAttribute('id_usuario','Implicado'),'Implicado');
		$this->setAttribute('id',$this->getAttribute('id_departamento','Departamento'),'Departamento');

		$estado_incidencia = (int)$this->getAttribute('estado');
		if (is_numeric($estado_incidencia)) {
			if (empty($estado_incidencia)) $this->setStatus($this->EV_PENDING);
			elseif ($estado_incidencia==1) $this->setStatus($this->EV_STARTED);
			elseif ($estado_incidencia==2) $this->setStatus($this->EV_CLOSED);
			else $this->setStatus($estado_incidencia);
		}
		$this->unsetFlag($this->ST_EDIT | $this->ST_NEW);
		return true;
	}

	function Dump() {
		$aO = $this->getData('Apertura');
		if (!is_array($aO) OR !sizeof($aO)) {
			if (!$this->updateOpener()) {
				debug("Usuario de apertura not set... quitting");
				return false;
			}
		}

		$aG = $this->getData('Gestor');
		if (!is_array($aG) OR !sizeof($aG)) $this->updateManager();

		$f = $this->getAttribute('fecha');
		if (!isset($f) OR empty($f)) {
			$this->setDate('now');
		}
		$retval = parent::Dump('db');
		if (is_object($this->oComentarios)) $this->oComentarios->Dump('db');
		return $retval;
	}

	function &getCfgDb() {
		return $this->db_cfg;
	}

	function setCfgDb($cfgconn = NULL) {
		if (empty($cfgconn)) $cfgconn = $this->_cfgdb_name;
		if (empty($cfgconn)) return false;

		$Ses = &$this->getApp();
		$this->db_cfg = $Ses->get_db($cfgconn);
		if (!is_object($this->db_cfg) OR !is_a($this->db_cfg,'wol_db') ) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
		$this->_cfgdb_name = $cfgconn;
		return true;
	}

	function getCfgDbName() {
		return $this->_cfgdb_name;
	}

	function init() {
		parent::init();

		if (!is_object($this->db_cfg)) {
			if (empty($this->_cfgdb_name)) return false;
			$oApp = &$this->getApp();
			$this->db_cfg = $oApp->get_db($this->_cfgdb_name);
			if (!is_object($this->db_cfg)) return false;
		}
		if (is_object($this->oUser)) $this->oUser->init();
		return true;
	}

	function cerrar() {
		parent::cerrar();
		unset($this->sesion);
		unset($this->db_cfg);
		if (is_object($this->oUser)) $this->oUser->cerrar();
	}

}

class Incidencia extends CRMEvent {
	var $NOTI_NEW		=	1;
	var $NOTI_EDIT		=	2;
	var $NOTI_COMMENT	=	4;
	var $NOTI_SCALE	=	8;
	var $NOTI_CLOSE	=	16;
	var $aTipoNotificacion = array(
			1	=> array( 'Apertura' => true, 'Implicado' => true, 'Gestor' => true, 'Coordinador' => true ),
			2	=> array( 'Apertura' => true, 'Implicado' => true, 'Gestor' => true, 'Coordinador' => true ),
			4	=> array( 'Apertura' => true, 'Implicado' => true, 'Gestor' => true, 'Coordinador' => true ),
			8	=> array( 'Gestor' => true, 'Coordinador' => true, 'ExGestor' => true ),
			16	=> array( 'Apertura' => true, 'Implicado' => true, 'Gestor' => true, 'Coordinador' => true ),
			);


	var $aStrChanges = array();

	function Incidencia ($AppName,$dataconn,$cfgconn,$oUsr) {
		
		$aCampos['Incidencias:Incidencia'] = array(		
			'id_incidencia', 'id_prioridad', 'id_tipo_incidencia',
			'usuario_empleado', 'id_usuario_apertura', 'id_usuario_implicado', 'id_usuario_gestor',
			'nombre', 'nota_apertura', 'estado',
			'fecha', 'fecha_inicio', 'fecha_estimada', 'fecha_cierre'
			);		
		$aAcciones['id_incidencia'] = array('exclude' => array('new' => false, 'edit' => false) );

		return parent::CRMEvent($AppName,$dataconn,$cfgconn,$oUsr,'Incidencias',$aCampos,$aAcciones);
	}

	/** Metodos sobre Atributos **/
	function getId() {
		$id = $this->getAttribute('id');
		if (!is_numeric($id)) $id = $this->getAttribute('id_incidencia');
		return $id;
	}

	function postFill() {
		$retval = parent::postFill();
		if ($retval) {
			$this->setAttribute('id',$this->getAttribute('id_incidencia'),NULL,true);
		}
		return $retval;
	}

	/** Metodos de flujo y pueble de estructuras **/

	function dbFill($id) {
		// if (!$this->verifyAccess()) return false;
		$oApp = &$this->getApp();
		if (!is_numeric($id)) {
			$oApp->lcMessage('INC_NOID',array('id'=>$id));
			return false;
		}
		return parent::dbFill(array('id_incidencia' => $id));
	}

	function dbDump() {
		$retval = parent::dbDump();
		$this->setAttribute('id',$this->getAttribute('id_incidencia'));
			
		return $retval;
	}

	function postDump($dumpret) {
		if ($dumpret) $this->notifyChanges();
		return $dumpret;
	}

	function getKeyField() {
		return 'id_incidencia';
	}
	
	/** Metodos para Notificaciones **/
	function newComment($aCom) {
		$retval = parent::newComment($aCom);
		return $retval;
	}

	function attachDocument($idx,$oDoc) {
		$retval = parent::attachDocument($idx,$oDoc);
		debug("Notificando Nuevo Documento ... ");
		return $retval;
	}

	function updatePriority($valor,$campo = NULL) {
		$lastval = $this->getAttribute('id','Prioridad');
		$lastname = $this->getAttribute('nombre','Prioridad');
		$retval = parent::updatePriority($valor,$campo);

		if ($retval AND $lastval!=$this->getAttribute('id','Prioridad') ) {
			if (!$this->checkFlag($this->ST_NEW)) {
				$oApp = &$this->getApp();
				$oMsg = $oApp->getMsgs();
				$aMsg = $oMsg->rawMsg('INC_EMAIL_CHGPRIORITY');
				$this->aStrChanges['Prioridad.nombre']  = $oMsg->parseMsg($aMsg['msg'],array('anterior' => $lastname,'actual' => $this->getAttribute('nombre','Prioridad')));
			}
		}
		return $retval;
	}

	function updateType($val,$fld = NULL) {
		$lastval = $this->getAttribute('id_tipo_incidencia');
		$lastname = $this->getAttribute('nombre','Tipo');
		$retval = parent::updateType($val,$fld);

		if ($retval AND $lastval!=$this->getAttribute('id_tipo_incidencia') ) {
			if (!$this->checkFlag($this->ST_NEW)) {
				$oApp = &$this->getApp();
				$oMsg = $oApp->getMsgs();
				$aMsg = $oMsg->rawMsg('INC_EMAIL_CHGTYPE');
				$this->aStrChanges['Tipo.nombre']  = $oMsg->parseMsg($aMsg['msg'],array('anterior' => $lastname,'actual' => $this->getAttribute('nombre','Tipo')));
			}
		}
		return $retval;
	}

	function setStatus($estado = 0) {
		$lastval = $this->getStatus();
		$retval = parent::setStatus($estado);

		if ($retval AND $lastval != $this->getStatus() AND $lastval != 0) {
			$oApp = &$this->getApp();
			$oMsg = $oApp->getMsgs();

			if ($lastval & $this->EV_PENDING) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_PENDING' );
			elseif ($lastval & $this->EV_CLOSED) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_CLOSED' );
			elseif ($lastval & $this->EV_DUE) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_DUE' );
			elseif ($lastval & $this->EV_STARTED) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_OPEN' );
			if (is_array($rawmsg) AND !empty($rawmsg['msg'])) $anterior = $oMsg->parseMsg($rawmsg['msg']);
			$rawmsg = NULL;

			if ($this->checkStatus($this->EV_PENDING)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_PENDING' );
			elseif ($this->checkStatus($this->EV_CLOSED)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_CLOSED' );
			elseif ($this->checkStatus($this->EV_DUE)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_DUE' );
			elseif ($this->checkStatus($this->EV_STARTED)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_OPEN' );
			if (is_array($rawmsg) AND !empty($rawmsg['msg'])) $actual = $oMsg->parseMsg($rawmsg['msg']);

			$aMsg = $oMsg->rawMsg('INC_EMAIL_CHGSTATUS');
			$this->aStrChanges['estado']  = $oMsg->parseMsg($aMsg['msg'],array('anterior' => $anterior,'actual' => $actual));
		}
		return $retval;
	}

	function notifyChanges() {

		if ($this->checkFlag($this->ST_NEW)) {
			$tipo = $this->NOTI_NEW;
		} elseif ($this->checkFlag($this->ST_EDIT)) {
			$tipo = $this->NOTI_EDIT;
		}
		if ($this->checkStatus($this->EV_CLOSED)) $tipo = $this->NOTI_CLOSE;

		if (is_object($this->oComentarios)) {
			$lid = $this->oComentarios->lastItem();
			$oCom = $this->oComentarios->getItem($lid);
			if ($oCom->checkFlag($oCom->ST_NEW)) $tipo |= $this->NOTI_COMMENT;
		}
		$aEx = $this->getData('ExGestor');
		if (is_array($aEx) AND sizeof($aEx)) $tipo |= $this->NOTI_SCALE;

		$aData = $this->getData();
		$aData['usuario_apertura'] = $this->getAttribute('nombre','Apertura').' '.$this->getAttribute('apellidos','Apertura');
		$aData['usuario_implicado'] = $this->getAttribute('nombre','Implicado').' '.$this->getAttribute('apellidos','Implicado');
		$aData['usuario_gestor'] = $this->getAttribute('nombre','Gestor').' '.$this->getAttribute('apellidos','Gestor').' ('.$this->getAttribute('cargo','Gestor').')';
		$aData['usuario_coordinador'] = $this->getAttribute('nombre','Coordinador').' '.$this->getAttribute('apellidos','Coordinador');

		$aMails = array();
		$oApp = &$this->getApp();
		$oMsg = $oApp->getMsgs();

		$aCfg = $oApp->get_var('_aAppConf');
		if (empty($aCfg['email'])) {
			$oApp->lcMessage('INC_NOEMAIL');
			return false;
		}
		$strSep = "\n";

		// Cabecera del Email 
		if ($tipo & $this->NOTI_NEW) {
			$aMsg = $oMsg->rawMsg('INC_EMAIL_NEWINTRO');
			$cabecera = $aMsg['msg'];
			$subject  = '['.$this->getId().']  '.$this->getDate().' -['.$this->getAttribute('nombre','Tipo').']- NEW ';
			// $msg = $oMsg->parseMsg($aMsg['msg'],array('anterior' => $lastname,'actual' => $this->getAttribute('nombre','Prioridad')));
		} elseif ($tipo & $this->NOTI_CLOSE) {
			$aMsg = $oMsg->rawMsg('INC_EMAIL_CLOSEDINTRO');
			$cabecera = $aMsg['msg'];
			$subject  = '['.$this->getId().']  '.$this->getDate().' -['.$this->getAttribute('nombre','Tipo').']- CLOSED ';
		} else {
			$aMsg = $oMsg->rawMsg('INC_EMAIL_EDITINTRO');
			$cabecera = $aMsg['msg'].$strSep;
			$subject  = '['.$this->getId().']  '.$this->getDate().' -['.$this->getAttribute('nombre','Tipo').']- ('.
							$this->getAttribute('nombre','Implicado').' '.$this->getAttribute('apellidos','Implicado').') ';
		}


		$aCampos = array(
				'id_incidencia' => array('msgid' => 'INC_EMAILFLD_NUMERO'),
				'Tipo.nombre' => array('msgid' => 'INC_EMAILFLD_TIPO'),
				'Prioridad.nombre' => array('msgid' => 'INC_EMAILFLD_PRIORIDAD'),
				'usuario_implicado' => array('msgid' => 'INC_EMAILFLD_IMPLICADO'),
				'fecha' => array('msgid' => 'INC_EMAILFLD_FECHA'),
				'fecha_inicio' => array('msgid' => 'INC_EMAILFLD_FECHAINI'),
				'fecha_estimada' => array('msgid' => 'INC_EMAILFLD_FECHAEST'),
				'fecha_fin' => array('msgid' => 'INC_EMAILFLD_FECHAFIN'),
				'usuario_apertura' => array('msgid' => 'INC_EMAILFLD_APERTURA'),
				'nota_apertura' => array('msgid' => 'INC_EMAILFLD_NOTA'),
				'usuario_gestor' => array('msgid' => 'INC_EMAILFLD_GESTOR','exclude' => array('Implicado') ),
				'usuario_coordinador' => array('msgid' => 'INC_EMAILFLD_COORDINADOR','exclude' => array('Implicado') ),
				'estado' => array('msgid' => 'INC_EMAILFLD_STATUS' )
				);

		$tipo_dest = $tipo;
		// Sacamos a $aMails _todos_ los destinos, independientemente del contenido a enviar:
		while ($tipo_dest) {
			if ($tipo_dest & $this->NOTI_EDIT) {
				$tmp_tipo = $this->NOTI_EDIT;
				$tipo_dest &= ~$this->NOTI_EDIT;
			} elseif ($tipo_dest & $this->NOTI_COMMENT) {
				$tmp_tipo = $this->NOTI_COMMENT;
				$tipo_dest &= ~$this->NOTI_COMMENT;
			} elseif ($tipo_dest & $this->NOTI_NEW) {
				$tmp_tipo = $this->NOTI_NEW;
				$tipo_dest &= ~$this->NOTI_NEW;
			} elseif ($tipo_dest & $this->NOTI_SCALE) {
				$tmp_tipo = $this->NOTI_SCALE;
				$tipo_dest &= ~$this->NOTI_SCALE;
			} elseif ($tipo_dest & $this->NOTI_CLOSE) {
				$tmp_tipo = $this->NOTI_CLOSE;
				$tipo_dest &= ~$this->NOTI_CLOSE;
			} else {
				$tmp_tipo = NULL;
				$tipo_dest = 0;
			}

			if (is_numeric($tmp_tipo) AND is_array($this->aTipoNotificacion[$tmp_tipo]))
				foreach ($this->aTipoNotificacion[$tmp_tipo] as $quien => $bool) {
					if ($bool) {
						$aQ = $this->getData($quien);
						if (is_array($aQ) AND sizeof($aQ) AND !empty($aQ['email'])) {
							if ( !is_array($aMails[$aQ['email']])) {
								if (!is_array($aMails[$aQ['email']])) {
									$aMails[$aQ['email']] = 
										array('roles' => array(), 'mailsubject' => $subject, 'mailbody' => $cabecera, 'changes' => NULL, 
												'comentarios_publicos' => $aQ['comentarios_publicos'], 'comentarios_privados' => $aQ['comentarios_privados']
												);
								} else {
									if (!$aMails[$aQ['email']]['comentarios_publicos']) $aMails[$aQ['email']]['comentarios_publicos'] = $aQ['comentarios_publicos'];
									if (!$aMails[$aQ['email']]['comentarios_privados']) $aMails[$aQ['email']]['comentarios_privados'] = $aQ['comentarios_privados'];
								}
							}
							// debug("a $quien : ".$aQ['email']);
							// array_push($aMails[$aQ['email']]['roles'],$quien);
						} else continue;
					}
				}
		}

		// El estado lo tratamos de una forma especial:
		if (empty($this->aStrChanges['estado'])) {
			if ($this->checkStatus($this->EV_PENDING)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_PENDING' );
			elseif ($this->checkStatus($this->EV_DUE)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_DUE' );
			elseif ($this->checkStatus($this->EV_STARTED)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_OPEN' );
			elseif ($this->checkStatus($this->EV_CLOSED)) $rawmsg = $oMsg->rawMsg( 'INC_EMAILST_CLOSED' );
			if (is_array($rawmsg) AND !empty($rawmsg['msg'])) $aData['estado'] = $oMsg->parseMsg($rawmsg['msg']);
		}

		// Campos de la Incidencia
		foreach ($aCampos as $fld => $aOpt) {
			if (!empty($this->aStrChanges[$fld])) {
				$msg = $this->aStrChanges[$fld];
				$destino = 'changes';
			} else {
				$value = $aData[$fld];
				if (empty($value) AND !is_numeric($value)) $value = $this->getAttribute($fld);
				if ( (empty($value) AND !is_numeric($value)) OR empty($aOpt['msgid']) ) continue;
				$rawmsg = $oMsg->rawMsg($aOpt['msgid']);
				$msg = $oMsg->parseMsg($rawmsg['msg'],array('valor' => $value));
				$destino = 'mailbody';
			}

			foreach ($aMails as $email => $aMOpt) {
				if (is_array($aOpt['exclude']) AND sizeof($aOpt['exclude']) ) {
					$bSkip = false;
					foreach ($aMOpt['roles'] as $rol) 
						if (in_array($rol,$aOpt['exclude'])) {
							// debug("$rol excluido de $fld .");
							$bSkip = true;
							break;
						}
					if ($bSkip) continue;
				}

				// debug("$fld es aceptable para $email ... en $destino : $msg ");
				$aMails[$email][$destino] .= $msg.$strSep;
			}
		}

		$destino = 'changes';
		// INC_EMAIL_CHGINTRO

		if ($tipo & $this->NOTI_SCALE AND is_array($aEx) AND sizeof($aEx)) {
			$aG = $this->getData('Gestor');
			$rawmsg = $oMsg->rawMsg('INC_EMAIL_CHGMANAGER');
			$msg = $oMsg->parseMsg($rawmsg['msg'],array(
											'anterior' => $aEx['nombre'].' '.$aEx['apellidos'].' ('.$aEx['cargo'].') ', 
											'actual' => $aG['nombre'].' '.$aG['apellidos'].' ('.$aG['cargo'].') '
											) );

			foreach ($aMails as $email => $aMOpt) {
				$bSkip = true;
				// Si encontramos un rol (en la lista de los de este email) al que se le notifiquen escalados, incluimos el mensaje.
				foreach ($aMOpt['roles'] as $rol) 
					if ($this->aTipoNotificacion[$this->NOTI_SCALE][$rol]) {
						$bSkip = false;
						break;
					}
				if ($bSkip) continue;

				// debug("$fld es aceptable para $email ... en $destino : $msg ");
				$aMails[$email][$destino] .= $msg.$strSep;
			}
		}

		if ($tipo & $this->NOTI_COMMENT AND is_object($oCom)) {
			$aComment = $oCom->getData();
			$aUsr = $oCom->getData('Usuarios');
			if (!$aUsr) $aUsr = $oCom->getData('Empleados');
			$aDocs = $oCom->getRelatedDocuments(true);
			
			foreach ($aMails as $email => $aMOpt) {
				$bSkip = true;

				// Si encontramos un rol (en la lista de los de este email) al que se le notifiquen escalados, incluimos el mensaje.
				foreach ($aMOpt['roles'] as $rol) 
					if ($this->aTipoNotificacion[$this->NOTI_COMMENT][$rol]) {
						$bSkip = false;
						break;
					}
				if ($bSkip OR (!$aMOpt['comentarios_publicos'] AND !$aMOpt['comentarios_privados']) ) continue;

				// Si al destino no le va a tocar ningun comentario, no mandamos nada.
				if ($aMOpt['comentarios_publicos'] AND empty($aComment['texto_publico']) )  {
					if ( ($aMOpt['comentarios_privados'] AND empty($aComment['texto_privado'])) OR !$aMOpt['comentarios_privados']) continue;
				} elseif ($aMOpt['comentarios_privados'] AND empty($aComment['texto_privado']) )  {
					if ( ($aMOpt['comentarios_publicos'] AND empty($aComment['texto_publico'])) OR !$aMOpt['comentarios_cpublicos']) continue;
				}

				$rawmsg = $oMsg->rawMsg('INC_EMAIL_NEWCOMMENT');
				$msg = $oMsg->parseMsg($rawmsg['msg'],array('usuario' => $aUsr['nombre'].' '.$aUsr['apellidos'].
									( (!empty($aUsr['cargo'])) ? ' ('.$aUsr['cargo'].') ' : '') , 'fecha' => $aComment['fecha']) );
				$aMails[$email][$destino] .= $msg.$strSep;

				if ($aMOpt['comentarios_publicos'] AND !empty($aComment['texto_publico']) ) {
					$rawmsg = $oMsg->rawMsg('INC_EMAIL_PUBLICTEXT');
					$msg = $oMsg->parseMsg($rawmsg['msg'],array('texto' => $aComment['texto_publico']) );
					$aMails[$email][$destino] .= $strSep.$msg.$strSep;
				}

				if ($aMOpt['comentarios_publicos'] AND !empty($aComment['texto_privado']) ) {
					$rawmsg = $oMsg->rawMsg('INC_EMAIL_PRIVATETEXT');
					$msg = $oMsg->parseMsg($rawmsg['msg'],array('usuario' => $aComment['texto_privado']) );
					$aMails[$email][$destino] .= $strSep.$msg.$strSep;
				}

				if (is_array($aDocs) AND sizeof($aDocs)) {
					$rawmsg = $oMsg->rawMsg('INC_EMAIL_COMMENTDOCS');
					$msg = $oMsg->parseMsg($rawmsg['msg']);
					$aMails[$email][$destino] .= $strSep.$msg.$strSep;

					$aUsuarios = NULL;
					$aEmpleados = NULL;
					foreach ($aDocs as $aD) 
						if (is_a($aD['object'],'CRMDoc')) {
							$aData = $aD['object']->getData();
							$usuario = NULL;
							if (is_numeric($aData['id_usuario'])) {
								if (!empty($aUsuarios[$aData['id_usuario']])) $usuario = $aUsuarios[$aData['id_usuario']];
								else {
									if (is_array($aTmp) AND sizeof($aTmp)) $aUsuarios[$aData['id_usuario']] = $usuario = $aTmp['nombre'].' '.$aTmp['apellidos'];
								}
							} else {
								if (!empty($aUsuarios[$aData['id_empleado']])) $usuario = $aEmpleados[$aData['id_empleado']];
								else {
									$aTmp = $oCom->findUser('id_empleado',$aData['id_empleado']);
									if (is_array($aTmp) AND sizeof($aTmp)) 
										$aEmpleados[$aData['id_empleado']] = $usuario = $aTmp['nombre'].' '.$aTmp['apellidos'].' ('.$aTmp['cargo'].') ';
								}
							}

							$rawmsg = $oMsg->rawMsg('INC_EMAIL_DOCUMENT');
							$msg = $oMsg->parseMsg($rawmsg['msg'],
									array('id' => $aData['id_documento'], 'documento' => $aData['nombre'], 'fecha' => $aData['fecha'], 
										'usuario' => $usuario, 'autor' => $aData['autor'] ) 
									);
							$aMails[$email][$destino] .= $msg.$strSep;
						}
				}
			}
			
		}

		foreach ($aMails as $email => $aMData) {
			// debug("Probando $email .. ");
			if (empty($aMData['changes']) AND !($tipo & $this->NOTI_NEW) ) continue;
			// debug("Mandando cambios a $email : ".$aMData['changes']);
			$mailbody = $aMData['mailbody'].$strSep.$aMData['changes'];
			mail($email,$aMData['mailsubject'],$mailbody,'From: '.$aCfg['email'].'\r\n');
		}

	}

	function cerrar() {
		$this->aStrChanges = NULL;
		return parent::cerrar();
	}

}

class RFQ extends CRMEvent {

	function RFQ ($AppName,$dataconn,$cfgconn,$oUsr) {
		
		$aCampos['RFQs:RFQ'] = array(			
			'id_rfq', 'id_prioridad', 'id_tipo',
			'usuario_empleado', 'id_usuario_apertura', 'id_usuario_implicado', 'id_usuario_gestor',
			'nombre', 'nota_apertura', 'estado',
			'fecha', 'fecha_inicio', 'fecha_estimada', 'fecha_cierre'
			);		
		$aAcciones['id_rfq'] = array('exclude' => array('new' => false, 'edit' => false) );

		return parent::CRMEvent($AppName,$dataconn,$cfgconn,$oUsr,'RFQs',$aCampos,$aAcciones);
	}

	/** Metodos sobre Atributos **/
	function getId() {
		$id = $this->getAttribute('id');
		if (!is_numeric($id)) $id = $this->getAttribute('id_rfq');
		return $id;
	}

	function updateType($val,$fld = NULL) {
		if (!is_numeric($val)) {
			$val = $this->getAttribute('id_tipo');
		}
		$retval = parent::updateType($val,$fld);
		$this->setAttribute('id_tipo',$this->getAttribute('id','Tipo'),NULL,true);
		return $retval;
	}

	function postFill() {
		$retval = parent::postFill();
		if ($retval) {
			$this->setAttribute('id',$this->getAttribute('id_rfq'),NULL,true);
		}
		return $retval;
	}

	function dbDump() {
		$retval = parent::dbDump();
		$this->setAttribute('id',$this->getAttribute('id_rfq'),NULL,true);
		return $retval;
	}

	/** Metodos de flujo y pueble de estructuras **/

	function dbFill($id) {
		// if (!$this->verifyAccess()) return false;
		$oApp = &$this->getApp();
		if (!is_numeric($id)) {
			$oApp->lcMessage('INC_NOID',array('id'=>$id));
			return false;
		}
		return parent::dbFill(array('id_rfq' => $id));
	}

	function getKeyField() {
		return 'id_rfq';
	}

}

?>
