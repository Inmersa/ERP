<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="9" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="100">Type</td>
 <td></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="400">Description</td>
 <td class="etiqueta" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="80" align="center">TVA</td>
 <td class="etiqueta" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="90" align="center">Reteneu équivalent </td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_tipo_cliente" action="" method=post>
 <input type=hidden name=estado value=3>


@%where:tabla|Tipo_cliente;nombre|busc;%@ 

<tr> <td colspan="9" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_tipo_cliente;%@<a href="?seccion=modif_tipo_cliente&id_tipo_cliente=@%db:Tipo_cliente.id_tipo_cliente;%@" class="accesos">@%db:Tipo_cliente.nombre;%@</a></td>
 @%end-if:%@
 <td class="etiqueta" height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" >@%db:Tipo_cliente.descripcion;%@</td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" align="center">@%db:Tipo_cliente.aplicar_iva%@</td>
 <td class="etiqueta" height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" align="center">@%db:Tipo_cliente.aplicar_recargo%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" colspan="8"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="8"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ 
</form>
 <tr> <td height="22" colspan="9" ></td>
 </tr>
 <tr align="center"> <td colspan="9" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>

