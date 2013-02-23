@%where:tabla|Empresas;where|id_empresa = $id_empresa;%@
<table class="full">
<tr><td class="etiqueta">Preefixo da Factura:</td>
<td><input type="text" name="registro[prefijo_fact_compras]" value="@%db:Empresas.prefijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Factura:</td>
<td><input type="text" name="registro[sufijo_fact_compras]" value="@%db:Empresas.sufijo_fact_compras;%@" size="5" /></td>
<td class="etiqueta">Dígitos:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_fact_compras]" value="@%db:Empresas.digitos_fact_compras;%@" size="5" /></td>
<td class="etiqueta"></td>
</tr>
<tr><td class="etiqueta">Prefixo da Encomenda:</td>
<td><input type="text" name="registro[prefijo_ped_compras]" value="@%db:Empresas.prefijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Encomenda:</td>
<td><input type="text" name="registro[sufijo_ped_compras]" value="@%db:Empresas.sufijo_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Dígitos:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_ped_compras]" value="@%db:Empresas.digitos_ped_compras;%@" size="5" /></td>
<td class="etiqueta">Contador de Encomendas:</td>
<td><input type="text" name="registro[contador_ped_compras]" value="@%db:Empresas.contador_ped_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta @%css:Empresas.prefijo_alb_compras;label;%@">Prefixo da Guia de Remessa:</td>
<td class="@%css:Empresas.prefijo_alb_compras;%@" ><input type="text" name="registro[prefijo_alb_compras]" value="@%db:Empresas.prefijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.sufijo_alb_compras;label;%@">Sufixo da Guia de Remessa:</td>
<td class="@%css:Empresas.sufijo_alb_compras;%@" ><input type="text" name="registro[sufijo_alb_compras]" value="@%db:Empresas.sufijo_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.digitos_alb_compras;label;%@">Dígitos:</td>
<td class="@%css:Empresas.digitos_alb_compras;%@"> <input type="text" name="registro[digitos_alb_compras]" value="@%db:Empresas.digitos_alb_compras;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.contador_alb_compras;label;%@">Contador de Guias de Remessa:</td>
<td class="@%css:Empresas.contador_alb_ventas;%@" ><input type="text" name="registro[contador_alb_compras]" value="@%db:Empresas.contador_alb_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Prefixo do Orçamento:</td>
<td><input type="text" name="registro[prefijo_pre_compras]" value="@%db:Empresas.prefijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Sufixo do Orçamento:</td>
<td><input type="text" name="registro[sufijo_pre_compras]" value="@%db:Empresas.sufijo_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Dígitos:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pre_compras]" value="@%db:Empresas.digitos_pre_compras;%@" size="5" /></td>
<td class="etiqueta">Contador de Orçamentos:</td>
<td><input type="text" name="registro[contador_pre_compras]" value="@%db:Empresas.contador_pre_compras;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Factura Pró-forma:</td>
<td><input type="text" name="registro[prefijo_pro_compras]" value="@%db:Empresas.prefijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Factura Pró-forma:</td>
<td><input type="text" name="registro[sufijo_pro_compras]" value="@%db:Empresas.sufijo_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Dígitos:</td>
<td class="etiqueta"> <input type="text" name="registro[digitos_pro_compras]" value="@%db:Empresas.digitos_pro_compras;%@" size="5" /></td>
<td class="etiqueta">Contador de Facturas Pró-forma:</td>
<td><input type="text" name="registro[contador_pro_compras]" value="@%db:Empresas.contador_pro_compras;%@" size="6" /></td>
</tr>

</table>
