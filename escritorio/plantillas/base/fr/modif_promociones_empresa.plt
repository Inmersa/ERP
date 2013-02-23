<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="331" >&gt; Promotiones Enterprise(
      @%where:tabla|Articulos;nolink|1;where|id_articulo = $id_articulos_promocion;%@
      @%db:Articulos.nombre;%@ 
      @%end-where:%@

       )</td>
 <td align="right" width="310" > <table width="140" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td width="47" > @%if:AllowedLink;nuevo_promociones;%@ <a href="" class="accesos">Ajouter </a> </td>
 @%end-if:%@
 <td width="47" ><a href="javascript: history.go(-1);" class="accesos">Tourner</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="10"> 
@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo_promocion;%@ <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="22"></td>
 </tr>
 <tr> <td height="22" colspan="8" bgcolor="#DBE0E3" class="etiqueta">@%db:Articulos.nombre;%@</td>
 </tr>
 </table>
 
@%end-where:%@

 <tr> <td> 
 @%plt:Promociones_Empresa%@ 
 </td>
 </tr>
</table>
