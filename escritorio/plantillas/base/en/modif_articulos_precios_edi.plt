@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Prices</legend>
<table class="full">
<tr>
<td class="etiqueta">Last Modification:</td>
<td>@%db:colocar_fecha{Empresas_articulos.ultima_modificacion}%@</td>
<td class="etiqueta">Register date:</td>
<td > <input type="text" name="registro2[fecha_alta]" value="@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@" /></td>
<td class="etiqueta">Down :</td>
<td class="check"> <input type="checkbox" name="registro2[causar_baja]" value="1" 
@%if:esta_vacio;Empresas_articulos.fecha_baja;%@
 />
@%else:%@
checked = "checked" />@%db:colocar_fecha{Empresas_articulos.fecha_baja};%@
<input type="hidden" name="registro2[fecha_baja]" value="@%db:Empresas_articulos.fecha_baja;%@" />
@%end-if:%@
</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta" >Ref.:</td>
<td colspan="5"><input type="text" name="registro2[referencia]" value="@%db:Empresas_articulos.referencia;%@" size="30" /></td></tr>

<tr><td class="@%css:Empresas_articulos.descripcion;label;%@" >Description:</td>
<td colspan="5" class="@%css:Empresas_articulos.descripcion;%@" 
><textarea name="registro2[descripcion]" class="longdesc" >@%db:Empresas_articulos.descripcion;%@</textarea></td></tr>

<tr><td class="etiqueta">Volume discount:</td>
<td ><input type="text" name="registro2[dto_vol]" value="@%db:Empresas_articulos.dto_vol;%@" size="6" maxlength="6" /> %</td>
<td class="etiqueta">Min. Packages :</td>
<td colspan="1"> <input type="text" name="registro2[dto_vol_bultos]" value="@%db:Empresas_articulos.dto_vol_bultos;%@" size="6" maxlength="6" /></td>
<td class="etiqueta">Units by package:</td>
<td><input type="text" name="registro2[unidades_bulto]" value="@%db:Empresas_articulos.unidades_bulto%@" size="10" /></td>
</tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_costo;label;%@">Price 1:</td>
<td class="@%css:Empresas_articulos.precio_costo;%@" ><input type="text" name="registro2[precio_costo]" value="@%db:Empresas_articulos.precio_costo%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_standard;label;%@">Price 2:</td>
<td class="@%css:Empresas_articulos.precio_standard;%@" ><input type="text" name="registro2[precio_standard]" value="@%db:Empresas_articulos.precio_standard%@" 
	class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_venta;label;%@">Price 3:</td>
<td class="@%css:Empresas_articulos.precio_venta;%@" ><input type="text" name="registro2[precio_venta]" value="@%db:Empresas_articulos.precio_venta%@" class="importe" /></td>
</tr>

<tr><td class="etiqueta @%css:Empresas_articulos.precio_4;label;%@">Price 4:</td>
<td class="@%css:Empresas_articulos.precio_4;%@" ><input type="text" name="registro2[precio_4]" value="@%db:Empresas_articulos.precio_4%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_5;label;%@">Price 5:</td>
<td class="@%css:Empresas_articulos.precio_5;%@" ><input type="text" name="registro2[precio_5]" value="@%db:Empresas_articulos.precio_5%@" class="importe" /></td>
<td class="etiqueta @%css:Empresas_articulos.precio_6;label;%@">Price 6:</td>
<td class="@%css:Empresas_articulos.precio_6;%@" ><input type="text" name="registro2[precio_6]" value="@%db:Empresas_articulos.precio_6%@" class="importe" /></td>
</tr>

</table></fieldset>

