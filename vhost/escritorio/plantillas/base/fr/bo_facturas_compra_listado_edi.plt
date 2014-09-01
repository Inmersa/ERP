
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('bo_facturas_compra','bo_factura_proveedor&imprimir=1&printit=1','ventana_impresion');" class="imprimirvarios" 
	><img src="imag/pixel.png" class="icono" /><span>Impressionn Multiple</span></a></li>
<li><a href="#Emitir Seleccionados" onclick="return onHRefClick('bo_facturas_compra','accion_ejecutar','Emitir');" class="emitir" 
	><img src="imag/pixel.png" class="icono" /><span>Émettre sur Sélectiones</span></a></li>
<li><a href="#Recalcular Seleccionados" onclick="return onHRefClick('bo_facturas_compra','accion_ejecutar','Recalcular');" class="recalcular" 
	><img src="imag/pixel.png" class="icono" /><span>Insister Selectiones</span></a></li></td>
<li><a href="#Borrar Seleccionados" onclick="return onHRefClick('bo_facturas_compra','accion_ejecutar','Borrar');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Effacer sur Sélectiones</span></a></li>
</ul></div>


<form name="bo_facturas_compra" method="post" action="?seccion=bo_facturas_compra">
<input type="hidden" name="accion_ejecutar" value="j" />

<table class="full"><thead><tr>
<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Proveedores.razon_social" class="order" 
	>Fournisseur<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.fecha" class="order" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.base_imponible" class="order" 
	>Revenu imposable<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.total_impuestos" class="order" 
	>Impôt<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.total_impuestos;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.monto_total" class="order" >Totals<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.estado" class="order" >État<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.estado;%@" /></a></td>
</tr></thead>

<!-- @%set:do=amarillo%@ @%set:ok=verde%@ -->
<tbody>
@%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.fecha desc;%@
<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
 class="impropio"
@%else:%@
	@%if:!esta_vacio;num_abonos;%@
	class="resalte" 
	@%end-if:%@
@%end-if:%@
>
<td><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" 
>@%db:not_empty{Facturas.referencia};%@</a></td>
<td class="check">
@%if:se_puede_borrar;%@ 
<input type="checkbox" name="registro_borrar[@%db:Facturas.id_factura;%@]" value="1" />
@%end-if:%@ 
 </td>
<td>@%db:Proveedores.razon_social;%@</td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Facturas.base_imponible;%@</td>
<td>@%db:Facturas.total_impuestos;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
</tr>
@%end-where:%@
 
</tbody></table>
</form>

@%plt:botonera%@

<table class="full">
<caption class="titulotb" >Légende</caption>
<tbody><tr>
<td class="etiqueta" >Émis</td>
<td class="estado" ><img src="imag/pixel.png" class="@%get:ok;%@" /></td>
<td class="etiqueta" >Sans émettre</td>
<td class="estado" ><img src="imag/pixel.png" class="@%get:do;%@" /></td>
</tr></tbody></table>


