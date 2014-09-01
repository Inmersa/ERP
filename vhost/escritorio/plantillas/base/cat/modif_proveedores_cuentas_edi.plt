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
<legend>Comptes comptables:</legend>
<table class="full">


<tr><td class="etiqueta">Compte Comptable de Proveïdor:</td>
<td colspan="3"> <input type="text" name="registro2[cc_proveedor]" value="@%db:Proveedores_empresas.cc_proveedor;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Compte Comptable de Compres:</td>
<td colspan="3"> <input type="text" name="registro2[cc_compras]" value="@%db:Proveedores_empresas.cc_compras;%@" size="20" maxlength="10" /></td>
</tr>

<tr><td class="etiqueta">Descompte financier:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_financiero]" value="@%db:Proveedores_empresas.cc_descuento_financiero;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Descomptes:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_comercial]" value="@%db:Proveedores_empresas.cc_descuento_comercial;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Consumacions:</td>
<td colspan="3"> <input type="text" name="registro2[cc_gastos]" value="@%db:Proveedores_empresas.cc_gastos;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Retencións:</td>
<td colspan="3"> <input type="text" name="registro2[cc_retenciones]" value="@%db:Proveedores_empresas.cc_retenciones;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Efectes:</td>
<td colspan="3"> <input type="text" name="registro2[cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" size="20" maxlength="10" /></td>
</tr>
</table>

<table class="full">
<caption class="titulotb" >Compte bancari IBAN</caption>

<tr><td class="etiqueta">Entitat</td>
<td><input type="text" name="registro2[entidad]" value="@%db:Proveedores_empresas.entidad;%@" size="5" maxlength="4" /></td>
<td class="etiqueta">Oficina</td>
<td><input type="text" name="registro2[oficina]" value="@%db:Proveedores_empresas.oficina;%@" size="5" maxlength="4" /></td>
<td class="etiqueta" >DC/ Nº Compte</td>
<td><input type="text" name="registro2[dc_ccc]" value="@%db:Proveedores_empresas.dc_ccc;%@" size="3" maxlength="2" />
<input type="text" name="registro2[cuenta_bancaria]" value="@%db:Proveedores_empresas.cuenta_bancaria;%@" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">País / DC</td>
 <td><input type="text" name="registro2[iban]" value="@%db:Proveedores_empresas.iban;%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">Códi de Banc</td>
 <td><input type="text" name="registro2[bic]" value="@%db:Proveedores_empresas.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Compte Bancari Base</td>
 <td><input type="text" name="registro2[bban]" value="@%db:Proveedores_empresas.bban;%@" size="27" maxlength="26" class="insertext"></td>
</tr>
</table>

</fieldset>


<fieldset class="fsficha">
<legend>Dies de pagament</legend>
<table class="full">
<tr>
<td class="etiqueta"> Primer</td>
<td><input type="text" name="registro2[dia_facturacion_1]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_1%@" /></td>
<td class="etiqueta"> Segon</td>
<td><input type="text" name="registro2[dia_facturacion_2]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_2%@" /></td>
<td class="etiqueta"> Tercer</td>
<td><input type="text" name="registro2[dia_facturacion_3]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_3%@" /></td>
</tr>
</table>
</fieldset>

