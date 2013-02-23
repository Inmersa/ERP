


@%plt:botonera%@

<div id="AccionesListado" ><ul>
<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('listado','bo_presupuesto_cliente&imprimir=1&printit=1','ventana_impresion');"
class="imprimirmultiple"><img src="imag/pixel.png" class="icono" /><span>Impressionn Multiple</span></a></li>
</ul></div>

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Presupuestos.referencia" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.referencia;%@" /></a></td>
<td><!-- img border="0" src="imag/iconos/marcar_todos_icono.png" / --></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Client<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.fecha" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.base_imponible" >Revenu imposable<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.impuestos" >Imp�t<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.impuestos;%@" /></a></td>
<td ><a href="?_search_sort=Presupuestos.importe" >Totals<img src="imag/pixel.png" class="@%func:class_searchsort;Presupuestos.importe;%@" /></a></td>
<td >�tat</td>
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

<div class="barraoscura">L�gende</div>
<table class="full">
<td class="etiqueta" >Non R�vis��</td>
<td align="left"><img src="imag/@%get:none;%@" /></td>
<td class="etiqueta" >R�vis�</td>
<td align="left"><img src="imag/@%get:do;%@" /></td>
<td class="etiqueta" >Approuv�</td>
<td align="left"><img src="imag/@%get:ok;%@" /></td>
<td class="etiqueta" >Rejet�</td>
<td align="left"><img src="imag/@%get:bad;%@" /></td>
</tr>
</table>


