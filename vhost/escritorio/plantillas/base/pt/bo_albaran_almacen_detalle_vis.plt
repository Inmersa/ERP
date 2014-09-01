<fieldset id="Albaran_Almacen_Detalle" class="fsficha">
<legend>Descri��o</legend>

<table class="full">
<thead>
<tr>
<td >C�digo</td>
<td >Data de Validade de Lote</td>
<td >Localiza��o</td>
<td >Quantidade Encomendada</td>
<td >Quantidade Recebida </td>
<td >Quantidade a emitir</td>
<td >Devolu��o</td>
</tr>
</thead>

<tbody>
@%where:tabla|Detalles_albaran;nolink|1;where|Detalles_albaran.id_albaran = $id_albaran;order||Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;contador|i;%@ 
 <!-- aqui empieza el registro -->
 <!--@%db:Albaranes.preparado;%@-->
<tr>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre%@</a></td>
<td> @%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@
@%if:!esta_vacio;Detalles_albaran.lote;%@
@%db:Detalles_albaran.lote;%@
@%end-if:%@
</td>
<td>@%db:Almacenes_logicos.nombre;%@ @%db:Detalles_albaran.planta;%@ @%db:Detalles_albaran.pasillo;%@ @%db:Detalles_albaran.fila;%@ @%db:Detalles_albaran.columna;%@</td>
<td>@%db:Lineas_detalle.cantidad;%@</td>
<td>@%db:Lineas_detalle.cantidad_recibida;%@</td>
<td>@%db:Detalles_albaran.cantidad;%@</td>
<td>@%db:Detalles_albaran.cantidad_devuelta;%@</td>
</tr>
@%if:!esta_vacio;Detalles_albaran.observaciones;%@
<tr><td colspan="6" class="etiqueta">@%db:reemplazar_salto{Detalles_albaran.observaciones};%@</td></tr>
@%end-if:%@
@%end-where:%@

</tbody>
</table>
<div class="barraoscurai">Legenda: P- Preparada E- Emitida C- Confirmada D- Devolvida</div>
</fieldset>

