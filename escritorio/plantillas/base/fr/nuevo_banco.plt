<form name="nuevo_banco" action="?seccion=bo_bancos" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo">
<input type="hidden" name="banco[id_empresa]" value="@%get:id_empresa%@">

<fieldset id="Banco" class="fsficha">
<legend>Compte Bancaire</legend>
<table class="full">
<tr><td class="caption" colspan="2">Banqe</td>
</tr>

<tr>
<td class="etiqueta">Nom banque</td>
<td><input type="text" name="banco[nombre]" size="80" value="" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Compte bancaire IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Société bancaire</td>
 <td><input type="text" name="banco[entidad]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Office</td>
 <td><input type="text" name="banco[oficina]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Contrôle / Nº Compte</td>
 <td><input type="text" name="banco[dc_ccc]" value="" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="" size="4" maxlength="4" /></td>
 <td class="etiqueta">Code Identificateur de Banque</td>
 <td><input type="text" name="banco[bic]" value="" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Numéro de Compte Bancaire Base</td>
 <td><input type="text" name="banco[bban]" value="" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Contact</legend>
<table class="full">
<tr>
<td class="etiqueta">Direction:</td>
<td><input type="text" name="banco[direccion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Ville:</td>
<td><input type="text" name="banco[poblacion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Code:</td>
<td><input type="text" name="banco[cp]" value="" /></td></tr>
<tr>
<td class="etiqueta">Téléphone:</td>
<td><input type="text" name="banco[telefono]" value="" /></td></tr>
<tr>
<td class="etiqueta">Télécopieur:</td>
<td><input type="text" name="banco[fax]" value="" /></td></tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="banco[email]" value="" /></td></tr>
<tr>
<td class="etiqueta">Personne de contact:</td>
<td><input type="text" name="banco[persona_contacto]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Charge de contact:</td>
<td><input type="text" name="banco[cargo_contacto]" size="80" value="" /></td></tr>
</table>
</fieldset>

<fieldset id="CuentasContables" class="fsficha">
<legend>Compte comptable</legend>
<table class="full">
<tr>
<td class="etiqueta">Compte comptable </td>
<td><input type="text" name="banco[cuenta_contable]" value="" /></td></tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('nuevo_banco');">Modifier</a></div>

