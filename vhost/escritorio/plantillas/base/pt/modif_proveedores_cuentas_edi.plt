@%where:tabla|Proveedores;where|Proveedores_empresas.id_proveedor = $id_proveedor_promocion AND Proveedores_empresas.id_empresa = $id_empresa;%@
<input type="hidden" name="cc_old[cc_proveedor]" value="@%db:Proveedores_empresas.cc_proveedor;%@" />
<input type="hidden" name="cc_old[cc_compras]" value="@%db:Proveedores_empresas.cc_compras;%@" />
<input type="hidden" name="cc_old[cc_banco]" value="@%db:Proveedores_empresas.cc_banco;%@" />
<input type="hidden" name="cc_old[cc_descuento_financiero]" value="@%db:Proveedores_empresas.cc_descuento_financiero;%@" />
<input type="hidden" name="cc_old[cc_descuento_comercial]" value="@%db:Proveedores_empresas.cc_descuento_comercial;%@" />
<input type="hidden" name="cc_old[cc_descuento_gastos]" value="@%db:Proveedores_empresas.cc_gastos;%@" />
<input type="hidden" name="cc_old[cc_descuento_retenciones]" value="@%db:Proveedores_empresas.cc_retenciones;%@" />
<input type="hidden" name="cc_old[cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" />


<fieldset class="fsficha">
<legend>Contas Contabil�sticas:</legend>
<table class="full">


<tr><td class="etiqueta">Conta Contabil�stica fornecedor:</td>
<td colspan="3"> <input type="text" name="registro2[cc_proveedor]" value="@%db:Proveedores_empresas.cc_proveedor;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Conta Contabil�stica de Compras:</td>
<td colspan="3"> <input type="text" name="registro2[cc_compras]" value="@%db:Proveedores_empresas.cc_compras;%@" size="20" maxlength="10" /></td>
</tr>

<tr><td class="etiqueta">Desconto Financeiro:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_financiero]" value="@%db:Proveedores_empresas.cc_descuento_financiero;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Desconto Comercial:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_comercial]" value="@%db:Proveedores_empresas.cc_descuento_comercial;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Despesas:</td>
<td colspan="3"> <input type="text" name="registro2[cc_gastos]" value="@%db:Proveedores_empresas.cc_gastos;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Reten��es:</td>
<td colspan="3"> <input type="text" name="registro2[cc_retenciones]" value="@%db:Proveedores_empresas.cc_retenciones;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Ordens de Pagamento:</td>
<td colspan="3"> <input type="text" name="registro2[cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" size="20" maxlength="10" /></td>
</tr>
</table>

<table class="full">
<caption class="titulotb" >IBAN</caption>

<tr><td class="etiqueta">Entidade</td>
<td><input type="text" name="registro2[entidad]" value="@%db:Proveedores_empresas.entidad;%@" size="5" maxlength="4" /></td>
<td class="etiqueta">Escrit�rio</td>
<td><input type="text" name="registro2[oficina]" value="@%db:Proveedores_empresas.oficina;%@" size="5" maxlength="4" /></td>
<td class="etiqueta" >DC/N.� Conta</td>
<td><input type="text" name="registro2[dc_ccc]" value="@%db:Proveedores_empresas.dc_ccc;%@" size="3" maxlength="2" />
<input type="text" name="registro2[cuenta_bancaria]" value="@%db:Proveedores_empresas.cuenta_bancaria;%@" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">Pa�s / DC</td>
 <td><input type="text" name="registro2[iban]" value="@%db:Proveedores_empresas.iban;%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">C�digo Identificador de Banco</td>
 <td><input type="text" name="registro2[bic]" value="@%db:Proveedores_empresas.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">N�mero de Conta Banc�rio Base</td>
 <td><input type="text" name="registro2[bban]" value="@%db:Proveedores_empresas.bban;%@" size="27" maxlength="26" class="insertext"></td>
</tr>
</table>

</fieldset>


<fieldset class="fsficha">
<legend>Dias do pagamento</legend>
<table class="full">
<tr>
<td class="etiqueta"> Primeiro</td>
<td><input type="text" name="registro2[dia_facturacion_1]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_1%@" /></td>
<td class="etiqueta"> Segundo</td>
<td><input type="text" name="registro2[dia_facturacion_2]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_2%@" /></td>
<td class="etiqueta"> Terceiro</td>
<td><input type="text" name="registro2[dia_facturacion_3]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_3%@" /></td>
</tr>
</table>
</fieldset>

