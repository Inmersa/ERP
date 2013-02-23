<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>Details</legend>

@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail;%@

@%if:nomodificar_detalles;%@
@%else:%@
<div class="barraoscura">
	@%if:AllowedLink;hacer_pedido;%@
		@%if:AllowedAction;Presupuestos;edit;%@
		<a href="?seccion=hacer_pedido">Modify Order Details</a> 
		@%end-if:%@
	@%end-if:%@
	@%if:AllowedAction;Lineas_detalle_presupuesto;del;%@
	<a href="#" onclick="return onHRefClick('pedido','accion_ejecutar','Borrar');">Delete(s)</a>
	@%set:permitir_selecciones=1;%@
	@%end-if:%@
</div>
@%end-if:%@

<table class="full">

<tr>
<td></td>
<td class="caption">Code</td>
<td class="caption">Amount</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td class="caption">Price</td>
@%end-if:%@
<td class="caption">VAT</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td class="caption">% Discount</td>
<td class="caption">Amount</td>
@%end-if:%@
 </tr>
<!-- @%set:estado=estado;%@ -->
@%set:caracteres_linea_observaciones=130;%@
@%where:nodb|nodb_order_details;contador|count;%@ 

<!-- @%set:num_detalles=count;%@ -->
<!-- @%db:medir_observaciones{observaciones}%@ -->

<!-- aqui empieza el registro -->

<tr>
<td class="check">
@%if:esta_vacio;permitir_selecciones;%@
@%else:%@
<!-- este checkbox solo va si el pedido no esta consolidado (lo mismo pal enlace de añadir>-->
 <input type="checkbox" name="borrar_articulos[]" value="@%db:idx_detalle%@" />
@%end-if:%@
</td>
<td>
@%if:AllowedLink;modif_articulos;%@
<a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a>
@%else:%@
@%db:nombre%@
@%end-if:%@
</td>
<td>@%db:cantidad;%@</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td>@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
@%end-if:%@
<td>@%db:porcentaje;%@</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td>@%db:tipo_descuento%@</td>
@%end-if:%@
@%if:esta_vacio;estado;%@
@%else:%@
<td>@%db:base_imponible;%@</td>
@%end-if:%@
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
 </td>
 </tr>
@%else:%@
@%end-if:%@

<!-- aqui termina el registro -->
@%end-where:%@

</table>

@%end-where:%@
 
 
</fieldset>
