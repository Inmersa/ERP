

@%plt:botonera%@

<!-- @%set:noemitido=rojo%@ @%set:emitido=amarillo%@ @%set:abonado=verde%@ @%set:devuelto=negro%@ -->
@%where:tabla|Efectos;nombre|busc;order|Clientes.razon_social,Efectos.fecha_vencimiento desc;no_results|1;%@ 
@%if:nuevo_cliente%@
@%if:!primera_vez;%@
</tbody>
</table>
<br>
@%end-if:%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Clientes.id_cliente" >Codi<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.id_cliente;%@" /></a></td>
<td class="fieldvalue" ><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.id_cliente;%@</a></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Ra� social<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td class="fieldvalue"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social%@</a></td>
</thead>
</tr>
 </table>
<table class="full">
<td class="etiqueta">Risc</td>
<td class="etiqueta">Demora</td>
<td class="etiqueta">Quantia</td>
<td class="etiqueta">Compte bancari IBAN</td>
 </tr>
<tr>
<td>@%db:Clientes_empresas.riesgo%@</td>
<td>@%db:Clientes_empresas.plazo_demora%@ Dia(s)</td>
<td>@%db:Clientes_empresas.monto_cuenta_efectos%@</td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
 </tr>
</table>

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Facturas.referencia" >Ref. Factures<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.concepto" >Concepte<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.concepto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.medio_pago" >Mig de pagament<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.medio_pago;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.fecha_vencimiento" >Venciment<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.fecha_vencimiento;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto" >Totals<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto;%@" /></a></td>
<td ><a href="?_search_sort=Efectos.monto_pagado" >Total pagat<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto_pagado;%@" /></a> </td>
<td >R</td>
 </tr>
</thead>
<tbody>
 @%else:%@
@%end-if:%@

<tr>
<td class="etiqueta"><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@">@%db:Facturas.referencia%@</a></td>
<td><a href="?seccion=modif_efectos_cliente&id_efecto=@%db:Efectos.id_efecto;%@"><img src="imag/hojablanco.jpg" border="0">@%db:Efectos.concepto;%@</a></td>
<td>@%db:Efectos.medio_pago%@</td>
<td>@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</td>
<td>@%db:Efectos.monto%@</td>
<td>@%db:Efectos.monto_pagado%@</td>
<td class="estado" ><img src="images/pixel.png" class="@%func:estado_efecto;Efectos.emitido;Efectos.devuelto;Efectos.pagado;noemitido;emitido;abonado;devuelto;%@" /></td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

 @%plt:botonera%@

<table class="full">
<tr>
<td class="caption" colspan="9">Llegenda</td>
</tr>
<tr>
<td class="etiqueta">Estat</td>
<td><img src="imag/triangulo.png" width="14" height="14"></td>
<td>Sense emetre</td>
<td><img src="imag/cuadrado.jpg" width="14" height="14"></td>
<td>Em�s</td>
<td><img src="imag/circulo.png" width="14" height="14"></td>
<td>Abonat</td>
<td><img src="imag/negro.gif" width="14" height="14"></td>
<td>Tornat</td>
</tr>

 </table>



