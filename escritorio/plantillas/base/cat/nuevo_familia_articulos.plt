
<!-- div class="tituloseccion">&gt; Nova Fam�lia Articles</div -->

 <form name="nuevo_familia_articulos" action="?seccion=bo_familia_articulos" method="post">
 <input type="hidden" name="registro[id_familia]" value="NULL" />
 <input type="hidden" name="estado" value="1" />
<fieldset class="fsficha" >
<legend>&gt; Nova Fam�lia Articles</legend>
<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
</tr>
<tr><td class="etiqueta">Stock:</td>
<td class="check"><input type="checkbox" name="registro[stock]" value="1" /></td>
</tr>
<tr><td class="etiqueta">Mat�ria prima:</td>
<td class="check"><input type="checkbox" name="registro[materia_prima]" value="1" /></td>
</tr>
<tr>
<td class="etiqueta">Grup families:</td>
<td><select name="registro[id_grupo_familia]">
<option value="">Cap selecci�</option>

 @%where:tabla|Grupo_familias;nolink|1;order|nombre asc;%@
<option value="@%db:Grupo_familias.id_grupo_familia;%@">
@%db:Grupo_familias.nombre;%@
</option>
 @%end-where:%@

 </select></td></tr></table>
</fieldset>
</form>


<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('nuevo_familia_articulos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

