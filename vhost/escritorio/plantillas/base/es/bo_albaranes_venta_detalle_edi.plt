
@%plt:botonera%@

<form name="albaranes" method="post" action="?seccion=@%get:_krn_ss_name;%@">            
<input type="hidden" name="accion_ejecutar" value="0" />

<div id="AccionesListado"><ul>
<li><a href="#Impresion Puesta en Marcha de Albaran" 
	onclick="return SendFormToWindow('albaranes','bo_albaran_almacen&imprimir=1','ventana_impresion');"
	class="inicioprint" ><img src="images/pixel.png" class="icono" /><span>Imprimir puesta en marcha</span></a></li>
<li class="noicon" >Poner Fecha de Salida<input type="checkbox" name="enviar" value="1" /></li>
<li><a href="#Impresion Albaran de Envio"
	 onclick="return SendFormToWindow('albaranes','bo_albaran_envio_print','ventana_impresion');"
	class="envioprint" ><img src="images/pixel.png" class="icono" /><span>Imprimir envio</span></a></li>
<li><a href="#Borrar Albaranes"
	 onclick="return sendForm('albaranes','accion_ejecutar','Borrar');"
	class="borrar" ><img src="images/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
</ul></div>

<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
@%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.fecha desc;cfunc|cf_estado_albaran;%@
<table class="full">
<thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Albaranes.referencia" >Ref Albar�n<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.referencia;%@" /></a> </td>
<td ><a href="?_search_sort=Albaranes.bultos" >Bultos<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.bultos;%@" /></a> </td>
<td ><a href="?_search_sort=Transportistas.nombre" >Transportista<img src="images/pixel.png" class="@%func:class_searchsort;Transportistas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.referencia" >Ref. Pedido<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a> </td>
<td colspan="2"><a href="?_search_sort=Almacenes.nombre" >Almac�n<img src="images/pixel.png" class="@%func:class_searchsort;Almacenes.nombre;%@" /></a></td>
</tr></thead>

<tbody><tr>
<td><input type="checkbox" name="registro_borrar[@%db:Albaranes.id_albaran;%@]" value="1" /></td>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
<td>@%db:Albaranes.bultos;%@</td>
<td>@%db:Transportistas.nombre;%@</td>
<td>
@%if:AllowedLink;bo_pedido_cliente;%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia%@</a>
@%else:%@
@%db:Pedidos.referencia%@
@%end-if:%@
</td>
<td colspan="2">
@%if:AllowedLink;modif_almacenes;%@
<a href="?seccion=modif_almacenes&id_albaran=@%db:Albaranes.id_almacen;%@">@%db:Almacenes.nombre;%@</a>
@%else:%@
@%db:Almacenes.nombre%@
@%end-if:%@
</td>
 </tr>
</tbody>

<thead class="secundario" >
<tr>
<td colspan="3"><a href="?_search_sort=Clientes.razon_social" 
	>Cliente<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Direcciones_entrega.direccion" 
	>Direcci�n de entrega<img src="images/pixel.png" class="@%func:class_searchsort;Direcciones_entrega.direccion;%@" /></a></td>
<td ><a href="?_search_sort=Albaranes.fecha" >Fecha<img src="images/pixel.png" class="@%func:class_searchsort;Albaranes.fecha;%@" /></a> </td>
<td >Estado</td>
</tr>
</thead>
<tbody>
<tr>
<td colspan="3">@%db:Clientes.razon_social;%@ 
@%if:AllowedLink;modif_clientes;%@
(<a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" >&nbsp;@%db:Clientes.cif;%@ </a>)
@%else:%@
(@%db:Clientes.cif;%@)
@%end-if:%@
</td>
<td colspan="2"> @%db:Direcciones_entrega.direccion;%@<br>
@%db:Direcciones_entrega.poblacion;%@ @%db:Direcciones_entrega.cp;%@ @%db:Provincias.nombre;%@</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td><img src="imag/@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" /></td>
 </tr>
</tbody>
</table>
@%end-where:%@

</form>
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



