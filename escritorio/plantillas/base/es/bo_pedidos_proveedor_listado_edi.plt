
@%plt:botonera%@
<table class="full">
<tr>
<td class="caption">Referencia</td>
<td class="caption">Fecha</td>
<td class="caption">Base Imp.</td>
<td class="caption">P</td>
<td class="caption">A</td>
<td class="caption">F</td>
</tr>
<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
 @%where:tabla|Pedidos;nombre|busc;no_results|1;cfunc|cf_pedidos;order|Pedidos.fecha desc;%@
<tr>
<td><a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a></td>
<td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
<td>@%db:monto_pedido;%@</td>
<td><img src="imag/@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>
<td><img src="imag/@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" /></td>
<td><img src="imag/@%func:switch_alfa_dec;estado_factura;none;do;ok;%@" /></td>
</tr>
 @%end-where:%@

</table>

@%plt:botonera%@ 

<div class="barraoscura">Leyenda</div>
<table class="full">

<tr>
<td class="etiqueta">P -Pedido</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>En Preparación</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparado</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Recibido </td>
</tr>
<tr>
<td class="etiqueta">A - <span>Albarán</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Nulo / en proceso</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparado</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Enviado</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Devuelto</td>
</tr>

<tr>
<td class="etiqueta">F - <span>Factura</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sin Factura</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Sin Emitir</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Emitida</td>

</tr>
</table>



