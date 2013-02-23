
<div class="barraoscura"><div class="titsuperior">&gt; Add delivery address</div></div>

<form name="nuevo_direcciones_entrega" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<table class="full">
<tr>
<td class="etiqueta">Name:
</td>
<td>
<input type="text" name="registro_dir[nombre]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Address:
</td>
<td>
<input type="text" name="registro_dir[direccion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">City:
</td>
<td>
<input type="text" name="registro_dir[poblacion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Area:
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
<td class="etiqueta">Postal Code:
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
<td class="etiqueta">Telephone:
</td>
<td>
<input type="text" name="registro_dir[telefono1]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Fax:
</td>
<td>
<input type="text" name="registro_dir[fax]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Contact person:
</td>
<td>
<input type="text" name="registro_dir[persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Contact Role:
</td>
<td>
<input type="text" name="registro_dir[cargo_persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta" valign="top">Remarks:
</td>
<td>
<textarea name="registro_dir[observaciones]" rows="7" cols="75"></textarea>
</td>
</tr>
</table>
<input type="hidden" name="Nuevo" value="Nuevo" />
<div class="enviar">
<a href="" onClick="document.forms['nuevo_direcciones_entrega'].submit();return false;" >Add</a>
</div>
</form>
