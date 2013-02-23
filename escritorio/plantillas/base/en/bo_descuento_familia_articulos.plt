<div class="barraoscura">
<div class="titsuperior">&gt; Discount by families (
      @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
      @%db:Clientes.razon_social;%@
      @%end-where:%@

      )
</div>
<div class="alinder">
@%if:AllowedLink;nuevo_descuento_familia_articulos;%@
 <a href="?seccion=nuevo_descuento_familia_articulos" >Add family of discount</a>
@%end-if:%@

</div>
</div>

@%plt:Datos_Descuento%@ 

