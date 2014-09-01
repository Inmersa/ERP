
<div class="tituloseccion">&gt; New Warehouse</div>

<form name="nuevo_almacenes" action="?seccion=bo_almacenes" method="post">
<input type="hidden" name="registro[id_almacen]" value="NULL" />

<table class="full">
<tr>
<td class="etiqueta">Name:</td>
<td>
<input type="text" name="registro[nombre]" size="30" /></td>
<td class="etiqueta" colspan="2">Area:</td>
<td colspan="2">
<select name="registro[id_provincia]">
@%where:tabla|Provincias;nolink|1;order|nombre;%@
<option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Contact person:</td>
<td>
<input type="text" name="registro[persona_contacto]" size="30" /></td>
<td class="etiqueta" colspan="2">Contact role:</td>
<td colspan="2">
<input type="text" name="registro[cargo_persona_contacto]" size="30" /></td>
</tr>
<tr>
<td class="etiqueta">Address</td>
<td>
<input type="text" name="registro[direccion]" size="30" /></td>
<td class="etiqueta">Postal Code:</td>
<td>
<input type="text" name="registro[cp]" size="6" /></td>
<td class="etiqueta">Area</td>
<td>
<input type="text" name="registro[poblacion]" size="14" /></td>

</tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td>
<input type="text" name="registro[email]" size="30" /></td>
<td class="etiqueta">Fax:</td>
<td>
<input type="text" name="registro[fax]" size="12" /></td>
<td class="etiqueta">Telephone</td>
<td>
<input type="text" name="registro[telefono]" size="14" /></td>

</tr>
<tr>
<td class="etiqueta">Group:</td>
<td colspan="5" >
<select name="registro[mask]">
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@"
>@%db:Groups.nombre%@</option>
@%end-where:%@

</select></td>
</table>

<input type="hidden" name="accion_ejecutar" value="Nuevo" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('nuevo_almacenes','accion_ejecutar','Nuevo');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
</ul></div>

