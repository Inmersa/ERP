
@%if:!esta_vacio;__tpv_resultados;%@
@%set:__notespack_locations_var = __tpv_return_status;value|val;%@
@%set:__notespack_locations_reset = 1;%@
@%where:nodb|nodb_notespack_locations;%@
Msg: @%db:msg;%@<br/>
@%end-where:%@

@%else:%@
<table class="full" style="border: 1px solid blue;" id="listado" >
@%where:nodb|nodb_notespack_article_faults;contador|i;%@
<!-- @%set:codigo_barras = Producto.codigo_barras;value|var;%@ -->
<caption>@%db:Producto.nombre;%@ (ID: @%db:Producto.id_articulo;%@)</caption>
<thead><tr><td>{{abr_cantidad_pendiente}}: @%db:Producto.cantidad_pendiente;%@</td></tr></thead>
<tbody>
<script type="text/javascript" >
var1 = "dos";
</script>
@%where:nodb|nodb_notespack_locations;contador|i;%@
<tr ><td>
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >

	<div name="Localizacion" >
	<!-- @%set:idzona = Detalle.id_almacen_logico;value|var;%@ -->
	@%if:!esta_vacio;idzona;%@
		@%where:table|Almacenes_logicos;where|id_almacen_logico = $idzona;nolink|1;%@
			@%db:Almacenes_logicos.nombre;%@
		@%end-where:%@

	@%end-if:%@
        @%db:planta;%@:@%db:pasillo;%@:@%db:columna;%@:@%db:fila;%@
	</div>

	<div name="SKU" >
	<input type="hidden" name="rec[@%db:DetallePedido.id_articulo;%@][@%db:idx;%@][fecha_caducidad]" value="@%db:fecha_caducidad;%@" />
	@%db:fmt_fecha_caducidad;%@ 
	@%if:!esta_vacio;Detalle.lote;%@
	<input type="hidden" name="rec[@%db:DetallePedido.id_articulo;%@][@%db:idx;%@][lote]" value="@%db:lote;%@" />
	* @%db:lote;%@
	@%end-if:%@
	<input type="hidden" name="rec[@%db:DetallePedido.id_articulo;%@][@%db:idx;%@][id_detalle]" 
		value="@%db:Detalle.id_detalle;%@" />
	<!-- iddet: @%db:Detalle.id_detalle;%@ / @%db:Detalle_pedido.id_detalle;%@ -->
	</div>
	<div name="Cantidades" >{{abr_cantidad_pendiente}}: @%db:Detalle.cantidad_pendiente;%@ / @%db:Detalle.cantidad;%@ </div>

</td></tr>
@%end-where:%@

</tbody>
@%end-where:%@

</table>
@%end-if:%@

