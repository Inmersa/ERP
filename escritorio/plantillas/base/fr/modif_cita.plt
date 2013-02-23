<div class="tituloseccion">&gt; Modifier Citation</div>
<!-- @%db:Citas.id_cita;%@ @%db:Clientes.id_cliente;%@ -->

@%plt:Datos_Cita%@

<form name="nuevopedido" method="post" action="?seccion=hacer_pedido" >
<input type="hidden" name="nuevo" value="1" />
<input type="hidden" name="pedido" value="1" />
<input type="hidden" name="id_cliente" value="@%db:Clientes.id_cliente;%@" />
<input type="hidden" name="_confirm_form_to" value="modif_cita&id_cita=@%db:Citas.id_cita;%@" />
</form>

<div class="AccionesEnvio" ><ul>
<li><a href="#" onClick="return sendForm('cita');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Modifier</span></a></li>
@%if:!esta_vacio;estado_iniciado;%@
@%if:esta_vacio;Citas.id_pedido;%@
<li><a href="#" onClick="return sendForm('nuevopedido');" class="nuevopedido" ><img src="imag/pixel.png" class="icono" /><span>Passer une commande</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('cita','accion_ejecutar','Finalizar');" class="finalizar" 
	><img src="imag/pixel.png" class="icono" /><span>Terminer</span></a></li>
@%end-if:%@
@%if:!esta_vacio;estado_noiniciado;%@
<li><a href="#" onClick="return sendForm('cita','accion_ejecutar','Iniciar');" class="iniciar" ><img src="imag/pixel.png" class="icono" /><span>Commencer</span></a></li>
@%end-if:%@
</ul></div>


<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Efectos;%@
</div>

<div class="PIIContainer" id="FichaTab_Cita" 
@%if:AllowedPII;incidencias;%@
><div name="Incidencias" class="activo" >Incidences</div
@%end-if:%@
@%if:!esta_vacio;estado_iniciado;%@
@%if:AllowedPII;EfectosPendientes;%@
><div name="Efectos" >Effets en suspens</div
@%end-if:%@
@%end-if:%@
></div>

@%if:!esta_vacio;estado_iniciado;%@
<!-- @%set:id_cliente = Clientes.id_cliente;%@ -->
<div class="PIIFicha" id="Efectos" >
@%plt:EfectosPendientes;%@
</div>
@%end-if:%@

<div class="PIIFicha" id="Incidencias" >
<!-- @%set:id_documento = Citas.id_cita;%@ -->
@%plt:incidencias;%@
</div>

<script >
<!-- 
TabCita = new TabGroup(document.getElementById('FichaTab_Cita'));
// -->
</script>

