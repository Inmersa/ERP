
<div class="tituloseccion">&gt; Quebra de Armazém
 @%if:!esta_vacio;id_almacen_logico_promocion;%@
	 @%where:tabla|Almacenes_logicos;nombre|almacenlogico;where|id_almacen_logico = $id_almacen_logico_promocion;%@
	 (@%db:Almacenes_logicos.nombre;%@)
	 @%end-where:%@

 @%end-if:%@
</div>

@%plt:botonera%@

<table class="full">
<thead><tr>
<td ><a href="?_search_sort=Almacenes_logicos.nombre" class="order" 
	>Armazém de Origem<img src="imag/pixel.png" class="@%func:class_searchsort;Almacenes_logicos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Bajas_almacen.nombre" class="order" 
	>Motivo da Quebra de Armazém<img src="imag/pixel.png" class="@%func:class_searchsort;Bajas_almacen.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Albaranes.referencia" class="order" 
	>Guia de Remessa<img src="imag/pixel.png" class="@%func:class_searchsort;Albaranes.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Bajas_localizacion.fecha_baja" class="order" 
	>Data de Anulação do Registo<img src="imag/pixel.png" class="@%func:class_searchsort;Bajas_localizacion.fecha_baja;%@" /></a></td>
</tr></thead>

<tbody>
 @%where:tabla|Bajas_almacen;nombre|busc;no_results|1;order|Bajas_localizacion.fecha_baja desc;%@
<tr>
<td>@%db:Almacenes_logicos.nombre;%@</td>
<td>
<a href="?seccion=modif_bajas_almacen&id_baja_localizacion=@%db:Bajas_localizacion.id_baja_localizacion;%@"
>@%db:not_empty{Bajas_almacen.nombre};%@</a>
</td>
<td>
@%if:!esta_vacio;Albaranes.referencia;%@
<!-- @%set:id_albaran=Bajas_localizacion.id_albaran;%@ @%db:Bajas_localizacion.id_albaran;%@-->
<a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@" 
>@%db:Albaranes.referencia;%@</a> 
(@%db:colocar_fecha{Albaranes.fecha};%@)
@%end-if:%@
</td>
<td>@%db:colocar_fecha{Bajas_localizacion.fecha_baja};%@</td>
 </tr>
 @%end-where:%@
 
</tbody></table>

@%plt:botonera%@

