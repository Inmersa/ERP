

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_descuento_articulos;%@
<li><a href="?seccion=nuevo_descuento_articulos" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Add article</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return onHRefClick('descuentos_articulo','accion_ejecutar','Borrar');" class="borrar" 
><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

@%plt:botonera%@

<form name="descuentos_articulo" method="post" action="#">
<input type="hidden" name="accion_ejecutar" value="0" />

<table class="full">
@%where:tabla|Cliente_articulos;nombre|busc;no_results|1;order|Articulos.id_familia%@ 
@%if:cambio_nombre_familia;%@
<tr><td colspan="5">@%db:Familia_articulos.nombre;%@</td></tr>
<tr>
<td> </td>
<td class="caption">Name</td>
<td class="caption">Tariff</td>
<td class="caption">Discount</td>
<td class="caption">Amount of discount</td>
</tr>
@%end-if:%@

<td class="caption">
<input type="checkbox" name="descuentos_articulo_borrar[@%db:Cliente_articulos.id_articulo%@]" value="1" />
</td>
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
<input type="text" name="descuentos_articulo_modificar_descuento[@%db:Cliente_articulos.id_articulo%@]" value="@%db:Cliente_articulos.descuento;%@" size="5" />%
</td>
<td>
<input type="text" name="descuentos_articulo_modificar_monto[@%db:Cliente_articulos.id_articulo%@]" size="10" maxlength="9" value="@%db:Cliente_articulos.monto;%@" />
</td>
</tr>
@%end-where:%@

</table>
</form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('descuentos_articulo','accion_ejecutar','Modificar');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>
