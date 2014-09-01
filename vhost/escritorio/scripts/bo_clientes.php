<?php
/** listado  de clientes
  global $id_cliente;
  global $nuevo_cliente;
  global $accion_ejecutar;
  global $borrar_clientes;
  global $importar_clientes;
  global $registro;
  global $registro2;
  global $registro_dir;
  Acciones Modificar (cliente),  Nuevo ( direccion_entrega ,cliente) , Borrar (direcciones cliente )
 */
function pre_clientes(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	$nuevo_cliente=$Sesion->fetchVar('nuevo_cliente','POST');

	//Variables de Form
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$acciones=$Sesion->fetchVar('acciones','POST');
	$borrar_clientes=$Sesion->fetchVar('borrar_clientes','POST');
	$borrar_direcciones=$Sesion->fetchVar('borrar_direcciones','POST');
	$borrar_agentes=$Sesion->fetchVar('borrar_agentes','POST');
	$importar_clientes=$Sesion->fetchVar('importar_clientes','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$registro2=$Sesion->fetchVar('registro2','POST');
	$registro_dir=$Sesion->fetchVar('registro_dir','POST');
	$registroNN=$Sesion->fetchVar('registroNN','POST');
	$Agentes=$Sesion->fetchVar('Agentes','POST');
	$id_recomendador=$Sesion->fetchVar('id_recomendador','POST');
	$cli_user=$Sesion->fetchVar('cli_user','POST');
	$cc_old=$Sesion->fetchVar('cc_old','POST');

	$contactos=$Sesion->fetchVar('cliente_contactos','POST');
	$enlaces=$Sesion->fetchVar('cliente_enlaces','POST');

	// El usuario contiene el id_empresa:
	$usuario = identifica_usuarios($Sesion);
	$tmp = $Sesion->get_var("id_empresa");
	if ($usuario['id'] != $tmp OR empty($tmp)) {
		$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
		$id_empresa = $usuario['id'];
	} else $id_empresa = $tmp;

	$a = $id_cliente;
	$id_cliente_sesion = $id_cliente = id_entidad($Sesion,'id_cliente',$id_cliente);

	enlazar_crm($Sesion);
	$oModSel = ModoSeleccion::Factory();
	if ($oModSel) $oModSel->Seek();

	$oDb = $Sesion->get_db('data');
	$db_conf = $oDb_conf = $Sesion->get_db('conf');

	$aMasks = $Sesion->get_var("_aMasks");
	if (!is_array($aMasks) OR !is_numeric($aMasks['cliente'])) {
		$cons = "SELECT mascara FROM Groups WHERE nombre = 'Clientes'";
		$rs = $oDb_conf->query($cons);
		if ($oDb_conf->num_rows($rs)) {
			$aTmp = $oDb_conf->fetch_assoc($rs);
			$group_mask = $aTmp['mascara'];
			$aMasks['cliente'] = $group_mask;
			$Sesion->set_var("_aMasks",$aMasks,"NOEXPIRE");
		} 
	} 
	$Sesion->set_var("group_mask",$aMasks['cliente'],"INMED");

	switch ($accion_ejecutar){
		case "Modificar" :
			if ($Sesion->verifyVar('registro_dir',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro_dir',IKRN_VAR_CRC_AUTHED)) {
				// debug("modificar y tal...");
				if(isset($registro_dir)){
					$registro_dir["id_cliente"] = $id_cliente_sesion;
					if ((int)$registro_dir['id_direccion'])
						$oDb->tb_update("Direcciones_entrega",$registro_dir);
					else
						$oDb->tb_replace("Direcciones_entrega",$registro_dir);
					return;
				}
			}
			if (isset($registro) AND is_array($registro)) {
				if(!(is_object($db_conf))) {
					$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
					return ;
				}

				if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {

					$oUsr = $Sesion->get_authed_user();
					if (is_array($cli_user) AND sizeof($cli_user) AND (!empty($cli_user['login']) OR !empty($cli_user['id_usr'])) ) {
						if (!empty($cli_user['passwd']) AND strcmp($cli_user['passwd'],$cli_user['passwd2']))
							$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $cli_user['login']));
						else {
							$cli_user['activo'] = (int)$cli_user['activo'];
							if (empty($cli_user['nombre'])) $cli_user['nombre'] = $registro['razon_social'];
							$idu = $oUsr->dbReplaceUser($cli_user,'Clientes');
							if (empty($idu)) $registro2['id_usr'] = 'null';
							elseif ($idu > 0) $registro2['id_usr'] = $idu;
						}
					}

					$oDb->tb_update("Clientes",$registro);
				}

				if ($Sesion->verifyVar('registro2',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro2',IKRN_VAR_CRC_AUTHED)) {
					if (!is_numeric($registro2['id_cliente']) OR empty($registro2['id_cliente']))
						$registro2["fecha_alta"]=date('Y-m-d H:i:s');
					$usuario = identifica_usuarios($Sesion);
					$registro2["id_empresa"]=$usuario['id'];
					$registro2['mostrar_ofertas'] = (int) $registro2['mostrar_ofertas'];
					$registro2['aplicar_dto_vol'] = (int) $registro2['aplicar_dto_vol'];
					$registro2['aplicar_retencion'] = (int) $registro2['aplicar_retencion'];
					$registro2['referencias_propias'] = (int) $registro2['referencias_propias'];

					// Formateando las CuentaContables y Dandolas de Alta
					$aCamposCC = array();
					foreach ($registro2 as $campo => $valor) 
						if (!strcasecmp(substr($campo,0,3),'cc_')) {
							array_push($aCamposCC,$campo);
						}
					if (sizeof($aCamposCC)) {
						$oDb_cfg = $Sesion->get_db('conf');
						$aCfg = $Sesion->get_var('_aAppConf');
						$icontadb = $aCfg['iconta_dbname'];
						$id_ej = $aCfg['iconta_ejercicio'];
						$id_emp_ej = NULL;
						if (!empty($icontadb) AND !empty($id_ej) ) {
							$oDb_ic = $Sesion->get_db($icontadb);
							foreach ($aCamposCC as $campo) {
								if (!empty($registro2[$campo]) AND is_numeric($registro2[$campo]) AND strcasecmp($registro2[$campo],$cc_old[$campo])) {
									if (!$id_emp_ej) {
										$tmprs = $oDb_ic->query('SELECT id_empresa FROM Ejercicios WHERE id_ejercicio = '.$id_ej);
										if (!$oDb_ic->num_rows($tmprs)) continue;
										$aTmp = $oDb_ic->fetch_row($tmprs);
										$id_emp_ej = $aTmp[0];
										$aTmp = NULL;
										$oDb_ic->libera($tmprs);
									}
									$aTmp = AccountEntry::filterAccount($registro2[$campo],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
									$tmprs = $oDb_ic->query("SELECT * FROM Cuenta_contable WHERE id_plan_contable = ".$aTmp[0].' AND id_cuenta = '.$aTmp[1].
												' AND id_empresa = '.$id_emp_ej);
									if (!$oDb_ic->num_rows($tmprs)) {
										$aTmpReg['id_cuenta'] = $aTmp[1];
										$aTmpReg['id_plan_contable'] = $aTmp[0];
										$aTmpReg['nombre'] = $registro['razon_social'].' ('.$registro['cif'].')';
										$aTmpReg['id_empresa'] = $id_emp_ej;
										$oDb_ic->tb_replace('Cuenta_contable',$aTmpReg);
										$aTmpReg = NULL;
									}
									$registro2[$campo] = $aTmp[0].$aTmp[1];
									$oDb_ic->libera($tmprs);
								} elseif (empty($registro2[$campo])) $registro2[$campo] = 'null';
							}
						}
					}
												
					if (is_array($acciones) AND sizeof($acciones)) {
						if (is_numeric($acciones['descartar_usuario_crm'])) $registro2['crm_id_usuario'] = 'null';
					}

					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) $registro2 = $oPer->getAssignments($registro2,'Clientes_empresas');
					$oDb->tb_update("Clientes_empresas",$registro2);
				}

				$Sesion->set_var("id_cliente_promocion",$registro["id_cliente"]);
				$id_cliente = $registro['id_cliente'];

				if ($Sesion->verifyVar('registro2',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro2',IKRN_VAR_CRC_AUTHED)) {
					if (is_array($Agentes) AND sizeof($Agentes)) {
						foreach ($Agentes as $id_agente => $aReg) {
							$aReg['id_cliente'] = $id_cliente;
							$aReg['id_agente'] = $id_agente;
							if (!is_numeric($aReg['comision'])) $aReg['comision'] = 'null';
							if (!is_numeric($aReg['comision_repartida'])) $aReg['comision_repartida'] = 'null';
							$oDb->tb_update("Agentes_clientes",$aReg);
						}
					}
				}
			} elseif (isset($id_recomendador) AND is_numeric($id_recomendador)) {
				$oDb->tb_update("Clientes_empresas",
						array('id_empresa' => $id_empresa, 'id_cliente' => $id_cliente, 'id_recomendador' => $id_recomendador));
			}

			if ($Sesion->verifyVar('registroNN',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registroNN',IKRN_VAR_CRC_AUTHED)) {
				// Nuevo Agente para un cliente
				if (isset($registroNN) AND is_array($registroNN['agentes']) AND sizeof($registroNN['agentes'])) {
					foreach ($registroNN['agentes'] as $id_ag => $bool)
						if ( (!is_array($registroNN['agentes_prev']) OR !is_numeric($registroNN['agentes_prev'][$id_ag])) AND (int)$bool)
							$oDb->tb_replace("Agentes_clientes",array('id_cliente' => $id_cliente, 'id_agente' => $id_ag,'fecha_captacion' => date('Y-m-d H:m:i')));
				}
			}
		break;
			  
		case "Nuevo" :
		   if ($Sesion->verifyVar('registro_dir',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro_dir',IKRN_VAR_CRC_AUTHED)) {
			   //Nueva direccion
			   if(isset($registro_dir)){
				   $registro_dir["id_cliente"] = $id_cliente_sesion;
				   $oDb->tb_replace("Direcciones_entrega",$registro_dir);
				   return;
			   }
			}
		   if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
			   //Nuevo cliente
			   if(isset($registro)){
	   //operaciones de login
					$oUsr = $Sesion->get_authed_user();
					if (is_array($cli_user) AND sizeof($cli_user) AND (!empty($cli_user['login']) OR !empty($cli_user['id_usr'])) ) {
						if (!empty($cli_user['passwd']) AND strcmp($cli_user['passwd'],$cli_user['passwd2']))
							$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $cli_user['login']));
						else {
							if (empty($cli_user['nombre'])) $cli_user['nombre'] = $registro['razon_social'];
							$idu = $oUsr->dbReplaceUser($cli_user,'Clientes');
							if (empty($idu)) $registro2['id_usr'] = 'null';
							elseif ($idu > 0) $registro2['id_usr'] = $idu;
						}
					}

	   //propias del cliente
				    $registro["fecha_alta"]=date("Y-m-d H:i:s");
		   //                depurar_array($registro);
				    $oDb->tb_replace("Clientes",$registro);
				    //Casos especiales con los registros
				    $id_cliente = $oDb->last_insert_id();

				    $registro2["id_cliente"]=$id_cliente;
				    $registro2["fecha_alta"]=date("Y-m-d H:i:s");
				    $usuario = identifica_usuarios($Sesion);
				    $registro2["id_empresa"]=$usuario['id'];

					$aCamposCC = array();
					foreach ($registro2 as $campo => $valor) 
						if (!strcasecmp(substr($campo,0,3),'cc_')) {
							array_push($aCamposCC,$campo);
						}
					if (sizeof($aCamposCC)) {
						$oDb_cfg = $Sesion->get_db('conf');
						$aCfg = $Sesion->get_var('_aAppConf');
						$icontadb = $aCfg['iconta_dbname'];
						$id_ej = $aCfg['iconta_ejercicio'];
						$id_emp_ej = NULL;
						if (!empty($icontadb) AND !empty($id_ej) ) {
							$oDb_ic = $Sesion->get_db($icontadb);
							foreach ($aCamposCC as $campo) {
								if (!empty($registro2[$campo]) AND is_numeric($registro2[$campo]) AND strcasecmp($registro2[$campo],$cc_old[$campo])) {
									if (!$id_emp_ej) {
										$tmprs = $oDb_ic->query('SELECT id_empresa FROM Ejercicios WHERE id_ejercicio = '.$id_ej);
										if (!$oDb_ic->num_rows($tmprs)) continue;
										$aTmp = $oDb_ic->fetch_row($tmprs);
										$id_emp_ej = $aTmp[0];
										$aTmp = NULL;
										$oDb_ic->libera($tmprs);
									}
									$aTmp = AccountEntry::filterAccount($registro2[$campo],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
									$tmprs = $oDb_ic->query("SELECT * FROM Cuenta_contable WHERE id_plan_contable = ".$aTmp[0].' AND id_cuenta = '.$aTmp[1].
												' AND id_empresa = '.$id_emp_ej);
									if (!$oDb_ic->num_rows($tmprs)) {
										$aTmpReg['id_cuenta'] = $aTmp[1];
										$aTmpReg['id_plan_contable'] = $aTmp[0];
										$aTmpReg['nombre'] = $registro['razon_social'].' ('.$registro['cif'].')';
										$aTmpReg['id_empresa'] = $id_emp_ej;
										$oDb_ic->tb_replace('Cuenta_contable',$aTmpReg);
										$aTmpReg = NULL;
									}
									$registro2[$campo] = $aTmp[0].$aTmp[1];
									$oDb_ic->libera($tmprs);
								} elseif (empty($registro2[$campo])) $registro2[$campo] = 'null';
							}
						}
					}

					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) $registro2 = $oPer->getAssignments($registro2,'Clientes_empresas');
					if (!$oDb->tb_replace("Clientes_empresas",$registro2))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Clientes_empresas'));
					$Sesion->set_var("id_cliente_promocion",$id_cliente);
					$Sesion->set_var("id_cliente",$id_cliente);

					if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
						$id_ag = $usuario['valor'];
						$oDb->tb_replace('Agentes_clientes',array('id_cliente' => $id_cliente, 'id_agente' => $id_ag));
					}

				    //meter una direccion por defecto
				    $registro_dir['id_cliente'] = $id_cliente;
				    $registro_dir['nombre'] = $registro['razon_social'];
				    $registro_dir['cp'] = $registro['cp'];
				    $registro_dir['id_provincia'] = $registro['id_provincia'];
				    $registro_dir['poblacion'] = $registro['poblacion'];
				    $registro_dir['email'] = $registro['email'];
				    $registro_dir['telefono1'] = $registro['telefono1'];
				    $registro_dir['fax'] = $registro['fax'];
				    $registro_dir['direccion'] = $registro['direccion_facturacion'];
				    $registro_dir['persona_contacto'] = $registro['persona_contacto'];
				    $registro_dir['cargo_persona_contacto'] = $registro['cargo_persona_contacto'];
				    $oDb->tb_replace("Direcciones_entrega",$registro_dir);

				   return;
			   }
		   }
			break;

		case "AbonarEfectos" :
			$efectos = $Sesion->fetchVar('efectos','POST');
			if ($Sesion->verifyVar('efectos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('efectos',IKRN_VAR_CRC_AUTHED)) {
				$aCfg = $Sesion->get_var('_aAppConf');
				foreach ($efectos as $id_efecto => $aEff) {
					if (is_numeric($aEff['importe']) AND is_numeric($id_efecto)) {
						$oEfecto = new Draft ($Sesion->App_Name);
						$oEfecto->dbFill($id_efecto);
						$oEfecto->setAccounting($aCfg['iconta_dbname'],$aCfg['iconta_dbcfgname'],$aCfg['iconta_ejercicio']);
						$oEff = &$oEfecto->getPartialDrafts();
						if (is_object($oEff)) {
							$aTmp['id_efecto'] = $id_efecto;
							$aTmp['monto_satisfecho'] = $aEff['importe'];
							$aTmp['medio_pago'] = $aEff['medio_pago'];
							$aTmp['notas'] = $aEff['notas'];
							$aTmp['id_cita'] = $id_cita;
							$oEff->insert($aTmp);
						}
						$oEfecto->Dump();
						$oEff = NULL;
						$oEfecto = NULL;
					}
				}
			}
			break;
			  
		case "Importar" :
			//si estamos metiendo un cliente nuevo ,
			if(isset($importar_clientes)){
				foreach($importar_clientes as $clave => $valor)
					if ($valor == 1) {
						$nuevo = array();
						$nuevo['id_cliente'] = $clave;
						$nuevo['id_empresa'] = $usuario['id'];
						$nuevo['fecha_baja'] = 'null';
						$nuevo['id_dia_baja'] = 'null';
						$oDb->tb_update("Clientes_empresas",$nuevo);
					}
			}
			if(isset($id_recomendador)){
				$oDb->tb_update('Clientes_empresas',array('id_recomendador' => $id_recomendador, 'id_cliente' => $id_cliente_sesion,'id_empresa' => $id_empresa));
			}
		break;

		case "Baja" :
			if(isset($borrar_clientes)){
				$aCli = array();
				foreach($borrar_clientes as $clave => $valor)
					if($valor == 1 ){
						$aTmp['id_cliente'] = $clave;
						$aTmp['id_empresa'] = $usuario['id'];
						array_push($aCli,$aTmp);
					}
				if (is_array($aCli) AND sizeof($aCli)) {
					$aTmp = array('fecha_baja' => date("Y-m-d H:i:s"));
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments($aTmp,'Clientes_empresas');
					$oDb->tb_update('Clientes_empresas',$aTmp,$aCli);
				}
			}
		break;

		case "Borrar" :
			if(isset($borrar_clientes)){
				foreach($borrar_clientes as $clave => $valor)
					if($valor == 1 ){
						$oDb->tb_delete('Clientes_empresas',array('id_cliente' => $clave, 'id_empresa' => $usuario['id']));
					}
			}
			if(isset($borrar_direcciones)){
				foreach($borrar_direcciones as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Direcciones_entrega where Direcciones_entrega.id_direccion = $clave";
						$oDb->query($consulta);
					}
			}
			if (isset($borrar_agentes) AND is_array($borrar_agentes) AND sizeof($borrar_agentes)) {
				foreach ($borrar_agentes as $id_ag => $bool)
					if ((int)$bool) $oDb->tb_delete("Agentes_clientes",
							array("id_agente" => $id_ag, 'id_cliente' => $id_cliente) );
				/** ** Todavia no, habria que incrementar una clave en Agentes_clientes -paso-
				  if ((int)$bool) $oDb->tb_update("Agentes_clientes",
				  array("id_agente" => $id_ag, 'id_cliente' => $id_cliente, 'fecha_fin' => date('Y-m-d H:i')));
				/** **/
			}
		break;

		case 'Seleccion_usuario_crm' :
			$usuario_seleccionado = $Sesion->fetchVar('usuario_seleccionado','POST');
			if (is_numeric($id_cliente) and is_numeric($usuario_seleccionado) AND is_numeric($id_empresa)) {
				$oDb->tb_update('Clientes_empresas',array('id_cliente'=>$id_cliente,'crm_id_usuario'=>$usuario_seleccionado,'id_empresa'=>$id_empresa));
			}
			break;

		case 'NuevoContacto' :
		   if ($Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($id_cliente) AND is_numeric($id_empresa) AND is_array($contactos) AND sizeof($contactos) ) {
					$contactos['id_cliente'] = $id_cliente;
					$contactos['id_empresa'] = $id_empresa;
					$oDb->tb_insert('Cliente_contactos',$contactos);
				}
			}
			break;

		case 'ModificarContacto' :
		   if ($Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($contactos) AND sizeof($contactos) AND $id_cliente==$contactos['id_cliente'] AND $id_empresa==$contactos['id_empresa'] 
						AND is_numeric($contactos['id_contacto']) ) {
					$oDb->tb_update('Cliente_contactos',$contactos);
				}
			}
			break;

		case 'BorrarContactos' :
		   if ($Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_contactos',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($contactos) AND sizeof($contactos))
					foreach ($contactos as $aCto) 
						if ((int)$aCto['id_contacto']) {
							$oDb->tb_delete('Cliente_contactos',$aCto);
						}
			}
			break;

		case 'NuevoEnlace' :
		   if ($Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($id_cliente) AND is_numeric($id_empresa) AND is_array($enlaces) AND sizeof($enlaces) ) {
					$enlaces['id_cliente'] = $id_cliente;
					$enlaces['id_empresa'] = $id_empresa;
					$oDb->tb_insert('Cliente_enlaces',$enlaces);
				}
			}
			break;

		case 'ModificarEnlace' :
		   if ($Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($enlaces) AND sizeof($enlaces) AND $id_cliente==$enlaces['id_cliente'] AND $id_empresa==$enlaces['id_empresa'] 
						AND is_numeric($enlaces['id_enlace']) ) {
					$oDb->tb_update('Cliente_enlaces',$enlaces);
				}
			}
			break;

		case 'BorrarEnlaces' :
		   if ($Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cliente_enlaces',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($enlaces) AND sizeof($enlaces))
					foreach ($enlaces as $aEnl) 
						if ((int)$aEnl['id_enlace']) {
							$oDb->tb_delete('Cliente_enlaces',$aEnl);
						}
			}
			break;

	}//fin del case

}//fin del precode

function pre_notas(&$Sesion) {
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$notas = $Sesion->fetchVar('cliente_notas','POST');

	$aUsr = identifica_usuarios($Sesion);
	$id_cliente = id_entidad($Sesion,'id_cliente');
	$id_empresa = $Sesion->get_var('id_empresa');
	$oDb = $Sesion->get_db('data');

	switch ($accion) {
		case 'NuevaNotaCliente':
			if (is_array($notas) AND sizeof($notas) AND is_numeric($id_cliente) AND is_numeric($id_empresa) ) {
				$notas['nota'] = trim($notas['nota']);
				if (!empty($notas['nota'])) {
					$notas[$aUsr['campo']] = $aUsr['valor'];
					$notas['id_cliente'] = $id_cliente;
					$notas['id_empresa'] = $id_empresa;
					$notas['fecha'] = date('Y-m-d H:i');
					$oDb->tb_insert('Cliente_notas',$notas);
				}
			}
			break;

		case 'Borrar':
			if (is_array($notas) AND sizeof($notas)) 
				foreach ($notas as $id => $aNota)
					if (is_numeric($aNota['id_nota_cliente']) AND $id == $aNota['id_nota_cliente'])
						$oDb->tb_delete('Cliente_notas',array('id_nota_cliente' => $id));
			break;
	}

}

function pre_cliente_servicios(&$Sesion) {
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$recursos = $Sesion->fetchVar('clientes_recursos','POST');

	$aUsr = identifica_usuarios($Sesion);
	$id_cliente = id_entidad($Sesion,'id_cliente');
	$id_empresa = $Sesion->get_var('id_empresa');
	$oDb = $Sesion->get_db('data');

	switch ($accion) {
		case 'NuevoServicio':
			if (is_array($recursos) AND sizeof($recursos) AND is_numeric($id_cliente) AND is_numeric($id_empresa) ) {
				foreach ($recursos as $aRec ) {
					if ((int)$aRec['insert'] AND is_numeric($aRec['id_recurso']) AND is_numeric($aRec['id_articulo']) ) {
						$aRec['notas'] = trim($aRec['notas']);
						$aRec['id_cliente'] = $id_cliente;
						$aRec['id_empresa'] = $id_empresa;
						$aRec['fecha_inicio'] = date('Y-m-d H:i');
						$oDb->tb_insert('Clientes_recursos',$aRec);
					}
				}
			}
			break;

		case 'Modificar':
			if (is_array($recursos) AND sizeof($recursos) AND 
					is_numeric($recursos['id_cliente_recurso']) AND is_numeric($recursos['id_cliente']) AND is_numeric($recursos['id_empresa']) ) {
				$oDb->tb_update('Clientes_recursos',$recursos);
			}
			break;

		case 'Borrar':
			if (is_array($recursos) AND sizeof($recursos)) 
				foreach ($recursos as $id => $aRec)
					if (is_numeric($aRec['id_cliente_recurso']) AND $id == $aRec['id_cliente_recurso'])
						$oDb->tb_delete('Clientes_recursos',array('id_cliente_recurso' => $id));
			break;
	}

}

function pre_ficha_servicio_cliente(&$Sesion) {
	$id = $Sesion->fetchVar('id','GET POST SESSION');
	if (is_numeric($id)) $Sesion->set_var('id',$id,'SUBSECCION');
}

function pre_nuevo_servicio_cliente(&$Sesion) {
	$articulos = $Sesion->fetchVar('selecciones','POST');
	if (!is_array($articulos) AND is_numeric($articulos)) $aArt = array($articulos);
	else $aArt = $articulos;
	$id_empresa = $Sesion->get_var('id_empresa');

	if (is_array($aArt) AND sizeof($aArt)) {
		foreach ($aArt as $id) $str_where .= ( (!empty($str_where)) ? ' AND ' : ' ' ).'Articulos_recursos.id_articulo = '.$id;
		if (!empty($str_where)) $Sesion->set_var('wr_lista_articulos','Articulos_recursos.id_empresa = '.$id_empresa.' AND '.$str_where,'SUBSECCION');
		else $Sesion->set_var('wr_lista_articulos','Articulos_recursos.id_articulo = 0','SUBSECCION');
	} else $Sesion->set_var('wr_lista_articulos','Articulos_recursos.id_articulo = 0','SUBSECCION');

}

function obtener_provincia(&$Sesion,&$aDatos){
	$Sesion->set_var("Provincias",$aDatos["Clientes.id_provincia"],"EXPIRE");
}
function chequear_provincia(&$Sesion,&$aDatos){
	$registro=$Sesion->fetchVar('registro','POST');
	if($Sesion->get_var("Provincias")==$aDatos["Provincias.id_provincia"]) return 'selected="selected"';
}

function dar_ofertas_promociones($Sess,$aDatos){
	if((int)$aDatos["Clientes.ofertas_promociones"]) return 'checked="checked"';
}


function obtener_tarifas(&$Sesion,&$aDatos){
	$Sesion->set_var("Tarifas",$aDatos["Clientes_empresas.id_tarifa"],"EXPIRE");
}

function chequear_tarifas(&$Sesion,&$aDatos){
	if($Sesion->get_var("Tarifas")==$aDatos["Tarifas.id_tarifa"]) return 'selected="selected"';
}

function obtener_forma_pago(&$Sesion,&$aDatos){
	$Sesion->set_var("Forma_pago",$aDatos["Clientes_empresas.id_forma_pago"],"EXPIRE");
}

function chequear_forma_pago(&$Sesion,&$aDatos){
	if($Sesion->get_var("Forma_pago")==$aDatos["Forma_pago.id_forma_pago"]) return 'selected="selected"';
}

function obtener_divisa(&$Sesion,&$aDatos){
	$Sesion->set_var("Divisa",$aDatos["Clientes_empresas.id_divisa"],"EXPIRE");
}

function chequear_divisa(&$Sesion,&$aDatos){
	if($Sesion->get_var("Divisa")==$aDatos["Divisa.id_divisa"]) return 'selected="selected"';
}

function obtener_tipo_cliente(&$Sesion,&$aDatos){
	$Sesion->set_var("Tipo_cliente",$aDatos["Clientes_empresas.id_tipo_cliente"],"EXPIRE");
}

function chequear_tipo_cliente(&$Sesion,&$aDatos){
	if($Sesion->get_var("Tipo_cliente")==$aDatos["Tipo_cliente.id_tipo_cliente"]) return 'selected="selected"';
}

function chequear_mostrar(&$Sesion,&$aDatos){
	if($aDatos["Clientes_empresas.mostrar_ofertas"]==1) return 'checked="checked"';
}

function recomendador(&$Sesion,&$aDatos){
	if($aDatos["Clientes_empresas.id_recomendador"]){
		$consulta="select nombre, apellidos from Clientes where id_cliente=".$aDatos["Clientes_empresas.id_recomendador"];
		$rs=$Sesion->query($consulta);
		$row=$Sesion->fetch_row($rs);
		return $row[0]." ".$row[1];
	}
}

function chequear_activo(&$Sesion,$aDatos){
	if($aDatos["Clientes_empresas.activo"]==1) return 'checked="checked"';
	else {
		$activo = array_shift($aDatos);
		return ( ((int)$activo) ? "checked" : NULl );
	}
}


function cliente_empresa(&$Sesion,&$aDatos){
	$usuario = identifica_usuarios($Sesion);
	$id_cli = $aDatos["Clientes.id_cliente"];
	$consulta = "select id_empresa from Clientes_empresas where id_cliente = $id_cli";
	$rs=$Sesion->query($consulta);
	while($row=$Sesion->fetch_array($rs)){
		if($row['id_empresa'] == $usuario['id']){
			return 0;
		}
	}
	return 1;
}

function dar_aplicar_recargo2($Sess,$aDatos){
	if((int)$aDatos["Clientes_empresas.aplicar_retencion"]) return 'checked="checked"';
}

function nombre_login_real(&$Sesion,$aDatos) {
	$usuario = identifica_usuarios($Sesion);
	$db_conf = $Sesion->get_db('conf');
	if(is_object($db_conf))
		if($aDatos["Clientes_empresas.id_usr"] != 0){
			$consulta = "select login,av_group from Users where id_usr =" . $aDatos["Clientes_empresas.id_usr"];
			$rs = $db_conf->query($consulta);
			$row = $db_conf->fetch_row($rs);
			$Sesion->set_var("usr_mask",$row[1],"INMED");
			return $row[0];
		} else {
			$id_usr = array_shift($aDatos);
			$consulta = "select login,av_group from Users where id_usr =".$id_usr;
			$rs = $db_conf->query($consulta);
			$row = $db_conf->fetch_row($rs);
			$Sesion->set_var("usr_mask",$row[1],"INMED");
			return $row[0];
		}
}

?>
