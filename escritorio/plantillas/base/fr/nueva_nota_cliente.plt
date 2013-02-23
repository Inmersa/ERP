
<fieldset id="NuevaNota" class="fsficha" >
<legend>Nouvelle Note</legend>

<table class="full"><thead><tr>
<td >Nom</td>
<td >Type d'Annotation</td>
<td >Date</td>
<td >Usager</td>
</tr></thead>

<tbody>
<tr>
<td><input type="text" name="cliente_notas[nombre]"  /></td>

<td>
<select name="cliente_notas[id_tipo_anotacion]">
@%where:tabla|Tipos_anotacion;nolink|1;%@
<option value="@%db:Tipos_anotacion.id_tipo_anotacion;%@"
>@%db:Tipos_anotacion.nombre;%@</option>
@%end-where:%@

</select>
<td><input type="text" name="cliente_notas[fecha]" value="@%func:colocar_fecha;now;%@" /></td>

<td>@%get:_AuthInfo[user_name];%@</td>

</tr>
<tr><td colspan="4" class="barraoscurai"> Note</td></tr>
<tr><td colspan="4"><textarea name="cliente_notas[nota]" rows="5" cols="120" wrap="VIRTUAL"></textarea></td></tr>
</tbody>
</table>

</fieldset>
