
<form name="modif_promociones" action="?seccion=modif_promociones" method="post">
<input type="hidden" name="accion_ejecutar" value="0" />
@%where:tabla|Promociones;where|Promociones.id_articulo = $id_articulo_promocion AND Promociones.id_empresa = $id_empresa AND Promociones.fecha_inicio < NOW() AND (Promociones.fecha_fin > NOW() OR Promociones.fecha_fin IS NULL) ;%@
 <input type=hidden name="registro[@%db:Promociones.id_promocion%@][id_promocion]" value="@%db:Promociones.id_promocion;%@" />
<fieldset id="Promocion_@%db:Promociones.id_promocion;%@" class="fsficha" >
<legend>Promoci�</legend>

<table class="full">
<thead>
<tr>
<td >Nom Promoci�ns</td>
<td >Stock actual</td>
<td >Data d�inici</td>
<td >Data Fin</td>
</tr>
</thead>
<tbody>
<tr>
<td>@%db:Promociones.nombre;%@</td>
<td>@%func:cantidad_total%@</td>
<td>@%db:colocar_fecha{Promociones.fecha_inicio};%@</td>
<td>@%db:colocar_fecha{Promociones.fecha_fin};%@</td>
</tr>
</tbody>
</table>

<!--@%db:Promociones.id_promocion;%@-->
<!--@%db:Promociones.oferta%@-->
@%if:!esta_vacio;Promociones.oferta;%@
<table class="full">
<tbody>
<tr>
<td class="etiqueta">Oferta</td>
<td class="etiqueta">Suma:</td>
<td>@%db:Promociones.monto;%@</td>
<td class="etiqueta">Descomptes:</td>
<td> @%db:Promociones.descuento;%@ %</td>
<td class="etiqueta">Quantitat:</td>
<td> @%db:Promociones.cantidad;%@</td>
</tr>
</tbody>
</table>
@%else:%@
<table class="full">
<tbody>
<tr>
<td class="etiqueta">Promoci�</td>
<td class="etiqueta">Quantitat:</td>
<td>@%db:Promociones.cantidad;%@</td>
<td colspan="4"></td>
</tr>
</tbody>
</table>

<table class="full">
<caption class="titulotb">Llistat d�articles Promoci�</caption>
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Quantitat</td>
</tr>
 @%set:id_promocion=Promociones.id_promocion%@
 @%where:tabla|Promociones_articulos;nolink|1;where|Promociones_articulos.id_promocion = $id_promocion;%@
 <!-- @%db:Promociones_articulos.id_promocion%@ -->

<tr>
<td class="etiqueta" colspan="2"><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre%@</a></td>
<td>@%db:Promociones_articulos.cantidad;%@</td>
</tr>
 @%end-where:%@

</table>
@%end-if:%@

</fieldset>
@%end-where:%@

</form>
