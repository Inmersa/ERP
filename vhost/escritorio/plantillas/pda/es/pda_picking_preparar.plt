
<table class="full" id="Leyenda" name="Leyenda" >
<thead><tr>
</tr></thead>
<tbody>
<tr ><td>1</td><td>Entrada Codigo de barras </td></tr>
<tr ><td>2</td><td>Guia de preparacion</td></tr>
<tr ><td>3</td><td>Menu Principal</td></tr>
<tr ><td>4</td><td>Revisar Albaran</td></tr>
<tr ><td>5</td><td>Confirmar Albaran</td></tr>
<tr ><td>6</td><td>Modo Ajax</td></tr>
<tr ><td>0</td><td>Enviar Modificaciones</td></tr>
</tbody></table>

<form name="directo_codigobarras" method="post" action="?seccion=pkg_tpv" id="frm_cbarras" >
<input type="hidden" name="accion" value="SeleccionarCBarras" />
<input type="hidden" name="tpvopt_return_section" value="pkg_preparar" />
<input type="hidden" name="tpvopt_addnew" value="0" />
<table class="full" style="border: 1px solid blue;" id="directo_codigo" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<tr ><td>
	<div id="DivLocation_CB" name="DetalleAlbaran" >
	<span>Code-barres</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasDirecto" name="CodigoBarras" value="" class="codigobarras" /></div>
	</div>
</td></tr>

</tbody></table>
</form>

<form name="albaranes_list" method="post" action="?seccion=pkg_preparar" id="frm_preparar" >
<input type="hidden" name="accion" value="Confirmar" />
<input type="hidden" name="__iface_followup" value="pkg_revisar_venta" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Revisar" />

<input type="hidden" name="__iface_key_0" value="pkg_preparar" />
<input type="hidden" name="__iface_key_0_setvar" value="accion" />
<input type="hidden" name="__iface_key_0_setval" value="Confirmar" />
<input type="hidden" name="__iface_key_3" value="pkg_inicio" />
<input type="hidden" name="__iface_key_3_setvar" value="accion" />
<input type="hidden" name="__iface_key_3_setval" value="none" />
<input type="hidden" name="__iface_key_4" value="pkg_revisar_venta" />
<input type="hidden" name="__iface_key_4_setvar" value="accion" />
<input type="hidden" name="__iface_key_4_setval" value="Revisar" />
<input type="hidden" name="__iface_key_5" value="pkg_inicio" />
<input type="hidden" name="__iface_key_5_setvar" value="accion" />
<input type="hidden" name="__iface_key_5_setval" value="Confirmar" />
<input type="hidden" name="__iface_key_6" value="pkg_albaran_ajax" />

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
	<!-- @%set:_selected_value=Detalle.id_almacen_logico;value|var;%@ -->
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
//Creamos los 2 formularios/contenedores 
oTabla1 = new TableBrowser($('directo_codigo'),{tagname:'DIV', name:'DetalleAlbaran'});
oTabla1.focus = function () {
	this.domTable.className = this.cssContentVisible;
	$('barrasDirecto').focus();
}
TableBrowser.prototype.form_id = "frm_preparar";
oTabla2 = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':TBItem_Location});
// Creamos el switcher entre form/tabla(s) 
oSW = new TableSwitcher($('Leyenda'));
// Registrando, en el nivel superior, las teclas que activan los Formularios/Tablas completos.
oSW.add(oTabla1,"NUM_1");
oSW.add(oTabla2,"NUM_2");
// Registrando un gestor de teclado, para el resto de teclas.
oM = new Menu($('frm_preparar'));
oSW.registerDefaultKeyHandler(oM.keyPress.bind(oM));
// Estado inicial
oSW.deactivate(0);
oSW.activate(1);
//Enganchando el teclado con el gestor global
oKb = new KeyboardDriver(document);
//oKb.register("all",oSW,oSW.keyPress);
oKb.register("all",oSW.keyPress.bind(oSW));
</script>

