<html>
<head>
<title>Fiche de Client</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
@%if:esta_vacio;id_cliente_pda;%@
Nones.

@%else:%@
@%where:tabla|Clientes;where|Clientes.id_cliente = $id_cliente_pda;%@
<form method="post" name="ficha_cliente" action="?seccion=@%env:_krn_ss_name;%@">
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">Inmersa Empresa: i-CFV</td>
 </tr>
<tr> <td class="accesos" align="right"></td>
 </tr>

</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">Client</td>
</tr>
<tr> <td class="titul1" align="left" width="68">Nom:</td>
 <td width="132">@%db:Clientes.nombre%@ @%db:Clientes.apellidos%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="68">NSF:</td>
 <td width="132">@%db:Clientes.cif%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="68">Raison sociale:</td>
 <td width="132">@%db:Clientes.razon_social%@</td>
 </tr>

<tr> <td class="titul1" align="left" width="68">Direction de facturacion:</td>
 <td width="132">@%db:Clientes.direccion_facturacion%@</td>
 </tr>

<tr> <td class="titul1" align="left" width="68">Ville:</td>
 <td width="132">@%db:Clientes.poblacion%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="68">T�l�phone<span class="titul1">o</span>Non:</td>
 <td width="132">@%db:Clientes.telefono1%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="68">CP:</td>
 <td width="132">@%db:Clientes.cp%@</td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">

<tr> <td class="accesos" align="left"><a href="?seccion=pda_direcciones_entrega&id_cliente=@%db:Clientes.id_cliente%@"
class="accesos">>Voir Direction � remise</a></td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="accesos2" align="left">Effets</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
 </table>
 @%where:tabla|Efectos;where|Efectos.emitido = 1 AND fecha_vencimiento < NOW() AND ABS(monto_pagado) < ABS(monto);%@
 <input type="hidden" name="pago[@%db:Efectos.id_efecto;%@][id_efecto]" value="@%db:Efectos.id_efecto%@" >
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td align="left" class="titocho" width="123">&gt;&gt;@%db:Facturas.referencia%@</td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="123">Date</td>
 <td align="left" width="77">@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="123">Paiemnet Partiel</td>
 <td> <input type="text" border="cccccc" name="pago[@%db:Efectos.id_efecto%@][importe]" class="insertext" size="10">
 </td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="123">Moyen de payant</td>
 <td> <select name="pago[@%db:Efectos.id_efecto%@][medio_pago]" size="1">
 <option value="efectivo">Liquidit�s</option>
 <option value="cheque">Ch�que</option>
 <option value="transferencia">Transfert</option>
 <option value="pagare">Billet</option>
 <option value="recibo">R�ception</option>
 </select>
 </td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="123"> Montant </td>
 <td align="left" width="77">
 <input type="hidden" name="pago[@%db:Efectos.id_efecto%@][monto_pagado]" value="@%db:Efectos.monto_pagado%@">
 <input type="hidden" name="pago[@%db:Efectos.id_efecto%@][monto]" value="@%db:Efectos.monto%@">
 <!-- @%set:pagado = Efectos.monto_pagado;%@ @%set:importe = Efectos.monto;%@ -->
 @%calc:importe - pagado;output|1;round|2;%@ @%db:Divisa.leyenda%@
 </td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="123">Notes</td>
 <td><textarea type="text" border="cccccc" name="pago[@%db:Efectos.id_efecto%@][notas]" 
 	class="insertext" cols="20" rows="2"></textarea></td>
 </tr>

 <tr>
<td height="10"></td>
</tr>
 </table>
 @%end-where:%@

 <!-- Terminar esto! 
 <table width="201" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="154">Commandes en suspens</td>
 </tr>
 <tr>
 <td align="left" class="accesos" width="154">R�f�rence </td>
 <td align="left" width="154">Date </td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="154"> Revenu imposable</td>
 <td align="left" width="46"> Euros</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
</table>
 -->
 
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td class="accesos" align="left"><a href="?seccion=pda_clientes_ruta"
class="accesos">Home</a></td>
 <td class="accesos" align="right"><a href="?seccion=pda_hacer_pedido&id_cliente=@%db:Clientes.id_cliente%@">Passer une commande</a></td>
 <td class="accesos" align="right"><a href="#" onClick="document.forms['ficha_cliente'].submit(); return false;">Accepter</a></td>
 <td class="accesos" align="right">
@%if:esta_vacio;id_cita_pda;%@
@%else:%@
@%where:tabla|Citas;where|Citas.id_cita = $id_cita_pda;nolink|1;%@
<a href="?seccion=pda_cerrar_cita&id_cita=@%db:Citas.id_cita%@">Terminer</a>
@%end-where:%@

@%end-if:%@
</td>
 </tr>

<tr>
<td height="10"></td>
</tr>
 </table>
</form>
@%end-where:%@

@%end-if:%@
</body>
</html>

