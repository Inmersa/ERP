
<div class="tituloseccion">&gt; Nouvelle Magasins</div>

<form name="nuevo_almacenes" action="?seccion=bo_almacenes" method="post">
<input type="hidden" name="registro[id_almacen]" value="NULL" />

<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td>
<input type="text" name="registro[nombre]" size="30" /></td>
<td class="etiqueta" colspan="2">Province / �tat:</td>
<td colspan="2">
<select name="registro[id_provincia]">
@%where:tabla|Provincias;nolink|1;order|nombre;%@
<option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
<tr>
<td class="etiqueta">Personne de contact:</td>
<td>
<input type="text" name="registro[persona_contacto]" size="30" /></td>
<td class="etiqueta" colspan="2">Charge de contact:</td>
<td colspan="2">
<input type="text" name="registro[cargo_persona_contacto]" size="30" /></td>
</tr>
<tr>
<td class="etiqueta">Direction</td>
<td>
<input type="text" name="registro[direccion]" size="30" /></td>
<td class="etiqueta">CP:</td>
<td>
<input type="text" name="registro[cp]" size="6" /></td>
<td class="etiqueta">Province / �tat</td>
<td>
<input type="text" name="registro[poblacion]" size="14" /></td>

</tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td>
<input type="text" name="registro[email]" size="30" /></td>
<td class="etiqueta">T�l�copieur:</td>
<td>
<input type="text" name="registro[fax]" size="12" /></td>
<td class="etiqueta">T�l�phone</td>
<td>
<input type="text" name="registro[telefono]" size="14" /></td>

</tr>
<tr>
<td class="etiqueta">Groupe:</td>
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
	><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>

