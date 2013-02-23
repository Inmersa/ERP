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


<tr><td class="etiqueta">Compte Comptable de Fournisseur:</td>
<td colspan="3"> <input type="text" name="registro2[cc_proveedor]" value="@%db:Proveedores_empresas.cc_proveedor;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Compte Comptable d'Achats:</td>
<td colspan="3"> <input type="text" name="registro2[cc_compras]" value="@%db:Proveedores_empresas.cc_compras;%@" size="20" maxlength="10" /></td>
</tr>

<tr><td class="etiqueta">Remise financier:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_financiero]" value="@%db:Proveedores_empresas.cc_descuento_financiero;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Remises:</td>
<td colspan="3"> <input type="text" name="registro2[cc_descuento_comercial]" value="@%db:Proveedores_empresas.cc_descuento_comercial;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Dépenses:</td>
<td colspan="3"> <input type="text" name="registro2[cc_gastos]" value="@%db:Proveedores_empresas.cc_gastos;%@" size="20" maxlength="10" /></td>
<td class="etiqueta">Rétentions:</td>
<td colspan="3"> <input type="text" name="registro2[cc_retenciones]" value="@%db:Proveedores_empresas.cc_retenciones;%@" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Effets:</td>
<td colspan="3"> <input type="text" name="registro2[cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" size="20" maxlength="10" /></td>
</tr>
</table>

<table class="full">
<caption class="titulotb" >Compte bancaire IBAN</caption>

<tr><td class="etiqueta">Société bancaire</td>
<td><input type="text" name="registro2[entidad]" value="@%db:Proveedores_empresas.entidad;%@" size="5" maxlength="4" /></td>
<td class="etiqueta">Office</td>
<td><input type="text" name="registro2[oficina]" value="@%db:Proveedores_empresas.oficina;%@" size="5" maxlength="4" /></td>
<td class="etiqueta" >Contrôle / Nº Compte</td>
<td><input type="text" name="registro2[dc_ccc]" value="@%db:Proveedores_empresas.dc_ccc;%@" size="3" maxlength="2" />
<input type="text" name="registro2[cuenta_bancaria]" value="@%db:Proveedores_empresas.cuenta_bancaria;%@" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">Pays / contrôle</td>
 <td><input type="text" name="registro2[iban]" value="@%db:Proveedores_empresas.iban;%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">Code Identificateur de Banque</td>
 <td><input type="text" name="registro2[bic]" value="@%db:Proveedores_empresas.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Numéro de Compte Bancaire Base</td>
 <td><input type="text" name="registro2[bban]" value="@%db:Proveedores_empresas.bban;%@" size="27" maxlength="26" class="insertext"></td>
</tr>
</table>

</fieldset>


<fieldset class="fsficha">
<legend>Jours de paiement</legend>
<table class="full">
<tr>
<td class="etiqueta"> Premièr</td>
<td><input type="text" name="registro2[dia_facturacion_1]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_1%@" /></td>
<td class="etiqueta"> Seconde</td>
<td><input type="text" name="registro2[dia_facturacion_2]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_2%@" /></td>
<td class="etiqueta"> Troisième</td>
<td><input type="text" name="registro2[dia_facturacion_3]" size="2" value="@%db:Proveedores_empresas.dia_facturacion_3%@" /></td>
</tr>
</table>
</fieldset>

