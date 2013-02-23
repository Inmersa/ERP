
<fieldset class="fsficha">
<legend>Access System</legend>

<table class="full">
<tr>
<td class="caption">Active</td>
<td class="caption">Login</td>
<td class="caption">Password</td>
<td class="caption">Repeat password</td>
<td class="caption">Users group</td>
</tr>
@%set:id_usr = _AuthInfo[id_usr];value|var;%@
@%if:!esta_vacio;id_usr;%@
@%where:tabla|Users;db|conf;where|Users.id_usr = $id_usr;%@
<tr>
<input type="hidden" name="users[@%db:Users.id_usr%@][id_usr]" value="@%db:Users.id_usr%@" />
<input type="hidden" name="users[@%db:Users.id_usr%@][login]" value="@%db:Users.login%@" />
<input type="hidden" name="users[@%db:Users.id_usr%@][activo]" value="@%db:Users.activo%@" />
<td class="check" >@%db:si_no_flag{Users.activo}%@</td>
<td>@%db:Users.login;%@</td>
<td><input type="password" name="users[@%db:Users.id_usr%@][passwd]" size="15" /></td>
<td><input type="password" name="users[@%db:Users.id_usr%@][passwd2]" size="15" /></td>
 <!-- @%db:Users.av_group%@ @%set:usr_mask=Users.av_group;%@ -->
<td>
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $usr_mask;nolink|1;%@
@%db:Groups.nombre%@ 
@%end-where:%@

</td>
@%end-where:%@

@%end-if:%@

</tr>
</table>
</fieldset>

