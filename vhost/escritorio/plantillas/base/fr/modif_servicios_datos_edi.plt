<form name="modif_servicios" action="?seccion=bo_servicios" method="post">
<input type="hidden" name="registro[id_servicio]" value="@%db:Servicios.id_servicio;%@">
<input type="hidden" name="estado" value="1">
 <!--@%db:Servicios.id_servicio;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td colspan="5"><input type="text" name="registro[nombre]" value="@%db:Servicios.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Dur�:</td>
 <td ><input type="text" name="registro[duracion]" value="@%db:Servicios.duracion;%@" class="insertext" size="5"></td>
 <td> <input type="radio" name="registro1" value="d" checked> Jours </td>
 <td><input type="radio" name="registro1" value="m" >Mois</td>
 <td><input type="radio" name="registro1" value="a" >ann�e</td>
 </tr>
 <tr><td class="etiqueta" >D�lai de facture:</td>
 <td ><input type="text" name="registro[plazo_factura]" value="@%db:Servicios.plazo_factura;%@" class="insertext" size="5"></td>
 <td> <input type="radio" name="registro2" value="d" checked> Jours </td>
 <td> <input type="radio" name="registro2" value="m" > Mois </td>
 <td> <input type="radio" name="registro2" value="a" > ann�e </td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_servicios');" >Garder</a> 
 <a href="#" onClick="return resetForm('modif_servicios');" >D�faire changement</a> 
 <a href="?seccion=bo_servicios&estado=2&registro[id_servicio]=@%db:Servicios.id_servicio%@" 
 	onClick="return confirm('�tes-vous s�r que vous voulez supprimer des enregistrements choisis?');" >Effacer</a></div>
