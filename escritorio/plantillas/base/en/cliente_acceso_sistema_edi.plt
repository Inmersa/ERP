@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.activo;%@ -->
<input type="hidden" name="cli_user[id_usr]" value="@%db:Clientes_empresas.id_usr%@">
<fieldset class="fsficha">
<legend>Access System</legend>
<table class="full">
@%if:esta_vacio;Clientes_empresas.id_usr;%@

	<tr>
	<td class="etiqueta">Login:
	</td>
	<td>
	<input type="text" name="cli_user[login]" value="" class="insertext" size="20" />
	</td>
	<td class="etiqueta">Group:
	</td>
	<td><!-- @%set:_selected_value=usr_mask;%@ -->
	<select name="cli_user[grupo]" class="insertext">
	@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
	<option value="@%db:Groups.mascara%@" >@%db:Groups.nombre%@</option>
	@%end-where:%@

	</select>
	</td>
	</tr>

@%else:%@
	<!-- @%set:id_usr=Clientes_empresas.id_usr;%@ -->
	@%where:db|conf;tabla|Users;where|Users.id_usr = $id_usr;no_results|0;%@
	<tr>
	<td class="etiqueta">Login:</td>
	<td><input type="text" name="cli_user[login]" value="@%db:Users.login%@" class="insertext" size="20" /></td>
	<td class="etiqueta">Group:</td>
	<td><!-- @%set:_selected_value=usr_mask;%@ -->
	<select name="cli_user[grupo]" class="insertext">
	@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
	<option value="@%db:Groups.mascara%@"
	@%db:selected_value{Groups.mascara}%@
	>@%db:Groups.nombre%@</option>
	@%end-where:%@

	</select>
	</td>
	</tr>
	<!-- @%set:usr_activo = Users.activo;%@ @%db:Users.activo;%@ -->
	@%end-where:%@

@%end-if:%@
<tr>
<td class="etiqueta">Password: </td>
<td> <input type="password" name="cli_user[passwd]" class="insertext" size="20" /> </td>
<td class="etiqueta">Repeat password: </td>
<td> <input type="password" name="cli_user[passwd2]" class="insertext" size="20" /> </td>
</tr>

<tr>
<td class="etiqueta">Active:</td>
<td class="check"><input type="checkbox" name="cli_user[activo]" value="1" @%func:check_flag;usr_activo;%@ />
@%func:si_no_flag;usr_activo;%@
</td>
<td class="etiqueta">To see only assigned Products:</td>
<td class="check"><input type="checkbox" name="registro2[referencias_propias]" value="1" @%db:check_flag{Clientes_empresas.referencias_propias}%@ />
@%func:si_no_flag;Clientes_empresas.referencias_propias;%@
</td>
</tr>

</table>
</fieldset>
