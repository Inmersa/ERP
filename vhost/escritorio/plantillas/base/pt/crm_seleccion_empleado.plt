
@%plt:botonera%@

<form action="?seccion=@%func:inm_prev_subsec%@" name="importar_empleado" method="post">
<input type="hidden" name="accion_ejecutar" value="Seleccion_usuario_crm" />
<table class="full">
 <!-- @%set:_inm_count_times=2;%@ -->
<tr>
@%where:tabla|Empleados;nombre|busc;order|Empleados.nombre, Empleados.apellidos;no_results|1;%@ 
<!--@%db:Usuarios.id_usuario%@ -->
 <td class="check"><input type="radio" name="usuario_seleccionado" value="@%db:Empleados.id_empleado%@" 
 @%if:equals;usuario_actual;Empleados.id_empleado;%@
 checked="checked"
 @%end-if:%@
 /></td>
 
 <td>@%db:Empleados.nombre;%@ @%db:Empleados.apellidos;%@ - @%db:Empleados.email;%@</td>
 @%if:inm_count;%@
</tr><tr>
@%end-if:%@

@%end-where:%@

</tr>
</table>
</form>

@%plt:botonera%@

<div class="enviar"><a href="" onclick="return sendForm('importar_empleado');">Aceitar Itens Seleccionados</a></div>

