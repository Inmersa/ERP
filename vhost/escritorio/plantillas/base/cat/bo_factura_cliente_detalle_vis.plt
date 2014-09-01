@%where:nodb|nodb_order_data;nombre|detalles;%@

<fieldset id="Factura_Cliente_Detalle" class="fsficha">
<legend>Detall</legend>

<table class="full">
<thead>
<tr>
<td >Codi</td>
<td >Quantitat</td>
<td >Preu</td>
<td >IVA</td>
<td >%Desc.</td>
<td >Import</td>
</tr>
</thead>

@%set:caracteres_linea_observaciones=130;%@
<tbody>
 @%where:nodb|nodb_order_details;contador|count;%@
 <!--
 @%set:num_detalles=count;%@
 @%db:medir_observaciones{observaciones}%@
 -->
 <!-- aqui empieza el registro -->

<tr>
<td>
@%if:AllowedLink;modif_articulos;%@
<a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a>
@%else:%@
@%db:nombre%@
@%end-if:%@
</td>

<td>@%db:cantidad;%@</td>
<td>@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
<td>@%db:porcentaje;%@</td>
<td><!-- @%db:monto;%@ -->
 <!-- @%db:descuento;%@ -->
 @%db:tipo_descuento%@</td>
<td>@%db:base_imponible;%@ </td>
</tr>
@%if:esta_vacio;observaciones;id_servicio;%@
@%else:%@
<tr>
<td colspan="4">@%db:observaciones%@</td>

 @%if:esta_vacio;id_servicio;%@
 <td></td><td></td><td></td>
 @%else:%@
 
<td >Esborrar Tots</td>
 <!-- @%set:ids=id_servicio;%@ -->
@%where:nodb|nodb_detail_contracts;%@
@%if:equals;ids;id;%@
<td>@%db:nombre;%@</td>
@%end-if:%@
@%end-where:%@
 
</tr>
 @%end-if:%@
@%end-if:%@
 <!-- aqui termina el registro -->
 @%end-where:%@

</tbody>
 </table>
</fieldset>
