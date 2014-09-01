
<form name="modif_direcciones_entrega" action="?seccion=modif_clientes" method="post" >
 <input type="hidden" name="accion_ejecutar" value='Modificar'>
 <input type="hidden" name="registro_dir[id_direccion]" value="@%db:Direcciones_entrega.id_direccion;%@">

<table class="full">
 <!-- @%db:Direcciones_entrega.id_direccion;%@ -->
<tbody>
 <tr> 
 <td class="etiqueta" >Nom:</td>
 <td><input type="text" name="registro_dir[nombre]" class="insertext" size="35" value="@%db:Direcciones_entrega.nombre;%@"></td>
 <td class="etiqueta">e-mail:</td>
 <td ><input type="text" name="registro_dir[email]" class="insertext" size="35" value="@%db:Direcciones_entrega.email;%@"></td>
 </tr>
 <tr> 
 <td class="etiqueta" >Adre�a:</td>
 <td ><input type="text" name="registro_dir[direccion]" class="insertext" size="35" value="@%db:Direcciones_entrega.direccion;%@"></td>
 <td class="etiqueta">Tel�fon:</td>
 <td ><input type="text" name="registro_dir[telefono1]" class="insertext" size="35" value="@%db:Direcciones_entrega.telefono1;%@"></td>
 </tr>
 <tr> 
 <td class="etiqueta">Poblaci�:</td>
 <td ><input type="text" name="registro_dir[poblacion]" class="insertext" size="35" value="@%db:Direcciones_entrega.poblacion;%@"></td>
 <td class="etiqueta">Fax:</td>
 <td ><input type="text" name="registro_dir[fax]" class="insertext" size="35" value="@%db:Direcciones_entrega.fax;%@"></td>
 </tr>
 <tr> 
 <td class="etiqueta" >Prov�ncia</td>
 <td ><select name="registro_dir[id_provincia]" class="insertext">
 <!--@%db:Direcciones_entrega.id_provincia;%@ @%set:_selected_value=Direcciones_entrega.id_provincia;%@-->
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" 
 	@%db:selected_value{Provincias.id_provincia};%@
	>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 <td class="etiqueta">Persona de contacte:</td>
 <td ><input type="text" name="registro_dir[persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.persona_contacto;%@"></td>
 <tr> 
 <td class="etiqueta">CP:</td>
 <td ><input type="text" name="registro_dir[cp]" class="insertext" size="6" value="@%db:Direcciones_entrega.cp;%@"></td>
 <td class="etiqueta">C�rrec de contacte:</td>
 <td ><input type="text" name="registro_dir[cargo_persona_contacto]" class="insertext" size="35" value="@%db:Direcciones_entrega.cargo_persona_contacto;%@"></td>
 </tr>
 <tr><td class="etiqueta" >Transportistes:</td>
 <td colspan="3" ><!-- @%set:_selected_value=Direcciones_entrega.id_transportista;%@ @%db:Direcciones_entrega.id_transportista;%@ -->
 <select name="registro_dir[id_transportista]" ><option value="null" >Pre-Def</option>
 @%where:tabla|Transportistas;nolink|1;order|nombre asc;%@
 <option value="@%db:Transportistas.id_transportista;%@" 
 @%db:selected_value{Transportistas.id_transportista};%@
 >@%db:Transportistas.nombre;%@</option>
 @%end-where:%@

 </td></tr>

 <tr><td class="etiqueta" >Observacions:</td>
 <td colspan="3" ><textarea name="registro_dir[observaciones]" class="desc" >@%db:Direcciones_entrega.observaciones;%@</textarea></td></tr>
</tbody>
</table>

<input type="hidden" name="Modificar" value="Modificar">
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('modif_direcciones_entrega');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</div>

