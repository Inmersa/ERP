
<div class="tituloseccion">&gt; A�adir art�culos a Cliente (
      @%where:nombre|cli;tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
      @%db:Clientes.razon_social;%@ 
      @%end-where:%@

      )
</div>

@%plt:botonera%@

 <form name="nuevo_descuento_articulos" method="post" action="?seccion=bo_descuento_articulos">
 <table class="full">
 <thead>
 <tr> 
 <td >&nbsp;</td>
 <td ><a href="?_search_sort=Articulos.nombre" >Nombre<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Marcas.nombre" >Marca<img src="imag/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
 <td >Descuento </td>
 <td >Cant. descuento</td>
 </tr>
 </thead>
 <tbody>
 @%where:tabla|Articulos;nombre|busc;no_results|1;%@ 
 @%if:!articulo_decliente;Articulos.id_articulo;%@
 <tr> 
 <td class="check" ><input type="checkbox" name="cliente_articulos[@%db:Articulos.id_articulo;%@][id_articulo]" value="@%db:Articulos.id_articulo;%@" /></td>
 <td class="etiqueta" >@%db:Articulos.nombre;%@</td>
 <td >@%db:Marcas.nombre;%@</td>
 <td ><input type="text" name="cliente_articulos[@%db:Articulos.id_articulo%@][descuento]" size="5" /> %</td>
 <td ><input type="text" name="cliente_articulos[@%db:Articulos.id_articulo%@][monto]" size="10" maxlength="9" /></td>
 </tr>
 @%end-if:%@
@%end-where:%@ 

</tbody>
</table>
 <input type="hidden" name="accion_ejecutar" value="Anyadir" />
 </form>

@%plt:botonera%@

 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('nuevo_descuento_articulos');"  class="enviar" ><img src="imag/pixel.png" class="icono" /><span>A�adir</span></a></li>
 </ul></div>

 

