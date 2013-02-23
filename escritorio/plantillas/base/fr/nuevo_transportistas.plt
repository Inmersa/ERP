
<div class="tituloseccion">&gt; Fiche Transporteurs</div>


<form name="nuevo_transportistas" action="?seccion=bo_transportistas" method="post">
<input type="hidden" name="registro[id_transportista]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<table class="full">
<tbody>
<tr>
<tr><td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="30" /></td>
<td class="etiqueta">Surnom:</td>
<td><input type="text" name="registro[apellidos]" size="20" /></td>
</tr>

<tr><td class="etiqueta">Raison sociale:</td>
<td><input type="text" name="registro[razon_social]" size="30" /></td>
<td class="etiqueta">NSF:</td>
<td><input type="text" name="registro[cif]" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Direction:</td>
<td><input type="text" name="registro[direccion]" size="30" /></td>
<td class="etiqueta">Ville:</td>
<td><input type="text" name="registro[poblacion]" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Province / État:</td>
<td><select name="registro[id_provincia]">
@%where:tabla|Provincias;nolink|1;order|Provincias.nombre;%@
 <option value="@%db:Provincias.id_provincia;%@"
 >@%db:Provincias.nombre;%@ </option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" size="5" /></td>
</tr>

<tr><td class="etiqueta">Téléphone 1:</td>
<td><input type="text" name="registro[telefono]" size="14" /></td>
<td class="etiqueta">Téléphone 2:</td>
<td><input type="text" name="registro[telefono2]" size="14" /></td>
</tr>

<tr>
<td class="etiqueta">Télécopieur:</td>
<td><input type="text" name="registro[fax]" size="14" /></td>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="registro[email]" size="20" /></td>
</tr></tbody>
</table>

 <table class="full">
 <tr>
   <td class="caption" colspan="6">Compte bancaire IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Pays / contrôle</td>
 <td><input type="text" name="registro[entidad]" class="mininum" /></td>
 <td class="etiqueta">Office</td>
 <td><input type="text" name="registro[oficina]" class="text" /></td>
 <td class="etiqueta" >Contrôle / Nº Compte</td>
 <td><input type="text" name="registro[dc_ccc]" class="mininum" />
 <input type="text" name="registro[cuenta_bancaria]" class="text" /></td>
</tr>
 <tr>
 <td class="etiqueta">Société bancaire</td>
 <td><input type="text" name="registro[iban]" class="mininum" /></td>
 <td class="etiqueta">Code Identificateur de Banque</td>
 <td><input type="text" name="registro[bic]" class="minitext" /></td>
 <td class="etiqueta">Numéro de Compte Bancaire Base</td>
 <td><input type="text" name="registro[bban]" class="text" /></td>
 </tr>
</table>
</form>

<div class="AccionesEnvio" ><ul>
<li><a href="#" onClick="return sendForm('nuevo_transportistas');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li>
</ul></div>

