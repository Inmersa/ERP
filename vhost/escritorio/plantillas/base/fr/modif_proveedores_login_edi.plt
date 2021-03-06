@%where:tabla|Proveedores_empresas;where|Proveedores_empresas.id_empresa = $id_empresa AND Proveedores.id_proveedor = $id_proveedor_promocion;%@
<!-- @%db:Proveedores.id_proveedor%@ @%set:id_usr=Proveedores_empresas.id_usr%@ -->
<input type="hidden" name="prov_user[id_usr]" value="@%db:Proveedores_empresas.id_usr%@" />

<fieldset id="Acceso_Sistema" class="fsficha">
<legend>Acc�s</legend>

<table class="full">
@%if:esta_vacio;Proveedores_empresas.id_usr;%@
<tr><td class="etiqueta">Login:</td><td><input type=text name="prov_user[login]" value="" size="20" /></td>
<td class="etiqueta">Groupe:</td><td><select name="prov_user[grupo]">
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@">@%db:Groups.nombre%@</option>
@%end-where:%@

 </select></td>
<td class="etiqueta">Actif</td>
<td class="check"><input type="checkbox" name="prov_user[activo]" value="1" /></td>
 </tr>
@%else:%@
@%where:db|conf;tabla|Users;where|Users.id_usr = $id_usr;no_results|0;%@
<tr><td class="etiqueta">Login:</td>
<td><input type=text name="prov_user[login]" value="@%db:Users.login%@" size="20" /></td>
<td class="etiqueta">Groupe :</td>
<td>
<!-- @%set:_selected_value=usr_mask;%@ -->
<select name="prov_user[grupo]">
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@"
@%db:selected_value{Groups.mascara}%@
>@%db:Groups.nombre%@</option>
@%end-where:%@

</select></td>
<td class="etiqueta">Actif:</td>
<td class="check"><input type="checkbox" name="prov_user[activo]" value=1 @%db:check_flag{Users.activo}%@ /></td>
</tr>
@%end-where:%@

@%end-if:%@
<tr><td class="etiqueta">Mot de passe:</td>
<td><input type=password name="prov_user[passwd]" size="20" /></td>
<td class="etiqueta">R�p�ter mot de passe:</td>
<td colspan="3"><input type="password" name="prov_user[passwd2]" size="20" /></td>
 </tr>
 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Utilisateur CRM:</td>
 <td>
 <!--@%db:Proveedores_empresas.crm_id_usuario%@ @%set:id_crm=Proveedores_empresas.crm_id_usuario;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Proveedores_empresas.crm_id_usuario;%@
 @%else:%@
 @%where:tabla|Usuarios;db|crm;nolink|1;where|id_usuario = $id_crm ;%@
 @%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos;%@ (@%db:Usuarios.email;%@)
 <!-- @%db:Usuarios.id_usuario;%@ @%set:usuario_actual=Usuarios.id_usuario;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" colspan="2">
 @%if:AllowedLink;crm_seleccionar_usuario;%@
 <a href="?seccion=crm_seleccionar_usuario&id=@%get:usuario_actual;%@" class="accesos">Asigner</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">D�marquer</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@
</table>


 </fieldset>
