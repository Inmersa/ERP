@%where:tabla|Empresas;where|id_empresa = $id_empresa;%@
<table class="full">
<tr><td class="etiqueta">Prefixe de facture:</td>
<td><input type="text" name="registro[prefijo_fact_compras]" value="@%db:Empresas.prefijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Suffixe de facture:</td>
<td><input type="text" name="registro[sufijo_fact_compras]" value="@%db:Empresas.sufijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Chiffre:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_fact_compras]" value="@%db:Empresas.digitos_fact_compras;%@" size="5" /></td>
<td class="etiqueta"></td>
</tr>
<tr><td class="etiqueta">Prefixe de commande:</td>
<td><input type="text" name="registro[prefijo_ped_compras]" value="@%db:Empresas.prefijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Suffixe de commande:</td>
<td><input type="text" name="registro[sufijo_ped_compras]" value="@%db:Empresas.sufijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Chiffre:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_ped_compras]" value="@%db:Empresas.digitos_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Compteur de commande:</td>
<td><input type="text" name="registro[contador_ped_compras]" value="@%db:Empresas.contador_ped_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta @%css:Empresas.prefijo_alb_compras;label;%@">Prefixe Livraisons:</td>
<td class="@%css:Empresas.prefijo_alb_compras;%@" ><input type="text" name="registro[prefijo_alb_compras]" value="@%db:Empresas.prefijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.sufijo_alb_compras;label;%@">Suffixe livraison:</td>
<td class="@%css:Empresas.sufijo_alb_compras;%@" ><input type="text" name="registro[sufijo_alb_compras]" value="@%db:Empresas.sufijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.digitos_alb_compras;label;%@">Chiffre:</td>
<td class="@%css:Empresas.digitos_alb_compras;%@"> <input type="text" name="registro[digitos_alb_compras]" value="@%db:Empresas.digitos_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.contador_alb_compras;label;%@">Compteur de livraison:</td>
<td class="@%css:Empresas.contador_alb_ventas;%@" ><input type="text" name="registro[contador_alb_compras]" value="@%db:Empresas.contador_alb_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Prefix devis:</td>
<td><input type="text" name="registro[prefijo_pre_compras]" value="@%db:Empresas.prefijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Suffixe devis:</td>
<td><input type="text" name="registro[sufijo_pre_compras]" value="@%db:Empresas.sufijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Chiffre:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pre_compras]" value="@%db:Empresas.digitos_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Compteur de devis:</td>
<td><input type="text" name="registro[contador_pre_compras]" value="@%db:Empresas.contador_pre_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Proforma:</td>
<td><input type="text" name="registro[prefijo_pro_compras]" value="@%db:Empresas.prefijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Suffixe de Facture Proforma:</td>
<td><input type="text" name="registro[sufijo_pro_compras]" value="@%db:Empresas.sufijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Chiffre:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pro_compras]" value="@%db:Empresas.digitos_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Compteur de Facture Proforma:</td>
<td><input type="text" name="registro[contador_pro_compras]" value="@%db:Empresas.contador_pro_compras;%@" size="6" /></td>
</tr>

</table>
