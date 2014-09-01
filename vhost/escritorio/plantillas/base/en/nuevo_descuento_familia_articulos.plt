
<div class="barraoscura">
<div class="titsuperior">&gt; New discount family (
      @%where:nombre|cli;tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
      @%db:Clientes.razon_social;%@ 
      @%end-where:%@

      )
</div>
<div class="alinder"><a href="javascript: history.go(-1);">Return</a>
</div>
</div>
<form name="nuevo_descuento_familia_articulos" method="post" action="?seccion=bo_descuento_familia_articulos">
<table class="full">
@%where:tabla|Familia_articulos;cfunc|cf_familias_seleccionadas;order|Familia_articulos.nombre%@
<tr>
<td class="etiqueta">@%db:Familia_articulos.nombre;%@
</td>
<td>
<input type="text" name="descuentos_familia_modificar[@%db:Familia_articulos.id_familia%@]" size="4" />%
</td>
</tr>
@%end-where:%@

</table>
<input type="hidden" name="accion_ejecutar" value="Anyadir" />
<div class="enviar"><a href="#" onClick="document.forms['nuevo_descuento_familia_articulos'].submit();return false;">Add</a>
</div>
</form>
