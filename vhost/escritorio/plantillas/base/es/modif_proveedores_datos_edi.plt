 @%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor_promocion;%@
<fieldset class="fsficha">
<legend>Datos Generales</legend>

<table class="full">

<tr> <!--@%Proveedores.id_proveedor;%@-->
<td class="etiqueta">Nombre:</td>
<td><input type="text" name="registro[nombre]" size="30" value="@%db:Proveedores.nombre;%@" /></td>
<td class="etiqueta">NIF intracom.:</td>
<td>
 <input type="text" name="registro[prefijo_cif]" value="@%db:Proveedores.prefijo_cif;%@" size="2" maxlength="2" /></td>
 </tr>

<tr><td class="etiqueta">Razón social:</td>
<td><input type="text" name="registro[razon_social]" size="30" value="@%db:Proveedores.razon_social;%@" /></td>
<td class="etiqueta">NIF - CIF:</td>
<td><input type="text" name="registro[cif]" value="@%db:Proveedores.cif;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Domicilio:</td>
<td><input type="text" name="registro[domicilio]" value="@%db:Proveedores.domicilio;%@" size="30" /></td>
<td class="etiqueta">Población:</td>
<td><input type="text" name="registro[poblacion]" value="@%db:Proveedores.poblacion;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Provincia:</td>
<td><select name="registro[id_provincia]">
 <option value="">-- Ninguna seleccion --</option>
 <!-- @%db:Proveedores.id_provincia;%@ @%set:_selected_value = Proveedores.id_provincia;%@-->
 @%where:tabla|Provincias;nolink|1;order|nombre;%@
 <option value="@%db:Provincias.id_provincia;%@" 
 @%db:selected_value{Provincias.id_provincia};%@
 >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="@%db:Proveedores.cp;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Persona de contacto:</td>
<td><input type="text" name="registro[persona_contacto]" value="@%db:Proveedores.persona_contacto;%@" size="30" /></td>
<td class="etiqueta">Teléfono 1:</td>
<td><input type="text" name="registro[telefono1]" value="@%db:Proveedores.telefono1;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Cargo Contacto:</td>
<td><input type="text" name="registro[cargo_persona_contacto]" value="@%db:Proveedores.cargo_persona_contacto;%@" size="30" /></td>
<td class="etiqueta">Teléfono 2:</td>
<td><input type="text" name="registro[telefono2]" value="@%db:Proveedores.telefono2;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">web:</td>
<td><input type="text" name="registro[web]" value="@%db:Proveedores.web;%@" size="30" /></td>
<td class="etiqueta">Fax:</td>
<td><input type="text" name="registro[fax]" value="@%db:Proveedores.fax;%@" size="20" /></td>
 </tr>

<tr><td class="etiqueta">e-mail:</td>
<td colspan="3" ><input type="text" name="registro[email]" value="@%db:Proveedores.email;%@" size="20" /></td>
</tr>
</table>
</fieldset>

