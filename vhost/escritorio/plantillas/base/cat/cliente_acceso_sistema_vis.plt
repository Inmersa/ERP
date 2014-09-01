@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.activo;%@ @%db:Clientes_empresas.id_usr;%@ -->
<input type="hidden" name="cli_user[id_usr]" value="@%db:Clientes_empresas.id_usr%@" />
<input type="hidden" name="registro2[referencias_propias]" value="@%db:Clientes_empresas.referencias_propias%@" />
<fieldset class="fsficha">
<legend>Accesos</legend>
<table class="full">
@%if:esta_vacio;Clientes_empresas.id_usr;%@
	<td class="etiqueta">Login: </td>
	<td><input type="text" name="cli_user[login]" value="" class="insertext" size="20" /></td>
	<td class="etiqueta">Grup:
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
	<!-- @%set:usr_activo = Users.activo;%@ @%db:Users.activo;%@ -->
	<input type="hidden" name="cli_user[activo]" value="@%db:Users.activo;%@" />
	<tr>
	<td class="etiqueta">Login:</td>
	<td>@%db:Users.login%@
	<input type="hidden" name="cli_user[login]" value="@%db:Users.login;%@" size="20" /></td>
	<td class="etiqueta">Grup:</td>
	<td>
	@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;%@
	@%db:Groups.nombre%@
	@%end-where:%@

	</td>
	</tr>
	@%end-where:%@

@%end-if:%@
<tr>
<td class="etiqueta">Contrasenya:
</td>
<td>
<input type="password" name="cli_user[passwd]" class="insertext" size="20" />
</td>
<td class="etiqueta">Repetir contrasenya:
</td>
<td>
<input type="password" name="cli_user[passwd2]" class="insertext" size="20" />
</td>
</tr>
</table>
</fieldset>

