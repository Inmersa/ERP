<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td colspan="5" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Nome</td>
 <td height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Descrição</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

<form name="modif_tipo_agente" action="" method=post>
 <input type=hidden name=estado value=3>



 @%where:tabla|Tipo_agente;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22" width="200">@%if:AllowedLink;modif_tipo_agente;%@<a href="?seccion=modif_tipo_agente&id_tipo_agente=@%db:Tipo_agente.id_tipo_agente;%@" class="accesos">@%db:Tipo_agente.nombre;%@</a></td>
 @%end-if:%@
 <td height="22" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" width="622">@%db:Tipo_agente.descripcion;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="4"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ 

</form>
 <tr> <td height="22" colspan="5" > </td>
 </tr>
 <tr align="center"> <td colspan="5" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>

