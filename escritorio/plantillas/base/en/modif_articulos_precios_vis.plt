@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Prices</legend>
<table class="full">
<tr>
<td class="etiqueta">Last Modification:</td>
<td>@%db:colocar_fecha{Empresas_articulos.ultima_modificacion}%@</td>
<td class="etiqueta">Register date:</td>
<td >@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td class="etiqueta">Down :</td>
<td class="check">
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
@%db:descolocar_fecha{Empresas_articulos.fecha_baja};%@
@%end-if:%@
</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Own production</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.fabricacion_propia}%@</td>
<td class="etiqueta">Stock</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.stock}%@</td>
<td class="etiqueta">Web / POS</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.frecuente}%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta" >Ref.:</td>
<td colspan="5">@%db:Empresas_articulos.referencia;%@</td></tr>

<tr><td class="etiqueta" >Description:</td>
<td colspan="5">@%db:reemplazar_salto{Empresas_articulos.descripcion};%@</td></tr>

<tr><td class="etiqueta">Weight Transport.:</td>
<td colspan="5">@%db:Articulos.peso_unidad;%@</td></tr>

<tr><td class="etiqueta">Volume discount:</td>
<td >@%db:Empresas_articulos.dto_vol;%@ %</td>
<td class="etiqueta">Min. Packages :</td>
<td colspan="3">@%db:Empresas_articulos.dto_vol_bultos;%@</td>
</tr>

<tr>
<td class="etiqueta">Estimated Stock:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Minimun Stock:</td>
<td>@%db:Empresas_articulos.stock_minimo;%@</td>
<td class="etiqueta">Maximun Stock:</td>
<td>@%db:Empresas_articulos.stock_maximo;%@</td>
</tr>

<tr>
<td class="etiqueta">Units by package:</td>
<td>@%db:Empresas_articulos.unidades_bulto%@</td>
<td class="etiqueta">Packages by Layer:</td>
<td>@%db:Empresas_articulos.bultos_capa_palet%@</td>
<td class="etiqueta">Layers by Palet:</td>
<td>@%db:Empresas_articulos.capas_palet%@</td>
</tr>

<tr><td class="etiqueta">Price 1:</td>
<td >@%db:Empresas_articulos.precio_costo%@</td>
<td class="etiqueta">Price 2:</td>
<td>@%db:Empresas_articulos.precio_standard%@</td>
<td class="etiqueta">Price 3:</td>
<td>@%db:Empresas_articulos.precio_venta%@</td>
</tr>

<tr><td class="etiqueta">Price 4:</td>
<td >@%db:Empresas_articulos.precio_4%@</td>
<td class="etiqueta">Price 5:</td>
<td>@%db:Empresas_articulos.precio_5%@</td>
<td class="etiqueta">Price 6:</td>
<td>@%db:Empresas_articulos.precio_6%@</td>
</tr>

</table></fieldset>

