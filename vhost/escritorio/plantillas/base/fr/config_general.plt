
<fieldset class="fsficha">
<legend>Configuration G�n�rale</legend>
<table class="full"><tbody>
<tr>
<td class="etiqueta" >Format mon�taire</td>
<td ><input type="text" class="texto" name="_main[gnrl_money_format]" value="@%get:_aAppConf[gnrl_money_format];%@" /></td>
<td class="etiqueta" >Nombre de d�cimales</td>
<td ><input type="text" class="mininum" name="_main[gnrl_frac_digits]" value="@%get:_aAppConf[gnrl_frac_digits];%@" /></td>
</tr>

<tr>
<td class="etiqueta" >Nombre de d�cimales pour op�rations sur les documents �valu�s</td>
<td ><input type="text" class="mininum" name="_main[gnrl_opdoc_digits]" value="@%get:_aAppConf[gnrl_opdoc_digits];%@" /></td>
<td class="etiqueta" >Nombre de d�cimales pour totaux sur les documents �valu�s</td>
<td ><input type="text" class="mininum" name="_main[gnrl_totdoc_digits]" value="@%get:_aAppConf[gnrl_totdoc_digits];%@" /></td>
</tr>

<tr>
<td class="etiqueta" >S�parateur d�cimal</td>
<td ><input type="text" class="mininum" name="_main[gnrl_decimal_point]" value="@%get:_aAppConf[gnrl_decimal_point];%@" /></td>
<td class="etiqueta" >S�parateur de millier</td>
<td ><input type="text" class="mininum" name="_main[gnrl_thousands_sep]" value="@%get:_aAppConf[gnrl_thousands_sep];%@" /></td>
</tr>

<tr>
<td class="etiqueta" >{{cfg_transportista_defecto}}</td>
<!-- @%set:_selected_value = _aAppConf[gnrl_transportista_defecto];%@ -->
<td ><select name="_main[gnrl_transportista_defecto]" />
@%where:tabla|Transportistas;nolink|1;%@
<option value="@%db:Transportistas.id_transportista;%@"
@%db:selected_value{Transportistas.id_transportista};%@
>@%db:Transportistas.nombre;%@</option>
@%end-where:%@

</td>
</tr>

</tbody></table>
</fieldset>

