@%where:tabla|Bancos;where|Bancos.id_banco = $id_banco;%@
 <form name="ficha_banco" action="?seccion=bo_bancos_empresa" method="post">
 <input type="hidden" name="accion_ejecutar" value="Modificar" />
 <input type="hidden" name="banco[id_banco]" value="@%db:Bancos.id_banco%@" />
 <input type="hidden" name="banco[id_empresa]" value="@%db:Bancos.id_empresa%@" />


<fieldset id="BancoCC" class="fsficha">
<legend>Cuenta Bancaria</legend>
<table class="full">
<tr><td class="caption" colspan="2">Bancos</td>
</tr>

<tr>
<td class="etiqueta">Nombre de Banco</td>
<td><input type="text" name="banco[nombre]" size="80" value="@%db:Bancos.nombre%@" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Cuenta Bancaria IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="banco[entidad]" value="@%db:Bancos.entidad%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="banco[oficina]" value="@%db:Bancos.oficina%@" size="5" maxlength="4" /></td>
 <td class="etiqueta">DC / Nº Cuenta</td>
 <td><input type="text" name="banco[dc_ccc]" value="@%db:Bancos.dc_ccc%@" size="3" maxlength="2" />
 <input type="text" name="banco[cuenta_bancaria]" value="@%db:Bancos.cuenta_bancaria%@" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">IBAN</td>
 <td><input type="text" name="banco[iban]" value="@%db:Bancos.iban%@" size="4" maxlength="4" /></td>
 <td class="etiqueta">Código Identificador de Banco</td>
 <td><input type="text" name="banco[bic]" value="@%db:Bancos.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Número de Cuenta Bancaria Base</td>
 <td><input type="text" name="banco[bban]" value="@%db:Bancos.bban;%@" size="27" maxlength="26" class="insertext"></td>
</tr>
 </table>
</fieldset>

<fieldset id="DatosGenerales" class="fsficha">
<legend>Datos de Contacto</legend>
<table class="full">
<tr>
<td class="etiqueta">Dirección:</td>
<td>
 <input type="text" name="banco[direccion]" size="80" value="@%db:Bancos.direccion%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Población:</td>
<td>
 <input type="text" name="banco[poblacion]" size="80" value="@%db:Bancos.poblacion%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Código Postal:</td>
<td>
 <input type="text" name="banco[cp]" value="@%db:Bancos.cp%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Teléfono:</td>
<td>
 <input type="text" name="banco[telefono]" value="@%db:Bancos.telefono%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Fax:</td>
<td>
 <input type="text" name="banco[fax]" value="@%db:Bancos.fax%@" /></td>
 </tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td>
 <input type="text" name="banco[email]" value="@%db:Bancos.email%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Nombre de Persona de contacto:</td>
<td>
 <input type="text" name="banco[persona_contacto]" size="80" value="@%db:Bancos.persona_contacto%@" /></td>
 </tr>
<tr>
<td class="etiqueta">Cargo de persona de contacto:</td>
<td>
 <input type="text" name="banco[cargo_contacto]" size="80" value="@%db:Bancos.cargo_contacto%@" /></td>
 </tr>
</table>
</fieldset>

<fieldset id="Devoluciones" class="fsficha">
<legend>Bancos Devoluciones</legend>
<div class="barraoscura"><a href="#" onClick="return onHRefClick('ficha_banco','accion_ejecutar','Borrar_Devolucion');">Borrar seleccionados</a></div>
<table class="full">
<tr>
<td></td>
<td class="caption">Cantidad Inicial</td>
<td class="caption">Cantidad Final</td>
<td class="caption">Comisión (%)</td>
<td class="caption">Comisión (Cantidad)</td>
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
<legend>Cuentas Contables</legend>
<table class="full">
<tr>
<td class="etiqueta">Cuenta Contable </td>
<td>
 <input type="hidden" name="cc_old[cuenta_contable]" value="@%db:Bancos.cuenta_contable%@" />
 <input type="text" name="banco[cuenta_contable]" value="@%db:Bancos.cuenta_contable%@" /></td>
 </tr>
</table>
</fieldset>


<div class="enviar"><a href="#" onClick="return sendForm('ficha_banco');">Modificar</a></div>


