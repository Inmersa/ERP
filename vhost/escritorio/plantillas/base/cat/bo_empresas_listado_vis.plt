<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="bo_empresas" method="post" action="">
<input type="hidden" name="estado" value="3">
 <tr> <td bgcolor="#CCD2D7"> <table width="100%" cellpadding="0" cellspacing="0" border="0">
 <tr> <td align="center" height="22" width="484"></td>
 <td align="right" width="148"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="20" bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" colspan="2">Nom<span class="texto"></span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="100">Grup</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="100">CIF</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" bgcolor="#DBE0E3" width="200">Ra� social </td>
 <td width="1"></td>
 </tr>
 @%where:tabla|Empresas;%@ 
<!-- @%db:Empresas.id_grupo_empresa;%@ -->
 <tr> <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="9"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" valign="top" height="22"> </td>
 <td class="accesos" width="6"></td>
 <td class="accesos">@%if:AllowedLink;modif_empresas;%@<a href="?seccion=modif_empresas&id_empresa=@%db:Empresas.id_empresa;%@" class="accesos">@%db:Empresas.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> @%where:tabla|Grupo_empresas;%@ 
 @%db:Grupo_empresas.nombre;%@ 

@%end-where:%@ 

</td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Empresas.prefijo_cif;%@ - @%db:Empresas.cif;%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Empresas.razon_social;%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3" bgcolor="#DBE0E3"></td>
 <td height="3" colspan="2"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> <td height="1" colspan="10" bgcolor="#DBE0E3"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
</table>

