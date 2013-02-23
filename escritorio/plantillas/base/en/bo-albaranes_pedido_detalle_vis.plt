 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="15" height="30"></td>
 </tr>
 <tr bgcolor="#CCD2D7" align="right"> <td colspan="15" height="22"><a href="" onclick="window.open('?seccion=bo_albaran_envio_print&id_albaran=@%db:Albaranes.id_albaran%@'); return false;" class="accesos">Print Order</a></td>
 </tr>
 <tr> <td colspan="15" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1">Code</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="75">Use-by date</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" width="60">Lot</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1" >Ordered Amount</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="titul1">Moved Amount</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="titul1" align="center" >Received amount </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="titul1" align="center" width="60" >Price</td>
 <td width="1" bgcolor="#DBE0E3" ></td>
 </tr>
 
@%where:tabla|Detalles_albaran;%@ <!--chapuza por culpa de ruta @%db:Detalles_albaran.id_detalle;%@-->
 <!--chapuza por culpa de ruta @%db:Articulos.id_articulo;%@-->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td ><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Detalles_albaran.lote;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%func:cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> @%db:Detalles_albaran.cantidad;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:cantidad_recibida;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="right">@%func:precio_articulo;%@&gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="9"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="2"></td>
 </tr>
 <tr> <td colspan="15" height="1" bgcolor="#DBE0E3"></td>
 </tr>

 @%end-where:%@ </table>

 @%end-where:%@


 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="center">
</td>
 </tr>
 </table>
 



