
@%set:tb=Importancias;%@

<div class="tituloseccion" >Importancia</div>

@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:AllowedAction;Importancias;new;%@
<li><a href="?seccion=nueva_importancia" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
@%end-if:%@
@%if:AllowedAction;Importancias;del;%@
<li><a href="#" onClick="return sendForm('listado','accion_ejecutar','Borrar');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
<thead>
<tr>
<td></td>
<td ><a href="?_search_sort=Importancias.nombre">Nombre<img src="imag/pixel.png" class="@%func:class_searchsort;Importancias.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Importancias.descripcion">Descripcción<img src="imag/pixel.png" class="@%func:class_searchsort;Importancias.descripcion;%@" /></a></td>
<td ><a href="?_search_sort=Importancias.nivel">Nivel<img src="imag/pixel.png" class="@%func:class_searchsort;Importancias.nivel;%@" /></a></td>
</tr>
</thead>
<form name="listado" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="tb" value="@%get:tb;%@" />
@%where:tabla|Importancias;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="lista_@%get:tb;%@[@%db:Importancias.id_importancia;%@]" value="@%db:Importancias.id_importancia;%@" /></td>
<td ><a href="?seccion=ficha_importancia&id=@%db:Importancias.id_importancia;%@">@%db:Importancias.nombre;%@</a></td>
<td >@%db:Importancias.descripcion;%@</td>
<td >@%db:Importancias.nivel;%@</td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@

