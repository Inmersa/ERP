<?php

function pre_mozoalmacen(&$Sesion) {
	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$id = $Sesion->fetchVar('id','GET SESSION');
	if (!$id) {
		$id = $Sesion->get_var('id_mozo');
		if (is_numeric($id)) $Sesion->set_var('id',$id,'SUBSECCION');
	} else $Sesion->set_var('id_mozo',$id);

	if (empty($id)) {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Mozos_Almacen'));
		return;
	}
	$id_crm = $Sesion->fetchVar('usuario_seleccionado','POST');
	$aMozo = $Sesion->fetchVar('Mozos_almacen','POST');
	$aAcc = $Sesion->fetchVar('acciones','POST');


	switch ($accion) {
		case 'Modificar':
			if (!is_array($aMozo) or !isset($aMozo)) break;
			if (!empty($aAcc['descartar_usuario_crm'])) $aMozo['crm_id_empleado'] = 'null';
			$aMozo['notificar_stock'] = (int)$aMozo['notificar_stock'];
			$oM = new MozoAlmacen();
			if ($oM->dbFill($id)) {
				$oM->update($aMozo);
				$oM->Dump();
			}
			break;

		case 'Seleccion_usuario_crm':
			if (empty($id)) break;
			$oM = new MozoAlmacen();
			if ($oM->dbFill($id)) {
				$oM->update(array('crm_id_empleado' => $id_crm));
				$oM->Dump();
			}
			break;
	}
}

/** funciones del listado de almacenes
Acciones : Borrar (almacenes , almacenes logicos) , Importar (almacenes)  , Nuevo (almacenes , almacenes logicos)  , Modificar (almacenes)
 */
function pre_almacenes(&$Sesion) {
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$id_almacen=$Sesion->fetchVar('id_almacen','GET');
	$almacen_borrar=$Sesion->fetchVar('almacen_borrar','POST');
	$almacen_logico_borrar=$Sesion->fetchVar('almacen_logico_borrar','POST');
	$importar_almacenes=$Sesion->fetchVar('importar_almacenes','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_logicos=$Sesion->fetchVar('registro_logicos','POST');
	$users=$Sesion->fetchVar('users','POST');

	// debug("pre_almacenes");
	$usuario = identifica_usuarios($Sesion);
	$tmp = $Sesion->get_var("id_empresa");
	if ($usuario['id'] != $tmp OR empty($tmp)) {
		$Sesion->set_var("id_empresa",$usuario['id'],"NOEXPIRE");
		$id_empresa = $usuario['id'];
	} else $id_empresa = $tmp;

	if (!strcasecmp($usuario['desktop_name'],'Almacenes')) {
		$id_almacen = $usuario['valor'];
		$Sesion->set_var('id_almacen',$id_almacen,'NOEXPIRE');
		$Sesion->set_var('id_almacen_promocion',$id_almacen,'NOEXPIRE');
	} else {
		$id_almacen_sesion = $Sesion->get_var("id_almacen_promocion");
		if(isset($id_almacen)) {
			$Sesion->set_var("id_almacen_promocion",$id_almacen);
			$Sesion->set_var("id_almacen",$id_almacen);
		} elseif (isset($id_almacen_sesion) AND !empty($id_almacen_sesion)) {
			$id_almacen = $id_almacen_sesion;
		} elseif (!strcasecmp($usuario['desktop_name'],"almacen")){
			$id_almacen = $usuario['valor'];
			$Sesion->set_var("id_almacen_promocion",$id_almacen);
			$Sesion->set_var("id_almacen",$id_almacen);
		}
	}
	$oDb = $Sesion->get_db('data');
	$db_conf = $Sesion->get_db('conf');

	$aMasks = $Sesion->get_var("_aMasks");
	if (!is_array($aMasks) OR !is_numeric($aMasks['almacen'])) {
		$cons = "SELECT mascara FROM Groups WHERE nombre = 'Almacenes'";
		$rs = $db_conf->query($cons);
		if ($db_conf->num_rows($rs)) {
			$aTmp = $db_conf->fetch_assoc($rs);
			$group_mask = $aTmp['mascara'];
			$aMasks['almacen'] = $group_mask;
			$Sesion->set_var("_aMasks",$aMasks,"NOEXPIRE");
		} 
	} 
	$Sesion->set_var("group_mask",$aMasks['almacen'],"INMED");

	// debug($accion_ejecutar);
	switch($accion_ejecutar){
		case "Borrar" :
			if(isset($almacen_borrar)){
				foreach($almacen_borrar as $clave => $valor)
					if($valor == 1 ){
						$cons = 'SELECT id_almacen FROM Almacenes WHERE id_almacen != '.$clave.' AND id_empresa = '.$usuario['id'].
									' ORDER BY id_almacen asc LIMIT 1';
						$tmprs = $oDb->query($cons);
						if ($oDb->num_rows($tmprs)) {
							$aTmp = $oDb->fetch_row($tmprs);
							$nuevo_almacen = $aTmp[0];
							$oDb->tb_delete('Almacenes',array('id_almacen' => $clave));
							$oDb->tb_update('Almacenes_logicos',array('id_almacen'=>$nuevo_almacen),array('id_almacen' => $clave));
						}
					}
			} 

			if(isset($almacen_logico_borrar)){
				if (is_numeric($id_almacen)) {
					borrar_almacenes_logicos($oDb,$id_almacen,$almacen_logico_borrar);
				}
			}
		break;

		case "Importar" :
			//        debug("Importando");
			//si estamos metiendo un almacen nuevo ,
			if(isset($importar_almacenes)){
				foreach($importar_almacenes as $clave => $valor)
					if($valor == 1 ){
						$consulta="Select *  from Almacenes where Almacenes.id_almacen = $clave";
						$resul=$Sesion->query($consulta);
						$row=$Sesion->fetch_array($resul);
						$row['id_empresa'] = $usuario['id'];
						if (!$oDb->tb_replace("Almacenes",$row))
							$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Almacenes'));
					}
			}
		break;

		case "Nuevo" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro)){
					//si estamos metiendo un almacen nuevo ,
					$registro['id_empresa']= $usuario['id'];
					if (!$oDb->tb_replace("Almacenes",$registro))
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Almacenes'));
				} elseif(isset($registro_logicos)){
					//si estamos metiendo un almacen nuevo ,
					$id_almacen_sesion = $Sesion->get_var("id_almacen_promocion");
					$registro_logicos['id_almacen']= $id_almacen_sesion;
					if (!$oDb->tb_replace("Almacenes_logicos",$registro_logicos))
			  		$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Almacenes_logicos'));
				}
			}
		break;

		case "Modificar" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(!(is_object($db_conf))) {
			  		$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'Conf'));
					return;
				}
				foreach ($users as $id => $luser) {

					$oM = new MozoAlmacen();
					if (!strcasecmp($id,"new") ) {
						if (empty($luser['login'])) continue;
						$luser['id_usr'] = NULL;
						unset($luser['id_usr']);
					} else {
						if (empty($luser['id_mozo'])) {
							debug("Error: No hay IDError: , pero tampoco es nuevo. SKIP ");
							continue;
						}
						$oM->dbFill($luser['id_mozo']);
						if ($luser['borrar']) {
							$oM->delete();
							$oM->Dump();
							continue;
						}
					}
					$luser['id_almacen'] = $id_almacen;
					$oM->update($luser);
					$oM->Dump();

				}

				$registro['id_empresa']= $id_empresa;
				if (is_numeric($registro['id_almacen'])) {
					$oDb->tb_update("Almacenes",$registro);
				} else {
					if (!$oDb->tb_replace("Almacenes",$registro)) $Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Almacenes'));
				}
			}
		break;

	}//fin del case

	$id_almacen_sesion = $Sesion->get_var("id_almacen_promocion");
	//debug("glob  $id_almacen");
	//debug("ses $id_almacen_sesion");

}//fin del precode

function borrar_almacenes_logicos($oDb,$id_almacen,$aZonas) {
		$aBorrar = array();
		foreach($aZonas as $clave => $valor)
			if($valor == 1) {
				array_push($aBorrar,array('id_almacen_logico' => $clave));
				$str_where .= ( (!empty($str_where)) ? ' AND ' : '').' id_almacen_logico != '.$clave;
				$str_update .= ( (!empty($str_update)) ? ' OR ' : '').' L.id_almacen_logico = '.$clave;
			}

		if (is_array($aBorrar) AND sizeof($aBorrar) AND !empty($str_where) ) {
			$cons = 'SELECT id_almacen_logico FROM Almacenes_logicos WHERE id_almacen = '.$id_almacen.' AND '.$str_where.' ORDER BY id_almacen_logico asc LIMIT 1';
			$tmprs = $oDb->query($cons);
			// Si hay zona destino, borraremos, sino no
			if ($oDb->num_rows($tmprs)) {
				$aTmp = $oDb->fetch_row($tmprs);
				$nueva_zona = $aTmp[0];

				// Desplazamos a Bloque a la nueva zona
				$cons = 'UPDATE Localizacion_articulos L SET L.id_almacen_logico = '.$nueva_zona.' WHERE '.$str_update;
				$oDb->query($cons);

				// Si nos ha quedao algo atras, ha tenido que ser porque el mismo lote de producto exista en la nueva zona.
				// Averiguamos cuales son las coincidencias, y sumamos la cantidad
				$cons = 'SELECT L.id_articulo, L.lote, L.fecha_caducidad, L2.planta, L2.pasillo, L2.fila, L2.columna, L.cantidad '.
							'FROM Localizacion_articulos L LEFT JOIN Localizacion_articulos L2 '.
								'ON (L.id_articulo=L2.id_articulo AND L.fecha_caducidad=L.fecha_caducidad AND L.lote=L2.lote) '.
							'WHERE ( '.$str_update.' ) AND L2.id_almacen_logico = '.$nueva_zona;
				$rs = $oDb->query($cons);
				if ($oDb->num_rows($rs)) {
					while ($aTmp = $oDb->fetch_assoc($rs)) {
						$cons = 'UPDATE Localizacion_articulos SET cantidad + '.$aTmp['cantidad'].' WHERE'.
									' id_almacen_logico = '.$nueva_zona.
									' id_articulo = '.$aTmp['id_articulo'].
									' fecha_caducidad = '.wol_db::formatear_fecha($aTmp['fecha_caducidad']).
									' lote = '.$aTmp['lote'].
									' planta = '.$aTmp['planta'].
									' pasillo = '.$aTmp['pasillo'].
									' fila = '.$aTmp['fila'].
									' columna = '.$aTmp['columna'];
						$oDb->query($cons);
					}
				}

				$oDb->libera($rs);
				$oDb->tb_delete('Almacenes_logicos',$aBorrar);
				$oDb->tb_delete('Localizacion_articulos',$aBorrar);
			}
			$oDb->libera($tmprs);
		}
		return true;
}

/** funciones del listado de almacenes   logicos
  global $id_almacen;
  global $id_almacen_logico;
  global $registro;

Acciones : Modificar
/** **/
function pre_almacenes_logicos(&$Sesion) {
	$Modificar=$Sesion->fetchVar('Modificar','POST');
	$id_almacen_logico=$Sesion->fetchVar('id_almacen_logico','GET');
	$registro=$Sesion->fetchVar('registro','POST');
	$accion = $Sesion->fetchVar('accione_ejecutar','POST');

	$id_sess = $Sesion->get_var('id_almacen_logico_promocion');
	if(isset($id_almacen_logico)) {
		$Sesion->set_var("id_almacen_logico_promocion",$id_almacen_logico);
		$Sesion->set_var("id_almacen_logico",$id_almacen_logico);
	} elseif (!empty($id_sess)) {
		$id_almacen_logico = $id_sess;
	}
	$oDb = $Sesion->get_db('data');

	if( (isset($Modificar) OR !strcasecmp($accion,'Modificar')) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE)){
		//si estamos modificando un almacen logico , COGER EL  ACTIVO
		$registro['id_almacen']= $Sesion->get_var("id_almacen_promocion");
		if (!$oDb->tb_replace("Almacenes_logicos",$registro))
			$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Almacenes_logicos'));
	}//fin de Modificar
}

/** Listado de productos en un almacen logico
  global $accion_ejecutar;

  global $registro_planta;
  global $registro_pasillo;
  global $registro_fila;
  global $registro_columna;
  global $registro_cantidad;
  global $registro_fecha_caducidad;
  global $registro_fecha_alta;
  global $registro_fecha_baja;
  global $registro_lote;
  global $registro_articulo;
  global $registro_borrar;

  global$registro;
Acciones : Nuevo , Modificar , Importar , Borrar
 */
function pre_inventario_almacen(&$Sesion){
	$id_almacen=$Sesion->fetchVar('id_almacen','GET');
	$id_almacen_logico=$Sesion->fetchVar('id_almacen_logico','GET');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$oldrecord=$Sesion->fetchVar('oldrecord','POST');


	$registro_planta=$Sesion->fetchVar('registro_planta','POST');
	$registro_pasillo=$Sesion->fetchVar('registro_pasillo','POST');
	$registro_fila=$Sesion->fetchVar('registro_fila','POST');
	$registro_columna=$Sesion->fetchVar('registro_columna','POST');
	$registro_cantidad=$Sesion->fetchVar('registro_cantidad','POST');
	$registro_fecha_caducidad=$Sesion->fetchVar('registro_fecha_caducidad','POST');
	$registro_fecha_alta=$Sesion->fetchVar('registro_fecha_alta','POST');
	$registro_fecha_baja=$Sesion->fetchVar('registro_fecha_baja','POST');
	$registro_lote=$Sesion->fetchVar('registro_lote','POST');
	$registro_id=$Sesion->fetchVar('registro_id','POST');
	$registro_articulo=$Sesion->fetchVar('registro_articulo','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');

	$registro=$Sesion->fetchVar('registro','POST');

	$oDb = $Sesion->get_db('data');

	$id_almacen_logico_sesion = $Sesion->get_var("id_almacen_logico_promocion");
	if(is_numeric($id_almacen_logico)) {
		$Sesion->set_var("id_almacen_logico_promocion",$id_almacen_logico);
		$Sesion->set_var("id_almacen_logico",$id_almacen_logico);
	} elseif (is_numeric($id_almacen_logico_sesion)) {
		$id_almacen_logico = $id_almacen_logico_sesion;
	}

	$id_almacen_sesion = $Sesion->get_var("id_almacen_promocion");
	if (!is_numeric($id_almacen) AND is_numeric($id_almacen_sesion)) 
		$id_almacen = $id_almacen_sesion;
	$oAlmacen = &$Sesion->getVarByRef('oAlmacen');
	if (!isset($oAlmacen) OR $oAlmacen->getID()!=$id_almacen) {
		debug("Poblando instancia de almacen $id_almacen ... ");
		$oAlmacen = new Wherehouse();
		$oAlmacen->dbFill($id_almacen);
		$Sesion->setVarByRef('oAlmacen',$oAlmacen,'SECCION');
	}

	switch($accion_ejecutar){
		case "Nuevo" :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if(isset($registro)){
					//si estamos metiendo un almacen nuevo ,
					if (!is_numeric($registro['id_almacen_logico'])) $registro['id_almacen_logico']= $id_almacen_logico_sesion ;
					$registro['fecha_alta'] = date("Y/m/d H:m:i");
					$temp = explode("*",$registro['lote']);
					$registro['lote'] = $temp[0];
					$registro['id_articulo'] = $temp[1];
					$registro['fecha_caducidad'] = $temp[2];

					//depurar_array($registro);
					if (!$oDb->tb_insert("Localizacion_articulos",$registro)) {
						$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Localizacion_articulos'));
					} elseif (is_numeric($registro['cantidad'])) {
						$oDb->query('UPDATE Empresas_articulos set stock_ficticio = stock_ficticio + ('.$registro['cantidad'].') WHERE id_articulo = '.$registro['id_articulo']);
					}
				}
			}
		break;

		case "Modificar" :
			// print_r($oldrecord);
			//si estamos modificando un almacen , COGER EL almacen logico activo
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED) AND is_numeric($id_almacen_logico) ) {
				foreach($registro as $clave=>$aRec){
					$aLocProd['fecha_caducidad'] = wol_db::formatear_fecha($aRec['fecha_caducidad'],false);
					if (!strcasecmp($aLocProd['fecha_caducidad'],'null')) {
						$aLocProd['fecha_caducidad'] = '0000-00-00';
						$aRec['fecha_caducidad'] = NULL;
					}
					$aLocProd['lote'] = $aRec['lote'];
					$aLocIn['planta'] = $aRec['planta'];
					$aLocIn['pasillo'] = $aRec['pasillo'];
					$aLocIn['fila'] = $aRec['fila'];
					$aLocIn['columna'] = $aRec['columna'];
					// debug("vale: ".strcasecmp(wol_db::formatear_fecha($aRec['fecha_caducidad'],FALSE),wol_db::formatear_fecha($oldrecord[$clave]['fecha_caducidad'],FALSE))); 
					if ( !vector_incluido($oldrecord[$clave],$aLocProd) OR !vector_incluido($oldrecord[$clave],$aLocIn)
							OR ($aRec['cantidad']!=$oldrecord[$clave]['cantidad'] AND is_numeric($oldrecord[$clave]['cantidad']) ) ) {

						// debug("VAle... ");
						// Si coinciden las localizaciones, no se toca nada!
						if (vector_incluido($oldrecord[$clave],$aLocProd) AND vector_incluido($oldrecord[$clave],$aLocIn)) {
							debug("No se puede cambiar la cantidad de una localizacion.");
							continue;
						}
						if (empty($oldrecord[$clave]['id_almacen_logico'])) $oldrecord[$clave]['id_almacen_logico'] = $id_almacen_logico_sesion;
						if (empty($aRec['id_almacen_logico'])) $aRec['id_almacen_logico'] = $id_almacen_logico_sesion;

						$aOrig = $oldrecord[$clave];
						$aOrig['cantidad'] = ($aRec['cantidad']*-1);
						$affected = sql_update_stock($oDb,$aOrig);
						if (!(int)$affected) {
							debug("Error Inesperado. ");
							continue;
						}

						if ( (empty($aLocIn['planta']) OR $aLocIn['planta'] == $oldrecord[$clave]['planta']) AND
								(empty($aLocIn['pasillo']) OR $aLocIn['pasillo'] == $oldrecord[$clave]['pasillo']) AND
								(empty($aLocIn['fila']) OR $aLocIn['fila'] == $oldrecord[$clave]['fila']) AND 
								(empty($aLocIn['columna']) OR $aLocIn['columna'] == $oldrecord[$clave]['columna']) ) $bTryRelocate = true;
						else $bTryReLocate = false;
						$aLocFinal = update_stock($Sesion,'data',$aRec,false,$bTryRelocate);

					}
				}
			}
			break;

		case "Agrupar" :
			debug("Agrupando eto: ");
			if (is_array($registro_borrar) AND sizeof($registro_borrar)) {
				print_r($registro_borrar);
				// Buscamos el de mayor fecha:
				$idx_fechamayor = NULL;
				$idx_cantidadmayor = NULL;
				$aGrupos = array();
				foreach($registro_borrar as $idx => $anone) {
					$idart = $oldrecord[$idx]['id_articulo'];
					if (!is_array($aGrupos[$idart])) $aGrupos[$idart] = array();
					if (!is_array($aGrupos[$idart]['loc'])) $aGrupos[$idart]['loc'] = array();
					$oldrecord[$idx]['fmt_fecha_caducidad'] = wol_db::formatear_fecha($oldrecord[$idx]['fecha_caducidad'],false);;
					$aGrupos[$idart]['loc'][$idx] = $oldrecord[$idx];

					$fmtf = wol_db::formatear_fecha($oldrecord[$idx]['fecha_caducidad'],false);
					if ( $fmtf != 'null' AND $fmtf != '0000-00-00') {
						// debug("Fecha pra $idx existe: $fmtf ");
						// if (is_numeric($aGrupos[$idart]['fecha_mayor']))
							// debug('Sera '.$registro[$idx]['fecha_caducidad']." _mayor_ que ".$registro[$aGrupos[$idart]['fecha_mayor']]['fecha_caducidad']);
						if (!is_numeric($aGrupos[$idart]['fecha_mayor'])) $aGrupos[$idart]['fecha_mayor'] = $idx;
						elseif (a_mayorfecha_b($Sesion,array($oldrecord[$idx]['fmt_fecha_caducidad'],$oldrecord[$aGrupos[$idart]['fecha_mayor']]['fmt_fecha_caducidad'])) ) {
							$aGrupos[$idart]['fecha_mayor'] = $idx;
						}
					}
					if (!is_numeric($aGrupos[$idart]['cantidad_mayor'])) $aGrupos[$idart]['cantidad_mayor'] = $idx;
					elseif ($oldrecord[$idx]['cantidad'] > $oldrecord[$aGrupos[$idart]['cantidad_mayor']]['cantidad']) $aGrupos[$idart]['cantidad_mayor'] = $idx;
				}

				if (is_array($aGrupos) AND sizeof($aGrupos))
					foreach ($aGrupos as $id_art => $aProd) {
						if (!is_numeric($aProd['fecha_mayor'])) $idx_final = $aProd['cantidad_mayor'];
						else $idx_final = $aProd['fecha_mayor'];
						if (!is_numeric($idx_final)) continue;

						$aLocas = $aProd['loc'];
						$aDst = $aLocas[$idx_final];
						$aLocas[$idx_final] = NULL;
						unset($aLocas[$idx_final]);
						/** **
						debug("stockMovment DesDe: ");
						print_r($aLocas);
						debug(" A ");
						print_r($aDst);
						/** **/
						$oAlmacen->stockMovement($aLocas,$aDst,false);
						/** **
						if (is_numeric($idx_final)) {
							$cantidad_final = 0;
							$aRec = $aProd['loc'];
							foreach($aRec as $idx => $aLoc) {
								$cantidad_final += $aLoc['cantidad'];
								if ($idx == $idx_final) continue;
								$aLoc['cantidad'] *= -1;
								update_stock($Sesion,'data',$aLoc,false,false);
							}

							$aRec[$idx_final]['cantidad'] = $cantidad_final;
							update_stock($Sesion,'data',$aRec[$idx_final],false,false);
						}
						/** **/
					}
			}
			break;

		case "Importar" :
			foreach($registro as $clave => $aRec)
				if(is_numeric($aRec['id_articulo']) AND $aRec['id_articulo'] != 0 ){
					if (!is_numeric($aRec['id_almacen_logico'])) $aRec['id_almacen_logico']= $id_almacen_logico_sesion;
					if (!is_numeric($aRec['id_almacen_logico'])) break;
					$aRec['fecha_alta']= date("Y/m/d G:h");
					if (!$oDb->tb_insert("Localizacion_articulos",$aRec))
						debug("Producto ya insertado en la BBDD");
				}
			break;

		case "Borrar" :
			if (is_array($registro_borrar) AND sizeof($registro_borrar)) {
				foreach($registro_borrar as $idx => $anone){
					if ($registro[$idx]['cantidad'] == 0)
						$oDb->tb_delete('Localizacion_articulos',$registro[$idx]);
				}
			}

	}//fin de Modificar

	$Sesion->set_var('totalizar_campo','1','SUBSECCION');
	$Sesion->set_var('totalizar_valor','1','SUBSECCION');
	// $Sesion->unset_var('totalizar_campo');
	$st = $Sesion->get_var('st');
	$st_precio = $st['precio'];
	if (!empty($st_precio)) {
		$oMsg = $Sesion->getMsgs();
		$rawmsg = $oMsg->rawMsg('MISC_ALLBL_VALOR');
		$aTmpTot = array(
				'1' => array(
					array( 'field' => 'Localizacion_articulos.cantidad*Empresas_articulos.'.$st_precio, 'fnc' => 'SUM', 'name' => $rawmsg['msg'] )
					) );
		$Sesion->set_var('TotalesInforme',$aTmpTot,'SUBSECCION');
	}

}

/** OJO: Esta funcion esta capada para que funcione bien en esta seccion de efectos:
  * 	se le ha eliminado la composicion de la clausula group by.
  **/
function nodb_totalizar(&$Sesion) {
	static $aRec = array();
	static $bNotDone = TRUE;
	/** **
	static $aTot = array(
		'Clientes.id_cliente' => array(
			array( 'field' => 'Facturas.base_imponible', 'fnc' => 'SUM', 'name' => 'Facturacion (ojo idiomas)'),
			array( 'field' => 'Facturas.total_impuestos', 'fnc' => 'SUM', 'name' => 'Impuestos (ojo idiomas)'),
			array( 'field' => 'Facturas.id_factura', 'fnc' => 'COUNT', 'name' => 'No Fras (ojo idiomas)')
			),
		'Agentes.id_agente' => array(
			array( 'field' => 'Facturas.base_imponible', 'fnc' => 'SUM', 'name' => 'Ag-Facturacion (ojo idiomas)'),
			array( 'field' => 'Facturas.total_impuestos', 'fnc' => 'SUM', 'name' => 'Ag-Impuestos (ojo idiomas)', 'round' => 2),
			array( 'field' => 'Facturas.id_factura', 'fnc' => 'COUNT', 'name' => 'Ag-No Fras (ojo idiomas)')
			)
			);
	/** **/
	$aTot = $Sesion->get_var('TotalesInforme');

	if (!sizeof($aRec) AND $bNotDone) {
		$aCond = array();
		$fld = $Sesion->get_var('totalizar_campo');
		$fld = str_replace(',','.',$fld);
		$val = $Sesion->get_var('totalizar_valor');
		// debug("Cond-fld: $fld_cond  Cond-val: $val_cond");

		$aTmpfld_cond = $Sesion->get_var('totalizar_cond_campo');
		$aTmpval_cond = $Sesion->get_var('totalizar_cond_valor');
		if (is_array($aTmpfld_cond) AND is_array($aTmpval_cond))
			foreach ($aTmpfld_cond as $idx => $fld_cond) {
				$fld_cond = str_replace(',','.',$fld_cond);
				$val_cond = $aTmpval_cond[$idx];
				// Si no ha habido un error, y no este disponible el valor (es decir, haya llegado con texto clavao al nombre de campo)
				if (strcmp($val_cond,$fld_cond)) {
					array_push($aCond,array($fld_cond,$val_cond));
				}
			}

		$oDb = $Sesion->get_db('data');
		$oBuscador = $Sesion->b_activa;
		$from = $oBuscador->cons_secc[0]['from'];
		$where = $oBuscador->cons_secc[0]['where'];

		// debug("tot:".is_object($oBuscador));
		// print_r($aTot[$fld]);
		if (is_array($aTot[$fld])) {
			foreach ($aTot[$fld] as $aInfo) {
				// debug("campo $campo funcion $fnc");
				// print_r($aInfo);
				if (empty($aInfo['field'])) continue;
				$strselect .= ((!empty($strselect)) ? ', ' : '').
									( (is_numeric($aInfo['round'])) ? 'ROUND(' : '' ).
									$aInfo['fnc'].'('.$aInfo['field'].')'.
									( (is_numeric($aInfo['round'])) ? ','.$aInfo['round'].')' : '' ).
									' as "'.$aInfo['name'].'"';
			}
		}
		if (!empty($strselect)) {
			$cons = 'SELECT '.$strselect.' '.$from.' '.$where.( (!empty($where)) ? ' AND (' : ' WHERE (').$fld.' = "'.$val.'") ';
			if (is_array($aCond) AND sizeof($aCond))
				foreach ($aCond as $aC) {
					$cons .= ( (isset($aC[0]) AND isset($aC[1])) ? ' AND ( '.$aC[0].' = "'.$aC[1].'") ' : '');
				}
			// $cons .= ' GROUP BY '.$fld;
			// debug($cons);
			$idrs = $oDb->query($cons);
			if ($oDb->num_rows($idrs)) {
				$aRec = $oDb->fetch_assoc($idrs);
			} else $aRec = array();
			$oDb->libera($idrs);

		}
		$Sesion->unset_var('totalizar_cond_valor');
		$Sesion->unset_var('totalizar_cond_campo');
		$bNotDone = FALSE;
	}

	$aRetVal = NULL;
	if (sizeof($aRec)) {
		$nombre = key($aRec);
		$aRetVal['nombre_campo'] = $nombre;
		$aRetVal['valor_campo'] = $aRec[$nombre];
		array_shift($aRec);
	} else {
		$bNotDone = TRUE;
	}

	return $aRetVal;
}

function pre_baja_localizacion(&$Sesion) {
	// Lista de ids (indice) bien llege por localizaciones o detalles de albaran
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$detalle_devuelto=$Sesion->fetchVar('detalle_devuelto','POST');
	if ((!is_array($registro_borrar) or !sizeof($registro_borrar)) and is_array($detalle_devuelto)) 
		$registro_borrar = $detalle_devuelto;
	if (!is_array($registro_borrar) or !sizeof($registro_borrar)) 
		$registro_borrar = $Sesion->fetchVar('detalles_albaran','POST');
	//
	$id_almacen_logico=$Sesion->fetchVar('id_almacen_logico','GET');
	$oldrecord=$Sesion->fetchVar('oldrecord','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$albaran_venta=$Sesion->fetchVar('albaran_venta','POST');
	$factura_abono=$Sesion->fetchVar('factura_abono','POST');

	$id_almacen_logico = $Sesion->get_var('id_almacen_logico_promocion');
	$oDb = $Sesion->get_db('data');
	$aPlt = $Sesion->get_plt_array('cerrar_ventana');
	if (!is_array($aPlt) OR !sizeof($aPlt)) {
		$Sesion->lcMessage('LCS_PLT_MISCONF',array('msg' => 'Plantilla de cierre de ventana'));
		$Sesion->perror_link('javascript: window.close()');
		return;
	} else {
		$close_plt = $aPlt[1];
	}
	if ( (!is_array($registro_borrar) OR !sizeof($registro_borrar)) AND empty($accion_ejecutar) AND !is_numeric($registro['id_albaran'])) {
		$Sesion->lcMessage('LCS_NOLOCATION',NULL,IM_FATALERROR);
		$Sesion->perror_link('javascript: window.close()');
		return;
	} elseif (is_numeric($registro['id_albaran'])) {
		$id_albaran = $registro['id_albaran'];
		if (is_array($detalle_devuelto)) {
			foreach ($detalle_devuelto as $i => $bool) {
				if ($bool) $registro_borrar[$i] = $oldrecord[$i];
			}
		} else {
			$Sesion->lcMessage('LCS_NOLOCATION',NULL,IM_FATALERROR);
			$Sesion->perror_link('javascript: window.close()');
			return;
		}
	}
	$Sesion->set_var('_iterate_times',sizeof($registro_borrar));
	$id_empresa = $Sesion->get_var('id_empresa');
	if (empty($id_albaran)) $id_albaran=$Sesion->fetchVar('id_albaran','GET POST SESSION');
	if (!empty($id_albaran)) {
		$oAlb = $Sesion->get_var('oAlbaran');
		if (!is_a($oAlb,'DeliveryNote') OR $id_albaran != $oAlb->getId()) {
			// debug("Ojo, _siempre_ poblamos : Creando _nueva_ instancia a partir de los valores en la bdd");
			$oAlb = new DeliveryNote();
			$oAlb->dbFill($id_albaran);
		} else {
			debug("Instancia recuperada ... ");
			$id_albaran = $oAlb->getId();
		}
	}

	switch ($accion_ejecutar) {
		case 'Baja' :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($registro) AND sizeof($registro)) {
					if (is_numeric($albaran_venta)) $bVenta = (bool)$albaran_venta;

					if (is_a($oAlb,'DeliveryNote')) {
						foreach ($registro as $aRec) {
							$idx = $aRec['idx'];
							$cnt = $aRec['cantidad'];
							$aRec['id_factura_abono'] = $Sesion->fetchVar('id_factura_abono','POST GET');
							$oAlb->returnDetail($cnt,$aRec,$idx);
						}
						debug("Ahora es cuando hay que volcarlo: ");
						$oAlb->postDump(true,'db');
						//$oAlb->Dump();
					} else {
						debug("Pendiente: Crear una baja a pelo. con esto: ");
						foreach ($registro as $aRec) {
							if ((bool)$aRec['commit']) {
								debug("dando baja a: ");
								if ($DEBUG=="ON") print_r($aRec);
								$oB = new BajaAlmacen();
								unset($aRec['commit']);
								$oB->update($aRec);
								$oB->alterStock(true);
								$oB->Dump();
							}
						}
					}
					return $close_plt;
				}
			}
			break;

		default:
			if (is_array($registro_borrar) AND sizeof($registro_borrar))
				foreach ($registro_borrar as $i => $x) {
					if (is_array($oldrecord[$i]) and sizeof($oldrecord[$i])) {
						$aTmp['id_art'] = $oldrecord[$i]['id_articulo'];
						$aTmp['id_alm'] = $oldrecord[$i]['id_almacen_logico'];
						$aTmp['id_almacen_logico'] = $oldrecord[$i]['id_almacen_logico'];
						$aTmp['planta'] = $oldrecord[$i]['planta'];
						$aTmp['pasillo'] = $oldrecord[$i]['pasillo'];
						$aTmp['fila'] = $oldrecord[$i]['fila'];
						$aTmp['columna'] = $oldrecord[$i]['columna'];
						$aTmp['lote'] = $oldrecord[$i]['lote'];
						$aTmp['fecha_caducidad'] = $oldrecord[$i]['fecha_caducidad'];
						if (is_numeric($oldrecord[$i]['id_albaran'])) {
							$id_albaran = $oldrecord[$i]['id_albaran'];
							$aTmp['id_albaran'] = $oldrecord[$i]['id_albaran'];
							$aTmp['id_detalle'] = $oldrecord[$i]['id_detalle'];
							$aTmp['cantidad'] = $oldrecord[$i]['cantidad_devuelta'];
							$aTmp['id_alm'] = $oldrecord[$i]['id_almacen_logico'];
						} else {
							$aTmp['cantidad'] = $registro[$i]['cantidad'];
							$Sesion->unset_var('id_albaran');
						}
						$aTmp['fecha_caducidad'] = $oldrecord[$i]['fecha_caducidad'];
						$aTmp['localizacion'] = 'Pta: '.$oldrecord[$i]['planta'].
							' P: '.$oldrecord[$i]['pasillo'].
							' F: '.$oldrecord[$i]['fila'].
							' C: '.$oldrecord[$i]['columna'];
						$aTmp['producto'] = ' F.Cad: '.colocar_fecha($oldrecord[$i]['fecha_caducidad']).
							' Lote: '.$oldrecord[$i]['lote'];
						$aArt[] = $aTmp;
					} elseif (is_a($oAlb,'DeliveryNote')) {
						$aTmp = $oAlb->getDetailData(NULL,$i);
						$aTmp['id_art'] = $oAlb->getDetailAttribute('id_articulo','DetallePedido',$i);
						$aTmp['id_alm'] = $aTmp['id_almacen_logico'];
						$aTmp['idx'] = $i;
						$aTmp['localizacion'] = 'Pta: '.$aTmp['planta'].
							' P: '.$aTmp['pasillo'].
							' F: '.$aTmp['fila'].
							' C: '.$aTmp['columna'];
						$aTmp['producto'] = ' F.Cad: '.colocar_fecha($aTmp['fecha_caducidad']).
							' Lote: '.$aTmp['lote'];
						$aTmp['cantidad'] = $aTmp['cantidad_devuelta'];
						$aArt[] = $aTmp;
					}
				}
			$Sesion->set_var('referencias',$aArt);
			debug("Las ref: ");
			print_r($aArt);

			if (!empty($id_albaran)) {
				$cons = 'SELECT count(F.id_factura),F.id_cliente,F.id_proveedor '.
							'FROM Detalles_albaran Da, Facturas_detalle Fd, Facturas F '.
							'WHERE (Da.id_detalle=Fd.id_detalle AND Fd.id_factura=F.id_factura) AND Da.id_albaran = '.$id_albaran.
							' GROUP BY F.id_factura ';
				$oDb = $Sesion->get_db('data');
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					$aTmp = $oDb->fetch_row($tmprs);
					if ($aTmp[0] > 0) {
						$Sesion->set_var('se_puede_abonar',1,'INMED');
						if (!empty($aTmp[1])) {
							$str_where = 'Facturas.id_cliente = '.$aTmp[1];
						} else {
							$str_where = 'Facturas.id_proveedor = '.$aTmp[2];
						}
						$Sesion->set_var('str_where_abono',$str_where,'INMED');
					}
				}
			}
			break;
	}
}

function bkp_pre_baja_localizacion(&$Sesion) {
	$id_almacen_logico=$Sesion->fetchVar('id_almacen_logico','GET');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	if (!is_array($registro_borrar) or !sizeof($registro_borrar)) 
		$registro_borrar = $Sesion->fetchVar('detalles_albaran','POST');
	$oldrecord=$Sesion->fetchVar('oldrecord','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$detalle_devuelto=$Sesion->fetchVar('detalle_devuelto','POST');
	$albaran_venta=$Sesion->fetchVar('albaran_venta','POST');
	$factura_abono=$Sesion->fetchVar('factura_abono','POST');

	$id_almacen_logico = $Sesion->get_var('id_almacen_logico_promocion');
	$oDb = $Sesion->get_db('data');
	$aPlt = $Sesion->get_plt_array('cerrar_ventana');
	if (!is_array($aPlt) OR !sizeof($aPlt)) {
		$Sesion->lcMessage('LCS_PLT_MISCONF',array('msg' => 'Plantilla de cierre de ventana'));
		$Sesion->perror_link('javascript: window.close()');
		return;
	} else {
		$close_plt = $aPlt[1];
	}
	if ( (!is_array($registro_borrar) OR !sizeof($registro_borrar)) AND empty($accion_ejecutar) AND !is_numeric($registro['id_albaran'])) {
		$Sesion->lcMessage('LCS_NOLOCATION',NULL,IM_FATALERROR);
		$Sesion->perror_link('javascript: window.close()');
		return;
	} elseif (is_numeric($registro['id_albaran'])) {
		$id_albaran = $registro['id_albaran'];
		if (is_array($detalle_devuelto)) {
			foreach ($detalle_devuelto as $i => $bool) {
				if ($bool) $registro_borrar[$i] = $oldrecord[$i];
			}
		} else {
			$Sesion->lcMessage('LCS_NOLOCATION',NULL,IM_FATALERROR);
			$Sesion->perror_link('javascript: window.close()');
			return;
		}
	}
	$Sesion->set_var('_iterate_times',sizeof($registro_borrar));
	$id_empresa = $Sesion->get_var('id_empresa');

	switch ($accion_ejecutar) {
		case 'Baja' :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($registro) AND sizeof($registro)) {
					if (is_numeric($albaran_venta)) $bVenta = (bool)$albaran_venta;
					// debug("venta: $bVenta ");

					// Antes de Nada comprobamos los ids_facturados.
					foreach ($registro as $id => $aD) 
						if (is_numeric($aD['id_detalle']) AND is_numeric($aD['id_albaran'])) 
							$strdets .= ( (empty($strdets)) ? ' ' : ' OR ' ).' (Ad.id_detalle = '.$aD['id_detalle'].' AND Ad.id_albaran = '.$aD['id_albaran'].') ';
					if (!empty($strdets)) {
						$cons = 'SELECT Fd.id_detalle,F.id_factura,F.id_serie,estado,F.id_cliente,F.id_proveedor,A.referencia,A.fecha, '.
									'Ld.descuento as "descuento_pto", Ld.monto as "descuento_monto", Ld.precio_articulo, Ld.id_pedido '.
									'FROM Facturas_detalle Fd,Facturas F, Detalles_albaran Ad, Albaranes A, Lineas_detalle Ld '.
									'WHERE Fd.id_detalle = Ld.id_detalle AND Ld.id_detalle = Ad.id_detalle AND Ad.id_albaran = A.id_albaran '.
									'AND F.id_factura = Fd.id_factura AND F.factura_abono = 0 AND ('.$strdets.') ORDER BY F.fecha asc ';
						$tmprs = $oDb->query($cons);
						if ($oDb->num_rows($tmprs)) {
							$aFound = array();
							$id_fra = NULL;
							$aDetFras = array();
							$aoFacturas = array();
							$str_notfras = NULL;
							while ($aTmp = $oDb->fetch_assoc($tmprs)) {
								if (in_array($aTmp['id_detalle'],$aFound)) continue;
								array_push($aFound,$aTmp['id_detalle']);
								if (!empty($aTmp['id_cliente'])) {
									$bVenta = true;
									$id_cliente = $aTmp['id_cliente'];
								} else {
									$bVenta = false;
									$id_proveedor = $aTmp['id_proveedor'];
								}
								if (!is_array($aDetFras[$aTmp['id_detalle']])) 
									$aDetFras[$aTmp['id_detalle']] = array();
								array_push($aDetFras[$aTmp['id_detalle']],$aTmp['id_factura']);

								if (!is_a($aoFacturas[$aTmp['id_factura']],'Invoice')) {
									$tipo = ( ($bVenta) ? inmPed_VENTA : inmPed_COMPRA);
									$oFra = new Invoice($Sesion->App_Name,'data',$tipo);
									if ($oFra->dbFill($aTmp['id_factura'])) {
										$aoFacturas[$aTmp['id_factura']] = &$oFra;
										// debug("aoFacturas del id: ".$aTmp['id_factura']);
									}
									unset($oFra);
								}

								// Si la fra no esta emitida, Marcamos estas facturas como no validas para un abono
								//   esto es asi porque vamos a asociarlo con el mismo id_detalle, y una misma fra no puede 
								//	  tener asociado el mismo id_detalle 2 veces.
								if (!(int)$aTmp['estado'] ) $str_notfras .= ( (empty($str_notfras)) ? '' : ' AND ').' id_factura != '.$aTmp['id_factura'];
							}
						}
						$oDb->libera($tmprs);
					}

					foreach ($registro as $aRec) {
						if ($aRec['commit']!=1 OR !is_numeric($aRec['cantidad'])) continue;
						$aRec['fecha_baja'] = date('Y-m-d H:i:s');
						$cantidad = $aRec['cantidad'];

						$aTmp = array();
						$aTmp['lote'] = $aRec['lote'];
						$aTmp['fecha_caducidad'] = $aRec['fecha_caducidad'];
						$aTmp['id_articulo'] = $aRec['id_articulo'];
						$aTmp['planta'] = $aRec['planta'];
						$aTmp['fila'] = $aRec['fila'];
						$aTmp['pasillo'] = $aRec['pasillo'];
						$aTmp['columna'] = $aRec['columna'];
						$aTmp['id_empresa'] = $id_empresa;
						$bAbonar = false;
						if (!is_numeric($aRec['id_albaran']) OR $aRec['causar_baja']) {
							// debug("Damos de baja la mercaderia ...");
							// Damos de baja las mercaderias
							if (is_numeric($aRec['id_albaran'])) {
								$aTmp['id_almacen_logico'] = $aRec['id_almacen_logico'];
								if (!is_numeric($aRec['cantidad_anterior'])) $aRec['cantidad_anterior'] = 0;

								if ($cantidad < 0 AND abs($cantidad) > $aRec['cantidad_anterior']) continue;
								$cons = "UPDATE Detalles_albaran SET ";
								if ($cantidad != $aRec['cantidad_anterior'] ) {
									// Si las cantidades son distintas, actualizamos solo la diferencia.
									// debug("cantidad anterior: ".$aRec['cantidad_anterior']);
									// $stock_update = $cantidad - $aRec['cantidad_anterior'];
									$stock_update = $cantidad ;

									$cons .= ' cantidad_devuelta = cantidad_devuelta + \''.($stock_update).'\', ';
									$cons_linea = "UPDATE Lineas_detalle SET ".
														' cantidad_recibida = cantidad_recibida - \''.($stock_update).'\' ';
								} else $stock_update = $cantidad;
								$cons .= 'fecha_devolucion = NOW()';
								$cons .= ' WHERE id_detalle = '.$aRec['id_detalle'].' AND id_albaran = '.$aRec['id_albaran'].
										' AND lote = "'.$aRec['lote'].'" '.
										' AND fecha_caducidad = '.wol_db::formatear_fecha($aRec['fecha_caducidad']).' '.
										' AND id_almacen_logico = '.$aRec['id_almacen_logico'].' '.
										' AND planta = '.$aRec['planta'].' '.
										' AND pasillo = '.$aRec['pasillo'].' '.
										' AND fila = '.$aRec['fila'].' '.
										' AND columna = '.$aRec['columna'].' ';

								$cons_linea .= ' WHERE id_detalle = '.$aRec['id_detalle'];
								// No quitamos la mercaderia aqui, esto sobra. Lo hacemos en el if del tb_replace()
								// $oDb->query($cons);
								// if (!empty($cons_linea)) $oDb->query($cons_linea);
								// $oDb->query('UPDATE Albaranes set devolucion = 1 WHERE id_albaran ='.$aRec['id_albaran']);

								$aTmp['id_almacen_logico'] = $aRec['id_almacen_logico'];
								$aTmp['cantidad'] = $stock_update;
								// debug("hay albaran ... ");
								// print_r($aRec);
							} else {
								$aRec['id_albaran'] = NULL;
								unset($aRec['id_albaran']);
								$aRec['id_detalle'] = NULL;
								unset($aRec['id_detalle']);
								$aTmp['id_almacen_logico'] = $aRec['id_almacen_logico'];
								$aTmp['cantidad'] = -1 * $cantidad;
							}
							if (!is_numeric($aRec['id_albaran']) OR $bVenta) {
								// debug("Dando la baja: ");
								// print_r($aRec);
								if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
								if (is_a($oPer,'Periodo')) $aRec = $oPer->getAssignments($aRec,'Bajas_localizacion');
								$bDoIt = $oDb->tb_replace('Bajas_localizacion',$aRec);
							} else $bDoIt = true;
							if ($bDoIt) {
								// debug("Lets do it... ");
								if (!is_numeric($aRec['id_albaran'])) {
									// Si no hay albaran, lo quitamos del stock real del producto
									// debug("Updateando : "); 
									// print_r($aTmp);
									update_stock($Sesion,NULL,$aTmp,true,false);
								} else {
									// Si es una baja de un albaran, el stock ya fue actualizado en su momento.
									// Simplemente indicamos que se ha devuelto mercaderia (OJO!: Comprobar que pasa en las devoluciones de compras)
									$cons = "UPDATE Detalles_albaran SET ";
									// if (($cantidad != $stock_update OR $aRec['cantidad_anterior']==0) AND !empty($stock_update) ) 
									if (!empty($stock_update)) {
										$cons .= ' cantidad_devuelta = cantidad_devuelta + \''.($stock_update).'\', ';
										if (!is_array($aFound) OR !in_array($aRec['id_detalle'],$aFound)) {
											$cons_linea = "UPDATE Lineas_detalle SET ".
												' cantidad_recibida = cantidad_recibida - \''.($stock_update).'\' ';
										}
									} 
									$cons .= 'fecha_devolucion = NOW() ';
									if (!$bVenta AND !empty($aRec['descripcion']) ) {
										$cons .= ', observaciones = IF(observaciones IS NULL,"-['.$aRec['descripcion'].']-",CONCAT(observaciones,"\n-['.$aRec['descripcion'].']-")) ';
									}
									$cons .= ' WHERE id_detalle = '.$aRec['id_detalle'].' AND id_albaran = '.$aRec['id_albaran'].
												' AND lote = "'.$aRec['lote'].'" '.
												' AND fecha_caducidad = '.wol_db::formatear_fecha($aRec['fecha_caducidad']).' '.
												' AND id_almacen_logico = '.$aRec['id_almacen_logico'].' '.
												' AND planta = '.$aRec['planta'].' '.
												' AND pasillo = '.$aRec['pasillo'].' '.
												' AND fila = '.$aRec['fila'].' '.
												' AND columna = '.$aRec['columna'].' ';
									$oDb->query($cons);
									if (!empty($cons_linea)) {
										$cons_linea .= ' WHERE id_detalle = '.$aRec['id_detalle'];
										$oDb->query($cons_linea);
									}
									$oDb->query('UPDATE Albaranes set devolucion = 1 WHERE id_albaran ='.$aRec['id_albaran']);
								}
								$bAbonar = true;

							}

						} elseif (is_numeric($aRec['id_albaran']) AND is_numeric($aRec['id_detalle'])) {
							// No damos de baja la mercancia, es una devolucion al stock.
							// debug("No damos de baja la mercaderia.");

							if ($cantidad < 0 AND abs($cantidad) > $aRec['cantidad_anterior']) continue;
							$cons = "UPDATE Detalles_albaran SET ";
							// if (($cantidad != $aRec['cantidad_anterior'] AND is_numeric($aRec['cantidad_anterior'])) AND !empty($stock_update)) 
							if (!empty($cantidad)) {
								// Si las cantidades son distintas, actualizamos
								//$stock_update = $cantidad - $aRec['cantidad_anterior'];
								//debug("cantidad anterior: ".$aRec['cantidad_anterior']);
								$stock_update = $cantidad ;

								$cons .= ' cantidad_devuelta = cantidad_devuelta + \''.($stock_update).'\', ';
								if (!is_array($aFound) OR !in_array($aRec['id_detalle'],$aFound)) {
									$cons_linea = 'UPDATE Lineas_detalle SET cantidad_recibida = cantidad_recibida - \''.($stock_update).'\' ';
								}
							} else $stock_update = $cantidad;
							$cons .= 'fecha_devolucion = NOW()';
							if (!empty($aRec['descripcion']) ) {
								$cons .= ', observaciones = IF(observaciones IS NULL,"-['.$aRec['descripcion'].']-",CONCAT(observaciones,"\n-['.$aRec['descripcion'].']-")) ';
							}
							$cons .= ' WHERE id_detalle = '.$aRec['id_detalle'].' AND id_albaran = '.$aRec['id_albaran'].
										' AND lote = "'.$aRec['lote'].'" '.
										' AND fecha_caducidad = '.wol_db::formatear_fecha($aRec['fecha_caducidad']).' '.
										' AND id_almacen_logico = '.$aRec['id_almacen_logico'].' '.
										' AND planta = '.$aRec['planta'].' '.
										' AND pasillo = '.$aRec['pasillo'].' '.
										' AND fila = '.$aRec['fila'].' '.
										' AND columna = '.$aRec['columna'].' ';
							$oDb->query($cons);
							if (!empty($cons_linea)) {
								$cons_linea .= ' WHERE id_detalle = '.$aRec['id_detalle'];
								$oDb->query($cons_linea);
							}
							$oDb->query('UPDATE Albaranes set devolucion = 1 WHERE id_albaran ='.$aRec['id_albaran']);
							$aTmp['id_almacen_logico'] = $aRec['id_almacen_logico'];
							$aTmp['cantidad'] = $stock_update;
							// Actualizamos tambien el stock estimado.
							if (!$bVenta) $aTmp['cantidad'] *= -1;
							update_stock($Sesion,NULL,$aTmp,true);
							$bAbonar = true;
						}

						// Si hay que abonar la mercaderia ...
						if ($bAbonar AND is_array($aFound) AND sizeof($aFound) AND isset($bVenta) 
								AND !empty($stock_update) AND in_array($aRec['id_detalle'],$aFound)) {
							// debug("Hay que abonar en el id($bVenta): $id_fra  - cant: $stock_update ");
							// print_r($aRec);
							if (!is_object($oFactura)) {
								// Si no sabemos el id_fra, buscamos una factura no emitida para abonar ahi.
								$id_fra = $Sesion->fetchVar('id_factura_abono','POST GET');
								$tipo = ( ($bVenta) ? inmPed_VENTA : inmPed_COMPRA);
								$oFactura = new Invoice($Sesion->App_Name,'data',$tipo);

								if (!empty($id_fra)) {
									if (!$oFactura->dbFill($id_fra)) {
										$id_fra = NULL;
										unset($oFactura);
										$oFactura = new Invoice($Sesion->App_Name,'data',$tipo);
									}
								} 

								if (empty($id_fra)) {
									// Poblamos la factura.
									if ($bVenta) {
										$oFactura->set_issuer($id_empresa);
										$oFactura->set_reciever($id_cliente);
									} else {
										$oFactura->set_issuer($id_proveedor);
										$oFactura->set_reciever($id_empresa);
									}
								}
							} 

							$id_facturita = $aDetFras[$aRec['id_detalle']][0];
							if (is_numeric($id_facturita) AND !empty($id_facturita) AND 
									is_a($aoFacturas[$id_facturita],'Invoice')
									) {
								// debug("id: $id_facturita det ".$aRec['id_detalle']);
								$idx = $oFactura->get_idxdetail_db($aRec['id_detalle']);
								if (!is_numeric($idx)) {
									$idx = $aoFacturas[$id_facturita]->get_idxdetail_db($aRec['id_detalle']);
									$oFactura->setInstallment(NULL,$aoFacturas[$id_facturita],array($idx => 1),true,false);
									$idx = $oFactura->get_idxdetail_db($aRec['id_detalle']);
									$oFactura->set_quantity($idx,$stock_update,NULL,false);
									// debug("El idx = $idx , con cantidad ".$oFactura->get_quantity($idx));
								} else {
									// debug("la Fra $id_facturita ya tenia el detalle. ");
									$oFactura->set_quantity($idx,$stock_update,NULL,true);
								}
								// debug("idx $idx con $stock_update que son ".$oFactura->get_quantity($idx));
							} else {
								// debug("No hemos encontrado la clase... que mal rollito. ");
								$idx = $oFactura->get_idxdetail_db($aRec['id_detalle']);
								if (!is_numeric($idx)) {
									$idx = $oFactura->add_detail($aRec['id_articulo'],$stock_update,0,false);
									$oFactura->setDetailAttribute($idx,'id_detalle',$aRec['id_detalle']);
									$oFactura->setDetailAttribute($idx,'id_pedido',$aRec['id_pedido']);
								} else {
									$oFactura->set_quantity($idx,$stock_update,NULL,true);
								}
								/** **
								if ($aCond['precio_articulo'] != $oFactura->get_price($idx,FALSE)) {
									$oFactura->set_price($idx,$aCond['precio_articulo'],FALSE);
								}
								// Corregimos los descuentos:
								if (empty($aCond['descuento_pto']) AND empty($aCond['descuento_monto'])) {
									if ($oFactura->have_discount($idx)) $oFactura->set_detail_discount($idx,0,0,'',TRUE);
								} else {
									if (!empty($aCond['descuento_pto'])) 
										$oFactura->set_detail_discount($idx,$aCond['descuento_pto'],TRUE,' - ',TRUE);
									elseif (!empty($aCond['descuento_monto'])) 
										$oFactura->set_detail_discount($idx,$aCond['descuento_monto'],FALSE,' - ',TRUE);
								}
								$oFactura->setDetailAttribute($idx,'id_pedido',$aCond['id_pedido']);
								$oFactura->_aIDPedido[$aCond['id_pedido']]['id_pedido'] = $aCond['id_pedido'];

								// Fixme: pequeña chapuza para que la factura sepa que tiene albaranes, y no debe actualizar el stock estimado.
								$oFactura->_aIDAlbaran[$aRec['id_albaran']]['referencia'] = $aCond['referencia'];
								$oFactura->_aIDAlbaran[$aRec['id_albaran']]['fecha'] = $aCond['fecha'];
								// Anyadimos referencia del albaran que causa el abono.
								$oFactura->set_detail_comment($idx,$aCond['referencia'].' ('.$aCond['fecha'].'): '.$aRec['descripcion']);
								/** **/
							}
						}
					}
					if (is_object($oFactura) AND $oFactura->num_details()>0) {
						// debug("Volcando fra: ".$oFactura->getId()." con ".$oFactura->num_details()." detalles ");
						$oFactura->dbDump();
					}
					return $close_plt;
				}
			}
			break;

		default:
			if (is_array($registro_borrar) AND sizeof($registro_borrar))
				foreach ($registro_borrar as $i => $x) {
					$aTmp['id_art'] = $oldrecord[$i]['id_articulo'];
					$aTmp['id_alm'] = $oldrecord[$i]['id_almacen_logico'];
					$aTmp['id_almacen_logico'] = $oldrecord[$i]['id_almacen_logico'];
					$aTmp['planta'] = $oldrecord[$i]['planta'];
					$aTmp['pasillo'] = $oldrecord[$i]['pasillo'];
					$aTmp['fila'] = $oldrecord[$i]['fila'];
					$aTmp['columna'] = $oldrecord[$i]['columna'];
					$aTmp['lote'] = $oldrecord[$i]['lote'];
					$aTmp['fecha_caducidad'] = $oldrecord[$i]['fecha_caducidad'];
					if (is_numeric($oldrecord[$i]['id_albaran'])) {
						$id_albaran = $oldrecord[$i]['id_albaran'];
						$aTmp['id_albaran'] = $oldrecord[$i]['id_albaran'];
						$aTmp['id_detalle'] = $oldrecord[$i]['id_detalle'];
						$aTmp['cantidad'] = $oldrecord[$i]['cantidad_devuelta'];
						$aTmp['id_alm'] = $oldrecord[$i]['id_almacen_logico'];
					} else {
						$aTmp['cantidad'] = $registro[$i]['cantidad'];
						$Sesion->unset_var('id_albaran');
					}
					$aTmp['fecha_caducidad'] = $oldrecord[$i]['fecha_caducidad'];
					$aTmp['localizacion'] = 'Pta: '.$oldrecord[$i]['planta'].
						' P: '.$oldrecord[$i]['pasillo'].
						' F: '.$oldrecord[$i]['fila'].
						' C: '.$oldrecord[$i]['columna'];
					$aTmp['producto'] = ' F.Cad: '.colocar_fecha($oldrecord[$i]['fecha_caducidad']).
						' Lote: '.$oldrecord[$i]['lote'];
					$aArt[] = $aTmp;
				}
			$Sesion->set_var('referencias',$aArt);

			if (!empty($id_albaran)) {
				$cons = 'SELECT count(F.id_factura),F.id_cliente,F.id_proveedor '.
							'FROM Detalles_albaran Da, Facturas_detalle Fd, Facturas F '.
							'WHERE (Da.id_detalle=Fd.id_detalle AND Fd.id_factura=F.id_factura) AND Da.id_albaran = '.$id_albaran.
							' GROUP BY F.id_factura ';
				$oDb = $Sesion->get_db('data');
				$tmprs = $oDb->query($cons);
				if ($oDb->num_rows($tmprs)) {
					$aTmp = $oDb->fetch_row($tmprs);
					if ($aTmp[0] > 0) {
						$Sesion->set_var('se_puede_abonar',1,'INMED');
						if (!empty($aTmp[1])) {
							$str_where = 'Facturas.id_cliente = '.$aTmp[1];
						} else {
							$str_where = 'Facturas.id_proveedor = '.$aTmp[2];
						}
						$Sesion->set_var('str_where_abono',$str_where,'INMED');
					}
				}
			}
			break;
	}

}

function nodb_bajas_localizacion(&$Sesion) {
	$aRef = $Sesion->get_var('referencias');
	if (!is_array($aRef) OR !sizeof($aRef)) return NULL;
	$aRetVal = array_shift($aRef);
	$Sesion->set_var('referencias',$aRef);
	return $aRetVal;
}

function pre_bajas_localizacion(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST',NULL,'Bajas_localizacion');
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$oDb = $Sesion->get_db('data');
	$id_empresa = $Sesion->get_var('id_empresa');

	// debug("acc: $accion_ejecutar");
	switch ($accion_ejecutar) {
		case 'Modificar' :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (is_array($registro) AND sizeof($registro)) {
					if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
					if (is_a($oPer,'Periodo')) $registro = $oPer->getAssignments($registro,'Bajas_localizacion');
					$oDb->tb_update('Bajas_localizacion',$registro);
					if (is_numeric($registro['cantidad']) AND $registro['cantidad'] != $registro['cantidad_anterior']) {
						$stock_update = $registro['cantidad_anterior'] - $registro['cantidad'];
						if (!is_numeric($registro['id_albaran']) AND !is_numeric($registro['id_detalle'])) {
							$aTmp['id_empresa'] = $id_empresa;
							$aTmp['id_almacen_logico'] = $registro['id_almacen_logico'];
							$aTmp['id_articulo'] = $registro['id_articulo'];
							$aTmp['planta'] = $registro['planta'];
							$aTmp['pasillo'] = $registro['pasillo'];
							$aTmp['fila'] = $registro['fila'] + 1;
							$aTmp['columna'] = $registro['columna'];
							$aTmp['lote'] = $registro['lote'];
							$aTmp['fecha_caducidad'] = $registro['fecha_caducidad'];
							$aTmp['cantidad'] = $registro['cantidad_anterior'] - $registro['cantidad'];
							update_stock($Sesion,NULL,$aTmp);
						} else {
							$cons = 'UPDATE Detalles_albaran SET '.
								'observaciones="'.$registro['descripcion'].'", '.
								'cantidad_devuelta = cantidad_devuelta + \''.(-1 * $stock_update).'\' '.
								'WHERE id_albaran = '.$registro['id_albaran'].' AND id_detalle = '.$registro['id_detalle'].
								' AND lote = "'.$registro['lote'].'" '.
								' AND fecha_caducidad = '.wol_db::formatear_fecha($registro['fecha_caducidad']).' '.
								' AND id_almacen_logico = '.$registro['id_almacen_logico'].' '.
								' AND planta = '.$registro['planta'].' '.
								' AND pasillo = '.$registro['pasillo'].' '.
								' AND fila = '.$registro['fila'].' '.
								' AND columna = '.$registro['columna'].' ';
							$oDb->query($cons);

						}
					}
				}
			}
			break;
	}
}

function off_cantidad(&$Sesion,&$aDatos){
	//depurar_array($aDatos);
	debug("cantidad");
	$oDb = $Sesion->get_db('data');
	$id_art = $aDatos["Localizacion_articulos.id_articulo"];
	if($aDatos["Empresas_articulos.stock"]){
		$consulta = "select sum(Localizacion_articulos.cantidad) From Localizacion_articulos where Localizacion_articulos.id_articulo = $id_art group by Localizacion_articulos.id_articulo";
		$resul=$oDb->query($consulta);
		$row=$oDb->fetch_array($resul);
		//        depurar_array($row);
		return $row[0];
	} else return "Sin stock";
}

// Prueba de merging, pero al final (V1.4_beta)

?>
