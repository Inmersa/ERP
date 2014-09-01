<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Entreprise</td>
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
 <td class="texto" height="22">Télécopieur: @%db:Empresas.fax;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">Tél. @%db:Empresas.telefono1;%@</td>
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
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Code:</td>
 <td colspan="3" class="texto">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Domicile:</td>
 <td colspan="3" class="texto">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Ville:</td>
 <td class="texto" colspan="3"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Province / État:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:Clientes.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">NSF:</td>
 <td colspan="3" class="texto">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Téléphone:</td>
 <td class="texto">@%db:Clientes.telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Télécopieur:</td>
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
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Fournisseur</td>
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
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Code:</td>
 <td colspan="3" class="texto">@%db:Proveedores.id_proveedor;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Domicile:</td>
 <td colspan="3" class="texto">@%db:Proveedores.domicilio;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" class="etiqueta" height="22">Ville:</td>
 <td class="texto" colspan="3"> @%db:Proveedores.poblacion;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Province / État:</td>
 <td class="texto">@%db:Provincias.nombre;%@</td>
 <td bgcolor="#EBECED" class="etiqueta" align="right">CP:</td>
 <td class="texto">@%db:Proveedores.cp;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">NSF:</td>
 <td colspan="3" class="texto">@%db:Proveedores.prefijo_cif;%@-@%db:Proveedores.cif;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" align="right"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td align="right" bgcolor="#EBECED" height="22" class="etiqueta">Téléphone:</td>
 <td class="texto">@%db:Proveedores.telefono1;%@</td>
 <td bgcolor="#EBECED" align="right" class="etiqueta">Télécopieur:</td>
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
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">Référence:</td>
 <td width="204" class="texto">@%db:Albaranes.referencia;%@</td>
 <td bgcolor="#EBECED" class="texto" width="96" align="right">Magasin:</td>
 <td width="264" class="texto">@%db:Almacenes.nombre;%@</td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="80"> Ref. Commande:</td>
 <td class="texto" >@%if:AllowedLink;bo_pedido_cliente;%@<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" class="accesos">@%db:Pedidos.referencia;%@</a></td>
 @%end-if:%@
<td bgcolor="#EBECED" class="texto" align="right" >État </td>
 <td class="texto" > P <input type="checkbox" name="registro[preparado]" value="1" @%db:check_flag{Albaranes.preparado}%@> E <input type="checkbox" name="registro[enviado]" value="1" @%db:check_flag{Albaranes.enviado}%@> C <input type="checkbox" name="registro[confirmacion]" value="1" @%db:check_flag{Albaranes.confirmacion}%@> R <input type="checkbox" name="registro[devolucion]" value="1" @%db:check_fllag{Albaranes.devolucion}%@>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="80"> Ref. Commande:</td>
 <td class="texto" colspan="3" >
 @%db:Albaranes.observaciones;%@
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22" width="80">Date:</td>
 <td width="204">
 @%db:colocar_fecha{Albaranes.fecha};%@<input type="hidden" name="registro[fecha]" class="insertextnumeros" size="13" value="@%db:colocar_fecha{Albaranes.fecha};%@" maxlength="10">
 </td>
 <td width="96" align="right" bgcolor="#EBECED" class="texto">Transporteurs:</td>
 <td width="264" class="texto"> <select name="id_transportista" class="insertext">
 <!--@%db:Albaranes.id_transportista;%@-->

@%func:obtener_Transportistas;%@

@%where:tabla|Transportistas;nolink|1;%@

 <option value="@%db:Transportistas.id_transportista;%@" @%func:chequear_Transportistas;%@>@%db:Transportistas.nombre;%@</option>

 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
</table>
