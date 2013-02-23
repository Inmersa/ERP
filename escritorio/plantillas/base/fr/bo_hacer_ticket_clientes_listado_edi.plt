<table width="647" border="0" cellspacing="0" cellpadding="0">Raison sociale
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
<form name="compra_articulos" method="post" action="?seccion=hacer_ticket">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="150" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="146" align="right"></td>
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
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Contact</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">NSF</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="30">TC</td>
 <td width="1"></td>
 </tr>
 <!-- aqui viene el registro -->
 <tr> <td></td>
 <td height="2"></td>
 <td></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="8"></td>
 </tr>
@%where:tabla|Clientes;nombre|busc;no_results|1;%@

 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Clientes.id_cliente;%@<br>
 <br>
 <br>
 </td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top"> <input type="radio" name="id_cliente" value="@%db:Clientes.id_cliente;%@" checked>
 </td>
 <td class="texto"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" class="accesos">@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a><br>
 @%db:Clientes.razon_social;%@<br>
 {{bo_hacer_ticket_clientes_listado_edi.plt6}} @%db:Clientes.poblacion;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Clientes.persona_contacto;%@ - @%db:Clientes.cargo_persona_contacto;%@<br>
 <a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a><br>
 Tél.: @%db:Clientes.telefono1;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Clientes.prefijo_cif;%@ - @%db:Clientes.cif;%@<br>
 <br>
 <br>
 </td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">P@%db:Tipo_cliente.nombre%@<br>
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
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> <td height="1" colspan="12" bgcolor="#DBE0E3"></td>
 </tr>
 <!-- Fin del registro -->
 @%end-where:%@

 </table>
 </td>
 </tr>
 <tr>
 <td align="center" height="30"> @%func:select_tarifas%@ </td>
 </tr>
 <tr>
 <td bgcolor="#CCD2D7" align="center" height="22"><a href="" onclick="document.forms['compra_articulos'].submit();return false;" class="accesos">Sélectionner</a>
<input type="hidden" name="Continuar" value="Continuar"></td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
</table>
