
<div class="tituloseccion">&gt; Facture
@%if:!esta_vacio;id_pedido;%@
@%where:tabla|Pedidos;where|Pedidos.id_pedido = $id_pedido;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" >@%db:Pedidos.referencia;%@</a> [@%db:colocar_fecha{Pedidos.fecha};%@] 
@%db:Clientes.razon_social;%@
@%end-where:%@

@%end-if:%@
</div>

@%plt:Listado_Compra%@


