
<form name="descuentos_familia" method="post" action="">
<input type="hidden" name="accion_ejecutar" value="0" />
<div class="barraoscura"><a href="" onClick="return onHRefClick('descuentos_familia','accion_ejecutar','Borrar');" class="accesos">Elimier</a>
</div>
<table class="full">

@%where:tabla|Cliente_familia_articulos;order|Familia_articulos.nombre;where|Cliente_familia_articulos.id_cliente = $id_cliente_promocion;%@

<tr>
<td class="caption">

@%func:store_id;Cliente_familia_articulos.id_familia;%@

<input type="checkbox" name="descuentos_familia_borrar[@%db:Cliente_familia_articulos.id_familia%@]" value="1" /></td>
<td class="etiqueta">@%db:Familia_articulos.nombre;%@
</td>
<td>
<input type="text" name="descuentos_familia_modificar[@%db:Cliente_familia_articulos.id_familia%@]" value="@%db:Cliente_familia_articulos.descuento;%@" size="4" /></td>
</tr>

@%end-where:%@

</table>
<div class="enviar"><a href="" onClick="return onHRefClick('descuentos_familia','accion_ejecutar','Modificar');" class="accesos">Modifier</a>
</div>
</form>
