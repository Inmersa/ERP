@%plt:botonera%@

<table class="full">
<tr>
<td></td>
<td></td>
<td class="caption" colspan="4" class="etiqueta">Quantitat</td>
<td></td>
</tr>
<tr>
<td></td>
<td></td>
<td class="caption" colspan="2">Proveïdor</td>
<td class="caption" colspan="2">Client</td>
<td></td>
</tr>
<tr>
<td class="caption" class="etiqueta">Ref.</td>
<td class="caption" class="etiqueta">Nom</td>
<td class="caption" class="etiqueta">Comanda</td>
<td class="caption" class="etiqueta">Rebuda</td>
<td class="caption" class="etiqueta">Comanda</td>
<td class="caption" class="etiqueta">Rebuda</td>
<td class="caption" class="etiqueta">Diferencial</td>
</tr>

 @%where:tabla|Compra_articulos;nombre|busc;no_results|1;%@
<tr>
<td>@%db:Compra_articulos.referencia;%@</td>
<td>@%db:Articulos.nombre;%@</td>
<td>@%db:cantidad;%@ @%set:cp=cantidad%@</td>
<td>@%db:cantidad_recibida;%@ @%set:cpr=cantidad_recibida%@</td>
<td>@%db:cantidad_cliente;%@ @%set:cc=cantidad_cliente%@</td>
<td>@%db:cantidad_recibida_cliente;%@ @%set:ccr=cantidad_recibida_cliente%@</td>
<td>@%calc:cp - cpr;output|1;round|1;%@ / @%calc:cc - ccr;2%@</td>
</tr>


 @%end-where:%@


</table>


 @%plt:botonera%@ 


