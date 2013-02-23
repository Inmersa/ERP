<?php

class Empresario extends dbItemMultiEntity {

	function Empresario ($AppName = NULL, $dbname = 'data', $aData = NULL) {
		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];

		$tabla = 'Empresarios';

		$aFlds['Empresarios:Empresario'] = array(
			// Claves Primarias y Foraneas
				'id_empresario','id_empresa','id_provincia','crm_id_empleado','id_usr',
			// Datos Personales
				'cif','nombre','apellidos','direccion','cp','poblacion','telefono1','telefono2','email','observaciones',
			// Datos Bancarios
				'iban','bic','bban','entidad','dc_ccc','oficina','cuenta_bancaria'
				);
		$aFlds['Empresas:Empresa'] = array(
				'id_empresa',
				'razon_social','nombre','apellidos','direccion_facturacion','cp','poblacion','telefono1','fax','email','stock_negativo'
				);

		$aAcciones['id_empresa'] = array('method' => 'updateForeignKey');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}
	}

	function update ($aData,$entidad = NULL,$bForce = NULL) {
		$oS = &$this->getApp();
		if (empty($aData['login']) and empty($aData['passwd']) and empty($aData['nombre']) and empty($aData['apellidos']) ) {
			$tmp = $this->getAttribute('nombre');
			$tmp2 = $this->getAttribute('apellidos');
			if (empty($tmp) and empty($tmp2)) {
				if (empty($tmp)) $aTmp['fld1'] = 'nombre';
				if (empty($tmp2)) $aTmp['fld2'] = 'apellidos';
				$oS->lcMessage('IKRN_MISSING_FIELDS',$aTmp);
				return false;
			}
		}
		$idu = $this->getAttribute('id_usr');
		if ($idu != $aData['id_usr'] and !empty($aData['login']) ) $aData['id_usr'] = $idu;

		$rval = parent::update($aData,$entidad,$bForce);

		if ($rval) {
			if (!empty($aData['login']) or !empty($aData['id_usr'])) {
				if (!empty($aData['passwd']) and strcmp($aData['passwd'],$aData['passwd2'])) {
					$oS->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $luser['login']));
				} else {
					$aUsr['activo'] = (int)$aData['activo'];
					$aUsr['nombre'] = $this->getAttribute('nombre').' '.$this->getAttribute('apellidos');
					$aUsr['passwd'] = $aData['passwd'];
					$aUsr['login'] = $aData['login'];
					$aUsr['id_usr'] = $this->getAttribute('id_usr');
					$oUsr = $oS->get_authed_user();
					$idu = $oUsr->dbReplaceUser($aUsr,'Empresas');
					if ( (!empty($idu) and $idu!=-1) ) {
						$this->setAttribute('id_usr',$idu);
					} else {
						$this->setAttribute('id_usr','null');
					}
				}
			}
		}

		return $rval;
	}

	function postDump($rval) {
		if ($rval) {
			if ($this->checkFlag($this->ST_DEL)) {
				$id_usr = $this->getAttribute('id_usr');
				$oS = &$this->getApp();
				$oUsr = $oS->get_authed_user();
				$oUsr->dbReplaceUser(array('id_usr' => $id_usr, 'login' => NULL),'Empresas');
			}
		}
		return $rval;
	}
}

/** Funciones de listado de empresa para grupo y modificacion de datos de empresa como empresario
   global $registro;
   global $registro_borrar;
   global $estado;
Acciones : (casos) 1  -> modificacion de Empresas como empresario
                   2  -> borrado desde la ficha
                   3  -> borrado desde el listado
						 4  -> ,odificacion desde el grupo de empresas
 */

function pre_empresas(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$id_imagen=$Sesion->fetchVar('id_imagen','POST');
	$users=$Sesion->fetchVar('users','POST');
	if (empty($estado)) $estado = 0;

	$usuario = identifica_usuarios($Sesion);
	$db_conf = &$Sesion->get_db('conf');
	$grp_mask = $Sesion->get_var("empresario_mask");
	if (empty($grp_mask) AND strcasecmp($usuario['desktop_name'],'Empresario')) {
		$rstmp = $db_conf->query("SELECT mask FROM Desktops WHERE nombre like '%Empresario%'");
		if ($db_conf->num_rows($rstmp)) {
			$aTmp = $db_conf->fetch_row($tmprs);
			$grp_mask = $aTmp[0];
		} else $grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
		$db_conf->libera($tmprs);
	} elseif (empty($grp_mask)) {
		$grp_mask = $usuario['desktop_mask'];
		$Sesion->set_var("empresario_mask",$grp_mask,"NOEXPIRE");
	}

	$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
	$id_empresa = $usuario['id'];
	$oDb = &$Sesion->get_db('data');
	//   depurar_array($usuario);
	switch ($estado) {
		case 1: /* modificacion de Empresas como empresario */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if(is_object($db_conf) AND is_array($users)){
					foreach ($users as $id => $aUser) {
						$oE = new Empresario();
						if (!strcasecmp($id,'new')) {
							if (empty($aUser['login'])) continue;
							$aUser['id_usr'] = NULL;
							unset($aUser['id_usr']);
						} else {
							if (empty($aUser['id_empresario'])) {
								debug("Error: No hay IDError: , pero tampoco es nuevo. SKIP ");
								continue;
							}
							$oE->dbFill($aUser['id_empresario']);
							if ($aUser['borrar']) {
								$oE->delete();
								$oE->Dump();
								continue;
							}
						}
						$aUser['id_empresa'] = $id_empresa;
						$oE->update($aUser);
						$oE->Dump();
					}
				} 
				if($Sesion->get_var("identificador_imagen_nueva"))
					$registro["id_imagen"] = $Sesion->get_var("identificador_imagen_nueva");
				$registro['stock_negativo'] = (int)$registro['stock_negativo'];
				if (!is_numeric($registro['id_imagen'])) $registro['id_imagen'] = 'null';
				$oDb->tb_update("Empresas",$registro);
				$Sesion->unset_var("identificador_imagen_nueva");
			}
			break;

		case 2 : //borrado
			$consulta="delete from Empresas where id_empresa = $registro[id_empresa]";
			if (!$oDb->query($consulta)) {
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Empresas'));
				return;
			}
			break;

		case 3 : //borrado del listado
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Empresas where id_empresa =$clave";
						if(!$oDb->query($consulta)){
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Empresas'));
							return;
						}
					}
			}
			break;

		case 4 : 
			//modificacion desde grupo de empresas FIXME: Esto esta sin arreglar -revisarse escritorio de grupo-
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(!(is_object($db_conf))) {
					$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
					return;
				}
			
				if ($registro["id_usr"] != 0) {
					$consulta2="select login  from Users where login ='$registro[login]' and id_usr !=". $registro["id_usr"];
					$rs2 = $db_conf->query($consulta2);
					$row2=$db_conf->fetch_array($rs2);
					if($row2){ //el login ya estaba pillao
						$Sesion->lcMessage('LCS_USR_EXISTS',array('login' => $registro['login']));
					} else {
						$consulta="select  passwd from Users where id_usr =" .$registro["id_usr"];
						$r44s = $db_conf->query($consulta);
						$row22=$db_conf->fetch_array($r44s);
						$user["passwd"] = $row22[0];
						$user["id_usr"] =  $registro["id_usr"];
						$user["nombre"] = $registro["login"];
						$user["login"] =  $registro["login"];
						$user["av_group"] =  4;
						$user["activo"] =  1;
						$db_conf->tb_replace("Users",$user);

						if($registro["passwd"] != "" AND $registro["passwd2"] != "" AND( $registro["passwd2"] == $registro["passwd"]) ){
							$consulta="update Users set passwd=PASSWORD('$registro[passwd]') where id_usr =$registro[id_usr]";
							$db_conf->query($consulta);
						}
					}

				} else {//no habia antes
					$consulta2="select login  from Users where login ='$registro[login]'";
					$rs2 = $db_conf->query($consulta2);
					$row2=$db_conf->fetch_array($rs2);
					if($row2){//el login ya estaba pillao
						$Sesion->lcMessage('LCS_USR_EXISTS',array('login' => $registro['login']));
					} else {
						if ($registro["passwd"] != "" AND $registro["login"] != "" AND $registro["passwd2"] != "" 
								AND( $registro["passwd2"] == $registro["passwd"]) ){
							$user["nombre"] = $registro["login"];
							$user["login"] =  $registro["login"];
							$user["av_group"] =  4;
							$user["activo"] =  1;
							$db_conf->tb_replace("Users",$user);
							$consulta23="select LAST_INSERT_ID()";
							$rs23 = $db_conf->query($consulta23);
							$row23=$db_conf->fetch_array($rs23);
							$consulta="update Users set passwd=PASSWORD('$registro[passwd]') where id_usr =$row23[0]";
							$db_conf->query($consulta);
							$registro["id_usr"]=$row23[0];
						}
					}
				}

				if($Sesion->get_var("identificador_imagen_nueva"))
					$registro["id_imagen"] = $Sesion->get_var("identificador_imagen_nueva");

				$registro['stock_negativo'] = (int)$registro['stock_negativo'];
				//                   debug($Sesion->get_var("identificador_imagen_nueva"));
				//                    depurar_array($registro);
				$oDb->tb_replace("Empresas",$registro);
				$Sesion->unset_var("identificador_imagen_nueva");
			}
			break;

		default :
			if (!is_object($Sesion->get_db("db_catalogo"))) {
				$db_user = $Sesion->read_main_value("db_catalogo_login");
				$db_pass = $Sesion->read_main_value("db_catalogo_passwd");
				$db_host = $Sesion->read_main_value("db_catalogo_server");
				$db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
				if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase))
					$Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
				else
					$Sesion->set_db("db_catalogo",$Sesion->get_db("data"),1);
			}
			break;

	}//fin del switch

}//fin del precode

function pre_empresario(&$Sesion) {
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$id = $Sesion->fetchVar('id','GET SESSION');
	if (!$id) {
		$id = $Sesion->get_var('id_empresario');
		if (is_numeric($id)) $Sesion->set_var('id',$id,'SUBSECCION');
	} else $Sesion->set_var('id_empresario',$id);

	if (empty($id)) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Empresarios'));
		return;
	}
	$id_crm = $Sesion->fetchVar('usuario_seleccionado','POST');
	$aEmp = $Sesion->fetchVar('Empresarios','POST');
	$aAcc = $Sesion->fetchVar('acciones','POST');

	switch ($accion) {
		case 'Modificar':
			if (!is_array($aEmp) or !isset($aEmp)) break;
			if (!empty($aAcc['descartar_usuario_crm'])) $aEmp['crm_id_empleado'] = 'null';
			$oEmp = new Empresario();
			if ($oEmp->dbFill($id)) {
				$oEmp->update($aEmp);
				$oEmp->Dump();
			}
			break;

		case 'Seleccion_usuario_crm':
			if (empty($id)) break;
			$oEmp = new Empresario();
			if ($oEmp->dbFill($id)) {
				$oEmp->update(array('crm_id_empleado' => $id_crm));
				$oEmp->Dump();
			}
			break;
	}
}

function pre_contadores(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');

	$id_emp = $Sesion->get_var("id_empresa");
	if (empty($id_emp) OR !isset($id_emp) OR !is_numeric($id_emp)) {
		$usuario = identifica_usuarios($Sesion);
		$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
		$id_emp = $usuario['id'];
	}

	if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
		if (is_array($registro) AND sizeof($registro)) {
			$oDb = $Sesion->get_db('data');
			$registro['id_empresa'] = $id_emp;
			$oDb->tb_update("Empresas",$registro);
		}
	}
}

function pre_bancos(&$Sesion) {
	$bancos=$Sesion->fetchVar('bancos','POST');
	$bancos_devolucion=$Sesion->fetchVar('bancos_devolucion','POST');
	$borrar_devolucion=$Sesion->fetchVar('borrar_devolucion','POST');
	$banco=$Sesion->fetchVar('banco','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_banco=$Sesion->fetchVar('id_banco','GET');
	$cc_old=$Sesion->fetchVar('cc_old','POST');

	if (!is_numeric($id_banco) OR empty($id_banco)) {
		$id = $Sesion->get_var("id_banco");
		if (is_numeric($id)) $id_banco = $id;
	} else $Sesion->set_var("id_banco",$id_banco,"SUBSECCION");

	$id_empresa = $Sesion->get_var("id_empresa");
	if (empty($id_empresa)) {
		$id_empresa = $usuario['id'];
		$Sesion->set_var("id_empresa",$id_empresa,"NOEXPIRE");
	}
	if (isset($accion_ejecutar) AND !empty($accion_ejecutar)) {
		$oDb = $Sesion->get_db('data');
		$usuario = identifica_usuarios($Sesion);
	}
	switch ($accion_ejecutar) {
		case "Nuevo" :
			if ($Sesion->verifyVar('banco',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('banco',IKRN_VAR_CRC_AUTHED)) {
				if (empty($banco['id_empresa'])) $banco['id_empresa'] = $id_empresa;
				$aCfg = $Sesion->get_var('_aAppConf');
				$icontadb = $aCfg['iconta_dbname'];
				$id_ej = $aCfg['iconta_ejercicio'];
				$id_emp_ej = NULL;
				if (!empty($icontadb)) {
					$oDb_ic = $Sesion->get_db($icontadb);
					if (!empty($banco['cuenta_contable']) AND is_numeric($banco['cuenta_contable']) ) {
						if (!$id_emp_ej) {
							$tmprs = $oDb_ic->query('SELECT id_empresa FROM Ejercicios WHERE id_ejercicio = '.$id_ej);
							if ($oDb_ic->num_rows($tmprs)) {
								$aTmp = $oDb_ic->fetch_row($tmprs);
								$id_emp_ej = $aTmp[0];
								$aTmp = NULL;
								$oDb_ic->libera($tmprs);
							}
						}
						if (is_numeric($id_emp_ej)) {
							$aTmp = AccountEntry::filterAccount($banco['cuenta_contable'],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
							$tmprs = $oDb_ic->query("SELECT * FROM Cuenta_contable WHERE id_plan_contable = ".$aTmp[0]." AND id_cuenta = ".$aTmp[1].' AND id_empresa = '.$id_emp_ej);
							if (!$oDb_ic->num_rows($tmprs)) {
								$aTmpReg['id_cuenta'] = $aTmp[1];
								$aTmpReg['id_plan_contable'] = $aTmp[0];
								$aTmpReg['nombre'] = $banco['nombre'];
								$aTmpReg['id_empresa'] = $id_emp_ej;
								$oDb_ic->tb_replace('Cuenta_contable',$aTmpReg);
								$aTmpReg = NULL;
							}
							$banco['cuenta_contable'] = $aTmp[0].$aTmp[1];
							$oDb_ic->libera($tmprs);
						}
					} elseif (empty($banco['cuenta_contable'])) $banco['cuenta_contable'] = 'null';
				}
				$oDb->tb_replace("Bancos",$banco);
			}
		break;

		case "Borrar" :
			foreach ($bancos as $id_banco) {
				$aTmp['id_banco'] = $id_banco;
				$aTmp['id_empresa'] = $id_empresa;
				$oDb->tb_delete("Bancos",$aTmp);
				$oDb->tb_delete("Bancos_devoluciones",$aTmp);
			}
		break;

		case "Modificar":
			if ($Sesion->verifyVar('banco',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('banco',IKRN_VAR_CRC_AUTHED)) {
				if (!is_numeric($banco['id_banco'])) return NULL;
				if (empty($banco['id_empresa'])) $banco['id_empresa'] = $id_empresa;
				$aCfg = $Sesion->get_var('_aAppConf');
				$icontadb = $aCfg['iconta_dbname'];
				$id_ej = $aCfg['iconta_ejercicio'];
				$id_emp_ej = NULL;
				if (!empty($icontadb)) {
					$oDb_ic = $Sesion->get_db($icontadb);
					if (!empty($banco['cuenta_contable']) AND is_numeric($banco['cuenta_contable']) ) {
						if (!$id_emp_ej) {
							$tmprs = $oDb_ic->query('SELECT id_empresa FROM Ejercicios WHERE id_ejercicio = '.$id_ej);
							if ($oDb_ic->num_rows($tmprs)) {
								$aTmp = $oDb_ic->fetch_row($tmprs);
								$id_emp_ej = $aTmp[0];
								$aTmp = NULL;
								$oDb_ic->libera($tmprs);
							}
						}
						if (is_numeric($id_emp_ej)) {
							$aTmp = AccountEntry::filterAccount($banco['cuenta_contable'],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
							$tmprs = $oDb_ic->query("SELECT * FROM Cuenta_contable WHERE id_plan_contable = ".$aTmp[0]." AND id_cuenta = ".$aTmp[1].' AND id_empresa = '.$id_emp_ej);
							if (!$oDb_ic->num_rows($tmprs)) {
								$aTmpReg['id_cuenta'] = $aTmp[1];
								$aTmpReg['id_plan_contable'] = $aTmp[0];
								$aTmpReg['nombre'] = $banco['nombre'];
								$aTmpReg['id_empresa'] = $id_emp_ej;
								$oDb_ic->tb_replace('Cuenta_contable',$aTmpReg);
								$aTmpReg = NULL;
							}
							$banco['cuenta_contable'] = $aTmp[0].$aTmp[1];
							$oDb_ic->libera($tmprs);
						}
					} elseif (empty($banco['cuenta_contable'])) $banco['cuenta_contable'] = 'null';
				}
				$oDb->tb_update("Bancos",$banco);

				// print_r($bancos_devolucion);
				if (is_array($bancos_devolucion['nuevo'])) {
					if (is_numeric($bancos_devolucion['nuevo']['monto_inicial']) 
							AND is_numeric($bancos_devolucion['nuevo']['monto_final'])) {
						if (!is_numeric($bancos_devolucion['nuevo']['id_banco'])) $bancos_devolucion['nuevo']['id_banco'] = $banco['id_banco'];
						$oDb->tb_replace("Bancos_devoluciones",$bancos_devolucion['nuevo']);
					}
					$bancos_devolucion['nuevo'] = NULL;
					unset($bancos_devolucion['nuevo']);
				}

				if (is_array($bancos_devolucion))
					foreach ($bancos_devolucion as $aBancoDev) {
						if (!is_numeric($aBancoDev['id_banco'])) $aBancoDev['id_banco'] = $banco['id_banco'];
						$oDb->tb_update("Bancos_devoluciones",$aBancoDev);
					}
			}
		break;

		case "Borrar_Devolucion":
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($borrar_devolucion)) 
					foreach ($borrar_devolucion as $id_devolucion)
						$oDb->tb_delete("Bancos_devoluciones",array("id_devolucion" => $id_devolucion));
			}
		break;

	}

}

?>
