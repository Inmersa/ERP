<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="323" >&gt; SELECCION DE ARTICULOS</td>
 <td width="318" align="right" > <table width="50" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td ><a href="javascript: history.go(-1);" class="accesos">Volver</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="194" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> <td class="texto">Resultados obtenidos :
@%func:numero_resultados;%@
</td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td bgcolor="#FFFFFF" width="3"></td>
 <td bgcolor="#E8F0B5" valign="top"> <table width="449" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="hacer_pedido" method="post" action="?seccion=cli_hacer_pedido">
 <input type="hidden" name="force_" value="1">
 <tr> <td width="1" bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" colspan="2">Nombre<span class="texto"></span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="left" width="250">Descripción</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="left" width="0">Precio </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="left" width="0">IVA / Recargo</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Bultos</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Cantidad</td>
 <td width="1"></td>
 <td align="center" class="etiqueta" colspan="3" bgcolor="#DBE0E3">Ofer./Promos</td>
 <td width="1" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:tabla|Articulos;nombre|busc;no_results|1;%@ <tr> <td height="1" colspan="18"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" valign="top" height="20"></td>
 <td class="accesos" width="4"></td>
 <td class="accesos">@%db:Articulos.nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Articulos.descripcion;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" >@%func:precio_visible%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" >@%db:Tipos_IVA.porcentaje;%@/@%db:Tipos_IVA.recargo_equivalente;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> <input type="text" name="array_bultos[@%db:Articulos.id_articulo;%@]" value=0 size="5" class="insertext">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center"> <input type="text" name="array_numero[@%db:Articulos.id_articulo;%@]" value=0 size="5" class="insertext">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" height="22" colspan="3" class="texto">@%func:descripcion_descuento%@ </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3" ></td>
 <td height="3" colspan="2"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3" colspan="5"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> <td height="1" colspan="18" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@ <tr> <td height="3" colspan="18" bgcolor="#FFFFFF"></td>
 </tr>
 <tr> <td height="22" colspan="18" align="center" bgcolor="#CCD2D7"> <input type="hidden" name="Anyadir" value="Añadir">
 <a href="" onclick="document.forms['hacer_pedido'].submit();return false;"class="accesos">Añadir</a></td>
 </tr>
 </form>
 </table>
 

</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="10"></td>
 </tr>
</table>