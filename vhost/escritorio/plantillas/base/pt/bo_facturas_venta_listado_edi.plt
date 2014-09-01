
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('bo_facturas_venta','bo_factura_cliente&imprimir=1&printit=1','ventana_impresion');" class="imprimirvarios" 
	><img src="imag/pixel.png" class="icono" /><span>Impressão Múltipla</span></a></li>
<li><a href="#Emitir Seleccionados" onclick="return onHRefClick('bo_facturas_venta','accion_ejecutar','Emitir');" class="emitir" 
	><img src="imag/pixel.png" class="icono" /><span>Emitir Itens Seleccionados</span></a></li>
<li><a href="#Recalcular Seleccionados" onclick="return onHRefClick('bo_facturas_venta','accion_ejecutar','Recalcular');" class="recalcular" 
	><img src="imag/pixel.png" class="icono" /><span>Recalcular Itens Seleccionados</span></a></li>
<li><a href="#Borrar Seleccionados" onclick="return onHRefClick('bo_facturas_venta','accion_ejecutar','Borrar');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Apagar Itens Seleccionados</span></a></li>
</ul></div>

<table class="full"><thead><tr>
<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Clientes.razon_social" class="order" >Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.fecha" class="order" >Data<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.base_imponible" class="order" 
	>Valor Tributável<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.total_impuestos" class="order" 
	>Impostos<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.total_impuestos;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.monto_total" class="order" >Total<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.estado" class="order" >Estado<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.estado;%@" /></a></td>
</tr></thead>

<form name="bo_facturas_venta" method="post" action="">
<input type="hidden" name="accion_ejecutar" value="none" />
<!-- @%set:do=amarillo%@ @%set:ok=verde%@ -->
<tbody>
@%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.fecha desc, Facturas.referencia desc;no_results|1;%@ 
<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
 class="impropio"
@%else:%@
	@%if:!esta_vacio;num_abonos;%@
	class="resalte" 
	@%end-if:%@
@%end-if:%@
>
<td><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:not_empty{Facturas.referencia};%@</a></td>
<td class="check">
 @%if:se_puede_borrar;%@
 <input type="checkbox" name="registro_borrar[@%db:Facturas.id_factura;%@]" value="1" />
 @%end-if:%@
 </td>
<td>@%db:Clientes.razon_social;%@</td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Facturas.base_imponible;%@</td>
<td>@%db:Facturas.total_impuestos;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
 </tr>
@%end-where:%@

</tbody>
 </table>
</form>

@%plt:botonera%@

<div class="barraoscura">Legenda</div>
<table class="full"><tbody><tr>
<td class="etiqueta" >Emitida</td>
<td class="estado"><img src="imag/pixel.png" class="@%get:ok;%@" /></td>
<td class="etiqueta" >Por Emitir</td>
<td class="estado"><img src="imag/pixel.png" class="@%get:do;%@" /></td>
</tr></tbody></table>

