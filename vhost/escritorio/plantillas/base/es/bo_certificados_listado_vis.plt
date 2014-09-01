<table width="647" border="0" cellspacing="0" cellpadding="0">
<tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22" class="etiqueta" align="right" bgcolor="#CCD2D7">
 <a href="javascript:document.forms['modif_certificados'].submit();" class="accesos">Borrar seleccionados</a> 
</td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="150">Nombre</td>
 <td class="etiqueta" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="300">Descripción</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="100" align="center" >Responsable</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>

 <form name="modif_certificados" action="" method=post>
 <input type=hidden name=estado value=3>

 @%where:tabla|Certificados;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td colspan="6" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> <input type="checkbox" name="registro_borrar[@%db:Certificados.id_certificado;%@]"value="1"/>
 </td>
 <td class="etiqueta" height="22" > <a href="?seccion=modif_certificados&id_certificado=@%db:Certificados.id_certificado;%@" class="accesos">@%db:Certificados.nombre;%@</a></td>
 <td height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" > @%db:Certificados.descripcion;%@</td>
 <td height="22" bgcolor="#CCD2D7" ></td>
 <td class="texto" height="22" align="center" >@%db:Certificados.responsable;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="619" colspan="5"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td height="1" bgcolor="#CCD2D7" width="619" colspan="5"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ 

</form>
 <tr> <td height="22" colspan="7" ></td>
 </tr>
 <tr align="center"> <td colspan="7" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="619" colspan="5"></td>
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
