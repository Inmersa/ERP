<div class="barraoscura"><div class="titsuperior">&gt; Nou Proveïdor</div></div>

<form name="nuevo_proveedores" action="?seccion=bo_proveedores" method="post">
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<input type="hidden" name="registro[id_proveedor]" value="NULL" />

<fieldset id="Datos_Generales" class="fsficha">
<legend>Dades generals</legend>
<table class="full">
<tr> 
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="30" value="" /></td>
<td class="etiqueta">NIF intracom.:</td>
<td>
 <input type="text" name="registro[prefijo_cif]" value="" size="2" maxlength="2" /></td>
 </tr>

<tr><td class="etiqueta">Raó social:</td>
<td><input type="text" name="registro[razon_social]" size="30" value="" /></td>
<td class="etiqueta">NIF:</td>
<td><input type="text" name="registro[cif]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Domicili:</td>
<td><input type="text" name="registro[domicilio]" value="" size="30" /></td>
<td class="etiqueta">Població:</td>
<td><input type="text" name="registro[poblacion]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Província:</td>
<td><select name="registro[id_provincia]">
 <option value="">Cap selecció</option>
 @%where:tabla|Provincias;nolink|1;order|nombre;%@
 <option value="@%db:Provincias.id_provincia;%@" 
 >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select></td>
<td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Persona de contacte:</td>
<td><input type="text" name="registro[persona_contacto]" value="" size="30" /></td>
<td class="etiqueta">Telèfon 1:</td>
<td><input type="text" name="registro[telefono1]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">Càrrec de contacte:</td>
<td><input type="text" name="registro[cargo_persona_contacto]" value="" size="30" /></td>
<td class="etiqueta">Telèfon 2:</td>
<td><input type="text" name="registro[telefono2]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">web:</td>
<td><input type="text" name="registro[web]" value="" size="30" /></td>
<td class="etiqueta">Fax:</td>
<td><input type="text" name="registro[fax]" value="" size="20" /></td>
 </tr>

<tr><td class="etiqueta">e-mail:</td>
<td colspan="3"><input type="text" name="registro[email]" value="" size="20" /></td>
</tr>
</table>

</fieldset>

<fieldset id="Descuentos_Volumen" class="fsficha">
<legend>Descomptes per volum</legend>

<table class="full">
<tr><td class="etiqueta">% Desc. Paquet:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto]" value="" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_bulto_uds]" value="" size="5" maxlength="5" /></td>
 </tr>

<tr><td class="etiqueta">% Desc. Capa:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa]" value="" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_capa_uds]" value="" size="5" maxlength="5" /></td>
 </tr>

<tr><td class="etiqueta">% Desc. Palet:</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet]" value="" size="5" maxlength="5" /></td>
<td class="etiqueta">Unit. Min :</td>
<td colspan="1"><input type="text" name="registro[dto_gnrl_vol_palet_uds]" value="" size="5" maxlength="5" /></td>
</tr>
</table>
</fieldset>

<fieldset id="Datos_Para" class="fsficha">
<legend>Dades generals</legend>

<table class="full">

<tr><td class="etiqueta">Mig de paga:</td>
<td><select name="registro2[id_forma_pago]">
@%where:tabla|Forma_pago;nolink|1;order|nombre;%@
 <option value="@%db:Forma_pago.id_forma_pago;%@" 
 >@%db:Forma_pago.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
<tr><td class="etiqueta">Divisa:</td>
<td><select name="registro[id_divisa]">
@%where:tabla|Divisa;nolink|1;order|nombre;%@
 <option value="@%db:Divisa.id_divisa;%@" 
 >@%db:Divisa.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
<tr><td class="etiqueta">Retenció:</td>
<td> <input type="text" name="registro[retencion]" value="" size="5" maxlength="5" /></td>
</tr>
</table>
</fieldset>


<fieldset id="Cuentas" class="fsficha">
<legend>Comptes comptables:</legend>
<table class="full">

<tr><td class="etiqueta">Proveïdor:</td>
<td > <input type="text" name="registro2[cc_proveedor]" value="" size="20" maxlength="10" /></td>
<td class="etiqueta">Compres:</td>
<td > <input type="text" name="registro2[cc_compras]" value="" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Descompte financier:</td>
<td > <input type="text" name="registro2[cc_descuento_financiero]" value="" size="20" maxlength="10" /></td>
<td class="etiqueta">Descomptes:</td>
<td > <input type="text" name="registro2[cc_descuento_comercial]" value="" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Consumacions:</td>
<td > <input type="text" name="registro2[cc_gastos]" value="" size="20" maxlength="10" /></td>
<td class="etiqueta">Retencións:</td>
<td > <input type="text" name="registro2[cc_retenciones]" value="" size="20" maxlength="10" /></td>
 </tr>

<tr><td class="etiqueta">Efectes:</td>
<td colspan="3"> <input type="text" name="registro2[cc_efectos]" value="" size="20" maxlength="10" /></td>
</tr>
</table>

<table class="full">
<tr>
<td class="caption" colspan="6">Compte bancari IBAN</td>
</tr>
<tr>
<td class="etiqueta">Entitat</td>
<td><input type="text" name="registro2[entidad]" value="" size="5" maxlength="4" /></td>
<td class="etiqueta">Oficina</td>
<td><input type="text" name="registro2[oficina]" value="" size="5" maxlength="4" /></td>
<td class="etiqueta" >DC/ Nº Compte</td>
<td><input type="text" name="registro2[dc_ccc]" value="" size="3" maxlength="2" />
<input type="text" name="registro2[cuenta_bancaria]" value="" size="11" maxlength="10" /></td>
</tr>
<tr>
 <td class="etiqueta">País / DC</td>
 <td><input type="text" name="registro2[iban]" value="" size="5" maxlength="4" /></td>
 <td class="etiqueta">Códi de Banc</td>
 <td><input type="text" name="registro2[bic]" value="" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Compte Bancari Base</td>
 <td><input type="text" name="registro2[bban]" value="" size="27" maxlength="26" class="insertext"></td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Data de alta:</td>
<td><input type="text" name="registro2[fecha_alta]" value="dd/mm/aaaa" /></td>
<td class="etiqueta">Actiu:</td>
<td class="check"><input type="checkbox" name="registro2[activo]" value="1" /></td>
</tr>
</table>

<table class="full">
<tr><td class="etiqueta">Observacions:</td><td colspan="3"><textarea name="registro2[observaciones]" cols="50" rows="4"></textarea></td></tr>
<tr>
<td class="etiqueta">% Desc. Comercial:</td>
<td><input type="text" name="registro2[descuento]" value="" size="4" /></td>
<td class="etiqueta">% Desc. Financier:</td>
<td><input type="text" name="registro2[descuento_financiero]" size="4"   value="" /></td>
</tr>
<tr> 
<td class="etiqueta">Aplicar Rècarre:</td>
<td class="check"><input type="checkbox" name="registro2[aplicar_recargo]" value="1" /></td>
<td class="etiqueta">Mantenir Ratio Divisa (Dies):</td>
<td><input type="text" name="registro2[mantener_ratio_divisa]" value="" size="4" maxlength="4" /></td>
</tr>
<tr>
<td class="etiqueta">Aplicar IVA:</td>
<td class="check"><input type="checkbox" name="registro2[aplicar_iva]" value="1" /></td>
<td class="etiqueta">Aplicar Retenció:</td>
<td class="check">
<input type="checkbox" name="registro2[aplicar_retencion]" value="1" /></td>
</tr>
</table>
</fieldset>


<fieldset id="Dias_Facturacion" class="fsficha">
<legend>Dies de pagament</legend>
<table class="full">
<tr>
<td class="etiqueta"> Primer</td>
<td><input type="text" name="registro2[dia_facturacion_1]" size="2" value="" /></td>
<td class="etiqueta"> Segon</td>
<td><input type="text" name="registro2[dia_facturacion_2]" size="2" value="" /></td>
<td class="etiqueta"> Tercer</td>
<td><input type="text" name="registro2[dia_facturacion_3]" size="2" value="" /></td>
</tr>
</table>
</fieldset>
</form>

<div class="enviar"><a href="#" onClick="return sendForm('nuevo_proveedores');">Guardar</a></div>
