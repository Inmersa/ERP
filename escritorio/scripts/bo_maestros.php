<?php

function pre_maestro(&$Sesion) {
	$tabla = $Sesion->fetchVar('tb','POST');
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');

	if (empty($tabla) AND !empty($accion)) {
		return NULL;
	}
	$data = $Sesion->fetchVar($tabla,'POST');
	$lista = $Sesion->fetchVar('lista_'.$tabla,'POST');
	$newdata = $Sesion->fetchVar('nuevo','POST');

	$modo_seleccion = $Sesion->fetchVar('modo_seleccion','GET');
	if (!is_numeric($modo_seleccion)) $modo_seleccion = (int)$Sesion->get_var('modo_seleccion');

	if ((int)$modo_seleccion) {
		$sel_many = $Sesion->fetchVar('many','GET');
		if (!is_numeric($sel_many)) $sel_many = (int)$Sesion->get_var('modo_seleccion_varios');
	}

	$Sesion->set_var('modo_seleccion',$modo_seleccion,'SUBSECCION');
	$Sesion->set_var('modo_seleccion_varios',$sel_many,'SUBSECCION');

	$oDb = $Sesion->get_db('data');
	if (!empty($accion)) {
		$aKeys = $oDb->obtener_clave($tabla);
		if (!is_array($aKeys) OR !sizeof($aKeys)) {
			debug("Entidad sin claves ... ");
			return NULL;
		}
		$nKeys = sizeof($aKeys);
	}
	switch ($accion) {
		case 'ModificarLista':
			$bKeys = true;
			foreach ($aKeys as $key) 
				if (!is_numeric($data[$key])) {
					$bKeys = false;
					break;
				}

			if (!$bKeys) {
				foreach ($data as $idx => $aData) {
					$oDb->tb_replace($tabla,$aData);
					if ($nKeys==1) $data[$idx][$aKeys[0]] = $oDb->last_insert_id();
				}
			} else {
				foreach ($data as $idx => $aData) $oDb->tb_update($tabla,$aData);
			}
			break;

		case 'Modificar':
			$bKeys = true;
			foreach ($aKeys as $key) 
				if (!is_numeric($data[$key])) {
					$bKeys = false;
					break;
				}

			if (!$bKeys) {
				$oDb->tb_replace($tabla,$data);
				if ($nKeys==1) $data[$aKeys[0]] = $oDb->last_insert_id();
			} else $oDb->tb_update($tabla,$data);
			break;

		case 'Borrar':
			if (is_array($lista) AND sizeof($lista)) {
				if ($nKeys == 1) {
					$aDel = array();
					$key = $aKeys[0];
					foreach ($lista as $keyval) array_push($aDel,array($key => $keyval));
					if (sizeof($aDel)) $oDb->tb_delete($tabla,$aDel);
				}
			}
			break;

		case 'Nuevo':
			if (is_array($newdata) AND sizeof($newdata) AND !empty($newdata)) {
				debug("Insertando en $tabla ... ");
				print_r($newdata);
				$oDb->tb_insert($tabla,$newdata);
			}
			break;
	}
}

function pre_configuracion_general(&$Sesion) {
	$reg = $Sesion->fetchVar('_main','POST');
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$aCfg = $Sesion->get_var('_aAppConf');
	$aCheckboxes = array('print_observaciones_enlinea', 'print_invoice_delivery', 'deliverynote_priced', 'print_invoice_productids');

	$oDb = $Sesion->get_db('conf');

	switch ($accion) {
		case 'Modificar':
			if (is_array($reg) AND sizeof($reg)) {
				// Checkboxes:
				if (is_array($aCheckboxes) AND sizeof($aCheckboxes))
					foreach ($aCheckboxes as $checkfld) {
						$reg[$checkfld] = (int)$reg[$checkfld];
					}

				foreach ($reg as $campo => $valor) {
					if (empty($valor)) $valor = 'null';
					if (isset($aCfg[$campo]) ) {
						// debug("update ... ");
						$oDb->tb_update('_main',array('valor' => $valor),array('nombre' => 'cfg_app_'.$campo));
						$aCfg[$campo] = ( (!strcasecmp($valor,'null')) ? '' : $valor);
					} else {
						$oDb->tb_replace('_main',array('nombre' => 'cfg_app_'.$campo, 'valor' => $valor));
						$aCfg[$campo] = ( (!strcasecmp($valor,'null')) ? '' : $valor);
						// debug("Replace... ");
					}
				}

			}
			break;
	}

	if (!is_array($aCfg) OR !sizeof($aCfg)) {
		$cons = 'SELECT nombre,valor FROM _main WHERE nombre like "cfg_app_%"';
		$rs = $oDb->query($cons);
		if ($oDb->num_rows($rs))
			while ($aTmp = $oDb->fetch_assoc($rs)) {
				$aCfg[substr($aTmp['nombre'],8)] = $aTmp['valor'];
			}
	}
			
	if (is_array($aCfg) AND sizeof($aCfg)) $Sesion->set_var('_aAppConf',$aCfg,'NOEXPIRE');
}

function pre_grupos_rutas(&$Sesion) {
	$estado=$Sesion->fetchVar('estado','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$registro=$Sesion->fetchVar('registro','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipo_agente */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_grupo_ruta']))
					$oDb->tb_replace("Grupo_rutas",$registro);
				else
					$oDb->tb_update('Grupo_rutas',$registro);
			}
			break;

		case 2 : //borrado
			if(!$oDb->tb_delete("Grupo_rutas",array("id_grupo_ruta" => $registro['id_grupo_ruta']) )){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Grupo_rutas'));
				return;
			}
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1){
						$oDb->tb_delete("Grupo_rutas",array("id_grupo_ruta" => $clave));
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}

function pre_gastos(&$Sesion) {
	$estado=$Sesion->fetchVar('estado','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$registro=$Sesion->fetchVar('registro','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipo_agente */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_gasto']))
					$oDb->tb_replace("Gastos",$registro);
				else
					$oDb->tb_update('Gastos',$registro);
			}
			break;

		case 2 : //borrado
			if(!$oDb->tb_delete("Gastos",array("id_gasto" => $registro['id_gasto']) )){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Gastos'));
				return;
			}
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1){
						$oDb->tb_delete("Gastos",array("id_gasto" => $clave));
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}

function pre_medios_contacto(&$Sesion) {
	$estado=$Sesion->fetchVar('estado','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$registro=$Sesion->fetchVar('registro','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipo_agente */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (is_numeric($registro['id_medio_contacto']))
					$oDb->tb_update("Medios_contacto",$registro);
				else
					$oDb->tb_replace("Medios_contacto",$registro);
			}
			break;

		case 2 : //borrado
			if(!$oDb->tb_delete("Medios_contacto",array("id_medio_cto" => $registro['id_medio_cto']) )){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Medios_contacto'));
				return;
			}
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1){
						$oDb->tb_delete("Medios_contacto",array("id_medio_cto" => $clave));
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}

/** funciones de maestros **/
function pre_tipo_agente(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipo_agente */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_tipo_agente']))
					$oDb->tb_replace("Tipo_agente",$registro);
				else
					$oDb->tb_update('Tipo_agente',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Tipo_agente where id_tipo_agente = $registro[id_tipo_agente]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Tipo_agente'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Tipo_agente where Tipo_agente.id_tipo_agente = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_tipo_cliente(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipo_cliente */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_tipo_cliente']))
					$oDb->tb_replace("Tipo_cliente",$registro);
				else
					$oDb->tb_update('Tipo_cliente',$registro);
			}
			break;

		case 2 : //borrado
			$consulta="delete from Tipo_cliente where id_tipo_cliente = $registro[id_tipo_cliente]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Tipo_cliente'));
				return;
			}
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Tipo_cliente where Tipo_cliente.id_tipo_cliente = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_divisa(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Divisa */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_divisa']))
					$oDb->tb_replace("Divisa",$registro);
				else
					$oDb->tb_update('Divisa',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Divisa where id_divisa = $registro[id_divisa]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Divisa'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Divisa where Divisa.id_divisa = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_paises(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Paises */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_pais']))
					$oDb->tb_replace("Paises",$registro);
				else
					$oDb->tb_update('Paises',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Paises where id_pais = $registro[id_pais]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Paises'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Paises where Paises.id_pais = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_provincias(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Provincias */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_provincia']))
					$oDb->tb_replace("Provincias",$registro);
				else
					$oDb->tb_update('Provincias',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Provincias where id_provincia = $registro[id_provincia]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Provincias'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Provincias where Provincias.id_provincia = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_forma_pago(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Forma_pago */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_forma_pago']))
					$oDb->tb_replace("Forma_pago",$registro);
				else
					$oDb->tb_update('Forma_pago',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Forma_pago where id_forma_pago = $registro[id_forma_pago]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Forma_pago'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Forma_pago where Forma_pago.id_forma_pago = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_tarifas(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tarifas */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$registro['coniva_recomendacion'] = (int)$registro['coniva_recomendacion'];
				if (!is_numeric($registro['id_tarifa']))
					$oDb->tb_replace("Tarifas",$registro);
				else
					$oDb->tb_update('Tarifas',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Tarifas where id_tarifa = $registro[id_tarifa]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Tarifas'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Tarifas where Tarifas.id_tarifa = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_series_facturacion(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Series_facturacion */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$registro['ventas'] = (int)$registro['ventas'];
				$registro['contabilizable'] = (int)$registro['contabilizable'];
				if (!is_numeric($registro['id_serie']))
					$oDb->tb_replace("Series_facturacion",$registro);
				else
					$oDb->tb_update('Series_facturacion',$registro);
			}
			break;
		case 2 : //borrado
			$oDb->tb_delete("Series_facturacion",array("id_serie" => $registro['id_serie']));
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Series_facturacion WHERE Series_facturacion.id_serie = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_grupo_familias(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Grupo_familias */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (is_numeric($registro['id_grupo_familia']))
					$oDb->tb_update("Grupo_familias",$registro);
				else
					$oDb->tb_replace("Grupo_familias",$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Grupo_familias where id_grupo_familia= $registro[id_grupo_familia]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Grupo_familias'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Grupo_familias where Grupo_familias.id_grupo_familia = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_grupo_empresas(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Grupo_empresas */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_grupo_empresa']))
					$oDb->tb_replace("Grupo_empresas",$registro);
				else
					$oDb->tb_update('Grupo_empresas',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Grupo_empresas where id_grupo_empresa = $registro[id_grupo_empresa]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Grupo_empresas'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Grupo_empresas where Grupo_empresas.id_grupo_empresa = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_marcas(&$Sesion) {
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$id_marca=$Sesion->fetchVar('id_marca','POST GET SESSION');
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
	$oDb = $Sesion->get_db('data');

	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Marcas */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if ($Sesion->get_var('identificador_imagen_nueva')) $registro['id_imagen'] = $Sesion->get_var('identificador_imagen_nueva');
				elseif (!is_numeric($registro['id_imagen'])) $registro['id_imagen'] = 'null';
				$registro['wwwactivo'] = (int)$registro['wwwactivo'];
				$registro['novender'] = (int)$registro['novender'];
				if (!is_numeric($registro['id_marca'])) {
					$oDb->tb_replace("Marcas",$registro);
					$id_marca = $oDb->last_insert_id();
				} else {
					$oDb->tb_update('Marcas',$registro);
					$id_marca = $registro['id_marca'];
				}
			}
			break;
		case 2 : //borrado
			$consulta="delete from Marcas where id_marca = $registro[id_marca]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Marcas'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Marcas where Marcas.id_marca = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case

	if (is_numeric($id_marca)) $Sesion->set_var('id_marca',$id_marca,'SECCION');

}//fin del precode

function pre_certificados(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Certificados */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (is_numeric($registro['id_certificado']))
					$oDb->tb_update("Certificados",$registro);
				else
					$oDb->tb_replace("Certificados",$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Certificados where id_certificado = $registro[id_certificado]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Certificados'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Certificados where Certificados.id_certificado = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_unidades_medida(&$Sesion) {
	$id_unidad_medida = $Sesion->fetchVar('id_unidad_medida','GET');
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$aNuevo=$Sesion->fetchVar('nuevo','POST');
	$aEscalas=$Sesion->fetchVar('UnidadesMedida_Escalas','POST');

	if (!empty($id_unidad_medida) AND is_numeric($id_unidad_medida)) {
		$Sesion->set_var('id_unidad_medida',$id_unidad_medida,'SUBSECCION');
	} else {
		$id_unidad_medida = $Sesion->get_var('id_unidad_medida');
	}
	if ( (empty($id_unidad_medida) or !is_numeric($id_unidad_medida)) and $Sesion->get_subsecc_name()!='bo_unidades_medida' ) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Unidades_medida'));
		return;
	}

	$estado=$Sesion->fetchVar('estado','POST');
	$accion=$Sesion->fetchVar('accion','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;

	switch ($accion) {
		case 'Modificar': /* modificacion de Unidades_medida */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro['conversion_descompuesta'] = (int)$registro['conversion_descompuesta'];
				//Casos especiales con los registros
				if (!is_numeric($registro['id_unidad_medida']))
					$oDb->tb_replace("Unidades_medida",$registro);
				else
					$oDb->tb_update('Unidades_medida',$registro);
			}
			if ($Sesion->verifyVar('UnidadesMedida_Escalas',IKRN_VAR_CRC_CHANGE) and 
					$Sesion->verifyVar('UnidadesMedida_Escalas',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($aEscalas) and sizeof($aEscalas))
					foreach ($aEscalas as $id => $aVal) {
						$aVal['id_escala_medida'] = $id;
						$aVal['id_unidad_medida'] = $id_unidad_medida;
						$oDb->tb_update('UnidadesMedida_Escalas',$aVal);
					}
			}

			break;

		case 'Borrar' : //borrado
			$consulta="delete from Unidades_medida where id_unidad_medida = $registro[id_unidad_medida]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Unidades_medida'));
				return;
			}
			break;

		case 'BorrarLista' :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Unidades_medida where Unidades_medida.id_unidad_medida = $clave";
						$oDb->query($consulta);
					}
			}

		case 'BorrarListado' :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $tabla => $aVal)
					if (is_array($aVal) and sizeof($aVal))
						foreach ($aVal as $id => $bool)
							if($bool == 1 ){
								$oDb->tb_delete($tabla,array('id_escala_medida' => $id));
							}
			}
			break;

		case 'Nuevo':
			if (is_array($aNuevo) and sizeof($aNuevo))
				foreach ($aNuevo as $tb => $aVal) {
					//FixMe: Comprobar que la tabla exista (para un modo generico)
					if (!empty($tb) and is_array($aVal) and sizeof($aVal) ) {
						$aVal['id_unidad_medida'] = $id_unidad_medida;
						$oDb->tb_insert($tb,$aVal);
					}
				}

			break;

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_competencia(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Competencia */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_competencia']))
					$oDb->tb_replace("Competencia",$registro);
				else
					$oDb->tb_update('Competencia',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Competencia where id_competencia = $registro[id_competencia]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Competencia'));
				return;
			}
			break;
		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_tipos_iva(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$cc_old=$Sesion->fetchVar('cc_old','POST');

	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Tipos_IVA */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$aCamposCC = array();
				foreach ($registro as $campo => $valor) 
					if (!strcasecmp(substr($campo,0,3),'cc_')) {
						array_push($aCamposCC,$campo);
					}
				if (sizeof($aCamposCC)) {
					$oDb_cfg = $Sesion->get_db('conf');
					$aCfg = $Sesion->get_var('_aAppConf');
					$icontadb = $aCfg['iconta_dbname'];
					$id_ej = $aCfg['iconta_ejercicio'];
					$id_emp_ej = NULL;
					if (!empty($icontadb)) {
						$oDb_ic = $Sesion->get_db($icontadb);
						if (!$id_emp_ej) {
							$tmprs = $oDb_ic->query('SELECT id_empresa FROM Ejercicios WHERE id_ejercicio = '.$id_ej);
							if (!$oDb_ic->num_rows($tmprs)) continue;
							$aTmp = $oDb_ic->fetch_row($tmprs);
							$id_emp_ej = $aTmp[0];
							$aTmp = NULL;
							$oDb_ic->libera($tmprs);
						}
						foreach ($aCamposCC as $campo) {
							if (!empty($registro[$campo]) AND is_numeric($registro[$campo]) AND strcasecmp($registro[$campo],$cc_old[$campo]) AND is_numeric($id_emp_ej)) {
								$aTmp = AccountEntry::filterAccount($registro[$campo],NULL,ICEntry_FILTER_ARRAY | ICEntry_FILTER_EXTENDED);
								$tmprs=$oDb_ic->query("SELECT * FROM Cuenta_contable WHERE id_plan_contable = ".$aTmp[0]." AND id_cuenta = ".$aTmp[1].' AND id_empresa = '.$id_emp_ej);
								if (!$oDb_ic->num_rows($tmprs)) {
									$aTmpReg['id_cuenta'] = $aTmp[1];
									$aTmpReg['id_plan_contable'] = $aTmp[0];
									if (strstr($campo,'_re_')) $aTmpReg['nombre'] = 'Recargo de Equivalencia ('.$registro['nombre'].') ';
									elseif (strstr($campo,'_ce_')) $aTmpReg['nombre'] = 'Impuesto Intra-Comunitario ('.$registro['nombre'].') ';
									else $aTmpReg['nombre'] = $registro['nombre'];
									$aTmpReg['id_empresa'] = $id_emp_ej;
									$oDb_ic->tb_replace('Cuenta_contable',$aTmpReg);
									$aTmpReg = NULL;
								} 
								$registro[$campo] = $aTmp[0].$aTmp[1];
								$oDb_ic->libera($tmprs);
							} elseif (empty($registro[$campo])) $registro[$campo] = 'null';
						}
					}
				}
				if (!is_numeric($registro['id_iva']))
					$oDb->tb_replace("Tipos_IVA",$registro);
				else
					$oDb->tb_update('Tipos_IVA',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Tipos_IVA where id_iva = $registro[id_iva]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Tipos_IVA'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Tipos_IVA where Tipos_IVA.id_iva = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_transportistas(&$Sesion) {
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Transportistas */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_transportista']))
					$oDb->tb_replace("Transportistas",$registro);
				else
					$oDb->tb_update('Transportistas',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Transportistas where id_transportista = $registro[id_transportista]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Transportistas'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Transportistas where Transportistas.id_transportista = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_tarifas_transporte(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$borrar=$Sesion->fetchVar('borrar','POST');
	$oDb = $Sesion->get_db('data');

	switch ($accion_ejecutar) {
		case 'Modificar': /* modificacion de Tarifas_transporte */
			//Casos especiales con los registros
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro['costo_unidad'] = (int)$registro['costo_unidad'];
				if (!is_numeric($registro['id_tarifa_transporte'])) {
					$oDb->tb_insert("Tarifas_transporte",$registro);
					$registro['id_tarifa_transporte'] = $oDb->last_insert_id();
				} else $oDb->tb_update('Tarifas_transporte',$registro);
				if (is_numeric($registro['id_tarifa_transporte'])) {
					$Sesion->set_var('id_tarifa_transporte',$registro['id_tarifa_transporte']);
				}
			}
			break;

		case 'Borrar' : //borrado
			if (is_array($borrar) AND sizeof($borrar)) 
				foreach ($borrar as $id => $bool) {
					$oDb->tb_delete('Tarifas_transporte',array('id_tarifa_transporte' => $id));
				}
			break;

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_maestro_bajas_almacen(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;

	switch ($estado) {
		case 1: /* modificacion de Maestro_bajas_almacen */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if (!is_numeric($registro['id_baja_almacen']))
					$oDb->tb_replace("Bajas_almacen",$registro);
				else
					$oDb->tb_update('Bajas_almacen',$registro);
			}
			break;

		case 2 : //borrado
			if (is_array($registro_borrar))
				foreach ($registro_borrar as $id_baja) {
					$consulta="delete from Bajas_almacen where id_baja_almacen = $id_baja";
					if(!$oDb->query($consulta)){
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Bajas_almacen'));
						$Sesion->perror_link('?seccion=bo_maestro_bajas_almacen');
						return;
					}
				}
			break;

		default: //debug("Estado no reconocido");
			break;

	}//fin del case
}//fin del precode

function pre_familia_articulos(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Familia_articulos */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$registro['stock'] = (int)$registro['stock'];
				$registro['materia_prima'] = (int)$registro['materia_prima'];
				if (is_numeric($registro['id_familia']))
					$oDb->tb_update("Familia_articulos",$registro);
				else
					$oDb->tb_replace("Familia_articulos",$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Familia_articulos where id_familia = $registro[id_familia]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Familia_articulos'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Familia_articulos where Familia_articulos.id_familia = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_descuento_familia(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');

	$oDb = $Sesion->get_db('data');
	$usuario = identifica_usuarios($Sesion);
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Descuento_familia */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				$registro['id_empresa'] = $usuario['id'];
				$oDb->tb_replace("Descuento_familia",$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Descuento_familia where id_familia = $registro[id_familia] and id_empresa = $usuario[id]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Descuento_familia'));
				return;
			}
			break;
		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Descuento_familia
							where Descuento_familia.id_familia = $clave and id_empresa = $usuario[id]";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;
	}//fin del case
}//fin del precode

function pre_servicios(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$registro1=$Sesion->fetchVar('registro1','POST');
	$registro2=$Sesion->fetchVar('registro2','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$estado=$Sesion->fetchVar('estado','POST');
	$oDb = $Sesion->get_db('data');
	if (empty($estado)) $estado = 0;
	switch ($estado) {
		case 1: /* modificacion de Servicios */
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				//Casos especiales con los registros
				if($registro1 == "m")
					$registro['duracion'] *=  30;
				if($registro1 == "a")
					$registro['duracion'] *=  365;
				if($registro2 == "m")
					$registro['plazo_factura'] *=  30;
				if($registro2 == "a")
					$registro['plazo_factura'] *=  365;

				if (!is_numeric($registro['id_servicio']))
					$oDb->tb_replace("Servicios",$registro);
				else
					$oDb->tb_update('Servicios',$registro);
			}
			break;
		case 2 : //borrado
			$consulta="delete from Servicios where id_servicio = $registro[id_servicio]";
			if(!$oDb->query($consulta)){
				$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Servicios'));
				return;
			}
			break;

		case 3 :
			if(isset($registro_borrar)){
				foreach($registro_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Servicios where id_servicio = $clave";
						$oDb->query($consulta);
						$consulta="delete from Empresas_servicios where id_servicio = $clave";
						$oDb->query($consulta);
					}
			}

		default: //debug("Estado no reconocido");
			break;

	}//fin del case

}//fin del precode

?>
