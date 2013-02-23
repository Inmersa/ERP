
<!-- @%set:formulario_botonera=ListadoClientes;%@ -->
@%plt:botonera%@
<div id="AccionesListado" >
<ul>
 @%if:!oModoSeleccion->isActive;%@
	@%if:AllowedAction;Clientes;new;%@
	<li><a href="?seccion=nuevo_clientes" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Novo Cliente</span></a></li>
	@%end-if:%@
	@%if:AllowedLink;bo_importar_clientes;%@
	<li><a href="?seccion=bo_importar_clientes" class="altausuario"><img src="imag/pixel.png" class="icono" /><span>Recuperar Cliente</span></a></li>
	@%end-if:%@
	@%if:AllowedAction;Clientes_empresas;del;%@
	<li><a href="#" onclick="return sendForm('bo_clientes');" class="bajausuario" ><img src="imag/pixel.png" class="icono" /><span>Anular Itens Seleccionados</span></a></li>
	@%set:permitir_selecciones=1;%@
	@%end-if:%@
  @%else:%@
 	<li ><a href="#" onClick="return sendForm('bo_clientes');" class="seleccionar" ><img src="imag/pixel.png" class="icono" /><span>Seleccionar</span></a></li>
  @%end-if:%@
</ul>
</div>


<form name="bo_clientes" method="post" id="FormListadoClientes" 
@%if:oModoSeleccion->isActive;%@
action="?seccion=@%func:oModoSeleccion->getFormTarget;%@" 
@%else:%@
action="#" 
@%end-if:%@
>
<input type="hidden" name="accion_ejecutar" value="Baja" />
<table class="full" id="TablaListadoClientes" >
 <!-- aqui viene el registro @%set:_inm_count_times=filas_por_pagina;%@-->
 @%where:tabla|Clientes;nombre|busc;no_results|1;order|Clientes.razon_social, Clientes.nombre, Clientes.apellidos;%@
 @%if:primera_vez;%@
<thead>
<tr>
 <td ><a href="?_search_sort=Clientes.id_cliente">Código<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.id_cliente;%@" /></a></td>
 <td class="check" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('selecciones');"  /></td>
 <td ><a href="?_search_sort=Clientes.razon_social">Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes_empresas.persona_contacto">Contacto<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes_empresas.persona_contacto;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes.cif">CIF<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.cif;%@" /></a></td>
 <td ><a href="?_search_sort=Tipo_cliente.nombre">Tipo de Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;Tipo_cliente.nombre;%@" /></a></td>
 </tr>
</thead>
<tbody>
@%end-if:%@

 <tr onclick="return acciones_fila(this);" 
@%if:check_persistent_search;Clientes.id_cliente;%@
 class="trsobre"
 @%else:%@
 class="trnormal"
@%end-if:%@
 ><td>@%db:Clientes.id_cliente;%@</td>

 <td class="check">
@%if:oModoSeleccion->isActive;%@
<input type="@%func:oModoSeleccion->getSelectionType;%@" name="@%func:oModoSeleccion->getSelectionName;%@" value="@%db:Clientes.id_cliente;%@" />
@%else:%@
 @%if:!esta_vacio;permitir_selecciones;%@
 <input type="checkbox" name="borrar_clientes[@%db:Clientes.id_cliente;%@]" value="1" 
	@%if:check_persistent_search;Clientes.id_cliente;%@
	checked="checked"
	@%end-if:%@
	/>
 @%end-if:%@
@%end-if:%@

</td>

 <td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" class="recordlink">@%db:Clientes.razon_social;%@</a><br>
 @%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@<br>
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

