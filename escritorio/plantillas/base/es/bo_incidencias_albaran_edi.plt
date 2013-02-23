
<form name="borrar_incidencias" action="?@%env:QUERY_STRING%@" method="post">
<fieldset id="" class="fsficha">
<legend>Incidencias Asociadas a este Documento</legend>

<div class="AccionesFicha">
<ul>
@%if:AllowedAction;Albaranes_Incidencias_CRM;new;%@
<li><a href="?seccion=nueva_incidencia_crm&id_albaran=@%get:id_documento%@" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nueva Incidencia</span></a></li> 
@%end-if:%@
@%if:AllowedAction;Albaranes_Incidencias_CRM;edit;%@
<li><a href="?seccion=incidencias&modo_seleccion=1&id_albaran=@%get:id_documento%@" class="asociar" 
	><img src="images/pixel.png" class="icono" /><span>Asociar incidencia</span></a></li>
@%end-if:%@
@%if:AllowedAction;Albaranes_Incidencias_CRM;del;%@
<li><a href="#Borrar" onClick="return sendForm('borrar_incidencias');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
@%end-if:%@
</ul>
</div>


<table class="full">
<tr>
<td></td>
<td class="caption">Referencia</td>
<td class="caption">Usuario Gestor</td>
<td class="caption">Fecha de alta</td>
<td class="caption">Fecha Aprox. Finalizaci�n</td>
<td class="caption">Tipo</td>
<td class="caption">Fecha Fin</td>
</tr>
 
@%where:tabla|Albaranes_Incidencias_CRM;nolink|1;where|id_albaran = $id_documento;%@
<!-- @%db:Albaranes_Incidencias_CRM.id_incidencia;%@ @%set:id_incidencia=Albaranes_Incidencias_CRM.id_incidencia;%@ -->
@%where:db|crm;tabla|Incidencias;where|id_incidencia = $id_incidencia;%@
 <!-- @%db:Incidencias.estado;%@ @%unset:clasefila;%@
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

-->
<tr class="@%get:clasefila;%@" > 
<td class="check"> <input type="checkbox" name="borrar_incidencias[@%db:Incidencias.id_incidencia%@]" value="1" /></td>
<td class="etiqueta">
 <a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
>INC-@%db:Incidencias.id_incidencia%@</a>
@%if:!esta_vacio;Incidencias.nota_apertura;%@
<br/>@%db:reemplazar_salto{Incidencias.nota_apertura}%@
@%end-if:%@
</td><td>
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

</table>
</fieldset>
</form>

