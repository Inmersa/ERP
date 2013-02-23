
@%plt:botonera%@

<form name="bo_rutas" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="" />

<div id="AccionesListado"><ul>
<li class="noicon" >From: <input type="text" name="generar_desde" value="dd/mm/aaaa" size="12" maxlength="10" /> </li>
<li class="noicon" >To: <input type="text" name="generar_hasta" value="dd/mm/aaaa" size="12" maxlength="10" /></li>
<li><a href="#" onClick="return onHRefClick('bo_rutas','accion_ejecutar', 'Generar');" class="generar" 
	><img src="images/pixel.png" class="icono" /><span>Create</span></a></li>
<li><a href="?seccion=nuevo_rutas" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Add</span></a></li>
<li><a href="#" onClick="return onHRefClick('bo_rutas','accion_ejecutar', 'Borrar_rutas');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete</span></a></li>
</ul></div>

<table class="full"><thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('bo_rutas');"  /></td>
<td ><a href="?_search_sort=Rutas.nombre" class="order" >Route<img src="images/pixel.png" class="@%func:class_searchsort;Rutas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Grupo_rutas.nombre" class="order" >Group<img src="images/pixel.png" class="@%func:class_searchsort;Grupo_rutas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Rutas.descripcion" class="order" >Discount<img src="images/pixel.png" class="@%func:class_searchsort;Rutas.descripcion;%@" /></a></td>
<td ><a href="?_search_sort=Rutas.d_frecuencia" class="order" >Frequency / Days<img src="images/pixel.png" class="@%func:class_searchsort;Rutas.d_frecuencia;%@" /></a></td>
<td ><a href="?_search_sort=Agentes.nombre" class="order" >Agent<img src="images/pixel.png" class="@%func:class_searchsort;Agentes.nombre;%@" /></a></td>
</tr></thead>
<tbody>
 @%where:tabla|Rutas;nombre|busc;no_results|1;%@
<input type="hidden" name="bo_rutas_values[@%db:Rutas.id_ruta%@][ultima_fecha]" value="@%db:ultima_fecha_recorrido;%@" />
<input type="hidden" name="bo_rutas_values[@%db:Rutas.id_ruta%@][proxima_fecha]" value="@%db:proxima_fecha_recorrido;%@" />
<input type="hidden" name="bo_rutas_values[@%db:Rutas.id_ruta%@][d_frecuencia]" value="@%db:Rutas.d_frecuencia;%@" />
<tr> 
<td class="check"><input type="checkbox" name="bo_rutas[@%db:Rutas.id_ruta%@]" value="1" /></td>
<td><a href="?seccion=modif_rutas&id_ruta=@%db:Rutas.id_ruta;%@">@%db:Rutas.nombre;%@</a></td>
<td>@%db:Grupo_rutas.nombre;%@</td>
<td>@%db:Rutas.descripcion;%@</td>
<td>@%db:Rutas.d_frecuencia;%@</td>
<td>@%db:Agentes.nombre;%@</td>
 </tr>
 @%end-where:%@

</tbody></table>
</form>

@%plt:botonera%@


