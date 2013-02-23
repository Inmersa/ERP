<?php
/** crear un albaran a partir de un pedido de compra
nos llega un almacen en el ke colocarlo y un transportista
entoces -> generamos un albaran con lo ke nos deberia llegar
si esta generado solo actualizarlo
no insertamos automaticamente esto deberia hacerse cuando el almacenero nos confirma todo lo llegado (cantidad recibida)
aunque  actualmente se hace buscando el primer hueco disponible de la cantidad o tamaño especificado en
un almacen logico  asi sabemos el desfase y lo ke le tenemos ke pagar al proveedor

global $identificador_pedido;
global $Generar;

global $id_transportista;
global $id_almacen_logico;
global $ref_externa;
global $confirmacion;

Acciones : Generar
*/
function pre_albaranes_compra (&$Sesion) {
	$identificador_pedido = $Sesion->fetchVar('identificador_pedido','POST SESSION');
	$Generar = $Sesion->fetchVar('Generar','POST SESSION');
	$Localizar=$Sesion->fetchVar('LocalizarProducto','POST SESSION');

	$id_transportista=$Sesion->fetchVar('id_transportista','POST');
	$id_almacen_pedido=$Sesion->fetchVar('id_almacen','POST');
	$ref_externa=$Sesion->fetchVar('ref_externa','POST');
	$confirmacion=$Sesion->fetchVar('confirmacion','POST');
	$enviado=$Sesion->fetchVar('enviado','POST');
	$preparado=$Sesion->fetchVar('preparado','POST');

	$accion = $Sesion->fetchVar('accion_ejecutar','POST');
	$aBorrar = $Sesion->fetchVar('registro_borrar','POST');

	$usuario = identifica_usuarios ($Sesion);
	$oDb = $Sesion->get_db ('data');

	if (isset ($Generar)) {
		debug("Generando albaranes de COMPRA... ID: ".$identificador_pedido);
		$aTmp = DeliveryNote::factoryFromDocument($identificador_pedido,'data');
		if (is_array($aTmp) and sizeof($aTmp)) 
			foreach (array_keys($aTmp) as $ida) {
				if (!empty($id_transportista)) $aTmpRec['id_transportista'] = $id_transportista;
				if (!empty($ref_externa)) $aTmpRec['referencia_externa'] = $ref_externa;
				if (is_array($aTmpRec) and sizeof($aTmpRec)) $aTmp[$ida]->update($aTmpRec);
				if ((bool)$Localizar) $aTmp[$ida]->LocateProduct();
				if ((bool)$preparado) {
					if (!(bool)$Localizar) $aTmp[$ida]->LocateProduct();
					for ($idx=$aTmp[$ida]->firstDetail(); isset($idx); $idx=$aTmp[$ida]->nextDetail()) {
						$aD = $aTmp[$ida]->getDetailData(NULL,$idx);
						if (true or $aTmp[$ida]->bVenta) 
							$aTmp[$ida]->setDetailAttribute('cantidad',$aTmp[$ida]->getDetailAttribute('stock_previsto',NULL,$idx),NULL,$idx);
						else
							$aTmp[$ida]->setDetailAttribute('stock_previsto',$aTmp[$ida]->getDetailAttribute('cantidad',NULL,$idx),NULL,$idx);
					}
					$aTmp[$ida]->update(array('preparado' => 1));
				}
				if ((bool)$enviado) $aTmp[$ida]->update(array('enviado' => 1));
				if ((bool)$confirmacion) $aTmp[$ida]->update(array('confirmacion' => 1));
				$aTmp[$ida]->Dump();
			}
		debug("FixMe: Esta pendiente arrastrar las observaciones del pedido, asi como el formulario dentro de pedido (refext,confirmado,preparado,etc...) ");
	}	// FIN DEL GENERAR

	switch ($accion) {
		case 'Borrar':
			debug("Borrando albaranes .. ");
			if (is_array($aBorrar) and sizeof($aBorrar))
				foreach ($aBorrar as $ida => $bool) {
					if ($bool) {
						debug("Borrando $ida ");
						$oAlb = new DeliveryNote();
						if ($oAlb->dbFill($ida)) {
							$oAlb->delete();
							$oAlb->Dump();
						}
					}
				}
			break;
	}

}	// fin del precode

function estado_albaran_compra(&$Sesion,&$aDatos) {
	//depurar_array($aDatos);
	if($aDatos["Albaranes.preparado"] == 0)
		 return "Sin preparar";
	if($aDatos["Albaranes.enviado"] == 0)
		 return "Sin Enviar";
	if($aDatos["Albaranes.confirmado"] == 0)
		 return "Sin confirmar";
	return "Finalizado";
}


function dar_preparado($Sess,$aDatos){
	if((int)$aDatos["albaranes_venta.preparado"]) return "CHECKED";
}

function dar_enviado($Sess,$aDatos){
	if((int)$aDatos["albaranes_venta.enviado"]) return "CHECKED";
}

function dar_confirmacion($Sess,$aDatos){
	if((int)$aDatos["albaranes_venta.confirmacion"]) return "CHECKED";
}

function dar_devolucion($Sess,$aDatos){
	if((int)$aDatos["albaranes_venta.devolucion"]) return "CHECKED";
}

/** buscar un hueco por el numero de filas , columnas .. de un almacen logico
*/
function busca_hueco_almacen(&$Localizaciones,$numero_huecos){
	for($i = 1;$i < $numero_huecos['n_planta'];$i++)
		  for($j = 1;$j < $numero_huecos['n_pasillo'];$j++)
				 for($k = 1;$k < $numero_huecos['n_fila'];$k++)
						for($l = 1;$l < $numero_huecos['n_columna'];$l++)
								  if($Localizaciones[$i][$j][$k][$l] != 1){
									  $Localizaciones[$i][$j][$k][$l] = 1;
									  return array( "planta" => $i ,
														 "pasillo" => $j ,
														 "fila" => $k ,
														 "columna" => $l ,
																			 );
								  }
}

function cf_estado_albaran (&$Sesion, &$aData) {
//depurar_array($aDatos);
	if ($aData['Albaranes.confirmacion'] AND !$aData['Albaranes.devolucion']) {
		$aData['estado_albaran'] = 'ok';
	} elseif($aData['Albaranes.devolucion']) {
		$aData['estado_albaran'] = 'bad';
	} elseif($aData['Albaranes.enviado']) {
		$aData['estado_albaran'] = 'ok';
	} elseif($aData['Albaranes.preparado']) {
		$aData['estado_albaran'] = 'do';
	} else $aData['estado_albaran'] = 'none';
	return TRUE;
}

?>
