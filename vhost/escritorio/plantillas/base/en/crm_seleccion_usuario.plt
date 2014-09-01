
@%plt:botonera%@

<form action="?seccion=@%func:inm_prev_subsec%@" name="importar_usuario" method="post">
<input type="hidden" name="accion_ejecutar" value="Seleccion_usuario_crm" />
<table class="full">
 <!-- @%set:_inm_count_times=2;%@ -->
<tr>
@%where:tabla|Usuarios;nombre|busc;order|Usuarios.nombre, Usuarios.apellidos;nombre|busc;no_results|1;%@ 
<!--@%db:Usuarios.id_usuario%@ -->
 <td class="check"><input type="radio" name="usuario_seleccionado" value="@%db:Usuarios.id_usuario%@" 
 @%if:equals;usuario_actual;Usuarios.id_usuario;%@
 checked="checked"
 @%end-if:%@
 /></td>
 
 <td>@%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos;%@ (@%db:Usuarios.email;%@)</td>
 @%if:inm_count;%@
</tr><tr>
@%end-if:%@

@%end-where:%@

</tr>
</table>
</form>

@%plt:botonera%@

<div class="enviar"><a href="" onclick="return sendForm('importar_usuario');">Send selected</a></div>

