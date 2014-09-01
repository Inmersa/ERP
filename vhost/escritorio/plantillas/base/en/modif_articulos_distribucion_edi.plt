@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>{{frame_distribucion}}</legend>

<table class="full"><tr>
<td class="@%css:Empresas_articulos.fabricacion_propia;label;%@">Own production</td>
<td class="@%css:Empresas_articulos.fabricacion_propia;%@"><input type="checkbox" name="registro2[fabricacion_propia]" value="1" @%db:check_flag{Empresas_articulos.fabricacion_propia}%@ /></td>
<td class="etiqueta">Stock</td>
<td class="check"><input type="checkbox" name="registro2[stock]" value="1" @%db:check_flag{Empresas_articulos.stock}%@ /></td>
</tr>
</table>

<table class="full">

<tr><td class="etiqueta">Weight Transport.:</td>
<td colspan="5"><input type="text" name="registro[peso_unidad]" value="@%db:Articulos.peso_unidad;%@" size="10" /></td></tr>

<tr><td class="etiqueta">{{fld_vidaproducto_dias}}:</td>
<td ><input type="text" name="registro[dias_vida]" value="@%db:Articulos.dias_vida;%@" size="10" /></td>
<td class="etiqueta">{{fld_ptovida_venta}}:</td>
<td ><input type="text" name="registro2[pto_vida_venta]" value="@%db:Empresas_articulos.pto_vida_venta;%@" size="5" /> % </td>
<td class="etiqueta">{{fld_ptovida_compra}}:</td>
<td ><input type="text" name="registro2[pto_vida_compra]" value="@%db:Empresas_articulos.pto_vida_compra;%@" size="5" /> % </td>
</tr>

<tr>
<td class="etiqueta">Estimated Stock:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Minimun Stock:</td>
<td><input type="text" name="registro2[stock_minimo]" value="@%db:Empresas_articulos.stock_minimo;%@" size="10" /></td>
<td class="etiqueta">Maximun Stock:</td>
<td><input type="text" name="registro2[stock_maximo]" value="@%db:Empresas_articulos.stock_maximo;%@" size="10" /></td>
</tr>

<tr>
<td class="etiqueta">Units by package:</td>
<td><input type="text" name="registro2[unidades_bulto]" value="@%db:Empresas_articulos.unidades_bulto%@" size="10" /></td>
<td class="etiqueta">Packages by Layer:</td>
<td><input type="text" name="registro2[bultos_capa_palet]" value="@%db:Empresas_articulos.bultos_capa_palet%@" size="10" /></td>
<td class="etiqueta">Layers by Palet:</td>
<td><input type="text" name="registro2[capas_palet]" value="@%db:Empresas_articulos.capas_palet%@" size="10" /></td>
</tr>

</table></fieldset>

