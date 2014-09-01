

@%plt:botonera%@

<table class="full">
@%where:tabla|Cliente_articulos;nombre|busc;no_results|1;order|Articulos.id_familia%@ 
@%if:cambio_nombre_familia;%@
<tr><td colspan="5">@%db:Familia_articulos.nombre;%@</td></tr>
<tr>
<td class="caption">Nome</td>
<td class="caption">Tarifa</td>
<td class="caption">Desconto</td>
<td class="caption">Total de Desconto</td>
</tr>
@%end-if:%@

<td class="etiqueta">
 @%if:AllowedLink;bo_cliente_articulos;%@   
 <a href="?seccion=bo_cliente_articulos&id_articulo=@%db:Cliente_articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a>   
 @%else:%@   
 @%db:Articulos.nombre;%@   
 @%end-if:%@
</td>
<td>@%func:precio_tarifa;%@ 
 @%if:AllowedLink;modif_tarifas;%@   
 (<a href="?seccion=modif_tarifas&id_tarifa=@%db:Tarifas.id_tarifa;%@" class="accesos">@%db:Tarifas.nombre;%@</a>)   
 @%end-if:%@
</td>
<td>
@%if:!esta_vacio;Cliente_articulos.descuento;%@
@%db:Cliente_articulos.descuento;%@%
@%end-if:%@
</td>
<td>@%db:Cliente_articulos.monto;%@</td>
</tr>
@%end-where:%@

</table>
</form>

@%plt:botonera%@

