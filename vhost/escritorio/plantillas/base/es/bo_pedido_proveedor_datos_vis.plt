 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Empresa</td>
 </tr>
 @%where:nodb|nodb_issuer_data;%@
 <tr> <td height="22"></td>
 <td height="22" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Provincias.nombre;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Fax: @%db:fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Tel. @%db:telefono1;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td height="22"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%end-where:%@

 </table>
 </td>
 <td width="20"></td>
 <td> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Cliente</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:nodb|nodb_reciever_data;%@
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Nombre:</td>
 <td height="22" colspan="3" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Código:</td>
 <td colspan="3" class="texto">@%db:id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Domicilio:</td>
 <td colspan="3" class="texto">@%db:direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Población:</td>
 <td class="texto" colspan="3"> @%db:poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Provincia:</td>
 <td class="texto">@%db:provincia;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">CIF:</td>
 <td colspan="3" class="texto">@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Teléfono:</td>
 <td class="texto">@%db:telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Fax:</td>
 <td class="texto">@%db:fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:email;%@" class="accesos">@%db:email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>
 @%end-where:%@

 </table>
 </td>
 </tr>
 </table>
<form name="pedido" action="?seccion=bo_pedido_cliente" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
<input type="hidden" name="identificador_pedido" value="@%db:id_pedido%@">
<!-- @%set:id_documento=id_pedido%@ -->
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
<tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="71" height="22">Ref externa:</td>
 <td colspan="2" class="texto"> <input type="text" name="pedido[referencia_externa]" class="insertext" size="20" value="@%db:referencia_externa;%@">
 </td>
 <td bgcolor="#EBECED" class="texto" align="right" width="274">Incompleto:</td>
 <td colspan="3" align="center">
@%if:pedido_incompleto%@
 <a href="?seccion=bo_pedido_cliente&id_pedido=@%db:id_pedido_incompleto;%@" class="accesos" align="center"> Ver </a>
@%else:%@
@%end-if:%@
 </td>
 </tr>
 <tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="71" height="22">Referencia:</td>
 <td colspan="2" class="texto"> @%db:referencia;%@
 </td>
 <td bgcolor="#EBECED" class="texto" align="right" width="274">Realizado por:</td>
 <td colspan="3"> <font color="red">
 <!--
 @%db:id_agente%@
 @%set:_selected_value=id_agente%@
 --> <select name="pedido[id_agente]" class="insertext">
 @%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
 @%db:selected_value{Agentes.id_agente}%@
 >@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</option>
 @%end-where:%@

 </select>
</font>
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="71">Fecha:</td>
 <td width="75"> <input type="text" name="pedido[fecha]" class="insertextnumeros" size="13" value="@%db:colocar_fecha{fecha};%@" maxlength="10">
 </td>
 <td bgcolor="#EBECED" align="right" class="texto" width="69">Forma de pago:</td>
 <td colspan="2">
@%set:_selected_value=id_forma_pago%@
<select name="pedido[id_forma_pago]" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" @%db:selected_value{Forma_pago.id_forma_pago}%@
 >@%db:Forma_pago.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" class="texto" align="right" width="61">Divisa:</td>
 @%where:nodb|nodb_currency_data;%@
 <td class="texto" width="246">@%db:nombre_divisa;%@ @%end-where:%@ </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </table>
