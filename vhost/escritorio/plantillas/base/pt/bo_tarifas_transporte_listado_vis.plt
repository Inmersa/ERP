<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="9" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Nome</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Peso Inicial</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Peso Final</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Custo</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:tabla|Tarifas_transporte;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="8" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_tarifas_transporte;%@<a href="?seccion=modif_tarifas_transporte&id_tarifa_transporte=@%db:Tarifas_transporte.id_tarifa_transporte;%@" class="accesos">@%db:Tarifas_transporte.nombre;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Tarifas_transporte.peso_inicial;%@ </td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Tarifas_transporte.peso_final;%@</td>
 <td bgcolor="#DBE0E3" ></td>
 <td class="texto">@%db:Tarifas_transporte.costo;%@</td>
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
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%end-where:%@ <tr> <td height="22" colspan="9" ></td>
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

