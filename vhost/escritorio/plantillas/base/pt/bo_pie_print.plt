@%where:tabla|Facturas;%@
<!-- @%db:Facturas.id_factura%@-->

<table class="fullstruct">
<tr><td>

<table class="full">
<thead class="encabezado">
<tr>
<td >Valor Tribut�vel</td>
<td >%</td>
<td ></td>
<td >Sobretaxa Equivalente</td>
</tr>
</thead>
</table>

</td></tr><tr><td>

</td></tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td colspan="3" height="10"></td>
</tr>
<tr> <td valign="top"> <table width="326" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td><img src="imag/p.gif" width="326" height="1"></td>
</tr>
 </table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td bgcolor="#DBE0E3" height="13" class="etiqueta" align="center" width="1"><img src="imag/p.gif" width="1" height="15"></td>
<td bgcolor="#DBE0E3" height="13" class="titul" align="center" width="95">Valor Tribut�vel</td>
<td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
<td bgcolor="#DBE0E3" align="center" height="13" class="titul">%</td>
<td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
<td bgcolor="#DBE0E3" align="center" height="13" class="titul" width="77"></td>
<td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
<td bgcolor="#DBE0E3" align="center" height="13" class="titul" width="77">Sobretaxa Equivalente</td>
<td width="1" height="13" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>

 @%where:tabla|IVAs;%@ <!-- @%db:IVAs.id_iva;%@ -->
 <tr> 
<td height="15" bgcolor="#DBE0E3" ><img src="imag/p.gif" width="1" height="15"></td>
<td height="15" align="center" class="texto">@%db:IVAs.monto;%@</td>
<td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
<td class="texto" align="center" height="15">@%db:Tipos_IVA.porcentaje%@</td>
<td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
<td class="texto" align="center" height="15">@%db:IVAs.recargo_iva;%@</td>
<td class="texto" align="center" height="15" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
<td class="texto" align="center" height="15">@%db:IVAs.recargo_equivalente;%@</td>
<td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%end-where:%@ 

</table>
 <table width="326" border="0" cellspacing="0" cellpadding="0">
<tr> <td><img src="imag/p.gif" width="326" height="1"></td>
</tr>
 </table>
 </td>
 <td width="187" height="63" align="center"> </td>
 <td valign="top" width="187"> 
<table width="187" border="0" cellspacing="0" cellpadding="0">
<tr> <td><img src="imag/p.gif" width="187" height="1"></td>
</tr>
 </table>
<table width="187" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="15" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" class="titul" align="center" height="15" width="55">Total Bruto</td>
 <td width="1" height="15" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center">%Desconto</td>
 <td width="1" height="15" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="55">Montante</td>
 <td width="1" bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%where:tabla|Descuentos;order|Descuentos.orden asc;%@
 <tr> <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="center" class="texto" height="15">@%db:Descuentos.monto_base;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" height="15">@%db:Descuentos.nombre%@ @%db:Descuentos.porcentaje%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="right" height="15">@%db:Descuentos.monto_final;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%end-where:%@ 
</table>
 <table width="187" border="0" cellspacing="0" cellpadding="0">
<tr> <td><img src="imag/p.gif" width="187" height="1"></td>
</tr>
 </table>
 </td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="5" width="171"></td>
 <td height="5" width="342"></td>
 <td height="5" width="187"></td>
</tr>
<tr> <td width="171"> 
<table width="170" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td><img src="imag/p.gif" width="170" height="1"></td>
 </tr>
 <tr> 
<td> 
<table width="170" border="0" cellspacing="0" cellpadding="0">
<tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 
<td align="right" class="texto" bgcolor="#EBECED">Total Bruto:</td>
 <td width="1" height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 
<td width="72" height="15" class="texto" align="right">@%get:total_bruto%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
</tr>
<tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 
<td align="right" class="texto" bgcolor="#EBECED">Desconto Total:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 
<td height="15" class="texto" align="right">@%db:Facturas.descuento;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
</tr>
<tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 
<td align="right" class="texto" bgcolor="#EBECED">Total do Valor Tribut�vel:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 
<td height="15" class="texto" align="right">@%db:Facturas.base_imponible;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
</tr>
<tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 
<td align="right" class="texto" bgcolor="#EBECED">Total de Impostos:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 
<td height="15" class="texto" align="right">@%db:Facturas.total_impuestos;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
</tr>
<tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 
<td align="right" class="texto" bgcolor="#EBECED">Reten��o:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 
<td height="15" class="texto" align="right">@%db:Facturas.retenido%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
</tr>
 </table>
 </td>
 </tr>
 <tr> 
<td><img src="imag/p.gif" width="170" height="1"></td>
 </tr>
</table>
 </td>
 <td width="342" align="center"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td width="76"></td>
<td>
 <table width="250" border="0" cellspacing="0" cellpadding="0">
<tr> <td><img src="imag/p.gif" width="250" height="1"></td>
</tr>
<tr> <td> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="15"></td>
<td class="titul" bgcolor="#CCD2D7">Notas</td>
<td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> 
<td><img src="imag/p.gif" width="1" height="50"></td>
<td class="texto" valign="top">@%db:Facturas.notas;%@</td>
<td><img src="imag/p.gif" width="1" height="50"></td>
 </tr>
</table>
 </td>
</tr>
<tr> <td><img src="imag/p.gif" width="250" height="1"></td>
</tr>
 </table>
</td>
 </tr>
</table>
 </td>
 <td width="187" valign="bottom"> <table width="187" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> 
<td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 <tr align="center" bgcolor="#CCD2D7"> 
<td height="15"><img src="imag/p.gif" width="1" height="15"></td>
<td class="titul" height="15" bgcolor="#CCD2D7">Montante Total</td>
<td height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> 
<td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
<td height="15" align="right" width="99%" class="titocho"> @%db:Facturas.monto_total%@ &euro; 
</td>
<td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> 
<td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
</table>
 </td>
</tr>
 </table>
 
@%end-where:%@ 
