@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Preços</legend>
<table class="full">
<tr>
<td class="etiqueta">Última Modificação:</td>
<td>@%db:colocar_fecha{Empresas_articulos.ultima_modificacion}%@</td>
<td class="etiqueta">Data de Registo:</td>
<td >@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td class="etiqueta">Quebra :</td>
<td class="check">
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
@%db:descolocar_fecha{Empresas_articulos.fecha_baja};%@
@%end-if:%@
</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Fabrico Próprio</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.fabricacion_propia}%@</td>
<td class="etiqueta">Stock</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.stock}%@</td>
<td class="etiqueta">Web / TPV</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.frecuente}%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta" >Referência:</td>
<td colspan="5">@%db:Empresas_articulos.referencia;%@</td></tr>

<tr><td class="etiqueta" >Descrição:</td>
<td colspan="5">@%db:reemplazar_salto{Empresas_articulos.descripcion};%@</td></tr>

<tr><td class="etiqueta">Peso para Transporte:</td>
<td colspan="5">@%db:Articulos.peso_unidad;%@</td></tr>

<tr><td class="etiqueta">Desconto por Volume:</td>
<td >@%db:Empresas_articulos.dto_vol;%@ %</td>
<td class="etiqueta">Embalagens Mínimas :</td>
<td colspan="3">@%db:Empresas_articulos.dto_vol_bultos;%@</td>
</tr>

<tr>
<td class="etiqueta">Stock Previsto:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Stock Mínimo:</td>
<td>@%db:Empresas_articulos.stock_minimo;%@</td>
<td class="etiqueta">Stock Máximo:</td>
<td>@%db:Empresas_articulos.stock_maximo;%@</td>
</tr>

<tr>
<td class="etiqueta">Unidades por Embalagem:</td>
<td>@%db:Empresas_articulos.unidades_bulto%@</td>
<td class="etiqueta">Embalagem Camada:</td>
<td>@%db:Empresas_articulos.bultos_capa_palet%@</td>
<td class="etiqueta">Camada Palete:</td>
<td>@%db:Empresas_articulos.capas_palet%@</td>
</tr>

<tr><td class="etiqueta">Preço 1:</td>
<td >@%db:Empresas_articulos.precio_costo%@</td>
<td class="etiqueta">Preço 2:</td>
<td>@%db:Empresas_articulos.precio_standard%@</td>
<td class="etiqueta">Preço 3:</td>
<td>@%db:Empresas_articulos.precio_venta%@</td>
</tr>

<tr><td class="etiqueta">Preço 4:</td>
<td >@%db:Empresas_articulos.precio_4%@</td>
<td class="etiqueta">Preço 5:</td>
<td>@%db:Empresas_articulos.precio_5%@</td>
<td class="etiqueta">Preço 6:</td>
<td>@%db:Empresas_articulos.precio_6%@</td>
</tr>

</table></fieldset>

