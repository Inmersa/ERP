
<fieldset class="fsficha">
<legend>Configura��o Geral</legend>
<table class="full"><tbody>
<tr>
<td class="etiqueta" >Formato monet�rio</td>
<td ><input type="text" class="texto" name="_main[gnrl_money_format]" value="@%get:_aAppConf[gnrl_money_format];%@" /></td>
<td class="etiqueta" >Casas Decimais</td>
<td ><input type="text" class="mininum" name="_main[gnrl_frac_digits]" value="@%get:_aAppConf[gnrl_frac_digits];%@" /></td>
</tr>

<tr>
<td class="etiqueta" >Casas decimais para opera��es sobre os documentos avaliados</td>
<td ><input type="text" class="mininum" name="_main[gnrl_opdoc_digits]" value="@%get:_aAppConf[gnrl_opdoc_digits];%@" /></td>
<td class="etiqueta" >Casas decimais para totais sobre os documentos avaliados</td>
<td ><input type="text" class="mininum" name="_main[gnrl_totdoc_digits]" value="@%get:_aAppConf[gnrl_totdoc_digits];%@" /></td>
</tr>

<tr>
<td class="etiqueta" >Separador decimal</td>
<td ><input type="text" class="mininum" name="_main[gnrl_decimal_point]" value="@%get:_aAppConf[gnrl_decimal_point];%@" /></td>
<td class="etiqueta" >Separador de milhar</td>
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

