
 <!--@%db:Provincias.id_provincia;%@-->
<form name="modif_provincias" action="?seccion=bo_provincias" method="post">
<input type="hidden" name="registro[id_provincia]" value="@%db:Provincias.id_provincia;%@" />
<input type="hidden" name="estado" value="1" />

@%if:AllowedLink;nuevo_provincias;%@
<div id="AccionesEncabezado" ><ul>
 <li><a href="?seccion=nuevo_provincias" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nouveau</span></a></li>
</ul></div>
@%end-if:%@

<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Provincias.nombre;%@" class="insertext" size="55"></td></tr>

 <tr><td class="etiqueta" >Pays:</td>
 <td ><select name="registro[id_pais]" class="insertext">
 <!--@%db:Provincias.id_pais;%@ @%set:_selected_value=Provincias.id_pais%@-->
@%where:tabla|Paises;nolink|1;%@
 <option value="@%db:Paises.id_pais;%@" 
 @%db:selected_value{Paises.id_pais}%@
>@%db:Paises.nombre;%@</option>
@%end-where:%@

 </select></td>

 </tr>
 <tr><td class="etiqueta" >Code:</td>
 <td ><input type="text" name="registro[codigo]" size="5" class="insertext" value="@%db:Provincias.codigo;%@"></td>
 </tr>

 <tr><td class="etiqueta" >Prefixe Tf.:</td>
 <td ><input type="text" name="registro[prefijo_tlf]" size="5" class="insertext" value="@%db:Provincias.prefijo_tlf;%@"></td>
 </tr>
 </table>

 </form>

<div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_provincias');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Garder</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_provincias');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>D�faire changement</span></a></li> 
 <li><a href="?seccion=bo_provincias&estado=2&registro[id_provincia]=@%db:Provincias.id_provincia%@" 
 	onClick="return confirm('�tes-vous s�r que vous voulez supprimer des enregistrements choisis?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Effacer</span></a></li>
</ul></div>
