
<div class="tituloseccion">Notas de cliente 
@%where:nombre|Cliente;tabla|Clientes;where|id_cliente = $id_cliente;%@
@%db:Clientes.razon_social;%@ (ID: @%db:Clientes.id_cliente;%@) 
@%end-where:%@

</div>

@%plt:botonera%@

@%if:AllowedAction;Cliente_notas;del;%@
<div id="AccionesListado"><ul>
<li><a href="#" onClick="return sendForm('notas','accion_ejecutar','Borrar');" class="borrar"><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
</ul></div>
@%end-if:%@

<form name="notas" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full"><thead><tr>
@%if:AllowedAction;Cliente_notas;del;%@
 <td >&nbsp;</td>
@%end-if:%@
 <td ><a href="?_search_sort=Cliente_notas.nombre" class="order" >Nombre<img src="imag/pixel.png" class="@%func:class_searchsort;Cliente_notas.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Tipos_anotacion.nombre" class="order" >Tipo<img src="imag/pixel.png" class="@%func:class_searchsort;Tipos_anotacion.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Cliente_notas.fecha" class="order" >Fecha<img src="imag/pixel.png" class="@%func:class_searchsort;Cliente_notas.fecha;%@" /></a></td>
 <td >Usuario</td>
</tr>
</thead>
<tbody>
 @%where:tabla|Cliente_notas;nombre|busc;order|Cliente_notas.id_tipo_anotacion asc, fecha desc;no_results|1;%@
<tr >
 @%if:AllowedAction;Cliente_notas;del;%@
 <td class="check"><input type="checkbox" name="cliente_notas[@%db:Cliente_notas.id_nota_cliente;%@][id_nota_cliente]" value="@%db:Cliente_notas.id_nota_cliente;%@" /></td>
 @%end-if:%@
 <td>@%db:Cliente_notas.nombre;%@</td>
 <td >@%db:Tipos_anotacion.nombre;%@</td>
 <td >@%db:colocar_fecha{Cliente_notas.fecha};%@</td>
 <td >
 @%func:primer_novacio;Coordinadores.nombre;Operadores.nombre;Agentes.nombre;Empresas.razon_social;%@
 @%func:primer_novacio;Coordinadores.apellidos;Operadores.apellidos;Agentes.apellidos;%@
 </td>
</tr>
<tr class="filacolor" >
 <td colspan="5" >@%db:reemplazar_salto{Cliente_notas.nota};%@</td>
</tr>

@%end-where:%@ 
 
</tbody>
</table>
</form>

 @%plt:botonera%@

@%if:AllowedAction;Cliente_notas;new;%@
<form name="nuevo" method="post" action="?seccion=@%get:_krn_ss_name;%@" >
<input type="hidden" name="accion_ejecutar" value="NuevaNotaCliente" />
@%plt:NuevaNota;%@
</form>

<div class="AccionesEnvio" ><ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
</ul></div>
@%end-if:%@

