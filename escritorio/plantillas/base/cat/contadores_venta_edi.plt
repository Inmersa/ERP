@%where:tabla|Empresas;where|id_empresa = $id_empresa;%@
<table class="full">

<tr><td class="etiqueta">Prefix factura:</td>
<td><input type="text" name="registro[prefijo_fact_ventas]" value="@%db:Empresas.prefijo_fact_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufix factura:</td>
<td><input type="text" name="registro[sufijo_fact_ventas]" value="@%db:Empresas.sufijo_fact_ventas;%@" size="5" /></td>
<td class="etiqueta">Dígits:</td>
<td > <input type="text" name="registro[digitos_fact_ventas]" value="@%db:Empresas.digitos_fact_ventas;%@" size="5" /></td>
<td class="etiqueta"></td>

 </tr>
<tr><td class="etiqueta">Prefix comanda:</td>
<td><input type="text" name="registro[prefijo_ped_ventas]" value="@%db:Empresas.prefijo_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufix comanda:</td>
<td><input type="text" name="registro[sufijo_ped_ventas]" value="@%db:Empresas.sufijo_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">Dígits:</td>
<td > <input type="text" name="registro[digitos_ped_ventas]" value="@%db:Empresas.digitos_ped_ventas;%@" size="5" /></td>
<td class="etiqueta">Comptadors de comanda:</td>
<td><input type="text" name="registro[contador_ped_ventas]" value="@%db:Empresas.contador_ped_ventas;%@" size="6" /></td>
 </tr>

<tr><td class="etiqueta @%css:Empresas.prefijo_alb_ventas;label;%@">Prefix Albaràns:</td>
<td class="@%css:Empresas.prefijo_alb_ventas;%@" ><input type="text" name="registro[prefijo_alb_ventas]" value="@%db:Empresas.prefijo_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.sufijo_alb_ventas;label;%@">Sufix albarà:</td>
<td class="@%css:Empresas.sufijo_alb_ventas;%@" ><input type="text" name="registro[sufijo_alb_ventas]" value="@%db:Empresas.sufijo_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.digitos_alb_ventas;label;%@">Dígits:</td>
<td class="@%css:Empresas.digitos_alb_ventas;%@" ><input type="text" name="registro[digitos_alb_ventas]" value="@%db:Empresas.digitos_alb_ventas;%@" size="5" /></td>
<td class="etiqueta @%css:Empresas.contador_alb_ventas;label;%@">Comptadors de albarà:</td>
<td class="@%css:Empresas.contador_alb_ventas;%@" ><input type="text" name="registro[contador_alb_ventas]" value="@%db:Empresas.contador_alb_ventas;%@" size="6" /></td>
</tr>

<tr><td class="etiqueta">Prefix pressupost:</td>
<td><input type="text" name="registro[prefijo_pre_ventas]" value="@%db:Empresas.prefijo_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufix pressupost:</td>
<td><input type="text" name="registro[sufijo_pre_ventas]" value="@%db:Empresas.sufijo_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">Dígits:</td>
<td > <input type="text" name="registro[digitos_pre_ventas]" value="@%db:Empresas.digitos_pre_ventas;%@" size="5" /></td>
<td class="etiqueta">Comptadors de pressupost:</td>
<td><input type="text" name="registro[contador_pre_ventas]" value="@%db:Empresas.contador_pre_ventas;%@" size="6" /></td>
</tr>
<tr><td class="etiqueta">Proforma:</td>
<td><input type="text" name="registro[prefijo_pro_ventas]" value="@%db:Empresas.prefijo_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">Sufix Proforma:</td>
<td><input type="text" name="registro[sufijo_pro_ventas]" value="@%db:Empresas.sufijo_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">Dígits:</td>
<td > <input type="text" name="registro[digitos_pro_ventas]" value="@%db:Empresas.digitos_pro_ventas;%@" size="5" /></td>
<td class="etiqueta">Comptador de Proforma:</td>
<td><input type="text" name="registro[contador_pro_ventas]" value="@%db:Empresas.contador_pro_ventas;%@" size="6" /></td>
</tr>
</table>

