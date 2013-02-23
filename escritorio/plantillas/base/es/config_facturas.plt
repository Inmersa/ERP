
<fieldset class="fsficha">
<legend>Configuración de Facturas</legend>

<table class="full"><tbody><tr>
<td class="etiqueta" >Forma de Abono por defecto</td>
<td ><select name="_main[invoice_default_installment]" >
<option value="1" 
	@%if:equals;_aAppConf[invoice_default_installment];1;%@
	selected="selected" 
	@%end-if:%@
>Restar Efectos y Sumar a Cuenta</option>
<option value="2" 
	@%if:equals;_aAppConf[invoice_default_installment];2;%@
	selected="selected" 
	@%end-if:%@
>Restar Efectos y Añadir Devolución</option>
<option value="3" 
	@%if:equals;_aAppConf[invoice_default_installment];3;%@
	selected="selected" 
	@%end-if:%@
>Abono en Devolución</option>
<option value="4" 
	@%if:equals;_aAppConf[invoice_default_installment];4;%@
	selected="selected" 
	@%end-if:%@
>Abono en Cuenta</option>

</select></td>

<td class="etiqueta" >Crear pedido residual por defecto</td>
<td class="check" ><input type="checkbox" name="_main[invoice_onnew_residual]" value="1"
	@%func:check_flag;_aAppConf[invoice_onnew_residual];%@ /></td>

</tr></tbody></table>

</fieldset>

