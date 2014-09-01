@%where:tabla|Empresarios;%@

<fieldset id="Modif_EmpresariosDatos" class="fsficha">
<legend>Datos Generales</legend>

<table class="full">
<tr>
<td class="etiqueta">Nombre:</td>
<td><input type="text" name="Empresarios[nombre]" value="@%db:Empresarios.nombre;%@" class="texto" /></td>
<td class="etiqueta">Teléfono 1:</td>
<td><input type="text" name="Empresarios[telefono1]" value="@%db:Empresarios.telefono1;%@" class="telefono" /></td>
</tr>
<tr>
<td class="etiqueta">Apellidos:</td>
<td><input type="text" name="Empresarios[apellidos]" value="@%db:Empresarios.apellidos;%@" class="texto" /></td>
<td class="etiqueta">Teléfono 2:</td>
<td><input type="text" name="Empresarios[telefono2]" value="@%db:Empresarios.telefono2;%@" class="telefono" /></td>
</tr>

<tr>
<td class="etiqueta">Dirección:</td>
<td><input type="text" name="Empresarios[direccion]" value="@%db:Empresarios.direccion;%@" class="texto" /></td>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="Empresarios[email]" value="@%db:Empresarios.email;%@" class="email" /></td>
</tr>

<tr>
<td class="etiqueta">Población:</td>
<td><input type="text" name="Empresarios[poblacion]" value="@%db:Empresarios.poblacion;%@" class="texto" /></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="Empresarios[cp]" value="@%db:Empresarios.cp;%@" size="6" /></td>
</tr>
<tr>
<td class="etiqueta">Provincia:</td>
<td colspan="3"><!-- @%db:Empresarios.id_provincia;%@ @%set:_selected_value=Empresarios.id_provincia;%@ -->
<select name="Empresarios[id_provincia]">
 @%where:tabla|Provincias;order|Provincias.nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia}%@ 
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select></td>
</tr>

</table>

<table class="full">
<caption >Cuenta Bancaria IBAN</caption>
<tbody>
<tr>
 <td class="etiqueta">País/DC</td>
 <td><input type="text" name="Empresarios[entidad]" value="@%db:Empresarios.entidad;%@" class="mininum" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="Empresarios[oficina]" value="@%db:Empresarios.oficina;%@" class="mininum" /></td>
 <td class="etiqueta" >DC / Nº Cuenta</td>
 <td><input type="text" name="Empresarios[dc_ccc]" value="@%db:Empresarios.dc_ccc;%@" class="nanonum" />
 <input type="text" name="Empresarios[cuenta_bancaria]" value="@%db:Empresarios.cuenta_bancaria;%@" class="cc" /></td>
</tr>
 <tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="Empresarios[iban]" value="@%db:Empresarios.iban;%@" class="mininum" /></td>
 <td class="etiqueta">Código Identificador de Banco</td>
 <td><input type="text" name="Empresarios[bic]" value="@%db:Empresarios.bic;%@" class="longnum" /></td>
 <td class="etiqueta">Número de Cuenta Bancaria Base</td>
 <td><input type="text" name="Empresarios[bban]" value="@%db:Empresarios.bban;%@" class="bban" /></td>
</tr>
</tbody></table>
</fieldset>

