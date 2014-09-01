
<fieldset class="fsficha">
<legend>Invoices Configuration</legend>

<table class="full"><tbody><tr>
<td class="etiqueta" >Form of Installment by defect</td>
<td ><select name="_main[invoice_default_installment]" >
<option value="1" 
	@%if:equals;_aAppConf[invoice_default_installment];1;%@
	selected="selected" 
	@%end-if:%@
>Detract From Effects and add against the account</option>
<option value="2" 
	@%if:equals;_aAppConf[invoice_default_installment];2;%@
	selected="selected" 
	@%end-if:%@
>Detract From Effects and add to Refunds</option>
<option value="3" 
	@%if:equals;_aAppConf[invoice_default_installment];3;%@
	selected="selected" 
	@%end-if:%@
>Installment in Refunds</option>
<option value="4" 
	@%if:equals;_aAppConf[invoice_default_installment];4;%@
	selected="selected" 
	@%end-if:%@
>Installment in Account</option>

</select></td>

<td class="etiqueta" >To create residual order by defect</td>
<td class="check" ><input type="checkbox" name="_main[invoice_onnew_residual]" value="1"
	@%func:check_flag;_aAppConf[invoice_onnew_residual];%@ /></td>

</tr></tbody></table>

</fieldset>

