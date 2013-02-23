 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <td bgcolor="#CCD2D7" height="22" align="center"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="etiqueta" width="449" >Warehouse Zones</td>
 <td align="center" width="144" ></td>
 <td width="48" align="center" >
</td>
 </tr>
 </table>
 </td>
 <tr> <td bgcolor="#FFFFFF" height="8"> </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> <table width="500" border="0" cellspacing="0" cellpadding="0">
@%where:tabla|Almacenes_logicos;%@
 <tr> <td width="81"></td>
 <td width="22" bgcolor="#EBECED" height="22"> </td>
 <td width="10"></td>
 <td width="387">@%if:AllowedLink;modif_almacenes_logicos;%@<a href="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@" class="accesos"> @%db:Almacenes_logicos.nombre;%@</a></td>
@%end-if:%@
 </tr>
@%end-where:%@

 </table>
 </table>
