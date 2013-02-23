
<form name="albaranes_list" method="post" action="?seccion=pkg_moverstock_confirmado" >
<input type="hidden" name="accion" value="Confirmar" />

@%where:nodb|elementos_fallidos;%@
@%db:msg;%@<br/>
@%end-where:%@

<table class="full" style="border: 1px solid blue;" id="listado" >
<thead><tr>
</tr></thead>

<tbody><tr ><td>

<div id="DivLocation_DE" name="BuscarLocalizacion" >
<span>MOVER DESDE:</span><br/>
<div name="Localizacion" >

<input type="hidden" name="__target" value="pkg_moverstock_mostrar" />
<input type="hidden" name="__target_setvar" value="accion" />
<input type="hidden" name="__target_setval" value="Revisar" />

<div name="CBarras_localizacion" class="oculto" id="CodBarras_"
><input type="text" name="comprobacionBarras[]" value="" class="codigobarras" /></div>

<!-- @%set:_selected_value=Zona.id_almacen_logico;value|var;%@ -->
<select name="rec[id_almacen_logico]" tabindex="" class="zona" >
@%where:table|Almacenes_logicos;nolink|1;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@" 
	@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
	>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@

</select><br/>

<input type="text" class="planta" name="rec[planta]" value="" tabindex="" />:
<input type="text" class="pasillo" name="rec[pasillo]" value="" tabindex="" />:
<input type="text" class="columna" name="rec[columna]" value="" tabindex="" />:
<input type="text" class="fila" name="rec[fila]" value="" tabindex="" />
</div>
</div>


</td></tr>
<!-- tr><td>

<div id="DivLocation_PARA" name="BuscarLocalizacion" >
<div name="Localizacion" >
<span>LLEVAR HASTA</span><br/>

<input type="hidden" name="__target" value="pkg_moverstock_confirmado" />
<input type="hidden" name="__target_setvar" value="accion" />
<input type="hidden" name="__target_setval" value="Confirmar" />
<input type="hidden" name="__target_confirm" value="Esta Ud Seguro de que desea mover este Stock?" />

<div name="CBarras_localizacion" class="oculto" id="CodBarras_X"
><input type="text" name="comprobacionBarras[]" value="" class="codigobarras" /></div>

<!-- @%set:_selected_value=Zona.id_almacen_logico;value|var;%@ -- >
<select name="dst[id_almacen_logico]" tabindex="" class="zona" >
@%where:table|Almacenes_logicos;nolink|1;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@" 
	@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
	>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@

</select><br/>

<input type="text" class="planta" name="dst[planta]" value="" tabindex="" />:
<input type="text" class="pasillo" name="dst[pasillo]" value="" tabindex="" />:
<input type="text" class="columna" name="dst[columna]" value="" tabindex="" />:
<input type="text" class="fila" name="dst[fila]" value="" tabindex="" />
</div>

</div>

</td></tr -->

@%where:nodb|nodb_notespack_locations;contador|i;%@
<tr ><td>
	<input type="hidden" name="from[@%db:i;%@][id_almacen_logico]" value="@%db:id_almacen_logico;%@" />
	<input type="hidden" name="from[@%db:i;%@][id_articulo]" value="@%db:id_articulo;%@" />
	<input type="hidden" name="from[@%db:i;%@][planta]" value="@%db:planta;%@" />
	<input type="hidden" name="from[@%db:i;%@][pasillo]" value="@%db:pasillo;%@" />
	<input type="hidden" name="from[@%db:i;%@][columna]" value="@%db:columna;%@" />
	<input type="hidden" name="from[@%db:i;%@][fila]" value="@%db:fila;%@" />
	<input type="hidden" name="from[@%db:i;%@][fecha_caducidad]" value="@%db:fecha_caducidad;%@" />
	<input type="hidden" name="from[@%db:i;%@][lote]" value="@%db:lote;%@" />
	<input type="hidden" name="from[@%db:i;%@][cantidad]" value="@%db:cantidad;%@" />
	<input type="hidden" name="from[@%db:i;%@][nombre_articulo]" value="@%db:nombre_articulo;%@" />
	<input type="hidden" name="from[@%db:i;%@][nombre_marca]" value="@%db:nombre_marca;%@" />
	<input type="hidden" name="from[@%db:i;%@][nombre_zona]" value="@%db:nombre_zona;%@" />
	<div id="ChkLocation_@%db:i;%@" name="BuscarLocalizacion" >
	<span>@%db:nombre_articulo;%@ (ID: @%db:id_articulo;%@) @%db:nombre_marca;%@</span>

	<div name="CodigoBarras" class="oculto" ><input type="hidden" name="codigoBarras[@%db:i;%@]" value="@%db:codigo_barras;%@" 
	class="codigobarras" /><input type="text" name="comprobacionBarras[@%db:i;%@]" value="" class="codigobarras"
	/>@%db:codigo_barras;%@</div>

	<div name="Origen" >@%db:nombre_zona;%@ - @%db:planta;%@ : @%db:pasillo;%@ : @%db:columna;%@ : @%db:fila;%@</div>

	<div name="SKU" >
	@%db:colocar_fecha{fecha_caducidad};%@ 
	@%if:!esta_vacio;lote;%@
	* @%db:lote;%@ 
	@%end-if:%@
	</div>

	<div name="Localizacion" >{{label_movera}}:<br/>
	<div name="CBarras_localizacion" class="oculto" id="CodBarras_X"
	><input type="text" name="comprobacionBarras[]" value="" class="codigobarras" /></div>

	<!-- @%set:_selected_value=Zona.id_almacen_logico;value|var;%@ -->
	<select name="dst[@%db:i;%@][id_almacen_logico]" tabindex="" class="zona" >
	@%where:table|Almacenes_logicos;nolink|1;%@
	<option value="@%db:Almacenes_logicos.id_almacen_logico;%@" 
		@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
		>@%db:Almacenes_logicos.nombre;%@</option>
	@%end-where:%@

	</select><br/>
	<input type="text" class="planta" name="dst[@%db:i;%@][planta]" value="" tabindex="" />:
	<input type="text" class="pasillo" name="dst[@%db:i;%@][pasillo]" value="" tabindex="" />:
	<input type="text" class="columna" name="dst[@%db:i;%@][columna]" value="" tabindex="" />:
	<input type="text" class="fila" name="dst[@%db:i;%@][fila]" value="" tabindex="" />
	</div>

	<div name="Cantidades" id="DivLocation_cnt_@%db:i;%@" >Amount: @%db:cantidad;%@</div>
</td></tr>
@%end-where:%@

<tr><td>

<!-- input type="radio" name="target" value="pkg_moverstock_confirmado" />
<span>REALIZAR MOVIMIENTOS</span><br/ -->

<div id="DivLocation_PARA" name="BuscarLocalizacion" >
<div name="Localizacion" >
<span>REALIZAR MOVIMIENTOS</span><br/>
<input type="hidden" name="__target" value="pkg_moverstock_confirmado" />
<input type="hidden" name="__target_setvar" value="accion" />
<input type="hidden" name="__target_setval" value="Confirmar" />
<input type="hidden" name="__target_confirm" value="Esta Ud Seguro de que desea mover este Stock?" />

</div>
</div>

</td></tr>

</tbody></table>

</form>

<script type="text/javascript" >
// oM = new Menu();
// new TableBrowser($('listado'),{tagname:'DIV', name:'BuscarLocalizacion', 'class':TBItem_Location},oM.selectItem);
oT = new TableBrowser($('listado'),{tagname:'DIV', name:'BuscarLocalizacion', 'class':TBItem_Location});
oKb = new KeyboardDriver(document);
oKb.register("all",oT.keyPress.bind(oT));
</script>

