<?php

function pre_incidencias_documento(&$Sesion) {
	$borrar_incidencias=$Sesion->fetchVar('borrar_incidencias','POST');

	$oDb_crm = &$Sesion->get_db('db_crm');
	if (!is_object($oDb_crm)) enlazar_crm(&$Sesion);

	crm_determinar_documento($Sesion);
	$oDb_data = $Sesion->get_db('data');

	if (isset($borrar_incidencias) AND is_array($borrar_incidencias) AND sizeof($borrar_incidencias))
		foreach ($borrar_incidencias as $id_inc => $bool) 
			if ((int)$bool) {
				$tb_link = $Sesion->get_var("CRM_db_table");
				$id_doc = $Sesion->get_var("id_documento");
				$fld = $Sesion->get_var("CRM_db_field");
				$aLink['id_incidencia'] = $id_inc;
				$aLink[$fld] = $id_doc;
				$oDb_data->tb_delete($tb_link,$aLink);
			}

}

function enlazar_crm(&$Sesion) {
	$id_doc = $Sesion->get_var("id_documento");

	$db_crm = &$Sesion->get_db('crm',true,true);
	if (is_object($db_crm)) {
		$oDb = &$Sesion->get_db('crm');
		$oDbCfg = &$Sesion->get_db('crmcfg');
		if (!is_object($oDb) OR !is_a($oDb,'wol_db') OR !is_object($oDbCfg) OR !is_a($oDbCfg,'wol_db')) {
			$Sesion->unset_var('LinkCRM');
		} else {
			$db_conf = &$Sesion->get_db('conf');
			$LinkCRM = $db_conf->read_main_value('crm_link');
			if (empty($LinkCRM)) $Sesion->unset_var('LinkCRM');
			else $Sesion->set_var("LinkCRM",$LinkCRM,"NOEXPIRE");
		}
	}
}

function crm_determinar_documento(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$id_factura=$Sesion->fetchVar('id_factura','GET');
	$id_albaran=$Sesion->fetchVar('id_albaran','GET');
	$id_cita=$Sesion->fetchVar('id_cita','GET');

	if(isset($id_factura) AND is_numeric($id_factura)) {
		$bk_link = $Sesion->get_old_subsecc_querystring();
		$Sesion->set_var("CRM_db_table","Facturas_Incidencias_CRM","SUBSECCION");
		$Sesion->set_var("id_documento",$id_factura,"SUBSECCION");
		$Sesion->set_var("CRM_db_field","id_factura","SUBSECCION");
		$Sesion->set_var('link_volver',$bk_link,'NOEXPIRE');
	} elseif (isset($id_albaran) AND is_numeric($id_albaran)) {
		$bk_link = $Sesion->get_old_subsecc_querystring();
		$Sesion->set_var("CRM_db_table","Albaranes_Incidencias_CRM","SUBSECCION");
		$Sesion->set_var("id_documento",$id_albaran,"SUBSECCION");
		$Sesion->set_var("CRM_db_field","id_albaran","SUBSECCION");
		$Sesion->set_var("link_volver",$bk_link,"NOEXPIRE");
	} elseif (isset($id_pedido) AND is_numeric($id_pedido)) {
		$bk_link = $Sesion->get_old_subsecc_querystring();
		$Sesion->set_var("CRM_db_table","Pedidos_Incidencias_CRM","SUBSECCION");
		$Sesion->set_var("id_documento",$id_pedido,"SUBSECCION");
		$Sesion->set_var("CRM_db_field","id_pedido","SUBSECCION");
		$Sesion->unset_var('link_volver');
		$Sesion->set_var("link_volver",$bk_link,"NOEXPIRE");
	} elseif (isset($id_cita) AND is_numeric($id_cita)) {
		$bk_link = $Sesion->get_old_subsecc_querystring();
		$Sesion->set_var("CRM_db_table","Citas_Incidencias_CRM","SUBSECCION");
		$Sesion->set_var("id_documento",$id_cita,"SUBSECCION");
		$Sesion->set_var("CRM_db_field","id_cita","SUBSECCION");
		$Sesion->set_var('link_volver',$bk_link,'NOEXPIRE');
	} 

}

function luz_estado_incidencia(&$Sesion,$Params) {
	$estado = array_shift($Params);
	return $Params[$estado];
}

function modificar_incidencia(&$Sesion) {

	$id_incidencia = $Sesion->fetchVar('id_incidencia','GET');
	if (!is_numeric($id_incidencia)) $id_incidencia = $Sesion->fetchVar('id','GET');

	$incidencia = $Sesion->fetchVar('incidencia','POST');
	$comentario = $Sesion->fetchVar('comentario','POST');
	$old_id_gestor = $Sesion->fetchVar('old_id_gestor','POST');
	$accion_ejecutar = $Sesion->fetchVar('accion_ejecutar','POST');

	if(isset($id_incidencia)) {
		$accion_ejecutar = NULL;
		$Sesion->set_var("id_incidencia",$id_incidencia,"SUBSECCION");
		$Sesion->set_var("id",$id_incidencia,"SUBSECCION");
	} elseif ((int)$incidencia['id_incidencia']) {
		$Sesion->set_var("id_incidencia",$incidencia['id_incidencia'],"SUBSECCION");
		$Sesion->set_var("id",$incidencia['id_incidencia'],"SUBSECCION");
		$id_incidencia = $incidencia['id_incidencia'];
	} elseif (strcasecmp($accion_ejecutar,'Nuevo')) {
		$id_incidencia = $Sesion->get_var('id_incidencia');
	}

	// La obtencion del usuario, logicamente, es distinta desde la gestion:
	$usuario=identifica_usuarios($Sesion);
	$id_usuario = $usuario['crm_id_usuario'];
	// $Sesion->set_var('comentarios_publicos',$usuario['emite_comentarios_publicos']);

	$oDb = $Sesion->get_db('crm');
	if (!is_object($oDb)) $oDb=$Sesion->get_db('data');

	if (!strcasecmp($usuario['desk_name'],'Gerente')) {
		$Sesion->set_var("id_usr",$usuario['id_usr'],"INMED");
		$Sesion->set_var("es_gerente",1,"INMED");

		$dbconf = $Sesion->get_db('conf');
		$cons = 'SELECT G.mascara FROM Groups G, Users U '.
					'WHERE U.av_group & G.mascara AND G.nombre like "%oordi%" ';
		$maskrs = $dbconf->query($cons);
		if (!$dbconf->num_rows($maskrs)) {
			$mask = $usuario['group_mask'];
			$Sesion->set_var("coordinador_mask",$mask,"SUBSECCION");
		} else {
			$aTmp = $dbconf->fetch_row($maskrs);
			$Sesion->set_var("coordinador_mask",$aTmp[0],"SUBSECCION");
		}
		$dbconf->libera($maskrs);

		// debug("idinc: $id_incidencia");
		// debug("mask : ".$Sesion->get_var('coordinador_mask'));
		$id_depto = $usuario['id_departamento'];
		if (is_numeric($id_incidencia) AND !empty($id_incidencia)) {
			$cons = "SELECT D.id_departamento,D.id_coordinador,C.id_usr, C.nombre ".
						"FROM Tipo_incidencia Ti, Incidencias I, Departamentos D, Empleados C ".
						"WHERE I.id_tipo_incidencia = Ti.id_tipo_incidencia AND Ti.id_departamento=D.id_departamento ".
						"AND D.id_coordinador = C.id_empleado AND I.id_incidencia = ".$id_incidencia;
			$tmprs = $oDb->query($cons);
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_assoc($tmprs);
				$Sesion->set_var("id_coordinador",$aTmp['id_coordinador'],"SUBSECCION");
			} else {
				$Sesion->perror(NULL,'Departamento','BBDD Corrupta, no se pudo obtener el Departamento');
				return $Sesion->perror_plt('?seccion=listado_incidencias');
			}
			$oDb->libera($tmprs);
		} else {
			if (is_numeric($id_depto) AND !empty($id_depto)) {
				$cons = "SELECT D.id_departamento,D.id_coordinador,C.id_usr, C.nombre ".
							"FROM Departamentos D, Empleados C ".
							"WHERE D.id_coordinador = C.id_empleado AND D.id_departamento = ".$id_depto;
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					$aTmp = $oDb->fetch_assoc($tmprs);
					$Sesion->set_var("id_coordinador",$aTmp['id_coordinador'],"SUBSECCION");
				} else {
					$Sesion->set_var("id_departamento",$id_depto,"SUBSECCION");
					// $Sesion->set_var('id_departamento',$aTmp[2],'INMED');
				}
				$oDb->libera($tmprs);
			}
		}
		$id_empleado = $usuario['id_empleado'];
	} if (!strcasecmp($usuario['desk_name'],"Coordinador")) {
		$Sesion->set_var("coordinador_mask",$usuario['group_mask'],"SUBSECCION");
		$Sesion->set_var("id_coordinador",$usuario['id_empleado'],"SUBSECCION");
		$id_empleado = $usuario['id_empleado'];
	} elseif (!strcasecmp($usuario['desk_name'],"Empleado")) {
		$id_empleado = $usuario['id_empleado'];
	}

	$tipo_notif = 0;
	switch($accion_ejecutar){
		case "Nuevo" :

			if ($Sesion->verifyVar('incidencia',IKRN_VAR_CRC_CHANGE)) {
				debug("IN");
				if ((int)$id_empleado) {
					$incidencia['id_usuario_apertura'] = $id_empleado;
					$incidencia['usuario_empleado'] = 1;
				} else {
					$incidencia['id_usuario_apertura'] = $id_usuario;
					$incidencia['usuario_empleado'] = 0;
				}
				if (!(int)$incidencia['id_usuario_gestor'] OR !(int)$incidencia['id_prioridad']) {
					if (!(int)$incidencia['id_tipo_incidencia']) return NULL;
					/** Fixme:
					  * 	En proximas versiones, este primer if habra que quitarlo. 
					  *	para que las incidencias ajenas al dto del usr de apertura se asignent al coordinador del dto del tipo.
					  */
					if (is_numeric($id_empleado)) {
						$incidencia['id_usuario_gestor'] = $id_empleado;
					} else {
						$cons = "SELECT t1.id_coordinador,t2.id_prioridad_defecto,t1.id_departamento ".
									"FROM Departamentos t1, Tipo_incidencia t2 ".
									"WHERE t1.id_departamento=t2.id_departamento AND t2.id_tipo_incidencia = $incidencia[id_tipo_incidencia]";
						$rs = $oDb->query($cons);
						if (!$oDb->num_rows($rs)) {
							return NULL;
						} else {
							$aTmp = $oDb->fetch_row($rs);
							if (!(int)$incidencia['id_usuario_gestor'] AND !empty($aTmp[0]) AND ($usuario['id_departamento']!=$aTmp[2] OR empty($id_empleado)) ) 
									$incidencia['id_usuario_gestor'] = $aTmp[0];
							elseif (!(int)$incidencia['id_usuario_gestor'])
									$incidencia['id_usuario_gestor'] = $id_empleado;
							if (!(int)$incidencia['id_prioridad']) $incidencia['id_prioridad'] = $aTmp[1];
						}
					}
				}

	debug("inc: ");
	print_r($incidencia);

				$incidencia["fecha"] = date ("Y/m/d G:i");
				if (!$oDb->tb_replace("Incidencias",$incidencia))
						 aviso("error al introducir en la base de datos");

				$id_incidencia = $id_in = $oDb->last_insert_id();
				$Sesion->set_var("id_incidencia",$id_in,"SUBSECCION");
				debug("id_inc: ".$id_in);
				$tipo_notif |= NOTI_NEW;
			}
			break;

		case "Anyadir" :
			if ($Sesion->verifyVar('incidencia',IKRN_VAR_CRC_CHANGE)) {
				
				if (is_numeric($incidencia['id_usuario_gestor']) AND $old_id_gestor != $incidencia['id_usuario_gestor']) {
					$tipo_notif |= NOTI_SCALE;
				} elseif (!is_numeric($incidencia['id_usuario_gestor'])) {
					// debug("Aqhi... solo 1 caso");
					$incidencia['id_usuario_gestor'] = NULL;
					unset($incidencia['id_usuario_gestor']);
				}

				if (is_array($incidencia) AND (int)$incidencia['id_incidencia']) {
					$oDb->tb_update("Incidencias",$incidencia);
					// $tipo_notif |= NOTI_EDIT;
				} // else return NULL;
			}

			if ((int)$id_empleado) {
				$comentario['id_empleado'] = $id_empleado;
				$comentario['id_usuario'] = 0;
			} else {
				$comentario['id_usuario'] = $id_usuario;
				$comentario['id_empleado'] = 0;
			}

			if ($Sesion->verifyVar('comentario',IKRN_VAR_CRC_CHANGE)) {
				if (!(int)$comentario['confirmacion']) $comentario['texto_publico'] = NULL;
				if (!(int)$comentario['confirmacion2']) $comentario['texto_privado'] = NULL;

				if (!empty($comentario['texto_publico']) OR !empty($comentario['texto_privado'])) {
					$comentario['id_incidencia'] = $incidencia['id_incidencia'];
					$comentario['fecha'] = date("Y/m/d G:i");
					$comentario['id_usuario'] = $id_usuario;
					$oDb->tb_replace("Comentarios",$comentario);
					$tipo_notif |= NOTI_COMMENT;
				}
			}
			break;

		case "Cerrar" :

			if ($Sesion->verifyVar('comentario',IKRN_VAR_CRC_CHANGE)) {
				if (!(int)$comentario['confirmacion']) $comentario['texto_publico'] = NULL;
				if (!(int)$comentario['confirmacion2']) $comentario['texto_privado'] = NULL;
				if (!empty($comentario['texto_publico']) OR !empty($comentario['texto_privado'])) {
					$comentario['id_incidencia'] = $id_incidencia;
					$comentario['fecha'] = date("Y/m/d-G:i");
					if ((int)$id_empleado) {
						$comentario['id_empleado'] = $id_empleado;
						$comentario['id_usuario'] = 0;
					} else {
						$comentario['id_usuario'] = $id_usuario;
						$comentario['id_empleado'] = 0;
					}
					$oDb->tb_replace("Comentarios",$comentario);
					$tipo_notif |= NOTI_COMMENT;
				}
				$oDb->query("update Incidencias set estado=1 , fecha_cierre='".date("Y-m-d G:i")."' where id_incidencia = $id_incidencia");
				$tipo_notif |= NOTI_CLOSE;
			}
			break;
	}//fin de acciones

	if ((int)$tipo_notif) 
		enviar_notificacion($oDb,$tipo_notif,$id_incidencia, ( ($tipo_notif & NOTI_SCALE) ? $old_id_gestor : NULL));

	$db_gestion = $Sesion->get_db('db_gestion');
	if (!is_object($db_gestion)) {
		$db_conf = $Sesion->get_db('conf');
		$db_user = $db_conf->read_main_value("db_gestion_login");
		$db_pass = $db_conf->read_main_value("db_gestion_passwd");
		$db_host = $db_conf->read_main_value("db_gestion_server");
		$db_dbase= $db_conf->read_main_value("db_gestion_dbase");
		if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase))
			  $Sesion->set_db("db_gestion",new wol_db("db_gestion",$db_user,$db_pass,$db_host,$db_dbase),1);
		else
			  $Sesion->set_db("db_gestion",$Sesion->get_db('data'),1);
		$cons = "SELECT nombre,valor FROM _main WHERE nombre like 'link_gestion%'";
		$rs = $db_conf->query($cons);
		if ($db_conf->num_rows($rs)) {
			while ($aTmp = $db_conf->fetch_assoc($rs)) {
				if (!strcmp($aTmp['nombre'],'link_gestion')) {
					$aLinkGestion['href'] = $aTmp['valor'];
				} else {
					$resto = substr($aTmp['nombre'],strlen('link_gestion'));
					$aChunk = explode("_",$resto);
					$seed = &$aLinkGestion;
					if ($aChunk AND sizeof($aChunk)) {
						foreach ($aChunk as $ref) {
							if (empty($ref)) continue;
							$seed = &$seed[$ref];
						}
						$seed = $aTmp['valor'];
					}
				}
			}
		}
		$Sesion->set_var("aLinkGestion",$aLinkGestion,"NOEXPIRE");
	}

	$tmpid = $Sesion->get_var('id_incidencia');
	if (!is_numeric($tmpid)) {
		$Sesion->perror(NULL,'ID','No se ha podido localizar el identificador de la incidencia a mostrar');
		return $Sesion->perror_plt();
	}
}


define(NOTI_NEW,			bindec("00000001"));
define(NOTI_EDIT,			bindec("00000010"));
define(NOTI_COMMENT,		bindec("00000100"));
define(NOTI_SCALE,		bindec("00001000"));
define(NOTI_CLOSE,		bindec("00010000"));
/** 
*  Manda un e mail advirtiendo de las modificaciones oportunas a quien sea necesario
* @param $quien ("Cliente","Proveedor","Agente" ,"Empleado","Proveedor"
* @param $accion "Escalado"  ("Nuevo","Cerrar","Anyadir") //sin usar
* @param $identificador_incidencia
*/
// Se le ha cambiado el parametro de entrada, pidiendo directamente la conexion bbdd.
function enviar_notificacion($oDb, $tipo = 0, $id_incidencia, $id_gestor_anterior=NULL, $bUsrApertura = NULL){
	if (!$tipo) return 0;

  $aEmail['de'] = "Inmersa CRM <cvs-crm@lists.wol>";
  $aEmail['encabezado'] = "Se le envia este aviso para indicarle que un $quien ha modifificado la incidencia ";
  $aEmail['headers'] = "From: ".$aEmail['de']."\r\n";
								 "MIME-Version: 1.0\r\n".
								 "Content-Type: text/plain; charset=iso-8859-1\r\n";
								 "Content-Transfer-Encoding: 7bit\r\n".

  $aBases['incidencia'] = "Texto de Introduccion / ENTRADA :\n";
  $aBases['escalado'] = "Esta Incidencia ha sido escalada a otro gestor.\n";
  $aBases['c_publico'] = "Nuevos comentarios:\n";
  $aBases['c_privado'] = "Comentario Interno:\n";
  $aBases['cierre'] = "La incidencia ha sido CERRADA\n";

  $aTipos[NOTI_NEW] = array( 'apertura' => TRUE, 'implicado' => TRUE, 'gestor' => TRUE, 'coordinador' => TRUE );
  $aTipos[NOTI_EDIT] = array( 'apertura' => TRUE, 'implicado' => TRUE, 'gestor' => TRUE, 'coordinador' => TRUE );
  $aTipos[NOTI_COMMENT] = array( 'apertura' => TRUE, 'implicado' => TRUE, 'gestor' => TRUE, 'coordinador' => TRUE );
  $aTipos[NOTI_SCALE] = array( 'apertura' => TRUE, 'implicado' => TRUE, 'gestor' => TRUE, 'coordinador' => TRUE, 'exgestor' => TRUE );
  $aTipos[NOTI_CLOSE] = array( 'apertura' => TRUE, 'implicado' => TRUE, 'gestor' => TRUE, 'coordinador' => TRUE );

  if (!is_object($oDb)) return 0;
  if (!(int)$id_gestor_anterior) $id_gestor_anterior = NULL;
  else $id_gestor_anterior = (int)$id_gestor_anterior;

  if (!isset($bUsrApertura) AND ($tipo & ~NOTI_NEW)) {
			 $cons = "SELECT Inc.usuario_empleado,Com.id_usuario,Com.id_empleado FROM Incidencias Inc, Comentarios Com ".
						"WHERE Inc.id_incidencia = Com.id_incidencia AND Inc.id_incidencia = $id_incidencia ".
						"ORDER BY Com.id_comentario desc LIMIT 1";
			 $rs = $oDb->query($cons);
			 if (!$oDb->num_rows($rs)) return 0;
			 $aTmp = $oDb->fetch_row($rs);
			 $bUsrApertura = !(int)$aTmp[0];
			 $bUsrComentario = (int)$aTmp[1];
			 $bEmpComentario = (int)$aTmp[2];
			 $oDb->libera($rs);
  }

  // Obtenemos la informacion de la Incidencia.
  $cons = "SELECT ".
				  " CONCAT('INC-',Inc.id_incidencia) as 'inc_Numero', ".
				  // " Inc.nombre as 'Nombre de Incidencia', ".
				  " Pri.nombre as 'inc_Prioridad', ".
				  " Dep.nombre as 'inc_Departamento', ".
				  " Tin.nombre as 'inc_Tipo', ".
				  " DATE_FORMAT(Inc.fecha,'%e/%c/%Y %T') as 'inc_Fecha de Apertura', ".
				  " IF(Inc.estado,'Cerrada','Abierta') as 'inc_Estado', ".
				  " IF(Inc.estado,DATE_FORMAT(Inc.fecha_cierre,'%e/%c/%Y %T'),NULL) as 'inc_Fecha de Cierre', ".
				  " IF(Inc.estado,NULL,DATE_FORMAT(DATE_ADD(Inc.fecha,INTERVAL Mat.horas_estimadas HOUR),'%e-%c-%Y %T')) ".
							 "as 'inc_Fecha Estimada de Cierre', ".
				  " CONCAT(Uap.nombre,' ',Uap.apellidos) as 'xin_Abierta por', ".
				  " CONCAT(Uim.nombre,' ',Uim.apellidos) as 'xin_Implica sobre', ".
				  " CONCAT(Uge.nombre,' ',Uge.apellidos) as 'xin_Gestor actual', ".
				  // " Inc.id_incidencia as 'inc_id', ".
				  " Inc.usuario_empleado as 'uap_usuario_empleado', ".
				  " Uap.email as 'uap_email', ".
				  " Uim.email as 'uim_email', ".
				  " Uge.email as 'uge_email', ".
				  " Coo.email as 'coo_email', ".
				  " 1 as 'coo_txtpublico', ".
				  " 1 as 'coo_txtprivado', ".
				  " 0 as 'uim_txtprivado', ".
				  " 1 as 'uim_txtpublico', ".
				  // " Inc.id_prioridad as 'inc_id_prioridad', ".
				  // " Inc.id_tipo_incidencia as 'ids_tipo_incidencia', ".
				  // " Dep.id_departamento as 'ids_departamento', ".
				  ( ($bUsrApertura)
					 ?  " Uap.id_usuario as 'uap_id', 0 as 'uap_escalado', 0 as 'uap_txtprivado', "
					 :  " Uap.id_empleado as 'uap_id', 1 as 'uap_escalado', Uap.comentarios_publicos as 'uap_txtpublico', ").
				  " Uim.id_usuario as 'uim_id', ".
				  " Uge.id_empleado as 'uge_id', ".
				  " Uge.comentarios_publicos as 'uge_txtpublico', ".
				  " 1 as 'uge_txtprivado', ".
				  (($id_gestor_anterior) 
					? "Exg.id_empleado as 'exg_id', ".
							 "CONCAT(Exg.nombre,' ',Exg.apellidos) as 'xin_Gestor Anterior', ".
							 "Exg.email as 'exg_email', Exg.comentarios_publicos as 'exg_txtpublico', 1 as 'exg_txtprivado', "
					: NULL ).
				  "Inc.nota_apertura as 'inc_Nota de Apertura' ".
				  "FROM Incidencias Inc, Prioridades Pri, Margenes_tiempo Mat, ".
				  (($id_gestor_anterior) 
					? "Empleados Exg, "
					: NULL
				  ).
				  ( ($bUsrApertura)
					 ?  "Usuarios Uap, "
					 :  "Empleados Uap, ") .
				  "Usuarios Uim, Empleados Uge, Tipo_incidencia Tin, Departamentos Dep, Empleados Coo ".
				  "WHERE Inc.id_incidencia = $id_incidencia AND ".
				  ( ($id_gestor_anterior)
				  	 ? "Exg.id_empleado = $id_gestor_anterior AND "
					 : NULL).
				  ( ($bUsrApertura)
					 ?  " Uap.id_usuario = Inc.id_usuario_apertura AND "
					 :  " Uap.id_empleado = Inc.id_usuario_apertura AND ").
				  "Inc.id_prioridad = Pri.id_prioridad AND ".
				  "Inc.id_usuario_implicado = Uim.id_usuario AND Inc.id_usuario_gestor = Uge.id_empleado AND ".
				  "Tin.id_tipo_incidencia = Inc.id_tipo_incidencia AND Dep.id_departamento=Tin.id_departamento AND ".
				  "Dep.id_coordinador = Coo.id_empleado AND ".
				  "Mat.id_prioridad = Inc.id_prioridad AND Mat.id_tipo_incidencia=Inc.id_tipo_incidencia ";
  $rs = $oDb->query($cons);
  if ($oDb->num_rows($rs)) {
			 $aTmp = $oDb->fetch_assoc($rs);
			 foreach($aTmp as $clave => $valor) {
						$ref_arr = substr($clave,0,4);
						$ref_resto = substr($clave,4);
						if (!strcasecmp($ref_arr,'inc_')) {
								  $aMensaje['incidencia'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'xin_')) {
								  $aMensaje['extras'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'uap_')) {
								  $aGente['apertura'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'uim_')) {
								  $aGente['implicado'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'uge_')) {
								  $aGente['gestor'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'exg_')) {
								  $aGente['exgestor'][$ref_resto] = $valor;
						} elseif (!strcasecmp($ref_arr,'coo_')) {
								  $aGente['coordinador'][$ref_resto] = $valor;
						}
			 }
  } else {
	  return 0;
  }

  $oDb->libera($rs);

  $aEmail['asunto'] = $aMensaje['incidencia']['Numero'].' ('.$aMensaje['incidencia']['Fecha de Apertura'].') -['.$aMensaje['incidencia']['Tipo'].
	  							']- Sobre '.$aMensaje['extras']['Implica sobre'];
  /** **
  debug("Incidencia :");
  print_r($aMensaje);
  /** **
  debug("Usuarios :");
  print_r($aGente);
  /** **/

  if ($tipo & NOTI_COMMENT) {
			 $cons = "SELECT ".
						 ( ($bUsrComentario) 
							? "CONCAT(Usr.nombre,' ',Usr.apellidos) as 'pub_Realizado por', ".
											  "CONCAT(Usr.nombre,' ',Usr.apellidos) as 'pri_Realizado por', "
							: "CONCAT(Usr.nombre,' ',Usr.apellidos) as 'pub_Realizado por', ".
											  "CONCAT(Usr.nombre,' ',Usr.apellidos) as 'pri_Realizado por', " ).
						 "DATE_FORMAT(Co.fecha,'%e-%c-%Y %T') as 'pub_Fecha', ".
						 "DATE_FORMAT(Co.fecha,'%e-%c-%Y %T') as 'pri_Fecha', ".
						 "Co.texto_publico as 'pub_Comentario', ".
						 "Co.texto_privado as 'pri_Comentario Interno' ".
						 "FROM Comentarios Co, ".
						 ( ($bUsrComentario)
							? "Usuarios Usr "
							: "Empleados Usr ").
						 "WHERE Co.id_incidencia = $id_incidencia AND ".
						 ( ($bUsrComentario)
							? "Usr.id_usuario = Co.id_usuario "
							: "Usr.id_empleado = Co.id_empleado ").
						 "ORDER BY Co.id_comentario desc LIMIT 1";
			 $rs = $oDb->query($cons);
			 $hay_rows = $oDb->num_rows($rs);

			 if ($hay_rows) {
						$aTmp = $oDb->fetch_assoc($rs);
						foreach($aTmp as $clave => $valor) {
								  $ref_arr = substr($clave,0,4);
								  $ref_resto = substr($clave,4);
								  if (!strcasecmp($ref_arr,'pub_')) {
											 $aMensaje['c_publico'][$ref_resto] = trim($valor);
								  } elseif (!strcasecmp($ref_arr,'pri_')) {
											 $aMensaje['c_privado'][$ref_resto] = trim($valor);
								  }
						}
			 }
			 $oDb->libera($rs);
  }

  $aDestinos = array();
  foreach ($aGente as $quien => $aDatos) {
	  if (empty($aDatos['email'])) continue;
	  $aDestinos[$aDatos['email']]['incidencia'] = 1;
	  if (!strcasecmp($quien,'coordinador') OR !strcasecmp($quien,'gestor') OR !strcasecmp($quien,'exgestor')) 
		  $aDestinos[$aDatos['email']]['extras'] = 1;
	  if (!strcasecmp($quien,'apertura') AND (int)$aDatos['usuario_empleado']) 
		  $aDestinos[$aDatos['email']]['extras'] = 1;
  }

  $i = 0;
  while ((int)$tipo AND ($i++)<10) {
			 if ($tipo & NOTI_NEW) {
						$tipo &= ~NOTI_NEW;
						// debug("Nueva  Incidencia...".decbin($tipo));
						// debug("NO se ha mandado email...");
			 } elseif ($tipo & NOTI_SCALE) {
						foreach ($aTipos[NOTI_SCALE] as $quien => $bool) {
							$aDatos = $aGente[$quien];
							if ((int)$bool AND !empty($aDatos['email'])) {
								$aDestinos[$aDatos['email']]['escalado'] = 1;
								// $aDestinos[$aDatos['email']]['extras'] = 1;
							}
						}
						$tipo &= ~NOTI_SCALE;
			 } elseif ($tipo & NOTI_EDIT) {
						// debug("Edicion de Incidencia...");
						// debug("NO se ha mandado email...");
						$tipo &= ~NOTI_EDIT;
			 } elseif ($tipo & NOTI_COMMENT) {
						foreach ($aTipos[NOTI_COMMENT] as $quien => $bool) 
								  if ((int)$bool) {
											 if (!is_array($aGente[$quien]) OR empty($aGente[$quien]['email'])) continue;
											 $aDatos = $aGente[$quien];
											 if (is_numeric($aDatos['txtprivado']) AND !empty($aMensaje['c_privado']['Comentario Interno']) ) {
														if ((int)$aDatos['txtprivado'])
																  $aDestinos[$aDatos['email']]['c_privado'] = 1;
											 } 
											 if (is_numeric($aDatos['txtpublico']) AND !empty($aMensaje['c_publico']['Comentario']) ) {
														if ((int)$aDatos['txtpublico'])
																  $aDestinos[$aDatos['email']]['c_publico'] = 1;
											 }
								  }
						$tipo &= ~NOTI_COMMENT;
			 } elseif ($tipo & NOTI_CLOSE) {
						foreach ($aTipos[NOTI_CLOSE] as $quien => $bool) {
							$aDatos = $aGente[$quien];
							if ((int)$bool AND !empty($aDatos['email'])) {
								$aDestinos[$aDatos['email']]['cierre'] = 1;
							}
						}
						$tipo &= ~NOTI_CLOSE;
			 }
  }

  foreach ($aDestinos as $email => $aMsgs) {
			 if (sizeof($aMsgs) == 0) continue;
			 $email_body = "";
			 foreach ($aMsgs as $parte => $bool)
						if ((int)$bool) {
								  if (!empty($aBases[$parte]))
											 $email_body .= $aBases[$parte];
								  if (is_array($aMensaje[$parte]) AND sizeof($aMensaje[$parte]))
											 foreach ($aMensaje[$parte] as $campo => $valor) {
														$email_body .= $campo."\t:\t".$valor."\n";
											 }
								  $email_body .= "\n";
						}
			 mail($email,$aEmail['asunto'],$email_body,$aEmail['headers']);
  }
  
  return 1;
}

function pre_rfq(&$Sesion) {
	$id = $Sesion->get_var('id_rfq');
	if (is_numeric($id)) {
		$oRFQ = $Sesion->get_var('oRFQ_actual');
		if (!is_object($oRFQ) OR !is_a($oRFQ,'RFQ') OR $id!=$oRFQ->getId()) {
			$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
			if (!$oRFQ->dbFill($id)) {
				$oRFQ = NULL;
			} else {
				$Sesion->set_var('oRFQ_actual',$oRFQ,'SUBSECCION');
				$Sesion->set_var('__dbItemMultiEntity_varname','oRFQ_actual','SUBSECCION');
			}
		} else {
			$Sesion->set_var('__dbItemMultiEntity_varname','oRFQ_actual','SUBSECCION');
		}
	}

}

function pre_documentos(&$Sesion) {
	$aUsr = identifica_usuarios($Sesion);
	$aCfg = $Sesion->get_var('_aAppConf');
	if (!is_array($aCfg) OR !sizeof($aCfg) OR empty($aCfg['crm_idgrupodocs_presupuestos']) 
			OR (!is_numeric($aUsr['crm_id_usuario']) AND !is_numeric($aUsr['crm_id_empleado'])) ) {
		$Sesion->unset_var('id_grupo_docs');
	} else {
		$Sesion->set_var('id_grupo_docs',$aCfg['crm_idgrupodocs_presupuestos'],'INMED');
	}

	$idpresu = $Sesion->get_var('id_presupuesto');
	if (!is_numeric($idpresu)) {
		$docvar = $Sesion->get_var('__document_iface_varname');
		if (!empty($docvar)) {
			$oPr = $Sesion->get_var($docvar);
			if (is_object($oPr) AND is_a($oPr,'Document')) {
				$idpresu = $oPr->getId();
			}
		}
	}

	if (!is_numeric($idpresu)) {
		$Sesion->unset_var('id_presupuesto');
		$Sesion->lcMesage('LCS_NOID',array('entidad' => 'Presupuestos'),IM_ERROR);
	} else $Sesion->set_var('id_presupuesto',$idpresu,'INMED');
}

function class_CRMEvent_getfirstdocs (&$Sesion,$block_name) {
	static $obj_var;
	static $aMethodResults;

	if (empty($obj_var)) {
		$docvar = $Sesion->get_var('__dbItemMultiEntity_varname');
	   if (empty($docvar)) $docvar = 'oIncidencia_en_curso';

	   $obj_var = $docvar;
	}

	if (!isset($aMethodResults) OR !is_array($aMethodResults)) {
		$aMethodResults = array();

		$oME = $Sesion->get_var($obj_var);
		if (!is_object($oME) OR !is_a($oME,'dbItemMultiEntity')) return NULL;

		$oCom = &$oME->getComments();
		$idx_first = $oCom->firstItem();
		for ($idx = $oCom->firstItem(); isset($idx); $idx = $oCom->nextItem()) {
			if (!is_numeric($old_idx) AND $idx > $idx_first) {
				break;
			} elseif ($idx > ($old_idx +1) ) {
				break;
			}
			$oItem = &$oCom->getItem();
			$aDocs = $oItem->getRelatedDocuments();
			if (is_array($aDocs) AND sizeof($aDocs)) {
				foreach($aDocs as $iddoc => $aDoc) {
					$aDoc['idx'] = $idx;
					$aDoc['texto_publico'] = $oItem->getAttribute('texto_publico');
					array_push($aMethodResults,$aDoc);
				}
				$old_idx = $idx;
			}
				
		}
	}

	if (is_array($aMethodResults) AND sizeof($aMethodResults)) $aRetVal = array_shift($aMethodResults);
	else $aRetVal = NULL;

	if (!$aRetVal) $aMethodResults = NULL;

	return $aRetVal;
}

?>
