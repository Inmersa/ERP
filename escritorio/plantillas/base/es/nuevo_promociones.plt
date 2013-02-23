
<div class="tituloseccion">&gt; NUEVA OFERTAS Y PROMOCIONES (
 @%where:tabla|Articulos;nolink|1;where|id_articulo = $id_articulo_promocion;%@
 @%db:Articulos.nombre;%@
<!-- @%db:Articulos.id_unidad_medida;%@ @%set:unidad_medida=Articulos.id_unidad_medida;value|var;%@ -->
 @%end-where:%@

)</div>


 
<form name="nuevo_promociones" action="?seccion=modif_promociones" method="post">
<input type="hidden" name="registro[id_unidad_medida]" value="@%get:unidad_medida;%@" />
<table class="full">
<tr>
<td class="caption">Nombre Oferta Promoción</td>
<td class="caption">Fecha inicio</td>
<td class="caption">Fecha Fin</td>
<td class="caption">Cantidad:</td>
</tr>
<tr>
<td><input type="text" name="registro[nombre]" size="30" /></td>
<td><input type="text" name="registro[fecha_inicio]" size="10" /></td>
<td><input type="text" name="registro[fecha_fin]" size="10" /></td>
<td><input type="text" name="registro[cantidad]" class="cantidad" /></td>
</tr>
</table>
<table class="full">
<tr><td><input type="radio" name="registro[oferta]" value="0" /></td>
<td class="etiqueta">Promoción</td></tr>

<tr><td><input type="radio" name="registro[oferta]" value="1" checked="checked" /></td>
<td class="etiqueta">Oferta</td>
<td class="etiqueta">Descuento:</td>
<td> <input type="text" name="registro[descuento]" class="descuento" /> %</td>
<td class="etiqueta">{{fld_importe}}:</td>
<td><input type="text" name="registro[monto]" class="importe" /></td>
</tr>
</table>
 <!-- aqui termina el registro-->
<input type="hidden" name="Nuevo" value="Guardar" />
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_promociones');" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>




