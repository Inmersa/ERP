
@%plt:botonera%@ 

<form action="?seccion=bo_agentes_clientes" name="importar_clientes_agentes" method="post">
 <input type="hidden" name="accion_ejecutar" value="Importar">
 <!-- @%set:_inm_count_times=2;%@ -->
 <table class="full">
 <tr>
@%where:tabla|Clientes;order|Clientes.nombre,Clientes.apellidos;nombre|busc;no_results|1;%@ 
<td class="check"> 
 @%if:tiene_clientes_agente%@ 
 <input type="checkbox" name="importar_clientes_agente[@%db:Clientes.id_cliente%@]" value="1">
 @%else:%@ 
 &nbsp;
 @%end-if:%@
 </td>
 <td>@%db:Clientes.razon_social;%@ (@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@)</td>
 @%if:inm_count;%@
 </tr><tr>
 @%else:%@
 @%end-if:%@
 @%end-where:%@
 
</table>

@%plt:botonera%@
<div class="enviar">
 <input type="hidden" name="Importar" value="Importar">
 <a href="" onclick="document.forms['importar_clientes_agentes'].submit();return false;" class="accesos">Import </a>
</div>
</form>

