@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.id_cliente%@ -->

<fieldset class="fsficha">
<legend>Compte bancari IBAN</legend>
 <table class="full">
<tr>
 <td class="etiqueta">País / DC</td>
 <td><input type="text" name="registro2[entidad]" value="@%db:Clientes_empresas.entidad;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="registro2[oficina]" value="@%db:Clientes_empresas.oficina;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta" >DC/ Nº Compte</td>
 <td><input type="text" name="registro2[dc_ccc]" value="@%db:Clientes_empresas.dc_ccc;%@" size="2" maxlength="3" class="insertext">
 <input type="text" name="registro2[cuenta_bancaria]" value="@%db:Clientes_empresas.cuenta_bancaria;%@" class="insertext" size="11" maxlength="10"></td>
</tr>
 <tr>
 <td class="etiqueta">Entitat</td>
 <td><input type="text" name="registro2[iban]" value="@%db:Clientes_empresas.iban;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Códi de Banc</td>
 <td><input type="text" name="registro2[bic]" value="@%db:Clientes_empresas.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Compte Bancari Base</td>
 <td><input type="text" name="registro2[bban]" value="@%db:Clientes_empresas.bban;%@" size="27" maxlength="26" class="insertext"></td>
 </tr>
</table>
 </fieldset>

