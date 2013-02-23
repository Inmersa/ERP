<form name="nuevo_banco" action="?seccion=bo_bancos" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo">
<input type="hidden" name="banco[id_empresa]" value="@%get:id_empresa%@">

<fieldset id="Banco" class="fsficha">
<legend>Cuenta Bancaria</legend>
<table class="full">
<tr><td class="caption" colspan="2">Bancos</td>
</tr>

<tr>
<td class="etiqueta">Nombre de Banco</td>
<td><input type="text" name="banco[nombre]" size="80" value="" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Cuenta Bancaria IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="banco[entidad]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="banco[oficina]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">DC / Nº Cuenta</td>
 <td><input type="text" name="banco[dc_ccc]" value="" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="" size="4" maxlength="4" /></td>
 <td class="etiqueta">Código Identificador de Banco</td>
 <td><input type="text" name="banco[bic]" value="" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Número de Cuenta Bancaria Base</td>
 <td><input type="text" name="banco[bban]" value="" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Datos de Contacto</legend>
<table class="full">
<tr>
<td class="etiqueta">Dirección:</td>
<td><input type="text" name="banco[direccion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Población:</td>
<td><input type="text" name="banco[poblacion]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Código Postal:</td>
<td><input type="text" name="banco[cp]" value="" /></td></tr>
<tr>
<td class="etiqueta">Teléfono:</td>
<td><input type="text" name="banco[telefono]" value="" /></td></tr>
<tr>
<td class="etiqueta">Fax:</td>
<td><input type="text" name="banco[fax]" value="" /></td></tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><input type="text" name="banco[email]" value="" /></td></tr>
<tr>
<td class="etiqueta">Nombre de Persona de contacto:</td>
<td><input type="text" name="banco[persona_contacto]" size="80" value="" /></td></tr>
<tr>
<td class="etiqueta">Cargo de persona de contacto:</td>
<td><input type="text" name="banco[cargo_contacto]" size="80" value="" /></td></tr>
</table>
</fieldset>

<fieldset id="CuentasContables" class="fsficha">
<legend>Cuentas Contables</legend>
<table class="full">
<tr>
<td class="etiqueta">Cuenta Contable </td>
<td><input type="text" name="banco[cuenta_contable]" value="" /></td></tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('nuevo_banco');">Modificar</a></div>

