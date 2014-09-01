 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" height="30"></td>
 </tr>
 <tr> <td colspan="13" height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6"></td>
 <td width="419"></td>
 <td align="center" width="100"><a href="" class="accesos">Ajouter article </a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="20" height="22"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta">Nom</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Quantite</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="60">Prix</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="60">Taxe</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="60"><span class="texto">%</span>Impliquer </td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="90">Montant</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 @%where:nodb|nodb_confirmar_pedido;format_name|classDocumentDetail;%@ 
 <!-- aqui empieza el registro -->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="22"> <input type="checkbox" name="articulos_confirmados[@%db:id_articulo;%@]" value="1" checked>
 </td>
 <td class="texto">@%db:nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:cantidad_total;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:precio_tarifa ;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:porcentaje;%@</td>
 <td bgcolor="#DBE0E3"> </td>
 <td class="texto" align="center"> @%db:tipo_descuento;%@ </td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%db:base_imponible;%@ @%func:leyenda_divisa%@ </td>
 <td bgcolor="#DBE0E3"></td>
 @%func:guardar_linea_detalle%@ </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="11" align="center" > <input type="text" name="observaciones[@%db:id_articulo;%@]" class="insertext" size="120">
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5"></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="4"></td>
 </tr>
 <tr> <td colspan="13" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td colspan="5" ></td>
 <td></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="3"></td>
 <td></td>
 </tr>
 <!-- aqui termina el registro -->
 @%end-where:%@ 
 
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 <td></td>
 <td></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Revenu imposable</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta">Taxe %</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="120">Reteneu équivalent %</td>
 <td width="1" height="20" bgcolor="#DBE0E3"></td>
 </tr>
 @%where:nodb|detalle_IVA;%@ 
 <!-- @%db:base_imponible;%@ -->
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="24" bgcolor="#DBE0E3" ></td>
 <td height="24" align="center" class="texto">@%db:total_bases_imponibles;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="center" height="24">@%db:recargo_iva;%@ / @%db:porcentaje;%@ %</td>
 <td class="texto" align="center" height="24" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center" height="24">@%db:recargo_equivalente;%@ / @%db:porcentaje_recargo_equivalente;%@ %</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
 @%end-where:%@ 
 
 </table>
 </td>
 <td width="40"></td>
 <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Revenu imposable</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" height="20" class="etiqueta" align="center">Remises</td>
 <td width="1" height="20"></td>
 <td bgcolor="#DBE0E3" align="center" height="20" class="etiqueta" width="80">Montant</td>
 <td width="1" bgcolor="#DBE0E3" height="20"></td>
 </tr>
 @%where:nodb|detalle_descuentos;%@
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="24"></td>
 <td align="center" class="texto" height="24">@%db:base_imponible;%@</td>
 <td bgcolor="#DBE0E3" height="24"> </td>
 <td class="texto" align="center" height="24">@%db:descuento_directo;%@@%db:descuento_pronto_pago;%@</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 <td class="texto" align="right" height="24">@%db:importe;%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" height="24"></td>
 </tr>
 <tr> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td height="1" bgcolor="#DBE0E3" colspan="7"></td>
 </tr>
 @%end-where:%@ 

 </table>
 </td>
 </tr>
 </table>
 @%where:nodb|detalle_totales;%@
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
 <tr> <td width="195" rowspan="2"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#DBE0E3"> <td colspan="2" height="1"></td>
 <td rowspan="11" width="1"></td>
 </tr>
 <tr> <td align="right" class="texto" width="112" bgcolor="#EBECED">Total revenu imposable:</td>
 <td width="81" height="22" class="texto"> @%db:total_bases_imponibles;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Totals Impôt:</td>
 <td width="81" height="22" class="texto"> @%db:total_impuestos;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Rétention:</td>
 <td width="81" height="22" class="texto"> @%db:total_retenciones;%@ </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Reteneu équivalent:</td>
 <td width="81" height="22" class="texto"> @%db:total_recargo_equivalente;%@</td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1" align="right"></td>
 </tr>
 <tr> <td align="right" class="texto" bgcolor="#EBECED" width="112">Total Remise:</td>
 <td width="81" height="22" class="texto"> @%db:total_descuentos;%@ <!--@%db:total_sin_retencion;%@-->
 </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#DBE0E3" height="1"></td>
 </tr>
 </table>
 </td>
 <td width="11" bgcolor="#FFFFFF" valign="top" rowspan="2"> </td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="125" bgcolor="#EBECED" valign="middle" class="texto" height="22">Notes:</td>
 <td width="6" bgcolor="#EBECED" valign="top" rowspan="2"></td>
 <td width="11" rowspan="2"></td>
 <td width="162" valign="top" rowspan="2"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" bgcolor="#CCD2D7" class="etiqueta" height="22">Montant </td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td height="22" align="right" width="99%" class="texto"> <!-- importe total del pedido (aplicados descuentos, ivas y retenciones)-->
 @%db:total_del_todo;%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="3" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td width="125" bgcolor="#EBECED" valign="top"> <!-- Notas del pedido -->
 <textarea name="registro[observaciones]" cols="30" wrap="VIRTUAL" rows="4"></textarea>
 </td>
 </tr>
 </table>
 @%end-where:%@ 

