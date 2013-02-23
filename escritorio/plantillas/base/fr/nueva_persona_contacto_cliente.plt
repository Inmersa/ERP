
<div class="barraoscura"><div class="titsuperior">&gt; Ajouter direction</div></div>

<form name="nuevo_direcciones_entrega" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<table class="full">
<tr>
<td class="etiqueta">Nom:
</td>
<td>
<input type="text" name="registro_dir[nombre]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Direction:
</td>
<td>
<input type="text" name="registro_dir[direccion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Ville:
</td>
<td>
<input type="text" name="registro_dir[poblacion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Province / État:
</td>
<td>
<select name="registro_dir[id_provincia]">
@%where:tabla|Provincias;order|nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
@%end-where:%@

</select>
</td>
</tr>
<tr>
<td class="etiqueta">CP:
</td>
<td>
<input type="text" name="registro_dir[cp]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">e-mail:
</td>
<td>
<input type="text" name="registro_dir[email]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Téléphone:
</td>
<td>
<input type="text" name="registro_dir[telefono1]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Télécopieur:
</td>
<td>
<input type="text" name="registro_dir[fax]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Personne de contact:
</td>
<td>
<input type="text" name="registro_dir[persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Charge de contact:
</td>
<td>
<input type="text" name="registro_dir[cargo_persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta" valign="top">Observationes:
</td>
<td>
<textarea name="registro_dir[observaciones]" rows="7" cols="75"></textarea>
</td>
</tr>
</table>
<input type="hidden" name="Nuevo" value="Nuevo" />
<div class="enviar">
<a href="" onClick="document.forms['nuevo_direcciones_entrega'].submit();return false;" >Ajouter</a>
</div>
</form>
