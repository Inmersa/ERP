
@%plt:botonera%@
<div id="AccionesListado"><ul>
 <li><a href="#" onClick="return onHRefClick('agentes_clientes','accion_ejecutar','Modificar');" class="enviar" 
 	><img src="images/pixel.png" class="icono" /><span>Confirmar</span></a></li>
</ul></div>

<form action="?seccion=modif_clientes" method="post" name="agentes_clientes">
<input type="hidden" name="accion_ejecutar" value="0" />

 <table class="full">
 <thead>
 <tr> 
 <td></td>
 <td >Nom</td>
 <td></td>
 <td >Nom</td>
 </tr>
 </thead>

<!-- @%set:_inm_count_times=2;%@ -->
 @%where:tabla|Agentes_clientes;nolink|1;nombre|cliag;where|Agentes_clientes.id_cliente = $id_cliente_promocion AND Agentes_clientes.fecha_fin IS NULL;%@
 <!--@%db:Agentes_clientes.id_agente;%@ @%db:store_checkmany{Agentes_clientes.id_agente}%@-->
 <input type="hidden" name="registroNN[agentes_prev][@%db:Agentes_clientes.id_agente%@]" value="1" />
 @%end-where:%@

 <tbody>
 <tr> 
 @%where:tabla|Agentes;order|Agentes.nombre;Agentes.apellidos;nombre|busc;no_results|1;%@ 
 <td class="check" ><input type="checkbox" name="registroNN[agentes][@%db:Agentes.id_agente%@]" value="1" @%db:checkmany{Agentes.id_agente}%@ /></td>
 <td ><a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" class="accesos">@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>
 @%if:inm_count;%@
 </tr><tr>
 @%end-if:%@
 @%end-where:%@ 

 </tr>
 </tbody>
 </table>
 </form>

 @%plt:botonera%@

