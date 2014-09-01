
@%plt:botonera%@

<form name="modif_provincias" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="estado" value="3" />

<div id="AccionesListado"><ul>
<li><a href="?seccion=nuevo_provincias" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nou</span></a></li>
<li><a href="#" onClick="return sendForm('modif_provincias');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
</ul></div>

<table class="full">
<thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Provincias.nombre" class="order" >Nom<img src="images/pixel.png" class="@%func:class_searchsort;Provincias.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Paises.nombre" class="order" >Pa�sos<img src="images/pixel.png" class="@%func:class_searchsort;Paises.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Provincias.codigo" class="order" >Codi<img src="images/pixel.png" class="@%func:class_searchsort;Provincias.codigo;%@" /></a></td>
<td ><a href="?_search_sort=Provincias.prefijo_tlf" class="order" 
	>Prefix Tf.<img src="images/pixel.png" class="@%func:class_searchsort;Provincias.prefijo_tlf;%@" /></a></td>
</tr></thead>

<tbody>
@%where:tabla|Provincias;nombre|busc;order|Paises.nombre,Provincias.nombre%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Provincias.id_provincia;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_provincias&id_provincia=@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</a></td>
<td >@%db:Paises.nombre;%@</td>
<td>@%db:Provincias.codigo;%@</td>
<td>@%db:Provincias.prefijo_tlf;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</form>
@%plt:botonera%@


