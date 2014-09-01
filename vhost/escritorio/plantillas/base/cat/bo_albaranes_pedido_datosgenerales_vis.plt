@%where:tabla|Pedidos;nolink|1;where|id_pedido = $id_pedido;%@
 <!-- @%db:Pedidos.id_pedido%@ --> <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Empresa</td>
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

@%if:es_cliente;%@

 @%where:tabla|Clientes;nolink|1;where|Direcciones_entrega.id_direccion = $id_direccion;%@
<!--
@%db:Direcciones_entrega.id_direccion;%@
nombre @%db:Clientes.nombre;%@
persona contacto @%db:Clientes.persona_contacto;%@
cargo persona contacto @%db:Clientes.cargo_persona_contacto;%@
web @%db:Clientes.web;%@
telefono 2 @%db:Clientes.telefono2;%@
-->
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Client</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Nom:</td>
 <td height="22" colspan="3" class="texto">@%db:Clientes.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Codi:</td>
 <td colspan="3" class="texto">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Domicili:</td>
 <td colspan="3" class="texto">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Poblaci�:</td>
 <td class="texto" colspan="3"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Prov�ncia:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:Clientes.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">CIF:</td>
 <td colspan="3" class="texto">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Tel�fon:</td>
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


 @%else:%@

 @%where:Tabla|Proveedores;nolink|1;where|id_proveedor = $id_proveedor;%@
<!--
nombre @%db:Proveedores.nombre;%@
persona contacto @%db:Proveedores.persona_contacto;%@
cargo persona contacto @%db:Proveedores.cargo_persona_contacto;%@
web @%db:Proveedores.web;%@
telefono 2 @%db:Proveedores.telefono2;%@
-->
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Prove�dor</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 <tr> <td height="22" align="right" bgcolor="#EBECED" class="etiqueta">Nom:</td>
 <td height="22" colspan="3" class="texto">@%db:Proveedores.razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Codi:</td>
 <td colspan="3" class="texto">@%db:Proveedores.id_proveedor;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Domicili:</td>
 <td colspan="3" class="texto">@%db:Proveedores.domicilio;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Poblaci�:</td>
 <td class="texto" colspan="3"> @%db:Proveedores.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Prov�ncia:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:Proveedores.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">CIF:</td>
 <td colspan="3" class="texto">@%db:Proveedores.prefijo_cif;%@-@%db:Proveedores.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Tel�fon:</td>
 <td class="texto">@%db:Proveedores.telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Fax:</td>
 <td class="texto">@%db:Proveedores.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">e-mail:</td>
 <td colspan="3"><a href="mailto:@%db:Proveedores.email;%@" class="accesos">@%db:Proveedores.email;%@</a></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" colspan="4"></td>
 </tr>

 @%end-where:%@


 @%end-if:%@

 </table>
 </td>
 </tr>
 </table>
 </table>

