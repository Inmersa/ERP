<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="9" height="22" class="etiqueta" align="right" bgcolor="#CCD2D7">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="24"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="191">Nombre</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="213" >Pa�ses</td>
 <td class="etiqueta" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" >C�digo</td>
 <td class="etiqueta" width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" >Prefijo Tf.</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <form name="modif_provincias" action="" method=post>
 <input type=hidden name=estado value=3>


 @%where:tabla|Provincias;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td colspan="8" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="24" align="center"> </td>
 <td height="22" width="191">@%if:AllowedLink;modif_provincias;%@<a href="?seccion=modif_provincias&id_provincia=@%db:Provincias.id_provincia;%@" class="accesos">@%db:Provincias.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" height="22" width="213">@%db:Paises.nombre;%@</td>
 <td class="texto" height="22" width="1" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" align="center" >@%db:Provincias.codigo;%@</td>
 <td class="texto" height="22" bgcolor="#CCD2D7"></td>
 <td class="texto" height="22" align="center">@%db:Provincias.prefijo_tlf;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="191"></td>
 <td height="1" width="1"></td>
 <td height="1" width="427" colspan="5"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td height="1" bgcolor="#CCD2D7" width="191"></td>
 <td height="1" bgcolor="#CCD2D7" width="1"></td>
 <td height="1" bgcolor="#CCD2D7" width="427" colspan="5"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ 

</form>
 <tr> <td height="22" colspan="9" ></td>
 </tr>
 <tr align="center"> <td colspan="9" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="191"></td>
 <td height="1" width="1"></td>
 <td height="1" width="427" colspan="5"></td>
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
