<?php

function pre_hacer_pedido_proveedor(&$Sesion) {
   $presupuesto=$Sesion->fetchVar('presupuesto','GET');
   $pedido=$Sesion->fetchVar('pedido','GET');
   $nuevo=$Sesion->fetchVar('nuevo','GET');
	$factura=$Sesion->fetchVar('factura','GET');
	$proforma=$Sesion->fetchVar('proforma','GET');

	$docvar = $Sesion->get_var('__document_iface_varname');
	if (empty($docvar) OR (int)$nuevo) $docvar = 'oPedido_en_curso';
	$oPed = $Sesion->get_var($docvar);
	if (is_object($oPed)) $Sesion->unset_var($docvar);
	else $Sesion->set_var('__document_iface_varname',$docvar);

	$es_ped = $Sesion->get_var("es_pedido");
	$es_pre = $Sesion->get_var("es_presupuesto");
	$es_fra = $Sesion->get_var("es_factura");
	$es_pro = $Sesion->get_var("es_proforma");
	if (!isset($pedido) AND !isset($presupuesto) AND !isset($proforma) AND !isset($factura)
			AND !(int)$es_ped AND !(int)$es_pre AND !(int)$es_pro AND !(int)$es_fra)
		$Sesion->set_var("es_pedido",1);

	if(isset($pedido)) {
		$Sesion->set_var("es_pedido",$pedido);
		$Sesion->unset_var("es_factura");
		$Sesion->unset_var("es_proforma");
		$Sesion->unset_var("es_presupuesto");
	} elseif(isset($presupuesto) OR isset($proforma)) {
		if ((int)$presupuesto) {
			$Sesion->set_var("es_presupuesto",$presupuesto);
			$Sesion->unset_var("es_factura");
			$Sesion->unset_var("es_proforma");
			$Sesion->unset_var("es_pedido");
		} else {
			$Sesion->set_var("es_proforma",$proforma);
			$Sesion->unset_var("es_factura");
			$Sesion->unset_var("es_presupuesto");
			$Sesion->unset_var("es_pedido");
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
	}
}//fin del precode

?>
