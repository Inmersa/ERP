
{{frame_picking_revisarfaltas}}
<input type="hidden" name="accion" value="ConfirmarFaltas" />

<table class="full" style="border: 1px solid blue;" id="listado" >
@%where:nodb|nodb_notespack_article_faults;contador|i;%@
<caption>@%db:Producto.nombre;%@ (ID: @%db:Producto.id_articulo;%@)</caption>
<!-- @%set:codigo_barras = Producto.codigo_barras;value|var;%@ -->

<thead><tr><td>
@%where:nodb|nodb_notespack_locations;contador|i;%@
	<table class="location" >
	<tbody>
	<tr><td>
	<input type="hidden" name="indice[@%db:id_articulo;%@][@%db:idx_albaran;%@][@%db:idx;%@]" value="@%db:Detalle.cantidad_pendiente;%@" /> 
	<!-- @%set:idzona = Zona.id_almacen_logico;value|var;%@ -->
	@%where:table|Almacenes_logicos;where|id_almacen_logico = $idzona;nolink|1;%@
		@%db:Almacenes_logicos.nombre;%@
	@%end-where:%@

        @%db:Detalle.planta;%@:@%db:Detalle.pasillo;%@:@%db:Detalle.columna;%@:@%db:Detalle.fila;%@
	</td></tr>

	<tr><td>
	@%db:Detalle.fmt_fecha_caducidad;%@ 
	@%if:!esta_vacio;Detalle.lote;%@
	* @%db:Detalle.lote;%@ 
	@%end-if:%@
	{{abr_cantidad_pendiente}}: @%db:Detalle.cantidad_pendiente;%@ 
	</td></tr>
	</tbody></table>
@%end-where:%@

</td></tr></thead>
<!-- 
@%set:__notespack_locations_var=__pack_otherlocations;value|val;%@ 
@%set:__notespack_locations_reset=1;%@ -->
<tbody>
@%where:nodb|nodb_notespack_locations;contador|i;%@
<tr ><td>

	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >
	<div name="CodigoBarras" class="oculto" ><input type="hidden" name="codigoBarras[@%db:idx;%@]" value="@%get:codigo_barras;%@" 
	class="codigobarras" /><input type="text" name="comprobacionBarras[@%db:idx;%@]" value="" class="codigobarras"
	/>@%get:codigo_barras;%@</div>

	<div name="Localizacion" >
	<!-- @%set:idzona = Zona.id_almacen_logico;value|var;%@ -->
	@%where:table|Almacenes_logicos;where|id_almacen_logico = $idzona;nolink|1;%@
		@%db:Almacenes_logicos.nombre;%@
	@%end-where:%@

        @%db:planta;%@:@%db:pasillo;%@:@%db:columna;%@:@%db:fila;%@
	</div>

	<div name="SKU" >
	<input type="text" class="dia" name="rec[@%db:id_articulo;%@][@%db:i;%@][fecha_caducidad][dia]" value="@%db:fmt_fecha_caducidad_dia;%@" /> /
	<input type="text" class="mes" name="rec[@%db:id_articulo;%@][@%db:i;%@][fecha_caducidad][mes]" value="@%db:fmt_fecha_caducidad_mes;%@"  /> /
	<input type="text" class="anyo" name="rec[@%db:id_articulo;%@][@%db:i;%@][fecha_caducidad][ano]" value="@%db:fmt_fecha_caducidad_ano;%@"  /> 
	@%if:!esta_vacio;Detalle.lote;%@
	* <input type="text" class="lote" name="rec[@%db:id_articulo;%@][@%db:i;%@][lote]" value="@%db:lote;%@"  />
	@%end-if:%@
	</div>

	<div name="Cantidades" >
	{{fld_stock}}: @%db:cantidad;%@ 
	<input type="text" class="cantidad" name="rec[@%db:id_articulo;%@][@%db:i;%@][cantidad]" value="" tabindex="" /> 
	</div>

</td></tr>
@%end-where:%@

</tbody>
@%end-where:%@

</table>
</form>

