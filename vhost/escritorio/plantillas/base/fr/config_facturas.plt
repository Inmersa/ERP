
<fieldset class="fsficha">
<legend>Configuration de Factures</legend>

<table class="full"><tbody><tr>
<td class="etiqueta" >Forme d'Engrais par défaut</td>
<td ><select name="_main[invoice_default_installment]" >
<option value="1" 
	@%if:equals;_aAppConf[invoice_default_installment];1;%@
	selected="selected" 
	@%end-if:%@
>Soustraire des Effets et Ajouter à Compte</option>
<option value="2" 
	@%if:equals;_aAppConf[invoice_default_installment];2;%@
	selected="selected" 
	@%end-if:%@
>Soustraire des Effets et Ajouter un Remboursement</option>
<option value="3" 
	@%if:equals;_aAppConf[invoice_default_installment];3;%@
	selected="selected" 
	@%end-if:%@
>Engrais en Remboursement</option>
<option value="4" 
	@%if:equals;_aAppConf[invoice_default_installment];4;%@
	selected="selected" 
	@%end-if:%@
>Engrais en Compte</option>

</select></td>

<td class="etiqueta" >Créer commande résiduelle par défaut</td>
<td class="check" ><input type="checkbox" name="_main[invoice_onnew_residual]" value="1"
	@%func:check_flag;_aAppConf[invoice_onnew_residual];%@ /></td>

</tr></tbody></table>

</fieldset>

