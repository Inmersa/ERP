@%where:tabla|Empresas;where|Empresas.id_empresa = $id_empresa;%@
<fieldset class="fsficha">
<legend>Access System</legend>

<table class="full"><thead><tr>
<td class="caption">Delete</td>
<td class="caption">Name</td>
<td class="caption">Last name</td>
<td class="caption">Login</td>
<td class="caption">Password</td>
<td class="caption">Repeat password</td>
<td class="caption">Active</td>
<td class="caption">Users group</td>
</tr></thead><tbody>
@%where:tabla|Empresarios;%@
<input type="hidden" name="users[@%db:Empresarios.id_empresario;%@][id_empresario]" value="@%db:Empresarios.id_empresario;%@" />
<tr>
<td class="check" ><input type="checkbox" name="users[@%db:Empresarios.id_empresario;%@][borrar]" value="1" /></td>
<td><a href="?seccion=ficha_empresario&id=@%db:Empresarios.id_empresario;%@" >@%db:Empresarios.nombre;%@</a></td>
<td><a href="?seccion=ficha_empresario&id=@%db:Empresarios.id_empresario;%@" >@%db:Empresarios.apellidos;%@</a></td>
<!-- @%set:id_usr = Empresarios.id_usr;%@ @%db:Empresarios.id_usr;%@ @%set:id_empresario=Empresarios.id_empresario;%@ -->
@%where:tabla|Users;db|conf;where|Users.id_usr = $id_usr;%@
<td><input type="text" name="users[@%get:id_empresario%@][login]" value="@%db:Users.login%@" /></td>
<td><input type="password" name="users[@%get:id_empresario;%@][passwd]" size="15" /></td>
<td><input type="password" name="users[@%get:id_empresario;%@][passwd2]" size="15" /></td>
<!-- @%db:Users.av_group%@ @%set:usr_mask=Users.av_group;%@ -->
<td class="check" ><input type="checkbox" name="users[@%get:id_empresario;%@][activo]" value="1"
	@%db:check_flag{Users.activo}%@ /></td>
<td>
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $usr_mask;nolink|1;%@
@%db:Groups.nombre%@ 
@%end-where:%@

</td>
@%end-where:%@

</tr>
@%end-where:%@

</tbody></table>

<table class="full">
<caption>Add login</caption>
<thead><tr>
<td class="caption">Name</td>
<td class="caption">Last name</td>
<td class="caption">Login</td>
<td class="caption">Password</td>
<td class="caption">Repeat password</td>
<td class="caption">Group</td>
</tr></thead>
<tbody><tr>
<td><input type="text" name="users[new][nombre]" size="20" /></td>
<td><input type="text" name="users[new][apellidos]" size="20" /></td>
<td><input type="text" name="users[new][login]" size="20" /></td>
<td><input type="password" name="users[new][passwd]" size="20" /></td>
<td><input type="password" name="users[new][passwd2]" size="20" /></td>
<td> 
<!-- @%set:_selected_value=usr_mask;%@ -->
 <select name="users[new][av_group]">
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $empresario_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@"
@%db:selected_value{Groups.mascara}%@
>@%db:Groups.nombre%@</option>
@%end-where:%@


</select></td>
</tr></tbody></table>
@%end-where:%@


</fieldset>
