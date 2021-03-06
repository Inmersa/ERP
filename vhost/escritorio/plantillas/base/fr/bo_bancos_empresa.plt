@%where:tabla|Bancos;where|Bancos.id_banco = $id_banco;%@
 <form name="ficha_banco" action="?seccion=bo_bancos_empresa" method="post">
 <input type="hidden" name="accion_ejecutar" value="Modificar" />
 <input type="hidden" name="banco[id_banco]" value="@%db:Bancos.id_banco%@" />
 <input type="hidden" name="banco[id_empresa]" value="@%db:Bancos.id_empresa%@" />


<fieldset id="BancoCC" class="fsficha">
<legend>Compte Bancaire</legend>
<table class="full">
<tr><td class="caption" colspan="2">Banqe</td>
</tr>

<tr>
<td class="etiqueta">Nom banque</td>
<td><input type="text" name="banco[nombre]" size="80" value="@%db:Bancos.nombre%@" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Compte bancaire IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Soci�t� bancaire</td>
 <td><input type="text" name="banco[entidad]" value="@%db:Bancos.entidad%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">Office</td>
 <td><input type="text" name="banco[oficina]" value="@%db:Bancos.oficina%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">Contr�le / N� Compte</td>
 <td><input type="text" name="banco[dc_ccc]" value="@%db:Bancos.dc_ccc%@" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="@%db:Bancos.cuenta_bancaria%@" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="@%db:Bancos.iban%@" size="4" maxlength="4" /></td>
 <td class="etiqueta">Code Identificateur de Banque</td>
 <td><input type="text" name="banco[bic]" value="@%db:Bancos.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Num�ro de Compte Bancaire Base</td>
 <td><input type="text" name="banco[bban]" value="@%db:Bancos.bban;%@" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Contact</legend>
<table class="full">
<tr>
<td class="etiqueta">Direction:</td>
<td>
 <input type="text" name="banco[direccion]" size="80" value="@%db:Bancos.direccion%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Ville:</td>
<td>
 <input type="text" name="banco[poblacion]" size="80" value="@%db:Bancos.poblacion%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Code:</td>
<td>
 <input type="text" name="banco[cp]" value="@%db:Bancos.cp%@" /></td>
 </tr>
<tr>
<td class="etiqueta">T�l�phone:</td>
<td>
 <input type="text" name="banco[telefono]" value="@%db:Bancos.telefono%@" /></td>
 </tr>
<tr>
<td class="etiqueta">T�l�copieur:</td>
<td>
 <input type="text" name="banco[fax]" value="@%db:Bancos.fax%@" /></td>
 </tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td>
 <input type="text" name="banco[email]" value="@%db:Bancos.email%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Personne de contact:</td>
<td>
 <input type="text" name="banco[persona_contacto]" size="80" value="@%db:Bancos.persona_contacto%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Charge de contact:</td>
<td>
 <input type="text" name="banco[cargo_contacto]" size="80" value="@%db:Bancos.cargo_contacto%@" /></td>
 </tr>
</table>
</fieldset>

<fieldset id="Devoluciones" class="fsficha">
<legend>Banqe retoures</legend>
<div class="barraoscura"><a href="#" onClick="return onHRefClick('ficha_banco','accion_ejecutar','Borrar_Devolucion');">Elimier</a></div>
<table class="full">
<tr>
<td></td>
<td class="caption">Initial quantite</td>
<td class="caption">Final quantite</td>
<td class="caption">Commission (%)</td>
<td class="caption">Commission (Quantite)</td>
</tr>
 @%where:tabla|Bancos_devoluciones;contador|count;%@
<tr>
 <input type="hidden" name="bancos_devolucion[@%db:count%@][id_banco]" value="@%db:Bancos_devoluciones.id_banco%@" />
 <input type="hidden" name="bancos_devolucion[@%db:count%@][id_devolucion]" value="@%db:Bancos_devoluciones.id_devolucion%@" />
<td class="check"><input type="checkbox" name="borrar_devolucion[]" value="@%db:Bancos_devoluciones.id_devolucion%@" /></td>
<td>
 <input type="text" name="bancos_devolucion[@%db:count%@][monto_inicial]" value="@%db:Bancos_devoluciones.monto_inicial%@" /></td>
<td>
 <input type="text" name="bancos_devolucion[@%db:count%@][monto_final]" value="@%db:Bancos_devoluciones.monto_final%@" /></td>
<td>
 <input type="text" name="bancos_devolucion[@%db:count%@][comision]" value="@%db:Bancos_devoluciones.comision%@" /></td>
<td>
 <input type="text" name="bancos_devolucion[@%db:count%@][importe]" value="@%db:Bancos_devoluciones.importe%@" /></td>
 </tr>
 @%end-where:%@




 <input type="hidden" name="bancos_devolucion[nuevo][id_banco]" value="@%db:Bancos.id_banco%@" />
<tr>
<td></td>
<td>
 <input type="text" name="bancos_devolucion[nuevo][monto_inicial]" /></td>
<td>
 <input type="text" name="bancos_devolucion[nuevo][monto_final]" /></td>
<td>
 <input type="text" name="bancos_devolucion[nuevo][comision]" /></td>
<td>
 <input type="text" name="bancos_devolucion[nuevo][importe]" /></td>
 </tr>
</table>
</fieldset>


<fieldset id="CuentasContables" class="fsficha">
<legend>Compte comptable</legend>
<table class="full">
<tr>
<td class="etiqueta">Compte comptable </td>
<td>
 <input type="hidden" name="cc_old[cuenta_contable]" value="@%db:Bancos.cuenta_contable%@" />
 <input type="text" name="banco[cuenta_contable]" value="@%db:Bancos.cuenta_contable%@" /></td>
 </tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('ficha_banco');">Modifier</a></div>


