 <br>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="left" bgcolor="#CCD2D7" class="etiqueta"> Selecció Actuel</td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="cesta" method="post" action="?seccion=cli_confirmar_pedido">
 <tr> <td width="20" bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" colspan="2">Article </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="left" width="250">Descripció</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" bgcolor="#DBE0E3">Paquets</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" bgcolor="#DBE0E3">Quantitat</td>
 <td width="1" bgcolor="#DBE0E3"></td>
 </tr>
@%where:nodb|nodb_confirmar_pedido;%@
 <tr> <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="9"></td>
 </tr>

 <tr> <td bgcolor="#DBE0E3" valign="top" height="20"> <input type="checkbox" name="articulos_confirmados[@%db:id_articulo;%@][poner]" value="1" checked>
 <input type="hidden" name="articulos_confirmados[@%db:id_articulo;%@][quitar]" value="1"> </td>
 <td width="4"></td>
 <td>@%db:nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:descripcion;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" valign="middle" height="22"> <input type="text" name="array_bultos[@%db:id_articulo;%@]" value="@%db:bultos;%@" class="insertext" size="15"/>
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" valign="middle"> <input type="text" name="array_numero[@%db:id_articulo;%@]" value="@%db:cantidad;%@" class="insertext" size="15"/>
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3"></td>
 <td colspan="2"></td>
 <td ></td>
 <td></td>
 <td></td>
 <td ></td>
 <td ></td>
 <td ></td>
 <td ></td>
 </tr>
 <tr> <td height="1" colspan="10" bgcolor="#DBE0E3"></td>
 </tr>

 @%end-where:%@
 <tr> <td height="3" colspan="10" bgcolor="#FFFFFF"></td>
 </tr>
 <tr align="center"> <td height="22" colspan="10" bgcolor="#CCD2D7"><a href="" onclick="document.forms['cesta'].submit();return false;" class="accesos">Finalitzar</a> <input type="hidden" name="Finalizar" value="Finalizar"></td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 </table>