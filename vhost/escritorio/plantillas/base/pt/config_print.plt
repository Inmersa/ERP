
<fieldset class="fsficha">
<legend>Sistema de Impress�o</legend>
<table class="full"><tbody>


<tr><td class="etiqueta" >Mostrar uma identifica��o de produto em factura</td>
<td class="check" ><input type="checkbox" name="_main[print_invoice_productids]" value="1"
	@%func:check_flag;_aAppConf[print_invoice_productids];%@ /></td>
<td class="etiqueta">Observa��es na mesma linha de produto</td>
<td class="check" ><input type="checkbox" name="_main[print_observaciones_enlinea]" value="1"
	@%func:check_flag;_aAppConf[print_observaciones_enlinea];%@ /></td>
</tr>

<tr><td class="etiqueta" >Direc��o de Entrega ao lugar de Factura��o</td>
<td class="check" ><input type="checkbox" name="_main[print_invoice_delivery]" value="1"
	@%func:check_flag;_aAppConf[print_invoice_delivery];%@ /></td>

<td class="etiqueta">N�meros c�pias de Facturas</td>
<td>
<!-- @%set:_iterate_times=5;%@ -->
@%set:_selected_value = _aAppConf[print_invoice_ncopies];%@
<select name="_main[print_invoice_ncopies]" >
<option value="0" 
@%if:esta_vacio;_selected_value;%@
selected="selected"
@%end-if:%@
>N�o Existem Itens Seleccionados</option>
@%where:nodb|nodb_iterate;%@
<option value="@%db:iterate_num;%@"
@%db:selected_value{iterate_num};%@ 
>@%db:iterate_num;%@</option>
@%end-where:%@

</select>
</td></tr>

<tr><td class="etiqueta" >Guias de Remessa Avaliadas</td>
<td class="check" ><input type="checkbox" name="_main[deliverynote_priced]" value="1"
	@%func:check_flag;_aAppConf[deliverynote_priced];%@ /></td>

<td class="etiqueta">N�meros c�pias de Guias de Remessa</td>
<!-- @%set:_iterate_reset=1;%@ -->
@%set:_selected_value = _aAppConf[print_deliverynote_ncopies];%@
<td>
<select name="_main[print_deliverynote_ncopies]" >
<option value="0" 
@%if:esta_vacio;_selected_value;%@
selected="selected"
@%end-if:%@
>N�o Existem Itens Seleccionados</option>
@%where:nodb|nodb_iterate;%@
<option value="@%db:iterate_num;%@"
@%db:selected_value{iterate_num};%@ 
>@%db:iterate_num;%@</option>
@%end-where:%@

</select></td></tr>

<tr><td class="etiqueta">Linhas na primeira p�gina</td>
<td><input type="text" name="_main[print_pgcabdoc_lineas]" value="@%get:_aAppConf[print_pgcabdoc_lineas];%@" /></td>
<td class="etiqueta">Linhas por p�gina</td>
<td><input type="text" name="_main[print_pgdoc_lineas]" value="@%get:_aAppConf[print_pgdoc_lineas];%@" /></td></tr>

<tr><td class="etiqueta">Car�cteres de observa��es por linha</td>
<td><input type="text" name="_main[print_numcar_observaciones]" value="@%get:_aAppConf[print_numcar_observaciones];%@" /></td>
<td clospan="3" ></td>
</tr>

</tbody></table>
</fieldset>

