 @%where:tabla|Familia_articulos;%@


<form name="modif_familia_articulos" action="?seccion=bo_familia_articulos" method="post">
<input type="hidden" name="registro[id_familia]" value="@%db:Familia_articulos.id_familia;%@" />
<input type="hidden" name="estado" value="1" />
 <!--@%db:Familia_articulos.id_familia;%@-->

<fieldset class="fsficha" >
<legend >&gt; Modify Product Family</legend>
<table class="full">
 <tr> 
 <td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Familia_articulos.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr> 
 <td class="etiqueta" >Stock:
 <td ><input type="checkbox" name="registro[stock]" value="1" @%db:check_flag{Familia_articulos.stock};%@>
 (@%db:si_no_flag{Familia_articulos.stock};%@)</td>
 </td>
 </tr>
 <tr> 
 <td class="etiqueta" >Row material:
 <td ><input type="checkbox" name="registro[materia_prima]" value="1" @%db:check_flag{Familia_articulos.materia_prima};%@>
 (@%db:si_no_flag{Familia_articulos.materia_prima;%@)</td>
 </td>
 </tr>
 <tr><td class="etiqueta" >Families Group:</td>
 <td >
 <!-- @%db:Familia_articulos.id_grupo_familia;%@ @%set:_selected_value=Familia_articulos.id_grupo_familia;%@-->
 <select name="registro[id_grupo_familia]" class="insertext">
 <option value="">No selection</option>
 @%where:tabla|Grupo_familias;nolink|1;order|nombre asc%@
 <option value="@%db:Grupo_familias.id_grupo_familia;%@" 
 	@%db:selected_value{Grupo_familias.id_grupo_familia}%@
	>@%db:Grupo_familias.nombre;%@</option>
 @%end-where:%@

 </select></td></tr></table>

</fieldset></form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_familia_articulos');"  class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li> 
<li><a href="#" onClick="return resetForm('modif_familia_articulos');"  class="deshacer" 
 	><img src="images/pixel.png" class="icono" /><span>Undo changes</span></a></li> 
<li><a href="?seccion=bo_familia_articulos&estado=2&registro[id_familia]=@%db:Familia_articulos.id_familia%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');"  class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete</span></a></li>
</ul></div>
@%end-where:%@ 
