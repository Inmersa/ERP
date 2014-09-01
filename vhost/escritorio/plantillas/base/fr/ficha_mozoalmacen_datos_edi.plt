@%where:tabla|Mozos_almacen;%@

<fieldset id="Modif_Mozos_almacenDatos" class="fsficha">
<legend>Donnée général</legend>

<table class="full"><tbody>
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="Mozos_almacen[nombre]" value="@%db:Mozos_almacen.nombre;%@" class="texto" /></td>
<td class="etiqueta">Téléphone 1:</td>
<td><input type="text" name="Mozos_almacen[telefono1]" value="@%db:Mozos_almacen.telefono1;%@" class="telefono" /></td>
</tr>
<tr>
<td class="etiqueta">Surnom:</td>
<td><input type="text" name="Mozos_almacen[apellidos]" value="@%db:Mozos_almacen.apellidos;%@" class="texto" /></td>
<td class="etiqueta">Téléphone 2:</td>
<td><input type="text" name="Mozos_almacen[telefono2]" value="@%db:Mozos_almacen.telefono2;%@" class="telefono" /></td>
</tr>

<tr>
<td class="etiqueta">Direction:</td>
<td><input type="text" name="Mozos_almacen[direccion]" value="@%db:Mozos_almacen.direccion;%@" class="texto" /></td>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="Mozos_almacen[email]" value="@%db:Mozos_almacen.email;%@" class="email" /></td>
</tr>

<tr>
<td class="etiqueta">Ville:</td>
<td><input type="text" name="Mozos_almacen[poblacion]" value="@%db:Mozos_almacen.poblacion;%@" class="texto" /></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="Mozos_almacen[cp]" value="@%db:Mozos_almacen.cp;%@" size="6" /></td>
</tr>
<tr>
<td class="etiqueta">Province / État:</td>
<td colspan="1"><!-- @%db:Mozos_almacen.id_provincia;%@ @%set:_selected_value=Mozos_almacen.id_provincia;%@ -->
<select name="Mozos_almacen[id_provincia]">
 @%where:tabla|Provincias;order|Provincias.nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia}%@ 
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select></td>
<td class="etiqueta" >{{fld_notificarstock}}</td>
<td class="check" ><input type="checkbox" name="Mozos_almacen[notificar_stock]" value="1" @%db:check_flag{Mozos_almacen.notificar_stock};%@ />
(@%db:si_no_flag{Mozos_almacen.notificar_stock};%@)</td>
</tr></tbody></table>

<table class="full">
<caption >Compte bancaire IBAN</caption>
<tbody>
<tr>
 <td class="etiqueta">Pays / contrôle</td>
 <td><input type="text" name="Mozos_almacen[entidad]" value="@%db:Mozos_almacen.entidad;%@" class="mininum" /></td>
 <td class="etiqueta">Office</td>
 <td><input type="text" name="Mozos_almacen[oficina]" value="@%db:Mozos_almacen.oficina;%@" class="mininum" /></td>
 <td class="etiqueta" >Contrôle / Nº Compte</td>
 <td><input type="text" name="Mozos_almacen[dc_ccc]" value="@%db:Mozos_almacen.dc_ccc;%@" class="nanonum" />
 <input type="text" name="Mozos_almacen[cuenta_bancaria]" value="@%db:Mozos_almacen.cuenta_bancaria;%@" class="cc" /></td>
</tr>
 <tr>
 <td class="etiqueta">Société bancaire</td>
 <td><input type="text" name="Mozos_almacen[iban]" value="@%db:Mozos_almacen.iban;%@" class="mininum" /></td>
 <td class="etiqueta">Code Identificateur de Banque</td>
 <td><input type="text" name="Mozos_almacen[bic]" value="@%db:Mozos_almacen.bic;%@" class="longnum" /></td>
 <td class="etiqueta">Numéro de Compte Bancaire Base</td>
 <td><input type="text" name="Mozos_almacen[bban]" value="@%db:Mozos_almacen.bban;%@" class="bban" /></td>
</tr>
</tbody></table>
</fieldset>

