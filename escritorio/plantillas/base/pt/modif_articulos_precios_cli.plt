@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo and Empresas_articulos.id_empresa = $id_empresa;cfunc|cf_escritorios;%@
<!-- @%db:Articulos.id_articulo;%@ @%db:Empresas_articulos.precio_costo;%@
@%db:Empresas_articulos.precio_standard;%@ @%db:Empresas_articulos.precio_venta;%@
@%db:Empresas_articulos.precio_4;%@ @%db:Empresas_articulos.precio_5;%@
@%db:Empresas_articulos.precio_6;%@ 
-->

<fieldset class="fsficha">
<legend>Preços</legend>

<table class="full">
<tr><td class="etiqueta" >Referência:</td>
<td colspan="5">@%db:Empresas_articulos.referencia;%@</td></tr>

<tr><td class="etiqueta" >Descrição:</td>
<td colspan="5">@%db:Empresas_articulos.descripcion;%@</td></tr>

</tr>

<tr><td class="etiqueta">Preço:</td>
<td >@%db:precio_tarifa;search|0;%@</td>
<td class="etiqueta">PVP Recomendado:</td>
<td colspan="3">@%db:precio_recomendado;search|0;;%@</td>
</tr>

<tr><td class="etiqueta">Desconto por Volume:</td>
<td >@%db:Empresas_articulos.dto_vol;%@</td>
<td class="etiqueta">Embalagens Mínimas :</td>
<td colspan="3">@%db:Empresas_articulos.dto_vol_bultos;%@</td>
</tr>

<tr>
<td class="etiqueta">Stock Previsto:</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td class="etiqueta">Peso para Transporte:</td>
<td colspan="3">@%db:Articulos.peso_unidad;%@</td>

</tr>

<tr>
<td class="etiqueta">Unidades por Embalagem:</td>
<td>@%db:Empresas_articulos.unidades_bulto%@</td>
<td class="etiqueta">Embalagem Camada:</td>
<td>@%db:Empresas_articulos.bultos_capa_palet%@</td>
<td class="etiqueta">Camada Palete:</td>
<td>@%db:Empresas_articulos.capas_palet%@</td>
</tr>

</table></fieldset>

