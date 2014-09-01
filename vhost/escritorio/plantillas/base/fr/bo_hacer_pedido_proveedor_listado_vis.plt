<table width="647" border="0" cellspacing="0" cellpadding="0">Raison sociale
 <tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
<form name="compra_articulos" method="post" action=""> <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table border="0" cellspacing="0" cellpadding="0">
 <tr> <td align="right">
 <td width="4"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" width="70" class="etiqueta">Code</td>
 <td width="1"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Client<span class="texto"> | Raz&oacute;n social</span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="170">Contact</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">NSF</td>
 <td width="1"></td>
 </tr>

 @%where:tabla|Proveedores;nombre|busc;no_results|1;%@

 <tr> <td></td>
 <td height="2"></td>
 <td></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="6"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Proveedores.id_proveedor;%@<br>
 <br>
 <br>
 </td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top"> </td>
 <td class="texto"> <p>@%if:AllowedLink;modif_proveedores;%@<a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@" class="accesos">@%db:Proveedores.nombre;%@</a><br>
 @%db:Proveedores.razon_social;%@<br>
 @%db:Proveedores.domicilio;%@ - @%db:Proveedores.poblacion;%@</p>
 </td>
 @%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td class="texto"> <p>@%db:Proveedores.persona_contacto;%@<br>
 <a href="mailto:@%db:Proveedores.email;%@" class="accesos">@%db:Proveedores.email;%@</a><br>
 @%db:Proveedores.telefono1;%@</p>
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Proveedores.prefijo_cif;%@ - @%db:Proveedores.cif;%@<br>
 <br>
 <br>
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3" bgcolor="#DBE0E3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> <td height="1" colspan="10" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@
 </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td> 
</td>
<input type="hidden" name="Continuar" value="Continuar">
 </tr>
 </table>
 </td>
 </tr>


 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@ 
</td>
 </tr>
</table>

