
@%plt:botonera%@
<table class="full">
<tr>
<td class="caption">R�f�rence</td>
<td class="caption">Date</td>
<td class="caption">Revenu imposable</td>
<td class="caption">P</td>
<td class="caption">L</td>
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

<div class="barraoscura">L�gende</div>
<table class="full">

<tr>
<td class="etiqueta">C -Commande</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>�mis</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Pr�t</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Re�u </td>
</tr>
<tr>
<td class="etiqueta">L - <span>Livraisons</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Nul / en l�espace</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Pr�t</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Envoy�</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Envoi en retour</td>
</tr>

<tr>
<td class="etiqueta">F- <span>Factures</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sans facture</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Sans �mettre</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>�mis</td>

</tr>
</table>



