

<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>Details</legend>

@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail;%@

@%if:nomodificar_detalles;%@
@%else:%@
<div class="AccionesFicha"><ul>
@%if:AllowedLink;hacer_pedido;%@
	@%if:AllowedAction;Pedidos;edit;%@
	<li><a href="?seccion=hacer_pedido" class="editar" ><img src="images/pixel.png" class="icono" /><span>Modify Order Details</span></a></li>
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Lineas_detalle_pedido;del;%@
<li><a href="#" onclick="return onHRefClick('pedido','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete(s)</span></a></li>
@%set:permitir_selecciones=1;%@
@%end-if:%@
</ul></div>
@%end-if:%@

<table class="full">

<thead>
<tr>
<td></td>
<td >Code</td>
<td >Amount</td>
<td >Price</td>
<td >VAT</td>
<td >% Discount</td>
<td >Amount</td>
</tr>
</thead>

@%set:caracteres_linea_observaciones=130;%@
<tbody>
@%where:nodb|nodb_order_details;contador|count;%@ 

<!-- @%set:num_detalles=count;%@ -->
<!-- @%db:medir_observaciones{observaciones}%@ -->

<!-- aqui empieza el registro -->

<tr>
@%if:esta_vacio;permitir_selecciones;%@
<td></td>
@%else:%@
<td class="check"><input type="checkbox" name="borrar_articulos[]" value="@%db:idx_detalle%@" /></td>
@%end-if:%@
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>
<td>@%db:cantidad;%@</td>
<td>@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
<td>@%db:porcentaje;%@</td>
<td>
@%if:!esta_vacio;tipo_descuento_fmt;%@
@%db:tipo_descuento_fmt;%@
@%else:%@
@%db:tipo_descuento%@
@%end-if:%@
</td>
<td>@%db:base_imponible;%@ </td>
</tr>
@%if:!esta_vacio;observaciones;id_servicio;%@

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
@%end-if:%@

<!-- aqui termina el registro -->
@%end-where:%@

</tbody>
</table>
@%end-where:%@
 
</fieldset>

