
<fieldset class="fsficha">
<legend>Configuració de Factures</legend>

<table class="full"><tbody><tr>
<td class="etiqueta" >Forma d'Abonament per defecte</td>
<td ><select name="_main[invoice_default_installment]" >
<option value="1" 
	@%if:equals;_aAppConf[invoice_default_installment];1;%@
	selected="selected" 
	@%end-if:%@
>Restar Efectes i Sumar a Compte</option>
<option value="2" 
	@%if:equals;_aAppConf[invoice_default_installment];2;%@
	selected="selected" 
	@%end-if:%@
>Restar Efectes i Afegir Devolució</option>
<option value="3" 
	@%if:equals;_aAppConf[invoice_default_installment];3;%@
	selected="selected" 
	@%end-if:%@
>Abonament en Devolució</option>
<option value="4" 
	@%if:equals;_aAppConf[invoice_default_installment];4;%@
	selected="selected" 
	@%end-if:%@
>Abonament en Compte</option>

</select></td>

<td class="etiqueta" >Crear comanda residual per defecte</td>
<td class="check" ><input type="checkbox" name="_main[invoice_onnew_residual]" value="1"
	@%func:check_flag;_aAppConf[invoice_onnew_residual];%@ /></td>

</tr></tbody></table>

</fieldset>

