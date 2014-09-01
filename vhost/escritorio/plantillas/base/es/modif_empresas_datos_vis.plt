 
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td height="22" colspan="4"></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Nombre:</td>
 <td width="316" class="texto"> @%db:Empresas.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Empresas.nombre;%@" class="insertext">
 </td>
 </tr>
 <tr> <td height="1" width="161" bgcolor="#CCD2D7"></td>
 <td height="1" width="316" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Grupo al que pertenece:</td>
 <td width="316"> <select name="registro[id_grupo_empresa]" class="insertext">
 <option value="">-- Ninguna seleccion --</option>
 @%func:obtener_Grupo_empresas;%@
 <!--@%db:Empresas.id_grupo_empresa;%@-->
 @%where:tabla|Grupo_empresas;nolink|1;order|nombre;%@
 <option value="@%db:Grupo_empresas.id_grupo_empresa;%@" @%func:chequear_Grupo_empresas%@> @%db:Grupo_empresas.nombre;%@ </option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="161"></td>
 <td bgcolor="#CCD2D7" height="1" width="316"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="titul1" height="22">Razón social:</td>
 <td width="316" class="texto"> @%db:Empresas.razon_social;%@
<input type="hidden" name="registro[razon_social]" value="@%db:Empresas.razon_social;%@" class="insertext">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="161" align="right" class="titul1" height="1"></td>
 <td width="316" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="titul1" height="22">Dirección de facturación:</td>
 <td width="316" class="texto"> @%db:Empresas.direccion_facturacion;%@
<input type="hidden" name="registro[direccion_facturacion]" value="@%db:Empresas.direccion_facturacion;%@" class="insertext">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7" width="161"></td>
 <td height="1" bgcolor="#CCD2D7" width="316"></td>
 </tr>
 </table>
 </td>
 <td bgcolor="#CCD2D7" width="1"></td>
 <td width="166" align="center"> <table border="0" cellspacing="0" cellpadding="0" class="texto">
 <tr> 
 <td align="center"> <!-- PARA PINCHAR EL CATALOGO DE IMAGENES -->
 <a href="" onclick="return abrir_ventana('?seccion=bo_cat_radio&amp;arreguarda=1&amp;campo_destino=id_empresa&id_imagen=@%db:Catalogo_imagenes.id_imagen%@&tabla=Empresas&id_sub=@%db:Empresas.id_empresa%@');return false" class="accesos">Logotipo</a><br>
 <br>
 <a href="" onclick="return abrir_ventana('?seccion=bo_cat_radio&arreguarda=1&campo_destino=id_empresa&id_imagen=@%db:Catalogo_imagenes.id_imagen%@&tabla=Empresas&id_sub=@%db:Empresas.id_empresa%@');return false"> <img src="../catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="140" height="120"></a> <br>

 <input type=checkbox name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" checked>


<!-- FIN PARA PINCHAR EL CATALOGO DE IMAGENES -->
</td>
 </tr>
 </table>
</td>
 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr bgcolor="#FFFFFF"> <td height="1" colspan="4"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">CIF:</td>
 <td width="228" class="texto"> @%db:Empresas.prefijo_cif;%@
<input type="hidden" name="registro[prefijo_cif]" value="@%db:Empresas.prefijo_cif;%@" class="insertextnumeros" size="3">
 @%db:Empresas.cif;%@<input type="hidden" name="registro[cif]" value="@%db:Empresas.cif;%@" class="insertextnumeros">
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Teléfono 1:</td>

 <td width="168" class="texto"> @%db:Empresas.telefono1;%@
<input type="hidden" name="registro[telefono1]" value="@%db:Empresas.telefono1;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="titul1" align="right" height="22">Población:</td>
 <td width="228" class="texto"> @%db:Empresas.poblacion;%@
<input type="hidden" name="registro[poblacion]" value="@%db:Empresas.poblacion;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Teléfono 2:</td>
 <td width="168" class="texto"> @%db:Empresas.telefono2;%@
<input type="hidden" name="registro[telefono2]" value="@%db:Empresas.telefono2;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="titul1" height="22">CP:</td>
 <td width="228" class="texto"> @%db:Empresas.cp;%@
<input type="hidden" name="registro[cp]" value="@%db:Empresas.cp;%@" class="insertextnumeros">
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">Fax:</td>
 <td width="168" class="texto"> @%db:Empresas.fax;%@
<input type="hidden" name="registro[fax]" value="@%db:Empresas.fax;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td width="161" height="22" align="right" class="titul1" bgcolor="#EBECED">Provincia:</td>
 <td width="228"> 
<select name="registro[id_provincia]" class="insertext">
 <option value="">-- Ninguna seleccion --</option>
 @%func:obtener_provincia%@
 <!--@%db:Empresas.id_provincia;%@-->
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_provincia%@ >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select>
 </td>
 <td bgcolor="#EBECED" width="87" class="titul1" align="right">web:</td>
 <td width="168" class="texto"> @%db:Empresas.web;%@
<input type="hidden" name="registro[web]" value="@%db:Empresas.web;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> 
 <td width="161" height="22" align="right" class="titul1"></td>
 <td width="228"> </td>
 <td bgcolor="#EBECED" width="87" align="right" class="titul1">e-mail:</td>
 <td width="168" class="texto"> @%db:Empresas.email;%@
<input type="hidden" name="registro[email]" value="@%db:Empresas.email;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 </table>
