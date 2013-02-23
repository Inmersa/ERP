<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> 
 <td height="22" bgcolor="#FFFFFF">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td height="22" colspan="11"></td>
 </tr>
 <tr> <td width="1" bgcolor="#DBE0E3" height="22"></td>
 <td height="22" bgcolor="#DBE0E3" class="etiqueta">Nom client</td>
 <td width="1"></td>
 <td height="22" bgcolor="#DBE0E3" align="center" class="etiqueta" width="70">Factures</td>
 <td width="1"></td>
 <td height="22" bgcolor="#DBE0E3" align="center" class="etiqueta" width="100">Facturat</td>
 <td width="1"></td>
 <td height="22" bgcolor="#DBE0E3" align="center" class="etiqueta" width="100">Comissions</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="100" class="etiqueta" align="center">Cobrat</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 @%where:tabla|Agentes_facturas;where|Agentes_facturas.id_agente = $id_agente_promocion AND Facturas.fecha between from_days(to_days(now()) - to_days(date_sub(now() , INTERVAL 1 MONTH))) AND now();no_results|1;group|Clientes.id_cliente;%@ <!-- @%db:Agentes_facturas.id_agente%@ -->
 <!--Ultima Factura = @%db:max(Facturas.fecha);%@-->
<tr> <td width="1" bgcolor="#DBE0E3" height="22"></td>
 <td height="22" class="texto">@%db:Clientes.apellidos;%@ @%db:Clientes.nombre;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="center" class="texto">@%db:count(Facturas.id_factura);%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="center" class="texto">@%db:sum(Facturas.monto_total);%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="center" class="texto">@%db:sum(Agentes_facturas.monto);%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:sum(Efectos.monto_pagado);%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="11" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@ <tr> <td colspan="11" height="10"></td>
 </tr>
 </table>

 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="270" height="22"></td>
 <td bgcolor="#CCD2D7" colspan="8"></td>
 </tr>
 <tr> <td height="22"></td>
 <td bgcolor="#DBE0E3" align="center" class="etiqueta">Totals</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="100" class="etiqueta">Facturat</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="100" class="etiqueta">Comissions </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="100" class="etiqueta">Cobrat</td>
 <td width="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="22"></td>
 <td></td>
 <td bgcolor="#CCD2D7"></td>
 <td align="center" class="texto">@%func:suma_total_facturas_agente%@</td>
 <td bgcolor="#CCD2D7"></td>
 <td align="center" class="texto">@%func:suma_total_comisiones_agente%@</td>
 <td bgcolor="#CCD2D7"></td>
 <td align="center"></td>
 <td bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td></td>
 <td></td>
 <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 </table>
</td>
 </tr>
<tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 </table>

