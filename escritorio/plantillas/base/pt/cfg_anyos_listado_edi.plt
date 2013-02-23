
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#" onClick="return sendForm('anyos','accion_ejecutar','Modificar');" class="guardar" 
><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
<li><a href="#" onClick="return sendForm('anyos');" class="borrar" 
><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
<li><a href="#" onClick="return sendForm('anyos','accion_ejecutar','Reconstruir');" class="reconstruir" 
><img src="imag/pixel.png" class="icono" /><span>Reconstruir ligações</span></a></li>
</ul></div>

<form name="anyos" action="?seccion=cfg_anyos" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<table class="full">
<thead><tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Anyos.numero" class="order" >Número<img src="imag/pixel.png" class="@%func:class_searchsort;Anyos.numero;%@" /></a></td>
<td ><a href="?_search_sort=nombre" class="order" >Nome<img src="imag/pixel.png" class="@%func:class_searchsort;nombre;%@" /></a></td>
<td ><a href="?_search_sort=Anyos.f_ini" class="order" >Data de Início<img src="imag/pixel.png" class="@%func:class_searchsort;Anyos.f_ini;%@" /></a></td>
<td ><a href="?_search_sort=Anyos.f_fin" class="order" >Data Final<img src="imag/pixel.png" class="@%func:class_searchsort;Anyos.f_fin;%@" /></a></td>
<td ><a href="?_search_sort=Anyos.n_trimestres" class="order" >Número de Trimestres<img src="imag/pixel.png" class="@%func:class_searchsort;Anyos.n_trimestres;%@" /></a></td>
</tr></thead>

<tbody>
@%where:tabla|Anyos;nombre|busc;no_results|1;order|Anyos.numero asc;%@
<input type="hidden" name="old_anyos[@%db:Anyos.id_anyo;%@][nombre]" value="@%db:Anyos.nombre;%@" />
<input type="hidden" name="old_anyos[@%db:Anyos.id_anyo;%@][n_trimestres]" value="@%db:Anyos.n_trimestres;%@" />
<input type="hidden" name="old_anyos[@%db:Anyos.id_anyo;%@][f_ini]" value="@%db:Anyos.f_ini;%@" />
<input type="hidden" name="old_anyos[@%db:Anyos.id_anyo;%@][f_fin]" value="@%db:Anyos.f_fin;%@" />
<input type="hidden" name="old_anyos[@%db:Anyos.id_anyo;%@][numero]" value="@%db:Anyos.numero;%@" />
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Anyos.id_anyo;%@]" value="@%db:Anyos.id_anyo;%@" /></td>
<td >@%db:Anyos.numero;%@</td>
<td ><input type="text" name="anyos[@%db:Anyos.id_anyo;%@][nombre]" value="@%db:Anyos.nombre;%@" class="texto" /></td>
<td >@%db:colocar_fecha{Anyos.f_ini};%@</td>
<td >@%db:colocar_fecha{Anyos.f_fin};%@</td>

<!-- @%set:_selected_value=Anyos.n_trimestres;%@ -->
<td><select name="anyos[@%db:Anyos.id_anyo;%@][n_trimestres]" >
@%if:equals;_selected_value;0;%@
<option value="0" selected="selected">Não Existem Itens Seleccionados</option>
@%end-if:%@
<option value="1"
@%if:equals;_selected_value;1;%@
selected="selected"
@%end-if:%@
>1</option>
<option value="2"
@%if:equals;_selected_value;2;%@
selected="selected"
@%end-if:%@
>2</option>
<option value="3"
@%if:equals;_selected_value;3;%@
selected="selected"
@%end-if:%@
>3</option>
<option value="4" 
@%if:equals;_selected_value;4;%@
selected="selected"
@%end-if:%@
>4</option>
</select></td>

</tr>
@%end-where:%@

</tbody></table>
</form>

@%plt:botonera%@

