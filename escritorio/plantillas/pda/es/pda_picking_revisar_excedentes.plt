
<!-- @%set:__notespack_locations_var=__pack_excedentes;value|val;%@ -->
<input type="hidden" name="accion" value="ConfirmarExcedentes" />

<table class="full" style="border: 1px solid blue;" id="listado" >
<caption>{{frame_picking_revisarexcedentes}}</caption>
<thead><tr><td>{{frame_confirmar_cantidades_excedentes}}</td></tr></thead>
<tbody>
@%where:nodb|nodb_notespack_locations;contador|i;%@
<input type="hidden" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][planta]" value="@%db:Detalle.planta;%@" tabindex="" />
<input type="hidden" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][pasillo]" value="@%db:Detalle.pasillo;%@" tabindex="" />
<input type="hidden" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][columna]" value="@%db:Detalle.columna;%@" tabindex="" />
<input type="hidden" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fila]" value="@%db:Detalle.fila;%@" tabindex="" />
<input type="hidden" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][id_almacen_logico]" value="@%db:Zona.id_almacen_logico;%@" >
<tr ><td>
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >
	<span>@%db:Producto.nombre;%@ (ID: @%db:Producto.id_articulo;%@)</span>
	<div name="CodigoBarras" class="oculto" ><input type="hidden" name="codigoBarras[@%db:idx;%@]" value="@%db:Producto.codigo_barras;%@" 
	class="codigobarras" /><input type="text" name="comprobacionBarras[@%db:idx;%@]" value="" class="codigobarras"
	/>@%db:Producto.codigo_barras;%@</div>

	<div name="Localizacion" >
	<!-- @%set:idzona = Detalle.id_almacen_logico;value|var;%@ -->
	@%where:table|Almacenes_logicos;where|id_almacen_logico = $idzona;nolink|1;%@
		@%db:Almacenes_logicos.nombre;%@
	@%end-where:%@

        @%db:Detalle.planta;%@:@%db:Detalle.pasillo;%@:@%db:Detalle.columna;%@:@%db:Detalle.fila;%@
	</div>

	<div name="SKU" >
	<input type="text" class="dia" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][dia]" value="@%db:Detalle.fmt_fecha_caducidad_dia;%@" /> /
	<input type="text" class="mes" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][mes]" value="@%db:Detalle.fmt_fecha_caducidad_mes;%@"  /> /
	<input type="text" class="anyo" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][ano]" value="@%db:Detalle.fmt_fecha_caducidad_ano;%@"  /> *
	<input type="text" class="lote" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][lote]" value="@%db:Detalle.lote;%@"  />
	@%db:Detalle.id_detalle;%@
	</div>

	<div name="Cantidades" >
	<input type="text" class="cantidad" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][cantidad]" value="@%db:Detalle.cantidad;%@" tabindex="" /> 
	{{abr_cantidad_prevista}}: @%db:Detalle.stock_previsto;%@
	</div>

	</div>
</td></tr>
@%end-where:%@

</tbody></table>

