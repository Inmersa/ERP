@%where:tabla|Empresas;where|id_empresa = $id_empresa;%@
<table class="full">

<tr><td class="etiqueta">Preefixo da Factura:</td>
<td><input type="text" name="registro[prefijo_fact_ventas]" value="@%db:Empresas.prefijo_fact_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Factura:</td>
<td><input type="text" name="registro[sufijo_fact_ventas]" value="@%db:Empresas.sufijo_fact_ventas;%@" size="5" /></td>
<td class="etiqueta">D�gitos:</td>
<td > <input type="text" name="registro[digitos_fact_ventas]" value="@%db:Empresas.digitos_fact_ventas;%@" size="5" /></td>
<td class="etiqueta"></td>

 </tr>
<tr><td class="etiqueta">Prefixo da Encomenda:</td>
<td><input type="text" name="registro[prefijo_ped_ventas]" value="@%db:Empresas.prefijo_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Encomenda:</td>
<td><input type="text" name="registro[sufijo_ped_ventas]" value="@%db:Empresas.sufijo_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">D�gitos:</td>
<td > <input type="text" name="registro[digitos_ped_ventas]" value="@%db:Empresas.digitos_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">Contador de Encomendas:</td>
<td><input type="text" name="registro[contador_ped_ventas]" value="@%db:Empresas.contador_ped_ventas;%@" size="6" /></td>
 </tr>

<tr><td class="etiqueta @%css:Empresas.prefijo_alb_ventas;label;%@">Prefixo da Guia de Remessa:</td>
<td class="@%css:Empresas.prefijo_alb_ventas;%@" ><input type="text" name="registro[prefijo_alb_ventas]" value="@%db:Empresas.prefijo_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.sufijo_alb_ventas;label;%@">Sufixo da Guia de Remessa:</td>
<td class="@%css:Empresas.sufijo_alb_ventas;%@" ><input type="text" name="registro[sufijo_alb_ventas]" value="@%db:Empresas.sufijo_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.digitos_alb_ventas;label;%@">D�gitos:</td>
<td class="@%css:Empresas.digitos_alb_ventas;%@" ><input type="text" name="registro[digitos_alb_ventas]" value="@%db:Empresas.digitos_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.contador_alb_ventas;label;%@">Contador de Guias de Remessa:</td>
<td class="@%css:Empresas.contador_alb_ventas;%@" ><input type="text" name="registro[contador_alb_ventas]" value="@%db:Empresas.contador_alb_ventas;%@" size="6" /></td>
</tr>

<tr><td class="etiqueta">Prefixo do Or�amento:</td>
<td><input type="text" name="registro[prefijo_pre_ventas]" value="@%db:Empresas.prefijo_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufixo do Or�amento:</td>
<td><input type="text" name="registro[sufijo_pre_ventas]" value="@%db:Empresas.sufijo_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">D�gitos:</td>
<td > <input type="text" name="registro[digitos_pre_ventas]" value="@%db:Empresas.digitos_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">Contador de Or�amentos:</td>
<td><input type="text" name="registro[contador_pre_ventas]" value="@%db:Empresas.contador_pre_ventas;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Factura Pr�-forma:</td>
<td><input type="text" name="registro[prefijo_pro_ventas]" value="@%db:Empresas.prefijo_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufixo da Factura Pr�-forma:</td>
<td><input type="text" name="registro[sufijo_pro_ventas]" value="@%db:Empresas.sufijo_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">D�gitos:</td>
<td > <input type="text" name="registro[digitos_pro_ventas]" value="@%db:Empresas.digitos_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">Contador de Facturas Pr�-forma:</td>
<td><input type="text" name="registro[contador_pro_ventas]" value="@%db:Empresas.contador_pro_ventas;%@" size="6" /></td>
</tr>
</table>

