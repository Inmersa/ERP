<fieldset class="fsficha">
<legend>Donnée général</legend>


@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_promocion;%@
<input type="hidden" name="registro[mask]" value="@%db:Almacenes.mask%@" />
<input type="hidden" name="accion_ejecutar" value="prueba" />
<input type="hidden" name="registro[id_almacen]" value="@%db:Almacenes.id_almacen;%@" />
<!--@%db:Almacenes.id_almacen;%@-->
<table class="full">
<tr><td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" value="@%db:Almacenes.nombre;%@" size="30" /></td>
<td class="etiqueta" >Province / État:</td>
<td ><!--@%db:Almacenes.id_provincia;%@ @%set:_selected_value=Almacenes.id_provincia;%@-->
<select name="registro[id_provincia]">
<option value="">Aucune sélection</option>
 @%where:tabla|Provincias;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia};%@
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select></td>
</tr>
<tr><td class="etiqueta"> Contact:</td>
<td><input type="text" name="registro[persona_contacto]" value="@%db:Almacenes.persona_contacto;%@" size="30" /></td>
<td class="etiqueta" >Charge de contact:</td>
<td ><input type="text" name="registro[cargo_persona_contacto]" value="@%db:Almacenes.cargo_persona_contacto;%@" size="30" /></td>
</tr>

<tr>
<td class="etiqueta">Direction:</td>
<td><input type="text" name="registro[direccion]" value="@%db:Almacenes.direccion;%@" size="30" /></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="@%db:Almacenes.cp;%@" size="6" /></td>
</tr>

<tr>
<td class="etiqueta">Téléphone:</td>
<td><input type="text" name="registro[telefono]" value="@%db:Almacenes.telefono;%@" size="14" /></td>
<td class="etiqueta">Ville:</td>
<td><input type="text" name="registro[poblacion]" value="@%db:Almacenes.poblacion;%@" size="14" /></td>
</tr>

</tr>
<td class="etiqueta">Télécopieur:</td>
<td><input type="text" name="registro[fax]" value="@%db:Almacenes.fax;%@" size="12" /></td>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="registro[email]" value="@%db:Almacenes.email;%@" size="30" /></td>
</tr>

<tr>
<td class="etiqueta">Groupe d´accès:</td>
<td colspan="3" ><select name="registro[mask]">
<!-- @%set:_selected_value=Almacenes.mask%@ @%db:Almacenes.mask%@-->
@%where:db|conf;tabla|Groups;where|mascara != 2147483647 AND mascara != 0 AND mascara & $group_mask;nolink|1;%@
<option value="@%db:Groups.mascara%@"
@%db:selected_value{Groups.mascara}%@
>@%db:Groups.nombre%@</option>
@%end-where:%@

</select></td>
<!-- td class="etiqueta" >Nouveau :</td>
<td ><input type="text" name="registro[mask_new]" size="30" /></td -->
<tr>
<td class="etiqueta" >Note au bas de Génerér</td>
<td colspan="4" ><textarea name="registro[nota_pie_albaran]" rows="7" cols="85"
 >@%db:Almacenes.nota_pie_albaran;%@</textarea></td>
</table>
@%end-where:%@

 
</fieldset>
