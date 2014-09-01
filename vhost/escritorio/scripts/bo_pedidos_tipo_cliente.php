<?php
/**control de usuarios
global $Borrar;
global $pedidos_tipo_cliente_borrar;
Acciones Borrar los pedidos tipo
*/

function pre_pedidos_tipo_cliente(&$Sesion) {
	$accion_ejecutar=$Sesion->fetchVar('accion_ejecutar','POST');
	$pedidos_tipo_cliente=$Sesion->fetchVar('pedidos_tipo_cliente','POST');

	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);
	$oDb = $Sesion->get_db('data');

	//debug("glob  $id_cliente");
	//debug("ses $id_cliente_sesion");
	//aviso("precode");
	if(isset($id_cliente) AND $id_cliente_sesion != $id_cliente)
		$Sesion->set_var("id_cliente_promocion",$id_cliente);
	else {
		$id_cliente = $Sesion->get_var("id_cliente_promocion");
		if(!isset($id_cliente)){
			$Sesion->lcMessage('LCS_NOID',array('entidad' => 'Clientes'));
			return;
		}
	}

	if(isset($accion_ejecutar) AND !strcasecmp($accion_ejecutar,"Borrar")){
		if(isset($pedidos_tipo_cliente)){
			foreach($pedidos_tipo_cliente as $clave => $valor)
				if($valor == 1 ){
					$consulta="delete from Pedidos_tipo_cliente
						where id_pedido = $clave AND
						Pedidos_tipo_cliente.id_cliente = $id_cliente AND
						Pedidos_tipo_cliente.id_empresa = $usuario[id]";
					$oDb->query($consulta);
				}

		}
	}//fin de borrar

}//fin del precode

function pre_pedido_tipo(&$Sesion) {
	$id_pedido=$Sesion->fetchVar('id_pedido','GET');
	$id_cliente_sesion = $Sesion->get_var("id_cliente_promocion");
	$usuario = identifica_usuarios($Sesion);

	$Sesion->set_var("id_cliente",$id_cliente_sesion);
	$Sesion->set_var("id_pedido",$id_pedido);
	$Sesion->set_var("id_empresa",$usuario['id']);

	//debug("cli : $id_cliente_sesion , ped $id_pedido , emp $usuario[id]");
}

?>
