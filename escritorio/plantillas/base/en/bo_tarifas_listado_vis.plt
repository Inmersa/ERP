<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Name</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">First discount</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Second discount</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Amount</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Action field</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <form name="modif_tarifas" action="" method=post>
 <input type=hidden name=estado value=3>


@%where:tabla|Tarifas;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="10" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_tarifas;%@<a href="?seccion=modif_tarifas&id_tarifa=@%db:Tarifas.id_tarifa;%@" class="accesos">@%db:Tarifas.nombre;%@
</a> </td>
@%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"> @%db:Tarifas.pto_primero;%@</td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto"> @%db:Tarifas.pto_segundo;%@ </td>
 <td bgcolor="DBE0E3"></td>
 <td class="texto"> @%db:Tarifas.monto;%@</td>
 <td bgcolor="DBE0E3"></td>
 <td class="texto"> @%db:Tarifas.campo_accion;%@ </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

@%end-where:%@

</form>

 <tr> <td height="22" colspan="11" ></td>
 </tr>
 <tr align="center"> <td colspan="11" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
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

