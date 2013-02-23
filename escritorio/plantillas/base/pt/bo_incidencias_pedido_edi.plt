
<fieldset id="Incidencias_Pedido" class="fsficha">
<legend>Incidências associadas ao Documento</legend>

<div class="AccionesFicha">
<ul>

@%if:AllowedAction;Pedidos_Incidencias_CRM;new;%@
<li><a href="?seccion=nueva_incidencia_crm&id_pedido=@%get:id_documento%@" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nova Incidência</span></a></li>
@%end-if:%@
 
@%if:AllowedAction;Pedidos_Incidencias_CRM;edit;%@
<li><a href="?seccion=incidencias&modo_seleccion=1&id_pedido=@%get:id_documento%@" class="asociar" 
	><img src="imag/pixel.png" class="icono" /><span>Associar Incidência</span></a></li>
@%end-if:%@

@%if:AllowedAction;Pedidos_Incidencias_CRM;del;%@
<li><a href="#" onClick="return sendForm('borrar_incidencias');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Selecções</span></a></li>
@%end-if:%@

</ul>
</div>

<form name="borrar_incidencias" action="?@%env:QUERY_STRING%@" method="post">
<table class="full">
<thead>
<tr>
<td></td>
<td class="caption">Referência</td>
<td class="caption">Administrador</td>
<td class="caption">Data de Registo</td>
<td class="caption">Data Aproximada de Conclusão</td>
<td class="caption">Tipo</td>
<td class="caption">Data Final</td>
</tr>
</thead>
<tbody>
 
@%where:tabla|Pedidos_Incidencias_CRM;nolink|1;where|id_pedido = $id_documento;%@
<!-- @%db:Pedidos_Incidencias_CRM.id_incidencia;%@ @%set:id_incidencia=Pedidos_Incidencias_CRM.id_incidencia;%@ -->
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
<td><a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
>INC@%db:Incidencias.id_incidencia%@</a>
@%if:!esta_vacio;Incidencias.nota_apertura;%@
<br/>@%db:reemplazar_salto{Incidencias.nota_apertura}%@
@%end-if:%@
</td>
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
</form>
</fieldset>
