<div class="tituloseccion">&gt; New Measures</div>

<form name="nuevo_unidades_medida" action="?seccion=bo_unidades_medida" method="post">
<input type="hidden" name="accion" value="Modificar" />

<table class="full">
<tr><td class="etiqueta">Name:</td>
<td><input type="text" name="registro[nombre]" class="texto" /></td></tr>

<tr><td class="etiqueta" >Type:</td>
<td ><select name="registro[id_tipo_unidadmedida]" >
<option value="0" >No selection</option>
@%where:tabla|Tipos_UnidadMedida;nolink|1;order|nombre asc;%@
<option value="@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@"
@%db:selected_value{Tipos_UnidadMedida.id_tipo_unidadmedida;%@
>@%db:Tipos_UnidadMedida.nombre;%@</option>
@%end-where:%@

</select>
</td></tr>

<tr><td class="etiqueta">Caption:</td>
<td><input type="text" name="registro[leyenda]" class="texto" /></td></tr>

<tr><td class="etiqueta" >Separated scale conversion:</td>
<td ><input type="checkbox" name="registro[conversion_descompuesta]" value="1" /></td></tr>
<tr><td class="etiqueta" >Decimal Numbers in Units of measurement:</td>
<td ><input type="text" name="registro[num_decimales]" value="" class="mininum" /></td></tr>

</table>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_unidades_medida');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>
