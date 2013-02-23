

<form name="borrar_incidencias" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<fieldset id="Cita_Incidencias" class="fsficha">
<legend>Events</legend>

<div class="AccionesFicha">
<ul>
@%if:AllowedAction;Citas_Incidencias_CRM;new;%@
<li><a href="?seccion=nueva_incidencia_crm&id_cita=@%get:id_documento%@" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New event</span></a></li> 
@%end-if:%@
@%if:AllowedAction;Citas_Incidencias_CRM;edit;%@
<li><a href="?seccion=incidencias&modo_seleccion=1&id_cita=@%get:id_documento%@" class="asociar" 
	><img src="images/pixel.png" class="icono" /><span>Associate Event</span></a></li>
@%end-if:%@
@%if:AllowedAction;Citas_Incidencias_CRM;del;%@
<li><a href="#Borrar" onClick="return sendForm('borrar_incidencias');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul>
</div>


<table class="full"><thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('borrar_incidencias');"  /></td>
<td class="caption">Reference</td>
<td class="caption">Managing User</td>
<td class="caption">Register date</td>
<td class="caption">Aproximate date to end</td>
<td class="caption">Type</td>
<td class="caption">Final date</td>
</tr></thead>
 
<tbody>
@%where:tabla|Citas_Incidencias_CRM;nolink|1;where|id_cita = $id_documento;%@
<!-- @%db:Citas_Incidencias_CRM.id_incidencia;%@ @%set:id_incidencia=Citas_Incidencias_CRM.id_incidencia;%@ -->
@%where:db|crm;tabla|Incidencias;where|id_incidencia = $id_incidencia;%@
 <!-- @%unset:clasefila;%@ @%db:Incidencias.estado;%@ 
 @%if:equals;Incidencias.estado;0;%@
   @%set:clasefila=pendiente;%@
 @%else:%@
   @%if:esta_vacio;Incidencias.fecha_cierre;%@
	   @%if:a_mayorfecha_b;Incidencias.fecha_estimada;%@
	   @%else:%@
		 @%set:clasefila=fueraplazo;%@
	   @%end-if:%@
   @%else:%@
	   @%if:a_mayorfecha_b;Incidencias.fecha_estimada;Incidencias.fecha_cierre;%@
	   @%else:%@
		 @%set:clasefila=fueraplazo;%@
	   @%end-if:%@
   @%end-if:%@
 @%end-if:%@
 -->
<tr class="@%get:clasefila;%@" > 
<td class="check"> <input type="checkbox" name="borrar_incidencias[@%db:Incidencias.id_incidencia%@]" value="1" /></td>
<td class="etiqueta">
 <a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
>EV-@%db:Incidencias.id_incidencia%@ @%db:Incidencias.nota_apertura%@</a></td>
<td>
 <!-- @%db:Incidencias.id_usuario_gestor;%@ @%set:id_gestor=Incidencias.id_usuario_gestor%@ -->
 @%where:db|crm;tabla|Empleados;where|id_empleado = $id_gestor;nolink|1;%@
 @%db:Empleados.nombre%@ @%db:Empleados.apellidos%@ - @%db:Empleados.cargo%@
 @%end-where:%@
 
</td>
<td>@%db:colocar_fecha{Incidencias.fecha}%@</td>
<td>@%db:colocar_fecha{Incidencias.fecha_estimada}%@</td>
<td>@%db:Tipo_incidencia.nombre;%@</td>
<td>@%db:colocar_fecha{Incidencias.fecha_cierre};%@</td>
</tr>
 @%end-where:%@

 @%end-where:%@

</tbody>
</table>
</fieldset>
</form>

