 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Company</td>
 </tr>
 @%where:tabla|Empresas;nolink|1;where|id_empresa = $id_empresa;%@
<!--
nombre @%db:Empresas.nombre;%@
Convendria colocar estos campos:
prefijo cif @%db:Empresas.prefijo_cif;%@
cif @%db:Empresas.cif;%@
web @%db:Empresas.web;%@
email @%db:Empresas.email;%@
-->
 <tr> <td height="22"></td>
 <td height="22" class="texto">@%db:Empresas.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:Empresas.poblacion;%@</td>
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
 <td class="texto" height="22">Fax: @%db:Empresas.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Tel. @%db:Empresas.telefono1;%@</td>
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
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Client</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
<!--
nombre @%db:Clientes.nombre;%@
persona contacto @%db:Clientes.persona_contacto;%@
cargo persona contacto @%db:Clientes.cargo_persona_contacto;%@
web @%db:Clientes.web;%@
telefono 2 @%db:Clientes.telefono2;%@
-->
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Name:</td>
 <td height="22" colspan="3" class="texto">@%db:Clientes.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Code:</td>
 <td colspan="3" class="texto">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Address:</td>
 <td colspan="3" class="texto">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">City:</td>
 <td class="texto" colspan="3"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Area:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">Postal Code:</td>
 <td class="texto">@%db:Clientes.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">EIN:</td>
 <td colspan="3" class="texto">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Telephone:</td>
 <td class="texto">@%db:Clientes.telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Fax:</td>
 <td class="texto">@%db:Clientes.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>
 @%end-where:%@

 </table>
 </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
<tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
<tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">External Ref.:</td>
 <td colspan="2" class="texto"> @%db:Pedidos.referencia_externa;%@
 </td>
 <td bgcolor="#EBECED" class="texto" align="right"></td>
 <td colspan="3"></td>
 </tr>
 <tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
<tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">Reference:</td>
 <td colspan="2" class="texto"> @%db:Pedidos.referencia;%@
 </td>
 <td bgcolor="#EBECED" class="texto" align="right">Done by:</td>
 <td colspan="3"> <font color="red">
<!--@%wdb:Pedidos.id_agente%@--> @%func:obtener_agente%@
 <select name="registro2[id_agente]" class="insertext">
@%where:tabla|Agentes;order|nombre;where|Agentes.id_empresa = $id_empresa;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"@%func:chequear_agente%@>
@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@ 
</option>
 @%end-where:%@

 </select>
</font>
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22">Date:</td>
 <td width="100"> <input type="text" name="textfield25" class="insertextnumeros" size="13" value="@%db:colocar_fecha{Pedidos.fecha};%@" maxlength="10">
 </td>
 <td bgcolor="#EBECED" align="right" class="texto" width="95">Method of payment:</td>
 <td colspan="2">
<!--@%db:Pedidos.id_forma_pago;%@-->
@%func:obtener_forma_pago%@
<select name="forma_pago" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@ 
<option value="@%db:Forma_pago.id_forma_pago;%@" @%func:chequear_forma_pago%@>@%db:Forma_pago.nombre;%@ 
</option>

 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" class="texto" align="right">Currency:</td>
 <td class="texto">@%db:Divisa.nombre;%@
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>

</table>