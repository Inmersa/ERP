


@%plt:botonera%@

<div id="AccionesListado" >
<ul>
@%if:AllowedAction;RFQ_estado;new;%@
<li><a href="#Revisar Seleccionados" onclick="return onHRefClick('listado','accion_ejecutar','Revisar');" class="revisar"
><img src="imag/pixel.png" class="icono" /><span>Revisar Selecciones</span></a></li>
@%end-if:%@

@%if:equals;_krn_ss_name;bo_presupuestos_ventas;%@
@%if:AllowedAction;RFQ_estado;del;%@
<li><a href="#Convertir a Proforma" onclick="return onHRefClick('listado','accion_ejecutar','ConvertirProforma');" class="aproforma"
><img src="imag/pixel.png" class="icono" /><span>Convertir en Proforma</span></a></li>
@%end-if:%@
@%end-if:%@

@%if:AllowedAction;RFQ_estado;edit;%@
<li><a href="#Aprobar Seleccionados" onclick="return onHRefClick('listado','accion_ejecutar','Aprobar');" class="aprobar"
><img src="imag/pixel.png" class="icono" /><span>Aprobar Seleccionados</span></a></li>

<li><a href="#Rechazar Seleccionados" onclick="return onHRefClick('listado','accion_ejecutar','Rechazar');" class="rechazar"
><img src="imag/pixel.png" class="icono" /><span>Rechazar Seleccionados</span></a></li>
@%end-if:%@

<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('listado','bo_presupuesto_cliente&imprimir=1&printit=1','ventana_impresion');"
class="imprimirmultiple"><img src="imag/pixel.png" class="icono" /><span>Impresi�n M�ltiple</span></a></li>

@%if:AllowedAction;Presupuestos;del;%@
<li><a href="#Borrar Seleccionados" onclick="return onHRefClick('listado','accion_ejecutar','Borrar');" class="borrar" 
><img src="imag/pixel.png" class="icono" /><span>Borrar Seleccionados</span></a></li>
@%end-if:%@

</ul>
</div>

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Presupuestos.referencia" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.referencia;%@" /></a></td>
<td><!-- img border="0" src="imag/iconos/marcar_todos_icono.png" / --></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.fecha" >Fecha<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.base_imponible" >B. imponible<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.impuestos" >Impuestos<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.impuestos;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.importe" >Total<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.importe;%@" /></a></td>
<td >Estado</td>
</tr>
</thead>
<form name="listado" method="post" action="#">
<input type="hidden" name="accion_ejecutar" value="none" />
<!-- @%set:bad=negro.gif;%@ @%set:none=triangulo.png;%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ -->

<tbody>
@%where:tabla|Presupuestos;nombre|busc;no_results|1;cfunc|cf_presupuesto;order|Presupuestos.fecha desc, Presupuestos.referencia desc;%@ 
<tr>
<td>
<a href="?seccion=bo_presupuesto_cliente&id_presupuesto=@%db:Presupuestos.id_presupuesto;%@">
@%db:not_empty{Presupuestos.referencia};%@
</a></td>
<td class="check">
 @%if:se_puede_borrar;%@
 <input type="checkbox" name="registro_borrar[@%db:Presupuestos.id_presupuesto;%@]" value="1" />
 @%else:%@
 &nbsp;
 @%end-if:%@
 </td>
<td>@%db:Clientes.razon_social;%@</td>
<td>@%db:colocar_fecha{Presupuestos.fecha};%@</td>
<td>@%db:Presupuestos.base_imponible;%@</td>
<td>@%db:Presupuestos.impuestos;%@</td>
<td>@%db:Presupuestos.importe;%@</td>
<td align="center">
@%if:esta_vacio;pedido_de_presupuesto;%@
	<img src="imag/@%db:icono_estado;;%@" />
@%else:%@
	@%if:AllowedLink;bo_pedido_cliente;%@
	<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:pedido_de_presupuesto;%@" ><img src="imag/iconos/ver.png" border="0"/></a>
	@%end-if:%@
@%end-if:%@
</td>
 </tr>
 @%end-where:%@

</tbody>
 </table>
</form>

@%plt:botonera%@

<div class="barraoscura">Leyenda</div>
<table class="full">
<td class="etiqueta" >No Revisado</td>
<td align="left"><img src="imag/@%get:none;%@" /></td>
<td class="etiqueta" >Revisado</td>
<td align="left"><img src="imag/@%get:do;%@" /></td>
<td class="etiqueta" >Aprobado</td>
<td align="left"><img src="imag/@%get:ok;%@" /></td>
<td class="etiqueta" >Rechazado</td>
<td align="left"><img src="imag/@%get:bad;%@" /></td>
</tr>
</table>


