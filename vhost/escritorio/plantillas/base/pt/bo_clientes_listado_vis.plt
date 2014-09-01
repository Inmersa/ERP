
<!-- @%set:formulario_botonera=ListadoClientes;%@ -->
@%plt:botonera%@
<div class="barraoscura"> </div>
<form name="bo_clientes" method="post" action="?seccion=@%get:_krn_ss_name;%@" id="FormListadoClientes" >
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<table class="full" id="TablaListadoClientes" >
<thead>
<tr>
 <td ><a href="?_search_sort=Clientes.id_cliente">Código<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.id_cliente;%@" /></a></td>
 <td class="check"></td>
 <td ><a href="?_search_sort=Clientes.razon_social">Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes_empresas.persona_contacto">Contacto<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes_empresas.persona_contacto;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes.cif">CIF<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.cif;%@" /></a></td>
 <td ><a href="?_search_sort=Tipo_cliente.nombre">Tipo de Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Tipo_cliente.nombre;%@" /></a></td>
 </tr>
</thead>
<tbody>
 <!-- aqui viene el registro @%set:_inm_count_times=filas_por_pagina;%@-->
 @%where:tabla|Clientes;nombre|busc;no_results|1;order|Clientes.razon_social, Clientes.nombre, Clientes.apellidos;%@
 <tr onclick="return acciones_fila(this);" 
@%if:check_persistent_search;Clientes.id_cliente;%@
 class="trsobre"
 @%else:%@
 class="trnormal"
@%end-if:%@
 > <td>@%db:Clientes.id_cliente;%@
</td>
 <td class="caption">
</td>
 <td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a><br>
 @%db:Clientes.razon_social;%@<br>
 @%db:Provincias.nombre;%@ - @%db:Clientes.poblacion;%@</td>
 <td>@%db:Clientes.persona_contacto;%@ @%db:Clientes.cargo_persona_contacto;%@<br>
 <a href="mailto:@%db:Clientes.email;%@">@%db:Clientes.email;%@</a><br>
 @%db:Clientes.telefono1;%@</td>
 <td class="texto">@%db:Clientes.prefijo_cif;%@
 @%if:esta_vacio;Clientes.prefijo_cif;%@
 @%else:%@
 -
 @%end-if:%@
 @%db:Clientes.cif;%@</td>
 <td>@%db:Tipo_cliente.nombre;%@</td>
 </tr>
 @%if:inm_count;%@
 </tbody>
<tbody>
 @%end-if:%@
 @%end-where:%@

</tbody>
</table>
</form>
@%plt:botonera%@

