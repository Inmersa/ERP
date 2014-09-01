@%where:tabla|Empresas;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
<form name="modif_empresas" action="../?seccion=modif_empresas" method=post>

<input type=hidden name=registro[id_empresa] value="@%db:Empresas.id_empresa;%@">
<input type=hidden name=registro[id_usr] value="@%db:Empresas.id_usr;%@">
<input type=hidden name=estado value=4>
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" >&gt; Fiche d´entreprises</td>
 <td align="right" ><a href="../?seccion=bo_empresas" class="accesos">Liste d´enterprises</a></td>
 <td width="46" align="center" ><a href="javascript: history.go(-1);" class="accesos">Tourner</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>

 <tr> 
 <td> @%plt:Datos_Generales%@ </td>
 </tr>
<tr> 
 <td> @%plt:Datos_Factura%@ </td>
 </tr>
<tr> 
 <td> @%plt:Login%@ </td>
 </tr>



 <tr align="center"> <td colspan="6" height="22" bgcolor="#CCD2D7">
<a href="javascript:document.forms['modif_empresas'].submit();" class="accesos">Modifier</a>
<a href="javascript:document.forms['modif_empresas'].reset();" class="accesos">Défaire changement</a> 
@%if:AllowedLink;modif_empresas;%@<a href="?seccion=modif_empresas&estado=2&registro[id_empresa]=@%db:Empresas.id_empresa%@" onclick="return confirm('Esta ud. seguro de que de desea borrar el registro?');return false;"
class="accesos">Effacer</a>
@5end-if:%@
</td>
</form></table>
 
