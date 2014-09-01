
@%where:nodb|nodb_issuer_data;%@
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
<td width="10"></td>
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="90"></td>
<td width="343" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="titul" height="15" width="5" bgcolor="#EBECED"></td>
 <td class="titul" height="18" width="55" bgcolor="#EBECED">Domicile:</td>
 <td colspan="4" class="texto" height="15">@%db:direccion_facturacion;%@</td>
</tr>
<tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="18"bgcolor="#EBECED">Ville:</td>
 <td class="texto" colspan="4" height="15">@%db:poblacion;%@</td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Province / État:</td>
 <td class="texto" height="15" width="110">@%db:provincia;%@</td> <td class="titul" align="right" height="15" width="60" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:Empresas.cp;%@</td>
 <td class="texto" height="15" width="5"></td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">NSF:</td>
 <td colspan="4" class="texto" height="15">@%db:prefijo_cif;%@-@%db:cif;%@</td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Téléphone:</td>
 <td class="texto" height="15">@%db:telefono1;%@</td>
 <td align="right" class="titul" height="15"bgcolor="#EBECED">Télécopieur:</td>
 <td class="texto" height="15">@%db:fax;%@</td>
 <td class="texto" height="15"></td>
</tr>
 </table>
</td>
<td width="1"><img src="imag/p.gif" width="1" height="90"></td>
<td></td>
<td width="1"><img src="imag/p.gif" width="1" height="90"></td>
<td width="343" align="center" valign="middle">
@%set:id_emp=id_empresa%@
@%where:tabla|Empresas;where|id_empresa = $id_emp;nolink|1;%@
<!-- @%db:Empresas.id_empresa%@ -->
<img src="../catalogo/@%db:Catalogo_imagenes.nombre%@" height="80" >
@%end-where:%@

<td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
<td></td>
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> 
<td colspan="7" height="10"></td>
 </tr>

</table>

@%end-where:%@

@%where:nodb|nodb_reciever_data;%@
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
<td width="10"></td>
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="125"></td>
<td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr bgcolor="#CCD2D7"> <td height="20" class="titocho" width="5" bgcolor="#CCD2D7"></td>
 <td height="20" class="titocho" width="55" bgcolor="#CCD2D7">Client</td>
 <td height="15" width="110" bgcolor="#CCD2D7"></td>
 <td height="15" width="60"></td>
 <td height="15"></td>
 <td height="15" width="5"></td>
</tr>

<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Nom:</td>
 <td height="15" colspan="4" class="texto">@%db:razon_social;%@</td>
</tr>
<tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Code:</td>
 <td colspan="4" class="texto" height="15">@%db:id_cliente;%@</td>
</tr>
<tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Domicile:</td>
 <td colspan="4" class="texto" height="15">@%db:direccion_facturacion;%@</td>
</tr>
<tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Ville:</td>
 <td class="texto" colspan="4" height="15"> @%db:poblacion;%@</td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Province / État:</td>
<td class="texto" height="15">@%db:provincia;%@</td> <td class="titul" align="right" height="15" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:cp;%@</td>
 <td class="texto" height="15"></td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">NSF:</td>
 <td colspan="4" class="texto" height="15">@%db:prefijo_cif;%@-@%db:cif;%@</td>
</tr>
<tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Téléphone:</td>
 <td class="texto" height="15">@%db:telefono1;%@</td>
 <td align="right" class="titul" height="15" bgcolor="#EBECED">Télécopieur:</td>
 <td class="texto" height="15">@%db:fax;%@</td>
 <td class="texto" height="15"></td>
</tr>
 </table>
</td>
<td width="1"><img src="imag/p.gif" width="1" height="125"></td>
<td></td>
<td width="1"><img src="imag/p.gif" width="1" height="125"></td>
<td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td height="20" class="titocho" bgcolor="#CCD2D7" width="5"></td>
 <td height="20" class="titocho" bgcolor="#CCD2D7">Direction de facturacion </td>
</tr>
<tr>
 <td height="100" align="center" class="titocho"></td>
 <td height="100" align="center" class="titocho">@%db:persona_contacto;%@ (@%db:cargo_persona_contacto%@)<br>
@%db:direccion_facturacion;%@<br>
 @%db:cp;%@ - @%db:poblacion;%@ @%db:provincia;%@ <br>
 Tél- @%db:telefono1;%@<br/>
</td>
</tr>
 </table>
</td>
<td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 </tr>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
<td></td>
<td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
</table>
@%end-where:%@
