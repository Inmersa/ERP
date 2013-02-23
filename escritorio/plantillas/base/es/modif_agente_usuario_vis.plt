@%where:tabla|Agentes;where|id_agente = $id_agente_promocion;%@
<fieldset id="Modif_Agente_Usuario" class="fsficha">
<legend>Acceso sistema</legend>

<input type="hidden" name="registro[id_usr]" value="@%db:Agentes.id_usr;%@" />

<!-- 
    @%set:id_usr=Agentes.id_usr;%@ 
    @%if:esta_vacio;id_usr;%@ 
	@%set:id_usr=0;%@
    @%end-if:%@
    -->

<table class="full">
<tr><td class="etiqueta">Usuario:</td>
<td><input type="hidden" name="registro[login]" size="16" 
@%where:db|conf;nombre|login;tabla|Users;where|Users.id_usr = $id_usr;%@
value="@%db:Users.login%@"
@%set:user_name=Users.login;%@
@%end-where:%@

 />@%get:user_name;%@</td>
<td class="etiqueta">Contraseña:</td>
<td><input type="password" name="registro[passwd]" size="14" /></td>
<td class="etiqueta">Confirmación:</td>
<td><input type="password" name="registro[passwd2]" size="12" /></td>
</tr>

 @%if:!esta_vacio;LinkCRM;%@
 <tr>
 <td class="etiqueta">Usuario CRM:</td>
 <td colspan="5">
 <!--@%db:Agentes.crm_id_empleado%@ @%set:id_crm=Agentes.crm_id_empleado;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Agentes.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.cargo;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@

 </td>
 @%end-if:%@

 </table>
</fieldset>
