<?php

function pre_pedidos(&$Sesion) {
	$id_cliente=$Sesion->fetchVar('id_cliente','GET');
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");


	//debug("glob  $id_cliente");
	//debug("ses $id_cliente_sesion");
	if(isset($id_cliente) AND $id_cliente_sesion != $id_cliente)
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	else {
		$id_cliente = $Sesion->get_var("id_cliente_promocion");
		if(!isset($id_cliente)){
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Clientes'));
			return;
		}
	}
}//fin del precode

function dar_estado($Sess,$aDatos){
	if((int)$aDatos["Pedidos.preparado"]) return "Recibido";
	else return "Pendiente";
}

function nombre_articulo2(&$Sesion,&$aDatos){
	$oDb = $Sesion->get_db('data');
	$id_articulo = $aDatos["Lineas_detalle.id_articulo"];
	$consulta = "select Articulos.nombre  from Articulos where Articulos.id_articulo = $id_articulo";
	$resul = $oDb->query($consulta);
	$row = $oDb->fetch_array($resul);
	return $row[0];
}

function calcular_monto_pedido(&$Sesion,&$aDatos){
	// global $id_pedido;
	//calcular con descuentos??
	$oDb = $Sesion->get_db('data');
	$id_pedido = $aDatos["Pedidos.id_pedido"];
	$consulta = "select sum(monto_total) from Lineas_detalle where Lineas_detalle.id_pedido = $id_pedido";
	$resul = $oDb->query($consulta);
	$row = $oDb->fetch_array($resul);
	return $row[0];
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
				$npreparados += $aTmp['preparado'];
				$nenviados += $aTmp['enviado'];
				$nconfirmados += $aTmp['confirmacion'];
				$ndevueltos += $aTmp['devolucion'];
			}
			if ($nalb == $npreparados) {
				if ($nalb == $nconfirmados AND !$ndevueltos) {
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

?>
