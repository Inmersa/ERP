 @%where:nodb|nodb_order_data;contador|count;%@ 
<fieldset id="Pedido_Cliente_Lineas" class="fsficha">
<legend>Details</legend>

<div class="AccionesFicha" ><ul>
@%if:esta_vacio;id_proveedor;%@
<li><a href="?seccion=hacer_pedido" class="editar" ><img src="images/pixel.png" class="icono" /><span>Add article</span></a></li>
@%else:%@
<li><a href="?seccion=hacer_pedido_compra" class="editar" ><img src="images/pixel.png" class="icono" /><span>Add article</span></a></li>
@%end-if:%@
</ul></div>

<table class="full">
<tr>
<td></td>
<td class="caption">Code</td>
<td class="caption">Amount</td>
<td class="caption">Price</td>
<td class="caption">VAT</td>
<td class="caption">% Discount</td>
<td class="caption">Amount</td>
 </tr>
@%where:nodb|nodb_order_details;contador|count;format_name|classDocumentDetail;%@ 
<!-- aqui empieza el registro -->

<tr><td class="check"><input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="1" checked></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>
<td>@%db:cantidad;%@</td>
<td>@%db:precio%@ 
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
<td>@%db:porcentaje;%@</td>
<td>
@%if:!esta_vacio;tipo_descuento_fmt;%@
 @%db:tipo_descuento_fmt%@
@%else:%@
 @%db:tipo_descuento%@
@%end-if:%@
</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<td 
@%if:esta_vacio;available_contracts;%@
colspan="7"
@%else:%@
colspan="4"
@%end-if:%@
><input type="text" name="observaciones[@%db:idx_detalle;%@]" class="insertext" size="85" value="@%db:observaciones%@"></td>
@%if:esta_vacio;available_contracts;%@
@%else:%@
 <td colspan="3">

@%set:_selected_value=id_servicio;value|var;%@
<select name="servicios[@%db:idx_detalle;%@]">
<option value="0">None</option>
    @%where:nodb|nodb_detail_contracts;%@
	<option value="@%db:id;%@" @%db:selected_value{id}%@ 
	>@%db:nombre;%@</option>
    @%end-where:%@

	</select>
 @%end-if:%@
 </td>
 </tr>
@%else:%@
@%end-if:%@

<!-- aqui termina el registro -->
@%end-where:%@

</table>
</fieldset>
