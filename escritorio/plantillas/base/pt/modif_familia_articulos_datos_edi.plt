 @%where:tabla|Familia_articulos;%@


<form name="modif_familia_articulos" action="?seccion=bo_familia_articulos" method="post">
<input type="hidden" name="registro[id_familia]" value="@%db:Familia_articulos.id_familia;%@" />
<input type="hidden" name="estado" value="1" />
 <!--@%db:Familia_articulos.id_familia;%@-->

<fieldset class="fsficha" >
<legend >&gt; Alterar Fam�lia de Produtos</legend>
<table class="full">
 <tr> 
 <td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Familia_articulos.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr> 
 <td class="etiqueta" >Stock:
 <td ><input type="checkbox" name="registro[stock]" value="1" @%db:check_flag{Familia_articulos.stock};%@>
 (@%db:si_no_flag{Familia_articulos.stock};%@)</td>
 </td>
 </tr>
 <tr> 
 <td class="etiqueta" >Mat�ria Prima:
 <td ><input type="checkbox" name="registro[materia_prima]" value="1" @%db:check_flag{Familia_articulos.materia_prima};%@>
 (@%db:si_no_flag{Familia_articulos.materia_prima;%@)</td>
 </td>
 </tr>
 <tr><td class="etiqueta" >Grupo de Fam�lias:</td>
 <td >
 <!-- @%db:Familia_articulos.id_grupo_familia;%@ @%set:_selected_value=Familia_articulos.id_grupo_familia;%@-->
 <select name="registro[id_grupo_familia]" class="insertext">
 <option value="">N�o Existem Itens Seleccionados</option>
 @%where:tabla|Grupo_familias;nolink|1;order|nombre asc%@
 <option value="@%db:Grupo_familias.id_grupo_familia;%@" 
 	@%db:selected_value{Grupo_familias.id_grupo_familia}%@
	>@%db:Grupo_familias.nombre;%@</option>
 @%end-where:%@

 </select></td></tr></table>

</fieldset></form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_familia_articulos');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
<li><a href="#" onClick="return resetForm('modif_familia_articulos');"  class="deshacer" 
 	><img src="imag/pixel.png" class="icono" /><span>Desfazer Altera��es</span></a></li> 
<li><a href="?seccion=bo_familia_articulos&estado=2&registro[id_familia]=@%db:Familia_articulos.id_familia%@" 
 	onClick="return confirm('�� voc� certo que voc� quer suprimir registros selecionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li>
</ul></div>
@%end-where:%@ 
