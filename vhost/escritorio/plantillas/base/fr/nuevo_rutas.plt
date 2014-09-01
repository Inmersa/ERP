<div class="barraoscura">
<div class="titsuperior">&gt; Nouvelle Route</div></div>


<form name="nuevo_rutas" action="?seccion=bo_rutas" method="post">

<table class="full">

<tr>
<td class="etiqueta">Nom route: </td>
<td><input type="text" name="registro[nombre]" size="25" /></td>
<td class="etiqueta">Groupe de routes:</td>
<td><select name="registro[id_grupo_ruta]">
 @%where:tabla|Grupo_rutas;nolink|1;%@
 <option value="@%db:Grupo_rutas.id_grupo_ruta%@"
 	>@%db:Grupo_rutas.nombre%@</option>
 @%end-where:%@

 </select></td>
 </tr>

<tr><td class="etiqueta">Agent:</td>
<td colspan="3"> <select name="registro[id_agente]">
 @%where:tabla|Agentes;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 	>@%db:Agentes.nombre%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

 </select></td>
 </tr>

<tr><td class="etiqueta">Description:</td>
<td colspan="3"><textarea name="registro[descripcion]" cols="50"></textarea></td>
</tr>

<tr>
<td class="etiqueta">Durée visite (minutes) (Minutes): </td>
<td><input type="text" name="registro[m_visita]" /></td>
<td class="etiqueta">Durée déplacement (minutes) (Minutes):</td>
<td><input type="text" name="registro[m_traslado]" /></td>
</tr>

<tr><td class="etiqueta">Fréquence / jours (Jours) :</td>
<td><input type="text" name="registro[d_frecuencia]" /></td>
<td class="etiqueta">Durée route (heures) (Jours):</td>
<td><input type="text" name="registro[h_duracion]" /></td>
</tr>

</table>

<input type="hidden" name="accion_ejecutar" value="Guardar" />

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_rutas'); return false;" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>

</form>




