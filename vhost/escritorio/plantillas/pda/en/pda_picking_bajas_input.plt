

<table class="full" id="Leyenda" name="Leyenda" >
<thead><tr>
</tr></thead>
<tbody>
<tr ><td>1</td><td>Entrada de datos</td></tr>
<tr ><td>0</td><td>Enviar Baja</td></tr>
</tbody></table>

<form name="directo_codigobarras" method="post" action="?seccion=pkg_bajas_cbarras" id="frm_baja" >
<input type="hidden" name="NO__iface_followup" value="pkg_bajas_cbarras" />
<input type="hidden" name="accion" value="CausarBaja" />

<input type="hidden" name="__iface_key_0" value="pkg_bajas_cbarras" />

<table class="full" style="border: 1px solid blue;" id="listado" name="Lista" >

@%where:nodb|nodb_notespack_locations;contador|i;%@
<!-- @%set:id_art = id_articulo;value|var;%@ -->
@%where:tabla|Articulos;where|Articulos.id_articulo = $id_art;%@
<caption>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)<br>[@%db:Marcas.nombre;%@]</caption>
<thead>
<!-- tr><td>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)</td></tr>
<tr><td>@%db:Marcas.nombre;%@</td></tr -->
</thead>
<tbody>
@%end-where:%@

<tr ><td>
	<div id="DivLocation_@%db:i;%@" name="DetalleAlbaran" >

	<div name="Localizacion" >
	@%if:!esta_vacio;id_almacen_logico;%@
		<!-- @%set:id_zona = id_almacen_logico;value|var;%@ -->
		@%where:tabla|Almacenes_logicos;where|id_almacen_logico = $id_zona;%@
		@%db:Almacenes_logicos.nombre;%@ 
		@%end-where:%@

	@%end-if;%@
	- @%db:planta;%@:@%db:pasillo;%@:@%db:columna;%@:@%db:fila;%@
	<input type="hidden" name="baja[id_almacen_logico]" value="@%db:id_almacen_logico;%@" />
	<input type="hidden" name="baja[planta]" value="@%db:planta;%@" />
	<input type="hidden" name="baja[pasillo]" value="@%db:pasillo;%@" />
	<input type="hidden" name="baja[columna]" value="@%db:columna;%@" />
	<input type="hidden" name="baja[fila]" value="@%db:fila;%@" />
	<input type="hidden" name="baja[id_articulo]" value="@%db:id_articulo;%@" />
	</div>

	<div name="SKU" >
	<input type="hidden" name="baja[fecha_caducidad]" value="@%db:fecha_caducidad;%@" />
	<input type="hidden" name="baja[lote]" value="@%db:lote;%@" />
	@%db:Localizacion_articulos.fecha_caducidad;fmtas|Detalles_albaran.fecha_caducidad;%@
	@%if:!esta_vacio;lote;%@
	* @%db:lote;%@
	@%end-if:%@
	</div>

	<div name="Cantidades" >
	<input type="hidden" name="baja[cantidad]" value="@%db:cantidad;%@" />
	{{fld_cantidad}}: @%db:cantidad;%@ <br/>
	<select name="baja[id_baja_almacen]" tabindex="0" >
	@%where:nolink|1;tabla|Bajas_almacen;%@
	<option value="@%db:Bajas_almacen.id_baja_almacen;%@" >@%db:Bajas_almacen.nombre;%@</option>
	@%end-where:%@

	</select><br>
	<textarea name="baja[descripcion]" tabindex="1" rows="3" cols="25" ></textarea>
	</div>

</td></tr>

@%end-where:%@

</tbody>
</table>
</form>

<script type="text/javascript" >
oSW = new TableSwitcher($('Leyenda'));
oM = new Menu($('frm_baja'));
TableBrowser.prototype.form_id = "frm_baja";
oTable1 = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':SKU_Selection});
oSW.add(oTable1,"NUM_1");
oSW.registerDefaultKeyHandler(oM.keyPress.bind(oM));
oSW.activate(0);
oKb = new KeyboardDriver(document);
oKb.register("all",oSW.keyPress.bind(oSW));
</script>
