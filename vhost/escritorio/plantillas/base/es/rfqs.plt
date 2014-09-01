
 @%set:nomostrarcierre=1;%@
<div class="tituloseccion">
 &gt;RFQ´s
 @%if:equals;st[estado];0;%@
 {{estado_pendientes}}
 @%end-if:%@
 @%if:equals;st[estado];1;%@
 {{estado_abiertas}}
 @%end-if:%@
 @%if:equals;st[estado];2;%@
 {{estado_cerradas}}
 @%set:nomostrarcierre=0;%@
 @%end-if:%@
</div>

@%plt:botonera%@

@%if:esta_vacio;modo_seleccion;%@
<form name="rfqs" action="?seccion=rfqs" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
@%else:%@
<div id="AccionesListado">
<ul>
<li><a href="#" onClick="return sendForm('rfqs');" class="enlazarrfq"><img src="imag/pixel.png" class="icono" /><span>Enviar</span></a></li>
</ul>
</div>
<form name="rfqs" action="?seccion=@%get:_krn_old_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Seleccionar_rfq" />
@%end-if:%@

<table class="full">
<thead>
<tr>
@%if:AllowedAction;RFQ;del;%@
 <td >&nbsp;</td>
@%else:%@
  @%if:AllowedAction;RFQ_estado;new;%@
<td >&nbsp;</td>
  @%end-if:%@
@%end-if:%@
 <td ><a href="?_search_sort=RFQs.id_rfq" >Numero<img src="imag/pixel.png" class="@%func:class_searchsort;RFQs.id_rfq;%@" /></a></td>
 <td ><a href="?_search_sort=RFQs.fecha" >Fecha de Entrada<img src="imag/pixel.png" class="@%func:class_searchsort;RFQs.fecha;%@" /></a></td>
 <td ><a href="?_search_sort=Tipo_incidencia.nombre" >Tipo<img src="imag/pixel.png" class="@%func:class_searchsort;Tipo_incidencia.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Usuarios.nombre" >Implicado<img src="imag/pixel.png" class="@%func:class_searchsort;Usuarios.nombre;%@" /></a></td>
@%if:AllowedAction;RFQ_id_usuario_gestor;new;%@
 <td ><a href="?_search_sort=Empleados.nombre" >Gestor Actual<img src="imag/pixel.png" class="@%func:class_searchsort;Empleados.nombre;%@" /></a></td>
@%end-if:%@
 <td ><a href="?_search_sort=RFQs.fecha_estimada" >Fecha Aproximada Finalización<img src="imag/pixel.png" class="@%func:class_searchsort;RFQs.fecha_estimada;%@" /></a></td>
@%if:esta_vacio;nomostrarcierre;%@
 <td ><a href="?_search_sort=RFQs.fecha_cierre" >Fecha Fin<img src="imag/pixel.png" class="@%func:class_searchsort;RFQs.fecha_cierre;%@" /></a></td>
@%end-if:%@
</tr>
</thead>
<tbody>
 @%where:tabla|RFQs;nombre|busc;order|estado asc, fecha_estimada desc;no_results|1;%@

 @%unset:clasefila;%@
 @%if:equals;RFQs.estado;0;%@
   @%set:clasefila=pendiente;%@
 @%else:%@
   @%if:esta_vacio;RFQs.fecha_cierre;%@
	   @%if:a_mayorfecha_b;RFQs.fecha_estimada;%@
	   @%else:%@
		 @%set:clasefila=fueraplazo;%@
	   @%end-if:%@
   @%else:%@
	   @%if:esta_vacio;RFQs.fecha_estimada;%@
	   @%else:%@
		   @%if:a_mayorfecha_b;RFQs.fecha_estimada;RFQs.fecha_cierre;%@
		   @%else:%@
			 @%set:clasefila=fueraplazo;%@
		   @%end-if:%@
	   @%end-if:%@
   @%end-if:%@
 @%end-if:%@

<tr class="@%get:clasefila;%@" > 
@%if:esta_vacio;modo_seleccion;%@
	@%if:AllowedAction;RFQ;del;%@
	 <td class="check"><input type="checkbox" name="rfqs[@%db:RFQs.id_rfq;%@]" value="@%db:RFQs.id_rfq;%@" /></td>
	@%else:%@
	  @%if:AllowedAction;RFQ_estado;new;%@
	 <td class="check"><input type="checkbox" name="rfqs[@%db:RFQs.id_rfq;%@]" value="@%db:RFQs.id_rfq;%@" /></td>
	  @%end-if:%@
	@%end-if:%@
@%else:%@
<td class="check"><input type="radio" name="selecciones" value="@%db:RFQs.id_rfq;%@" /></td>
@%end-if:%@
 <td><a href="?seccion=rfq&id=@%db:RFQs.id_rfq;%@" >RFQ-@%db:RFQs.id_rfq;%@</a></td>
 <td >@%db:colocar_fecha{RFQs.fecha};%@</td>
 <td >@%db:Tipo.nombre;%@(@%db:Departamentos.nombre;%@)</td>
 <td >@%db:Usuarios.nombre%@ @%db:Usuarios.apellidos;%@ </td>
@%if:AllowedAction;RFQ_id_usuario_gestor;new;%@
 <td >@%db:Empleados.nombre%@ @%db:Empleados.apellidos;%@ (@%db:departamento_gestor;%@)</td>
@%end-if:%@
 <td >@%db:colocar_fecha{RFQs.fecha_estimada}%@</td>
@%if:esta_vacio;nomostrarcierre;%@
 <td >@%db:colocar_fecha{RFQs.fecha_cierre}%@</td>
@%end-if:%@
</tr>
<tr class="@%get:clasefila;%@" ><td colspan="9" >@%db:RFQs.nota_apertura;%@</td></tr>
 @%end-where:%@ 
 
</tbody>
</table>
</form>

 @%plt:botonera%@

