<form name="nuevo_banco" action="?seccion=bo_bancos" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo">
<input type="hidden" name="banco[id_empresa]" value="@%get:id_empresa%@">

<fieldset id="Banco" class="fsficha">
<legend>Compte bancari</legend>
<table class="full">
<tr><td class="caption" colspan="2">Bancs</td>
</tr>

<tr>
<td class="etiqueta">Nom Banc</td>
<td><input type="text" name="banco[nombre]" size="80" value="" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Compte bancari IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Entitat</td>
 <td><input type="text" name="banco[entidad]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="banco[oficina]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">DC/ Nº Compte</td>
 <td><input type="text" name="banco[dc_ccc]" value="" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="" size="4" maxlength="4" /></td>
 <td class="etiqueta">Códi de Banc</td>
 <td><input type="text" name="banco[bic]" value="" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Compte Bancari Base</td>
 <td><input type="text" name="banco[bban]" value="" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Contacte</legend>
<table class="full">
<tr>
<td class="etiqueta">Adreça:</td>
<td><input type="text" name="banco[direccion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Població:</td>
<td><input type="text" name="banco[poblacion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Codi:</td>
<td><input type="text" name="banco[cp]" value="" /></td></tr>
<tr>
<td class="etiqueta">Telèfon:</td>
<td><input type="text" name="banco[telefono]" value="" /></td></tr>
<tr>
<td class="etiqueta">Fax:</td>
<td><input type="text" name="banco[fax]" value="" /></td></tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="banco[email]" value="" /></td></tr>
<tr>
<td class="etiqueta">Persona de contacte:</td>
<td><input type="text" name="banco[persona_contacto]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Càrrec de contacte:</td>
<td><input type="text" name="banco[cargo_contacto]" size="80" value="" /></td></tr>
</table>
</fieldset>

<fieldset id="CuentasContables" class="fsficha">
<legend>Comptes comptables</legend>
<table class="full">
<tr>
<td class="etiqueta">Compte comptable </td>
<td><input type="text" name="banco[cuenta_contable]" value="" /></td></tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('nuevo_banco');">Modificar</a></div>

