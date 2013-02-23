<?php

/** Funciones desde el listado de clientes para la realizacion de un pedido */
function pre_hacer_pedido_cliente(&$Sesion) {
	$presupuesto=$Sesion->fetchVar('presupuesto','GET');
	$pedido=$Sesion->fetchVar('pedido','GET');
	$factura=$Sesion->fetchVar('factura','GET');
	$proforma=$Sesion->fetchVar('proforma','GET');
	$albaran=$Sesion->fetchVar('albaran','GET');

	$nuevo=$Sesion->fetchVar('nuevo','GET');
	$id_rfq =$Sesion->fetchVar('id_rfq','GET');

	debug("pre_hacer_pedido_cliente..");
	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar)) $docvar = 'oPedido_en_curso';
	$oPed = $Sesion->get_var($docvar);
	if (is_object($oPed)) $Sesion->unset_var($docvar);

	$es_ped = $Sesion->get_var("es_pedido");
	$es_pre = $Sesion->get_var("es_presupuesto");
	$es_fra = $Sesion->get_var("es_factura");
	$es_pro = $Sesion->get_var("es_proforma");
	$es_alb = $Sesion->get_var("es_albaran");
	if (!isset($pedido) AND !isset($presupuesto) AND !isset($proforma) AND !isset($factura) AND !isset($albaran)
			AND !(int)$es_ped AND !(int)$es_pre AND !(int)$es_pro AND !(int)$es_fra AND !(int)$es_alb)
		$Sesion->set_var("es_pedido",1);

	if(isset($pedido)) {
		$Sesion->set_var("es_pedido",$pedido);
		$Sesion->unset_var("es_factura");
		$Sesion->unset_var("es_proforma");
		$Sesion->unset_var("es_presupuesto");
		$Sesion->unset_var("es_albaran");
	} elseif(isset($presupuesto) OR isset($proforma)) {
		if ((int)$presupuesto) {
			$Sesion->set_var("es_presupuesto",$presupuesto);
			$Sesion->unset_var("es_factura");
			$Sesion->unset_var("es_proforma");
			$Sesion->unset_var("es_pedido");
			$Sesion->unset_var("es_albaran");
		} else {
			$Sesion->set_var("es_proforma",$proforma);
			$Sesion->unset_var("es_factura");
			$Sesion->unset_var("es_presupuesto");
			$Sesion->unset_var("es_pedido");
			$Sesion->unset_var("es_albaran");
		}

		$linkcrm = $Sesion->get_var('LinkCRM');
		if (!empty($linkcrm)) {
			$oRFQ = $Sesion->get_var('_presupuesto_rfq');
			if (!is_object($oRFQ) OR !is_a($oRFQ,'RFQ')) {
				if (!is_numeric($id_rfq)) $id_rfq = $Sesion->get_var('_presupuesto_id_rfq');
				if (is_numeric($id_rfq)) {
					$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
					if ($oRFQ->dbFill($id_rfq)) {
						$Sesion->set_var('_presupuesto_id_rfq',$id_rfq,'NOEXPIRE');
						$Sesion->set_var('_presupuesto_rfq',$oRFQ,'NOEXPIRE');
					}
				} else {
					$Sesion->unset_var('_presupuesto_id_rfq');
					$Sesion->unset_var('_presupuesto_rfq');
				}
			}
		}
	} elseif ((int)$factura) {
		$Sesion->set_var("es_factura",$factura);
		$Sesion->unset_var("es_pedido");
		$Sesion->unset_var("es_proforma");
		$Sesion->unset_var("es_presupuesto");
	} elseif ((int)$albaran) {
		$Sesion->set_var("es_albaran",$albaran);
		$Sesion->unset_var("es_pedido");
		$Sesion->unset_var("es_proforma");
		$Sesion->unset_var("es_presupuesto");
		$Sesion->unset_var("es_factura");
	}


}//fin del precode

function obtener_tarifas(&$Sesion,&$aDatos){
	$Sesion->set_var("Tarifas",$aDatos["Clientes_empresas.id_tarifa"],"EXPIRE");
}

function chequear_tarifas(&$Sesion,&$aDatos){
	if($Sesion->get_var("Tarifas")==$aDatos["Tarifas.id_tarifa"]) return 'selected="selected"';
}

function nombre_tipo_cliente(&$Sesion,&$aDatos){
	$usuario = identifica_usuarios($Sesion);
	$id_cli_ti = $aDatos["Clientes.id_cliente"];
	$oDb = $Sesion->get_db('data');
	$consulta = "select Tipo_cliente.nombre from Tipo_cliente , Clientes_empresas
		where Tipo_cliente.id_tipo_cliente = Clientes_empresas.id_tipo_cliente
		and Clientes_empresas.id_empresa = $usuario[id]
		and Clientes_empresas.id_cliente = $id_cli_ti";
	$resul=$oDb->query($consulta);
	$row=$oDb->fetch_array($resul);
	return $row['nombre'];
}

?>
