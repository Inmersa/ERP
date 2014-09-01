
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedAction;Agentes;new;%@
<li><a href="?seccion=nuevo_agentes" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Nouveau</span></a></li>
@%end-if:%@
@%if:AllowedLink;bo_importar_agentes;%@
<li><a href="?seccion=bo_importar_agentes" class="importarusuario"><img src="imag/pixel.png" class="icono" /><span>Importer</span></a></li>
@%end-if:%@
@%if:AllowedAction;Agentes;del;%@
<li><a href="#" onClick="return sendForm('bo_agentes');" class="borrar"><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
@%set:permitir_selecciones = 1;%@
@%end-if:%@
</ul></div>


<form name="bo_agentes" method="post" action="?seccion=bo_agentes">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<table class="full">
<thead>
<tr>
@%if:!esta_vacio;permitir_selecciones;%@
<td></td>
@%end-if:%@
<td ><a href="?_search_sort=Agentes.nombre" >Nom<img src="imag/pixel.png" class="@%func:class_searchsort;Agentes.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Agentes.telefono1" >Téléphone<img src="imag/pixel.png" class="@%func:class_searchsort;Agentes.telefono1;%@" /></a></td>
<td ><a href="?_search_sort=Tipo_agente.nombre" >Tipe d´agent<img src="imag/pixel.png" class="@%func:class_searchsort;Tipo_agente.nombre;%@" /></a></td>
</tr>
</thead>
<tbody>
@%where:tabla|Agentes;order|Agentes.nombre,Agentes.apellidos;nombre|busc;no_results|1;%@
<tr>
@%if:!esta_vacio;permitir_selecciones;%@
<td class="check"><input type="checkbox" name="borrar_agentes[@%db:Agentes.id_agente;%@]" value ="1" /></td>
@%end-if:%@
<td class="etiqueta"><a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@">
@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>

<td>@%db:Agentes.telefono1;%@</td>
<td>@%db:Tipo_agente.nombre%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@


