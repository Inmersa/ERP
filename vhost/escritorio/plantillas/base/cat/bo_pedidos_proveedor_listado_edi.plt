
@%plt:botonera%@
<table class="full">
<tr>
<td class="caption">Referència</td>
<td class="caption">Data</td>
<td class="caption">Base imposable</td>
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

<div class="barraoscura">Llegenda</div>
<table class="full">

<tr>
<td class="etiqueta">C -Comanda</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>En preparació</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparat</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Rebuda </td>
</tr>
<tr>
<td class="etiqueta">A - <span>Albaràns</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Nul / en proces</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparat</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Enviat</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Tornat</td>
</tr>

<tr>
<td class="etiqueta">F- <span>Factures</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sense factura</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Sense emetre</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Emesa</td>

</tr>
</table>



