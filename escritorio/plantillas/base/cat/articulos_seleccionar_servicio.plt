
<div class="barraoscura"><div class="titsuperior">&gt; Serveis</div></div>
 
<form name="bo_servicios" action="?seccion=@%func:inm_prev_subsec%@" method="post">
<input type="hidden" name="accion_ejecutar" value="asociar_servicios">

<table class="full">
<tr>
 <td></td>
 <td class="etiqueta" >Nom</td>
 <td class="etiqueta" >Duració</td>
 <td class="etiqueta" >Plaç de factura</td>
</tr>

@%where:tabla|Servicios;no_results|1;%@ 
<!--@%db:Servicios.id_servicio%@-->
 <tr>
 <td class="check" ><input type="checkbox" name="servicios_seleccionados[@%db:Servicios.id_servicio;%@]" value="1"></td>
 <td >@%db:Servicios.nombre;%@
 <!-- a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@" class="accesos"></a -->
 </td>
 <td >@%db:Servicios.duracion;%@ Dies</td>
 <td >@%db:Servicios.plazo_factura;%@ Dies</td>
 </tr>
@%end-where:%@

</table>
</form>

<div class="enviar"><a href="#" onClick="return sendForm('bo_servicios');" >Confirmar</a></div>


