<fieldset class="fsficha">
<legend>Fornecedores</legend>

<table class="full">
<thead>
<tr>
<td >Nome</td>
<td >Refer�ncia</td>
<!-- td >Pre�o</td >
<td >Pr.Rt Oficial</td>
<td >Pr.Pub Oficial</td>
<td >Desconto</td -->
<td >Fab.</td>
<!-- td >Desconto por Volume</td -->
</tr>
</thead>

<!-- @%set:_store_id_reset=1;%@ -->
<tbody>
@%where:nombre|compraarticulos;tabla|Compra_articulos;nolink|1;where|Compra_articulos.id_articulo = $id_articulo AND Compra_articulos.fecha_baja IS NULL;%@
<!--@%db:Compra_articulos.fabricante;%@ @%db:Compra_articulos.id_servicio;%@ @%db:Compra_articulos.id_articulo;%@ @%db:Compra_articulos.id_proveedor;%@ -->
<tr>
<td><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.nombre;%@</a></td>
<td>@%db:Compra_articulos.referencia;%@ </td>
<!-- td>@%db:Compra_articulos.precio;%@ </td >
<td>@%db:Compra_articulos.PV_oficial;%@ </td>
<td>@%db:Compra_articulos.PVP_oficial;%@ </td>
<td>@%db:Compra_articulos.descuento;%@ </td -->
<td class="check">@%db:si_no_flag{Compra_articulos.fabricante}%@ </td>
<!-- td class="etiqueta"> @%db:Compra_articulos.dto_vol;%@% X@%db:Compra_articulos.dto_vol_bultos;%@ Emb </td -->
</tr>
@%if:!esta_vacio;Compra_articulos.id_servicio;%@
<tr><td colspan="9">
<table class="full">
<tr>
<td class="etiqueta">Servi�o</td>
<td>
@%where:nombre|servicios;tabla|Servicios;%@
@%db:Servicios.nombre;%@ 
@%end-where:%@

</td>
<!-- td class="etiqueta">Taxa de Subscri��o</td>
<td>@%db:Compra_articulos.cuota_alta;%@</td>

@%if:esta_vacio;Compra_articulos.servicios_duracion_precio;%@
<td class="etiqueta">Pre�o por Unidade</td>
<td >@%db:si_no_flag{Compra_articulos.id_articulo};%@</td>
@%else:%@
<td class="etiqueta">Dias</td>
<td>@%db:Compra_articulos.servicios_duracion_precio;%@</td>
@%end-if:%@
<td class="etiqueta">Pr�-factura��o</td>
<td class="check">@%db:si_no_flag{Compra_articulos.servicios_poradelantado};%@ </td -->

</tr>
</table>
</td></tr>
@%end-if:%@
@%end-where:%@

</tbody>
</table>
</fieldset>

