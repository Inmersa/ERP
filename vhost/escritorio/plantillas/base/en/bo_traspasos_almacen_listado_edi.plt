<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" bgcolor="#CCD2D7" height="22"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Warehouse Origen</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Posting Warehouse </td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Carrier</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="120">Remarks</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="75" height="22" class="etiqueta" align="center">Transfer date</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="30"></td>
 <td width="1"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 @%where:tabla|Traspasos_almacen;nombre|busc;no_results|1;%@
 <tr> <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%func:almacen_origen%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Almacenes_logicos.nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">
<a href="?seccion=bo_transportistas&id_transportista=@%db:Traspasos_almacen.id_transportista;%@" class="accesos">
@%db:Transportistas.nombre;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Traspasos_almacen.observaciones;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" height="22" class="texto">@%db:colocar_fecha{Traspasos_almacen.fecha};%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" ><a href="?seccion=modif_traspasos_almacen&id_traspaso=@%db:Traspasos_almacen.id_traspaso;%@" class="accesos">To see</a></td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td colspan="13" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <!-- aqui termina el registro-->
 @%end-where:%@
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@
 </td>
 </tr>
 </table>
