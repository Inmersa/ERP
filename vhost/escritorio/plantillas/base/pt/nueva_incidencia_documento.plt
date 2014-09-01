<div class="tituloseccion">Nova Incidência</div>

<form name="nueva_incidencia" action="?seccion=@%get:target_nueva_incidencia;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />

<table class="full">
<thead>
<tr>
<td >Tipo de Incidência</td>
<td >Prioridade</td>
<td >Utilizador Envolvido</td>
<td >Utilizador de Abertura</td>
</tr>
</thead>
<tbody>
<tr>
<td><select name="incidencia[id_tipo_incidencia]">
@%where:db|crm;tabla|Tipo_incidencia;nolink|1;%@
<option value="@%db:Tipo_incidencia.id_tipo_incidencia;%@">@%db:Tipo_incidencia.nombre;%@</option>
 @%end-where:%@

</select>
<td><select name="incidencia[id_prioridad]">
@%where:db|crm;tabla|Prioridades;nolink|1;%@
<option value="@%db:Prioridades.id_prioridad;%@">
@%db:Prioridades.nombre;%@
</option>
 @%end-where:%@

</select></td>
<td>
@%if:esta_vacio;id_usuario_implicado;%@
<select name="incidencia[id_usuario_implicado]">
@%where:db|crm;tabla|Usuarios;nolink|1;order|nombre,apellidos%@
<option value="@%db:Usuarios.id_usuario;%@">@%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos%@</option>
@%end-where:%@

</select>
@%else:%@
@%where:db|crm;tabla|Usuarios;nolink|1;where|id_usuario = $id_usuario_implicado;%@
<input type="hidden" name="incidencia[id_usuario_implicado]" value="@%db:Usuarios.id_usuario;%@">
@%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos%@ (@%db:Usuarios.email;%@)
@%end-where:%@

@%end-if:%@

<td>
@%if:esta_vacio;id_usuario_apertura;%@
   @%if:esta_vacio;usuario_empleado;%@
	<select name="incidencia[id_usuario_apertura]">
	@%where:db|crm;tabla|Usuarios;nolink|1;%@
	<option value="@%db:Usuarios.id_usuario;%@">@%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos%@ (@%db:Usuarios.email%@)</option>
	@%end-where:%@

	</select>
	<input type="hidden" name="incidencia[usuario_empleado]" value="0" />
   @%else:%@
	<select name="incidencia[id_usuario_apertura]">
	@%where:db|crm;tabla|Empleados;nolink|1;%@
	<option value="@%db:Empleados.id_empleado;%@">@%db:Empleados.nombre;%@ @%db:Empleados.apellidos%@ - @%db:Empleados.cargo%@</option>
	@%end-where:%@

	</select>
	<input type="hidden" name="incidencia[usuario_empleado]" value="1" />
   @%end-if:%@
@%else:%@
   @%if:esta_vacio;usuario_empleado;%@
	@%where:db|crm;tabla|Usuarios;nolink|1;where|id_usuario = $id_usuario_apertura;%@
	<input type="hidden" name="incidencia[usuario_empleado]" value="0" />
	<input type="hidden" name="incidencia[id_usuario_apertura]" value="@%db:Usuarios.id_usuario;%@" />
	@%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos%@ (@%db:Usuarios.email;%@)
	@%end-where:%@

   @%else:%@
	@%where:db|crm;tabla|Empleados;nolink|1;where|id_empleado = $id_usuario_apertura;%@
	<input type="hidden" name="incidencia[usuario_empleado]" value="1" />
	<input type="hidden" name="incidencia[id_usuario_apertura]" value="@%db:Empleados.id_empleado;%@" />
	@%db:Empleados.nombre;%@ @%db:Empleados.apellidos%@ - @%db:Empleados.cargo;%@
	@%end-where:%@

   @%end-if:%@
@%end-if:%@

</td>
</tr>
<td colspan="4" class="barraoscurai"> Nota de Abertura</td></tr>
<tr><td colspan="4"><textarea name="incidencia[nota_apertura]" rows="5" cols="80" wrap="VIRTUAL"></textarea></td></tr>
</tbody>
</table>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nueva_incidencia');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>
</form>

