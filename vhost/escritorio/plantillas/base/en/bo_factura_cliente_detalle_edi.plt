@%where:nodb|nodb_order_data;nombre|detalles;format_name|classDocumentDetail;%@

<fieldset id="Factura_Cliente_Detalle" class="fsficha">
<legend>Details</legend>

<div class="AccionesFicha"><ul>
@%if:emitida%@
	@%if:esta_vacio;factura_abono;%@
	<li class="noicon" >New</li>
	<li class="noicon" ><input type="radio" name="id_factura_abono" value="0" checked="checked" /></li>
	<li><a href="#" onClick="return sendForm('factura','accion_ejecutar','AbonarFactura','hacer_pedido&factura=1&abono=1&nuevo=1');" class="abonofactura" 
		><img src="images/pixel.png" class="icono" /><span>Pay Invoice</span></a></li> 
	@%set:listar_abonos = 1;%@
	@%end-if:%@
@%else:%@
	@%if:esta_vacio;factura_abono;%@
	@%if:AllowedAction;Facturas_detalle;edit;%@
	<li><a href="?seccion=hacer_pedido" class="editar" 
		><img src="images/pixel.png" class="icono" /><span>Modify Invoice Details</span></a></li> 
	@%end-if:%@
	@%end-if:%@
	@%if:AllowedAction;Facturas_detalle;del;%@
	<li><a href="#" onclick="return onHRefClick('factura','accion_ejecutar','Borrar');" class="borrar" 
		><img src="images/pixel.png" class="icono" /><span>Delete(s)</span></a></li>
	@%end-if:%@

@%end-if:%@
</ul></div>

@%if:!esta_vacio;listar_abonos;%@

@%if:esta_vacio;id_proveedor;%@
@%set:id_proveedor=0;%@
@%end-if:%@
@%if:esta_vacio;id_cliente;%@
@%set:id_cliente=0;%@
@%end-if:%@

<table class="full" ><tr>
<!-- @%set:_inm_count_times=4;%@ @%set:_reset_listados = 1;%@ -->
@%where:tabla|Facturas;where|Facturas.factura_abono != 0 AND IF( $id_cliente , Facturas.id_cliente = $id_cliente ,1) AND IF( $id_proveedor , Facturas.id_proveedor = $id_proveedor ,1) AND Facturas.estado = 0;%@
<!-- @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
<td class="check" ><input type="radio" name="id_factura_abono" value="@%db:Facturas.id_factura;%@" /></td>
<td class="etiquetacheck" >
@%if:!esta_vacio;Facturas.id_cliente;%@
	<a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
@%else:%@
	<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a>
@%end-if:%@

[@%db:colocar_fecha{Facturas.fecha};%@] 
@%db:Facturas.base_imponible;%@ </td>
@%if:inm_count;%@
</tr><tr>
@%end-if:%@
@%end-where:%@

</tr></table>
@%end-if:%@

<table class="full">
<thead>
<tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('borrar_articulos');"  /></td>
<td >Code</td>
<td >Amount</td>
<td >Price</td>
<td >VAT</td>
<td >%Discount</td>
<td >Amount</td>
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

<tr><td class="check"><input type="checkbox" name="borrar_articulos[@%db:idx_detalle;%@]" value="1" /></td>
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
<td>@%db:tipo_descuento%@</td>
<td>@%db:base_imponible;%@ </td>
</tr>
@%if:!esta_vacio;observaciones;id_servicio;%@
<tr><td colspan="4">@%db:observaciones%@</td>

 @%if:esta_vacio;id_servicio;%@
 <td colspan="4" ></td>
 @%else:%@
 
<td class="etiqueta" >Delete All</td>
<td class="check"><input type="checkbox" name="borrar_servicios[@%db:idx_detalle;%@]" value="1" /></td>
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

</tbody></table>
</fieldset>

