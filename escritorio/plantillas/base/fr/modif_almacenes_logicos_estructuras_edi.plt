@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen_logico = $id_almacen_logico_promocion;%@

<table class="full">

<form name="modif_almacenes_logicos" action="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@" method="post">
<input type="hidden" name="registro[id_almacen_logico]" value="@%db:Almacenes_logicos.id_almacen_logico;%@" />

<tr>
<td class="etiqueta">Nom:</td>
<td colspan="9"><input type="text" name="registro[nombre]" value="@%db:Almacenes_logicos.nombre;%@" size="80" /></td>
<tr>
<td class="etiqueta">Plantes:</td>
<td><input type="text" name="registro[n_planta]" value="@%db:Almacenes_logicos.n_planta;%@" size="3" /></td>
<td class="etiqueta">Couloirs:</td>
<td><input type="text" name="registro[n_pasillo]" value="@%db:Almacenes_logicos.n_pasillo;%@" size="3" /></td>
<td class="etiqueta">Rangs:</td>
<td><input type="text" name="registro[n_fila]" value="@%db:Almacenes_logicos.n_fila;%@" size="3" /></td>
<td class="etiqueta">Colonnes:</td>
<td><input type="text" name="registro[n_columna]" value="@%db:Almacenes_logicos.n_columna;%@" size="3" /></td>
</tr>
</table>

<input type="hidden" name="Modificar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_almacenes_logicos');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
</ul></div>

<table class="full">
<tr>
<td class="caption">Magasins</td>
</tr>
<tr>
<td class="etiqueta">Nom:</td>
<td colspan="3">@%db:Almacenes.nombre;%@</td>
</tr>
<tr><td class="etiqueta">Direction:</td>
<td colspan="3">@%db:Almacenes.direccion;%@ - @%db:Almacenes.cp;%@ (@%db:Almacenes.poblacion;%@)</td>
</tr>
<tr>
<td class="etiqueta">Personne de contact:</td>
<td>@%db:Almacenes.persona_contacto;%@ (@%db:Almacenes.cargo_persona_contacto;%@)</td>
<td class="etiqueta">Téléphone:</td>
<td>@%db:Almacenes.telefono;%@</td>
</tr>
<tr>
<td colspan="2"></td>
<td class="etiqueta">Télécopieur:</td>
<td>@%db:Almacenes.fax;%@</td>
</tr>
<tr>
<td colspan="2"></td>
<td class="etiqueta">e-mail:</td>
<td>@%db:Almacenes.email;%@</td>
</tr>
</table>
 
