@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@

<fieldset class="fsficha">
<legend>VOIP Product</legend>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.fabricacion_propia;label;%@">Always Local</td>
<td class="@%css:Empresas_articulos.fabricacion_propia;%@"><input type="checkbox" name="registro2[fabricacion_propia]" value="1" 
@%db:check_flag{Empresas_articulos.fabricacion_propia}%@ /></td>
</tr></table>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.descripcion;label;%@" >Telephone Area codes:</td>
<td colspan="3" class="@%css:Empresas_articulos.descripcion;%@" 
><textarea name="registro2[descripcion]" class="longdesc" >@%db:Empresas_articulos.descripcion;%@</textarea></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_costo;label;%@">Local Fare - Standard Time:</td>
<td class="@%css:Empresas_articulos.precio_costo;%@" ><input type="text" name="registro2[precio_costo]" value="@%db:Empresas_articulos.precio_costo%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_standard;label;%@">Local Fare - Reduced Time:</td>
<td class="@%css:Empresas_articulos.precio_standard;%@" ><input type="text" name="registro2[precio_standard]" value="@%db:Empresas_articulos.precio_standard%@" 
	class="importe" /></td></tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_venta;label;%@">Outbound Fare - Standard Time:</td>
<td class="@%css:Empresas_articulos.precio_venta;%@" ><input type="text" name="registro2[precio_venta]" value="@%db:Empresas_articulos.precio_venta%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_4;label;%@">Outbound Fare - Reduced Time:</td>
<td class="@%css:Empresas_articulos.precio_4;%@" ><input type="text" name="registro2[precio_4]" value="@%db:Empresas_articulos.precio_4%@" class="importe" /></td>
</tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_6;label;%@">Call Establishment:</td>
<td class="@%css:Empresas_articulos.precio_6;%@" ><input type="text" name="registro2[precio_6]" value="@%db:Empresas_articulos.precio_6%@" class="importe" /></td>
</tr>

<!-- td class="etiqueta @%css:Empresas_articulos.precio_5;label;%@">Price 5:</td>
<td class="@%css:Empresas_articulos.precio_5;%@" ><input type="text" name="registro2[precio_5]" value="@%db:Empresas_articulos.precio_5%@" class="importe" /></td -->
</table>
</fieldset>
