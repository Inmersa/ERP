
<form name="nuevo_clientes" action="?seccion=modif_clientes" method="post">
<div class="tituloseccion">&gt; New Client</div>

<fieldset id="NuevoCliente_DatosGenerales" class="fsficha">
<legend>General Information</legend>
 <table class="full">
 <tr>
 <td class="etiqueta">Name:</td>
 <td><input type="text" name="registro[nombre]" size="30" /></td>
 <td class="etiqueta">EIN (intracom.) :</td>
 <td><input type="text" name="registro[prefijo_cif]" size="2" maxlength="2" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Last name:</td>
 <td><input type="text" name="registro[apellidos]" class="insertext" size="30" /></td>
 <td class="etiqueta">EIN:</td>
 <td><input type="text" name="registro[cif]" size="20" maxlength="12" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Company Name:</td>
 <td><input type="text" name="registro[razon_social]" class="insertext" size="30" /></td>
 <td class="etiqueta">City:</td>
 <td><input type="text" name="registro[poblacion]" size="20" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Invoicing address:</td>
 <td>
 <input type="text" name="registro[direccion_facturacion]" size="30" /></td>
 <td class="etiqueta">Postal Code:</td>
 <td><input type="text" name="registro[cp]" size="6" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Area:</td>
 <td>
 <select name="registro[id_provincia]">
 @%where:tabla|Provincias;order|nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
 @%end-where:%@

 </select></td>
 <td class="etiqueta">e-mail:</td>
 <td><input type="text" name="registro[email]" size="20" /></td>
 </tr>


 <tr>
 <td class="etiqueta">Contact person:</td>
 <td>
 <input type="text" name="registro[persona_contacto]" size="30" /></td>
 <td class="etiqueta">Phone 1:</td>
 <td><input type="text" name="registro[telefono1]" size="14" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Contact role:</td>
 <td>
 <input type="text" name="registro[cargo_persona_contacto]" size="30" /></td>
 <td class="etiqueta">Phone 2:</td>
 <td>
 <input type="text" name="registro[telefono2]" size="14" /></td>
 </tr>

 <tr>
 <td class="etiqueta">Web:</td>
 <td>
 <input type="text" name="registro[web]" size="30" /></td>
 <td class="etiqueta">Fax:</td>
 <td>
 <input type="text" name="registro[fax]" size="14" /></td>
 </tr>
</table>
</fieldset>

@%plt:Acceso_Sistema;%@

@%plt:Cliente_Empresa;%@

@%plt:Cuentas_Contables;%@

@%plt:Mostrar_Ofertas%@

@%plt:Observaciones%@

 <input type="hidden" name="accion_ejecutar" value="Nuevo" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_clientes');" class="guardar"><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
</ul></div>

