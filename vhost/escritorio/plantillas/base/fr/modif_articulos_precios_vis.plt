@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Prixes</legend>
<table class="full">
<tr>
<td class="etiqueta">Dernière Modification:</td>
<td>@%db:colocar_fecha{Empresas_articulos.ultima_modificacion}%@</td>
<td class="etiqueta">Début de période:</td>
<td >@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td class="etiqueta">Baisse :</td>
<td class="check">
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
@%db:descolocar_fecha{Empresas_articulos.fecha_baja};%@
@%end-if:%@
</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Même fabrication</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.fabricacion_propia}%@</td>
<td class="etiqueta">Stock</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.stock}%@</td>
<td class="etiqueta">WEB / Caisse enregistreuse</td>
<td class="check">@%db:si_no_flag{Empresas_articulos.frecuente}%@</td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta" >Ref.:</td>
<td colspan="5">@%db:Empresas_articulos.referencia;%@</td></tr>

<tr><td class="etiqueta" >Description:</td>
<td colspan="5">@%db:reemplazar_salto{Empresas_articulos.descripcion};%@</td></tr>

<tr><td class="etiqueta">Pèse transport:</td>
<td colspan="5">@%db:Articulos.peso_unidad;%@</td></tr>

<tr><td class="etiqueta">Remises par volume:</td>
<td >@%db:Empresas_articulos.dto_vol;%@ %</td>
<td class="etiqueta">Bosses min. :</td>
<td colspan="3">@%db:Empresas_articulos.dto_vol_bultos;%@</td>
</tr>

<tr>
<td class="etiqueta">Stock Estimée:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Stock Minime:</td>
<td>@%db:Empresas_articulos.stock_minimo;%@</td>
<td class="etiqueta">Stock Maximum:</td>
<td>@%db:Empresas_articulos.stock_maximo;%@</td>
</tr>

<tr>
<td class="etiqueta">Unités bosse:</td>
<td>@%db:Empresas_articulos.unidades_bulto%@</td>
<td class="etiqueta">Bosses Cape:</td>
<td>@%db:Empresas_articulos.bultos_capa_palet%@</td>
<td class="etiqueta">Cape Palet:</td>
<td>@%db:Empresas_articulos.capas_palet%@</td>
</tr>

<tr><td class="etiqueta">Prix 1:</td>
<td >@%db:Empresas_articulos.precio_costo%@</td>
<td class="etiqueta">Prix 2:</td>
<td>@%db:Empresas_articulos.precio_standard%@</td>
<td class="etiqueta">Prix 3:</td>
<td>@%db:Empresas_articulos.precio_venta%@</td>
</tr>

<tr><td class="etiqueta">Prix 4:</td>
<td >@%db:Empresas_articulos.precio_4%@</td>
<td class="etiqueta">Prix 5:</td>
<td>@%db:Empresas_articulos.precio_5%@</td>
<td class="etiqueta">Prix 6:</td>
<td>@%db:Empresas_articulos.precio_6%@</td>
</tr>

</table></fieldset>

