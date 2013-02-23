@%where:tabla|Empresas;where|id_empresa = $id_empresa;%@
<table class="full">
<tr><td class="etiqueta">Invoice prefix:</td>
<td><input type="text" name="registro[prefijo_fact_compras]" value="@%db:Empresas.prefijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Invoice suffix:</td>
<td><input type="text" name="registro[sufijo_fact_compras]" value="@%db:Empresas.sufijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Digits:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_fact_compras]" value="@%db:Empresas.digitos_fact_compras;%@" size="5" /></td>
<td class="etiqueta"></td>
</tr>
<tr><td class="etiqueta">Order prefix:</td>
<td><input type="text" name="registro[prefijo_ped_compras]" value="@%db:Empresas.prefijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Order suffix:</td>
<td><input type="text" name="registro[sufijo_ped_compras]" value="@%db:Empresas.sufijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Digits:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_ped_compras]" value="@%db:Empresas.digitos_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Order meter:</td>
<td><input type="text" name="registro[contador_ped_compras]" value="@%db:Empresas.contador_ped_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta @%css:Empresas.prefijo_alb_compras;label;%@">Prefix Delivery note:</td>
<td class="@%css:Empresas.prefijo_alb_compras;%@" ><input type="text" name="registro[prefijo_alb_compras]" value="@%db:Empresas.prefijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.sufijo_alb_compras;label;%@">Delivery note suffix:</td>
<td class="@%css:Empresas.sufijo_alb_compras;%@" ><input type="text" name="registro[sufijo_alb_compras]" value="@%db:Empresas.sufijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.digitos_alb_compras;label;%@">Digits:</td>
<td class="@%css:Empresas.digitos_alb_compras;%@"> <input type="text" name="registro[digitos_alb_compras]" value="@%db:Empresas.digitos_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.contador_alb_compras;label;%@">Delivery notes meter:</td>
<td class="@%css:Empresas.contador_alb_ventas;%@" ><input type="text" name="registro[contador_alb_compras]" value="@%db:Empresas.contador_alb_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Budget prefix:</td>
<td><input type="text" name="registro[prefijo_pre_compras]" value="@%db:Empresas.prefijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Budget suffix:</td>
<td><input type="text" name="registro[sufijo_pre_compras]" value="@%db:Empresas.sufijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Digits:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pre_compras]" value="@%db:Empresas.digitos_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Budget meter:</td>
<td><input type="text" name="registro[contador_pre_compras]" value="@%db:Empresas.contador_pre_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Proforma Invoice:</td>
<td><input type="text" name="registro[prefijo_pro_compras]" value="@%db:Empresas.prefijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Proforma Invoice suffix:</td>
<td><input type="text" name="registro[sufijo_pro_compras]" value="@%db:Empresas.sufijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Digits:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pro_compras]" value="@%db:Empresas.digitos_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Proforma Invoice meter:</td>
<td><input type="text" name="registro[contador_pro_compras]" value="@%db:Empresas.contador_pro_compras;%@" size="6" /></td>
</tr>

</table>
