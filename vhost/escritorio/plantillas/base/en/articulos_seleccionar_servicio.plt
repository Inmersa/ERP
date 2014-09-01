
<div class="barraoscura"><div class="titsuperior">&gt; Services</div></div>
 
<form name="bo_servicios" action="?seccion=@%func:inm_prev_subsec%@" method="post">
<input type="hidden" name="accion_ejecutar" value="asociar_servicios">

<table class="full">
<tr>
 <td></td>
 <td class="etiqueta" >Name</td>
 <td class="etiqueta" >Length</td>
 <td class="etiqueta" >Invoice period</td>
</tr>

@%where:tabla|Servicios;no_results|1;%@ 
<!--@%db:Servicios.id_servicio%@-->
 <tr>
 <td class="check" ><input type="checkbox" name="servicios_seleccionados[@%db:Servicios.id_servicio;%@]" value="1"></td>
 <td >@%db:Servicios.nombre;%@
 <!-- a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@" class="accesos"></a -->
 </td>
 <td >@%db:Servicios.duracion;%@ Days</td>
 <td >@%db:Servicios.plazo_factura;%@ Days</td>
 </tr>
@%end-where:%@

</table>
</form>

<div class="enviar"><a href="#" onClick="return sendForm('bo_servicios');" >Send</a></div>


