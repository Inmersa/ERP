@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@
<!-- @%db:Efectos.id_efecto%@ @%db:Efectos.pago_cobro;%@ -->
<div 
@%if:esta_vacio;Efectos.pago_cobro;%@
class="tituloseccion impropio"
@%else:%@
class="tituloseccion"
@%end-if:%@
>&gt; Modify Bank drafts (ID: @%db:Clientes.id_cliente;%@) @%db:Clientes.razon_social;%@</div>

<form name="efecto" action="?seccion=modif_efectos_cliente" method="post"> 
<input type="hidden" name="accion_ejecutar" value="Ficha_Efecto" /> 
<input type="hidden" name="efecto[id_efecto]" value="@%db:Efectos.id_efecto%@" />

@%plt:Datos_Generales%@

@%plt:Nuevo_Abono%@

@%if:AllowedAction;Efectos;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('efecto');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Save</span></a></li>
<li><a href="#" onClick="return sendForm('efecto');" class="deshacer" ><img src="images/pixel.png" class="icono" /><span>Undo changes</span></a></li>
<li><a href="#" onClick="return abrir_ventana('?seccion=@%get:_krn_ss_name;%@&id=@%db:Efectos.id_efecto;%@&imprimir=1');" class="imprimir" 
	><img src="images/pixel.png" class="icono" /><span>Print</span></a></li>
</ul></div>
@%end-if:%@


@%plt:Abonos_Parciales%@


 </form>

