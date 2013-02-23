
<fieldset id="NuevoCliente_CuentasContables" class="fsficha">
<legend>Cuentas contables</legend>
<table class="full">
 <tr> <td class="etiqueta">Clientes:</td>
 <td > <input type="text" name="registro2[cc_cliente]" value="" size="10" />
 </td>
 <td class="etiqueta">Ventas:</td>
 <td > <input type="text" name="registro2[cc_ventas]" value="" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta">Descuento financiero:</td>
 <td> <input type="text" name="registro2[cc_descuento_financiero]" value="" size="10" />
 </td>
 <td class="etiqueta" align="right">Gastos:</td>
 <td> <input type="text" name="registro2[cc_gastos]" value="" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta">Retenciones:</td>
 <td> <input type="text" name="registro2[cc_retenciones]" value="" size="10" />
 </td>
 <td class="etiqueta" align="right">Descuento Comercial:</td>
 <td> <input type="text" name="registro2[cc_descuento_comercial]" value="" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta" colspan="3">Efectos:</td>
 <td > <input type="text" name="registro2[cc_efectos]" value="" size="10" />
 </td>
 </tr>
 
 
 <tr> <td class="etiqueta" align="right">Riesgo:</td>
 <td colspan="3"> <input type="text" name="registro2[riesgo]" value="" size="30" />
 </td>
 </tr>
 
 </table>
</fieldset>

<fieldset id="NuevoCliente_CuentaBancaria" class="fsficha">
<legend>Cuenta Bancaria IBAN</legend>
 <table class="full">
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="registro2[entidad]" value="" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="registro2[oficina]" value="" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta" >DC / Nº Cuenta</td>
 <td><input type="text" name="registro2[dc_ccc]" value="" size="2" maxlength="3" class="insertext" />
 <input type="text" name="registro2[cuenta_bancaria]" value="" class="insertext" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="registro2[iban]" value="" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta">Código Identificador de Banco</td>
 <td><input type="text" name="registro2[bic]" value="" size="13" maxlength="12" class="insertext" /></td>
 <td class="etiqueta">Número de Cuenta Bancaria Base</td>
 <td><input type="text" name="registro2[bban]" value="" size="27" maxlength="26" class="insertext" /></td>
</tr>
</table>
</fieldset>

