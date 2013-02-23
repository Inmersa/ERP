<table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="generar_albaran" action="?seccion=bo_albaranes_venta" method="post">
 <input type="hidden" name="Generar" value="Generar">
 <input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@">
 <tr> <td height="22" colspan="5"></td>
 </tr>
 <tr> <td height="22" bgcolor="#CCD2D7" class="etiqueta" colspan="3">Génerér</td>
 <td height="22" bgcolor="#CCD2D7" class="etiqueta" align="right"><a href="" onclick="document.forms['generar_albaran'].submit();return false;" class="accesos">Génerér</a></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="92" align="center">Transporteurs:</td>
 <td width="320"> <select name="id_transportista" class="insertext">
 @%where:tabla|Transportistas;nolink|1;%@
 <option value="@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" width="91" class="texto">Réf. Ext:</td>
 <td width="140"> <input type="text" name="ref_externa" class="insertext" size="16">
 </td>
 <td bgcolor="#EBECED" class="texto" width="1" align="right"></td>
 </tr>
 <tr> <td height="1" colspan="5" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="20" bgcolor="#EBECED" align="right" class="texto" width="92">Prêt:</td>
 <td height="20" colspan="3" class="texto">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="120"> <input type="checkbox" name="preparado" value="1">
 </td>
 <td bgcolor="#EBECED" height="20" align="right" class="texto">Envoyé:</td>
 <td width="100"> <input type="checkbox" name="enviado" value="1">
 </td>
 <td bgcolor="#EBECED" width="91" align="right" class="texto">Confirmation:</td>
 <td width="140"> <input type="checkbox" name="confirmacion" value="1">
 </td>
 </tr>
 </table>
 </td>
 <td height="1" bgcolor="#CCD2D7" width="1"></td>
 </tr>
 <tr> <td height="1" colspan="5" bgcolor="#CCD2D7"></td>
 </tr>
 <tr > <td height="22" colspan="5"></td>
 </tr>
 </form>
</table>


<form name="generar_factura" action="?seccion=bo_facturas_venta" method="post">

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <input type="hidden" name="Generar" value="Generar">
 <input type="hidden" name="identificador_pedido" value="@%db:Pedidos.id_pedido%@">
 <input type="hidden" name="ratio_divisa" value="@%db:Pedidos.id_divisa;%@">
 <tr> <td height="22" colspan="4"></td>
 </tr>
 <tr> <td height="22" bgcolor="#CCD2D7" class="etiqueta" colspan="3">Génerér</td>
 <td height="22" bgcolor="#CCD2D7" class="etiqueta" align="right"><a href="" onclick="document.forms['generar_factura'].submit();return false;" class="accesos">Consolider</a></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Série Facturation:</td>
 <td> <select name="id_serie" class="insertext"> 
@%where:tabla|Series_facturacion;nolink|1;where|ventas = 1;%@
 <option value="@%db:Series_facturacion.id_serie;%@">@%db:Series_facturacion.nombre;%@
- @%db:Series_facturacion.contador;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" align="right" class="texto">Réf. Ext:</td>
 <td> <input type="text" name="ref_externa" class="insertext" size="16">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="4"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Modes de paiement:</td>
 <td class="insertext" colspan="3">

<!-- @%set:_selected_value=id_forma_pago%@ -->
<select name="id_forma_pago" class="insertext">
 @%where:tabla|Forma_pago;nolink|1;%@ <option value="@%db:Forma_pago.id_forma_pago;%@"
 @%db:selected_value{Forma_pago.id_forma_pago}%@
 >@%db:Forma_pago.nombre;%@</option> @%end-where:%@ 
 </select> </td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="texto" width="120" align="right">Référence:</td>
 <td class="insertext" colspan="3">
 <input type="text" name="contador" class="insertext" size="16">
 Créer Commande Résidue <input type="checkbox" name="residuo" value="1" checked>
 </td>
 </tr>
 <tr> <td bgcolor="#EBECED" height="22" class="texto" align="right" valign="top">Notes:</td>
 <td colspan="3" height="1"> <textarea name="notas" cols="57" class="insertext"></textarea>
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="4"></td>
 </tr> <tr> <td height="22" colspan="4"></td>
 </tr>
 </form>
 </table>