<table class="full">
 <form name="nuevo_empresas" action="?seccion=bo_empresas" method=post>
 <input type=hidden name=estado value=4>
 <tr> <td bgcolor="#CCD2D7"> <table class="full">
 <tr> <td width="6" ></td>
 <td class="titocho" >&gt; NUEVA EMPRESA</td>
 <td ></td>
 <td ><a href="javascript: history.go(-1);" >Volver</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"></td>
 </tr>
 <tr> <td> <table class="full">
 <tr> <td width="194" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> 
 <td >Resultados obtenidos: </td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td width="3"></td>
 <td bgcolor="@%get:color_accesos_mensaka%@" valign="top"> 
@%plt:mensajero%@
</td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="13"></td>
 </tr>
 <tr> 
 <td > <table class="full">
 <tr bgcolor="#CCD2D7"> <td ></td>
 </tr>
 <tr> <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="etiqueta" >Nombre:</td>
 <td > <input type="text" name="registro[nombre]" >
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7"></td>
 <td bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td class="etiqueta" >Grupo al que pertenece:</td>
 <td > <select name="registro[id_grupo_empresa]">
@%where:tabla|Grupo_empresas;nolink|1;%@
 <option value="@%db:Grupo_empresas.id_grupo_empresa;%@"> @%db:Grupo_empresas.nombre;%@ </option>

 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" ></td>
 <td bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td class="etiqueta" >Razón social:</td>
 <td > <input type="text" name="registro[razon_social]" >
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" class="etiqueta" ></td>
 <td bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td class="etiqueta" >Dirección de facturación:</td>
 <td > <input type="text" name="registro[direccion_facturacion]" >
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" ></td>
 <td bgcolor="#CCD2D7" ></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 <table class="full">
 <tr> <td colspan="4" ></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td class="etiqueta" >CIF:</td>
 <td > <input type="text" name="registro[prefijo_cif]" class="insertextnumeros" size="3">
 <input type="text" name="registro[cif]" class="insertextnumeros">
 </td>
 <td width="87" class="etiqueta" >Teléfono 1:</td>

 <td width="168"> <input type="text" name="registro[telefono1]" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td class="etiqueta" >Población:</td>
 <td > <input type="text" name="registro[poblacion]" size="30">
 </td>
 <td width="87" class="etiqueta" >Teléfono 2:</td>
 <td width="168"> <input type="text" name="registro[telefono2]" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td class="etiqueta" >CP:</td>
 <td > <input type="text" name="registro[cp]" class="insertextnumeros">
 </td>
 <td width="87" class="etiqueta" >Fax:</td>
 <td width="168"> <input type="text" name="registro[fax]" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td class="etiqueta" >Provincia:</td>
 <td > <select name="registro[id_provincia]" >
@%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" >@%db:Provincias.nombre;%@</option>

 @%end-where:%@

</select>

 </td>
 <td width="87" class="etiqueta" >web:</td>
 <td width="168"> <input type="text" name="registro[web]" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> 
 <td class="etiqueta"></td>
 <td > </td>
 <td width="87" class="etiqueta">e-mail:</td>
 <td width="168"> <input type="text" name="registro[email]" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" ></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td > <table class="full">
 <tr> <td colspan="6" class="etiqueta" ></td>
 </tr>
 <tr> <td colspan="6" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr > 
 <td width="124" class="etiqueta" >Prefijo factura:</td>
 <td width="57"> <input type="text" name="registro[prefijo_fact]" class="insertextnumeros" size="6">
 </td>
 <td class="etiqueta" width="124" >Sufijo factura:</td>
 <td width="67"> <input type="text" name="registro[sufijo_fact]" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="etiqueta" ></td>
 <td width="124" > </td>
 </tr>
 <tr > 
 <td width="124" class="etiqueta" >Prefijo pedido:</td>
 <td width="57"> <input type="text" name="registro[prefijo_ped]" class="insertextnumeros" size="6">
 </td>
 <td class="etiqueta" width="124" >Sufijo pedido:</td>
 <td width="67"> <input type="text" name="registro[sufijo_ped]" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="etiqueta" >Contador pedido:</td>
 <td width="124" > <input type="text" name="registro[contador_ped]" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr > 
 <td width="124" class="etiqueta" >Prefijo albarán:</td>
 <td width="57"> <input type="text" name="registro[prefijo_alb]" class="insertextnumeros" size="6">
 </td>
 <td class="etiqueta" width="124" >Sufijo albarán:</td>
 <td width="67"> <input type="text" name="registro[sufijo_alb]" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="etiqueta" >Contador albarán:</td>
 <td width="124" > <input type="text" name="registro[contador_alb]" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr > 
 <td width="124" class="etiqueta" >Prefijo presupuesto:</td>
 <td width="57"> <input type="text" name="registro[prefijo_pre]" class="insertextnumeros" size="6">
 </td>
 <td class="etiqueta" width="124" >Sufijo presupuesto:</td>
 <td width="67"> <input type="text" name="registro[sufijo_pre]" class="insertextnumeros" size="6">
 </td>
 <td width="148" class="etiqueta" >Contador presupuesto:</td>
 <td width="124" > <input type="text" name="registro[contador_pre]" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr> <td colspan="6" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td colspan="6" >
 <table class="full">
 <tr> <td colspan="2"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" class="etiqueta">Otros datos</td>
 </tr>
 <tr> <td width="125" class="etiqueta"> Retenci&oacute;n a aplicar:
 </td>
 <td width="519"> <input type=text name=registro[retencion] size="6" >
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" ></td>
 </tr>
 <tr > <td class="etiqueta">Stock negativo:</td>
 <td ><input type="checkbox" name="registro[stock_negativo]" value="1"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td class="etiqueta" colspan="2"></td>
 <tr> <td colspan="2" ></td>
 </tr>
 </table>
 <table class="full">
 <tr> <td class="etiqueta">Login:</td>
 <td width="483"> <input type=text name=registro[login] size="20" >
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" ></td>
 </tr>
 <tr> <td class="etiqueta">Contraseña:</td>
 <td width="483"> 
 <input type=text name=registro[passwd] size="20" >
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" ></td>
 </tr>
 <tr> <td class="etiqueta">Repetir contraseña:</td>
 <td width="483"> 
 <input type=text name=registro[passwd2] size="20" >
 </td>
 </tr>
 <tr> <td colspan="2" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr > <td colspan="6" bgcolor="#CCD2D7">
<a href="javascript:document.forms['nuevo_empresas'].submit();" >Guardar</a>
</table>
</td> 
</tr>
 <tr> <td > </td>
 </tr>

</form>
 </table>
