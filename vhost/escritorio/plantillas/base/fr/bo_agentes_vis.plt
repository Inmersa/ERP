<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="194" valign="top"> 
 <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> <td class="texto">Resultats: @%func:numero_resultados;%@</td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td bgcolor="#FFFFFF" width="3"></td>
 <td bgcolor="@%get:color_accesos_mensaka%@" valign="top">
 @%plt:mensajero%@
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> 
 <td bgcolor="#FFFFFF" height="30">
 @%plt:botonera%@ </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right">
 <form name="bo_agentes" method="post" action=""> <td colspan="7" bgcolor="#CCD2D7" height="22" class="etiqueta">
</td>
 </form></tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" colspan="2" height="22">Nom</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Téléphone</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Tipe d´agent</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
@%where:tabla|Agentes;order|Agentes.nombre,Agentes.apellidos;nombre|busc;no_results|1;%@
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18"> </td>
 <td class="etiqueta" height="22">
@%if:AllowedLink;modif_agentes;%@<a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" class="accesos">
 @%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto" width="100"> @%db:Agentes.telefono1;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Tipo_agente.nombre%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" width="18" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 @%end-where:%@

 </table>

 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@
 </td>
 </tr>
 </table>
