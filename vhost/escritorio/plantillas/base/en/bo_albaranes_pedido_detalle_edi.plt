@%where:tabla|Albaranes;nolink|1;where|Albaranes.id_pedido = $id_pedido;%@

<fieldset id="Albaranes_Pedido_Cabecera" class="fsficha">
<legend>Delivery Conditions</legend>


<table class="full">
<tr>
<td class="etiqueta">Reference:</td>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
<td class="etiqueta">Warehouses:</td>
<td>@%db:Almacenes.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Date:</td>
<td><input type="text" name="registro[fecha]" size="13" value="@%db:colocar_fecha{Albaranes.fecha};%@" maxlength="10" /></td>
<td class="etiqueta">Carrier:</td>
<td>@%db:Transportistas.nombre;%@</td>
</tr>
</table>
</fieldset>

<fieldset id="Albaranes_Pedido_Detalle" class="fsficha">
<legend>Details</legend>
<div class="AccionesFicha"><ul>
<li><a href="#" onclick=window.open('?seccion=bo_albaran_envio_print&id_albaran=@%db:Albaranes.id_albaran%@');  class="envioprint" 
	><img src="images/pixel.png" class="icono" /><span>Print Order</span></a></li>
</ul></div>

<table class="full">
<thead><tr>
<td >Code</td>
<td >Use-by date</td>
<td >Lot</td>
<td >Ordered Amount</td>
<td >Pend. Amount</td>
<td >Amount to send</td>
<td >Price</td>
</tr></thead>
 
<tbody>
@%where:tabla|Detalles_albaran;not_ruta_path|Almacenes,Pedidos,Traspasos_almacen,Transportistas,Provincias,Presupuestos,Catalogo_imagenes;order|Articulos.nombre,Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;contador|num_detalle;%@
 <!-- 
 @%db:Detalles_albaran.id_detalle;%@ @%db:Articulos.id_articulo;%@ @%db:Articulos.id_unidad_medida;%@ 
 @%set:cantp=Lineas_detalle.cantidad;%@ @%set:cants=Lineas_detalle.cantidad_recibida;%@ @%db:Lineas_detalle.cantidad_recibida;%@ 
 -->
<tr>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@ </td>
<td>@%db:Detalles_albaran.lote;%@</td>

<td>@%db:Lineas_detalle.cantidad;%@</td>
<td>@%calc:(cantp - cants);round|3;output|1;fmtas|Lineas_detalle.cantidad;%@</td>
<td>@%db:Detalles_albaran.cantidad;%@</td>

<td>@%db:Lineas_detalle.precio_articulo;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

