
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="etiqueta" bgcolor="#CCD2D7" >Comptes comptables:</td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">

 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">{{modif_proveedores_cuentas_vis.plt{{modif_proveedores_cuentas_vis.plt20}}}}:</td>
 <td colspan="3" class="texto"> @%db:Proveedores_empresas.cc_compras;%@
<input type="hidden" name="registro2[cc_compras]" value="@%db:Proveedores_empresas.cc_compras;%@" class="insertext" size="10" maxlength="10"/>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Remises:</td>
 <td colspan="3" class="texto"> @%db:Proveedores_empresas.cc_descuentos;%@
<input type="hidden" name="registro2[cc_descuentos]" value="@%db:Proveedores_empresas.cc_descuentos;%@" class="insertext" size="10" maxlength="10"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">{{modif_proveedores_cuentas_vis.plt3}}:</td>
 <td colspan="3" class="texto"> @%db:Proveedores_empresas.cc_gastos;%@
<input type="hidden" name="registro2[cc_gastos]" value="@%db:Proveedores_empresas.cc_gastos;%@" class="insertext" size="10" maxlength="10"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" height="22" align="right" class="etiqueta" width="161">Rétentions:</td>
 <td colspan="3" height="22" class="texto"> @%db:Proveedores_empresas.cc_retenciones;%@
<input type="hidden" name="registro2[cc_retenciones]" value="@%db:Proveedores_empresas.cc_retenciones;%@" class="insertext" size="10" maxlength="10">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Effets:</td>
 <td colspan="3" class="texto"> @%db:Proveedores_empresas.cc_efectos;%@
<input type="hidden" name="registro2[cc_efectos]" value="@%db:Proveedores_empresas.cc_efectos;%@" class="insertext" size="10" maxlength="10"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" class="etiqueta" height="22">
 <table width="644" border="0" cellspacing="0" cellpadding="0" class="etiqueta">
 <tr bgcolor="#CCD2D7"> <td height="22" width="161"></td>
 <td height="22" width="49" align="center">Pays / contrôle</td>
 <td height="22" width="68" align="center">Société bancaire</td>
 <td height="22" width="65" align="center">Office</td>
 <td height="22">Contrôle / Nº Compte</td>
 </tr>
 <tr> 
 <td width="161" align="right" bgcolor="#EBECED" height="22">Compte bancaire IBAN:</td>
 <td width="49" align="center"> 
 @%db:Proveedores_empresas.iban;%@<input type="hidden" name="registro2[iban]" value="@%db:Proveedores_empresas.iban;%@" size="4" maxlength="4" class="insertext">
 </td>
 <td width="68" align="center"> @%db:Proveedores_empresas.entidad;%@<input type="hidden" name="registro2[entidad]" value="@%db:Proveedores_empresas.entidad;%@" size="4" maxlength="4" class="insertext">
 </td>
 <td width="65" align="center"> @%db:Proveedores_empresas.oficina;%<input type="hidden" name="registro2[oficina]" value="@%db:Proveedores_empresas.oficina;%@" size="4" maxlength="4" class="insertext">
 </td>
 <td> @%db:Proveedores_empresas.cuenta_bancaria;%@<input type="hidden" name="registro2[cuenta_bancaria]" value="@%db:Proveedores_empresas.cuenta_bancaria;%@" class="insertext" size="12" maxlength="12">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="22"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td align="right" class="etiqueta" height="22" bgcolor="#EBECED">Début de période:</td>
 <td class="texto" height="22">@%db:colocar_fecha{Proveedores_empresas.fecha_alta};%@ <input type="hidden" name="registro2[fecha_alta]" value="@%db:Proveedores_empresas.fecha_alta;%@">
 </td>
 <td align="right" class="etiqueta" height="22" bgcolor="#EBECED">Actif:</td>
 <td class="etiqueta" height="22"> <!--@%db:Proveedores_empresas.activo;%@-->
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" height="1"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" height="22" align="right" class="etiqueta" valign="top">Observationes:</td>
 <td colspan="3" height="22" class="texto"> @%db:Proveedores_empresas.observaciones;%@ </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" class="etiqueta" align="right" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">% Rem.:</td>
 <td colspan="3" class="texto"> @%db:Proveedores_empresas.descuento;%@
<input type="hidden" name="registro2[descuento]" value="@%db:Proveedores_empresas.descuento;%@" class="insertext" size="4">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="4" height="1"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="8">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="162" bgcolor="#EBECED" align="right" class="etiqueta">Appliquer Majoration :</td>
 <td> <!--@%db:Proveedores.aplicar_recargo;%@-->
 </td>
 <td bgcolor="#EBECED" align="right" width="200" class="etiqueta">Actif Taxe (extracom.):</td>
 <td>
 <!--@%db:Proveedores.aplicar_iva;%@-->
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="4" height="1"></td>
 </tr>
 <tr> <td colspan="4" height="22"></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
<table width="644" border="0" height="22" cellspacing="0" cellpadding="0">
 <tr> 
 <td class="etiqueta" align0"right" width="200" bgcolor="#EBECED">Remise financier:</td>
 <td><input type="text" name="textfield">
 </td>
 </tr>
<tr><td height="22">
</td></tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCD2D7">
 <tr> 
 <td class="etiqueta" height="20" width="172" >Jours de paiement</td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="titocho" align="center" width="37">1</td>
 <td width="178"> <input type="text" name="textfield" class="insertextnumeros">
 </td>
 <td class="titocho" align="center" width="37">2</td>
 <td width="178"> <input type="text" name="textfield" class="insertextnumeros">
</td>
 <td class="titocho" align="center" width="37"> 3</td>
 <td width="177"> <input type="text" name="textfield" class="insertextnumeros">
</td>
 </tr>
</table>


