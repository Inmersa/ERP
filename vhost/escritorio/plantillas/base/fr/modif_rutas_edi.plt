
<form name="modif_rutas" action="?seccion=modif_rutas" method="post">
<input type="hidden" name="registro[id_ruta]" value="@%db:Rutas.id_ruta%@" />

<fieldset class="fsficha" >
<legend>Raison sociale</legend>

<table class="full">
<tr>
<td class="etiqueta">Nom route:</td>
<td><input type="text" name="registro[nombre]" size="25" value="@%db:Rutas.nombre%@" /></td>
<td class="etiqueta">Groupe de routes:</td>
<td><!-- @%set:_selected_value=Rutas.id_grupo_ruta%@ @%db:Rutas.id_grupo_ruta%@ -->
 <select name="registro[id_grupo_ruta]">
 @%where:tabla|Grupo_rutas;nolink|1;%@
 <option value="@%db:Grupo_rutas.id_grupo_ruta%@"
@%db:selected_value{Grupo_rutas.id_grupo_ruta}%@
>@%db:Grupo_rutas.nombre%@</option>
 @%end-where:%@

 </select></td>
 </tr>
<tr>
<td class="etiqueta">Agent:</td>
<td colspan="3"> <!-- @%set:_selected_value=Rutas.id_agente%@ @%db:Rutas.id_agente%@ -->
 <select name="registro[id_agente]">
 @%where:tabla|Agentes;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
@%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre%@</option>
 @%end-where:%@

 </select></td>
</tr>
<tr>
<td class="etiqueta">Description:</td>
<td colspan="3"><textarea name="registro[descripcion]" cols="70">@%db:Rutas.descripcion%@</textarea></td>
 </tr>

<tr>
<td class="etiqueta">Dur�e visite (minutes) : </td>
<td><input type="text" name="registro[m_visita]" value="@%db:Rutas.m_visita%@" /></td>
<td class="etiqueta">Dur�e d�placement (minutes) :</td>
<td><input type="text" name="registro[m_traslado]" value="@%db:Rutas.m_traslado%@" /></td>
 </tr>

<tr>
<td class="etiqueta">Fr�quence / jours :</td>
<td><input type="text" name="registro[d_frecuencia]" value="@%db:Rutas.d_frecuencia;%@" /></td>
<td class="etiqueta">Dur�e route (heures) :</td>
<td><input type="text" name="registro[h_duracion]" value="@%db:Rutas.h_duracion%@" /></td>
</tr>
</table>
</fieldset>

<input type="hidden" name="accion_ejecutar" value="Guardar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="return sendForm('modif_rutas');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
</ul></div>

<form name="clientes_ruta" action="?seccion=modif_rutas" method="post">
<input type="hidden" name="accion_ejecutar" value="Guardar_clientes" />
<input type="hidden" name="clientes_array" value="" />

<fieldset class="fsficha" >
<legend>Liste de clients route</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onclick="return onHRefClick('clientes_ruta', 'clientes_array', 'clientes','seleccionar_clientes');" class="nuevo" 
	><img src="imag/pixel.png" class="icono" /><span>Ajouter</span></a></li>
<li><a href="#" onclick="return onHRefClick('clientes_ruta', 'accion_ejecutar', 'Borrar_clientes');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
<li><a href="#" onclick="return sendForm('clientes_ruta');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>

<table class="full">
<thead><tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('borrar_clientes');"  /></td>
<td >Code</td>
<td >Client | Raison sociale</td>
<td >Direction</td>
<td >Moyen de contact</td>
<td >Ordre</td>
</tr></thead>

<tbody>
@%where:tabla|Rutas_clientes;no_results|1;order|Clientes.razon_social, Clientes.nombre, Clientes.apellidos;%@
<!-- @%db:Rutas_clientes.id_ruta%@ -->

<tr>
<td class="check"><input type="checkbox" name="borrar_clientes[@%db:Clientes.id_cliente;%@]" value="1" />
 <input type="hidden" name="clientes[@%db:Clientes.id_cliente;%@]" value="@%db:Clientes.id_cliente%@" /></td>

<td>@%db:Clientes.id_cliente;%@</td>
<td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social;%@</a>
(@%db:Clientes.prefijo_cif;%@ @%db:Clientes.cif;%@)
@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@
</td>
<!-- @%set:_chop_length=30%@ -->
<td>@%db:do_chop{Clientes.direccion_facturacion};%@
 <a href="mailto:@%db:Clientes.email;%@">@%db:Clientes.email;%@</a>
 @%db:Clientes.telefono1;%@ @%db:Clientes.poblacion;%@</td>
<td>
<!-- @%db:Rutas_clientes.id_medio_cto%@ @%set:_selected_value=Rutas_clientes.id_medio_cto%@ -->
 <select name="cli[@%db:Clientes.id_cliente;%@][id_medio_cto]">
@%where:tabla|Medios_contacto;nolink|1;%@
 <option value="@%db:Medios_contacto.id_medio_cto%@"
@%db:selected_value{Medios_contacto.id_medio_cto}%@
>@%db:Medios_contacto.nombre%@</option>
@%end-where:%@

</select></td>
<td><input type="text" name="cli[@%db:Clientes.id_cliente;%@][orden]" value="@%db:Rutas_clientes.orden%@" size="3" /></td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>
</form>


