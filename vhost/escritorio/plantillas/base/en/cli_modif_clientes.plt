
 @%where:tabla|Clientes;where|Clientes.id_cliente = $id_cliente_promocion ;%@ 
<table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="323" >&gt; Client Card</td>
 <td width="318" align="right" > <table width="260" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td ><a href="javascript: history.go(-1);" class="accesos">Return</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="30"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_clientes" action="?seccion=cli_modif_clientes" method=post>
<input type="hidden" name="accion_ejecutar" value="j">
<input type=hidden name=registro[id_cliente] value="@%db:Clientes.id_cliente;%@">
<input type=hidden name=registro[fecha_alta] value="@%db:Clientes.fecha_alta;%@">
<input type=hidden name=registro[id_usr] value="@%db:Clientes_empresas.id_usr;%@">
<input type=hidden name="registro[login]" value="@%func:nombre_login_real%@">
<tr> <td colspan="4" height="22" bgcolor="#CCD2D7"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" height="20" ></td>
 <!--@%Clientes.id_cliente;%@-->
 <td class="etiqueta" height="20" > Company clients</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" > <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Name:</td>
 <td width="228"> <input type="text" name="registro[nombre]" value="@%db:Clientes.nombre;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" align="right" class="etiqueta">Last name:</td>
 <td width="168"> <input type="text" name="registro[apellidos]" value="@%db:Clientes.apellidos;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Company Name:</td>
 <td width="228"> <input type="text" name="registro[razon_social]" value="@%db:Clientes.razon_social;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">EIN:</td>
 <td width="168"> <input type="text" name="registro[prefijo_cif]" value="@%db:Clientes.prefijo_cif;%@" class="insertextnumeros" size="1" maxlength="1">
 <input type="text" name="registro[cif]" value="@%db:Clientes.cif;%@" class="insertextnumeros" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="161" class="etiqueta" align="right" height="22" bgcolor="#EBECED">Invoicing address:</td>
 <td width="228"> <input type="text" name="registro[direccion_facturacion]" value="@%db:Clientes.direccion_facturacion;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">City:</td>
 <td width="168"> <input type="text" name="registro[poblacion]" value="@%db:Clientes.poblacion;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Area:</td>
 <td width="228"> <select name="registro[id_provincia]" class="insertext">
 <option value="">No selection</option>
 @%func:obtener_provincia%@
 <!--@%db:Clientes.id_provincia;%@-->
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_provincia%@ >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Postal Code:</td>
 <td width="168"> <input type="text" name="registro[cp]" value="@%db:Clientes.cp;%@" class="insertextnumeros" size="5">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td width="161" height="22" bgcolor="#EBECED" class="etiqueta" align="right">Contact person:</td>
 <td width="228"> <input type="text" name="registro[persona_contacto]" value="@%db:Clientes.persona_contacto;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Phone 1:</td>
 <td width="168"> <input type="text" name="registro[telefono1]" value="@%db:Clientes.telefono1;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td width="161" height="22" bgcolor="#EBECED" class="etiqueta" align="right">Contact role:</td>
 <td width="228"> <input type="text" name="registro[cargo_persona_contacto]" value="@%db:Clientes.cargo_persona_contacto;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Phone 2:</td>
 <td width="168"> <input type="text" name="registro[telefono2]" value="@%db:Clientes.telefono2;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="4" height="1"></td>
 </tr>
 <tr> <td width="161" height="22" bgcolor="#EBECED" class="etiqueta" align="right">Web:</td>
 <td width="228"> <input type="text" name="registro[web]" value="@%db:Clientes.web;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Fax:</td>
 <td width="168"> <input type="text" name="registro[fax]" value="@%db:Clientes.fax;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="161" height="22" class="etiqueta" align="right"></td>
 <td width="228"> </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">e-mail:</td>
 <td width="168"> <input type="text" name="registro[email]" value="@%db:Clientes.email;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="4" height="1"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Login:</td>
 <td width="483">
 @%func:nombre_login_real%@
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">{{fld_contrasea}}:</td>
 <td width="483">
 <input type=password name=registro[passwd] class="insertext" size="20">
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1" align="right"></td>
 </tr>
 <tr> <td width="161" align="right" bgcolor="#EBECED" height="22" class="etiqueta">Repeat password:</td>
 <td width="483">
 <input type=password name=registro[passwd2] class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="2" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" ></td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" > <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#EBECED"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" height="20" ></td>
 <td class="etiqueta" height="20" width="172" >Delivery addresses:</td>
 <td class="etiqueta" height="20" width="466" align="right" ><a href="?seccion=cli_nuevo_direcciones_entrega&amp;id_cliente=@%db:Clientes.id_cliente%@" class="accesos">Add address</a> <a href="" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Borrar');" class="accesos">Delete</a>
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 <tr> <td> @%where:tabla|Direcciones_entrega;order|Direcciones_entrega.nombre,Direcciones_entrega.direccion;%@
 <table width="500" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="10"></td>
 <td height="22" width="22" bgcolor="#EBECED" align="center"> <input type="checkbox" name="borrar_direcciones[@%db:Direcciones_entrega.id_direccion%@]" value="1">
 </td>
 <td><a href="?seccion=modif_direcciones_entrega&amp;id_direccion=@%db:Direcciones_entrega.id_direccion%@" class="accesos"> @%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@
 </a></td>
 </tr>
</table>
@%end-where:%@

 </td>
 </tr>
 <tr> <td height="22"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr bgcolor="#CCD2D7" align="center"> <td colspan="4" height="22" bgcolor="#CCD2D7"> 
<a href="" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Modificar');" class="accesos">Modify</a>
 </td>
 </tr>
 </>
 </table>
 </td>
 </tr>
 <tr> <td height="30"></td>
 </tr>
</form>
</table>

@%end-where:%@ 

