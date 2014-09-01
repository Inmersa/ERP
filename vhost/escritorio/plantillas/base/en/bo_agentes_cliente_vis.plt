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
 <tr> <td colspan="15" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"> </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="70">Code</td>
 <td align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="22"></td>
 <td align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="150">Name</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Delivery Add.</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="100">Recruitment date </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" align="center" class="etiqueta">Commission</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" align="center" class="etiqueta">Shared Commission</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 @%where:tabla|Agentes_clientes;order|Clientes.nombre;Clientes.apellidos;nombre|busc;no_results|1;%@ <!--@%db:Agentes_clientes.id_cliente;%@-->
 <!--@%db:Agentes_clientes.id_agente;%@-->
 <input type="hidden" name="indices[]" value="@%db:Clientes.id_cliente%@">
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Clientes.id_cliente;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" bgcolor="#DBE0E3"> </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%if:AllowedLink;modif_clientes;%@<a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" class="accesos"> @%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a></td>
 @%end-if:%@
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Clientes.razon_social;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:colocar_fecha{Agentes_clientes.fecha_captacion};%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" height="22" class="texto"> @%db:Agentes_clientes.comision;%@
 </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" height="22" class="texto"> @%db:Agentes_clientes.comision_repartida;%@
 </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="14" height="1"></td>
 </tr>
 <tr> <td colspan="14" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 <tr> <td colspan="14" height="1"></td>
 </tr>
 @%end-where:%@ 
 <tr> <td bgcolor="#CCD2D7" height="22" colspan="15" align="center">
 </tr>
</table>
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">

 @%plt:botonera%@

</td>
 </tr>
 </form></table>


