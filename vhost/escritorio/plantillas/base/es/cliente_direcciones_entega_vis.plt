<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#EBECED"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" height="20" ></td>
 <td class="titul1" height="20" width="172" >Direcciones de entrega:</td>
 </table>
 </td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 <tr> <td> @%where:tabla|Direcciones_entrega;where|Clientes.id_cliente= $id_cliente_promocion;order|Direcciones_entrega.nombre,Direcciones_entrega.direccion;%@
 <table width="500" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="10"></td>
 <td class="texto">@%if:allowed_link;modif_direcciones_entrega:%@
 <a href="?seccion=modif_direcciones_entrega&amp;id_direccion=@%db:Direcciones_entrega.id_direccion%@" class="accesos">@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@ </a> @%else:%@ @%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@ @%end-if:%@ </td>
 </tr>
 </table>
 @%end-where:%@



 </td>
 </tr>
 <tr> <td height="22"></td>
 </tr>
 </table>
