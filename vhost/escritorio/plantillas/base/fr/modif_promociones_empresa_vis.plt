 
@%where:tabla|Promociones;where|Promociones.id_articulo = $id_articulo_promocion AND Promociones.id_empresa = $id_empresa;%@

 <form name="modif_promociones" action="" method="post">
 <input type="hidden" name="accion_ejecutar" value="0">
 <input type=hidden name=registro[id_promocion] value="@%db:Promociones.id_promocion;%@">

 

<table width="644" border="0" cellspacing="0" cellpadding="0">

 <tr> <td colspan="8" height="10"></td>
 </tr>
 <tr> <td height="22" width="1" bgcolor="#DBE0E3"></td>
 <td bgcolor="#91C800" width="80" class="etiqueta">
 <input type="checkbox" name="reg[]" value="@%db:Promociones_articulos.id_articulo%@">

Nom Promotiones</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="80" align="center" class="etiqueta">Article</td>
 <td width="1"></td>
 <td width="80" bgcolor="#DBE0E3" align="center" class="etiqueta">Debut de periode</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" class="etiqueta" width="80">Derniére date</td>
 </tr>
 <tr> <td colspan="8" height="1"></td>
 </tr>
 <tr> <td height="22" bgcolor="#DBE0E3" class="texto"></td>
 <td>
 <input type="text" name="registro[nombre]" value="@%db:Promociones.nombre;%@" class="insertext">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:cantidad_total%@</td>
 <td></td>
 <td align="center"> <input type="text" name="registro[fecha_inicio]" value="@%db:colocar_fecha{Promociones.fecha_inicio};%@" size="10" class="insertextnumeros">
 </td>
 <td></td>
 <td align="center"> <input type="text" name="registro[fecha_fin]" value="@%db:colocar_fecha{Promociones.fecha_fin};%@" size="10" class="insertextnumeros">
 </td>
 </tr>
 <tr> <td height="1" colspan="8" bgcolor="#DBE0E3"></td>
 </tr>
 
 </table>
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" bgcolor="#DBE0E3" height="22" align="center" class="texto">

Debut de periode<input type="text" name="registro[fecha_inicio]" value="@%db:colocar_fecha{Promociones.fecha_inicio};%@" size="10" class="insertextnumeros">
 Derniére date<input type="text" name="registro[fecha_fin]" value="@%db:colocar_fecha{Promociones.fecha_fin};%@" size="10" class="insertextnumeros">


<a href="" onclick="return onHRefClick('modif_promociones','accion_ejecutar','Modificar');" class="accesos">Actif</a>

 </td>
 </tr>
 </table>
 </form>
@%end-where:%@


