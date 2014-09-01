<?php


function pre_nueva_incidencia(&$Sesion) {
	$incidencia=$Sesion->fetchVar('incidencia','POST');

	$oDb_crm = $Sesion->get_db('crm');
	$oDb_data = $Sesion->get_db('data');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	$aUsr = identifica_usuarios($Sesion);
	if (!is_numeric($aUsr['crm_id_usuario']) AND !is_numeric($aUsr['crm_id_empleado']) AND !strcasecmp($aUsr['desktop_name'],'Clientes') ) {
		$Sesion->lcMessage('CRM_NOVALIDUSER',NULL,IM_FATALERROR);
		return;
	}
	if (is_numeric($aUsr['crm_id_usuario'])) {
		$Sesion->set_var('id_usuario_apertura',$aUsr['crm_id_usuario'],'SUBSECCION');
		$Sesion->set_var('usuario_empleado',0,'SUBSECCION');
		$Sesion->set_var('id_usuario_implicado',$aUsr['crm_id_usuario'],'SUBSECCION');
	} elseif (is_numeric($aUsr['crm_id_empleado'])) {
		$Sesion->set_var('id_usuario_apertura',$aUsr['crm_id_empleado'],'SUBSECCION');
		$Sesion->set_var('usuario_empleado',1,'SUBSECCION');

		$id_usuario_implicado = obtener_implicado_documento($Sesion);
		if (is_numeric($id_usuario_implicado)) $Sesion->set_var('id_usuario_implicado',$id_usuario_implicado,'SUBSECCION');
	} else {
		$Sesion->unset_var('id_usuario_apertura');
		$Sesion->unset_var('id_usuario_implicado');
		$Sesion->set_var('usuario_empleado',1,'SUBSECCION');

		$id_usuario_implicado = obtener_implicado_documento($Sesion);
		if (is_numeric($id_usuario_implicado)) $Sesion->set_var('id_usuario_implicado',$id_usuario_implicado,'SUBSECCION');
	}

	$id_doc = $Sesion->get_var("id_documento");
	if (is_numeric($id_doc)) {
		$Sesion->set_var('target_nueva_incidencia',$Sesion->get_subsecc_name(),'SUBSECCION');
	} else {
		$Sesion->set_var('target_nueva_incidencia',$Sesion->get_old_subsecc_name(),'SUBSECCION');

		$id_usuario_implicado = $Sesion->get_var('id_usuario_implicado');
		if (!is_numeric($id_usuario_implicado)) {
			$id_cl = id_entidad($Sesion,'id_cliente');
			if (is_numeric($id_cl)) {
				$id_usuario_implicado = obtener_implicado_cliente($Sesion,$id_cl);
			} else {
				$id_pr = id_entidad($Sesion,'id_proveedor');
				if (is_numeric($id_pr)) $id_usuario_implicado = obtener_implicado_proveedor($Sesion,$id_pr);
			}
			if (is_numeric($id_usuario_implicado)) $Sesion->set_var('id_usuario_implicado',$id_usuario_implicado,'SUBSECCION');
		} else $Sesion->unset_var('id_usuario_implicado');
	}

	if(isset($incidencia) AND is_array($incidencia) AND sizeof($incidencia)) {
		if ($Sesion->verifyVar('incidencia',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('incidencia',IKRN_VAR_CRC_AUTHED)) {
			// Localizando el usuario gestor de la incidencia (coord del dep del tipo de incid)
			$db_crm_auth = $Sesion->get_db('crmcfg');
			if (!is_object($db_crm_auth)) {
				$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'inmDB :: crm_auth'),IM_FATALERROR);
				return NULL;
			}

			$db_auth = $db_crm_auth->get_dbase_name();
			$oDb = $Sesion->get_db("crm");

			$incidencia['fecha'] = date('Y-m-d H:m:s');

			$oInc = new Incidencia($Sesion->App_Name,'crm','crmcfg',NULL);
			$oInc->update($incidencia);

			$oInc->Dump();
			$incidencia['id_incidencia'] = $oInc->getId();

			$id_doc = $Sesion->get_var("id_documento");
			if (is_numeric($id_doc)) {
				$tb_link = $Sesion->get_var("CRM_db_table");
				$fld = $Sesion->get_var("CRM_db_field");
				$aLink['id_incidencia'] = $incidencia['id_incidencia'];
				$aLink[$fld] = $id_doc;
				$oDb_data->tb_replace($tb_link,$aLink);
			}

		}
		
		$aPlt_ok = $Sesion->get_plt_array("incidencia_ok");
		$Sesion->change_plt("bo_seccion",$aPlt_ok[1]);
		return $aPlt_ok[1];
	} else crm_determinar_documento($Sesion);
}

function pre_asociar_incidencia(&$Sesion) {
	$incidencia=$Sesion->fetchVar('incidencia','POST');
	$selecciones=$Sesion->fetchVar('selecciones','POST');
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');

	$modosel = $Sesion->fetchVar('modo_seleccion','GET SESSION');
	$Sesion->set_var('modo_seleccion',(int)$modosel,'SUBSECCION');

	$oDb_crm = $Sesion->get_db('crm');
	if (!is_object($oDb_crm)) enlazar_crm($Sesion);

	if (isset($incidencia) AND !is_array($incidencia) AND !sizeof($incidencia)) {
		crm_determinar_documento(&$Sesion);
		$aUsr = identifica_usuarios($Sesion);
		if (is_array($aUsr) AND sizeof($aUsr)) {
			if (is_numeric($aUsr['crm_id_usuario']) OR is_numeric($aUsr['crm_id_empleado'])) {
				if (!strcasecmp($aUsr['desktop_name'],'Clientes')) {
					$id_usuario_implicado = $aUsr['crm_id_usuario'];
				}
			}

			if (!is_numeric($id_usuario_implicado)) $id_usuario_implicado = obtener_implicado_documento($Sesion);
			if (is_numeric($id_usuario_implicado)) $Sesion->set_var('id_usuario_implicado',$id_usuario_implicado,'SUBSECCION');
			else $Sesion->unset_var('id_usuario_implicado');
		}
	}

	switch ($accion) {
		case 'Nuevo':
			$oInc = new Incidencia($Sesion->App_Name,'crm','crmcfg',NULL);
			$oInc->update($incidencia);
			$oInc->Dump();
			break;

		case 'Aprobar':
			if (is_array($selecciones) AND sizeof($selecciones)) 
				foreach ($selecciones as $id_inc) {
					$oInc = new Incidencia($Sesion->App_Name,'crm','crmcfg',NULL);
					if ($oInc->dbFill($id_inc)) {
						$oInc->setStatus($oInc->EV_STARTED);
						$oInc->Dump();
					}
					$oInc = NULL;
				}
			break;
	}

}

function obtener_implicado_documento(&$Sesion) {
	crm_determinar_documento($Sesion);
	$oDb_data = $Sesion->get_db('data');
	$id_doc = $Sesion->get_var("id_documento");
	$fld = $Sesion->get_var('CRM_db_field');
	$retval = NULL;
	switch ($fld) {
		case 'id_pedido' :
			$cons = 'SELECT C.id_cliente,IF(C.id_cliente,C.crm_id_usuario,Pr.crm_id_usuario) as "crm_id_usuario" ,Pr.id_proveedor '.
						'FROM Pedidos P LEFT JOIN Direcciones_entrega D ON (P.id_direccion=D.id_direccion) '.
						'LEFT JOIN Clientes_empresas C ON (D.id_cliente=C.id_cliente AND P.id_empresa=C.id_empresa) '.
						'LEFT JOIN Proveedores_empresas Pr ON (P.id_proveedor=Pr.id_proveedor AND Pr.id_empresa=P.id_empresa) '.
						'WHERE P.id_pedido = '.$id_doc;
			break;

		case 'id_factura' :
			$cons = 'SELECT C.id_cliente,IF(C.id_cliente,C.crm_id_usuario,Pr.crm_id_usuario) as "crm_id_usuario" ,Pr.id_proveedor '.
						'FROM Facturas F LEFT JOIN Clientes_empresas C ON (F.id_cliente=C.id_cliente AND F.id_empresa=C.id_empresa) '.
						'LEFT JOIN Proveedores_empresas Pr ON (F.id_proveedor=Pr.id_proveedor AND Pr.id_empresa=F.id_empresa) '.
						'WHERE F.id_factura = '.$id_doc;
			break;

		case 'id_albaran' :
			$cons = 'SELECT C.id_cliente,IF(C.id_cliente,C.crm_id_usuario,Pr.crm_id_usuario) as "crm_id_usuario" ,Pr.id_proveedor '.
						'FROM Albaranes A, Pedidos P LEFT JOIN Direcciones_entrega D ON (P.id_direccion=D.id_direccion) '.
						'LEFT JOIN Clientes_empresas C ON (D.id_cliente=C.id_cliente AND P.id_empresa=C.id_empresa) '.
						'LEFT JOIN Proveedores_empresas Pr ON (P.id_proveedor=Pr.id_proveedor AND Pr.id_empresa=P.id_empresa) '.
						'WHERE P.id_pedido = A.id_pedido AND A.id_albaran = '.$id_doc;
			break;

		case 'id_cita' :
			$cons = 'SELECT C.id_cliente,C.crm_id_usuario as "crm_id_usuario" '.
						'FROM Citas Ct LEFT JOIN Clientes_empresas C ON (Ct.id_cliente=C.id_cliente) '.
						'WHERE Ct.id_cita = '.$id_doc;
			break;

		default:
			$cons = NULL;
			break;
	}
	if (!empty($cons)) {
		$pedrs = $oDb_data->query($cons);
		if ($oDb_data->num_rows($pedrs)) {
			$aPed = $oDb_data->fetch_assoc($pedrs);
			if (is_numeric($aPed['crm_id_usuario'])) $retval =$aPed['crm_id_usuario'];
		}
	} 
	return $retval;
}

function obtener_implicado_cliente(&$Sesion,$id_cli = NULL) {
	$oDb_data = $Sesion->get_db('data');
	if (!is_numeric($id_cli)) $id_cli = id_entidad($Sesion,'id_cliente');
	if (!is_numeric($id_cli)) return NULL;
	$id_empresa = $Sesion->get_var('id_empresa');
	if (!is_numeric($id_empresa)) return NULL;
	$oDb_data = $Sesion->get_db('data');

	$retval = NULL;
	$cons = 'SELECT C.id_cliente,C.crm_id_usuario as "crm_id_usuario" '.
				'FROM Clientes_empresas C '.
				'WHERE C.id_cliente = '.$id_cli.' AND C.id_empresa = '.$id_empresa;

	if (!empty($cons)) {
		$pedrs = $oDb_data->query($cons);
		if ($oDb_data->num_rows($pedrs)) {
			$aPed = $oDb_data->fetch_assoc($pedrs);
			if (is_numeric($aPed['crm_id_usuario'])) $retval =$aPed['crm_id_usuario'];
		}
	} 
	return $retval;
}

function pre_asociar_usuario(&$Sesion) {
	$id = $Sesion->fetchVar('id','GET');

	if (is_numeric($id)) $Sesion->set_var('usuario_actual',$id,'SUBSECCION');
}

function selected_document(&$Sesion,$aParam) {
	static $aDocList;

	if (!is_array($aParam) OR !sizeof($aParam)) return NULL;

	$id = $Sesion->fetchVar('id_presupuesto','GET');
	if (!is_numeric($id)) $id = $Sesion->get_var('id_presupuesto');
	else $Sesion->set_var('id_presupuesto',$id,'SUBSECCION');

	$iddoc = array_shift($aParam);

	if (!is_array($aDocList)) $aDocList = $Sesion->get_var('_aDocList');

	if (is_numeric($id) AND !is_array($aDocList)) {
		$cons = 'SELECT id_documento FROM Presupuestos_Documentos_CRM WHERE id_presupuesto = '.$id;
		$oDb = $Sesion->get_db('data');
		$rs = $oDb->query($cons);
		$aDocList = array();
		while ($aTmp = $oDb->fetch_assoc($rs)) {
			if (!in_array($aTmp['id_documento'],$aDocList)) array_push($aDocList,$aTmp['id_documento']);
		}
		if (is_array($aDocList) AND sizeof($aDocList)) $Sesion->set_var('_aDocList',$aDocList,'SUBSECCION');
	}

	if (is_array($aDocList) AND sizeof($aDocList) AND is_numeric($iddoc)) 
		return ( (in_array($iddoc,$aDocList)) ? 'checked="checked"' : NULL);
}

function pre_download(&$Sesion) {
	$id = $Sesion->fetchVar('id','GET');

	if (!is_numeric($id)) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Documentos'));
		return;
	}
	$oDoc = new CRMDoc($Sesion->App_Name,'crm','crmcfg',NULL);
	if (!$oDoc->dbFill($id)) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Documentos', 'id' => $id));
		return;
	}

	$aDoc = $oDoc->getData();
	if (empty($aDoc['path']) OR !is_dir($aDoc['path']) ) {
		$Sesion->lcMessage('DOC_PATH_NOTFOUND',array('path' => $aDoc['path']));
		return;
	}

	$filename = $aDoc['path'].'/'.$aDoc['file_name'];
	if (empty($aDoc['file_name']) OR !is_file($filename) ) {
		$Sesion->lcMessage('DOC_FILE_NOTFOUND',array('file' => $aDoc['file_name']));
		return;
	}

	$filemime = mime_content_type($filename);
	if (empty($filemime)) {
		$Sesion->lcMessage('DOC_MIME_NOTFOUND',array('mime' => $filemime));
		return;
	}

	header("Cache-control: private");
	header("Content-Type: " . $filemime);
	// header("Content-Disposition: filename=CV1019587517.pdf");
	header("Content-Disposition: attachment; filename=".$aDoc['file_name']);

	readfile($filename);
}

function cf_presupuesto(&$Sesion,&$aData) {
	// print_r($aData);
	$estado = $aData['Presupuestos.estado'];
	switch ($estado) {
		case -1:
			$Sesion->set_var('icono_estado',$Sesion->get_var('bad'),'INMED');
			break;

		case 0:
			$Sesion->set_var('icono_estado',$Sesion->get_var('none'),'INMED');
			break;

		case 1:
			$Sesion->set_var('icono_estado',$Sesion->get_var('do'),'INMED');
			break;

		case 2:
			$oDb = $Sesion->get_db('data');
			$tmprs = $oDb->query('SELECT id_pedido FROM Pedidos WHERE id_presupuesto = '.$aData['Presupuestos.id_presupuesto']);
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_assoc($tmprs);
				$Sesion->set_var('pedido_de_presupuesto',$aTmp['id_pedido'],'INMED');
			} else $Sesion->set_var('icono_estado',$Sesion->get_var('ok'),'INMED');
			break;
	}
	return true;
}

function pre_rfq_cliente(&$Sesion) {

	$nuevo = $Sesion->fetchVar('nuevo','GET');
	$id = $Sesion->fetchVar('id','GET');
	$accion_ejecutar = $Sesion->fetchVar('accion_ejecutar','POST');
	$aRfq = $Sesion->fetchVar('rfq','POST');
	$aSelDocs = $Sesion->fetchVar('selecciones','POST');
	$aDocumentos = $Sesion->fetchVar('documento','POST');

	$docvar = 'oPresupuesto_rfq';

	$link = $Sesion->get_var('LinkCRM');
	if (empty($link)) {
		$Sesion->lcMessage('CRM_NOCRM',NULL,IM_FATALERROR);
		return;
	}
	
	$id_empresa = $Sesion->get_var('id_empresa');
	$aUsr = identifica_usuarios($Sesion);

	switch ($aUsr['desktop_name']) {
		case 'Clientes':
			if (empty($aUsr['crm_id_usuario'])) {
				$Sesion->lcMessage('CRM_NOCLIENTUSER',array('cliente' => $aUsr['nombre_usuario']),IM_FATALERROR);
				$Sesion->perror_link('BACK');
				return;
			}
			$id_usuario_apertura = $aUsr['crm_id_usuario'];
			$id_usuario_implicado = $aUsr['crm_id_usuario'];
			$id_cliente = $aUsr['valor'];
			$usuario_empleado = 0;
			$Sesion->set_var('grupodocs_interno',1);
			break;

		default:
			$id_cliente = id_entidad($Sesion,'id_cliente');
			if (!is_numeric($id_cliente)) {
				$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Clientes') );
				$Sesion->perror_link('?seccion=clientes');
				return;
			}

			if (!is_numeric($aUsr['crm_id_empleado']) AND !is_numeric($aUsr['crm_id_usuario'])) {
				$Sesion->lcMessage('CRM_NOVALIDUSER',NULL,IM_FATALERROR);
				$Sesion->perror_link('?seccion=modif_clientes');
				return;
			} else {
				if (is_numeric($aUsr['crm_id_empleado'])) {
					$id_usuario_apertura = $aUsr['crm_id_empleado'];
					$usuario_empleado = 1;
				} else {
					$id_usuario_apertura = $aUsr['crm_id_usuario'];
					$usuario_empleado = 0;
				}
			}

			$aCliCRM = array();
			if (!is_numeric($aCliCRM[$id_cliente]) OR empty($aCliCRM[$id_cliente]) ) {
				$oDb = $Sesion->get_db('data');
				$cons = 'SELECT C.razon_social,Ce.crm_id_usuario FROM Clientes_empresas Ce, Clientes C '.
							'WHERE C.id_cliente=Ce.id_cliente AND Ce.id_empresa = '.$id_empresa.' AND Ce.id_cliente = '.$id_cliente;
				$clrs = $oDb->query($cons);
				if ($oDb->num_rows($clrs)) {
					$aTmp = $oDb->fetch_assoc($clrs);
					$nombrecli = $aTmp['razon_social'];
					$aCliCRM[$id_cliente] = (int)$aTmp['crm_id_usuario'];
				} else $aCliCRM[$id_cliente] = 0;
			}
				
			if (empty($aCliCRM[$id_cliente])) {
				$Sesion->lcMessage('CRM_NOCLIENTUSER',array('cliente' => $nombrecli),IM_FATALERROR);
				$Sesion->perror_link('?seccion=modif_clientes');
				return;
			} else $id_usuario_implicado = $aCliCRM[$id_cliente];

			$Sesion->set_var('grupodocs_interno',1);
	}

	$oRFQ = $Sesion->get_var('oRFQ_actual');
	if ((int)$nuevo) {
		$oRFQ = NULL;
		$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
		$oRFQ->update(array('usuario_empleado'=>$usuario_empleado,'id_usuario_apertura'=>$id_usuario_apertura,'id_usuario_implicado'=>$id_usuario_implicado));
		$Sesion->unset_var($docvar);
	} else {
		if (!is_object($oRFQ) OR !is_a($oRFQ,'RFQ') OR (is_numeric($id) ANd $id!=$oRFQ->getId()) ) {
			$oRFQ = NULL;
			$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
			if (!$oRFQ->dbFill($id)) {
				$oRFQ = NULL;
			} else $Sesion->unset_var($docvar);
		}
	}

	if (!is_object($oRFQ) OR !is_a($oRFQ,'RFQ')) {
		$Sesion->lcMessage('INC_NOID',array('id' => $id),IM_FATALERROR);
		$Sesion->perror_link('BACK');
		return;
	}

	// debug("acc: $accion_ejecutar");
	switch ($accion_ejecutar) {
		case 'Modificar':
			if (is_array($aRfq) AND sizeof($aRfq)) {
				$oRFQ->update($aRfq);
				$oRFQ->Dump();
			}
			break;

		case 'NuevoDocumento':
			if (is_array($aDocumentos) AND sizeof($aDocumentos) AND is_numeric($aDocumentos['id_agrupacion_documentos']) AND is_a($oRFQ,'RFQ') ) {
				if (is_array($_FILES['document_file']) AND sizeof($_FILES['document_file']) AND is_uploaded_file($_FILES['document_file']['tmp_name'])) {
					$bDo = true;
					$oCom = &$oRFQ->getComments();
					for ($idx = $oCom->firstItem(); isset($idx); $idx = $oCom->nextItem()) {
						if (!is_numeric($old_idx) AND $idx > $idx_first) {
							$bDo = false;
							break;
						} elseif ($idx > ($old_idx +1) ) {
							$bDo = false;
							break;
						}
						$oItem = &$oCom->getItem();
						$aDocs = $oItem->getRelatedDocuments();
						if (is_array($aDocs) AND sizeof($aDocs)) {
							$old_idx = $idx;
						}
					}

					if ($bDo) {
						$aDoc['id_agrupacion_documentos'] = $aDocumentos['id_agrupacion_documentos'];
						if (empty($aDocumentos['nombre'])) $aDoc['nombre'] = $_FILES['document_file']['name'];
						else $aDoc['nombre'] = $aDocumentos['nombre'];
						if ($usuario_empleado) $aDoc['id_empleado'] = $id_usuario_apertura;
						else $aDoc['id_usuario'] = $id_usuario_apertura;
					
						$oDoc = new CRMDoc($Sesion->App_Name,'crm','crmcfg',NULL);
						$oDoc->edit($aDoc);
						$oDoc->uploadFile($_FILES['document_file']);
						if ($oDoc->dbDump()) {
							if (is_numeric($aDoc['id_usuario'])) $aComm['id_usuario'] = $aDoc['id_usuario'];
							else $aComm['id_empleado'] = $aDoc['id_empleado'];
							$aComm['texto_publico'] = $aDoc['sinopsis'];
							$idx = $oRFQ->newComment($aComm);
							if (is_numeric($idx) AND !$oRFQ->attachDocument($idx,$oDoc)) {
								$oRFQ->delComment($idx);
								$oDoc->delete();
								$oDoc->dbDump();
							}
							$oRFQ->Dump();
						} else {
							// FixMe: Comprobar que borrara fisicamente el documento.
							$oDoc->delete();
						}
					} else debug("_not_ done");
				}
			}
			break;

		case 'ModificarDocumentos':
			if (is_a($oRFQ,'RFQ')) {
				$oComs = &$oRFQ->getComments();
				if (is_array($aDocumentos) AND sizeof($aDocumentos) AND is_numeric($aDocumentos['id_agrupacion_documentos']) ) 
					foreach ($aDocumentos as $idx => $aDoc) 
						if (is_numeric($idx) AND is_array($aDoc) AND sizeof($aDoc) ){
							$oItem = &$oComs->getItem($idx);
							if (!is_a($oItem,'CRMComment')) continue;
							$aTmp['texto_publico'] = $aDoc['nota'];
							$oItem->update($aTmp);
						}
				$oRFQ->Dump();
			}
			break;

		case 'BorrarDocumentos':
			if (is_a($oRFQ,'RFQ')) {
				if (is_array($aDocumentos) AND sizeof($aDocumentos) AND is_numeric($aDocumentos['id_agrupacion_documentos']) ) 
					foreach ($aDocumentos as $idx => $aDoc) 
						if (is_numeric($aDoc['id_documento']) AND is_numeric($idx) ) {
							$oRFQ->delComment($idx);
						}
				$oRFQ->Dump();
			}
			break;

		case 'Seleccion_documentos_crm':
			if (is_array($aSelDocs) AND sizeof($aSelDocs)) {
				$oCom = &$oRFQ->getComments();
				$bDo = true;
				for ($idx = $oCom->firstItem(); isset($idx); $idx = $oCom->nextItem()) {
					if (!is_numeric($old_idx) AND $idx > $idx_first) {
						$bDo = false;
						break;
					} elseif ($idx > ($old_idx +1) ) {
						$bDo = false;
						break;
					}
					$oItem = &$oCom->getItem();
					$aDocs = $oItem->getRelatedDocuments();
					if (is_array($aDocs) AND sizeof($aDocs)) {
						$old_idx = $idx;
					}
				}
				if ($bDo) {
					foreach ($aSelDocs as $iddoc) {
						$comment['documento_publico'] = 0;
						if ($usuario_empleado) $comment['id_empleado'] = $id_usuario_apertura;
						else $comment['id_usuario'] = $id_usuario_apertura;
						$idx = $oRFQ->newComment($comment);
						if (is_numeric($idx)) {
							if (!$oRFQ->attachDocument($idx,$iddoc)) {
								$oRFQ->delComment($idx);
							}
						}
					}
					$oRFQ->Dump();
				} else debug("_not_ done");
			}
			break;
	}

	// Caso de nuevo, se usaran estos tiposde incidencia/eveto (rfq)
	$Sesion->set_var('crm_tipo_nuevo_evento',1,'SUBSECCION');

	if (is_object($oRFQ)) {
		$id_rfq = $oRFQ->getId();
		$Sesion->set_var('id_rfq_actual',$id_rfq,'SUBSECCION');
		$Sesion->set_var('oRFQ_actual',$oRFQ);
		$Sesion->set_var('__dbItemMultiEntity_varname','oRFQ_actual','SUBSECCION');
	}

	// Buscando el presupuesto 
	$oPre = $Sesion->get_var($docvar);
	if (!is_object($oPre) OR !is_a($oPre,'Budget')) {
		$id_rfq = $oRFQ->getId();
		if (is_numeric($id_rfq)) {
			$oDb = $Sesion->get_db('data');
			// debug("Buscando presupuesto. para rfq $id_rfq ");
			$cons = 'SELECT id_presupuesto FROM Presupuestos WHERE (estado = 0 OR estado = 1) AND id_rfq = '.$id_rfq.' LIMIT 1';
			$rs = $oDb->query($cons);
			if ($oDb->num_rows($rs)) {
				$aTmp = $oDb->fetch_assoc($rs);
				$id_presupuesto = $aTmp['id_presupuesto'];
			} 
			$oPre = new Budget($Sesion->App_Name,'data',inmPed_VENTA);
			if (is_numeric($id_presupuesto)) {
				$oPre->dbFill($id_presupuesto);
			} else {
				$oPre->set_issuer($id_empresa);
				$oPre->set_reciever($id_cliente);
			}
		}
	} 

	$accioncesta = $Sesion->fetchVar('Finalizar','POST');
	$servicios = $Sesion->fetchVar('servicios','POST');
	$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');	//array de checkboxes con los ke keremos konfirmar
	$articulos_cesta=$Sesion->fetchVar('articulos_cesta','POST');			//array de hidden que habia en la cesta (para no borrar los k entran por promo)
	$array_bultos=$Sesion->fetchVar('array_bultos','POST');
	$array_numero=$Sesion->fetchVar('array_numero','POST');

	if (empty($accioncesta)) $accioncesta = $accion_ejecutar;

	// debug("cesta $accioncesta ");
	switch($accioncesta) {
		case 'Finalizar':
			for ($idxdet = $oPre->first_detail(); isset($idxdet); $idxdet = $oPre->next_detail()) {
				if (!isset($articulos_cesta[$idxdet])) continue;
				if (!isset($articulos_confirmados[$idxdet])) {
					$oPre->del_detail($idxdet);
					continue;
				} elseif (is_numeric($array_bultos[$idxdet]['palets']) AND is_array($array_bultos) ) {
					$oPre->set_quantity($idxdet,$array_numero[$idxdet],3);
				} elseif (is_numeric($array_bultos[$idxdet]['capas']) AND is_array($array_bultos) ) {
					$oPre->set_quantity($idxdet,$array_numero[$idxdet],2);
				} elseif (is_numeric($array_bultos[$idxdet]['bultos']) AND is_array($array_bultos) ) {
					$oPre->set_quantity($idxdet,$array_numero[$idxdet],1);
				} else {
					$oPre->set_quantity($idxdet,$array_numero[$idxdet],0);
				} 

				if ( method_exists($oPre,'set_detail_contract') AND is_numeric($servicios[$idxdet]) ) {
					$aServ = $oPre->get_detail_contract($idxdet);
					if (is_array($aServ) AND sizeof($aServ)) {
						if (is_numeric($servicios[$idxdet]) AND $servicios[$idxdet]!=$aServ['id']) $oPre->set_detail_contract($idxdet,$servicios[$idxdet]);
						elseif (!$servicios[$idxdet]) {
							$oPre->unset_detail_contract($idxdet);
						}
					} elseif (is_numeric($servicios[$idxdet])) { 
						$oPre->set_detail_contract($idxdet,$servicios[$idxdet]);
					}
				}

			}
			break;

		case 'BorrarDetalle':
			if (is_array($articulos_confirmados) AND sizeof($articulos_confirmados))
				foreach ($articulos_confirmados as $idxdet => $bool) {
					if ((int)$bool) {
						$oPre->del_detail($idxdet);
					}
				}
			break;

		case 'ModificarPresupuesto':
			if (is_a($oPre,'Budget') AND is_numeric($id_rfq) ) {
				$oPre->setHeaderAttribute('id_rfq',$id_rfq);
				$oPre->calculate();
				$oPre->dbDump();
			}
			break;
	}

	if (!empty($docvar) AND is_a($oPre,'Budget')) {
		$Sesion->set_var('__document_iface_varname',$docvar);
		$Sesion->set_var($docvar,$oPre);
	}

	return;
}

function pre_rfqs_cliente(&$Sesion) {
	$modosel = $Sesion->fetchVar('modo_seleccion','GET');
	if (!is_numeric($modosel)) $modosel = $Sesion->get_var('modo_seleccion');
	$Sesion->set_var('modo_seleccion',(int)$modosel,'SUBSECCION');
}


?>
