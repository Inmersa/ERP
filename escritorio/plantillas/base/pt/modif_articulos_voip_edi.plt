@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@

<fieldset class="fsficha">
<legend>Produto de VOIP</legend>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.fabricacion_propia;label;%@">Sempre chamada Local</td>
<td class="@%css:Empresas_articulos.fabricacion_propia;%@"><input type="checkbox" name="registro2[fabricacion_propia]" value="1" 
@%db:check_flag{Empresas_articulos.fabricacion_propia}%@ /></td>
</tr></table>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.descripcion;label;%@" >C�digos de �rea:</td>
<td colspan="3" class="@%css:Empresas_articulos.descripcion;%@" 
><textarea name="registro2[descripcion]" class="longdesc" >@%db:Empresas_articulos.descripcion;%@</textarea></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_costo;label;%@">Pre�o Local - Tempo Padr�o:</td>
<td class="@%css:Empresas_articulos.precio_costo;%@" ><input type="text" name="registro2[precio_costo]" value="@%db:Empresas_articulos.precio_costo%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_standard;label;%@">Pre�o Local - Tempo Reduzido:</td>
<td class="@%css:Empresas_articulos.precio_standard;%@" ><input type="text" name="registro2[precio_standard]" value="@%db:Empresas_articulos.precio_standard%@" 
	class="importe" /></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_venta;label;%@">Pre�o chamada externa - Tempo Padr�o:</td>
<td class="@%css:Empresas_articulos.precio_venta;%@" ><input type="text" name="registro2[precio_venta]" value="@%db:Empresas_articulos.precio_venta%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_4;label;%@">Pre�o chamada externa - Tempo Reduzido:</td>
<td class="@%css:Empresas_articulos.precio_4;%@" ><input type="text" name="registro2[precio_4]" value="@%db:Empresas_articulos.precio_4%@" class="importe" /></td>
</tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_6;label;%@">Estabelecimento Da Chamada:</td>
<td class="@%css:Empresas_articulos.precio_6;%@" ><input type="text" name="registro2[precio_6]" value="@%db:Empresas_articulos.precio_6%@" class="importe" /></td>
</tr>

<!-- td class="etiqueta @%css:Empresas_articulos.precio_5;label;%@">Pre�o 5:</td>
<td class="@%css:Empresas_articulos.precio_5;%@" ><input type="text" name="registro2[precio_5]" value="@%db:Empresas_articulos.precio_5%@" class="importe" /></td -->
</table>
</fieldset>
