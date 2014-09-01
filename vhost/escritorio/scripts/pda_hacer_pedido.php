<?php
/** Hacer pedido desde pda para agente
Seleccion de imposiciones para el cliente
*/

/** variables de sesion cliente_pda , pedido_desde_pda , control_imposiciones_pda */
function pre_insertar_articulos(&$Sesion){
	global $cif;
	global $id_cliente;
	//debug($id_cliente);
	//debug($cif);

	if(isset($id_cliente) and !empty($id_cliente))
		$Sesion->set_var("cliente_pda",$id_cliente);
	elseif(isset($cif) and !empty($cif)){
		$consulta="select id_cliente from Clientes where cif = '$cif'";
		$resul = $Sesion->query($consulta);
		if($row=$Sesion->fetch_array($resul))
			$Sesion->set_var("cliente_pda",$row[0]);
		else {debug("cliente no valido");
			$Sesion->set_var("cliente_pda",0);
		}
	}

	global $referencia1 , $referencia2 , $referencia3 , $referencia4 , $referencia5;
	global $cantidad1 , $cantidad2 , $cantidad3 , $cantidad4 , $cantidad5;

	$carrito = $Sesion->get_var("pedido_desde_pda");

	if(isset($referencia1) and !empty($referencia1) and isset($cantidad1) and !empty($cantidad1) )
		$carrito[$referencia1] = $cantidad1;

	if(isset($referencia2) and !empty($referencia2) and isset($cantidad2) and !empty($cantidad2) )
		$carrito[$referencia2] = $cantidad2;

	if(isset($referencia3) and !empty($referencia3) and isset($cantidad3) and !empty($cantidad3) )
		$carrito[$referencia3] = $cantidad3;

	if(isset($referencia4) and !empty($referencia4) and isset($cantidad4) and !empty($cantidad4) )
		$carrito[$referencia4] = $cantidad4;

	// debug("Carrito :");
	// print_r($carrito);
	$Sesion->set_var("pedido_desde_pda",$carrito);

}
/** Control de imposiciones a un cliente
  id_empresa , id_cliente TODO
 */
function pre_confirmar_pedido(&$Sesion){
	global $confirmar;
	//purar_array($confirmar);
	$pedido = $Sesion->get_var("pedido_desde_pda");
	if(!is_array($pedido))
		return;
	//depurar_array($pedido);
	if(isset($confirmar))
		foreach($confirmar as $id_articulo => $linea)
			if($linea[insertar] == 1){
				$registro[$id_articulo] = $pedido[$id_articulo];
			}
	$Sesion->set_var("pedido_desde_pda",$registro);
	$Sesion->unset_var("detalle_descuento_cliente");
	$Sesion->unset_var("detalle_descuento_cliente_2");
	$Sesion->unset_var("total");
	$Sesion->unset_var("total_final");
	$Sesion->unset_var("total_iva");
	$Sesion->unset_var("retencion");
	$Sesion->unset_var("pedido_final_pda");

	// debug("1");
	// depurar_array($registro);
}

function pre_pre_confirmar_pedido(&$Sesion){
	$control_imposiciones = $Sesion->get_var("control_imposiciones_pda");
	if(!isset($control_imposiciones)){
		$id_cliente = $Sesion->get_var("cliente_pda");
		$usuario = identifica_usuarios($Sesion);
		$consulta = "select Empresas.id_empresa , pto_primero , pto_segundo , monto , campo_accion , retencion , aplicar_iva , aplicar_recargo , dto_directo , dto_pronto_pago , aplicar_retencion ,mostrar_ofertas
			from Clientes_empresas , Tipo_cliente ,Empresas , Agentes , Tarifas where
			id_cliente = $id_cliente and Clientes_empresas.id_empresa = Agentes.id_empresa and
			Agentes.id_agente =  $usuario[id] and
			Clientes_empresas.id_tipo_cliente = Tipo_cliente.id_tipo_cliente and
			Empresas.id_empresa = Agentes.id_empresa and
			Clientes_empresas.id_tarifa = Tarifas.id_tarifa";
		$resul5=$Sesion->query($consulta);
		$row5=$Sesion->fetch_array($resul5);
		//aplicar iva , aplikar recargo , desccuento por cliente , descuento pronto pago
		$Sesion->set_var("control_imposiciones_pda",$row5);
		//       depurar_array($row5);
	}
}

?>
