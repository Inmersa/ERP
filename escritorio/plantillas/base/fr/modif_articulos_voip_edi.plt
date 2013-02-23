@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@

<fieldset class="fsficha">
<legend>Produit de VOIP</legend>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.fabricacion_propia;label;%@">Appels Toujours Locaux</td>
<td class="@%css:Empresas_articulos.fabricacion_propia;%@"><input type="checkbox" name="registro2[fabricacion_propia]" value="1" 
@%db:check_flag{Empresas_articulos.fabricacion_propia}%@ /></td>
</tr></table>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.descripcion;label;%@" >Indicatifs r�gionaux:</td>
<td colspan="3" class="@%css:Empresas_articulos.descripcion;%@" 
><textarea name="registro2[descripcion]" class="longdesc" >@%db:Empresas_articulos.descripcion;%@</textarea></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_costo;label;%@">Prix Local - Temps Standard:</td>
<td class="@%css:Empresas_articulos.precio_costo;%@" ><input type="text" name="registro2[precio_costo]" value="@%db:Empresas_articulos.precio_costo%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_standard;label;%@">Prix Local - Temps R�duit:</td>
<td class="@%css:Empresas_articulos.precio_standard;%@" ><input type="text" name="registro2[precio_standard]" value="@%db:Empresas_articulos.precio_standard%@" 
	class="importe" /></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_venta;label;%@">Prix External - Temps Standard:</td>
<td class="@%css:Empresas_articulos.precio_venta;%@" ><input type="text" name="registro2[precio_venta]" value="@%db:Empresas_articulos.precio_venta%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_4;label;%@">Prix External - Temps R�duit:</td>
<td class="@%css:Empresas_articulos.precio_4;%@" ><input type="text" name="registro2[precio_4]" value="@%db:Empresas_articulos.precio_4%@" class="importe" /></td>
</tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_6;label;%@">Establissement D'Appel:</td>
<td class="@%css:Empresas_articulos.precio_6;%@" ><input type="text" name="registro2[precio_6]" value="@%db:Empresas_articulos.precio_6%@" class="importe" /></td>
</tr>

<!-- td class="etiqueta @%css:Empresas_articulos.precio_5;label;%@">Prix 5:</td>
<td class="@%css:Empresas_articulos.precio_5;%@" ><input type="text" name="registro2[precio_5]" value="@%db:Empresas_articulos.precio_5%@" class="importe" /></td -->
</table>
</fieldset>
