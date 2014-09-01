@%where:tabla|Marcas;%@

<form name="modif_marcas" action="?seccion=bo_marcas" method="post">
<input type="hidden" name="registro[id_marca]" value="@%db:Marcas.id_marca;%@">
<input type="hidden" name="estado" value="1">
<fieldset class="fsficha" >
<legend>&gt; Alterar Marca</legend>

<!--
@%db:Marcas.id_marca;%@ @%db:Marcas.id_imagen%@ 
@%set:id_img=Marcas.id_imagen%@ @%set:id_art=Marcas.id_marca%@
-->
<table class="full">
 <tr><td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Marcas.nombre;%@" class="insertext" size="55"></td>

 <td class="tdimgarticulo" rowspan="2" ><a 
 	href="" onClick="return CatalogoImagenesSoloUna('Marcas','id_marca','@%db:Marcas.id_marca;%@');"
	>Imagem</a><br/>
@%where:db|db_catalogo;tabla|Catalogo_imagenes;where|id_imagen = $id_img;nolink|1;%@ 
<!-- onClick="abrir_ventana('?seccion=bo_cat_radio&amp;arreguarda=1&amp;campo_destino=id_marca&id_imagen=@%db:Catalogo_imagenes.id_imagen%@&tabla=Marcas&id_sub=@%get:id_art%@');return false;" -->
<a href="#" onClick="return CatalogoImagenesSoloUna('Marcas','id_marca','@%get:id_art;%@','@%db:Catalogo_imagenes.id_imagen;%@');"
	><img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" ></a><br/>
 <input type="checkbox" name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" checked/>
@%end-where:%@ 

 </td>
 </tr>
 <tr><td class="etiqueta" >Observações:</td>
 <td ><textarea name="registro[observaciones]" cols="55" rows="10">@%db:Marcas.observaciones;%@</textarea></td>
 </tr>
 </table>
 <table class="full" >
 <tr>
 <td class="etiqueta" >Web / TPV</td>
 <td class="check" ><input type="checkbox" name="registro[wwwactivo]" value="1" @%db:check_flag{Marcas.wwwactivo};%@ /></td>
 <td class="etiqueta" >Excluído de Venda</td>
 <td class="check" ><input type="checkbox" name="registro[novender]" value="1" @%db:check_flag{Marcas.novender};%@ /></td>
 </tr>
 </table>
</fieldset>

 </form>
 <div class="AccionesEnvio"><ul>
 <li><a href="#" onClick="return sendForm('modif_marcas');"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
 <li><a href="#" onClick="return resetForm('modif_marcas');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Desfazer Alterações</span></a></li>
 <li><a href="?seccion=bo_marcas&estado=2&registro[id_marca]=@%db:Marcas.id_marca%@" 
 	onClick="return confirm('¿É você certo que você quer suprimir registros selecionados?');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li> 
 </ul></div>

