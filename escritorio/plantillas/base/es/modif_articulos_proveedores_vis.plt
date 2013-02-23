<fieldset class="fsficha">
<legend>Proveedores</legend>

<table class="full">
<thead>
<tr>
<td >Nombre</td>
<td >Referencia</td>
<!-- td >Precio</td >
<td >Pr. Rt Oficial</td>
<td >Pr. Pub Oficial</td>
<td >Descuento</td -->
<td >Fab.</td>
<!-- td >Dto por Volumen</td -->
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
<!-- td class="etiqueta"> @%db:Compra_articulos.dto_vol;%@% X@%db:Compra_articulos.dto_vol_bultos;%@ Bts. </td -->
</tr>
@%if:!esta_vacio;Compra_articulos.id_servicio;%@
<tr><td colspan="9">
<table class="full">
<tr>
<td class="etiqueta">Servicio</td>
<td>
@%where:nombre|servicios;tabla|Servicios;%@
@%db:Servicios.nombre;%@ 
@%end-where:%@

</td>
<!-- td class="etiqueta">Cuota de Alta</td>
<td>@%db:Compra_articulos.cuota_alta;%@</td>

@%if:esta_vacio;Compra_articulos.servicios_duracion_precio;%@
<td class="etiqueta">Por Unidad</td>
<td >@%db:si_no_flag{Compra_articulos.id_articulo};%@</td>
@%else:%@
<td class="etiqueta">Días</td>
<td>@%db:Compra_articulos.servicios_duracion_precio;%@</td>
@%end-if:%@
<td class="etiqueta">Facturación de Servicio por Adelantado</td>
<td class="check">@%db:si_no_flag{Compra_articulos.servicios_poradelantado};%@ </td -->

</tr>
</table>
</td></tr>
@%end-if:%@
@%end-where:%@

</tbody>
</table>
</fieldset>

