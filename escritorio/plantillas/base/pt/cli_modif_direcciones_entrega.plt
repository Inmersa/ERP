@%where:tabla|Direcciones_entrega;%@
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" >&gt; Alterar Endere�o de Entrega</td>
 <td width="46" align="center" ><a href="?seccion=cli_modif_clientes" class="accesos">Voltar</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="194" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> <td class="texto"></td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 <tr> <td class="texto" valign="top">Modificar Endere�o de Entrega</td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td bgcolor="#FFFFFF" width="3"></td>
 <td bgcolor="@%get:color_accesos_mensaka%@" valign="top">
 @%plt:mensajero%@
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_direcciones_entrega" action="?seccion=cli_modif_clientes" method=post>
 <input type=hidden name=registro_dir[id_direccion] value="@%db:Direcciones_entrega.id_direccion;%@">
 <!--@%Direcciones_entrega.id_direccion;%@-->
 <tr> <td height="21" bgcolor="#CCD2D7" width="5" class="etiqueta"></td>
 <td height="21" bgcolor="#CCD2D7" class="etiqueta" colspan="3"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Nome:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" > <input type="text" name="registro_dir[nombre]" class="insertext" size="35" value="@%db:Direcciones_entrega.nombre;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Endere�o:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[direccion]" class="insertext" size="35" value="@%db:Direcciones_entrega.direccion;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Localidade:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[poblacion]" class="insertext" size="35" value="@%db:Direcciones_entrega.poblacion;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Distrito</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <select name="registro_dir[id_provincia]" class="insertext">

 @%func:obtener_Provincia2%@
 <!--@%db:Direcciones_entrega.id_provincia;%@-->

@%where:tabla|Provincias;order|nombre;nolink|1;%@

 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_provincia%@>@%db:Provincias.nombre;%@</option>

 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">CP:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[cp]" class="insertext" size="35" value="@%db:Direcciones_entrega.cp;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">e-mail:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[email]" class="insertext" size="35" value="@%db:Direcciones_entrega.email;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Telefone:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[telefono1]" class="insertext" size="35" value="@%db:Direcciones_entrega.telefono1;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Fax:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[fax]" class="insertext" size="35" value="@%db:Direcciones_entrega.fax;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Pessoa de Contacto:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.persona_contacto;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Cargo do Contacto:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <input type="text" name="registro_dir[cargo_persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.cargo_persona_contacto;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185" valign="top">Observa��es:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <textarea name="registro_dir[observaciones]" class="insertext" rows="7" cols="75">@%db:Direcciones_entrega.observaciones;%@</textarea>
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr align="center"> <input type="hidden" name="accion_ejecutar" value="Modificar">
 <td colspan="4" height="22" bgcolor="#CCD2D7"> <a href="" onclick="document.forms['modif_direcciones_entrega'].submit();return false;" class="accesos">Alterar</a> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="25"></td>
 </tr>
 </table>

 @%end-where:%@


