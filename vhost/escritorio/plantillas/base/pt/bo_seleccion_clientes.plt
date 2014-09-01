
@%plt:botonera%@

<form action="?seccion=@%func:inm_prev_subsec%@" name="importar_clientes_agentes" method="post">
<input type="hidden" name="accion_ejecutar" value="Seleccion_clientes" />
<table class="full">
 <!-- @%set:_inm_count_times=2;%@ -->
@%where:tabla|Clientes;nombre|busc;order|Clientes.razon_social;nombre|busc;no_results|1;%@ 
<!--@%db:Clientes.id_cliente%@ -->
 @%if:cliente_seleccionado;Clientes.id_cliente;%@
 @%else:%@
 <td class="check"><input type="checkbox" name="clientes_seleccionados[@%db:Clientes.id_cliente%@]" value="@%db:Clientes.id_cliente%@" /></td>
 @%end-if:%@
 
 <td>
 @%db:Clientes.razon_social;%@ 
(@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@)</td></tr>
 @%if:inm_count;%@


@%else:%@

@%end-if:%@
@%end-where:%@


</table>
</form>

@%plt:botonera%@

<div class="enviar"><a href="" onclick="return sendForm('importar_clientes_agentes');">Aceitar Itens Seleccionados</a></div>

