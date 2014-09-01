
<form name="localizaciones_actuales" action="?seccion=@%get:_krn_ss_name;%@" method="post" >
<input type="hidden" name="accion" value="Localizaciones" />
@%where:tabla|Detalles_albaran;nolink|1;where|Detalles_albaran.id_albaran = $id_albaran;order|Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;contador|i;cfunc|cf_localizaciones_albaran;%@ 
<!-- @%set:id_art = Articulos.id_articulo;%@ @%set:cantidad_albaran = Detalles_albaran.cantidad;fmt|1;%@ -->
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][id_detalle]" value="@%db:Detalles_albaran.id_detalle;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][cantidad_devuelta]" value="@%db:Detalles_albaran.cantidad_devuelta;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][cantidad]" value="@%db:Detalles_albaran.cantidad;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][planta]" value="@%db:Detalles_albaran.planta;%@" /> 
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][pasillo]" value="@%db:Detalles_albaran.pasillo;%@" /> 
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][fila]" value="@%db:Detalles_albaran.fila;%@" /> 
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][columna]" value="@%db:Detalles_albaran.columna;%@" /> 
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][lote]" value="@%db:Detalles_albaran.lote;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][fecha_caducidad]" value="@%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][id_articulo]" value="@%db:Articulos.id_articulo;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][id_albaran]" value="@%db:Detalles_albaran.id_albaran;%@" />
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][id_almacen_logico]" value="@%db:Detalles_albaran.id_almacen_logico;%@" /></td>
 <input type="hidden" name="oldrecord[@%get:idx_albaran;%@][id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" /></td>

<fieldset class="fsficha" >
<legend >Locations</legend>
<table class="full" >
<tbody>
<tr><td class="etiqueta" >Article</td><td colspan="2" >@%db:Articulos.nombre;%@ (@%db:Articulos.id_articulo;%@)</td></tr>
<tr><td class="etiqueta" >Amount to send</td><td colspan="2" >@%db:Detalles_albaran.cantidad;%@</td></tr>
<tr><td class="etiqueta" >To group</td><td class="check" ><input type="checkbox" name="detalles_localizacion[@%get:idx_albaran;%@][agrupar]" value="1" /></td>
<tr><td class="etiqueta" >To group locations in delivery notes</td><td class="check" 
	><input type="checkbox" name="detalles_localizacion[@%get:idx_albaran;%@][agrupar_albaranes]" value="1" /></td>
<td >&nbsp;</td></tr>
</tbody>
</table>

<table class="full" >
 <thead class="secundario" ><tr>
 <td ></td>
 <td >Amount to send</td>
 <td >Amount</td>
 <td >Use-by date Lot</td>
 <td >Warehouse Zone </td>
 <td >Floor</td>
 <td >Corridor</td>
 <td >Column</td>
 <td >Row</td>
 </tr></thead><tbody>
 @%where:tabla|Localizacion_articulos;where|Localizacion_articulos.id_articulo = $id_art;contador|j;cfunc|cf_match_localizacion;%@
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][planta]" value="@%db:Localizacion_articulos.planta;%@" />
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][pasillo]" value="@%db:Localizacion_articulos.pasillo;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][columna]" value="@%db:Localizacion_articulos.columna;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][fila]" value="@%db:Localizacion_articulos.fila;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][fecha_caducidad]" value="@%db:Localizacion_articulos.fecha_caducidad;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][lote]" value="@%db:Localizacion_articulos.lote;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][id_almacen_logico]" value="@%db:Localizacion_articulos.id_almacen_logico;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][id_articulo]" value="@%db:Localizacion_articulos.id_articulo;%@" /> 
 <input type="hidden" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" /> 
 <tr>
 <td class="check" ><input type="radio" name="detalles_localizacion[@%get:idx_albaran;%@][num]" value="@%db:j;%@" @%get:check_match_localizacion;%@ /></td>
 <td><input type="text" name="detalles_localizacion[@%get:idx_albaran;%@][@%db:j;%@][cantidad]" 
 @%if:!esta_vacio;check_match_localizacion;%@
 value="@%get:cantidad_albaran;%@" 
 @%end-if:%@
 class="cantidad" />
 </td>
 <td>@%db:Localizacion_articulos.cantidad;%@</td>
 <td>@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@  
 (@%db:Localizacion_articulos.lote%@)</td>
 <td>@%db:Almacenes_logicos.nombre;%@</td>
 <td>@%db:Localizacion_articulos.planta;%@</td>
 <td>@%db:Localizacion_articulos.pasillo;%@</td>
 <td>@%db:Localizacion_articulos.columna;%@</td>
 <td>@%db:Localizacion_articulos.fila;%@</td>
 </tr>
 @%end-where:%@

</tbody></table>
</fieldset>
@%end-where:%@


<div id="contenido" class="IconosYTexto" >
<div class="AccionesEnvio" ><ul>
<li><a href="#" onClick="return sendForm('localizaciones_actuales');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
</ul></div>
</div>

</form>


