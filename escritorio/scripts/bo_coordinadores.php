<?php
/** Funciones del listado de coordinadores
  global $registro;
  global $registro_borrar;
  global $estado;
  global $id_coordinador;

  Acciones (estados) Modificar , Crear , Borrar
 */

function pre_coordinadores(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$acciones=$Sesion->fetchVar('acciones','POST');

	$id_coordinador=$Sesion->fetchVar('id_coordinador','GET');
	$id_coordinador = id_entidad($Sesion,'id_coordinador',$id_coordinador);
	$Sesion->set_var('id_coordinador',$id_coordinador);

	//$usuario = identifica_usuarios($Sesion);
	$oDb = $Sesion->get_db('data');
	$id_empresa = $Sesion->get_var('id_empresa');

	enlazar_crm($Sesion);

	switch ($accion_ejecutar) {
		case 'Modificar' : //modificacion desde grupo de empresas
			$db_conf = $Sesion->get_db('conf');
			if(!(is_object($db_conf))) {
				$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
				return ;
			}
					
			$oUsr = $Sesion->get_authed_user();
			if (!empty($registro['login']) AND $registro['passwd']==$registro['passwd2'] ) {
				$id_usr = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'passwd' => $registro['passwd'], 
												'id_usr' => $registro['id_usr'], 'nombre' => $registro['nombre'], 'activo' => 1,
												'apellidos' => $registro['apellidos']),'Coordinador');
				if (!empty($id_usr) AND $id_usr != -1) $registro['id_usr'] = $id_usr;
				elseif (empty($registro['id_usr'])) $registro['id_usr'] = 'null';
			} elseif (!empty($registro['login']))  {
				$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $registro['login']));
			} elseif ( empty($registro['login']) AND is_numeric($registro['id_usr']) ) {
				$registro['id_usr'] = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'id_usr' => $registro['id_usr']));
				if ($registro['id_usr'] <= 0 ) $registro['id_usr'] = 'null';
			}

			if (is_array($acciones) AND sizeof($acciones)) {
				if (is_numeric($acciones['descartar_usuario_crm'])) $registro['crm_id_empleado'] = 'null';
			}

			if (is_numeric($registro['id_coordinador'])) $oDb->tb_update("Coordinadores",$registro);
			else $oDb->tb_replace("Coordinadores",$registro);

			if(!is_numeric($registro['id_coordinador'])) {
				$registro['id_coordinador'] = $oDb->last_insert_id();
			}
			$Sesion->set_var("id_coordinador",$registro['id_coordinador'],"SUBSECCION");
			break;

		case 'Nuevo' : //nuevo
			if (!empty($registro['nombre'])) {
				$id_empresa = $Sesion->get_var('id_empresa');
				if (!is_numeric($id_empresa)) {
					$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Empresas'));
					break;
				}
				$registro['id_empresa'] = $id_empresa;
				if (!empty($registro['login']) AND $registro['passwd']==$registro['passwd2'] ) {
					$oUsr = $Sesion->get_authed_user();
					$registro['id_usr'] = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'passwd' => $registro['passwd'], 'activo' => 1,
																'nombre' => $registro['nombre'], 'apellidos' => $registro['apellidos']),'Coordinador');
					if ($registro['id_usr'] == -1) $registro['id_usr'] = 'null';
				} elseif (!empty($registro['login'])) {
					$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $registro['login']));
				}
				$oDb->tb_replace("Coordinadores",$registro);
				if(!is_numeric($registro['id_coordinador'])) $registro['id_coordinador'] = $oDb->last_insert_id();
			}
			$Sesion->set_var("id_coordinador",$registr['id_coordinador'],"SUBSECCION");
			break;

		case 'Borrar' : //borrado del listado
			if(isset($registro_borrar)){
				foreach($registro_borrar as $id => $id_usr) {
					if(is_numeric($id_usr)){
						$db_conf = $Sesion->get_db('conf');
						$db_conf->tb_delete('Users',array('id_usr' => $id_usr));
					}
					if(!$oDb->tb_delete('Coordinadores',array('id_coordinador' => $id)) ){
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Coordinadores'));
					}
				}
			}
			break;

		case 'Seleccion_usuario_crm' :
			$usuario_seleccionado = $Sesion->fetchVar('usuario_seleccionado','POST');
			if (is_numeric($id_coordinador) and is_numeric($usuario_seleccionado) AND is_numeric($id_empresa)) {
				$oDb->tb_update('Coordinadores',array('id_coordinador'=>$id_coordinador,'crm_id_empleado'=>$usuario_seleccionado,'id_empresa'=>$id_empresa));
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del switch

}//fin del precode

/**devuelve el login de un coordinador */
function nombre_login_coordinadores(&$Sesion,&$aDatos) {
	$db_conf = $Sesion->get_db('conf');
	if(is_object($db_conf)){
		$consulta="select login from Users where id_usr =" .$aDatos["Coordinadores.id_usr"];
		$rs = $db_conf->query($consulta);
		$row = $db_conf->fetch_row($rs);
		//      depurar_array($row);
		return $row[0];
	}
	return "Error";
}

function pre_operadores(&$Sesion) {
	$registro=$Sesion->fetchVar('operadores','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$acciones=$Sesion->fetchVar('acciones','POST');

	$id_operador=$Sesion->fetchVar('id','GET');
	$id_operador = id_entidad($Sesion,'id_operador',$id_operador);
	$Sesion->set_var('id_operador',$id_operador);
	$Sesion->set_var('id',$id_operador);

	//$usuario = identifica_usuarios($Sesion);
	$oDb = $Sesion->get_db('data');
	$id_empresa = $Sesion->get_var('id_empresa');

	enlazar_crm($Sesion);

	switch ($accion_ejecutar) {
		case 'Modificar' : //modificacion desde grupo de empresas
			$db_conf = $Sesion->get_db('conf');
			if(!(is_object($db_conf))) {
				$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
				return ;
			}
					
			$oUsr = $Sesion->get_authed_user();
			if (!empty($registro['login']) AND $registro['passwd']==$registro['passwd2'] ) {
				$id_usr = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'passwd' => $registro['passwd'], 
												'id_usr' => $registro['id_usr'], 'nombre' => $registro['nombre'], 'activo' => 1,
												'apellidos' => $registro['apellidos']),'Operador');
				if (!empty($id_usr) AND $id_usr != -1) $registro['id_usr'] = $id_usr;
				elseif (empty($registro['id_usr'])) $registro['id_usr'] = 'null';
			} elseif (!empty($registro['login']))  {
				$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $registro['login']));
			} elseif ( empty($registro['login']) AND is_numeric($registro['id_usr']) ) {
				$registro['id_usr'] = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'id_usr' => $registro['id_usr']));
				if ($registro['id_usr'] <= 0 ) $registro['id_usr'] = 'null';
			}

			if (is_array($acciones) AND sizeof($acciones)) {
				if (is_numeric($acciones['descartar_usuario_crm'])) $registro['crm_id_empleado'] = 'null';
			}

			if (is_numeric($registro['id_operador'])) $oDb->tb_update("Operadores",$registro);
			else $oDb->tb_replace("Operadores",$registro);

			if(!is_numeric($registro['id_operador'])) {
				$registro['id_operador'] = $oDb->last_insert_id();
			}
			$Sesion->set_var("id_operador",$registro['id_operador'],"SUBSECCION");
			break;

		case 'Nuevo' : //nuevo
			if (!empty($registro['nombre'])) {
				$id_empresa = $Sesion->get_var('id_empresa');
				if (!is_numeric($id_empresa)) {
					$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Empresas'));
					break;
				}
				$registro['id_empresa'] = $id_empresa;
				if (!empty($registro['login']) AND $registro['passwd']==$registro['passwd2'] ) {
					$oUsr = $Sesion->get_authed_user();
					$registro['id_usr'] = $oUsr->dbReplaceUser(array('login' => $registro['login'], 'passwd' => $registro['passwd'], 'activo' => 1,
																'nombre' => $registro['nombre'], 'apellidos' => $registro['apellidos']),'Operador');
					if ($registro['id_usr'] == -1) $registro['id_usr'] = 'null';
				} elseif (!empty($registro['login'])) {
					$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $registro['login']));
				}
				$oDb->tb_replace("Operadores",$registro);
				if(!is_numeric($registro['id_operador'])) $registro['id_operador'] = $oDb->last_insert_id();
			}
			$Sesion->set_var("id_operador",$registr['id_operador'],"SUBSECCION");
			break;

		case 'Borrar' : //borrado del listado
			if(isset($registro_borrar)){
				foreach($registro_borrar as $id => $id_usr) {
					if(is_numeric($id_usr)){
						$db_conf = $Sesion->get_db('conf');
						$db_conf->tb_delete('Users',array('id_usr' => $id_usr));
					}
					if(!$oDb->tb_delete('Operadores',array('id_operador' => $id)) ){
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Operadores'));
					}
				}
			}
			break;

		case 'Seleccion_usuario_crm' :
			$usuario_seleccionado = $Sesion->fetchVar('usuario_seleccionado','POST');
			// debug("asociando no? ($id_operador) ($usuario_seleccionado) ($id_empresa) ");
			if (is_numeric($id_operador) and is_numeric($usuario_seleccionado) AND is_numeric($id_empresa)) {
				$oDb->tb_update('Operadores',array('id_operador'=>$id_operador,'crm_id_empleado'=>$usuario_seleccionado,'id_empresa'=>$id_empresa));
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del switch

	if (is_numeric($id_operador)) $Sesion->set_var('id',$id_operador,'NOEXPIRE');

}//fin del precode

?>
