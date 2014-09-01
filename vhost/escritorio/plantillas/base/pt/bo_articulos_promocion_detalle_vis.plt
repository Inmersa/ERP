<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="bo_articulos_promocion" method="post" action="">
<tr> <td>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" bgcolor="#DBE0E3" height="22"></td>
 <td bgcolor="#DBE0E3" width="150" class="etiqueta">Nome</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Descrição</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="100" class="etiqueta">Código de Barras</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="60" class="etiqueta">Quantidade</td>
 <td width="1" bgcolor="#DBE0E3"></td>
 </tr>

@%where:tabla|Articulos;nombre|busc;%@ <tr> <td bgcolor="#CCD2D7" height="22"></td>
 <td class="texto">@%db:Articulos.nombre;%@</td>
 <td bgcolor="#CCD2D7"></td>
 <td class="texto">@%db:Articulos.descripcion;%@</td>
 <td bgcolor="#CCD2D7"></td>
 <td class="texto"align="center">@%db:Articulos.codigo_barras;%@</td>
 <td bgcolor="#CCD2D7"></td>
 <td align="center"> @%if:promocion_articulo_promocion%@ @%else:%@ @%end-if:%@ </td>
 <td bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="9" height="1" bgcolor="#CCD2D7"></td>
 </tr>

@%end-where:%@

 </table>
 </td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="center"> </td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
</td>
 </tr>
</table>

