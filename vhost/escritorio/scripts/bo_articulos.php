<?php

/**Listado de articulos
  global $borrar_articulos;
  global $registro_lista_precio_venta;
  global $registro_lista_precio_standard;
  global $registro_lista_precio_costo;

  Acciones : Borrar , Modificar (desde el listado)
 */


function pre_articulos(&$Sesion) {
	//debug("precode de listado");
	$borrar_articulos = $Sesion->fetchVar('selecciones','POST');
	$registro_lista = $Sesion->fetchVar('registro_lista','POST',NULL,'Empresas_articulos');
	$accion_ejecutar = $Sesion->fetchVar('accion_ejecutar','POST');

	$registro_lista_precio_venta = $registro_lista['precio_venta'];
	$registro_lista_precio_standard = $registro_lista['precio_standard'];
	$registro_lista_precio_costo = $registro_lista['precio_costo'];
	$registro_lista_precio_cuatro = $registro_lista['precio_4'];
	$registro_lista_precio_cinco = $registro_lista['precio_5'];
	$registro_lista_precio_seis = $registro_lista['precio_6'];

	$oModSel = ModoSeleccion::Factory();
	if ($oModSel) $oModSel->Seek();

	$usuario = identifica_usuarios($Sesion);
	$id_emp = $usuario['id'];
	$Sesion->set_var("id_empresa",$usuario['id']);
	$oDb = $Sesion->get_db('data');
	$id_empresa = $usuario['id'];

	switch($accion_ejecutar){
		case "Borrar" :
			if(isset($borrar_articulos)){
				foreach($borrar_articulos as $clave => $valor)
					if($valor == $clave ){
						//Borra un articulo ,Compra_articulos , descuentos  Servicios , Pedidos , Albaranes , 
						// Facturas , y tod-o loke se vea afectado
						$aTmp = NULL;
						$aTmp['id_articulo'] = $clave;
						$aTmp['id_empresa'] = $id_empresa;
						$aTmp['fecha_baja'] = date('Y-m-d H:i');
						if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
						if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments($aTmp,'Empresas_articulos');
						$oDb->tb_update('Empresas_articulos',$aTmp);
					}
			}
		break;

		case "Modificar" :
			if (is_array($registro_lista_precio_venta))
				foreach($registro_lista_precio_venta as $clave => $valor){
					$aTmp = NULL;
					if (is_numeric($registro_lista_precio_venta[$clave])) 
						$aTmp['precio_venta'] = $registro_lista_precio_venta[$clave];
					else $aTmp['precio_venta'] = 'null';
					if (is_numeric($registro_lista_precio_costo[$clave])) 
						$aTmp['precio_costo'] = $registro_lista_precio_costo[$clave];
					else $aTmp['precio_costo'] = 'null';
					if (is_numeric($registro_lista_precio_standard[$clave])) 
						$aTmp['precio_standard'] = $registro_lista_precio_standard[$clave];
					else $aTmp['precio_standard'] = 'null';
					if (is_numeric($registro_lista_precio_cuatro[$clave])) 
						$aTmp['precio_4'] = $registro_lista_precio_cuatro[$clave];
					else $aTmp['precio_4'] = 'null';
					if (is_numeric($registro_lista_precio_cinco[$clave])) 
						$aTmp['precio_5'] = $registro_lista_precio_cinco[$clave];
					else $aTmp['precio_5'] = 'null';
					if (is_numeric($registro_lista_precio_seis[$clave])) 
						$aTmp['precio_6'] = $registro_lista_precio_seis[$clave];
					else $aTmp['precio_6'] = 'null';
					if (is_array($aTmp) AND sizeof($aTmp)) {
						$aTmp['id_empresa'] = $id_emp;
						$aTmp['id_articulo'] = $clave;
						$oDb->tb_update('Empresas_articulos',$aTmp);
					}
				}
		break;

		case "Importar" :
			$registro=$Sesion->fetchVar('registro','POST');
			$insertar_articulo=$Sesion->fetchVar('insertar_articulo','POST');

			if(is_array($insertar_articulo)) {
				foreach($insertar_articulo as $id_articulo => $valor)
					if($valor == 1){
						$aTmp = NULL;
						$aTmp["id_articulo"] = $id_articulo;
						$aTmp["id_empresa"] = $id_empresa;
						$aTmp['fecha_baja'] = 'null';
						$aTmp['id_dia_baja'] = 'null';
						$aTmp['fecha_alta'] = date('Y-m-d');
						if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
						if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments($aTmp,'Empresas_articulos');
						$cons = "SELECT id_articulo FROM Empresas_articulos WHERE id_articulo = $id_articulo AND id_empresa = $id_empresa";
						$tmprs = $oDb->query($cons);
						if ($oDb->num_rows($tmprs)) {
							$oDb->tb_update("Empresas_articulos",$aTmp);
						} else {
							$oDb->tb_replace('Empresas_articulos',$aTmp);
						}
					}
			}

			break;

		default :
	}

}//fin del precode

/** Ficha indididual de los articulos
  global $id_articulo;

  global $registro; //articulos
  global $registro2; //empresas_articulos
  global $registro3; //articulos_articulos
  global $registro4_precio; //compra_articulos
  global $registro4_referencia;
  global $registro4_descuento;
  global $registro4_fabricante;

  global $cantidad_articulo;

  global $borrar_composicion;
  global $borrar_proveedor;

Acciones : Modificar(Articulo , composicion de articulo , proveedores articulos , articulos empresas) ,
Borrar (composicion de articulo , proveedores articulos ) , Nuevo
 */
function pre_articulo(&$Sesion) {
	$id_articulo=$Sesion->fetchVar('id_articulo','GET');
	$registro=$Sesion->fetchVar('registro','POST','Articulos'); //articulos
	$registro2=$Sesion->fetchVar('registro2','POST',false,'Empresas_articulos'); //empresas_articulos
	$registro3=$Sesion->fetchVar('registro3','POST',false,'Articulos_articulos'); //articulos_articulos

	$registro4=$Sesion->fetchVar('registro4','POST',false,'Compra_articulos'); //compra_articulos
	//servicios
	$registro_servicios=$Sesion->fetchVar('registro_servicios','POST');
	$cantidad_articulo=$Sesion->fetchVar('cantidad_articulo','POST');
	$borrar_composicion=$Sesion->fetchVar('borrar_composicion','POST');
	$composicion_articulos=$Sesion->fetchVar('composicion_articulos','POST');
	$borrar_proveedor=$Sesion->fetchVar('borrar_proveedor','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$servicios_seleccionados=$Sesion->fetchVar('servicios_seleccionados','POST');
	$proveedores_seleccionados=$Sesion->fetchVar('proveedores_seleccionados','POST',false,'Compra_articulos');
	$selecciones=$Sesion->fetchVar('selecciones','POST');
	$articulos_recursos=$Sesion->fetchVar('articulos_recursos','POST');
	$aCheckboxList = array('stock','frecuente','fabricacion_propia','wwwhome','wwwactivo','wwwportada','wwwdestacado');

	$field = $Sesion->_aAcciones['Articulos']['module_field'];
	if (!empty($field) and is_array($registro[$field])) {
		$mascara = 0;
		foreach ($registro[$field] as $idx => $mask) $mascara |= $mask;
		$registro[$field] = $mascara;
	}

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


	$usuario = identifica_usuarios($Sesion);
	$id_empresa = $Sesion->get_var("id_empresa");
	if (!(int)$id_empresa) {
		$id_empresa = $usuario['id'];
		$Sesion->set_var("id_empresa",$id_empresa);
	}
	//debug("glob  $id_articulo");
	//debug("ses $id_articulo_sesion");

	if (!empty($accion_ejecutar) AND is_numeric($registro['id_articulo']) AND !empty($registro['id_articulo'])) {
		$id_articulo_sesion = $id_articulo = $registro['id_articulo'];
		$Sesion->set_var('id_articulo',$id_articulo);
		$Sesion->set_var('id_articulo_promocion',$id_articulo);
	} else {
		$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
		if(isset($id_articulo)) {
			$Sesion->set_var("id_articulo_promocion",$id_articulo);
			$Sesion->set_var("id_articulo",$id_articulo);
		} elseif (isset($id_articulo_sesion) AND !empty($id_articulo_sesion))
			$id_articulo = $id_articulo_sesion;
		elseif (strcasecmp($accion_ejecutar,'nuevo')) return NULL;
	}

	$oDb = $Sesion->get_db('data');

	switch($accion_ejecutar){
		case "Modificar" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro) AND is_array($registro) AND sizeof($registro)){
					$registro["id_articulo"] = $id_articulo;
					if($Sesion->get_var("identificador_imagen_nueva"))
						$registro["id_imagen"] = $Sesion->get_var("identificador_imagen_nueva");
					elseif (!is_numeric($registro['id_imagen'])) $registro['id_imagen'] = 'null';
					$oDb->tb_update("Articulos",$registro);
					$Sesion->unset_var("identificador_imagen_nueva");
				}
			}

			if ($Sesion->verifyVar('registro2',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro2',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro2)){
					if ((int)$registro2['causar_baja'] AND empty($registro2['fecha_baja']))
						$registro2["fecha_baja"] = date('Y-m-d H:i');
					elseif (!(int)$registro2['causar_baja']) $registro2['fecha_baja'] = 'null';
					// Servicios:
					if (empty($registro2['_duracion_precio'])) {
						$registro2['servicios_duracion_precio'] = 'null';
					}
					$registro2["id_articulo"] = $Sesion->get_var("id_articulo_promocion");
					$registro2["id_empresa"] = $usuario['id'];
					if (is_array($aCheckboxList) and sizeof($aCheckboxList))
						foreach ($aCheckboxList as $fld => $val) 
							$registro2[$val] = (int)$registro2[$val];

					if (!is_numeric($registro2['dto_vol'])) $registro2['dto_vol'] = 'null';
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) $registro2 = $oPer->getAssignments($registro2,'Empresas_articulos');

					$oDb->tb_update("Empresas_articulos",$registro2);
				}
			}

			if ($Sesion->verifyVar('registro3',IKRN_VAR_CRC_CHANGE) and $Sesion->verifyVar('registro3',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro3) and is_array($registro3))
					foreach ($registro3 as $clave => $aV) {
						if (!empty($aV) or $composicion_articulos[$clave]) {
							$reg["id_articulo"] = $id_articulo;
							$reg["id_materia_prima"] = $clave;
							if (empty($aV['unidades']) || !is_numeric($aV['unidades']))
								$valor = (int)$composicion_articulos[$clave];
							else $valor = $aV['unidades'];
							$reg["unidades"] = $valor;
							if($valor != 0)
								if (!$oDb->tb_replace("Articulos_articulos",$reg))
									$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Articulos_articulos'));
						} 
					}
			}

			if ($Sesion->verifyVar('registro4',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro4',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro4) and is_array($registro4) and sizeof($registro4))
					foreach($registro4 as $id_prov => $aCompra) {
						$aCompra["id_articulo"] = $id_articulo;
						$aCompra["id_proveedor"] = $id_prov;
						$aCompra['fabricante'] = (int)$aCompra['fabricante'];
						$aCompra['preferente'] = (int)$aCompra['preferente'];
						if (empty($aCompra['_duracion_precio'])) {
							$aCompra['servicios_duracion_precio'] = 'null';
						}
						$aCompra['servicios_poradelantado'] = (int)$aCompra['servicios_poradelantado'];
						if (!is_numeric($aCompra['dto_vol'])) $aCompra['dto_vol'] = 'null';
						if (!is_numeric($aCompra['descuento'])) $aCompra['descuento'] = 'null';
						$oDb->tb_update("Compra_articulos",$aCompra);
					}
			}

			if ($Sesion->verifyVar('registro_servicios',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro_servicios',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro_servicios) AND is_array($registro_servicios)) {
					foreach($registro_servicios as $ids => $aSer) {
						$reg3['id_articulo'] = $id_articulo;
						$reg3['id_empresa'] = $id_empresa;
						$reg3["id_servicio"] = $ids;
						$reg3['cuota_alta'] = $aSer['cuota'];
						$reg3['servicios_poradelantado'] = (int)$aSer['servicios_poradelantado'];
						$oDb->tb_update("Empresas_servicios",$reg3);
					}
				}
			}

			if ($Sesion->verifyVar('articulos_recursos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('articulos_recursos',IKRN_VAR_CRC_AUTHED)) {
				if(isset($articulos_recursos) AND is_array($articulos_recursos) AND sizeof($articulos_recursos)) 
					foreach ($articulos_recursos as $id_recurso => $aRec) {
						$aRec['id_articulo'] = $id_articulo;
						$aRec['id_empresa'] = $id_empresa;
						$aRec['id_recurso'] = $id_recurso;
						if (empty($aRec['descripcion'])) $aRec['descripcion'] = 'null';

						$oDb->tb_update('Articulos_recursos',$aRec);
					}
			}
		break;

		case "Borrar" :
			$art = $Sesion->get_var("id_articulo_promocion");
			if (!is_numeric($art)) $art = $Sesion->get_var('id_articulo');
			if(isset($borrar_composicion)){
				foreach($borrar_composicion as $clave => $valor)
					if($valor == 1 ) {
						$consulta="delete from Articulos_articulos
							where Articulos_articulos.id_materia_prima = $clave AND
							Articulos_articulos.id_articulo = $art";
						$oDb->query($consulta);
					}
			}

			if(isset($borrar_proveedor))
				foreach($borrar_proveedor as $clave => $valor)
					if($valor == 1 ){
						$bDelete = true;
						$cons = 'SELECT COUNT(*) '.
									'FROM Compra_articulos Ca, Lineas_detalle Ld, Pedidos P '.
									'WHERE (P.id_pedido IS NOT NULL AND P.id_proveedor = Ca.id_proveedor) '.
									'AND (Ld.id_pedido=P.id_pedido AND Ld.id_articulo=Ca.id_articulo) '.
									'AND Ca.id_proveedor = '.$clave.' AND Ca.id_articulo = '.$art;
						$tmprs = $oDb->query($cons);
						$aTmp = $oDb->fetch_row($tmprs);
						$oDb->libera($tmprs);
						if (!$aTmp[0]) {
							$cons = 'SELECT COUNT(*) '.
										'FROM Compra_articulos Ca, Lineas_detalle Ld, Facturas_detalle Fd, Facturas F '.
										'WHERE (F.id_factura IS NOT NULL AND F.id_proveedor = Ca.id_proveedor) '.
										'AND (Fd.id_factura=F.id_factura AND Fd.id_detalle=Ld.id_detalle AND Ld.id_articulo=Ca.id_articulo) '.
										'AND Ca.id_proveedor = '.$clave.' AND Ca.id_articulo = '.$art;
							$tmprs=$oDb->query($cons);
							$aTmp = $oDb->fetch_row($tmprs);
							$oDb->libera($tmprs);
							if ($aTmp[0]) $bDelete = false;
						} else $bDelete = false;

						if (!$bDelete) {
							$oDb->tb_update('Compra_articulos',array('fecha_baja' => date('Y-m-d H:i'),'id_articulo' => $art, 'id_proveedor' => $clave));
						} else {
							$oDb->tb_delete('Compra_articulos',array('id_articulo' => $art, 'id_proveedor' => $clave));
						}
					}
		break;

		case "Nuevo" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro['fecha_alta'] = date("Y-m-d");
				$registro['id_articulo'] = NULL;
				if (!$oDb->tb_replace("Articulos",$registro))
					$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Articulos'));
				$id_articulo = $oDb->last_insert_id();
				$Sesion->set_var("id_articulo_promocion",$id_articulo);

				$registro2['id_articulo']= $id_articulo;
				$registro2['id_empresa']= $usuario['id'];
				$registro2['fecha_alta'] =  date("Y-m-d"); ;
				$registro2['stock'] = (int)$registro2['stock'];
				$registro2['fabricacion_propia'] = (int)$registro2['fabricacion_propia'];
				$registro2['frecuente'] = (int)$registro2['frecuente'];
				if (!$oDb->tb_replace("Empresas_articulos",$registro2))
					$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Empresas_articulos'));
			}
		break;

		case "asociar_servicios" :
			if (is_array($servicios_seleccionados)) {
				$aTmp['id_empresa'] = $id_empresa;
				$aTmp['id_articulo'] = $id_articulo;
				foreach ($servicios_seleccionados as $clave => $valor) {
					$aTmp['id_servicio'] = $clave;
					$oDb->tb_insert("Empresas_servicios",$aTmp);
				}
			}
		break;

		case "asociar_proveedores" :
			if ($Sesion->verifyVar('proveedores_seleccionados',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('proveedores_seleccionados',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($proveedores_seleccionados)) {
					foreach ($proveedores_seleccionados as $clave => $aVal) {
						if (!is_numeric($aVal['id_proveedor'])) continue;
						$aTmp = $aVal;
						$aTmp['id_proveedor'] = $clave;
						$aTmp['id_articulo'] = $id_articulo;
						$aTmp['fecha_baja'] = 'null';
						$oDb->tb_replace("Compra_articulos",$aTmp);
					}
				}
			}
		break;

		case "Borrar_servicios" :
			if (is_array($registro_servicios)) {
				$aTmp['id_empresa'] = $id_empresa;
				$aTmp['id_articulo'] = $id_articulo;
				foreach($registro_servicios as $clave => $aServ) {
					if (!is_numeric($aServ['id'])) continue;
					$aTmp['id_servicio'] = $aServ['id'];
					$oDb->tb_delete("Empresas_servicios",$aTmp);
				}
			}

		case "SeleccionarRecursos" :
			if ($Sesion->verifyVar('selecciones',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('selecciones',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($selecciones) AND sizeof($selecciones)) {
					foreach ($selecciones as $id_recurso) {
						$oDb->tb_insert('Articulos_recursos',array('id_articulo' => $id_articulo, 'id_empresa' => $id_empresa, 'id_recurso' => $id_recurso));
					}
				}
			}
			break;

		case "BorrarRecursos" :
			if (is_array($articulos_recursos) AND sizeof($articulos_recursos)) 
				foreach ($articulos_recursos as $id_recurso => $aRec) 
					if (is_numeric($aRec['id_recurso']) AND $id_recurso == $aRec['id_recurso'])
						$oDb->tb_delete('Articulos_recursos',array('id_articulo' => $id_articulo, 'id_empresa' => $id_empresa, 'id_recurso' => $id_recurso));

			break;
	}//fin de case

	if (is_numeric($id_articulo)) {
		$Sesion->set_var('id_articulo',$id_articulo);
		$Sesion->set_var('id_articulo_promocion',$id_articulo);
	}
}//fin del precode

function cf_escritorios(&$Sesion,&$aData) {
	static $oPed;
	static $aTarifa;
	$aTar = NULL;
	if (!is_object($oPed)) {
		$usr = identifica_usuarios($Sesion);
		if (!strcasecmp($usr['desktop_name'],'Clientes')) {
			$idemp = $Sesion->get_var('id_empresa');
			$idcli = $usr['valor'];
			$oPed = new Document ($Sesion->App_Name,'data',inmPed_VENTA);
			if (is_object($oPed)) {
				if ($oPed->set_issuer($idemp)) {
					if ($oPed->set_reciever($idcli)) $aTarifa = $oPed->get_revenue();
				}
			}
		}
	}

	$aTar = $aTarifa;
	if (is_numeric($aData['Empresas_servicios.id_articulo'])) {
		$tabla_precios = 'Empresas_servicios';
		$aTar['campo_accion'] = 'cuota_alta';
		$aTar['campo_recomendacion'] = 'cuota_alta';
	} else $tabla_precios = 'Empresas_articulos';


	if (!empty($aTar['campo_accion'])) {
		$precio = $aData[$tabla_precios.'.'.$aTar['campo_accion']];
		if (empty($precio)) $precio = $aData[$aTar['campo_accion']];
		if (!empty($precio)) $aData['precio_tarifa'] = $oPed->_applyRevenue($precio);
	}
	if (!empty($aTarifa['campo_recomendacion'])) {
		$precio = $aData[$tabla_precios.'.'.$aTar['campo_recomendacion']];
		if (empty($precio)) $precio = $aData[$aTar['campo_recomendacion']];
		if (!empty($precio)) $aData['precio_recomendado'] = $oPed->_applyRevenue($precio,$aData['Tipos_IVA.porcentaje']);
	}

	return true;
}

function nombre_articulo_compuesto(&$Sesion,&$aDatos){
	$id_art = $aDatos["Articulos_articulos.id_materia_prima"];
	$consulta= "Select nombre from Articulos where id_articulo = $id_art";
	$resul =  $Sesion->query($consulta);
	$row =  $Sesion->fetch_array($resul);
	return $row["nombre"];
}

function promocion_articulo(&$Sesion,&$aDatos){
	$id_art = $aDatos["Articulos.id_articulo"];
	$usuario = identifica_usuarios($Sesion);
	$oDb = &$Sesion->get_db('data');
	$consulta= "Select nombre from Promociones where id_articulo = $id_art and id_empresa = $usuario[id] and fecha_inicio<NOW() AND (fecha_fin>NOW() OR fecha_fin IS NULL)";
	$resul =  $oDb->query($consulta);
	$row =  $oDb->fetch_array($resul);
	$oDb->libera($resul);
	return $row["nombre"];
}

function promocion_articulo_promocion(&$Sesion,&$aDatos){
	$id_art = $aDatos["Articulos.id_articulo"];
	$id_promocion = (int)$Sesion->get_var("id_promocion_promocion");
	$consulta= "Select * from Promociones_articulos where id_articulo = $id_art and  id_promocion = $id_promocion";
	$oDb = &$Sesion->get_db('data');
	$resul =  $oDb->query($consulta);
	$row =  $oDb->fetch_array($resul);
	if($row) return 0;
	return 1;
}

/** Ficha de promocion de un articulo
Acciones :     Modificar , Borrar , Borrar_articulos
 */
function pre_promociones(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST',NULL,'Promociones');
	$registro_promocion=$Sesion->fetchVar('registro_promocion','POST',NULL,'Promociones_articulos');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$promocion_articulo=$Sesion->fetchVar('promociones_articulos','POST',NULL,'Promociones_articulos');
	$reg=$Sesion->fetchVar('reg','POST'); // Array con las checkboxes por articulo de la promocion
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_promocion=$Sesion->fetchVar('id_promocion','POST');
	$id_articulo = $Sesion->fetchVar('GET POST SESSION');

	$cantidad_promocion_articulo = $promocion_articulo['cantidad'];

	switch ($accion_ejecutar) {
		case "Modificar":
			$Modificar = 1;
		break;
		case "Borrar":
			$Borrar = 1;
		break;
		case "Nuevo":
			$Nuevo = 1;
		break;
		case "Borrar_articulos":
			$Borrar_articulos = 1;
		break;
	}

	$usuario = identifica_usuarios($Sesion);
	if (!is_numeric($id_articulo)) $id_articulo = $id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
	else $id_articulo_sesion = $id_articulo;

	$oDb = $Sesion->get_db('data');

	if(isset($Modificar)) {
		if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
			foreach ($registro as $id_promo => $reg) {
				$reg["id_articulo"] = $Sesion->get_var("id_articulo_promocion");
				$reg["id_empresa"] = $usuario['id'];
				if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
				if (is_a($oPer,'Periodo')) $reg = $oPer->getAssignments($reg,'Promociones');
				if($reg['oferta'] == 1){
					$oDb->tb_update("Promociones",$reg);
				} else {
					$oDb->tb_update("Promociones",$reg);

					// print_r($registro_promocion);
					if(isset($registro_promocion[$id_promo]) AND is_array($registro_promocion[$id_promo]))
						foreach($registro_promocion[$id_promo] as $clave => $aV) {
							$reg = array();
							$reg["cantidad"]  = $registro_promocion[$id_promo][$clave]['cantidad'];
							$reg["id_articulo"] = $clave;
							$reg["id_promocion"] = $id_promo;
							$oDb->tb_update("Promociones_articulos",$reg);
						}
				}
			}
		}
	} elseif (isset($Nuevo)) {
		if(isset($cantidad_promocion_articulo)){
			if ($Sesion->verifyVar('cantidad_promocion_articulo',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('cantidad_promocion_articulo',IKRN_VAR_CRC_AUTHED)) {
				if (!is_numeric($id_promocion)) {
					$consulta = "select id_promocion  from Promociones where id_articulo = $id_articulo_sesion and id_empresa = $usuario[id]";
					$resul = $oDb->query($consulta);
					if ($oDb->num_rows($resul)!=1) $id_promocion = NULL;
					else {
						$row=$oDb->fetch_array($resul);
						$id_promocion = (int)$row['id_promocion'];
					}
				} 
				if (is_numeric($id_promocion))
					foreach($cantidad_promocion_articulo as $clave => $valor){
						if($cantidad_promocion_articulo[$clave] >0){
							$reg["cantidad"]  = $cantidad_promocion_articulo[$clave];
							$reg["id_articulo"] = $clave;
							$reg["id_promocion"] = $id_promocion;
							if (!$oDb->tb_replace("Promociones_articulos",$reg))
								$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Promociones_articulos'));
						}
					}
			}
		} else {
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				$registro["id_articulo"] = $Sesion->get_var("id_articulo_promocion");
				$registro["id_empresa"] = $usuario['id'];
				$registro["fecha_inicio"] = descolocar_fecha($registro["fecha_inicio"]);
				$registro["fecha_fin"] = descolocar_fecha($registro["fecha_fin"]);
				if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
				if (is_a($oPer,'Periodo')) $registro = $oPer->getAssignments($registro,'Promociones');
				if($registro["oferta"] == 1){
					if (!$oDb->tb_replace("Promociones",$registro))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Promociones'));
				} else {
					if (!$oDb->tb_replace("Promociones",$registro))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Promociones'));
				}
			}
		}
	} elseif ($Borrar_articulos){
		if (is_array($reg))
			foreach ($reg as $idp => $aArts) {
				$aDel = array();
				foreach ($aArts as $n => $id) {
					$aTmp['id_promocion'] = $idp;
					$aTmp['id_articulo'] = $id;
					array_push($aDel,$aTmp);
				}
				if (is_array($aDel) AND sizeof($aDel)) $oDb->tb_delete("Promociones_articulos",$aDel);
			}
	} elseif (isset($Borrar)){
		if (is_array($registro_borrar)) {
			foreach ($registro_borrar as $id_promo) {
				$oDb->tb_delete('Promociones',array('id_promocion' => $id_promo));
				$oDb->tb_delete('Promociones_articulos',array('id_promocion' => $id_promo));
			}
		}
	}
	if (is_numeric($id_promocion)) $Sesion->set_var("id_promocion_promocion",$id_promocion);
	if (is_numeric($id_articulo)) {
		$Sesion->set_var('id_articulo',$id_articulo);
		$Sesion->set_var('id_articulo_promocion',$id_articulo);
	}

}//fin del precode

function pre_articulos_promocion(&$Sesion) {
	$id_promocion=$Sesion->fetchVar('id_promocion','GET');
	if (is_numeric($id_promocion)) {
		$Sesion->set_var("id_promocion_promocion",$id_promocion);
	}
}

function dar_oferta($Sess,$aDatos){
	if((int)$aDatos["Promociones.oferta"]) return "CHECKED";
}

function dar_promocion($Sess,$aDatos){
	if((int)$aDatos["Promociones.oferta"] == 0) return "CHECKED";
}

function cantidad_total(&$Sesion,&$aDatos){
	$usuario = identifica_usuarios($Sesion);
	//depurar_array($aDatos);
	$oDb = $Sesion->get_db('data');
	if($aDatos["Articulos.id_articulo"])
		$id_art = $aDatos["Articulos.id_articulo"];
	else if($id_articulo_sesion = $Sesion->get_var("id_articulo_promocion"))
		$id_art = $id_articulo_sesion;

	$consulta = "select sum(Localizacion_articulos.cantidad) From Localizacion_articulos , Almacenes , Almacenes_logicos where
		Localizacion_articulos.id_articulo = $id_art and
		Almacenes.id_empresa = $usuario[id] and
		Almacenes.id_almacen = Almacenes_logicos.id_almacen and
		Almacenes_logicos.id_almacen_logico = Localizacion_articulos.id_almacen_logico";
	$resul=$oDb->query($consulta);
	$row=$oDb->fetch_array($resul);
	//depurar_array($row);
	return $row[0];
}

function nombre_articulo_promocion(&$Sesion,&$aDatos){
	if($aDatos["Promociones_articulos.id_articulo"])
		$id_art = $aDatos["Promociones_articulos.id_articulo"];
	else if($id_articulo_sesion = $Sesion->get_var("id_articulo_promocion"))
		$id_art = $id_articulo_sesion;
	$oDb = $Sesion->get_db('data');

	$consulta = "select nombre from Articulos where id_articulo = $id_art";
	$resul=$oDb->query($consulta);
	$row=$oDb->fetch_array($resul);
	//depurar_array($row);
	return $row['nombre'];
}

function pre_localizacion_articulos(&$Sesion) {
	$id_articulo = $Sesion->fetchVar('id_articulo','GET POST SESSION');
	if (!is_numeric($id_articulo)) $id_articulo = $Sesion->fetchVar('id_articulo_promocion','GET POST SESSION');

	if (is_numeric($id_articulo)) {
		$Sesion->set_var('id_articulo',$id_articulo);
		$Sesion->set_var('id_articulo_promocion',$id_articulo);
	}
}

function pre_ordenes_fabricacion(&$Sesion) {
	$Borrar=$Sesion->fetchVar('Borrar','POST');
	$orden_fabricacion_borrar=$Sesion->fetchVar('orden_fabricacion_borrar','POST');

	$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
	$oDb = $Sesion->get_db('data');
	$usuario = identifica_usuarios($Sesion);
	if(isset($Borrar)){
		//debug("borrando");
		if(isset($orden_fabricacion_borrar)){
			foreach($orden_fabricacion_borrar as $clave => $valor)
				if($valor == 1 ){
					$consulta="delete from Ordenes_fabricacion
						where lote =  '$clave' AND
						id_empresa = $usuario[id] AND
						id_articulo = $id_articulo_sesion";
					$oDb->query($consulta);
				}
		}
	}//fin de borrar
}

/** Listado de descuentos ñpara un cliente de articulos
  global $descuentos_cliente_borrar;
  global $descuentos_articulo_modificar_descuento;
  global $descuentos_articulo_modificar_monto;
  global $campo_accion;

Acciones : Borrar ,  Modificar
 */
function pre_cliente_articulos(&$Sesion) {
	$descuentos_cliente_borrar=$Sesion->fetchVar('descuentos_cliente_borrar','POST');
	$descuentos_articulo_modificar_descuento=$Sesion->fetchVar('descuentos_articulo_modificar_descuento','POST');
	$descuentos_articulo_modificar_monto=$Sesion->fetchVar('descuentos_articulo_modificar_monto','POST');
	$campo_accion=$Sesion->fetchVar('campo_accion','POST');
	$id_articulo=$Sesion->fetchVar('id_articulo','GET POST SESSION');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');

	$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
	if (!empty($id_articulo) AND is_numeric($id_articulo)) {
		$id_articulo_sesion = $id_articulo;
		$Sesion->set_var('id_articulo_promocion',$id_articulo_sesion);
		$Sesion->set_var('id_articulo',$id_articulo_sesion);
	}

	$usuario = identifica_usuarios($Sesion);
	$oDb = $Sesion->get_db('data');

	switch($accion_ejecutar){
		case "Borrar" :
			if(isset($descuentos_cliente_borrar)){
				foreach($descuentos_cliente_borrar as $clave => $valor)
					if($valor == 1 ){
						$consulta="delete from Cliente_articulos where id_cliente =  $clave AND
							id_empresa = $usuario[id] AND id_articulo = $id_articulo_sesion";
						$oDb->query($consulta);
					}
			}
		break;
		case "Modificar" :
			if(isset($descuentos_articulo_modificar_descuento))
				foreach($descuentos_articulo_modificar_descuento as $clave => $valor){
					$registro['id_articulo'] = $id_articulo_sesion;
					$registro['id_empresa'] = $usuario['id'];
					$registro['id_cliente'] = $clave;
					$registro['descuento'] = $descuentos_articulo_modificar_descuento[$clave];
					$registro['monto'] = $descuentos_articulo_modificar_monto[$clave];
					$registro['campo_accion'] = $campo_accion[$clave];
					//                        depurar_array($registro);
					if (!$oDb->tb_replace("Cliente_articulos",$registro))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Cliente_articulos'));
				}
		break;
	}//fin switch

}


function pre_orden_fabricacion(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$lote=$Sesion->fetchVar('lote','POST');

	$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
	$id_lote_sesion = $Sesion->get_var("id_lote_promocion");
	if(isset($lote) AND $id_lote_sesion != $lote)
		$Sesion->set_var("id_lote_promocion",$lote);
	/*else    {$id_lote = $Sesion->get_var("id_lote_promocion");
	  if(!isset($lote)){
	//               debug("no hay lote");
	return;
	}
	}
	 */
	$oDb = $Sesion->get_db('data');
	$usuario = identifica_usuarios($Sesion);
	if(isset($Nuevo)){
		//si estamos metiendo un lote nuevo ,
		$registro['fecha'] = descolocar_fecha($registro['fecha']);
		$registro['fecha_caducidad'] = descolocar_fecha($registro['fecha_caducidad']);
		$registro['id_empresa'] = $usuario['id'];
		$registro['id_articulo'] = $id_articulo_sesion;
		//        depurar_array($registro);
		if (!$oDb->tb_replace("Ordenes_fabricacion",$registro))
			$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Ordenes_fabricacion'));
		$Sesion->set_var("id_lote_promocion",$registro['lote']);
	}//fin de Nuevo

	if(isset($Modificar)){
		$registro["fecha"] = descolocar_fecha($registro["fecha"]);
		$registro["fecha_caducidad"] = descolocar_fecha($registro["fecha_caducidad"]);
		$registro["id_articulo"] = $Sesion->get_var("id_articulo_promocion");
		$registro['id_empresa'] = $usuario['id'];
		$registro['lote'] = $id_lote_sesion;
		//        depurar_array($registro);
		if (!$oDb->tb_replace("Ordenes_fabricacion",$registro))
			$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Ordenes_fabricacion'));
	}//fin de Modificar


}

function obtener_Proveedores(&$Sesion,&$aDatos){
	$Sesion->set_var("Proveedores",$aDatos["Ordenes_fabricacion.id_proveedor"],"EXPIRE");
}
function chequear_Proveedores(&$Sesion,&$aDatos){
	$registro=$Sesion->fetchVar('registro','POST');

	if($Sesion->get_var("Proveedores")==$aDatos["Proveedores.id_proveedor"])
		return 'selected="selected"';
}

function dar_estado($Sess,$aDatos){
	if((int)$aDatos["Ordenes_fabricacion.estado"]) return 'checked = "checked"';
}

function selected_campo_accion2(&$Sesion,&$aDatos){
	$campo_a = $aDatos["Cliente_articulos.campo_accion"];
	//debug($campo_a);
	echo "<select name=\"campo_accion[".
		$aDatos["Cliente_articulos.id_cliente"] ."]\">";
	if($campo_a=="precio_costo") echo "<option value=\"precio_costo\"
		selected>Precio de costo</option>";
	else    echo "<option value=\"precio_costo\">Precio de costo</option>";
	if($campo_a=="precio_standard") echo "<option value=\"precio_standard\"
		selected>Precio standard</option>";
	else    echo "<option value=\"precio_standard\">Precio standard</option>";
	if($campo_a=="precio_venta") echo "<option value=\"precio_venta\"
		selected>Precio de venta</option>";
	else    echo "<option value=\"precio_venta\">Precio de venta</option>";
	echo "</select>";
}

function composicion_articulo(&$Sesion,&$aDatos){
	static $aMateria = NULL;

	if (!is_array($aMateria)) {
		$id_articulo_sesion = $Sesion->get_var("id_articulo_promocion");
		$oDb = $Sesion->get_db('data');
		$consulta= "Select id_materia_prima  from Articulos_articulos where id_articulo = $id_articulo_sesion ";
		$resul =  $oDb->query($consulta);
		if (!$oDb->num_rows($resul)) $aMateria = array();
		else {
			$aMateria = array();
			while( $row =  $oDb->fetch_assoc($resul)) array_push($aMateria,$row['id_materia_prima']);
		}
	}

	return in_array($aDatos['Articulos.id_articulo'],$aMateria);
}

function precio_tarifa(&$Sesion,&$aDatos){
	if (!empty($aDatos['Tarifas.monto'])) {
		$precio = $aDatos[$aDatos['Tarifas.campo_accion']] + $aDatos['Tarifas.monto'];
	} else {
		$precio = $aDatos[$aDatos['Tarifas.campo_accion']];
		if (!empty($aDatos['Tarifas.pto_primero'])) 
			$precio += $precio * ($aDatos['Tarifas.pto_primero'] / 100);
		if (!empty($aDatos['Tarifas.pto_segundo'])) 
			$precio += $precio * ($aDatos['Tarifas.pto_segundo'] / 100);
	}
	return round($precio,3);
}

function articulo_empresa(&$Sesion,&$aDatos){
	$usuario = identifica_usuarios($Sesion);
	$id_art =  $aDatos["Articulos.id_articulo"];
	$oDb = $Sesion->get_db('data');
	$consulta = "select id_empresa from Empresas_articulos where id_articulo = $id_art";
	$rs=$oDb->query($consulta);
	while($row=$oDb->fetch_array($rs)){
		if($row['id_empresa'] == $usuario['id']){
			return 0;
		}
	}
	return 1;
}

?>
