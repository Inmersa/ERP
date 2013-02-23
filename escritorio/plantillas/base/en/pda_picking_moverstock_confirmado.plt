
<form name="albaranes_list" method="post" action="?seccion=pkg_moverstock" >
<input type="hidden" name="accion" value="Confirmado" />
<input type="hidden" name="__iface_followup" value="pkg_moverstock" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Confirmado" />

<table class="full" style="border: 1px solid blue;" id="listado" >
<caption >Stock Movido</caption>
<thead>
</thead>
<tbody>
<input type="hidden" name="dummy_var" value="none" />
<!-- @%set:__notespack_locations_var=movimientos_realizados;value|val;%@ @%set:__notespack_locations_reset=1;%@ -->
@%where:nodb|nodb_notespack_locations;contador|i;%@
<tr><td>

@%if:!esta_vacio;es_destino;%@
	{{fld_almacenlogico}}: 
	<!-- @%set:id_zona = id_almacen_logico;value|var;%@ -->
	@%where:Almacenes_logicos;where|id_almacen_logico=$id_zona;nolink|1;%@
	@%db:Almacenes_logicos.nombre;%@ 
	@%end-where:%@

	<br/>
	{{fld_planta}}: @%db:planta;%@ 
	{{fld_pasillo}}: @%db:pasillo;%@ <br/>
	{{fld_columna}}: @%db:columna;%@ 
	{{fld_fila}}: @%db:fila;%@

@%else:%@
	<div id="ChkLocation_@%db:i;%@" name="BuscarLocalizacion" >
	<span>@%db:nombre_articulo;%@ (ID: @%db:id_articulo;%@) @%db:nombre_marca;%@</span>

	<div name="SKU" >
	@%db:colocar_fecha{fecha_caducidad};%@ 
	@%if:!esta_vacio;lote;%@
	* @%db:lote;%@ 
	@%end-if:%@
	</div>

	<div name="Cantidades" id="DivLocation_cnt_@%db:i;%@" >{{label_cantidad}}: @%db:cantidad;%@</div>
	</div>
@%end-if:%@

</td></tr>
@%end-where:%@

</tbody></table>
</form>

<script type="text/javascript" >
oM = new Menu();
new TableBrowser($('listado'),null,oM.selectItem);
</script>

