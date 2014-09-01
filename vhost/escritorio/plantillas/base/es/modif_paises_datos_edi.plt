

 <form name="modif_paises" action="?seccion=bo_paises" method="post">
 <input type="hidden" name="registro[id_pais]" value="@%db:Paises.id_pais;%@">
 <input type="hidden" name="estado" value="1">
 <!--@%db:Paises.id_pais;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Paises.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Código:</td>
 <td ><input type="text" name="registro[codigo]" size="5" value="@%db:Paises.codigo;%@" class="insertext"></td>
 </tr>
 <tr><td class="etiqueta" >Continente:</td>
 <td > <input type="text" name="registro[continente]" size="55" value="@%db:Paises.continente;%@" class="insertext"></td>
 </tr>
 <tr><td class="etiqueta" >Prefijo telefónico:</td>
 <td ><b><input type="text" name="registro[prefijo_tlf]" size="5" value="@%db:Paises.prefijo_tlf;%@" class="insertext"></b></td>
 </tr>
 <tr><td class="etiqueta" >Prefijo CIF: </td>
 <td ><input type="text" name="registro[prefijo_cif]" size="5" value="@%db:Paises.prefijo_cif;%@" class="insertext"></td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_paises');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_paises');" >Deshacer Cambios</a> 
 <a href="?seccion=bo_paises&estado=2&registro[id_pais]=@%db:Paises.id_pais%@" 
 	onClick="return confirm('¿Está ud. seguro de que desea borrar los registros seleccionados?');" >Borrar</a></div>


