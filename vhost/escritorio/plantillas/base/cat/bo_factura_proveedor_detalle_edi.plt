@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail%@

<fieldset id="Factura_Proveedor_Detalle" class="fsficha">
<legend>Detall</legend>

<div class="AccionesFicha"><ul>
@%if:emitida%@
	@%if:esta_vacio;factura_abono;%@
	<li class="noicon" >Nova</li>
	<li class="noicon" ><input type="radio" name="id_factura_abono" value="0" checked="checked" /></li>
	<li><a href="#" onClick="return sendForm('factura','accion_ejecutar','AbonarFactura','hacer_pedido_compra&factura=1&abono=1&nuevo=1');" class="abonofactura" 
		><img src="images/pixel.png" class="icono" /><span>Abonar Factura</span></a></li> 
	@%set:listar_abonos = 1;%@
	@%end-if:%@
@%else:%@
	<li><a href="?seccion=hacer_pedido_compra" class="editar" ><img src="images/pixel.png" class="icono" /><span>Modificar detall de comanda</span></a></li> 
	<li><a href="#" onclick="return onHRefClick('factura','accion_ejecutar','Borrar');" class="borrar" 
		><img src="images/pixel.png" class="icono" /><span>Esborrar(s)</span></a></li>
@%end-if:%@
</ul></div>

<table class="full"><thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="eturn formCheckAll('borrar_articulos');"  /></td>
<td >Codi</td>
<td >Quantitat</td>
<td >Preu</td>
<td >IVA</td>
<td >% Desc.</td>
<td >Import</td>
</tr></thead>

<tbody>
@%set:caracteres_linea_observaciones=130;%@
@%where:nodb|nodb_order_details;contador|count;%@
 <!-- @%set:num_detalles=count;%@ @%db:medir_observaciones{observaciones}%@ -->

<tr><td class="check"><input type="checkbox" name="borrar_articulos[@%db:idx_detalle;%@]" value="1" /></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:id_articulo;%@">@%db:nombre%@</a></td>

<td>@%db:cantidad;%@</td>
<td>@%db:precio;%@</td>
<td>@%db:porcentaje;%@</td>
<td>@%db:tipo_descuento%@</td>
<td>@%db:base_imponible;%@</td>

@%if:esta_vacio;observaciones;id_servicio;%@
@%else:%@
<tr>
<td colspan="5">@%db:observaciones%@</td>
<td colspan="2">
@%if:esta_vacio;id_servicio;%@
@%else:%@
Esborrar Tots
<input type="checkbox" name="borrar_servicios[@%db:idx_detalle;%@]" value="1" />
<!-- @%set:ids=id_servicio;%@ -->
@%where:nodb|nodb_detail_contracts;%@
@%if:equals;ids;id;%@
@%db:nombre;%@
@%end-if:%@
@%end-where:%@
 
</td></tr>
@%end-if:%@
@%end-if:%@
 @%end-where:%@

</tbody></table>
</fieldset>
