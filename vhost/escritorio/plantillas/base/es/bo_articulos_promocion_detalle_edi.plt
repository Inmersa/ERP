
@%plt:botonera%@

<form name="bo_articulos_promocion" method="post" action="?seccion=modif_promociones">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<input type="hidden" name="id_promocion" value="@%get:id_promocion_promocion%@" />

<table class="full">
<tr>
<td class="caption">Nombre</td>
<td class="caption">Descripci�n</td>
<td class="caption">Cod. barras</td>
<td class="caption">Cantidad</td>
</tr>

@%where:tabla|Articulos;nombre|busc;no_results|1;%@
<tr>
<td>@%db:Articulos.nombre;%@</td>
<td>@%db:Articulos.descripcion;%@</td>
<td>@%db:Articulos.codigo_barras;%@</td>
<td>
@%if:promocion_articulo_promocion%@
<input type="hidden" name="promociones_articulos[id_unidad_medida][@%db:Articulos.id_articulo;%@]" value="@%db:Articulos.id_unidad_medida;%@" />
<input type="text" name="promociones_articulos[cantidad][@%db:Articulos.id_articulo;%@]" class="cantidad" />
@%else:%@ 
@%end-if:%@
</td></tr>

@%end-where:%@


</table>
<input type="hidden" name="Nuevo" value="Nuevo" />
</form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return !sendForm('bo_articulos_promocion');" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nuevo</span></a></li>
</ul></div>

