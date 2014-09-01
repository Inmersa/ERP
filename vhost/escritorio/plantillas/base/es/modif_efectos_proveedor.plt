@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@
<!-- @%db:Efectos.id_efecto%@ -->
<div 
@%if:!esta_vacio;Efectos.pago_cobro;%@
class="tituloseccion impropio"
@%else:%@
class="tituloseccion"
@%end-if:%@
>&gt; MODIFICAR EFECTO (ID: @%db:Proveedores.id_proveedor;%@) @%db:Proveedores.razon_social;%@</div>

<form name="efecto" action="?seccion=modif_efectos_proveedor" method="post"> 
<input type="hidden" name="accion_ejecutar" value="Ficha_Efecto" />
<input type="hidden" name="efecto[id_efecto]" value="@%db:Efectos.id_efecto%@" />

@%plt:Datos_Generales%@

@%plt:Abonos_Parciales%@

@%plt:Nuevo_Abono%@

</form>

@%if:AllowedAction;Efectos;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('efecto')"  class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li> 
<li><a href="#" onClick="return resetForm('efecto');"  class="deshacer" ><img src="imag/pixel.png" class="icono" /><span>Deshacer Cambios</span></a></li>
</ul></div>
@%end-if:%@
 
@%end-where:%@ 
