<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>D�tail</legend>

@%where:nodb|nodb_order_data;nombre|detalles;%@

<table class="full">

<thead>
<tr>
<td >Code</td>
<td >Quantite</td>
<td >Prix</td>
<td >TVA</td>
<td >% Rem.</td>
<td >Montant</td>
</tr>
</thead>

<tbody>
@%set:caracteres_linea_observaciones=130;%@
@%where:nodb|nodb_order_details;contador|count;%@ 
<!-- @%set:num_detalles=count;%@ -->
<!-- @%db:medir_observaciones{observaciones}%@ -->
<!-- aqui empieza el registro -->
<tr>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>
<td>@%db:cantidad;%@</td>
<td>@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
<td>@%db:porcentaje;%@</td>
<td>@%db:tipo_descuento%@</td>
<td>@%db:base_imponible;%@ </td>
</tr>
@%if:esta_vacio;observaciones;id_servicio;%@
@%else:%@
<td colspan="4">@%db:observaciones%@</td>
 <td colspan="3">
 @%if:esta_vacio;id_servicio;%@
 @%else:%@
    <!-- @%set:ids=id_servicio;%@ -->
    @%where:nodb|nodb_detail_contracts;%@
    	@%if:equals;ids;id;%@
	@%db:nombre;%@
	@%end-if:%@
    @%end-where:%@

 @%end-if:%@
 </td></tr>
@%else:%@
@%end-if:%@
<!-- aqui termina el registro -->
@%end-where:%@

</tbody>
</table>
@%end-where:%@
 
</fieldset>

