@%plt:botonera%@

<table class="full">
<tr>
<td class="caption">Referencia</td>
<td class="caption">Fecha</td>
<td class="caption">Dirección Destino</td>
<td class="caption">Bultos</td>
<td class="caption">Estado</td>
</tr>
<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
@%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.fecha desc;%@
<tr>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a> 
			@%if:esta_vacio;Albaranes.id_transportista;%@
			@%else:%@
			@%where:tabla|Transportistas;nombre|transporte;%@
					@%db:Transportistas.nombre;%@
			@%end-where:%@

			@%end-if:%@
</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td>
			@%db:Direcciones_entrega.direccion;%@ @%db:Direcciones_entrega.cp;%@ @%db:Direcciones_entrega.poblacion;%@<br>
			@%db:Clientes.razon_social;%@ (@%db:Clientes.id_cliente;%@): @%db:Direcciones_entrega.nombre;%@
</td>
<td>@%db:Albaranes.bultos%@</td>
<td>@%func:estado_albaran%@</td>
</tr>
@%end-where:%@


</table>

@%plt:botonera%@




