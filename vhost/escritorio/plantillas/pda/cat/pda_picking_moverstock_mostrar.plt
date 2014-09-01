
<form name="albaranes_list" method="post" action="?seccion=pkg_moverstock" id="frm_preparar" >
<input type="hidden" name="accion" value="Seleccionar" />

<table class="full" style="border: 1px solid blue;" id="listado" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<input type="hidden" name="__iface_followup" value="pkg_moverstock" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="NoEncontrado" />

@%where:tabla|Localizacion_articulos;where|1 AND $where_localizacion;contador|i;order|Marcas.nombre,Articulos.nombre,Localizacion_articulos.fecha desc;%@
<tr ><td>
	<input type="hidden" name="rec[@%db:i;%@][id_almacen_logico]" value="@%db:Localizacion_articulos.id_almacen_logico;%@" />
	<input type="hidden" name="rec[@%db:i;%@][id_articulo]" value="@%db:Localizacion_articulos.id_articulo;%@" />
	<input type="hidden" name="rec[@%db:i;%@][planta]" value="@%db:Localizacion_articulos.planta;%@" />
	<input type="hidden" name="rec[@%db:i;%@][pasillo]" value="@%db:Localizacion_articulos.pasillo;%@" />
	<input type="hidden" name="rec[@%db:i;%@][columna]" value="@%db:Localizacion_articulos.columna;%@" />
	<input type="hidden" name="rec[@%db:i;%@][fila]" value="@%db:Localizacion_articulos.fila;%@" />
	<input type="hidden" name="rec[@%db:i;%@][fecha_caducidad]" value="@%db:Localizacion_articulos.fecha_caducidad;%@" />
	<input type="hidden" name="rec[@%db:i;%@][lote]" value="@%db:Localizacion_articulos.lote;%@" />
	<input type="hidden" name="rec[@%db:i;%@][nombre_articulo]" value="@%db:Articulos.nombre;%@" />
	<input type="hidden" name="rec[@%db:i;%@][nombre_marca]" value="@%db:Marcas.nombre;%@" />
	<input type="hidden" name="rec[@%db:i;%@][nombre_zona]" value="@%db:Almacenes_logicos.nombre;%@" />
	<input type="hidden" name="rec[@%db:i;%@][codigo_barras]" value="@%db:Articulos.codigo_barras;%@" />
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >
	<span>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@) [@%db:Marcas.nombre;%@]</span>

	<div name="CodigoBarras" class="oculto" ><input type="hidden" name="codigoBarras[@%db:i;%@]" 
	value="@%db:Articulos.codigo_barras;%@" class="codigobarras" /><input type="text" name="comprobacionBarras[@%db:i;%@]" 
	value="" class="codigobarras" />@%db:Articulos.codigo_barras;%@</div>

	<div name="SKU" >
	@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@ 
	@%if:!esta_vacio;Localizacion_articulos.lote;%@
	* @%db:Localizacion_articulos.lote;%@ 
	@%end-if:%@
	</div>

	<div name="Cantidades" id="DivLocation_cnt_@%db:i;%@" 
		><input type="text" class="cantidad" name="rec[@%db:i;%@][cantidad]" value="" tabindex="" 
		/>Quantitat: @%db:Localizacion_articulos.cantidad;%@</div>

	</div>
</td></tr>
@%end-where:%@

</tbody></table>
</form>

<script type="text/javascript" >
oT = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':TBItem_Location});
oKb = new KeyboardDriver(document);
oKb.register("all",oT.keyPress.bind(oT));
</script>

