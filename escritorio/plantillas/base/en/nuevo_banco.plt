<form name="nuevo_banco" action="?seccion=bo_bancos" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo">
<input type="hidden" name="banco[id_empresa]" value="@%get:id_empresa%@">

<fieldset id="Banco" class="fsficha">
<legend>Bank Account</legend>
<table class="full">
<tr><td class="caption" colspan="2">Banks</td>
</tr>

<tr>
<td class="etiqueta">Bank name</td>
<td><input type="text" name="banco[nombre]" size="80" value="" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Bank</td>
 <td><input type="text" name="banco[entidad]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Branch</td>
 <td><input type="text" name="banco[oficina]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">DC / Account Number</td>
 <td><input type="text" name="banco[dc_ccc]" value="" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="" size="4" maxlength="4" /></td>
 <td class="etiqueta">Bank Identifier Code</td>
 <td><input type="text" name="banco[bic]" value="" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Bank Basic Account Number</td>
 <td><input type="text" name="banco[bban]" value="" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Contact</legend>
<table class="full">
<tr>
<td class="etiqueta">Address:</td>
<td><input type="text" name="banco[direccion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">City:</td>
<td><input type="text" name="banco[poblacion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Code:</td>
<td><input type="text" name="banco[cp]" value="" /></td></tr>
<tr>
<td class="etiqueta">Telephone:</td>
<td><input type="text" name="banco[telefono]" value="" /></td></tr>
<tr>
<td class="etiqueta">Fax:</td>
<td><input type="text" name="banco[fax]" value="" /></td></tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="banco[email]" value="" /></td></tr>
<tr>
<td class="etiqueta">Contact person:</td>
<td><input type="text" name="banco[persona_contacto]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Contact role:</td>
<td><input type="text" name="banco[cargo_contacto]" size="80" value="" /></td></tr>
</table>
</fieldset>

<fieldset id="CuentasContables" class="fsficha">
<legend>Countable Accounts</legend>
<table class="full">
<tr>
<td class="etiqueta">Countable account </td>
<td><input type="text" name="banco[cuenta_contable]" value="" /></td></tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('nuevo_banco');">Modify</a></div>

