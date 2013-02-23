

<form name="modif_transportistas" action="?seccion=bo_transportistas" method="post">
<input type="hidden" name="registro[id_transportista]" value="@%db:Transportistas.id_transportista;%@">
<input type="hidden" name="estado" value="1">
<!--@%db:Transportistas.id_transportista;%@-->
<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Transportistas.nombre;%@" class="insertext" size="30"></td>
 <td class="etiqueta">Last name:</td>
 <td ><input type="text" name="textfield2233382" class="insertext" size="20"></td>
 </tr>
 <tr><td class="etiqueta" >Company Name:</td>
 <td ><input type="text" name="registro[razon_social]" value="@%db:Transportistas.razon_social;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >EIN:</td>
 <td ><input type="text" name="textfield2233383" class="insertext" size="20"></td>
 </tr>
 <tr><td class="etiqueta" >Address:</td>
 <td ><input type="text" name="registro[direccion]" value="@%db:Transportistas.direccion;%@" class="insertext" size="30"></td>
 <td class="etiqueta" >City:</td>
 <td ><input type="text" name="textfield2233384" class="insertext" size="20"></td>
 </tr>
 <tr><td class="etiqueta" >Area:</td>
 <td ><select name="registro[id_provincia]" class="insertext">
 <!--@%db:Transportistas.id_provincia;%@ @%set:_selected_value=Transportisas.id_provincia;%@-->
@%where:tabla|Provincias;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" 
 	@%db:selected_value{Provincias.id_provincia};%@
	>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td class="etiqueta" >Postal Code:</td>
 <td ><input type="text" name="registro[cp]" value="@%db:Transportistas.cp;%@" class="insertextnumeros" size="5"></td>
 </tr>
 <tr>
 <td class="etiqueta" >Phone 1:</td>
 <td ><input type="text" name="registro[telefono]" value="@%db:Transportistas.telefono;%@" class="insertextnumeros" size="14"></td>
 <td class="etiqueta" >Phone 2:</td>
 <td ><input type="text" name="registro[telefono2]" class="insertextnumeros" size="14"></td>
 </tr>
 <tr>
 <td class="etiqueta" >Fax:</td>
 <td ><input type="text" name="registro[fax]" value="@%db:Transportistas.fax;%@" class="insertextnumeros" size="14"></td>
 <td class="etiqueta" >e-mail:</td>
 <td colspan="3"><input type="text" name="registro[email]" value="@%db:Transportistas.email;%@" class="insertext" size="20"></td>
 </tr>
 </table>
 <table class="full">
 <tr>
   <td class="caption" colspan="6">IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Country / DC</td>
 <td><input type="text" name="registro[entidad]" value="@%db:Transportistas.entidad;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Branch</td>
 <td><input type="text" name="registro[oficina]" value="@%db:Transportistas.oficina;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta" >DC / Account Number</td>
 <td><input type="text" name="registro[dc_ccc]" value="@%db:Transportistas.dc_ccc;%@" size="2" maxlength="3" class="insertext">
 <input type="text" name="registro[cuenta_bancaria]" value="@%db:Transportistas.cuenta_bancaria;%@" class="insertext" size="11" maxlength="10"></td>
</tr>
 <tr>
 <td class="etiqueta">Bank</td>
 <td><input type="text" name="registro[iban]" value="@%db:Transportistas.iban;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Bank Identifier Code</td>
 <td><input type="text" name="registro[bic]" value="@%db:Transportistas.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Bank Basic Account Number</td>
 <td><input type="text" name="registro[bban]" value="@%db:Transportistas.bban;%@" size="27" maxlength="26" class="insertext"></td>
 </tr>
</table>

 </form>

 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_transportistas');" >Save</a> 
 <a href="#" onClick="return resetForm('modif_transportistas');" >Undo changes</a>
 <a href="?seccion=bo_transportistas&estado=2&registro[id_transportista]=@%db:Transportistas.id_transportista%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');" >Delete</a></div>
