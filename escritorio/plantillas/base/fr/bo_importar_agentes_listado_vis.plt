<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr align="right" bgcolor="#CCD2D7"> <form name ="bo_importar_agentes" method="post" action="">
 <td colspan="7" height="22" class="etiqueta"> </td>
 </form>
 </tr>
 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" colspan="2" height="22">Nom</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Téléphone</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Tipe d´agent</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>

 @%where:tabla|Agentes;nombre|busc;no_results|1;%@ <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="18"> </td>
 <td class="etiqueta" height="22">@%if:AllowedLink;modif_agentes;%@<a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" class="accesos"> @%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto" width="100"> @%db:Agentes.telefono1;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto"> @%db:Tipo_agente.nombre%@</td>
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

@%end-where:%@ <tr bgcolor="#CCD2D7" align="center"> <td colspan="7" height="22"> <input type="hidden" name="accion_ejecutar" value="Importar">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
 @%plt:botonera%@ </td>
 </tr>
</table>

