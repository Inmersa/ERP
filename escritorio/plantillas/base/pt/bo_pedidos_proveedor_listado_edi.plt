
@%plt:botonera%@
<table class="full">
<tr>
<td class="caption">Referência</td>
<td class="caption">Data</td>
<td class="caption">Valor Tributável</td>
<td class="caption">P</td>
<td class="caption">G</td>
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

<div class="barraoscura">Legenda</div>
<table class="full">

<tr>
<td class="etiqueta">E -Encomenda</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Em Preparação</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparada</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Recebido </td>
</tr>
<tr>
<td class="etiqueta">G - <span>Guia de Remessa</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Anulada / Em Processamento</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparada</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Enviado</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Devolvido</td>
</tr>

<tr>
<td class="etiqueta">F- <span>Factura</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sem Factura</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Por Emitir</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Emitida</td>

</tr>
</table>



