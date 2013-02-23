@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@
<!-- @%db:Recorridos.id_recorrido;%@ -->

<fieldset class="fsficha" >
<legend>Consumacions</legend>
<table class="full"><thead><tr>
<td >Nom</td>
<td >Import</td>
<td >Comentari</td>
</tr></thead>

<tbody>
@%where:tabla|Recorridos_gastos;%@
<input type="hidden" name="gastos[@%db:Recorridos_gastos.id_gasto%@][id_recorrido]" value="@%db:Recorridos_gastos.id_recorrido%@" />
<tr>
<td>@%db:Gastos.nombre%@</td>
<td>
@%if:!esta_vacio;estado_cerrado;%@
@%db:Recorridos_gastos.importe%@
@%else:%@
<input type="text" name="gastos[@%db:Recorridos_gastos.id_gasto%@][importe]" value="@%db:Recorridos_gastos.importe%@" size="10" />
@%end-if:%@
</td>
<td>
@%if:!esta_vacio;estado_cerrado;%@
@%db:reemplazar_salto{Recorridos_gastos.comentario}%@
@%else:%@
<textarea name="gastos[@%db:Recorridos_gastos.id_gasto%@][comentario]" rows="5" cols="60" >@%db:Recorridos_gastos.comentario%@</textarea>
@%end-if:%@
</td>
</tr>
@%end-where:%@

</tbody>
@%if:!esta_vacio;estado_iniciado;%@
<thead class="secundario" >
<tr><td colspan="3" >Nou</td></tr>
</thead>
<tbody>
<tr>
<td><select name="recorridos_gastos[new][id_gasto]" >
@%where:tabla|Gastos;nolink|1;%@
<option value="@%db:Gastos.id_gasto;%@" 
>@%db:Gastos.nombre%@</option>
@%end-where:%@

</select></td>
<td><input type="text" name="recorridos_gastos[new][importe]" value="" size="10" /></td>
<td><textarea name="recorridos_gastos[new][comentario]" rows="5" cols="60" ></textarea></td>
</tr>
</tbody>
@%end-if:%@
</table>
</fieldset>

