@%where:tabla|Albaranes;nolink|1;where|Albaranes.id_pedido = $id_pedido;%@

<fieldset id="Albaranes_Pedido_Cabecera" class="fsficha">
<legend>Condicions de remesa</legend>


<table class="full">
<tr>
<td class="etiqueta">Referčncia:</td>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
<td class="etiqueta">Magatzems:</td>
<td>@%db:Almacenes.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Data:</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td class="etiqueta">Transportistes:</td>
<td>@%db:Transportistas.nombre;%@</td>
</tr>
</table>
</fieldset>

<fieldset id="Albaranes_Pedido_Detalle" class="fsficha">
<legend>Detall</legend>
<div class="barraoscura"><a href="#" onclick="window.open('?seccion=bo_albaran_envio_print&id_albaran=@%db:Albaranes.id_albaran%@'); return false;">Imprimir enviament</a></div>
<table class="full">
<tr>
<td class="caption">Codi</td>
<td class="caption">Data de caducitat</td>
<td class="caption">Lot</td>

<td class="caption">Quantitat demanda</td>
<td class="caption">Quant. Pend.</td>
<td class="caption">Quantitat a Servir</td>

<td class="caption">Preu</td>
 </tr>
 
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


</table>

</fieldset>
