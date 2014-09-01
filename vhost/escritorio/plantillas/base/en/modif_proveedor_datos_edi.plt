 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <!--@%db:Proveedores.id_proveedor;%@-->
 <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Name:</td>
 <td width="228"> <input type="text" name="registro[nombre]" class="insertext" size="30" value="@%db:Proveedores.nombre;%@"/>
 </td>
 <td width="87" class="titul1" align="right" bgcolor="#EBECED">EIN (intracom.):</td>
 <td width="168">
 <input type="text" name="registro[prefijo_cif]" value="@%db:Proveedores.prefijo_cif;%@" size="2" maxlength="2" class="insertext">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Company Name:</td>
 <td width="228"> <input type="text" name="registro[razon_social]" class="insertext" size="30" value="@%db:Proveedores.razon_social;%@"/>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">EIN:</td>
 <td width="168"> <input type="text" name="registro[cif]" value="@%db:Proveedores.cif;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="titul1" height="22">Address:</td>
 <td width="228"> <input type="text" name="registro[domicilio]" value="@%db:Proveedores.domicilio;%@" class="insertext" size="30"/>
 </td>
 <td bgcolor="#EBECED" width="87" align="right" class="titul1">City:</td>
 <td width="168"> <input type="text" name="registro[poblacion]" value="@%db:Proveedores.poblacion;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Area:</td>
 <td width="228"> <select name="registro[id_provincia]" class="insertext">
 <option value="">No selection</option>

 @%func:obtener_Provincias%@

 <!--@%db:Proveedores.id_provincia;%@-->


 @%where:tabla|Provincias;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_Provincias%@> @%db:Provincias.nombre;%@ </option>

 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Postal Code:</td>
 <td width="168"> <input type="text" name="registro[cp]" value="@%db:Proveedores.cp;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Contact person:</td>
 <td width="228"> <input type="text" name="registro[persona_contacto]" value="@%db:Proveedores.persona_contacto;%@" class="insertext" size="30"/>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Phone 1:</td>
 <td width="168"> <input type="text" name="registro[telefono1]" value="@%db:Proveedores.telefono1;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Contact role:</td>
 <td width="228"> <input type="text" name="registro[cargo_persona_contacto]" value="@%db:Proveedores.cargo_persona_contacto;%@" class="insertext" size="30"/>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Phone 2:</td>
 <td width="168"> <input type="text" name="registro[telefono2]" value="@%db:Proveedores.telefono2;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="titul1" height="22">Web:</td>
 <td width="228"> <input type="text" name="registro[web]" value="@%db:Proveedores.web;%@" class="insertext" size="30"/>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Fax:</td>
 <td width="168"> <input type="text" name="registro[fax]" value="@%db:Proveedores.fax;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td width="161" height="22" align="right" bgcolor="#EBECED" class="titul1">Register date:</td>
 <td width="228" class="texto">
 <input type="hidden" name="registro[fecha_alta]" value="@%db:Proveedores.fecha_alta;%@">
 @%db:colocar_fecha{Proveedores.fecha_alta};%@</td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">e-mail:</td>
 <td width="168"> <input type="text" name="registro[email]" value="@%db:Proveedores.email;%@" class="insertext" size="20"/>
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="4" height="22"></td>
 </tr>
 </table>

 <table width="644" border="0" cellspacing="0" cellpadding="0">
@%where:tabla|Proveedores_empresas;where|Proveedores_empresas.id_empresa = $id_empresa;%@
<!-- @%db:Proveedores_empresas.id_proveedor%@ -->


<input type=hidden name=registro2[id_usr] value="@%db:Proveedores_empresas.id_usr%@">

 <tr> <td colspan="4" height="22" bgcolor="#CCD2D7"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" height="20" ></td>
 <td class="titul1" height="20" >General Information</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="4" height="8"></td>
 </tr>
 <tr> <td align="right" height="22" bgcolor="#EBECED" class="titul1" width="161">Payment Rules:</td>
 <td height="22" bgcolor="#EBECED" width="245"> <!--@%db:Proveedores_empresas.id_forma_pago;%@-->
 @%func:obtener_Forma_pago%@ <select name="registro2[id_forma_pago]" class="insertext">
@%where:tabla|Forma_pago;nolink|1;%@
 <option value="@%db:Forma_pago.id_forma_pago;%@" @%func:chequear_Forma_pago;%@>
 @%db:Forma_pago.nombre;%@ </option>
@%end-where:%@

 </select>
 </td>
 <td class="titul1" height="22" bgcolor="#EBECED" align="right" width="106"></td>
 <td height="22" bgcolor="#EBECED" width="132"></td>
 </tr>
 <tr> <td colspan="4" height="1"></td>
 </tr>
 <tr> <td class="titul1" height="22" bgcolor="#EBECED" align="right" width="161">Currency:</td>
 <td height="22" bgcolor="#EBECED" width="245"> <!--@%db:Proveedores.id_divisa;%@ @%set:_selected_value=Proveedores.id_divisa;%@-->
 Div: @%db:Proveedores.id_divisa;%@
 <select name="registro[id_divisa]" class="insertext">
@%where:tabla|Divisa;nolink|1;%@
 <option value="@%db:Divisa.id_divisa;%@" @%db:selected_value{Divisa.id_divisa};%@ >@%db:Divisa.nombre;%@</option>
@%end-where:%@

 </select>
 </td>
 <td class="titul1" height="22" bgcolor="#EBECED" align="right" width="106"></td>
 <td height="22" bgcolor="#EBECED" width="132"></td>
 </tr>
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" height="22" align="right" class="titul1">Deduction:</td>
 <td colspan="3" height="22"> <input type="text" name="registro[retencion]" value="@%db:Proveedores.retencion;%@" class="insertext" size="5" maxlength="5"/>
 </td>
 </tr>
 </table>
