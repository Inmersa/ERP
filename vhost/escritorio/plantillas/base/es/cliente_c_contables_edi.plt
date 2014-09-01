@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<input type="hidden" name="cc_old[cc_cliente]" value="@%db:Clientes_empresas.cc_cliente;%@">
<input type="hidden" name="cc_old[cc_ventas]" value="@%db:Clientes_empresas.cc_ventas;%@">
<input type="hidden" name="cc_old[cc_banco]" value="@%db:Clientes_empresas.cc_banco;%@">
<input type="hidden" name="cc_old[cc_descuento_financiero]" value="@%db:Clientes_empresas.cc_descuento_financiero;%@">
<input type="hidden" name="cc_old[cc_descuento_comercial]" value="@%db:Clientes_empresas.cc_descuento_comercial;%@">
<input type="hidden" name="cc_old[cc_gastos]" value="@%db:Clientes_empresas.cc_gastos;%@">
<input type="hidden" name="cc_old[cc_retenciones]" value="@%db:Clientes_empresas.cc_retenciones;%@">
<input type="hidden" name="cc_old[cc_efectos]" value="@%db:Clientes_empresas.cc_efectos;%@">
<!--@%db:Clientes_empresas.id_cliente%@ -->

<fieldset class="fsficha">
<legend>Cuentas contables</legend>
<table class="full">
 <tr> <td class="etiqueta">Clientes:</td>
 <td > <input type="text" name="registro2[cc_cliente]" value="@%db:Clientes_empresas.cc_cliente;%@" class="insertext" size="10" />
 </td>
 <td class="etiqueta">Ventas:</td>
 <td > <input type="text" name="registro2[cc_ventas]" value="@%db:Clientes_empresas.cc_ventas;%@" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta">Descuento financiero:</td>
 <td> <input type="text" name="registro2[cc_descuento_financiero]" value="@%db:Clientes_empresas.cc_descuento_financiero;%@" class="insertext" size="10" />
 </td>
 <td class="etiqueta" align="right">Gastos:</td>
 <td> <input type="text" name="registro2[cc_gastos]" value="@%db:Clientes_empresas.cc_gastos;%@" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta">Retenciones:</td>
 <td> <input type="text" name="registro2[cc_retenciones]" value="@%db:Clientes_empresas.cc_retenciones;%@" class="insertext" size="10" />
 </td>
 <td class="etiqueta" align="right">Descuento Comercial:</td>
 <td> <input type="text" name="registro2[cc_descuento_comercial]" value="@%db:Clientes_empresas.cc_descuento_comercial;%@" class="insertextnumeros" size="10" />
 </td>
 </tr>
 <tr> <td class="etiqueta" colspan="3">Efectos:</td>
 <td > <input type="text" name="registro2[cc_efectos]" value="@%db:Clientes_empresas.cc_efectos;%@" class="insertext" size="10" />
 </td>
 </tr>
 
 
 <tr> <td class="etiqueta" align="right">Riesgo:</td>
 <td > <input type="text" name="registro2[riesgo]" value="@%db:Clientes_empresas.riesgo;%@" class="insertext" size="30" /></td>
 <td class="etiqueta" align="right">Monto Cuenta:</td>
 <td >@%db:Clientes_empresas.monto_cuenta;%@</td>
 </tr>
 
 </table>
</fieldset>

<fieldset class="fsficha">
<legend>Cuenta Bancaria IBAN</legend>
 <table class="full">
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="registro2[entidad]" value="@%db:Clientes_empresas.entidad;%@" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="registro2[oficina]" value="@%db:Clientes_empresas.oficina;%@" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta" >DC / Nº Cuenta</td>
 <td><input type="text" name="registro2[dc_ccc]" value="@%db:Clientes_empresas.dc_ccc;%@" size="2" maxlength="3" class="insertext" />
 <input type="text" name="registro2[cuenta_bancaria]" value="@%db:Clientes_empresas.cuenta_bancaria;%@" class="insertext" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="registro2[iban]" value="@%db:Clientes_empresas.iban;%@" size="5" maxlength="4" class="insertext" /></td>
 <td class="etiqueta">Código Identificador de Banco</td>
 <td><input type="text" name="registro2[bic]" value="@%db:Clientes_empresas.bic;%@" size="13" maxlength="12" class="insertext" /></td>
 <td class="etiqueta">Número de Cuenta Bancaria Base</td>
 <td><input type="text" name="registro2[bban]" value="@%db:Clientes_empresas.bban;%@" size="27" maxlength="26" class="insertext" /></td>
</tr>
</table>
</fieldset>

