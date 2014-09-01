<table width="647" border="0" cellspacing="0" cellpadding="0">
<tr> 
 <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
<form action="" method="post" name="agentes_clientes">
<input type="hidden" name="accion_ejecutar" value="0">
 <tr> 
 <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="5" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="22"></td>
 <td align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Nome</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="4" height="1"></td>
 </tr>
 @%where:tabla|Agentes;order|Agentes.nombre;Agentes.apellidos;nombre|busc;no_results|1;%@ <!--@%db:Agentes.id_agente;%@
 @%db:store_checkmany{Agentes.id_agente}%@-->
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" bgcolor="#DBE0E3"> </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%if:AllowedLink;modif_agentes;%@<a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" class="accesos">@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="4" height="1"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 <tr> <td colspan="4" height="1"></td>
 </tr>
 @%end-where:%@ 
 <tr> <td bgcolor="#CCD2D7" height="22" colspan="5" align="center"></td>
 </tr>
 </table>
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@

</td>
 </tr>
 </form></table>

