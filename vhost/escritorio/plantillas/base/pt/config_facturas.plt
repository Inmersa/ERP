
<fieldset class="fsficha">
<legend>Configuração de Facturas</legend>

<table class="full"><tbody><tr>
<td class="etiqueta" >Forma de Crédito por defeito</td>
<td ><select name="_main[invoice_default_installment]" >
<option value="1" 
	@%if:equals;_aAppConf[invoice_default_installment];1;%@
	selected="selected" 
	@%end-if:%@
>Subtrair dos Ordens de Pagamento e acrescentar à Conta</option>
<option value="2" 
	@%if:equals;_aAppConf[invoice_default_installment];2;%@
	selected="selected" 
	@%end-if:%@
>Subtrair dos Ordens de Pagamento e acrescentar um Reembolso</option>
<option value="3" 
	@%if:equals;_aAppConf[invoice_default_installment];3;%@
	selected="selected" 
	@%end-if:%@
>Crédito em Reembolso</option>
<option value="4" 
	@%if:equals;_aAppConf[invoice_default_installment];4;%@
	selected="selected" 
	@%end-if:%@
>Crédito em Conta</option>

</select></td>

<td class="etiqueta" >Criar encomenda residual por defeito</td>
<td class="check" ><input type="checkbox" name="_main[invoice_onnew_residual]" value="1"
	@%func:check_flag;_aAppConf[invoice_onnew_residual];%@ /></td>

</tr></tbody></table>

</fieldset>

