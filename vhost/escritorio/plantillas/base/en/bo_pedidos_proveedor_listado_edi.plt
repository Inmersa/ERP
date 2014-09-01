
@%plt:botonera%@
<table class="full">
<tr>
<td class="caption">Reference</td>
<td class="caption">Date</td>
<td class="caption">Taxable Income</td>
<td class="caption">Rd</td>
<td class="caption">D</td>
<td class="caption">Inv</td>
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

<div class="barraoscura">Caption</div>
<table class="full">

<tr>
<td class="etiqueta">O -Order</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>In Preparation</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Ready</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Received </td>
</tr>
<tr>
<td class="etiqueta">D - <span>Delivery note</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Null / in process</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Ready</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Sended</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Returned</td>
</tr>

<tr>
<td class="etiqueta">Inv- <span>Invoices</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Without invoice</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Not Issued</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Issued</td>

</tr>
</table>



