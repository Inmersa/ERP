@%where:tabla|Agentes;where|id_agente = $id_agente_promocion;%@
<form name="modif_agentes" action="?seccion=modif_agentes" method="post">
<input type="hidden" name="registro[id_usr]" value="@%db:Agentes.id_usr%@">
<input type="hidden" name="registro[id_agente]" value="@%db:Agentes.id_agente;%@">

<div class="tituloseccion">&gt; Fitxa d�agent</div>

@%plt:Agentes%@

@%plt:Usuario%@ 

<input type="hidden" name="accion_ejecutar" value="Modificar">
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('modif_agentes');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>
@%end-where:%@
