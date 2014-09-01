<div class="barraoscura">
<div class="titsuperior">&gt; Nova Ruta</div></div>


<form name="nuevo_rutas" action="?seccion=bo_rutas" method="post">

<table class="full">

<tr>
<td class="etiqueta">Nom ruta: </td>
<td><input type="text" name="registro[nombre]" size="25" /></td>
<td class="etiqueta">Grup de rutes:</td>
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

<tr><td class="etiqueta">Descripci�:</td>
<td colspan="3"><textarea name="registro[descripcion]" cols="50"></textarea></td>
</tr>

<tr>
<td class="etiqueta">Duraci� visita (minuts) (Minutes): </td>
<td><input type="text" name="registro[m_visita]" /></td>
<td class="etiqueta">Duraci� trasllat (minuts) (Minutes):</td>
<td><input type="text" name="registro[m_traslado]" /></td>
</tr>

<tr><td class="etiqueta">Freq��ncia / dies (Dies) :</td>
<td><input type="text" name="registro[d_frecuencia]" /></td>
<td class="etiqueta">Duraci� ruta (hores) (Horas):</td>
<td><input type="text" name="registro[h_duracion]" /></td>
</tr>

</table>

<input type="hidden" name="accion_ejecutar" value="Guardar" />

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_rutas'); return false;" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

</form>




