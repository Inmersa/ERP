<div class="barraoscura">
<div class="titsuperior">&gt; Històric de demandes(
      @%where:tabla|Proveedores;nolink|1;where|id_proveedor = $id_proveedor_promocion;%@
      @%db:Proveedores.razon_social;%@ 
      @%end-where:%@

)
</div><div class="alinder">
@%if:AllowedLink;nuevo_pedidos;%@
<a href="?seccion=hacer_pedido_compra&nuevo=1" class="accesos">Nou</a></td>
@%end-if:%@
</div></div>
@%plt:Pedidos_Proveedor%@

