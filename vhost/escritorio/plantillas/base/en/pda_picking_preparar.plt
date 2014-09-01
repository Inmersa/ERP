
<form name="albaranes_list" method="post" action="?seccion=pkg_preparar" id="frm_preparar" >
<input type="hidden" name="accion" value="Confirmar" />
<input type="hidden" name="__iface_followup" value="pkg_revisar_venta" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Revisar" />

<table class="full" style="border: 1px solid blue;" id="listado" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>
@%where:nodb|nodb_notespack_locations;contador|i;%@
<tr ><td>
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >
	<span>@%db:Producto.nombre;%@ (ID: @%db:Producto.id_articulo;%@)</span>

	<div name="CodigoBarras" class="oculto" ><input type="hidden" name="codigoBarras[@%db:idx;%@]" value="@%db:Producto.codigo_barras;%@" 
	class="codigobarras" /><input type="text" name="comprobacionBarras[@%db:idx;%@]" value="" class="codigobarras"
	/>@%db:Producto.codigo_barras;%@</div>

	<div name="Localizacion" >
	<!-- @%set:_selected_value=Zona.id_almacen_logico;value|var;%@ -->
	<select name="rec[@%db:idx_albaran;%@][@%db:idx;%@][id_almacen_logico]" tabindex="" class="zona" >
	@%where:table|Almacenes_logicos;nolink|1;%@
	<option value="@%db:Almacenes_logicos.id_almacen_logico;%@" 
		@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
		>@%db:Almacenes_logicos.nombre;%@</option>
	@%end-where:%@

	</select><br/>

	<input type="text" class="planta" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][planta]" value="@%db:Detalle.planta;%@" tabindex="" />:
	<input type="text" class="pasillo" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][pasillo]" value="@%db:Detalle.pasillo;%@" tabindex="" />:
	<input type="text" class="columna" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][columna]" value="@%db:Detalle.columna;%@" tabindex="" />:
	<input type="text" class="fila" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fila]" value="@%db:Detalle.fila;%@" tabindex="" />
	</div>

	<div name="SKU" >
	<input type="text" class="dia" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][dia]" value="@%db:fmt_fecha_caducidad_dia;%@" /> /
	<input type="text" class="mes" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][mes]" value="@%db:fmt_fecha_caducidad_mes;%@"  /> /
	<input type="text" class="anyo" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][fecha_caducidad][ano]" value="@%db:fmt_fecha_caducidad_ano;%@"  /> *
	<input type="text" class="lote" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][lote]" value="@%db:Detalle.lote;%@"  />
	@%db:idx;%@ - @%db:Detalle.id_detalle;%@
	</div>

	<div name="Cantidades" id="DivLocation_cnt_@%db:i;%@" 
		><input type="text" class="cantidad" name="rec[@%db:idx_albaran;%@][@%db:idx;%@][cantidad]" value="" tabindex="" /> 
	{{abr_cantidad_pendiente}}: @%db:Detalle.cantidad_pendiente;%@ {{abr_cantidad_pedida}}: @%db:DetallePedido.cantidad;%@
	</div>

	</div>
</td></tr>
@%end-where:%@

</tbody></table>
</form>

<script type="text/javascript" >
new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':TBItem_Location});
</script>

