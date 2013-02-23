@%where:tabla|Agentes;where|id_agente = $id_agente;%@
<fieldset id="Modif_Agente_Usuario" class="fsficha">
<legend>Access System</legend>

<input type="hidden" name="registro[id_usr]" value="@%db:Agentes.id_usr;%@" />

<!-- 
    @%set:id_usr=Agentes.id_usr;%@ 
    @%if:esta_vacio;id_usr;%@ 
	@%set:id_usr=0;%@
    @%end-if:%@
    -->

<table class="full">
<tr><td class="etiqueta">User:</td>
<td><input type="text" name="registro[login]" size="16" 
@%where:db|conf;nombre|login;tabla|Users;where|Users.id_usr = $id_usr;%@
value="@%db:Users.login%@"
@%end-where:%@

 /></td>
<td class="etiqueta">Password:</td>
<td><input type="password" name="registro[passwd]" size="14" /></td>
<td class="etiqueta">Confirmation:</td>
<td><input type="password" name="registro[passwd2]" size="12" /></td>
</tr>

 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">CRM User:</td>
 <td>
 <!--@%db:Agentes.crm_id_empleado%@ @%set:id_crm=Agentes.crm_id_empleado;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Agentes.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.cargo;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" colspan="2">
 @%if:AllowedLink;crm_seleccionar_empleado;%@
 <a href="?seccion=crm_seleccionar_empleado&id=@%get:usuario_actual;%@" >Assign</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">Unmark</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@

 </table>
</fieldset>

