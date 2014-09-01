@%where:tabla|Divisa;%@

<form name="modif_divisa" action="?seccion=bo_divisa" method=post>
<input type="hidden" name="registro[id_divisa]" value="@%db:Divisa.id_divisa;%@">
<input type="hidden" name="estado" value="1">
<!--@%db:Divisa.id_divisa;%@-->
<table class="full">
 <tr><td class="etiqueta">Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Divisa.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr>
 <td class="etiqueta" >Légende :</td>
 <td ><input type="text" name="registro[leyenda]" value="@%db:Divisa.leyenda;%@" class="insertext" size="55"></td>
 </tr>
 <tr>
 <td class="etiqueta" >Ratio :</td>
 <td ><input type="text" name="registro[ratio]" value="@%db:Divisa.ratio;%@" class="insertext" size="55"></td>
 </tr>
 </table>
</form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_divisa');" >Garder</a> 
 <a href="#" onClick="return resetForm('modif_divisa');" >Défaire changement</a>
 <a href="?seccion=bo_divisa&estado=2&registro[id_divisa]=@%db:Divisa.id_divisa%@" 
 	onClick="return confirm('Êtes-vous sûr que vous voulez supprimer des enregistrements choisis?');" >Effacer</a></div>
