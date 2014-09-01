<?php

function pre_cod_barras(&$Sesion) {
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$reg=$Sesion->fetchVar('reg','POST');

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) {
		$Sesion->lcMessage('LCS_DBNULL',array('dbname' => 'data'),IM_FATALERROR);
		$Sesion->perror_link('?logout=1');
		return;
	}
	$id_emp = $Sesion->get_var('id_empresa');

	switch ($accion_ejecutar) {
		case 'mas' :
			if ($Sesion->verifyVar('reg',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('reg',IKRN_VAR_CRC_AUTHED)) {
				if (is_numeric($id_emp) AND is_numeric($reg['cod_barras']) AND is_numeric($reg['cantidad'])) {
					$aArt = $Sesion->get_var('_aArtTicket');
					$cons = "SELECT t1.id_articulo, t1.nombre ".
								"FROM Articulos t1, Empresas_articulos t2 ".
								"WHERE t1.id_articulo = t2.id_articulo AND ".
								"t2.id_empresa = $id_emp AND t1.codigo_barras = ".$reg['cod_barras'];
					$idrs = $oDb->query($cons);
					if ($oDb->num_rows($idrs)) {
						$aTmp = $oDb->fetch_row($idrs);
						$aArt[$aTmp[0]] += (double)$reg['cantidad'];
						$Sesion->set_var('nombre_articulo',$aTmp[1],'INMED');
						$Sesion->set_var('codigo_barras',$reg['cod_barras'],'INMED');
						$Sesion->set_var('_aArtTicket',$aArt,'SECCION');
					} else {
						$Sesion->set_var('nombre_articulo',' --- No se Ha Encontrado --- ','INMED');
						$Sesion->set_var('codigo_barras',$reg['cod_barras'],'INMED');
					}
					$oDb->libera($idrs);
				} else {
					$Sesion->set_var('nombre_articulo',' --- No se Ha Encontrado --- ','INMED');
					$Sesion->set_var('codigo_barras',$reg['cod_barras'],'INMED');
				}
			}
			break;

		case 'Actualizar':
			$aPlt = $Sesion->get_plt_array('recarga');
			if (is_array($aPlt) AND sizeof($aPlt)) {
				return $aPlt[1];
			}
			break;
	}
}

function print_ticket(&$Sesion) {
	$articulos_confirmados=$Sesion->fetchVar('articulos_confirmados','POST');	//array de checkboxes con los ke keremos konfirmar
	$articulos_cesta=$Sesion->fetchVar('articulos_cesta','POST');			//array de hidden que habia en la cesta (para no borrar los k entran por promo)
	$array_precio=$Sesion->fetchVar('array_precio','POST');
	$array_numero=$Sesion->fetchVar('array_numero','POST');

	$oPedido = $Sesion->get_var('oPedido_en_curso');
	if (!is_object($oPedido)) {
		$Sesion->lcMessage('LCS_MODULE_NOINSTANCE',array('class' => 'Order'));
		$Sesion->perror_link('javascript: window.close();');
		return;
	}
	for ($idxdet = $oPedido->first_detail(); isset($idxdet); $idxdet = $oPedido->next_detail()) {
		if (!isset($articulos_cesta[$idxdet])) continue;
		if (!isset($articulos_confirmados[$idxdet])) {
			if ($oPedido->debug) debug("borrando detalle $idxdet ...");
			$oPedido->del_detail($idxdet);
		} else {
			if (is_numeric($array_precio[$idxdet]) AND $array_precio[$idxdet]!= $oPedido->get_price($idxdet) ) {
				if ($oPedido->debug) 
					debug("Cambiando($idxdet) precio de ".$oPedido->get_price($idxdet)." a ".$array_precio[$idxdet]);
				$oPedido->set_price($idxdet,$array_precio[$idxdet],TRUE);
			} 
			if (is_numeric($array_numero[$idxdet]) AND $array_numero[$idxdet]!=(int)$oPedido->get_quantity($idxdet) ) {
				if ($oPedido->debug) 
					debug("Cambiando($idxdet) cantidades de ".$oPedido->get_quantity($idxdet)." a ".$array_numero[$idxdet]);
				$oPedido->set_quantity($idxdet,$array_numero[$idxdet]);
			}
		}
	}
	$oPedido->calculate();
	$oPedido->dbdump();
	$Sesion->set_var('oPedido_en_curso',$oPedido,'SECCION');
}

function pre_hacer_ticket(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','POST');
	$id_tarifa=$Sesion->fetchVar('id_tarifa','POST'); // Identificador de la tarifa que le tocca (en nuevo)

	$identificador_pedido=$Sesion->fetchVar('identificador_pedido','POST');//de donde viene

	// Variables para hacer/modificar un pedido.
	$Anyadir=$Sesion->fetchVar('Anyadir','POST');
	$vaciar_pedido=$Sesion->fetchVar('vaciar_pedido','GET');
	$array_ids=$Sesion->fetchVar('array_ids','POST');
	$array_numero=$Sesion->fetchVar('array_numero','POST');
	$array_detalle=$Sesion->fetchVar('array_detalle','POST');
	$array_bultos=$Sesion->fetchVar('array_bultos','POST');
	$borrar_articulos=$Sesion->fetchVar('borrar_articulos','POST');

	// Variables de pedidos Tipo.
	$pedidos_tipo_cliente=$Sesion->fetchVar('pedidos_tipo_cliente','POST');
	$tipo=$Sesion->fetchVar('tipo','GET');

	// Fixme: Accesos de Usuarios.
	$usuario = identifica_usuarios($Sesion);
	$id_emp = $usuario['id'];

	$oPedido = $Sesion->get_var('oPedido_en_curso');

	// Esperemos que esto no de problemas.
	if ($tipo == 1 AND is_array($pedidos_tipo_cliente)) $oPedido = NULL;

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	if (is_numeric($id_cliente) AND $id_cliente != $id_cliente_sesion)
		$id_cliente_sesion = $id_cliente;
	if (is_numeric($id_cliente_sesion) AND is_object($oPedido) 
			AND $id_cliente_sesion != $oPedido->get_reciever_id()) {
		$vaciar_pedido = 1;
		$id_cliente = $id_cliente_sesion;
	}

	if ((int)$vaciar_pedido AND is_object($oPedido)) {
		if (!isset($id_cliente)) {
			if ($oPedido->debug) debug("Vaciando el pedido y recogiendo sus datos");
			$aPed = $oPedido->get_info();
			if (is_numeric($aPed['id_cliente']) ) {
				$id_cliente = $aPed['id_cliente'];
			}
			if (is_numeric($aPed['id_empresa']))
				$id_emp = $aPed['id_empresa'];
			$id_tarifa = $aPed['id_tarifa'];
		} 
		if ($oPedido->debug) debug("reeeeset de pedido");
		$oPedido = NULL;
		$Sesion->unset_var('oPedido_en_curso');
	}

	if (!is_object($oPedido)) {
		// debug("No existe el pedido, probamos a construirlo($id_cliente)..");
		if (!strcasecmp($usuario['desktop_name'],'cliente')) {
			$id_cliente = $usuario['valor'];
			$Sesion->set_var("id_cliente_promocion",$id_cliente);
		} elseif (isset($id_cliente)) {
			$id_cliente_sesion = $id_cliente;
			$Sesion->set_var("id_cliente_pedido", $id_cliente);
			// debug("id_cliente pedido = $id_cliente");
			$Sesion->set_var("id_cliente_promocion", $id_cliente);
		} elseif (!empty($id_cliente_sesion) AND is_numeric($id_cliente_sesion)) {
			$id_cliente = $id_cliente_sesion;
			debug("id_cli = $id_cliente");
		} else return NULL;

		if((isset($identificador_pedido) AND (int)$identificador_pedido) OR ($tipo == 1)) {
			$Sesion->set_var("identificador_pedido", $identificador_pedido);
			// $Sesion->set_var("es_presupuesto",1);
			$tipo_doc = 0;
			$id_ped = (int)$identificador_pedido;
		} else $tipo_doc = 0;

		$oPedido = new Order($Sesion->App_Name,'data',inmPed_VENTA,$tipo_doc);
		$base_ok = 0;
		if ($tipo == 1 AND is_array($pedidos_tipo_cliente)) {
			$Sesion->set_var("es_pedido",1,"INMED");
			foreach ($pedidos_tipo_cliente as $idp => $val) {
				$oPedido_base = new Order($Sesion->App_Name,'data',inmPed_VENTA,$tipo_doc);
				if (!$oPedido_base->dbfill($idp)) {
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $idp));
					$base_ok = 0;
					break;
				}
				if (!$base_ok) {
					$id_cl = $oPedido_base->get_reciever_id();
					$id_em = $oPedido_base->get_issuer_id();
					if (!strcasecmp($usuario['desktop_name'],'Agente')) $id_ag = $usuario['valor'];
					$oPedido->set_issuer($id_emp);
					$oPedido->set_reciever($id_cl);
					if (is_numeric($id_ag)) $oPedido->set_agent($id_ag);
					$base_ok = 1;
				}
				for($idx = $oPedido_base->first_detail(); isset($idx); $idx = $oPedido_base->next_detail()) {
					$precio = $oPedido_base->get_price($idx);
					if (!$precio) continue;
					$id_art = $oPedido_base->get_detail_article_id($idx);
					$cant = $oPedido_base->get_quantity($idx);
					$oPedido->add_detail($id_art,$cant);
				}
				$oPedido_base = NULL;
				unset($oPedido_base);
			}
		} 

		if (!$base_ok) {
			if (!$id_ped) {
				if ($oPedido->debug) debug("Emisor $id_emp");
				$oPedido->set_issuer($id_emp);
				if ($oPedido->debug) debug("receptor $id_cliente");
				$oPedido->set_reciever($id_cliente);
				if (is_numeric($id_tarifa)) $oPedido->set_revenue($id_tarifa);
				if (!strcasecmp($usuario['desktop_name'],'Agente')) $id_agente = $usuario['valor'];
				if (is_numeric($id_agente)) $oPedido->set_agent($id_agente);
			} else {
				if (!$oPedido->dbfill($id_ped)) {
					if ($oPedido->debug) debug("No se ha podido rellenar los datos provenientes del pedido $id_ped");
			  		$Sesion->lcMessage('ORDER_DBFILL',array('id' => $idp));
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
		$id_cli = $Sesion->get_var("id_cliente_promocion");
	if (!(int)$id_cli)
		$id_cli = $oPedido->get_reciever_id();
		
	$Sesion->set_var("id_cliente_pedido", $id_cli);
	$Sesion->set_var("id_cliente_promocion", $id_cli);

	$aCodBarras = $Sesion->get_var('_aArtTicket');
	if (is_array($aCodBarras) AND sizeof($aCodBarras)) {
		foreach ($aCodBarras as $idart => $cant) {
			$idx = $oPedido->add_detail($idart,$cant);
		}
		$Sesion->unset_var('_aArtTicket');
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

	//aki se meten los bultos cantidades ¿y paletas ?
		// debug("Vaciar pedido = $vaciar_pedido");

		if ($Sesion->verifyVar('array_bultos',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('array_bultos',IKRN_VAR_CRC_AUTHED)) {
			if (is_array($array_bultos))
				foreach($array_bultos as $idx => $num) {
					if (empty($num)) continue;
					$id_art = $array_ids[$idx];
					if ($oPedido->debug) debug("localizando bulto $idx ... $id_art ($num)"); 
					$idxdet = $oPedido->add_detail($id_art,$num,TRUE);
				}
		}

		if ($Sesion->verifyVar('array_numero',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('array_numero',IKRN_VAR_CRC_AUTHED)) {
			if (is_array($array_numero))
				foreach($array_numero as $idx => $num) {
					if (empty($num)) continue;
					if (!empty($array_bultos[$idx])) continue;

					$id_art = $array_ids[$idx];
					if ($oPedido->debug) debug("localizando cantidad idx $idx ... $id_art ($num)"); 
					if (!isset($array_bultos[$idx]) OR empty($array_bultos[$idx]))
						$idxdet = $oPedido->add_detail($id_art,$num);
				}
		}
	}
	$Sesion->set_var("oPedido_en_curso",$oPedido);

}//fin del precode


function descripcion_descuento(&$Sesion,&$aDatos){
	$id_art = $aDatos["Articulos.id_articulo"];
	$usuario = identifica_usuarios($Sesion);
	$id_cliente = $Sesion->get_var("id_cliente_pedido");
	$oPedido = $Sesion->get_var("oPedido_en_curso");
	$oDb = $Sesion->get_db('data');

	//DIVISA
	if (!is_object($oPedido)) {
		$consulta = "select leyenda from Divisa , Empresas ".
			" where Empresas.id_divisa = Divisa.id_divisa and id_empresa = $usuario[id]";
		$resuld=$oDb->query($consulta);
		$rowd=$oDb->fetch_array($resuld);
		$aplicar_descuentos = (int) $Sesion->get_var("aplicar_descuentos_cliente");
	} else {
		$aDiv = $oPedido->get_currency();
		$rowd['leyenda'] = $aDiv['leyenda'];
		$aRec = $oPedido->get_reciever_info();
		$aplicar_descuentos = (int)$aRec['mostrar_ofertas'];
	}
	//depurar_array($rowd);
	//debug($Sesion->get_var("aplicar_descuentos_cliente"));
	if($aplicar_descuentos == 1){
		//SI A ESTE CLIENTE SE LE APLIKAN LOS DESCUENTOS
		//descuento por cliente y articulo
		$consulta = "Select descuento , monto  from Cliente_articulos  where id_articulo = $id_art and id_empresa = $usuario[id] and id_cliente = $id_cliente";
		$resul4 = $oDb->query($consulta);
		$row4 = $oDb->fetch_array($resul2);
		if($row4['descuento'] > 0 )
			return $row4['descuento'] .  "% Cli/Art";
		elseif($row4['monto'] > 0)
			return $row4['monto'] ." " .  $rowd['leyenda'] .  " Cli/Art";

		//descuento por familia de articulos y cliente
		$consulta = "Select descuento from Cliente_familia_articulos , Articulos
			where Articulos.id_articulo = $id_art and Cliente_familia_articulos.id_empresa = $usuario[id]
			and Cliente_familia_articulos.id_cliente = $id_cliente
			and Cliente_familia_articulos.id_familia = Articulos.id_familia";
		$resul2 = $oDb->query($consulta);
		$row2 = $oDb->fetch_array($resul2);
		if($row2['descuento'] > 0){
			return $row2['descuento'] . "% Cli/Fam";
		}
	}//FIN DE DEESCUENTOS ESPECIFICOS DE CLIENTE
	//Promociones u ofertas
	$consulta = "Select descuento , monto , oferta , nombre from Promociones where id_articulo = $id_art AND ".
		"id_empresa = $usuario[id]";
	$consulta = "Select id_promocion, cantidad, descuento , monto , oferta , nombre  ".
		"FROM Promociones ".
		"WHERE id_articulo = $id_art and id_empresa = $usuario[id] ".
		"AND fecha_inicio < NOW() AND (fecha_fin>NOW() OR fecha_fin IS NULL OR fecha_fin=0) ";
	$resul3 = $oDb->query($consulta);
	$row3 = $oDb->fetch_array($resul3);
	if($row3['oferta'] == 1){
		//ofertas
		if($row3['descuento'] > 0)
			return  $row3['descuento'] . "% Art >=$row3[cantidad]";
		elseif($row3['monto'] > 0)
			return  $row3['monto'] . " " .  $rowd['leyenda'] .  " Art >=$row3[cantidad]";
	}
	elseif($row3['nombre'] !=  "") //Promociones
		return  $row3['nombre']." >=$row3[cantidad]";

	$consulta = "Select descuento from Descuento_familia , Articulos
		where Articulos.id_articulo = $id_art and
		Descuento_familia.id_empresa = $usuario[id] and
		Descuento_familia.id_familia = Articulos.id_familia";
	$resul8 = $oDb->query($consulta);
	$row8 = $oDb->fetch_array($resul8);
	if($row8['descuento'] > 0){
		return $row8['descuento'] . "% Fam";
	}

	if ((int)$aDatos["Empresas_articulos.unidades_bulto"]>1) {
		if ((int)$aDatos['Empresas_articulos.dto_vol']) {
			if ($aDatos['Empresas_articulos.dto_vol'] == (int)$aDatos['Empresas_articulos.dto_vol'])
				$aDatos['Empresas_articulos.dto_vol'] = (int)$aDatos['Empresas_articulos.dto_vol'];
			if (!(int)$aDatos['Empresas_articulos.dto_vol_bultos'])
				$aDatos['Empresas_articulos.dto_vol_bultos'] = NULL;
			$retval = $aDatos['Empresas_articulos.dto_vol'].'% X '.
				$aDatos['Empresas_articulos.dto_vol_bultos'].' Bto';
		} elseif ((int)$aDatos['Empresas.dto_gnrl_vol']) {
			if ($aDatos['Empresas.dto_gnrl_vol'] == (int)$aDatos['Empresas.dto_gnrl_vol'])
				$aDatos['Empresas.dto_gnrl_vol'] = (int)$aDatos['Empresas.dto_gnrl_vol'];
			if (!(int)$aDatos['Empresas.dto_gnrl_vol_bultos'])
				$aDatos['Empresas.dto_gnrl_vol_bultos'] = NULL;
			$retval = $aDatos['Empresas.dto_gnrl_vol'].'% X '.
				$aDatos['Empresas.dto_gnrl_vol_bultos'].' Bto';
		} else $retval = NULL;
		return $retval;
	}

}

function modificable(&$Sesion,&$aData) {
	if (!(float)$aData['precio']) return 0;
	else return 1;
}

?>
