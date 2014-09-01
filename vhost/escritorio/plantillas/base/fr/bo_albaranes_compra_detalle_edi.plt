
@%plt:botonera%@

<form name="albaranes" method="post" action="?seccion=@%get:_krn_ss_name;%@">            
<input type="hidden" name="accion_ejecutar" value="0">
<div id="AccionesListado"> <ul>
<li><a href="#Impresion Puesta en Marcha de Albaran" 
	onclick="return SendFormToWindow('albaranes','bo_albaran_almacen&imprimir=1','ventana_impresion');"
	class="inicioprint" ><img src="imag/pixel.png" class="icono" /><span>Imprimer Début</span></a></li>
<li class="noicon" >Mettre Date de sortie<input type="checkbox" name="enviar" value="1" /></li>
<li><a href="#Impresion Albaran de Envio"
	 onclick="return SendFormToWindow('albaranes','bo_albaran_envio_print','ventana_impresion');"
	class="envioprint" ><img src="imag/pixel.png" class="icono" /><span>Imprimer</span></a></li>
<li><a href="#Borrar Albaranes"
	 onclick="return sendForm('albaranes','accion_ejecutar','Borrar');"
	class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
</ul>
</div>

<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
@%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.fecha desc, Albaranes.referencia desc;cfunc|cf_estado_albaran;%@
<table class="full">

<thead>
<tr>
<td class="check"></td>
<td ><a href="?_search_sort=Albaranes.referencia" >Référence<img src="imag/pixel.png" class="@%func:class_searchsort;Albaranes.referencia;%@" /></a> </td>
<td ><a href="?_search_sort=Albaranes.bultos" >Bosses<img src="imag/pixel.png" class="@%func:class_searchsort;Albaranes.bultos;%@" /></a> </td>
<td ><a href="?_search_sort=Transportistas.nombre" >Transporteurs<img src="imag/pixel.png" class="@%func:class_searchsort;Transportistas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.referencia" >Ref. Commande<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a> </td>
</tr>
</thead>

<tbody>
<tr >
<td class="check" ><input type="checkbox" name="registro_borrar[@%db:Albaranes.id_albaran;%@]" value="1"></td>
<td><a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@">@%db:Albaranes.referencia;%@</a></td>
<td>@%db:Albaranes.bultos;%@</td>
<td>@%db:Transportistas.nombre;%@</td>
<td>
@%if:AllowedLink;bo_pedido_proveedor;%@
<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia%@</a>
@%else:%@
@%db:Pedidos.referencia%@
@%end-if:%@
</td>
</tr>
</tbody>

<thead class="secundario">
<tr>
<td >État</td>
<td ><a href="?_search_sort=Almacenes.nombre" >Magasin<img src="imag/pixel.png" class="@%func:class_searchsort;Almacenes.nombre;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Proveedores.nombre" >Fournisseur<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Albaranes.fecha" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Albaranes.fecha;%@" /></a> </td>
</tr>
</thead>

<tbody>
<tr >
<td><img src="imag/@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" /></td>
<td ><a href="?seccion=modif_almacenes&id_albaran=@%db:Albaranes.id_almacen;%@">@%db:Almacenes.nombre;%@</a></td>
<td colspan="2">@%db:Proveedores.nombre;%@</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
</tr>
</tbody>

</table>
@%end-where:%@

</form>

@%plt:botonera%@

<div class="barraoscura">Légende</div>
<table class="full">
<tr>
<td class="etiqueta">L - <span>Livraisons</span></td>
<td><img src="imag/@%get:none;%@" width="14" height="14" /></td>
<td>Nul / en l´espace</td>
<td><img src="imag/@%get:do;%@" width="14" height="14" /></td>
<td>Prêt</td>
<td><img src="imag/@%get:ok;%@" width="14" height="14" /></td>
<td>Envoyé</td>
<td><img src="imag/@%get:bad;%@" width="14" height="14" /></td>
<td>Envoi en retour</td>
</tr>
</table>

