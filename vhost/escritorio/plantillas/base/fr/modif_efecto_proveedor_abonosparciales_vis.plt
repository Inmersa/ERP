@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td height="22" align="left" bgcolor="#CCD2D7" class="titocho">>Règlement Partial</td>
<td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr><td colspan="2">

 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 <td bgcolor="#EBECED" class="etiqueta" align="center" width="100">Date liquidation</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#EBECED" class="etiqueta" align="center" width="100">Moyen de payant</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#EBECED" class="etiqueta" align="center" width="80">Montant</td> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#EBECED" class="etiqueta" align="center" width="80">Banqe</td> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#EBECED" class="etiqueta" align="center" >Notes</td>
 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 @%where:tabla|Efectos_parciales;%@ <tr bgcolor="#FFFFFF"> <td class="texto" align="center">@%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Efectos_parciales.medio_pago%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Efectos_parciales.monto_satisfecho%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center"> @%where:tabla|Bancos;%@ @%db:Bancos.nombre%@ @%end-where:%@ 
 </td> <td bgcolor="#DBE0E3" width="1"></td> <td class="texto" align="center">@%db:Efectos_parciales.notas%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 @%end-where:%@ <tr> <td bgcolor="#CCD2D7" height="1" colspan="8"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13" colspan="2"></td>
 </tr>
 </table>
