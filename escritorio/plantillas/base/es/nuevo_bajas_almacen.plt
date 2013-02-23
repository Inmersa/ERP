<form name="nuevo_bajas_almacen" action="?seccion=@%get:ss_nm;%@" method="post" >
<input type="hidden" name="accion_ejecutar" value="Baja">
@%where:nodb|nodb_bajas_localizacion;contador|i;%@
<table class="full" ><tr>
<td class="etiqueta">
<input type="hidden" name="registro[@%db:i;%@][id_articulo]" value="@%db:id_art;%@">
<input type="hidden" name="registro[@%db:i;%@][planta]" value="@%db:planta;%@">
<input type="hidden" name="registro[@%db:i;%@][pasillo]" value="@%db:pasillo;%@">
<input type="hidden" name="registro[@%db:i;%@][fila]" value="@%db:fila;%@">
<input type="hidden" name="registro[@%db:i;%@][columna]" value="@%db:columna;%@">
<input type="hidden" name="registro[@%db:i;%@][lote]" value="@%db:lote;%@">
<input type="hidden" name="registro[@%db:i;%@][fecha_caducidad]" value="@%db:fecha_caducidad;%@">
<input type="hidden" name="registro[@%db:i;%@][id_almacen_logico]" value="@%db:id_almacen_logico;%@">
Referencia : 
</td><td colspan="3" >
@%if:esta_vacio;id_art;%@
@%else:%@
@%set:id_art = id_art;%@
@%where:tabla|Articulos;where|id_articulo = $id_art ;%@
@%db:Articulos.nombre;%@ (@%db:Articulos.id_articulo;%@)
@%end-where:%@

@%end-if:%@
</td></tr>
<tr><td class="etiqueta">
Zona : 
</td><td colspan="3" >
@%if:esta_vacio;id_almacen_logico;%@
@%else:%@
@%set:id_alm = id_almacen_logico;%@ @%set:id_almacen_logico = id_almacen_logico;%@
@%where:tabla|Almacenes_logicos;where|id_almacen_logico = $id_almacen_logico ;%@
@%db:Almacenes_logicos.nombre;%@ 
@%end-where:%@

@%end-if:%@
</td></tr>
@%if:!esta_vacio;id_albaran;%@
	<input type="hidden" name="registro[@%db:i;%@][cantidad_anterior]" value="@%db:cantidad;%@" />
	<input type="hidden" name="registro[@%db:i;%@][id_albaran]" value="@%db:id_albaran;%@" />
	<input type="hidden" name="registro[@%db:i;%@][id_detalle]" value="@%db:id_detalle;%@" />
	<input type="hidden" name="registro[@%db:i;%@][idx]" value="@%db:idx;%@" />
	<tr><td class="etiqueta">Albarán :</td>
	@%set:id_albaran = id_albaran;%@
	@%where:tabla|Albaranes;where|id_albaran = $id_albaran;%@
	<td colspan="3" >@%db:Albaranes.referencia;%@ (@%db:colocar_fecha{Albaranes.fecha}%@)</td>
	<!-- @%db:Pedidos.id_proveedor;%@ @%db:Pedidos.id_direccion;%@ 
	@%if:esta_vacio;Pedidos.id_proveedor;%@
	@%set:es_venta=1;%@
	@%set:id_direccion = Pedidos.id_direccion;%@
	@%else:%@
	@%set:id_proveedor = Pedidos.id_proveedor;%@
	@%end-if:%@
	-->
	@%end-where:%@

	</tr>
	<input type="hidden" name="albaran_venta" value="@%get:es_venta;%@" />
	@%if:esta_vacio;es_venta;%@
		<tr><td class="etiqueta" >No tocar el Stock</td>
		<td class="check" ><input type="radio" name="registro[@%db:i;%@][causar_baja]" value="0" ></td>
		<td class="check" ><input type="radio" name="registro[@%db:i;%@][causar_baja]" value="1" checked="checked" ></td>
		<td class="etiquetacheck" >Restablecer Stock</td></tr>
	@%else:%@
		<tr><td class="etiqueta" >Causar Baja</td>
		<td class="check" ><input type="radio" name="registro[@%db:i;%@][causar_baja]" value="1" checked="checked" ></td>
		<td class="check" ><input type="radio" name="registro[@%db:i;%@][causar_baja]" value="0"></td>
		<td class="etiquetacheck" >Restablecer Stock</td></tr>
	@%end-if:%@

	</tr>

@%end-if:%@

<tr><td class="etiqueta">
Localización : 
</td><td colspan="3" >
@%db:localizacion;%@
</td></tr>
<tr><td class="etiqueta">
Producto : 
</td><td colspan="3" >
@%db:producto;%@
</td></tr>

<tr><td class="etiqueta"> Cantidad Inicial : </td><td colspan="3" >@%db:cantidad;%@</td></tr>

<tr><td class="etiqueta">
Cantidad : 
</td><td colspan="3" ><input type="text" name="registro[@%db:i;%@][cantidad]" class="insertext" size="7" >
<input type="checkbox" name="registro[@%db:i;%@][commit]" class="insertext" value="1" >
</td></tr>

<tr><td class="etiqueta" >Causas de la Baja :</td>
<td colspan="3">
<textarea name="registro[@%db:i;%@][descripcion]" class="insertext" rows="5" cols="50"
></textarea>
</td></tr>

<td class="etiqueta">
Tipo de Baja :
</td><td colspan="3" >
<select name="registro[@%db:i;%@][id_baja_almacen]" class="insertext" >
@%where:tabla|Bajas_almacen;nolink|1;%@
<option value="@%db:Bajas_almacen.id_baja_almacen;%@"
>@%db:Bajas_almacen.nombre;%@</option>
 @%end-where:%@

</select>
</td></tr>
@%end-where:%@

</table>

@%if:!esta_vacio;id_albaran;%@
	<table class="full" >
	<caption class="titulotb" >Facturas de Abono</caption>
	<tr><td class="etiqueta" >Nueva</td>
	<td class="check" colspan="2" ><input type="radio" name="id_factura_abono" value="0" /></td>
	<td ></td>

	<!-- @%set:_inm_count_times=2;%@ -->
	@%if:!esta_vacio;se_puede_abonar;str_where_abono%@

		@%where:tabla|Facturas;where|Facturas.factura_abono != 0 AND Facturas.estado = 0 AND $str_where_abono ;%@
		@%if:inm_count;%@
		@%set:otro_lado = 0;%@
		@%else:%@
		</tr><tr>
		@%set:otro_lado = 1;%@
		@%end-if:%@

		@%if:esta_vacio;otro_lado;%@
		<td class="check" ><input type="radio" name="id_factura_abono" value="@%db:Facturas.id_factura;%@" /></td>
		<td class="etiquetacheck" >@%db:Facturas.referencia;%@ [@%db:colocar_fecha{Facturas.fecha};%@] 
		@%db:Facturas.base_imponible;%@</td>
		@%else:%@
		<td class="etiqueta" >@%db:Facturas.referencia;%@ [@%db:colocar_fecha{Facturas.fecha};%@] 
		@%db:Facturas.base_imponible;%@</td>
		<td class="check" ><input type="radio" name="id_factura_abono" value="@%db:Facturas.id_factura;%@" /></td>
		@%end-if:%@

		@%end-where:%@

	@%end-if:%@
	</tr></table>
@%end-if:%@


<div id="contenido" class="IconosYTexto" >
<div class="AccionesEnvio" ><ul>
<li><a href="#" onClick="return sendForm('nuevo_bajas_almacen');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>
</div>

</form>

