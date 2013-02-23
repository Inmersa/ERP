
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> 
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_direcciones_entrega" action="" method=post>
 <input type=hidden name="accion_ejecutar" value='Modificar'>
 <input type=hidden name=registro_dir[id_direccion] value="@%db:Direcciones_entrega.id_direccion;%@">
 <!--@%db:Direcciones_entrega.id_direccion;%@-->
 <tr> <td height="21" bgcolor="#CCD2D7" width="5" class="etiqueta"></td>
 <td height="21" bgcolor="#CCD2D7" class="etiqueta" colspan="3"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Nom:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto" > @%db:Direcciones_entrega.nombre;%@
<input type="hidden" name="registro_dir[nombre]" class="insertext" size="35" value="@%db:Direcciones_entrega.nombre;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Adreça:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.direccion;%@<input type="hidden" name="registro_dir[direccion]" class="insertext" size="35" value="@%db:Direcciones_entrega.direccion;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Població:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.poblacion;%@<input type="hidden" name="registro_dir[poblacion]" class="insertext" size="35" value="@%db:Direcciones_entrega.poblacion;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Província</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> <select name="registro_dir[id_provincia]" class="insertext">
 @%func:obtener_Provincias%@
 <!--@%db:Direcciones_entrega.id_provincia;%@-->
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_Provincias%@>@%db:Provincias.nombre;%@</option>
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
 <td height="22" class="texto"> @%db:Direcciones_entrega.cp;%@<input type="hidden" name="registro_dir[cp]" class="insertext" size="35" value="@%db:Direcciones_entrega.cp;%@">
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
 <td height="22" class="texto"> @%db:Direcciones_entrega.email;%@<input type="hidden" name="registro_dir[email]" class="insertext" size="35" value="@%db:Direcciones_entrega.email;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Telèfon:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.telefono1;%@<input type="hidden" name="registro_dir[telefono1]" class="insertext" size="35" value="@%db:Direcciones_entrega.telefono1;%@">
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
 <td height="22" class="texto"> @%db:Direcciones_entrega.fax;%@<input type="hidden" name="registro_dir[fax]" class="insertext" size="35" value="@%db:Direcciones_entrega.fax;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Persona de contacte:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.persona_contacto;%@<input type="hidden" name="registro_dir[persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.persona_contacto;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185">Càrrec de contacte:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.cargo_persona_contacto;%@<input type="hidden" name="registro_dir[cargo_persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.cargo_persona_contacto;%@">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="5"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="texto" width="185" valign="top">Observacions:</td>
 <td height="22" width="6" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" class="texto"> @%db:Direcciones_entrega.observaciones;%@
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#FFFFFF" width="5"></td>
 <td height="1" bgcolor="#FFFFFF" width="185"></td>
 <td height="1" bgcolor="#FFFFFF" width="6"></td>
 <td height="1" bgcolor="#CCD2D7" width="440"></td>
 </tr>
 <tr align="center"> <input type="hidden" name="Modificar" value="Modificar">
 <td colspan="4" height="22" bgcolor="#CCD2D7"> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="25"></td>
 </tr>
 </table>
