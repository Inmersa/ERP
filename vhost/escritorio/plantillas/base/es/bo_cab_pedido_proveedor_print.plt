@%where:tabla|Pedidos;%@
<!--@%db:Pedidos.id_pedido%@-->
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="10"></td>
 </tr>
 <tr bgcolor="#000000"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td width="1" bgcolor="#000000"></td>
 <td width="698"> <table width="698" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7" align="center"> <td height="15" class="titul">Pedido</td>
 <td class="titul">Fecha</td>
 <td class="titul">T. Peso</td>
 <td class="titul">Forma de pago</td>
 <td class="titul">Realizado por</td>
 <td class="titul">Divisa</td>
 </tr>
 <tr align="center"> <td height="15" class="texto">@%db:Pedidos.referencia;%@</td>
 <td class="texto">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <!--@%func_nill:calcular_total_peso;%@-->
 <td class="texto">@%get:total_peso%@ Kg</td>
 <td class="texto">@%db:Forma_pago.nombre;%@</td>
 <td class="texto"> @%db:Agentes.nombre;%@ </td>
 <td class="texto">@%db:Divisa.nombre;%@</td>
 </tr>
 </table>
 </td>
 <td width="1" bgcolor="#000000"></td>
 </tr>
 <tr bgcolor="#000000"> <td colspan="3" height="1"></td>
 </tr>
 <tr>
 <td colspan="3" height="15"></td>
 </tr>
</table>

@%end-where:%@
