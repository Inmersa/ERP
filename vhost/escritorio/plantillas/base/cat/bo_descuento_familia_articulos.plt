<div class="barraoscura">
<div class="titsuperior">&gt; Descompte per família (
      @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
      @%db:Clientes.razon_social;%@
      @%end-where:%@

      )
</div>
<div class="alinder">
@%if:AllowedLink;nuevo_descuento_familia_articulos;%@
 <a href="?seccion=nuevo_descuento_familia_articulos" >Afegir família de descompte</a>
@%end-if:%@

</div>
</div>

@%plt:Datos_Descuento%@ 

