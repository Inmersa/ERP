<HTML>
<HEAD>
<TITLE>INMERSA - GESTI�N</TITLE>
<link rel="stylesheet" href="estilosprint.css" type="text/css">
</HEAD>
<BODY>

@%where:tabla|Pedidos;where|Pedidos.id_pedido = $id_pedido and Pedidos.id_empresa = $id_empresa;%@
<!--@%db:Pedidos.id_pedido;%@-->
@%where:tabla|Empresas;nolink|1;where|id_empresa = $id_empresa;%@

<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho">@%db:Empresas.nombre;%@</td>
 <td class="titul" align="right">Pag @%func:poner_num_p%@ de @%func:poner_tot_p%@</td>
 </tr>
 <tr> <td class="titocho" height="5" colspan="2"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> <td class="titocho" height="5" colspan="2"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td width="10"></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td width="343" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titul" height="15" width="5" bgcolor="#EBECED"></td>
 <td class="titul" height="18" width="55" bgcolor="#EBECED">Domicilio:</td>
 <td colspan="4" class="texto" height="15">@%db:Empresas.direccion_facturacion;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="18"bgcolor="#EBECED">Poblaci�n:</td>
 <td class="texto" colspan="4" height="15">@%db:Empresas.poblacion;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Provincia:</td>
 <td class="texto" height="15" width="110">@%db:Provincias.nombre;%@</td>
 <td class="titul" align="right" height="15" width="60" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:Empresas.cp;%@</td>
 <td class="texto" height="15" width="5"></td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">CIF:</td>
 <td colspan="4" class="texto" height="15">@%db:Empresas.prefijo_cif;%@-@%db:Empresas.cif;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Tel�fono:</td>
 <td class="texto" height="15">@%db:Empresas.telefono1;%@</td>
 <td align="right" class="titul" height="15"bgcolor="#EBECED">Fax:</td>
 <td class="texto" height="15">@%db:Empresas.fax;%@</td>
 <td class="texto" height="15"></td>
 </tr>



 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td></td>
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td width="343" align="center" valign="middle"><!--@%db:Empresas.id_imagen;%@--><img src="../catalogo/@%db:Catalogo_imagenes.nombre%@"
 height="80">
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td colspan="7" height="10"></td>
 </tr>


@%end-where:%@
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td width="10"></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">


@%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@

 <tr bgcolor="#CCD2D7"> <td height="20" class="titocho" width="5" bgcolor="#CCD2D7"></td>
 <td height="20" class="titocho" width="55" bgcolor="#CCD2D7">Cliente</td>
 <td height="15" width="110" bgcolor="#CCD2D7"></td>
 <td height="15" width="60"></td>
 <td height="15"></td>
 <td height="15" width="5"></td>
 </tr>

 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Nombre:</td>
 <td height="15" colspan="4" class="texto">@%db:Clientes.razon_social;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">C�digo:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Domicilio:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Poblaci�n:</td>
 <td class="texto" colspan="4" height="15"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Provincia:</td>
 <td class="texto" height="15">@%db:Provincias.nombre;%@</td>
 <td class="titul" align="right" height="15" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:Clientes.cp;%@</td>
 <td class="texto" height="15"></td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">CIF:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Tel�fono:</td>
 <td class="texto" height="15">@%db:Clientes.telefono1;%@</td>
 <td align="right" class="titul" height="15" bgcolor="#EBECED">Fax:</td>
 <td class="texto" height="15">@%db:Clientes.fax;%@</td>
 <td class="texto" height="15"></td>
 </tr>

 @%end-where:%@


 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td></td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="20" class="titocho" bgcolor="#CCD2D7" width="5"></td>
 <td height="20" class="titocho" bgcolor="#CCD2D7">Direcci&oacute;n de entrega</td>
 </tr>
 <tr>
 <td height="100" align="center" class="titocho"></td>
 <td height="100" align="center" class="titocho">@%db:Direcciones_entrega.nombre;%@<br>
 @%db:Direcciones_entrega.direccion;%@<br>

 @%db:Direcciones_entrega.cp;%@ - @%db:Direcciones_entrega.poblacion;%@<br>
 <!--@%wdb:Provincias.nombre;%@ va por agentes y los necesitamos --></td>

 </tr>
 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="10"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="30"></td>
 <td width="698"> <table width="698" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7" align="center"> <td height="15" class="titul">Pedido</td>
 <td class="titul">Fecha</td>
 <td class="titul">Forma de pago</td>
 <td class="titul">Realizado por</td>
 <td class="titul">Divisa</td>
 </tr>
 <tr align="center"> <td height="15" class="texto">@%db:Pedidos.referencia;%@</td>
 <td class="texto">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td class="texto">@%db:Forma_pago.nombre;%@</td>
 <td class="texto">@%db:Agentes.nombre;%@</td>
 <td class="texto">@%db:Divisa.nombre;%@</td>
 </tr>
 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="30"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr>
 <td colspan="3" height="15"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="105">Ref.</td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul">Producto</td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center" width="100">Marca</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="50">Cert.</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="35">Cantidad</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" class="titul" align="center" width="70" height="15">Precio</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center" width="40">IVA<span class="texto">%</span> </td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="73">Importe</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
</table>

<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="555" valign="top"> 
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <!-- aqui empieza el registro -->
 @%where:tabla|Lineas_detalle;where|Pedidos.id_pedido = $id_pedido and Pedidos.id_empresa = $id_empresa;not_ruta_path|IVAs;%@

 <tr> <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" width="105" >@%db:Articulos.referencia;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" >@%db:Articulos.nombre;;s|0,30;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" width="100" align="center" >@%db:Marcas.nombre;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" width="50">@%db:Certificados.nombre;s|0,7;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" width="35">@%db:Lineas_detalle.cantidad;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="center" class="texto" width="70">@%db:Lineas_detalle.precio_articulo;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" width="40">@%db:Tipos_IVA.porcentaje;%@</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="right" width="73">@%db:Lineas_detalle.monto_total;%@ &gt; Euro</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <!--chapuza por culpa de ruta @%db:Lineas_detalle.id_articulo;%@ (Tite: Sin comentarios 8D ) -->

 @%if:poner_cabecera%@
 
 </table>

 <table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" class="SaltoDePagina">
 <tr>
 <td></td>
 </tr>
</table>

@%where:tabla|Empresas;nolink|1;where|id_empresa = $id_empresa;nombre|empresas;%@

<table width="700" border="0" cellspacing="0" cellpadding="0" class="SaltoDePagina">
 <tr> <td class="titocho">@%db:Empresas.nombre;%@</td>
 <td class="titul" align="right">Pag @%func:poner_num_p%@ de @%func:poner_tot_p%@</td>
 </tr>
 <tr> <td class="titocho" height="5" colspan="2"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> <td class="titocho" height="5" colspan="2"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td width="10"></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td width="343" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titul" height="15" width="5" bgcolor="#EBECED"></td>
 <td class="titul" height="18" width="55" bgcolor="#EBECED">Domicilio:</td>
 <td colspan="4" class="texto" height="15">@%db:Empresas.direccion_facturacion;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="18"bgcolor="#EBECED">Poblaci�n:</td>
 <td class="texto" colspan="4" height="15">@%db:Empresas.poblacion;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Provincia:</td>
 <td class="texto" height="15" width="110">@%wdb:Provincias.nombre;%@</td>
 <td class="titul" align="right" height="15" width="60" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:Empresas.cp;%@</td>
 <td class="texto" height="15" width="5"></td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">CIF:</td>
 <td colspan="4" class="texto" height="15">@%db:Empresas.prefijo_cif;%@-@%db:Empresas.cif;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="18" class="titul" bgcolor="#EBECED">Tel�fono:</td>
 <td class="texto" height="15">@%db:Empresas.telefono1;%@</td>
 <td align="right" class="titul" height="15"bgcolor="#EBECED">Fax:</td>
 <td class="texto" height="15">@%db:Empresas.fax;%@</td>
 <td class="texto" height="15"></td>
 </tr>
 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td></td>
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 <td width="343" align="center" valign="middle"><!--@%db:Empresas.id_imagen;%@--><img src="../catalogo/@%db:Catalogo_imagenes.nombre%@"
 height="80">
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="90"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td colspan="7" height="10"></td>
 </tr>
</table>

@%end-where:%@

<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td width="10"></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">


@%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@

 <tr bgcolor="#CCD2D7"> <td height="20" class="titocho" width="5" bgcolor="#CCD2D7"></td>
 <td height="20" class="titocho" width="55" bgcolor="#CCD2D7">Cliente</td>
 <td height="15" width="110" bgcolor="#CCD2D7"></td>
 <td height="15" width="60"></td>
 <td height="15"></td>
 <td height="15" width="5"></td>
 </tr>

 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Nombre:</td>
 <td height="15" colspan="4" class="texto">@%db:Clientes.razon_social;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">C�digo:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.id_cliente;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Domicilio:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.direccion_facturacion;%@</td>
 </tr>
 <tr> <td class="titul" height="15" bgcolor="#EBECED"></td>
 <td class="titul" height="15" bgcolor="#EBECED">Poblaci�n:</td>
 <td class="texto" colspan="4" height="15"> @%db:Clientes.poblacion;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Provincia:</td>
 <td class="texto" height="15">@%wdb:Provincias.nombre;%@</td>
 <td class="titul" align="right" height="15" bgcolor="#EBECED">CP:</td>
 <td class="texto" height="15">@%db:Clientes.cp;%@</td>
 <td class="texto" height="15"></td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">CIF:</td>
 <td colspan="4" class="texto" height="15">@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
 </tr>
 <tr> <td height="15" class="titul" bgcolor="#EBECED"></td>
 <td height="15" class="titul" bgcolor="#EBECED">Tel�fono:</td>
 <td class="texto" height="15">@%db:Clientes.telefono1;%@</td>
 <td align="right" class="titul" height="15" bgcolor="#EBECED">Fax:</td>
 <td class="texto" height="15">@%db:Clientes.fax;%@</td>
 <td class="texto" height="15"></td>
 </tr>

 @%end-where:%@


 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td></td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 <td width="343" align="center" valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="20" class="titocho" bgcolor="#CCD2D7" width="5"></td>
 <td height="20" class="titocho" bgcolor="#CCD2D7">Direcci&oacute;n de entrega</td>
 </tr>
 <tr>
 <td height="100" align="center" class="titocho"></td>
 <td height="100" align="center" class="titocho">@%db:Direcciones_entrega.nombre;%@<br>
 @%db:Direcciones_entrega.direccion;%@<br>

 @%db:Direcciones_entrega.cp;%@ - @%db:Direcciones_entrega.poblacion;%@<br>
 @%wdb:Provincias.nombre;%@</td>

 </tr>
 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="125"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 <td></td>
 <td colspan="3"><img src="imag/p.gif" width="345" height="1"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="10"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="30"></td>
 <td width="698"> <table width="698" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7" align="center"> <td height="15" class="titul">Pedido</td>
 <td class="titul">Fecha</td>
 <td class="titul">Forma de pago</td>
 <td class="titul">Realizado por</td>
 <td class="titul">Divisa</td>
 </tr>
 <tr align="center"> <td height="15" class="texto">@%db:Pedidos.referencia;%@</td>
 <td class="texto">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td class="texto">@%db:Forma_pago.nombre;%@</td>
 <td class="texto">@%db:Agentes.nombre;%@</td>
 <td class="texto">@%db:Divisa.nombre;%@</td>
 </tr>
 </table>
 </td>
 <td width="1"><img src="imag/p.gif" width="1" height="30"></td>
 </tr>
 <tr> <td colspan="3"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr>
 <td colspan="3" height="15"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="105">Ref.</td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul">Producto</td>
 <td bgcolor="#DBE0E3" height="15" class="titul" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center" width="100">Marca</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="50">Cert.</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="35">Cantidad</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" class="titul" align="center" width="70" height="15">Precio</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center" width="40">IVA<span class="texto">%</span> </td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="73">Importe</td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
</table>


<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="555" valign="top"> 
<table width="700" border="0" cellspacing="0" cellpadding="0">


 @%else:%@

 @%end-if:%@

 @%end-where:%@

</table>

 <table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="155" valign="top">
 <table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="10"></td>
 </tr>
 <tr> <td valign="top"> <table width="326" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="326" height="1"></td>
 </tr>
 </table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" height="13" class="etiqueta" align="center" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="13" class="titul" align="center" width="95">Base imponible</td>
 <td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="13" class="titul">%</td>
 <td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="13" class="titul" width="77">IVA/IGIC</td>
 <td width="1" height="13" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="13" class="titul" width="77">R. equiv.</td>
 <td width="1" height="13" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%where:tabla|IVAs;%@ <!-- @%db:IVAs.id_iva;%@ -->
 <tr> <td height="15" bgcolor="#DBE0E3" ><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" align="center" class="texto">@%db:IVAs.monto;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" height="15">@%func:porcentaje_iva2%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" height="15">@%db:IVAs.recargo_iva;%@</td>
 <td class="texto" align="center" height="15" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" height="15">@%db:IVAs.recargo_equivalente;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%end-where:%@ </table>
 <table width="326" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="326" height="1"></td>
 </tr>
 </table>
 </td>
 <td width="187" height="63" align="center"> </td>
 <td valign="top" width="187"> <table width="187" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 </table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" height="15" bgcolor="#DBE0E3"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" class="titul" align="center" height="15">Descuento</td>
 <td width="1" height="15" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center" width="40">%</td>
 <td width="1" height="15" class="titul"><img src="imag/p.gif" width="1" height="15"></td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="73">Importe</td>
 <td width="1" bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%where:tabla|Descuentos;%@ <tr> <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="center" class="texto" height="15">@%db:Descuentos.monto_final;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="center" height="15">@%db:Descuentos.porcentaje%@ </td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="texto" align="right" height="15">@%db:Descuentos.monto_base;%@</td>
 <td bgcolor="#DBE0E3" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 @%end-where:%@ </table>
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
 <tr> <td width="171"> <table width="170" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="170" height="1"></td>
 </tr>
 <tr> <td> <table width="170" border="0" cellspacing="0" cellpadding="0">
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">T.B. Imponible:</td>
 <td width="1" height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td width="72" height="15" class="texto" align="right">@%func:calcular_base_imponible%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">T. Impuestos:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="right">@%func:calcular_total_ivas%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Retenci�n:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="right">@%func:calcular_total_retencion%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Recargo equiv:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="right">@%func:calcular_total_recargo_equivalencia%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Total descuento:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="right"> @%func:calcular_total_descuentos;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td><img src="imag/p.gif" width="170" height="1"></td>
 </tr>
 </table>
 </td>
 <td width="342" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="76"></td>
 <td> <table width="250" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="250" height="1"></td>
 </tr>
 <tr> <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="titul" bgcolor="#CCD2D7">Notas</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td><img src="imag/p.gif" width="1" height="60"></td>
 <td class="texto" valign="top">@%db:Pedidos.observaciones;%@</td>
 <td><img src="imag/p.gif" width="1" height="60"></td>
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
 <td width="187" valign="top"> <table width="187" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 <tr align="center" bgcolor="#CCD2D7"> <td height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="titul" height="15" bgcolor="#CCD2D7">Importe Total</td>
 <td height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" align="right" width="99%" class="titul"> @%func:calcular_total_del_todo;%@ </td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 </table>
 <table width="187" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td colspan="3" height="13"></td>
 </tr>
 <tr align="center"> <td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 <tr align="center" bgcolor="#CCD2D7"> <td height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td class="titul" height="15">Importe Total</td>
 <td height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" align="right" width="99%" class="titul">@%func:calcular_total_en_pesetas;%@ </td>
 <td width="1" height="15"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td colspan="3" height="1"><img src="imag/p.gif" width="187" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
</table>
 @%end-where:%@ 
 </BODY>
</HTML>
