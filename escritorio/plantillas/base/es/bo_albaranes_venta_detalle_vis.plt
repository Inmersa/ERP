
@%plt:botonera%@

<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
@%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.fecha desc;cfunc|cf_estado_albaran;%@
<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Albaranes.referencia" >Ref Albar�n<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.referencia;%@" /></a> </td>
<td ><a href="?_search_sort=Albaranes.bultos" >Bultos<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.bultos;%@" /></a> </td>
<td ><a href="?_search_sort=Transportistas.nombre" >Transportista<img src="images/pixel.png" class="@%func:class_searchsort;Transportistas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.referencia" >Ref. Pedido<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a> </td>
<td colspan="2"><a href="?_search_sort=Almacenes.nombre" >Almac�n<img src="images/pixel.png" class="@%func:class_searchsort;Almacenes.nombre;%@" /></a></td>
</tr>
</thead>
<tbody>
<tr>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
<td>@%db:Albaranes.bultos;%@</td>
<td>@%db:Transportistas.nombre;%@</td>
<td><a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia%@</a></td>
<td colspan="2"><a href="?seccion=modif_almacenes&id_albaran=@%db:Albaranes.id_almacen;%@">@%db:Almacenes.nombre;%@</a></td>
 </tr>
</tbody>

<thead class="secundario" >
<tr>
<td colspan="2"><a href="?_search_sort=Clientes.razon_social" 
	>Cliente<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Direcciones_entrega.direccion" 
	>Direcci�n de entrega<img src="images/pixel.png" class="@%func:class_searchsort;Direcciones_entrega.direccion;%@" /></a></td>
<td ><a href="?_search_sort=Albaranes.fecha" >Fecha<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.fecha;%@" /></a> </td>
<td >Estado</td>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2">@%db:Clientes.razon_social;%@ (<a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" >&nbsp;@%db:Clientes.cif;%@ </a>)</td>
<td colspan="2"> @%db:Direcciones_entrega.direccion;%@<br>
@%db:Direcciones_entrega.poblacion;%@ @%db:Direcciones_entrega.cp;%@ @%db:Provincias.nombre;%@</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td><img src="imag/@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" /></td>
 </tr>
</tbody>
</table>
@%end-where:%@

@%plt:botonera%@

<div class="barraoscura">Leyenda</div>
<table class="full">
<tr>
<td class="etiqueta">A - <span>Albar�n</span></td>
<td><img src="imag/@%get:none;%@" width="14" height="14" /></td>
<td>Nulo / en proceso</td>
<td><img src="imag/@%get:do;%@" width="14" height="14" /></td>
<td>Preparado</td>
<td><img src="imag/@%get:ok;%@" width="14" height="14" /></td>
<td>Enviado</td>
<td><img src="imag/@%get:bad;%@" width="14" height="14" /></td>
<td>Devuelto</td>
</tr>
</table>



