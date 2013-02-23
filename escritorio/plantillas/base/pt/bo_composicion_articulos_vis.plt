<table width="647" border="0" cellspacing="0" cellpadding="0">

<tr>
<td>
@%plt:botonera%@
 </td></tr>
<tr valign="top"> 
 <td bgcolor="#FFFFFF" height="10">
<form name="composicion_articulos" action="" method="post">
<input type="hidden" name="accion_ejecutar" value="0">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td class="etiqueta" width="200">Composição</td>
 <td align="center"> <!--a href="?seccion=bo_composicion_articulos" class="accesos">Adicionar Produto</a-->
 </td>
 <td align="center">

 <!-- input type="Submit" name="Modificar" value="Modificar" -->
 </td>
 </tr>
 </table>
 </td>
<td class="etiqueta" align="center" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Nome</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" colspan="7">Quantidade</td>
 <td class="etiqueta" align="center" width="1" bgcolor="#DBE0E3"></td>
 <!--td colspan="5" class="etiqueta" align="center" bgcolor="#DBE0E3"></td-->
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="10" height="1"></td>
 </tr>
 @%where:tabla|Articulos;nombre|busc;%@ <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_articulos;&@<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@" class="accesos">@%db:Articulos.nombre;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto" colspan="7"> 
@%if:composicion_articulo%@ <input type="text" name="registro3[@%db:Articulos.id_articulo;%@]" value="0" class="insertext" size="10">
 @%else:%@ @%end-if:%@ </td>
 <td align="center" class="texto" width="1" bgcolor="#DBE0E3"></td>
 <!--td align="center" class="texto" width="88"></td>
 <td align="center" class="texto" width="1"></td>
 <td align="center" class="texto" width="32"></td>
 <td align="center" class="texto" width="26"></td>
 <td width="92" class="etiqueta"></td-->
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24" ></td>
 <td height="1" width="204"></td>
 <td height="1" width="1"></td>
 <td height="1" width="62"></td>
 <td height="1" width="62"></td>
 <td height="1" bgcolor="#DBE0E3" width="1"></td>
 <td height="1" width="62"></td>
 <td height="1" width="1"></td>
 <td height="1" width="23"></td>
 <td height="1" width="263"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="24"></td>
 <td height="1" bgcolor="#CCD2D7" width="204"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7" width="62"></td>
 <td height="1" bgcolor="#CCD2D7" width="62"></td>
 <td height="1" bgcolor="#DBE0E3" width="1"></td>
 <td height="1" bgcolor="#CCD2D7" width="62"></td>
 <td height="1" bgcolor="#CCD2D7" width="1"></td>
 <td height="1" bgcolor="#CCD2D7" width="23"></td>
 <td height="1" bgcolor="#CCD2D7" width="263"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%end-where:%@
 </table>
 </form>
 </td>
 </tr>
 <tr>
 <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@
</td>
 </tr>
 </table>
 