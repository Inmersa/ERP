<?php

function pre_recorrido(&$Sesion) {
	$fecha=$Sesion->fetchVar('fecha','POST');
	global $id_ag;				//Variable de Buscador
	$iniciar=$Sesion->fetchVar('iniciar','GET');
	global $id_recorrido;	// Variable de Buscador
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$gastos=$Sesion->fetchVar('gastos','POST');

	$oDb = $Sesion->get_db('data');

	$id_ag_sess = $Sesion->get_var('id_agente_pda');
	$user = identifica_usuarios($Sesion);
	if ($user['desktop_name'] == 'Agentes') {
		$id_ag = $user['valor'];
		$Sesion->set_var('id_agente_pda',$id_ag,"SECCION");
	} elseif (is_numeric($id_ag_sess)) {
		$id_ag = $id_ag_sess;
	} else {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Agentes'));
		$Sesion->perror_link('?seccion=pda_clientes_ruta');
		return;
	}

	$id_recorrido_sess = (int)$Sesion->get_var('id_recorrido_pda');
	if ((int)$iniciar AND (int)$id_recorrido) {
		$hora = date('H:i');
		$hoy = date('Y-m-d');
		$aTmp = array('id_recorrido' => $id_recorrido,'h_inicio' => $hora,'fecha' => $hoy);
		if (!is_a($oPer,'Periodo')) $oPer = &Periodo::factoryActivePeriod();
		if (is_a($oPer,'Periodo')) $aTmp = $oPer->getAssignments($aTmp,'Recorridos');
		$oDb->tb_update('Recorridos',$aTmp);
		$Sesion->set_var('fecha_recorrido',$hoy,'SECCION');
	} elseif (!is_numeric($id_recorrido) OR empty($id_recorrido)) {
		if (empty($id_recorrido_sess)) {
			$id_recorrido = $Sesion->get_var('id_recorrido_act');
			if (!is_numeric($id_recorrido)) $id_recorrido = '%';
		} else $id_recorrido = $id_recorrido_sess;
	}
	$Sesion->set_var('id_recorrido_pda',$id_recorrido,'SECCION');

	switch($accion_ejecutar) {
		case 'cerrar_cita' :
			if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if ((int)$registro['id_cita']) {
					$registro['visitado'] = (int)$registro['visitado'];
					$registro['h_fin_sys'] = date('H:i');
					$oDb->tb_update('Citas',$registro);
				}
			}
			break;

		case 'cerrar_recorrido' :
			if (!strcasecmp($registro['id_recorrido'],'%') AND is_numeric($id_recorrido)) {
				$registro['id_recorrido'] = $id_recorrido;
			}
			if ((int)$registro['id_recorrido']) {
				if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
					$registro['h_fin'] = date('H:i');
					$oDb->tb_update('Recorridos',$registro);
					if (is_array($gastos))
						foreach ($gastos as $idg => $aTmp) {
							$aTmp['id_recorrido'] = $registro['id_recorrido'];
							$aTmp['id_gasto'] = $idg;
							$oDb->tb_replace('Recorridos_gastos',$aTmp);
						}
				}
				$Sesion->unset_var('id_recorrido_pda');
				$Sesion->unset_var('fecha_recorrido');
			}
			break;

		case 'confirmar_pedido';
			  $oPedido = $Sesion->get_var('oPedido_en_curso');
			  if (!is_object($oPedido)) {
				  $Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
				  $Sesion->perror_link('?seccion=pda_clientes_ruta');
				  return NULL;
			  }

			  if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				  if (!$oPedido->set_reciever_address($registro['id_direccion']))
						if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

				  $oPedido->set_agent($id_ag,TRUE);
				  $oPedido->set_comments($registro['observaciones']);

			  }

			  if ($Sesion->verifyVar('servicio',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('servicio',IKRN_VAR_CRC_AUTHED)) {
				  if ($oPedido->debug) debug("nos pateamos los detalles para establecer valores");
				  for ($idx = $oPedido->first_detail(); isset($idx); $idx = $oPedido->next_detail()) {
						if (is_numeric($servicio[$idx]))
							$oPedido->set_detail_contract($idx,$servicio[$idx]);
				  }
			  }

			  $oPedido->calculate();
			  $oPedido->dbdump();
			  $Sesion->unset_var('oPedido_en_curso');

			  // Fixme: Comprobar estas variables!
			  $Sesion->unset_var("id_direccion_cliente");
			  break;
	}

}

function pre_pda_cliente(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','POST');
	$id_cita=$Sesion->fetchVar('id_cita','GET');
	$pago=$Sesion->fetchVar('pago','POST');

	$Sesion->set_var('ss_nm',$Sesion->get_subsecc_name(),'INMED');
	$Sesion->set_var('old_ss_nm',$Sesion->get_old_subsecc_name(),'INMED');
	$Sesion->set_var('ss_qs',$Sesion->get_subsecc_querystring(),'INMED');

	$oDb = $Sesion->get_db('data');
	$id_cita_sess = $Sesion->get_var('id_cita_pda');
	if (is_numeric($id_cita)) {
		$id_cita_sess = $Sesion->get_var('id_cita_pda');
		$Sesion->set_var('id_cita_pda',$id_cita,'SECCION');
		if ($id_cita_sess != $id_cita) $oDb->tb_update('Citas',array('id_cita' => $id_cita, 'h_inicio' => date('H:i')));
	} elseif (is_numeric($id_cita_sess)) {
		$id_cita = $Sesion->get_var('id_cita_pda');
		// $Sesion->unset_var('id_cita_pda');
	}

	$id_agente_sesion = $Sesion->get_var('id_agente_pda');
	if (!strcasecmp($usuario['desktop_name'],'agente')) {
		$id_agente = $usuario['valor'];
		$Sesion->set_var("id_agente_pda",$id_cliente);
	} elseif (!empty($id_agente_sesion) AND is_numeric($id_agente_sesion)) {
		$id_agente = $id_agente_sesion;
	} 

	$id_cli_sess = $Sesion->get_var('id_cliente_pda');
	if (is_numeric($id_cliente)) {
		if (is_numeric($id_agente)) {
			$cons = "SELECT * FROM Agentes_clientes WHERE id_agente = $id_agente AND id_cliente = $id_cliente";
			$tmp_rs = $oDb->query($cons);
			if ($oDb->num_rows($tmp_rs)) {
				$Sesion->set_var('id_cliente_pda',$id_cliente,'SECCION');
				$Sesion->unset_var('id_cita_pda');
			} else $id_cliente = 0;
		} else $id_cliente = 0;
	} elseif (is_numeric($id_cita)) {
		if (!is_numeric($id_cita)) {
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Citas'));
			$Sesion->perror_link('?seccion=pda_clientes_ruta');
			return ; 
		}
		if (is_numeric($id_cli_sess)) $Sesion->unset_var('id_cliente_pda');
		$cons = "SELECT id_cliente FROM Citas WHERE id_cita = $id_cita";
		$tmprs = $oDb->query($cons);
		$aTmp = $oDb->fetch_assoc($tmprs);
		$id_cliente = $aTmp['id_cliente'];
	} elseif (is_numeric($id_cli_sess)) {
		$id_cliente = $id_cli_sess;
	} else {
		$id_cliente = 0;
	}
	$Sesion->set_var('id_cliente_pda',$id_cliente,'SECCION');

	if ($id_cliente AND is_array($pago) AND sizeof($pago)) 
		foreach ($pago as $id_efecto => $aEff) {
			if (is_numeric($aEff['importe']) AND $aEff['importe']>0 AND (abs($aEff['monto_pagado']) + abs($aEff['importe']) <= abs($aEff['monto']+1))) {
				$aTmp['id_efecto'] = $id_efecto;
				$aTmp['monto_satisfecho'] = $aEff['importe'];
				$aTmp['fecha'] = date('Y-m-d H:m');
				$aTmp['medio_pago'] = $aEff['medio_pago'];
				$aTmp['notas'] = $aEff['notas'];
				$aTmp['id_cita'] = $id_cita;
				$oDb->tb_insert('Efectos_parciales',$aTmp);

				$cons = 'UPDATE Efectos set monto_pagado = monto_pagado + '.$aEff['importe'].
							( (abs($aEff['monto_pagado']) + abs($aEff['importe']) >= abs($aEff['monto'])) ? ', pagado = 1, fecha_abono = NOW() ' : ' ').
							'WHERE id_efecto = '.$id_efecto;
				$oDb->query($cons);
				// print_r($aTmp);
				//debug($cons);
				$aTmp = NULL;
			}
		}

}

function pre_cerrar_cita(&$Sesion) {
	$registro=$Sesion->fetchVar('registro','POST');
	$Confirmar=$Sesion->fetchVar('Confirmar','POST');
	$id_cita=$Sesion->fetchVar('id_cita','POST');
	if (!$id_cita) {
		$id_cita = $Sesion->get_var('id_cita_pda');
		if (!$id_cita) {
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Citas'),'IM_FATALERROR');
			$Sesion->perror_link('?seccion=pda_clientes_ruta');
			return;
		}
	}
	$Sesion->set_var('id_cita',$id_cita,'SUBSECCION');

	$id_ag_sess = $Sesion->get_var('id_agente_pda');
	$user = identifica_usuarios($Sesion);
	if ($user['desktop_name'] == 'Agentes') {
		$id_ag = $user['valor'];
		$Sesion->set_var('id_agente_pda',$id_ag,"SECCION");
	} elseif (is_numeric($id_ag_sess)) {
		$id_ag = $id_ag_sess;
	} else {
		$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Agentes'));
		$Sesion->perror_link('?seccion=pda_clientes_ruta');
		return;
	}

	if (is_numeric($id_cita))
		$Sesion->set_var('id_cita_pda',$id_cita,'SECCION');
	else $id_cita = $Sesion->get_var('id_cita_pda');

	$oDb = $Sesion->get_db('data');
	$id_cli_sess = $Sesion->get_var('id_cliente_pda');
	if (is_numeric($id_cliente))
		$Sesion->set_var('id_cliente_pda',$id_cliente,'SECCION');
	elseif (is_numeric($id_cita)) {
		if (!is_numeric($id_cita)) return NULL; //TODO: Cambiar por msg de error.
		if (is_numeric($id_cli_sess)) $Sesion->unset_var('id_cliente_pda');
		$cons = "SELECT id_cliente FROM Citas WHERE id_cita = $id_cita";
		$tmprs = $oDb->query($cons);
		$aTmp = $oDb->fetch_assoc($tmprs);
		$id_cliente = $aTmp['id_cliente'];
		$Sesion->set_var('id_cliente_pda',$id_cliente,'SECCION');
	} elseif (is_numeric($id_cli_sess)) {
		$id_cliente = $id_cli_sess;
	} else {
		$id_cliente = 0;
	}
	
	if(isset($Confirmar)){
			  $oPedido = $Sesion->get_var('oPedido_en_curso');
			  if (!is_object($oPedido)) {
				  $Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
				  $Sesion->perror_link('?seccion=pda_clientes_ruta');
				  return ;
			  }

			  if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				  if (!$oPedido->set_reciever_address($registro['id_direccion']))
						if ($oPedido->debug) debug("No se ha podido establecer la direccion de entrega");

				  if (is_numeric($id_ag)) $oPedido->set_agent($id_ag,TRUE);
				  $oPedido->set_comments($registro['observaciones']);

				  if ($oPedido->debug) debug("nos pateamos los detalles para establecer valores");
				  /** No hay comentarios ni servicios **
				  for ($idx = $oPedido->first_detail(); isset($idx); $idx = $oPedido->next_detail()) {
						if (!empty($observaciones[$idx]))
							$oPedido->set_detail_comment($idx,$observaciones[$idx]);
						if (is_numeric($servicio[$idx]))
							$oPedido->set_detail_contract($idx,$servicio[$idx]);
				  }
				  /** **/

				  $oPedido->calculate();
				  $oPedido->dbdump();
				  $Sesion->unset_var('oPedido_en_curso');
				  $id = $oPedido->get_id();
				  $oDb->tb_update('Citas',array('id_cita' => $id_cita,'id_pedido' => $id));

				  // Fixme: Comprobar estas variables!
				  $Sesion->unset_var("id_direccion_cliente");
			  }

	} else { //fin de confirmar  un pedido
		// debug("Borrando el pedido en curso");
		// $Sesion->unset_var("oPedido_en_curso");
	}

}

function pre_pda_hacer_pedido(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');

	// Variables para hacer/modificar un pedido.
	$Anyadir=$Sesion->fetchVar('Anyadir','POST');
	$vaciar_pedido=$Sesion->fetchVar('vaciar_pedido','GET');
	$array_ids=$Sesion->fetchVar('array_ids','POST');
	$array_numero=$Sesion->fetchVar('array_numero','POST');
	$array_detalle=$Sesion->fetchVar('array_detalle','POST');
	$array_bultos=$Sesion->fetchVar('array_bultos','POST');
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST');

	// No se necesita: global $id_cita;
	$repo=$Sesion->fetchVar('repo','POST');

	// Fixme: Accesos de Usuarios.
	$usuario = identifica_usuarios($Sesion);
	$id_emp = $usuario['id'];

	$oPedido = $Sesion->get_var('oPedido_en_curso');
	$oDb = $Sesion->get_db('data');

	if ((int)$vaciar_pedido AND is_object($oPedido)) {
		if (!isset($id_cliente)) {
			if ($oPedido->debug) debug("Vaciando el pedido y recogiendo sus datos");
			$aPed = $oPedido->get_info();
			$id_cliente = $aPed['id_cliente'];
			$id_emp = $aPed['id_empresa'];
			$id_tarifa = $aPed['id_tarifa'];
			$id_ped = (int)$aPed['id_pedido'];
		} 
		if ($oPedido->debug) debug("reeeeset de pedido");
		$oPedido = NULL;
		$Sesion->unset_var('oPedido_en_curso');
		$Sesion->unset_var('aIDxsNotToCheck');
	}

	if (is_object($oPedido) AND is_numeric($id_cliente)) {
		$id_cli = $oPedido->get_reciever_id();
		if ($id_cli != $id_cliente) $oPedido = NULL;
	}

	if (!is_object($oPedido)) {
		// debug("No existe el pedido, probamos a construirlo..");
		$id_cliente_sesion = $Sesion->get_var("id_cliente_pda");
		if (!is_numeric($id_cliente_sesion)) {
			if (!is_numeric($id_cita)) $id_cita = $Sesion->get_var('id_cita_pda');
			if (!is_numeric($id_cita)) {
				$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Citas'));
				$Sesion->perror_link('?seccion=pda_clientes_ruta');
				return ; 
			}
			$cons = "SELECT id_cliente FROM Citas WHERE id_cita = $id_cita";
			$tmprs = $oDb->query($cons);
			$aTmp = $oDb->fetch_assoc($tmprs);
			$id_cliente = $aTmp['id_cliente'];
		}
		if (!strcasecmp($usuario['desktop_name'],'cliente')) {
			$id_cliente = $usuario['valor'];
			$Sesion->set_var("id_cliente_pda",$id_cliente);
		} elseif (isset($id_cliente)) {
			$id_cliente_sesion = $id_cliente;
			$Sesion->set_var("id_cliente_pda", $id_cliente);
		} elseif (!empty($id_cliente_sesion) AND is_numeric($id_cliente_sesion)) {
			$id_cliente = $id_cliente_sesion;
		} else {
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Clientes'));
			$Sesion->perror_link('?seccion=pda_clientes_ruta');
			return ;
		}
		$Sesion->set_var("id_cliente_pedido", $id_cliente);

		$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA,$tipo_doc);
		$base_ok = 0;
		if (!$base_ok) {
			if (!$id_ped) {
				if ($oPedido->debug) debug("Emisor $id_emp");
				$oPedido->set_issuer($id_emp);
				if ($oPedido->debug) debug("receptor $id_cliente");
				$oPedido->set_reciever($id_cliente);
				if (!strcasecmp($usuario['desktop_name'],'Agentes')) $id_agente = $usuario['valor'];
				if (is_numeric($id_agente)) $oPedido->set_agent($id_agente);
			} else {
				if (!$oPedido->dbfill($id_ped)) {
					if ($oPedido->debug) debug("No se ha podido rellenar los datos provenientes del pedido $id_ped");
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $id_ped));
					$Sesion->perror_link('?seccion=pda_clientes_ruta');
					return ;
				}
			}
		}
	} else {
		$id_cliente = $oPedido->get_reciever_id();
		if ($oPedido->debug) debug("oPedido es un objeto! cliente = $id_cliente; N detalles = ".sizeof($oPedido->_aDetalles));
	}

	$id_cli = $Sesion->get_var("id_cliente_pedido");
	if (!(int)$id_cli)
		$id_cli = $Sesion->get_var("id_cliente_pda");
	if (!(int)$id_cli)
		$id_cli = $oPedido->get_reciever_id();
		
	$Sesion->set_var("id_cliente_pedido", $id_cli);
	$Sesion->set_var("id_cliente_pda", $id_cli);

	// Referencias HAbituales del Cliente:
	$check_them = TRUE;
	if ($Sesion->verifyVar('repo',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('repo',IKRN_VAR_CRC_AUTHED)) {
		if (is_array($repo)) {
			if (strcasecmp($repo['fecha_inicio'],'dd/mm/aaaa') ) {
				$fini = wol_db::formatear_fecha($repo['fecha'],FALSE);
				$cons = "SELECT t1.id_articulo,SUM(t1.cantidad) ".
					  "FROM Lineas_detalle t1, Pedidos t2, Direcciones_entrega t3 ".
					  "WHERE t1.id_pedido=t2.id_pedido AND ".
					  "(t2.id_proveedor = 0 OR t2.id_proveedor IS NULL) AND ".
					  "t2.id_direccion=t3.id_direccion AND ".
					  "t3.id_cliente = $id_cliente AND t2.fecha between ".
					  "'$fini' AND NOW() ".
					  "GROUP BY t1.id_articulo ";
				$idrs = $oDb->query($cons);
				if ($oDb->num_rows($idrs)) {
					$check_them = FALSE;
					$Anyadir = 1;
					while($aTmp = $oDb->fetch_row($idrs)) {
						$array_numero[$aTmp[0]] = $aTmp[1];
						$array_ids[$aTmp[0]] = $aTmp[0];
					}
				}
			}
		}
	}

	$aNotToCheck = $Sesion->get_var('aIDxsNotToCheck');
	if (!is_array($aNotToCheck)) {
		$aNotToCheck = array();
		if ($check_them) 
			$Sesion->set_var('pda_check_them',1,'INMED');
	} else {
		$Sesion->set_var('pda_check_them',0,'INMED');
	}

	if(isset($Anyadir)) {
	//si estamos borrando eliminar
		if ($Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('borrar_articulos',IKRN_VAR_CRC_AUTHED)) {
			if(is_array($borrar_articulos)) {
				debug("Fixme: borrar_articulos se ha disparado, comprobar en array.");
				foreach($borrar_articulos as $id_articulo)
					unset($array_numero[$id_articulo]);
			}
		}

		if ($Sesion->verifyVar('array_numero',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('array_numero',IKRN_VAR_CRC_AUTHED)) {
			if (is_array($array_numero))
				foreach($array_numero as $idx => $num) {
					if (!is_numeric($num) OR empty($num)) continue;
					if ((int)$array_bultos[$idx]) $bBultos = TRUE;
					else $bBultos = FALSE;

					$id_art = $array_ids[$idx];
					if ($oPedido->debug) debug("localizando cantidad idx $idx ... $id_art ($num)"); 
					$idxdet = $oPedido->add_detail($id_art,$num,$bBultos);
					if (!$check_them AND !in_array($idxdet,$aNotToCheck)) 
						array_push($aNotToCheck,$idxdet);
				}
		}
	}
	if (is_array($aNotToCheck) AND sizeof($aNotToCheck)) 
		$Sesion->set_var('aIDxsNotToCheck',$aNotToCheck,'SUBSECCION');

	$Sesion->set_var("oPedido_en_curso",$oPedido);

}//fin del precode

function pda_confirmar_check(&$Sesion,$aParams) {
	static $aNotToCheck;

	// print_r($aParams);
	if (!is_array($aNotToCheck) AND !sizeof($aNotToCheck)) {
		$aNotToCheck = $Sesion->get_var('aIDxsNotToCheck');
		if (!is_array($aNotToCheck) OR !sizeof($aNotToCheck)) return TRUE;
	}

	$idx = $aParams['idx_detalle'];
	if (!is_numeric($idx)) return FALSE;
	// debug("Comprobando id: ".$idx);
	return !in_array($idx,$aNotToCheck);
}

function pre_pda_confirmar_pedido(&$Sesion) {
	$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');	//array de checkboxes con los ke keremos konfirmar
	$articulos_cesta=$Sesion->fetchVar('articulos_cesta','POST');			//array de hidden que habia en la cesta (para no borrar los k entran por promo)
	$array_bultos=$Sesion->fetchVar('array_bultos','POST');
	$array_numero=$Sesion->fetchVar('array_numero','POST');
	$registro=$Sesion->fetchVar('registro','POST');

	$oPedido = $Sesion->get_var("oPedido_en_curso");
	$oPedido->debug = 0;

	if (!is_object($oPedido)) {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
		$Sesion->perror_link('?seccion=pda_clientes_ruta');
		return ;
	}

	if ($oPedido->debug) debug("Falta Re-comprobar las Cantidades ->".sizeof($oPedido->_aDetalles));
	if ($oPedido->debug) print_r($array_bultos);
	if ($oPedido->debug) print_r($array_numero);
	if ($oPedido->debug) debug("Registro :");
	if ($oPedido->debug) print_r($registro);
	if ($oPedido->debug) debug("Confirmados :");
	if ($oPedido->debug) print_r($articulos_confirmados);
	$aDel = array();
	for ($idxdet = $oPedido->first_detail(); isset($idxdet); $idxdet = $oPedido->next_detail()) {
		if (!isset($articulos_cesta[$idxdet])) continue;
		if (!isset($articulos_confirmados[$idxdet])) {
			if ($oPedido->debug) debug("borrando detalle $idxdet ...");
			$oPedido->del_detail($idxdet);
		} elseif (is_numeric($array_bultos[$idxdet]) AND $array_bultos[$idxdet]!= $oPedido->get_quantity($idxdet,TRUE) ) {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) bultos de ".$oPedido->get_quantity($idxdet,TRUE)." a ".$array_bultos[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_bultos[$idxdet],TRUE);
		} elseif (is_numeric($array_numero[$idxdet]) AND $array_numero[$idxdet]!=(int)$oPedido->get_quantity($idxdet) ) {
			if ($oPedido->debug) 
				debug("Cambiando($idxdet) cantidades de ".$oPedido->get_quantity($idxdet)." a ".$array_numero[$idxdet]);
			$oPedido->set_quantity($idxdet,$array_numero[$idxdet]);
		}
	}

	$aPed = $oPedido->get_info();
	$id_empresa = $aPed['id_empresa'];
	$id_div = $aPed['id_divisa'];
	$id_forma_pago = $aPed['id_forma_pago'];
	$id_cliente = $aPed['id_cliente'];
	if ($oPedido->debug) debug("divisa = $id_div");
	if ($oPedido->debug) debug("forma_pago = $id_forma_pago");
	$Sesion->set_var("id_empresa",$id_empresa,"INMED");
	$Sesion->set_var("id_divisa",$id_div,"INMED");
	$Sesion->set_var("id_forma_pago",$id_forma_pago,"INMED");
	$Sesion->set_var("id_cliente_pedido",$id_cliente,"INMED");
	$Sesion->set_var("es_pedido",1,"INMED");
	$Sesion->unset_var('aIDxsNotToCheck');

	$aDirs = $oPedido->get_reciever_address();
	if (sizeof($aDirs) == 1) {
		$Dir = array_pop($aDirs);
		$Sesion->set_var("id_direccion_cliente",$Dir['id_direccion']);
	}

	$oPedido->calculate();
	$Sesion->set_var('oPedido_en_curso',$oPedido);

}

?>
