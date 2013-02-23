@%where:tabla|Marcas;%@

<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td >@%db:Marcas.nombre;%@</td></tr>
 <tr><td class="etiqueta">Remarks:</td>
 <td >@%db:Marcas.observaciones;%@</td><tr> 

 <tr>
 <td class="tdimgarticulo" colspan="4" >
<!-- 
@%db:Marcas.id_imagen%@ 
@%set:id_img=Marcas.id_imagen%@
@%set:id_art=Marcas.id_marca%@
-->
@%where:db|db_catalogo;tabla|Catalogo_imagenes;where|id_imagen = $id_img;nolink|1;%@ 
 <img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" border="0" width="200" height="200"></a>
@%end-where:%@ 

 </td>
 </tr>


</table>

