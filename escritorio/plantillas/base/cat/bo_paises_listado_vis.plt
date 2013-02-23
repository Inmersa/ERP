<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right">
 </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="22"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Nom</td>
 <td class="etiqueta" width="1" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center" width="80">Codi</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center">Continent</td>
 <td width="1" class="etiqueta"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center" width="80">Prefix Tf.</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center" width="80">Prefix CIF</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <form name="modif_paises" action="" method=post>
 <input type=hidden name=estado value=3>


 @%where:tabla|Paises;nombre|busc;%@ <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td height="1" colspan="9"></td>
 <td height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18" align="center"> </td>
 <td class="etiqueta" height="22">{{bo_paises_listado_vis.plt5}}:{{bo_paises_listado_vis.plt6}}%{{bo_paises_listado_vis.plt7}}<a href="?seccion=modif_paises&id_pais=@%db:Paises.id_pais;%@" class="accesos">@%db:Paises.nombre;%@ </a></td>
@%end-if:%@
 <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td class="texto" height="22" align="center">@%db:Paises.codigo;%@</td>
 <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td class="texto" height="22" align="center" width="150">@%db:Paises.continente;%@</td>
 <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td class="texto" height="22" align="center">@%db:Paises.prefijo_tlf;%@</td>
 <td class="etiqueta" height="22" bgcolor="#DBE0E3"></td>
 <td class="texto" height="22" align="center">@%db:Paises.prefijo_cif;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1" colspan="9"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" colspan="10"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>

 @%end-where:%@ 

</form>
 <tr> <td height="22" colspan="11" > </td>
 </tr>
 <tr align="center"> <td colspan="11" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1" colspan="9"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@ </td>
 </tr>
</table>

