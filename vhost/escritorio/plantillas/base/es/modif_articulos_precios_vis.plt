@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Precios</legend>
<table class="full">
<tr>
<td class="etiqueta">Última Modificación:</td>
<td>@%db:colocar_fecha{Empresas_articulos.ultima_modificacion}%@</td>
<td class="etiqueta">Fecha alta:</td>
<td >@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td class="etiqueta">Baja :</td>
<td class="check">
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
@%db:descolocar_fecha{Empresas_articulos.fecha_baja};%@
@%end-if:%@
</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Fabricación propia</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.fabricacion_propia}%@</td>
<td class="etiqueta">Stock</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.stock}%@</td>
<td class="etiqueta">Web/TPV</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.frecuente}%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta" >Ref:</td>
<td colspan="5">@%db:Empresas_articulos.referencia;%@</td></tr>

<tr><td class="etiqueta" >Descripción:</td>
<td colspan="5">@%db:reemplazar_salto{Empresas_articulos.descripcion};%@</td></tr>

<tr><td class="etiqueta">Peso tpte.:</td>
<td colspan="5">@%db:Articulos.peso_unidad;%@</td></tr>

<tr><td class="etiqueta">Dto por Volumen:</td>
<td >@%db:Empresas_articulos.dto_vol;%@ %</td>
<td class="etiqueta">Bultos Min. :</td>
<td colspan="3">@%db:Empresas_articulos.dto_vol_bultos;%@</td>
</tr>

<tr>
<td class="etiqueta">Stk Est.:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Stock mínimo:</td>
<td>@%db:Empresas_articulos.stock_minimo;%@</td>
<td class="etiqueta">Stock máximo:</td>
<td>@%db:Empresas_articulos.stock_maximo;%@</td>
</tr>

<tr>
<td class="etiqueta">Uds. bulto:</td>
<td>@%db:Empresas_articulos.unidades_bulto%@</td>
<td class="etiqueta">Bultos por Capa:</td>
<td>@%db:Empresas_articulos.bultos_capa_palet%@</td>
<td class="etiqueta">Capas por Palet:</td>
<td>@%db:Empresas_articulos.capas_palet%@</td>
</tr>

<tr><td class="etiqueta">Precio 1:</td>
<td >@%db:Empresas_articulos.precio_costo%@</td>
<td class="etiqueta">Precio 2:</td>
<td>@%db:Empresas_articulos.precio_standard%@</td>
<td class="etiqueta">Precio 3:</td>
<td>@%db:Empresas_articulos.precio_venta%@</td>
</tr>

<tr><td class="etiqueta">Precio 4:</td>
<td >@%db:Empresas_articulos.precio_4%@</td>
<td class="etiqueta">Precio 5:</td>
<td>@%db:Empresas_articulos.precio_5%@</td>
<td class="etiqueta">Precio 6:</td>
<td>@%db:Empresas_articulos.precio_6%@</td>
</tr>

</table></fieldset>

