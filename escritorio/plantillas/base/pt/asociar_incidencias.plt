
<div class="tituloseccion">Lista de Incidências</div>

@%plt:botonera%@

@%if:esta_vacio;modo_seleccion;%@
<form name="incidencias" method="post" action="?seccion=@%get:_krn_ss_name;%@">
<input type="hidden" name="accion_ejecutar" value="Aprobar" />
	@%set:permitir_selecciones=1;%@
	@%set:modo_seleccion_varios=1;%@
	<div id="AccionesListado" ><ul>
	@%if:esta_vacio;_AuthInfo[crm_id_usuario];_AuthInfo[crm_id_empleado];%@
	@%else:%@
	<li><a href="?seccion=nueva_incidencia_crm" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nova Incidência</span></a></li>
	@%end-if:%@
  	@%if:AllowedAction;Incidencias_estado;edit;%@
	<li><a href="#" onClick="return sendForm('incidencias','accion_ejecutar','Aprobar');" class="aprobar" 
		><img src="imag/pixel.png" class="icono" /><span>Aprovar</span></a></li>
	@%end-if:%@
	</ul></div>
</form>
@%else:%@
<form name="incidencias" method="post" action="?seccion=@%get:_krn_old_ss_name;%@">
<input type="hidden" name="accion_ejecutar" value="seleccionar_incidencia" />
<div id="AccionesListado" ><ul>
<li><a href="#" onClick="return sendForm('incidencias','accion_ejecutar','seleccionar_incidencias');" class="enviar" 
	><img src="imag/pixel.png" class="icono" /><span>Associar</span></a></li>
</ul></div>
@%set:permitir_selecciones=1;%@
@%end-if:%@

<table class="full">
<thead>
<tr>
@%if:esta_vacio;permitir_selecciones;%@
@%else:%@
<td></td>
@%end-if:%@
<td ><a href="?_search_sort=Incidencias.id_incidencia" >Referência<img src="imag/pixel.png" class="@%func:class_searchsort;Incidencias.id_incidencia;%@" /></a></td>
<td ><a href="?_search_sort=Usuarios.nombre" >Utilizador Envolvido<img src="imag/pixel.png" class="@%func:class_searchsort;Usuarios.nombre;%@" /></a></td>
@%if:AllowedAction;Incidencias_id_usuario_gestor;new;%@
<td ><a href="?_search_sort=Empleados.nombre" >Administrador<img src="imag/pixel.png" class="@%func:class_searchsort;Empleados.nombre;%@" /></a></td>
@%end-if:%@
<td ><a href="?_search_sort=Incidencias.fecha" >Data de Registo<img src="imag/pixel.png" class="@%func:class_searchsort;Incidencias.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Incidencias.fecha_estimada" >Data Estimada<img src="imag/pixel.png" class="@%func:class_searchsort;Incidencias.fecha_estimada;%@" /></a></td>
</tr>
</thead>
<tbody>
@%where:nombre|busc;no_results|1;%@
 @%unset:clasefila;%@
 @%if:equals;Incidencias.estado;0;%@
   @%set:clasefila=pendiente;%@
 @%else:%@
   @%if:esta_vacio;Incidencias.fecha_cierre;%@
	   @%if:a_mayorfecha_b;Incidencias.fecha_estimada;%@
	   @%else:%@
		 @%set:clasefila=fueraplazo;%@
	   @%end-if:%@
   @%else:%@
	   @%if:esta_vacio;Incidencias.fecha_estimada;%@
	   @%else:%@
		   @%if:a_mayorfecha_b;Incidencias.fecha_estimada;Incidencias.fecha_cierre;%@
		   @%else:%@
			 @%set:clasefila=fueraplazo;%@
		   @%end-if:%@
	   @%end-if:%@
   @%end-if:%@
 @%end-if:%@

<tr class="@%get:clasefila;%@" > 
@%if:esta_vacio;permitir_selecciones;%@
@%else:%@
<td class="check" >
@%if:esta_vacio;modo_seleccion_varios;%@
<input type="radio" name="selecciones" value="@%db:Incidencias.id_incidencia%@" />
@%else:%@
<input type="checkbox" name="selecciones[@%db:Incidencias.id_incidencia;%@]" value="@%db:Incidencias.id_incidencia%@" />
@%end-if:%@
</td>
@%end-if:%@
<td><a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
>INC@%db:Incidencias.id_incidencia%@</a></td>
<td>@%db:Usuarios.nombre%@ @%db:Usuarios.apellidos;%@
@%if:esta_vacio;Usuarios.email;%@
@%else:%@
(<a href="mailto:@%db:Usuarios.email;%@" >@%db:Usuarios.email;%@</a>)
@%end-if:%@
</td>
@%if:AllowedAction;Incidencias_id_usuario_gestor;new;%@
<td>@%db:Empleados.nombre%@ @%db:Empleados.apellidos;%@ @%db:Empleados.cargo;%@
@%if:esta_vacio;Empleados.email;%@
@%else:%@
(<a href="mailto:@%db:Empleados.email;%@" >@%db:Empleados.email;%@</a>)
@%end-if:%@
</td>
@%end-if:%@
<td>@%db:colocar_fecha{Incidencias.fecha}%@</td>
<td>@%db:colocar_fecha{Incidencias.fecha_estimada}%@</td>
</tr>
<tr class="@%get:clasefila;%@" ><td colspan="6">@%db:Incidencias.nota_apertura%@</td></tr>
@%end-where:%@

</table>
</form>

@%plt:botonera%@

