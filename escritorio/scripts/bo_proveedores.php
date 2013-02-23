<?php
/** Funciones accesibles para proveedores
global $accion_ejecutar;
global $id_proveedor;
global $registro;
global $registro2;
global $proveedor_importar;
global $proveedor_borrar;
global $proveedor_borrar2;

Acciones : Modificar , Importar , Nuevo , Borrar (desde nuevo y desde importar , interesante ver el tratamiento de los borrados)
*/
function pre_proveedores(&$Sesion) {
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$acciones=$Sesion->fetchVar('acciones','POST');
	$id_proveedor=$Sesion->fetchVar('id_proveedor','GET');
	$registro=$Sesion->fetchVar('registro','POST');
	$registro2=$Sesion->fetchVar('registro2','POST');
	$prov_user=$Sesion->fetchVar('prov_user','POST');
	$cc_old=$Sesion->fetchVar('cc_old','POST');
	$proveedor_importar=$Sesion->fetchVar('proveedor_importar','POST');
	$proveedor_borrar=$Sesion->fetchVar('proveedor_borrar','POST');
	$proveedor_borrar2=$Sesion->fetchVar('proveedor_borrar2','POST');

	$usuario = identifica_usuarios($Sesion);
	$Sesion->set_var("id_empresa",$usuario['id']);
	$id_empresa = $usuario['id'];
	$oDb = $Sesion->get_db('data');
	$db_conf = $Sesion->get_db('conf');

	$aMasks = $Sesion->get_var("_aMasks");
	if (!is_array($aMasks) OR !is_numeric($aMasks['proveedor'])) {
		$cons = "SELECT mascara FROM Groups WHERE nombre = 'Proveedores'";
		$rs = $db_conf->query($cons);
		if ($db_conf->num_rows($rs)) {
			$aTmp = $db_conf->fetch_assoc($rs);
			$group_mask = $aTmp['mascara'];
			$aMasks['proveedor'] = $group_mask;
			$Sesion->set_var("_aMasks",$aMasks,"NOEXPIRE");
		} 
	} else $group_mask = $aMasks['proveedor'];
	$Sesion->set_var("group_mask",$aMasks['proveedor'],"INMED");

	$id_proveedor = id_entidad($Sesion,'id_proveedor',$id_proveedor);
	enlazar_crm($Sesion);

	switch($accion_ejecutar){
		case "Importar" :
			if(isset($proveedor_importar)){
				foreach($proveedor_importar as $clave => $valor)
					if(is_numeric($valor) AND !empty($valor) AND $valor==$id_empresa ){
						$oDb->tb_update("Proveedores_empresas",array('fecha_baja' => 'null', 'id_dia_baja' => 'null', 'id_proveedor' => $clave, 'id_empresa' => $id_empresa));
					}
			}
		break;

		case "Borrar" :
			if(isset($proveedor_borrar)){
				//        debug("Borrando");
				foreach($proveedor_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="select id_usr from Proveedores_empresas where id_proveedor =$clave and id_empresa  = $usuario[id]";
						$rs = $oDb->query($consulta);
						$row = $oDb->fetch_row($rs);

						if (is_numeric($row[0]) AND !empty($row[0])) {
							$consulta='UPDATE Users SET activo = 0 WHERE id_usr = '.$row[0];
							$db_conf->query($consulta);
						}

						$aTmp['fecha_baja'] = date('Y-m-d H:i');
						$aTmp['id_proveedor'] = $clave;
						$aTmp['id_empresa'] = $usuario['id'];
						if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
						if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments($aTmp,'Proveedores_empresas');
						$oDb->tb_update('Proveedores_empresas',$aTmp);
					}
			}

			if(isset($proveedor_importar)){
				foreach($proveedor_importar as $clave => $valor)
					if($valor == 1 ){
						$consulta="select id_usr from Proveedores_empresas where id_proveedor =$clave and id_empresa  = $usuario[id] AND fecha_baja IS NOT NULL";
						$rs = $oDb->query($consulta);
						if ($oDb->num_rows($rs)) {
							$row = $oDb->fetch_row($rs);

							if (is_numeric($row[0]) AND !empty($row[0])) {
								$consulta='DELETE FROM Users WHERE id_usr = '.$row[0];
								$db_conf->query($consulta);
							}

							$consulta = 'DELETE FROM Proveedores_empresas WHERE Proveedores_empresas.id_proveedor = '.$clave.
											' AND Proveedores_empresas.id_empresa = '.$id_empresa;
							$oDb->query($consulta);
							$consulta='DELETE FROM Proveedores WHERE id_proveedor = '.$clave;
							$oDb->query($consulta);
						}
					}
			}
			break;

		case "Nuevo" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//si estamos metiendo un proveedor nuevo ,
				if($registro["passwd"] != "" AND $registro["login"] != "" AND 
						$registro["passwd2"] != "" AND( $registro["passwd2"] == $registro["passwd"]) ){
					if(is_object($db_conf)){
						$consulta="select login  from Users where login ='$registro[login]'";
						$rs = $db_conf->query($consulta);
						$row=$db_conf->fetch_array($rs);
						if($row){
							$Sesion->lcMessage('LCS_USR_EXISTS',array('login' => $registro['login']));
						} else {
							$user["nombre"] = $registro["login"] ;
							$user["login"] =  $registro["login"] ;
							$user["av_group"] =  $group_mask;
							$user["activo"] =  1;
							$db_conf->tb_replace("Users",$user);

							$consulta="select  id_usr from Users where login ='$registro[login]'";
							$r44s = $db_conf->query($consulta);
							$row2=$db_conf->fetch_array($r44s);
							$consulta="update Users set passwd=PASSWORD('$registro[passwd]') where login ='$registro[login]'";
							$db_conf->query($consulta);
							$registro2["id_usr"]=$row2[0];
						}
					} else {
						$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'),IM_FATALERROR);
						return ;
					}
				}

				if (!is_numeric($registro['id_proveedor'])) {
					$registro['fecha_alta'] = date("Y-m-d H:i");
					$registro2['fecha_alta'] =  date("Y-m-d H:i"); ;
					if (!$oDb->tb_replace("Proveedores",$registro)) 
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Proveedores'));
					$registro['id_proveedor'] = $oDb->last_insert_id();
				} else {
					$oDb->tb_update("Proveedores",$registro);
				}
			}

			$Sesion->set_var("id_proveedor_promocion",$registro['id_proveedor']);
			$Sesion->set_var("id_proveedor",$registro['id_proveedor']);
			if ($Sesion->verifyVar('registro2',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro2',IKRN_VAR_CRC_AUTHED)) {
				$usuario = identifica_usuarios($Sesion);
				$Sesion->set_var("id_empresa",$usuario['id']);

				$registro2['id_proveedor']= $registro['id_proveedor'];
				$registro2['id_empresa']= $usuario['id'];
				$registro2['activo']=1;

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
				if (is_a($oPer,'Periodo')) $registro2 = $oPer->getAssignments($registro2,'Proveedores_empresas');
				if (!$oDb->tb_replace("Proveedores_empresas",$registro2))
			  		$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Proveedores_empresas'));
			}
		break;

		case "Modificar" :
			if ($Sesion->verifyVar('prov_user',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('prov_user',IKRN_VAR_CRC_AUTHED)) {
				$registro2['activo'] = (int)$registro2['activo'];

				$oUsr = $Sesion->get_authed_user();
				if (is_array($prov_user) AND sizeof($prov_user)) {
					if (!empty($prov_user['passwd']) AND strcmp($prov_user['passwd'],$prov_user['passwd2']))
						$Sesion->lcMessage('LCS_USR_PASSWORDMISMATCH',array('login' => $prov_user['login']));
					else {
						if (is_numeric($prov_user['id_usr']) OR !empty($prov_user['login'])) {
							$idu = $oUsr->dbReplaceUser($prov_user,'Proveedores');
							if (empty($idu) OR $idu < 0 ) $registro2['id_usr'] = 'null';
							elseif ($idu > 0) $registro2['id_usr'] = $idu;
						}
					}
				}
			}

			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($registro['id_proveedor'])) {
					$oDb->tb_update("Proveedores",$registro);
				} else {
					if (!$oDb->tb_replace("Proveedores",$registro)) $Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Proveedores'));
				}
			}

			if ($Sesion->verifyVar('registro2',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro2',IKRN_VAR_CRC_AUTHED)) {
				$registro2['id_proveedor']= $registro['id_proveedor'];
				$registro2['id_empresa']= $usuario['id'];

				$registro2['aplicar_recargo'] = (int) $registro2['aplicar_recargo'];
				$registro2['aplicar_retencion'] = (int) $registro2['aplicar_retencion'];
				$registro2['aplicar_iva'] = (int) $registro2['aplicar_iva'];
				$registro2['comunitario'] = (int) $registro2['comunitario'];
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
				if (is_a($oPer,'Periodo')) $registro2 = $oPer->getAssignments($registro2,'Proveedores_empresas');
				// Formateando las CuentaContables y Dandolas de Alta
				if (is_numeric($registro2['id_proveedor'])) {
					$oDb->tb_update("Proveedores_empresas",$registro2);
				} else {
					if (!$oDb->tb_replace("Proveedores_empresas",$registro2)) $Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Proveedores_empresas'));
				}
			}
			break;

			case 'Seleccion_usuario_crm' :
				$usuario_seleccionado = $Sesion->fetchVar('usuario_seleccionado','POST');
				if (is_numeric($id_proveedor) and is_numeric($usuario_seleccionado) AND is_numeric($id_empresa)) {
					$oDb->tb_update('Proveedores_empresas',array('id_proveedor'=>$id_proveedor,'crm_id_usuario'=>$usuario_seleccionado,'id_empresa'=>$id_empresa));
				}
			break;
		}//fin del switch

	if (is_numeric($id_proveedor)) $Sesion->set_var('id_proveedor',$id_proveedor);

}//fin del precode

function obtener_Provincias(&$Sesion,&$aDatos){
	$Sesion->set_var("Provincias",$aDatos["Proveedores.id_provincia"],"EXPIRE");
}

function chequear_Provincias(&$Sesion,&$aDatos){
	if($Sesion->get_var("Provincias")==$aDatos["Provincias.id_provincia"]) return 'selected="selected"';
}

function obtener_Divisa(&$Sesion,&$aDatos){
	$Sesion->set_var("Divisa",$aDatos["Proveedores_empresa.id_divisa"],"EXPIRE");
}
function chequear_Divisa(&$Sesion,&$aDatos){
	if($Sesion->get_var("Divisa")==$aDatos["Proveedores_empresa.id_divisa"]) return 'selected="selected"';
}

function obtener_Forma_pago(&$Sesion,&$aDatos){
	$Sesion->set_var("Forma_pago",$aDatos["Proveedores_empresas.id_forma_pago"],"EXPIRE");
}
function chequear_Forma_pago(&$Sesion,&$aDatos){
	if($Sesion->get_var("Forma_pago")==$aDatos["Forma_pago.id_forma_pago"]) return 'selected="selected"';
}
function obtener_activo(&$Sesion,&$aDatos){
	if($aDatos["Proveedores_empresas.activo"]) return 'checked="checked"';
}
function obtener_aplicar_iva(&$Sesion,&$aDatos){
	if($aDatos["Proveedores.aplicar_iva"]) return 'checked="checked"';
}
function obtener_aplicar_recargo(&$Sesion,&$aDatos){
	if($aDatos["Proveedores.aplicar_recargo"]) return 'checked="checked"';
}

function proveedor_empresa(&$Sesion,&$aDatos){
	$usuario = identifica_usuarios($Sesion);
	$id_cli = $aDatos["Proveedores.id_proveedor"];
	$consulta = "select id_empresa from Proveedores_empresas where id_proveedor = $id_cli";
	$rs=$Sesion->query($consulta);
	while($row=$Sesion->fetch_array($rs)){
		if($row['id_empresa'] == $usuario['id']){
			return 0;
		}
	}
	return 1;
}


function pre_compra_articulos(&$Sesion){
	$proovedores_articulo_borrar=$Sesion->fetchVar('proovedores_articulo_borrar','POST');
	$articulos_proveedor_importar=$Sesion->fetchVar('articulos_proveedor_importar','POST');
	$articulos_proveedor=$Sesion->fetchVar('articulos_proveedor','POST');

	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_proveedor=$Sesion->fetchVar('id_proveedor','GET');

	$articulos_proveedor_descuento=$Sesion->fetchVar('articulos_proveedor_descuento','POST');
	$articulos_proveedor_precio=$Sesion->fetchVar('articulos_proveedor_precio','POST');
	$articulos_proveedor_referencia=$Sesion->fetchVar('articulos_proveedor_referencia','POST');
	$articulos_proveedor_fabricante=$Sesion->fetchVar('articulos_proveedor_fabricante','POST');

	$id_proveedor = $id_proveedor_sesion = get_id_proveedor($Sesion);
	$oDb = $Sesion->get_db('data');

	// debug("acc: $accion_ejecutar");
	switch($accion_ejecutar) {
		case "Modificar" :
			if(isset($articulos_proveedor) AND is_array($articulos_proveedor) AND sizeof($articulos_proveedor)){
				foreach($articulos_proveedor as $idart => $aArt){
					$aArt['id_proveedor']=$id_proveedor_sesion;
					$aArt['id_articulo']=$idart;
					if (!$oDb->tb_replace("Compra_articulos",$aArt))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Compra_articulos'));
				}//fin del foreach
			}//fin del if
		break;

		case "Borrar" :
			if(isset($proovedores_articulo_borrar)){
				foreach($proovedores_articulo_borrar as $clave => $valor)
					if($valor == 1 ){
						$bDelete = true;
						$cons = 'SELECT COUNT(*) '.
									'FROM Compra_articulos Ca, Lineas_detalle Ld, Pedidos P '.
									'WHERE (P.id_pedido IS NOT NULL AND P.id_proveedor = Ca.id_proveedor) '.
									'AND (Ld.id_pedido=P.id_pedido AND Ld.id_articulo=Ca.id_articulo) '.
									'AND Ca.id_proveedor = '.$id_proveedor_sesion.' AND Ca.id_articulo = '.$clave;
						$tmprs = $oDb->query($cons);
						$aTmp = $oDb->fetch_row($tmprs);
						$oDb->libera($tmprs);
						if (!$aTmp[0]) {
							$cons = 'SELECT COUNT(*) '.
										'FROM Compra_articulos Ca, Lineas_detalle Ld, Facturas_detalle Fd, Facturas F '.
										'WHERE (F.id_factura IS NOT NULL AND F.id_proveedor = Ca.id_proveedor) '.
										'AND (Fd.id_factura=F.id_factura AND Fd.id_detalle=Ld.id_detalle AND Ld.id_articulo=Ca.id_articulo) '.
										'AND Ca.id_proveedor = '.$id_proveedor_sesion.' AND Ca.id_articulo = '.$clave;
							$tmprs=$oDb->query($cons);
							$aTmp = $oDb->fetch_row($tmprs);
							$oDb->libera($tmprs);
							if ($aTmp[0]) $bDelete = false;
						} else $bDelete = false;

						if (!$bDelete) {
							$oDb->tb_update('Compra_articulos',array('fecha_baja' => date('Y-m-d H:i'),'id_articulo' => $clave, 'id_proveedor' => $id_proveedor_sesion));
						} else {
							$oDb->tb_delete('Compra_articulos',array('id_articulo' => $clave, 'id_proveedor' => $id_proveedor_sesion));
						}
					}
			}
		break;

		case "Importar" :
			// debug("importamos $articulos_proveedor_precio");
			if(isset($articulos_proveedor_importar) AND is_array($articulos_proveedor_importar) AND sizeof($articulos_proveedor_importar) ){
				foreach($articulos_proveedor_importar as $idart => $valor){
					if(is_array($articulos_proveedor[$idart]) AND sizeof($articulos_proveedor) ){
						$aArt = $articulos_proveedor[$idart];
						$aArt['id_proveedor'] = $id_proveedor_sesion;
						$aArt['id_articulo'] = $idart;
						$aArt['fecha_baja'] = 'null';
						//print_r($aArt);
						/** **/
						if (!$oDb->tb_replace("Compra_articulos",$aArt))
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Compra_articulos'));
						/** **/
					}//fin del if
				}//fin del foreach
			}//fin del if
		break;

	}//fin de switch
}

function checked_fabricante(&$Sesion,&$aDatos){
	if($aDatos["Compra_articulos.fabricante"] == 1)
		return 'checked="checked"';
}

function cf_almacenar_articulos(&$Sesion,$aDatos) {
	static $aArts;
	if (!is_array($aArts)) $aArts = array();
	array_push($aArts,$aDatos['Compra_articulos.id_articulo']);
	$Sesion->set_var('_ArticulosProveedor',$aArts,'SECCION');
	return TRUE;
}

function articulo_proveedor(&$Sesion,&$aDatos){
	static $aArts;
	static $bDone = FALSE;

	if ($bDone) return FALSE;
	if (!is_array($aArts)) {
		$aArts = $Sesion->get_var('_ArticulosProveedor');
		if (!is_array($aArts)) {
			$aArts = array();
			$bDone = TRUE;
		}
	}
	return in_array($aDatos['Articulos.id_articulo'],$aArts);
}


function pre_pedidos_tipo_proveedor(&$Sesion) {
	$Borrar=$Sesion->fetchVar('Borrar','POST');
	$pedidos_tipo_proveedor=$Sesion->fetchVar('pedidos_tipo_proveedor_borrar','POST');
	$id_proveedor=$Sesion->fetchVar('id_proveedor','GET');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$usuario = identifica_usuarios($Sesion);

	$oDb = $Sesion->get_db('data');
	$id_proveedor_sesion = get_id_proveedor($Sesion);

	if(isset($accion_ejecutar) AND !strcasecmp($accion_ejecutar,'Borrar') ){
		if(isset($pedidos_tipo_proveedor)){
			foreach($pedidos_tipo_proveedor as $clave => $valor)
				if($valor == 1 ){
					$consulta='DELETE FROM Pedidos_tipo_proveedor WHERE Pedidos_tipo_proveedor.id_pedido = '.
								 $clave.' AND  Pedidos_tipo_proveedor.id_proveedor = '.$id_proveedor_sesion.
								 ' AND Pedidos_tipo_proveedor.id_empresa = '.$usuario['id'];
					$oDb->query($consulta);
				}

		}
	}//fin de borrar

}

function pre_pedido_proveedor(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$id_proveedor_sesion = get_id_proveedor($Sesion);
	$usuario = identifica_usuarios($Sesion);

	$Sesion->set_var("id_proveedor",$id_proveedor_sesion);
	$Sesion->set_var("id_pedido",$id_pedido);
	$Sesion->set_var("id_empresa",$usuario['id']);
	//debug("pro : $id_proveedor_sesion , ped $id_pedido , emp $usuario[id]");
}

function off_nombre_articulo2(&$Sesion,&$aDatos){
	$id_articulo = $aDatos["Lineas_detalle.id_articulo"];
	$consulta = "select Articulos.nombre  from Articulos where Articulos.id_articulo = $id_articulo";
	$resul = $Sesion->query($consulta);
	$row = $Sesion->fetch_array($resul);
	return $row[0];
}

function pre_pedidos_proveedor(&$Sesion){
	get_id_proveedor(&$Sesion);
}

function dar_estado($Sess,$aDatos){
	if((int)$aDatos["Pedidos.preparado"]) return "Recibido";
	else return "Pendiente";
}

function pre_factura_proveedor(&$Sesion) {
	$id_factura=$Sesion->fetchVar('id_factura','GET');
	$id_proveedor_sesion = get_id_proveedor($Sesion);
	$usuario = identifica_usuarios($Sesion);

	$Sesion->set_var("id_proveedor",$id_proveedor_sesion);
	$Sesion->set_var("id_proveedor_promocion",$id_proveedor_sesion);
	$Sesion->set_var("id_factura",$id_factura);
	$Sesion->set_var("id_empresa",$usuario['id']);

	//debug("cli : $id_cliente_sesion , factura $id_factura , emp $usuario[id]");
}

function nombre_login_real(&$Sesion,&$aDatos) {
	$usuario = identifica_usuarios($Sesion);
	$db_conf = $Sesion->get_db('conf');
	if(is_object($db_conf))
		if($aDatos["Proveedores_empresas.id_usr"] != 0){
			$consulta = "select login from Users where id_usr =" . $aDatos["Proveedores_empresas.id_usr"];
			$rs = $db_conf->query($consulta);
			$row = $db_conf->fetch_row($rs);
			return $row[0];
		}
}

function cf_pedidos(&$Sesion,&$aData) {
	$oDb = $Sesion->get_db('data');
	// Estado pedido:
	if ((int)$aData['Pedidos.id_pedido']) {
		$cons = "SELECT estado ".
			"FROM Facturas, Pedidos_facturas ".
			"WHERE Pedidos_facturas.id_factura = Facturas.id_factura AND ".
			"Pedidos_facturas.id_pedido = ".$aData['Pedidos.id_pedido'];
		$rsfact = $oDb->query($cons);
		$nfacts = (int)$oDb->num_rows($rsfact);
		if (!$nfacts) { 
			$aData['noborrar'] = 0;
			$aData['estado_factura'] = 'none';
			$aData['link_factura'] = 0;
		} else {
			$aData['link_factura'] = 1;
			$aDaba['noborrar'] = 0;
			while ($aTmp = $oDb->fetch_assoc($rsfact)) {
				$est_fact += $aTmp['estado'];
				if ((int)$aTmp['estado']) $aData['noborrar'] = (int)$aTmp['estado'];
			}
			if ($est_fact == $nfacts) $aData['estado_factura'] = 'ok';
			else $aData['estado_factura'] = 'do';
			$aTmp = NULL;
		}
		$oDb->libera($rsfact);

		$cons = "SELECT preparado,enviado,confirmacion,devolucion ".
			"FROM Albaranes ".
			"WHERE Albaranes.id_pedido = ".$aData['Pedidos.id_pedido'];
		$rsalb = $oDb->query($cons);
		$nalb = (int)$oDb->num_rows($rsalb);
		if (!$nalb) {
			$aData['estado_albaran'] = 'none';
			$aData['link_albaran'] = 0;
		} else {
			$aData['link_albaran'] = 1;
			while ($aTmp = $oDb->fetch_assoc($rsalb)) {
				$npreparados = $aTmp['preparado'];
				$nenviados = $aTmp['enviado'];
				$nconfirmados = $aTmp['confirmacion'];
				$ndevueltos = $aTmp['devolucion'];
			}
			if ($nalb == $npreparados) {
				if ($nalb == $nconfirmados) {
					$aData['estado_albaran'] = 'ok';
					$aData['estado_pedido'] = 'ok';
				} elseif ($ndevueltos > 0) {
					$aData['estado_albaran'] = 'bad';
				} elseif ($nalb == $nenviados) {
					$aData['estado_albaran'] = 'ok';
				} else $aData['estado_albaran'] = 'do';
			} else $aData['estado_albaran'] = 'none';
		}

		$est = $aData['Pedidos.preparado'];
		if ((int)$est AND empty($aData['estado_pedido'])) {
			if ($aData['estado_albaran']=='ok') $aData['estado_pedido'] = 'ok';
			else $aData['estado_pedido'] = 'do';
		} elseif ((int)$est) {
			$aData['estado_pedido'] = 'do'; 
		} else $aData['estado_pedido'] = 'none'; 

		/** **
		  $cons = "SELECT SUM(Lineas_detalle.monto_total) as 'monto_pedido' ".
		  "FROM Pedidos, Lineas_detalle ".
		  "WHERE Pedidos.id_pedido = Lineas_detalle.id_pedido AND ".
		  "Pedidos.id_pedido = ".$aData['Pedidos.id_pedido'];
		  $rsfact = $oDb->query($cons);
		  $nfacts = (int)$oDb->num_rows($rsfact);
		  if (!$nfacts) { 
		  $aData['monto_pedido'] = 0;
		  } else {
		  $aTmp = $oDb->fetch_row($rsfact);
		  $aData['monto_pedido'] = $aTmp[0];
		  }
		/** **/
	}
	return 1;
}

function obtener_id(&$Sesion) {
	$id=get_id_proveedor($Sesion);
}

function get_id_proveedor(&$Sesion) {
	$id_proveedor=$Sesion->fetchVar('id_proveedor','GET');

	$id_sess = $Sesion->get_var('id_proveedor_promocion');
	if (isset($id_proveedor) AND is_numeric($id_proveedor)) {
		$Sesion->set_var('id_proveedor_promocion',$id_proveedor);
		$Sesion->set_var('id_proveedor',$id_proveedor,'SECCION');
	} elseif (is_numeric($id_sess)) {
		$id_proveedor = $id_sess;
		$Sesion->set_var('id_proveedor',$id_proveedor,'SECCION');
		$Sesion->set_var('id_proveedor_promocion',$id_proveedor,'SECCION');
	}

	return $id_proveedor;
}

?>
