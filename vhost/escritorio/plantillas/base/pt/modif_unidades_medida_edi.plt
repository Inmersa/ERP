@%where:tabla|Unidades_medida;where|id_unidad_medida = $id_unidad_medida;%@

<form name="modif_unidades_medida" action="?seccion=modif_unidades_medida" method="post">
<input type="hidden" name="registro[id_unidad_medida]" value="@%db:Unidades_medida.id_unidad_medida;%@" />
<input type="hidden" name="accion" value="Modificar" />
<!--@%db:Unidades_medida.id_unidad_medida;%@ @%db:Unidades_medida.id_tipo_unidadmedida;%@ -->

<table class="full">
<tbody>
 <tr><td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Unidades_medida.nombre;%@" class="texto" /></td></tr>
 <tr><td class="etiqueta" >Tipo:</td>
 <td ><select name="registro[id_tipo_unidadmedida]" >
 <!-- @%set:_selected_value=Unidades_medida.id_tipo_unidadmedida;%@ -->
 <option value="0" >N�o Existem Itens Seleccionados</option>
 @%where:tabla|Tipos_UnidadMedida;nolink|1;order|nombre asc;%@
 <option value="@%db:Tipos_UnidadMedida.id_tipo_unidadmedida;%@"
 @%db:selected_value{Tipos_UnidadMedida.id_tipo_unidadmedida;%@
 >@%db:Tipos_UnidadMedida.nombre;%@</option>
 @%end-where:%@

 </select>
 </td></tr>
 <tr><td class="etiqueta" >Legenda:</td>
 <td ><input type="text" name="registro[leyenda]" value="@%db:Unidades_medida.leyenda;%@" class="nanotexto" /></td></tr>
 <tr><td class="etiqueta" >onvers�o decomposta:</td>
 <td ><input type="checkbox" name="registro[conversion_descompuesta]" value="1" 
 @%db:check_flag{Unidades_medida.conversion_descompuesta};%@" /></td></tr>
 <tr><td class="etiqueta" >N�meros decimans em Unidades de medida:</td>
 <td ><input type="text" name="registro[num_decimales]" value="@%db:Unidades_medida.num_decimales;%@" class="mininum" /></td></tr>
 <tr><td class="etiqueta" >Utilizador:</td>
 <td >@%db:si_no_flag{Unidades_medida.user_defined;%@</td></tr>

</tbody></table>

<fieldset class="fsficha" >
<legend>Lista de Escalas</legend>

<div class="AccionesFicha"><ul>
<li class="noicon" ><input type="text" name="nuevo[UnidadesMedida_Escalas][nombre]" /></li>
<li><a href="#" onclick="return sendForm('modif_unidades_medida', 'accion', 'Nuevo');" class="nuevo" 
	><img src="imag/pixel.png" class="icono" /><span>Adicionar</span></a></li>
<li><a href="#" onclick="return sendForm('modif_unidades_medida', 'accion', 'BorrarListado');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
</ul></div>

<table class="full" >
<thead class="cabecera" ><tr>
<td class="check" ></td>
<td>Nome</td>
<td>Factor de convers�o</td>
<td>Legenda</td>
<td>Alias</td>
</tr></thead>

<tbody>
@%where:tabla|UnidadesMedida_Escalas;order|factor_conversion asc;%@
<tr>
<td class="check" ><input type="checkbox" name="registro_borrar[UnidadesMedida_Escalas][@%db:UnidadesMedida_Escalas.id_escala_medida;%@]"
value="1" /></td>
<td><input type="text" class="texto" name="UnidadesMedida_Escalas[@%db:UnidadesMedida_Escalas.id_escala_medida;%@][nombre]"
value="@%db:UnidadesMedida_Escalas.nombre;%@" /></td>
<td><input type="text" class="longnum" name="UnidadesMedida_Escalas[@%db:UnidadesMedida_Escalas.id_escala_medida;%@][factor_conversion]"
value="@%db:UnidadesMedida_Escalas.factor_conversion;%@" /></td>
<td><input type="text" class="nanotexto" name="UnidadesMedida_Escalas[@%db:UnidadesMedida_Escalas.id_escala_medida;%@][leyenda]"
value="@%db:UnidadesMedida_Escalas.leyenda;%@" /></td>
<td><input type="text" class="minitexto" name="UnidadesMedida_Escalas[@%db:UnidadesMedida_Escalas.id_escala_medida;%@][alias_list]"
value="@%db:UnidadesMedida_Escalas.alias_list;%@" /></td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="?seccion=nuevo_unidades_medida" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Novo</span></a></li>
<li><a href="#" onClick="return sendForm('modif_unidades_medida');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
<li><a href="#" onClick="return resetForm('modif_unidades_medida');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Desfazer Altera��es</span></a></li> 
<li><a href="?seccion=bo_unidades_medida&estado=2&registro[id_unidad_medida]=@%db:Unidades_medida.id_unidad_medida%@" 
 	onClick="return confirm('�� voc� certo que voc� quer suprimir registros selecionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li>
</ul></div>
