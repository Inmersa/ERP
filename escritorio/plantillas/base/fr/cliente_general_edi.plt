 @%where:tabla|Clientes;where|id_cliente = $id_cliente_promocion;nolink|1;%@
<fieldset id="Datos_Generales" class="fsficha">
<legend>Donnée général</legend>
<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" value="@%db:Clientes.nombre;%@" class="insertext" size="30"></td>
<td class="etiqueta">NSF Intracommunitaire :</td>
<td><input type="text" name="registro[prefijo_cif]" value="@%db:Clientes.prefijo_cif;%@" class="insertextnumeros" size="2" /></td>
</tr>

<tr> 
<td class="etiqueta">Surnom:</td>
<td><input type="text" name="registro[apellidos]" value="@%db:Clientes.apellidos;%@" class="insertext" size="30"></td>
<td class="etiqueta">NSF:</td>
<td><input type="text" name="registro[cif]" value="@%db:Clientes.cif;%@" class="insertextnumeros" size="20" maxlength="12"></td>
</tr>

<tr>
<td class="etiqueta">Raison sociale: </td>
<td><input type="text" name="registro[razon_social]" value="@%db:Clientes.razon_social;%@" class="insertext" size="30"></td>
<td class="etiqueta">Ville: </td>
<td><input type="text" name="registro[poblacion]" value="@%db:Clientes.poblacion;%@" class="insertext" size="20"></td>
</tr>

<tr>
<td class="etiqueta">Direction de facturacion:</td>
<td><input type="text" name="registro[direccion_facturacion]" value="@%db:Clientes.direccion_facturacion;%@" class="insertext" size="30"></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="@%db:Clientes.cp;%@" class="insertextnumeros" size="5"></td>
</tr>

<tr>
<td class="etiqueta">Province / État:</td>
<td><!--@%db:Clientes.id_provincia;%@ @%set:_selected_value=Clientes.id_provincia;%@-->
<select name="registro[id_provincia]" class="insertext">
@%where:tabla|Provincias;order|nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia}%@ 
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select></td>
<td class="etiqueta">Personne de contact:</td>
<td><input type="text" name="registro[persona_contacto]" value="@%db:Clientes.persona_contacto;%@" class="insertext" size="30"></td>
</tr>

<tr>
<td class="etiqueta">Téléphone 1:</td>
<td><input type="text" name="registro[telefono1]" value="@%db:Clientes.telefono1;%@" class="insertextnumeros" size="14"></td>
<td class="etiqueta">Charge de contact:</td>
<td><input type="text" name="registro[cargo_persona_contacto]" value="@%db:Clientes.cargo_persona_contacto;%@" class="insertext" size="30"></td>
</tr>

<tr>
<td class="etiqueta">Téléphone 2:</td>
<td><input type="text" name="registro[telefono2]" value="@%db:Clientes.telefono2;%@" class="insertextnumeros" size="14"></td>
<td class="etiqueta">Web:</td>
<td><input type="text" name="registro[web]" value="@%db:Clientes.web;%@" class="insertext" size="30"></td>
</tr>

<tr>
<td class="etiqueta">Télécopieur:</td>
<td><input type="text" name="registro[fax]" value="@%db:Clientes.fax;%@" class="insertextnumeros" size="14"></td>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="registro[email]" value="@%db:Clientes.email;%@" class="insertext" size="20"></td>
</tr>

</table>
</fieldset>

