@%where:tabla|Proveedores_empresas;where|Proveedores_empresas.id_empresa = $id_empresa AND Proveedores.id_proveedor = $id_proveedor_promocion;%@
<!-- @%db:Proveedores.id_proveedor%@ @%db:Proveedores_empresas.activo%@ -->

<table width="644" border="0" cellspacing="0" cellpadding="0" dwcopytype="CopyTableRow">
 <tr> <td width="161" align="right" bgcolor="#CCD2D7" height="22" class="etiqueta">Accès </td>
 <td height="22" align="right" bgcolor="#CCD2D7" class="etiqueta">Activo: @%db:si_no_flag{Proveedores_empresas.activo}%@
 <input type="hidden" name="registro2[activo]" value=1 @%func:chequear_activo%@>
 <!--@%db:Clientes_empresas.activo%@-->
 </td>
 </tr>
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Login:</td>
 <td width="483" class="texto"> @%func:nombre_login_real%@ <input type="hidden" name="registro[login]" value="@%func:nombre_login_real%@" class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Mot de passe:</td>
 <td width="483"> <input type="text" name=registro[passwd] class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Répéter mot de passe:</td>
 <td width="483"> <input type="text" name=registro[passwd2] class="insertext" size="20">
 </td>
 </tr>
</table>
