@%where:tabla|Facturas;where|Facturas.id_factura = $id_factura and Facturas.id_empresa = $id_empresa;not_ruta_path|Agentes_facturas;ruta_path|Pedidos_facturas,Facturas;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED"> <table width="312" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" height="22" width="6"> </td>
 <td bgcolor="#CCD2D7" height="22" class="etiqueta">Empresa</td>
 </tr>
 @%where:nodb|detalle_empresa;%@
<!--
nombre @%db:nombre;%@
Convendria colocar estos campos:
prefijo cif @%db:prefijo_cif;%@
cif @%db:cif;%@
web @%db:web;%@
email @%db:email;%@
-->
 <tr> <td height="22"></td>
 <td height="22" class="texto">@%db:razon_social;%@</td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1"></td>
 <td bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td></td>
 <td class="texto" height="22">@%db:direcion_facturacion;%@</td>
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
 <td class="texto" height="22">@%db:provincia;%@</td>
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
 <tr> <td bgcolor="#CCD2D7" height="22" align="right" class="etiqueta" width="80">Prove�dor</td>
 <td bgcolor="#CCD2D7" height="22" width="90"></td>
 <td bgcolor="#CCD2D7" height="22" width="60"></td>
 <td bgcolor="#CCD2D7" height="22"></td>
 </tr>
 @%where:Tabla|Proveedores;not_ruta_path|Agentes,Direcciones_entrega;ruta_path|Proveedores;%@
<!--
nombre @%db:Proveedores.nombre;%@
persona contacto @%db:Proveedores.persona_contacto;%@
cargo persona contacto @%db:Proveedores.cargo_persona_contacto;%@
web @%db:Proveedores.web;%@
telefono 2 @%db:Proveedores.telefono2;%@
-->
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



 </table>
 </td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="7" height="22"></td>
 </tr>
 <tr> <td colspan="7" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" width="80" height="22">Refer�ncia:</td>
 <td colspan="2" class="texto"> @%db:Facturas.referencia;%@
 </td>
 <td bgcolor="#EBECED" class="texto" width="95" align="right">Realitzar per:</td>
 <td colspan="3" class="texto"> 
<!--@%db:Pedidos.id_agente%@--> 
@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="texto" height="22">Data:</td>
 <td width="100" class="texto">@%db:colocar_fecha{Facturas.fecha};%@</td>
 <td bgcolor="#EBECED" align="right" class="texto" width="95">Forma de paga:</td>
 <td colspan="2" class="texto"> @%db:Forma_pago.nombre;%@ </td>
 <td bgcolor="#EBECED" width="50" class="texto" align="right">Divisa:</td>
 <td class="texto" >@%db:Divisa.nombre;%@
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </table>
 