@%where:nodb|nodb_order_data;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td colspan="3" height="10"></td>
 </tr>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="30"></td>
<td width="698"> 
 <table width="698" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7" align="center"> <td height="15" class="titul">Factures</td>
 <td class="titul">Ref. Ext</td>
 <td class="titul">Data</td>
 <td class="titul">Pes Total</td>
 <td class="titul">Mig de paga</td>
 <td class="titul">Divisa</td>
 </tr>
 <tr align="center"> <td height="15" class="texto">@%db:referencia;%@</td>
 <td height="15" class="texto">@%db:referencia_externa;%@</td>
 <td class="texto">@%db:colocar_fecha{fecha};%@</td>
 <td class="texto">@%db:peso%@ Kg</td>
 <td class="texto">@%db:nombre_forma_pago%@</td>
 <td class="texto">@%db:nombre_divisa;%@</td>
 </tr>
 </table>
 </td>
<td width="1"><img src="imag/p.gif" width="1" height="30"></td>
 </tr>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr>
<td colspan="3" height="15"></td>
 </tr>
</table>

@%end-where:%@
