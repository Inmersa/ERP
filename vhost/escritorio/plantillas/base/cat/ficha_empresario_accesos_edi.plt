@%where:tabla|Empresarios;%@
<fieldset id="Modif_Usuario" class="fsficha">
<legend>Accesos</legend>

<input type="hidden" name="Empresarios[id_usr]" value="@%db:Empresarios.id_usr;%@" />

<!-- 
    @%set:id_usr=Empresarios.id_usr;%@ 
    @%if:esta_vacio;id_usr;%@ 
	@%set:id_usr=0;%@
    @%end-if:%@
    -->

<table class="full">
<tr><td class="etiqueta">Usuari:</td>
<td><input type="text" name="Empresarios[login]" class="login" 
@%if:!esta_vacio;id_usr;%@
@%where:db|conf;nombre|login;tabla|Users;where|Users.id_usr = $id_usr;%@
value="@%db:Users.login%@" />
<!-- @%set:id_usr_activo=Users.activo;%@ @%db:Users.activo;%@ -->
@%end-where:%@

@%else:%@
/>
@%end-if:%@
</td>
<td class="etiqueta">Contrasenya:</td>
<td><input type="password" name="Empresarios[passwd]" class="password" /></td>
<td class="etiqueta">Confirmació:</td>
<td><input type="password" name="Empresarios[passwd2]" class="password" /></td>
<td class="etiqueta">Actiu</td>
<td class="check"><input type="checkbox" name="Empresarios[activo]" value="1" 
@%func:check_flag;id_usr_activo;%@
></td>

</tr>

 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Usuari CRM:</td>
 <td>
 <!--@%db:Empresarios.crm_id_empleado%@ @%set:id_crm=Empresarios.crm_id_empleado;value|var;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Empresarios.crm_id_empleado;%@
 @%else:%@
 @%where:tabla|Empleados;db|crm;nolink|1;where|id_empleado = $id_crm ;%@
 @%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ (@%db:Empleados.cargo;%@)
 <!-- @%db:Empleados.id_empleado;%@ @%set:usuario_actual=Empleados.id_empleado;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" colspan="4">
 @%if:AllowedLink;crm_seleccionar_empleado;%@
 <a href="?seccion=crm_seleccionar_empleado&id=@%get:usuario_actual;%@" >Assignar</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">Desmarcar</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@

 </table>
</fieldset>

