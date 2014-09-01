
<form name="directo_codigobarras" method="post" action="?seccion=@%get:__inventario_sendto;%@" id="frm_inventario" >
<input type="hidden" name="__iface_followup" value="@%get:__inventario_sendto;%@" />
sndTo: @%get:__inventario_sendto;%@
<input type="hidden" name="accion" value="SeleccionarLocalizacion" />
<table class="full" style="border: 1px solid blue;" id="listado" >

@%where:tabla|Localizacion_articulos;where|Articulos.codigo_barras='$codigo_barras' OR Articulos.codigo_barras_bulto='$codigo_barras' OR Articulos.codigo_barras_palet='$codigo_barras';contador|i;%@
<!-- @%db:Localizacion_articulos.id_articulo;%@ -->
@%if:equals;i;1;%@
<caption>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)<br>[@%db:Marcas.nombre;%@]</caption>
<thead>
<!-- tr><td>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)</td></tr>
<tr><td>@%db:Marcas.nombre;%@</td></tr -->
</thead>
<tbody>
@%end-if:%@

<tr ><td>
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >

	<div name="Localizacion" >
	@%db:Almacenes_logicos.nombre;%@ - 
	@%db:Localizacion_articulos.planta;%@:@%db:Localizacion_articulos.pasillo;%@:@%db:Localizacion_articulos.columna;%@:@%db:Localizacion_articulos.fila;%@
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][id_almacen_logico]" value="@%db:Localizacion_articulos.id_almacen_logico;%@" />
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][planta]" value="@%db:Localizacion_articulos.planta;%@" />
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][pasillo]" value="@%db:Localizacion_articulos.pasillo;%@" />
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][columna]" value="@%db:Localizacion_articulos.columna;%@" />
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][fila]" value="@%db:Localizacion_articulos.fila;%@" />
	</div>

	<div name="SKU" >
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][fecha_caducidad]" value="@%db:Localizacion_articulos.fecha_caducidad;%@" />
	<input type="hidden" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][lote]" value="@%db:Localizacion_articulos.lote;%@" />
	@%db:Localizacion_articulos.fecha_caducidad;fmtas|Detalles_albaran.fecha_caducidad;%@
	@%if:!esta_vacio;Localizacion_articulos.lote;%@
	* @%db:Localizacion_articulos.lote;%@
	@%end-if:%@
	</div>

	<div name="Cantidades" >{{fld_stock}}: @%db:Localizacion_articulos.cantidad;%@  
	<input type="text" class="cantidad" name="localizacion_articulos[@%db:Localizacion_articulos.id_articulo;%@][@%db:i;%@][cantidad]" 
		value="@%get:invent_cbarras_cantidad;%@" tabindex="" /></div>
	</div>
</td></tr>
@%end-where:%@

</tbody>
</table>
</form>

<script type="text/javascript" >
TableBrowser.prototype.form_id = "frm_inventario";
oTable1 = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':SKU_Selection});
oKb = new KeyboardDriver(document);
oKb.register("all",oTable1.keyPress.bind(oTable1));
oTable1.activate();
</script>
