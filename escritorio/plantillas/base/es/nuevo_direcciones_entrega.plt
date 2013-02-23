
<div class="tituloseccion">&gt; AÑADIR DIRECCION DE ENTREGA</div>

<form name="nuevo_direcciones_entrega" action="?seccion=modif_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<table class="full">
<tr>
<td class="etiqueta">Nombre:
</td>
<td>
<input type="text" name="registro_dir[nombre]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Dirección:
</td>
<td>
<input type="text" name="registro_dir[direccion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Población:
</td>
<td>
<input type="text" name="registro_dir[poblacion]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Provincia:
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
<td class="etiqueta">Teléfono:
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
<td class="etiqueta">Persona de contacto:
</td>
<td>
<input type="text" name="registro_dir[persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta">Cargo de contacto:
</td>
<td>
<input type="text" name="registro_dir[cargo_persona_contacto]" size="35" />
</td>
</tr>
<tr>
<td class="etiqueta" valign="top">Observaciones:
</td>
<td>
<textarea name="registro_dir[observaciones]" rows="7" cols="75"></textarea>
</td>
</tr>
</table>
<input type="hidden" name="Nuevo" value="Nuevo" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="" onClick="return sendForm('nuevo_direcciones_entrega');"  class="guardar" 
	><img src="imag/pixel.png" class="icono" /><span>Añadir</span></a></li>
</ul></div>

