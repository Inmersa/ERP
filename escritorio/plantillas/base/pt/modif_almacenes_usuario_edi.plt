@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_promocion;%@

<fieldset class="fsficha">
<legend>Acesso</legend>

<table class="full"><thead><tr>
<td class="caption">Eliminar</td>
<td class="caption">Nome</td>
<td class="caption">Apelidos</td>
<td class="caption">Iniciar Sessão</td>
<td class="caption">Palavra-Passe</td>
<td class="caption">Repetir a Palavra-Passe</td>
<td class="caption">Activo</td>
<td class="caption">Grupo de Utilizadores</td>
</tr></thead><tbody>
@%where:tabla|MozosAlmacen;%@
<input type="hidden" name="users[@%db:Mozos_almacen.id_mozo;%@][id_mozo]" value="@%db:Mozos_almacen.id_mozo;%@" />
<tr>
<td class="check" ><input type="checkbox" name="users[@%db:Mozos_almacen.id_mozo;%@][borrar]" value="1" /></td>
<td><a href="?seccion=ficha_mozo&id=@%db:Mozos_almacen.id_mozo;%@" >@%db:Mozos_almacen.nombre;%@</a></td>
<td><a href="?seccion=ficha_mozo&id=@%db:Mozos_almacen.id_mozo;%@" >@%db:Mozos_almacen.apellidos;%@</a></td>
<!-- @%set:id_usr = Mozos_almacen.id_usr;value|var;%@ @%db:Mozos_almacen.id_usr;%@ @%set:id_mozo=Mozos_almacen.id_mozo;%@ -->
@%if:!esta_vacio;id_usr;%@
@%where:tabla|Users;db|conf;where|Users.id_usr = $id_usr;%@
<td><input type="text" name="users[@%get:id_mozo%@][login]" value="@%db:Users.login%@" /></td>
<td><input type="password" name="users[@%get:id_mozo;%@][passwd]" size="15" /></td>
<td><input type="password" name="users[@%get:id_mozo;%@][passwd2]" size="15" /></td>
<!-- @%db:Users.av_group%@ @%set:usr_mask=Users.av_group;%@ -->
<td class="check" ><input type="checkbox" name="users[@%get:id_mozo;%@][activo]" value="1"
	@%db:check_flag{Users.activo}%@ /></td>
<td>
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $usr_mask;nolink|1;%@
@%db:Groups.nombre%@ 
@%end-where:%@

</td>
@%end-where:%@

@%else:%@
<td colspan="5" ></td>
@%end-if:%@
</tr>
@%end-where:%@

</tbody></table>

<table class="full">
<caption>Adicionar Início de Sessão</caption>
<thead><tr>
<td class="caption">Nome</td>
<td class="caption">Apelidos</td>
<td class="caption">Iniciar Sessão</td>
<td class="caption">Palavra-Passe</td>
<td class="caption">Repetir a Palavra-Passe</td>
<td class="caption">Grupo</td>
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
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@"
@%db:selected_value{Groups.mascara}%@
>@%db:Groups.nombre%@</option>
@%end-where:%@


</select></td>
</tr></tbody></table>
@%end-where:%@


</fieldset>
