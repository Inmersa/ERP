<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" colspan="7" align="center" class="etiqueta" >Cantidades</td>
 <td height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" colspan="3" align="center" class="etiqueta" >Proveedor</td>
 <td height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" colspan="3" align="center" class="etiqueta" >Cliente</td>
 <td height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 <td bgcolor="#CCD2D7" height="22" ></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" width="90">Ref.</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Nombre</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Pedida</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Recibida</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Pedida</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Recibida</td>
 <td width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Diferencial</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="15" height="1"></td>
 </tr>

 @%where:tabla|Compra_articulos;nombre|busc;no_results|1;%@

 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td class="texto" height="22">@%db:Compra_articulos.referencia;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Articulos.nombre;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:cantidad;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:cantidad_recibida;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%func:cantidad_clientes;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%func:cantidad_clientes_recibida;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%func:cantidad_diferencial%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%end-where:%@ <tr> <td height="22" colspan="15" ></td>
 </tr>
 <tr align="center"> <td colspan="15" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">

 @%plt:botonera%@ 
 </td>
 </tr>
</table>

