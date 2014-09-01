<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22" class="etiqueta"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="180">Referência</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="75">Data</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="190">Endereço de Destino</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="90">Tipo de Guia de Remessa </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="70" height="22" align="center" class="etiqueta">Estado</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="11" height="1"></td>
 </tr>
 @%where:tabla|Albaranes;nombre|busc;no_results|1;order|Albaranes.referencia desc;%@
<!--
Campo fecha_recepcion = @%db:Albaranes.fecha_recepcion;%@
Campo Pedidos:nombre @%db:Pedidos.nombre;%@ @%db:Pedidos.id_direccion;%@ @%db:Pedidos.id_proveedor;%@ 
-->
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"> <a href="?seccion=bo_albaran_almacen&id_albaran=@%db:Albaranes.id_albaran;%@"
 class="accesos">@%db:Albaranes.referencia;%@
@%db:Transportistas.nombre;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:colocar_fecha{Albaranes.fecha};%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">

 @%func:direccion%@

 </td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:tipo_albaran%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" height="22" class="texto">@%func:estado_albaran%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="11" height="1"></td>
 </tr>
 <tr> <td colspan="11" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 <tr> <td colspan="11" height="1"></td>
 </tr>
 @%end-where:%@

 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
</table>
<!--br>
<a href="?seccion=nuevo_albaranes">Adicionar Registo</a>
<br-->

