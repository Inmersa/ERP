@%where:tabla|Bajas_localizacion;%@
<form name="bajas_localizacion" action="?seccion=bo_bajas_almacen" method=post>
<input type="hidden" name="registro[id_baja_localizacion]" value="@%db:Bajas_localizacion.id_baja_localizacion;%@" />
<input type="hidden" name="registro[id_almacen_logico]" value="@%db:Bajas_localizacion.id_almacen_logico;%@" />
<input type="hidden" name="registro[id_articulo]" value="@%db:Bajas_localizacion.id_articulo;%@" />
<input type="hidden" name="registro[planta]" value="@%db:Bajas_localizacion.planta;%@" />
<input type="hidden" name="registro[pasillo]" value="@%db:Bajas_localizacion.pasillo;%@" />
<input type="hidden" name="registro[fila]" value="@%db:Bajas_localizacion.fila;%@" />
<input type="hidden" name="registro[columna]" value="@%db:Bajas_localizacion.columna;%@" />
<input type="hidden" name="registro[lote]" value="@%db:Bajas_localizacion.lote;%@" />
<input type="hidden" name="registro[fecha_caducidad]" value="@%db:Bajas_localizacion.fecha_caducidad;%@" />
<input type="hidden" name="registro[id_empresa]" value="@%db:Almacenes.id_empresa;%@" />
<input type="hidden" name="registro[id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" />
<input type="hidden" name="accion_ejecutar" value="Modificar" />
 <div class="barraoscura"><div class="titsuperior">&gt; Modificar Baixa de Magatzen</div></div>
<!--@%db:Bajas_localizacion.id_baja_localizacion;%@-->
<!-- @%db:Bajas_localizacion.id_albaran;%@ -->
<table class="full">
<tr><td class="etiqueta">Article :</td>
<td >@%db:Articulos.nombre;%@ (@%db:Articulos.id_articulo;%@)</td>
</tr>

<tr><td class="etiqueta">Data de baixa :</td>
<td>@%db:colocar_fecha{Bajas_localizacion.fecha_baja};%@</td></tr>

<tr><td class="etiqueta"> Zona Magatzem : </td>
<td >@%db:Almacenes_logicos.nombre;%@</td></tr>

@%if:esta_vacio;Bajas_localizacion.id_albaran;%@
@%else:%@
	<tr><td class="etiqueta"> Albar�ns : </td>
	<td >
	@%set:id_albaran = Bajas_localizacion.id_albaran;%@
	@%where:tabla|Albaranes;where|id_albaran = $id_albaran;nolink|1;%@
	@%db:Albaranes.referencia;%@ 
	(@%db:colocar_fecha{Albaranes.fecha}%@)
	@%end-where:%@

	<input type="hidden" name="registro[causar_baja]" value="1" />
	<input type="hidden" name="registro[cantidad_anterior]" value="@%db:Bajas_localizacion.cantidad;%@" />
	<input type="hidden" name="registro[id_albaran]" value="@%db:Bajas_localizacion.id_albaran;%@" />
	<input type="hidden" name="registro[id_detalle]" value="@%db:Bajas_localizacion.id_detalle;%@" />
	</td></tr>
@%end-if:%@
<tr><td class="etiqueta"> Localitzaci� : 
</td><td >
Planta: @%db:Bajas_localizacion.planta;%@
Corredor: @%db:Bajas_localizacion.pasillo;%@
Fila: @%db:Bajas_localizacion.fila;%@
Columna: @%db:Bajas_localizacion.columna;%@
</td></tr>

<tr><td class="etiqueta"> Article (Lot / Caducitat) : </td>
<td >@%db:Bajas_localizacion.lote;%@ @%db:colocar_fecha{Bajas_localizacion.fecha_caducidad};%@</td></tr>

<tr><td class="etiqueta"> Quantitat : </td>
<td >@%db:Bajas_localizacion.cantidad;%@</td></tr>

<tr><td class="etiqueta">Tipus baixa:</td>
<td>
<!-- @%set:_selected_value=Bajas_localizacion.id_baja_almacen;%@ @%db:Bajas_localizacion.id_baja_almacen;%@ -->
<select name="registro[id_baja_almacen]" class="insertext" >
@%where:tabla|Bajas_almacen;nolink|1;%@
<option value="@%db:Bajas_almacen.id_baja_almacen;%@"
@%db:selected_value{Bajas_almacen.id_baja_almacen};%@
>@%db:Bajas_almacen.nombre;%@</option>
@%end-where:%@

</select>
</td></tr>
<tr><td class="etiqueta" > Baixes de magatzen : </td>
<td ><textarea name="registro[descripcion]" class="insertext" rows="5" cols="75" 
>@%db:Bajas_localizacion.descripcion;%@</textarea></td>
</tr>
</table>
</form>

<tr><td colspan="2" align="center">
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('bajas_localizacion');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
<li><a href="#" onClick="return sendForm('bajas_localizacion');"  class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Desfer canvis</span></a></li>
<li><a href="?seccion=bo_bajas_almacen&accion_ejecutar=Borrar&registro[id_baja_localizacion]=@%db:Bajas_localizacion.id_baja_localizacion%@" 
	onclick="return confirm('�Est� segur que desitja esborrar els registres seleccionats?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar</span></a></li>
</ul></div>

@%end-where:%@
