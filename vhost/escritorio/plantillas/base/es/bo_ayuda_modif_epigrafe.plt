 @%where:tabla|Ayuda_epigrafes;%@
 <div class="barraoscura"><div class="titsuperior">
 <!-- @%db:Ayuda_epigrafes.id_sub%@ @%set:id_sub=Ayuda_epigrafes.id_sub%@ -->
 &gt; MODIFICAR EPIGRAFE de AYUDA para
	@%where:db|conf;tabla|Sub_Secc;nolink|1;where|id_sub_secc = $id_sub;%@
 @%db:Sub_Secc.nombre_visual%@(@%db:Sub_Secc.nombre%@)
 @%end-where:%@

 </div>
 <div class="alinder">
 @%if:AllowedLink;bo_ayuda_nuevo_epigrafe;%@
 <a href="?seccion=bo_ayuda_nuevo_epigrafe&id_sub=@%db:Ayuda_epigrafes.id_sub;%@">Nuevo</a>
 @%end-if:%@
 </div></div>
 <form name="nuevo_ayuda" action="?seccion=bo_ayuda_modif&id_sub=@%db:Ayuda_epigrafes.id_sub%@" method="post">
 <input type="hidden" name="estado" value="3">
 <input type="hidden" name="registro[id_sub]" value="@%db:Ayuda_epigrafes.id_sub%@">
 <input type="hidden" name="registro[id_epigrafe]" value="@%db:Ayuda_epigrafes.id_epigrafe%@">
 <table class="full">
 <tr><td class="etiqueta">Título:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65" value="@%db:Ayuda_epigrafes.titulo%@"></td>
<!-- @%db:Ayuda_epigrafes.id_imagen;%@ @%set:id_img=Ayuda_epigrafes.id_imagen%@ @%set:id_art=Ayuda_epigrafes.id_epigrafe%@ -->
 <td class="tdimgarticulo" rowspan="3">
@%if:esta_vacio;id_img;%@
 <a href="#" onClick="return CatalogoImagenesSoloUna('Ayuda_epigrafes','id_epigrafe','@%db:Ayuda_epigrafes.id_epigrafe;%@');"
 >Imagen</a><br/>
@%else:%@
@%where:db|db_catalogo;tabla|Catalogo_imagenes;where|id_imagen = $id_img;nolink|1;%@ 
<a href="" onClick="return CatalogoImagenesSoloUna('Ayuda_epigrafes','id_epigrafe','@%get:id_art;%@','@%db:Catalogo_imagenes.id_imagen;%@');"
	><img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0"></a><br/>
 <input type="checkbox" name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@" checked />
@%end-where:%@

@%end-if:%@
</td>
 </tr>
 <tr><td class="etiqueta" >Activo:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1" @%db:check_flag{Ayuda_epigrafes.activo}%@"></td>
 </tr>
 <tr><td class="etiqueta" >Cuerpo:</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80">@%db:Ayuda_epigrafes.cuerpo%@</textarea></td>
 </tr>
</table>
</form>
<div class="enviar"><a href="#" onClick="return sendForm('nuevo_ayuda');" >Guardar</a></div>
