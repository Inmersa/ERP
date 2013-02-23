<table width="647" border="0" cellspacing="0" cellpadding="0">Company Name
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@ 
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="importar_clientes" action="" method="post">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" width="70" class="etiqueta">Code</td>
 <td width="1"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="170">Client<span class="texto"> | Raz&oacute;n social</span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="170">Contact</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">EIN</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <!-- aqui viene el registro -->
 @%where:tabla|Clientes;nombre|busc;%@ <tr> <td></td>
 <td height="2"></td>
 <td></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="6"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Clientes.id_cliente;%@<br>
 <br>
 <br>
 </td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top">
 @%if:cliente_empresa%@
 <input type="checkbox" name="importar_clientes[@%db:Clientes.id_cliente;%@]" value="1">
 @%else:%@

 @%end-if:%@
 </td>
 <td class="texto">@%if:AllowedLink;modif_clientes;%@<a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" class="accesos">@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a><br>
 @%db:Clientes.razon_social;%@<br>
 @%db:Provincias.nombre;%@ - @%db:Clientes.poblacion;%@</td>
@%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Clientes.cargo_persona_contacto;%@<br>
 <a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a><br>
 @%db:Clientes.telefono1;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Clientes.prefijo_cif;%@ - @%db:Clientes.cif;%@<br>
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
 @%end-where:%@ <tr bgcolor="#CCD2D7" align="center"> <td height="22" colspan="10"> <input type="hidden" name="accion_ejecutar" value="Importar">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="46">
@%plt:botonera%@ 
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
</table>

