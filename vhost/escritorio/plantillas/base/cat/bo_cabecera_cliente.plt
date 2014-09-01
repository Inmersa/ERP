
<link rel="stylesheet" href="estilos.css" type="text/css">

@%set:color_inm=#91C800%@
@%set:color_barra=#689830%@
@%set:color_accesos_mensaka=#EBECED%@
@%set:color_menu_lateral=#EBECED%@

<table width="771" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" width="769">
 <a href="?seccion=@%func:get_from_user;desktop_subsec%@"
 ><img src="imag/barra-sup-gestion.png" border="0" ></a>
 </td>
 <td bgcolor="#FFFFFF" width="769" class="etiqueta" align="left">
 Usuario: @%func:get_from_user;nombre_usuario;%@
 </td>
 <td bgcolor="#FFFFFF" width="769" class="etiqueta" align="right">
 <img src="imag/logop.gif" width="62" height="20" >
 </td>
 </tr>
</table>
<table width="771" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="5"></td>
 </tr>
 <tr> <td bgcolor="@%get:color_accesos_mensaka%@" height="22" align="center" valign="middle"> <table width="760" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="texto" width="112"></td>
 <td width="55" align="right"></td>
 <td width="19" align="left"></td>
 <td width="43" align="right"></td>
 <td width="18" align="left"></td>
 <td width="110" align="right">
 </td>
 <td width="19" align="left"></td>
 <td width="101" align="right"></td>
 <td width="19" align="left"></td>
 <td width="43" align="right"><a href="" class="acceso_directo">Sortir</a></td>
 <td width="54" align="left"><a href="" class="accesos"><img src="imag/accesosdirectos.png" border="0"/></a></td>
<td width="140"> <table width="140" border="0" cellspacing="0" cellpadding="0"
height="22">
 <tr> <td height="4"></td>
 </tr>
 <tr> <td align="right" valign="bottom">
 <!--<a href="#"><img src="imag/acdirect.gif" width="19" height="17" border="0"></a> -->
 <!--<a href="#"><img src="imag/andirect.gif" width="19" height="17" border="0"></a> -->
 <!--<a href="#"><img src="imag/emali.gif" width="19" height="17" border="0"></a> --> <a href="?@%func:querystring%@&imprimir_todas=1"><img src="imag/impri.gif" width="19" height="17" border="0" alt="Imprimir"/></a>
@%if:hay_ayuda%@
 <a href="Ayuda" onClick="return abrir_ayuda('?seccion=ayuda&id_sub=@%get:ayuda_id%@');"
><img src="imag/ayuda.jpg" alt="Consultar la Ayuda" border="0"></a> 
@%else:%@
 <img src="imag/noayuda.jpg" ALT="No hay Ayuda disponible" border="0">
@%end-if:%@
 </td></tr>
 <tr>
 <td height="4"></td>
 </tr>
 </table>
 </td> </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#CCCCCC" height="3"></td>
 </tr>
</table>

@%if:nombre_seccion;null%@ 
<table width="771" border="0" cellspacing="0" cellpadding="0"
bgcolor="@%get:color_inm%@">
 <tr> <td width="6"></td>
 <td height="1" colspan="5" ></td>
 <td height="1" colspan="8"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td rowspan="2" width="1"></td>
 <td rowspan="2" width="2"></td>
 <td height="2"></td>
 <td rowspan="2" width="2"></td>
 <td rowspan="2" width="1"></td>
 <td colspan="8"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td align="center"><a href=""
class="menus">Client</a></td>
 <td align="center"><a href=""
class="menus">Articles</a></td>
 <td align="center"><a href=""
class="menus">Agents</a></td>
 <td align="center" colspan="5"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td></td>
 <td></td>
 <td height="1"></td>
 <td></td>
 <td></td>
 <td colspan="8" height="1"></td>
 <td width="6"></td>
 </tr>
 <tr> <td height="2" colspan="3"></td>
 <td height="2"></td>
 <td colspan="11" height="2"></td>
 </tr>
</table>

 @%else:%@

 @%end-if:%@

@%if:nombre_seccion;clientes%@

<table width="771" border="0" cellspacing="0" cellpadding="0" bgcolor="@%get:color_inm%@">
 <tr> <td width="6"></td>
 <td height="1" colspan="5" bgcolor="#FFFFFF"></td>
 <td height="1" colspan="8"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td rowspan="2" width="2"></td>
 <td height="2"></td>
 <td rowspan="2" width="2"></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td colspan="8"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6" height="16"></td>
 <td bgcolor="@%get:color_barra%@" align="center" height="16"><a href="" class="menus2">Client</a></td>
 <td align="center" height="16"><a href="" class="menus">Articles</a></td>
 <td align="center" height="16"><a href="" class="menus">Agents</a></td>
 <td align="center" colspan="5"></td>
 <td width="6" height="16"></td>
 </tr>
 <tr> <td width="6"></td>
 <td bgcolor="#FFFFFF"></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td></td>
 <td bgcolor="#FFFFFF"></td>
 <td colspan="8"></td>
 <td width="6"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" width="6"></td>
 <td></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="1"></td>
 <td></td>
 <td></td>
 <td colspan="8" bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" width="6"></td>
 </tr>
 <tr> <td height="2" colspan="3"></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td colspan="11" height="2"></td>
 </tr>
</table>

@%else:%@ @%end-if:%@ @%if:nombre_seccion;articulos%@ 
<table width="771" border="0" cellspacing="0" cellpadding="0" bgcolor="@%get:color_inm%@">
 <tr> <td width="6"></td>
 <td height="1"></td>
 <td height="1" colspan="5" bgcolor="#FFFFFF"></td>
 <td height="1" colspan="7"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td rowspan="2" width="2"></td>
 <td height="2"></td>
 <td rowspan="2" width="2"></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td colspan="7"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td align="center" height="18"><a href="" class="menus">Client</a></td>
 <td bgcolor="@%get:color_barra%@" align="center"><a href="" class="menus2">Articles</a></td>
 <td align="center"><a href="" class="menus">Agents</a></td>
 <td align="center" colspan="5"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td></td>
 <td bgcolor="#FFFFFF"></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td></td>
 <td bgcolor="#FFFFFF"></td>
 <td colspan="7"></td>
 <td width="6"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" width="6"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="1"></td>
 <td></td>
 <td></td>
 <td colspan="7" bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" width="6"></td>
 </tr>
 <tr> <td height="2" colspan="4"></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td colspan="10" height="2"></td>
 </tr>
</table>

@%else:%@ @%end-if:%@ @%if:nombre_seccion;agentes%@ 
<table width="771" border="0" cellspacing="0" cellpadding="0" bgcolor="@%get:color_inm%@">
 <tr> <td width="6"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" colspan="5" bgcolor="#FFFFFF"></td>
 <td height="1" colspan="6"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6"></td>
 <td></td>
 <td></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td rowspan="2" width="2"></td>
 <td height="2"></td>
 <td rowspan="2" width="2"></td>
 <td bgcolor="#FFFFFF" rowspan="2" width="1"></td>
 <td colspan="6"></td>
 <td width="6"></td>
 </tr>
 <tr> <td width="6" height="18"></td>
 <td align="center" height="18"><a href="" class="menus">Client</a></td>
 <td align="center" height="18"><a href="" class="menus">Articles</a></td>
 <td bgcolor="@%get:color_barra%@" align="center" height="18"><a href="" class="menus2">Agents</a></td>
 <td align="center" colspan="5"></td>
 <td width="6" height="18"></td>
 </tr>
 <tr> <td width="6"></td>
 <td></td>
 <td></td>
 <td bgcolor="#FFFFFF"></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td></td>
 <td bgcolor="#FFFFFF"></td>
 <td colspan="6"></td>
 <td width="6"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" width="6"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" height="1"></td>
 <td></td>
 <td></td>
 <td bgcolor="@%get:color_barra%@" height="1"></td>
 <td></td>
 <td></td>
 <td colspan="6" bgcolor="#FFFFFF" height="1"></td>
 <td bgcolor="#FFFFFF" width="6"></td>
 </tr>
 <tr> <td height="2" colspan="5"></td>
 <td bgcolor="@%get:color_barra%@" height="2"></td>
 <td colspan="9" height="2"></td>
 </tr>
</table>

@%else:%@

@%end-if:%@




@%else:%@ @%end-if:%@ @%if:nombre_seccion;almacenes%@ 
