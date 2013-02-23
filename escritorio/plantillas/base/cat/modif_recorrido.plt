@%where:tabla|Recorridos;where|id_recorrido = $id_recorrido;%@

<div class="tituloseccion">&gt; Modificar Recorreguts</div>

<form name="modif_recorridos" action="?seccion=modif_recorridos" method="post">
<input type="hidden" name="accion_ejecutar" value="Guardar" />
<input type="hidden" name="Guardar" value="Guardar" />
<input type="hidden" name="registro[id_recorrido]" value="@%db:Recorridos.id_recorrido%@" />
<input type="hidden" name="registro[h_inicio]" value="@%db:Recorridos.h_inicio%@" />
<input type="hidden" name="registro[h_fin]" value="@%db:Recorridos.h_fin%@" />

<div class="PIIFichaBase" id="DatosGenerales" >
@%plt:Nombre_Recorrido%@
</div>

<div class="PIIContainer" id="FichaTab_Recorrido" 
@%if:AllowedPII;Citas;%@
><div name="Citas" class="activo" >Llistat de Recorreguts</div
@%end-if:%@
@%if:AllowedPII;Gastos;%@
><div name="Gastos" >Consumacions</div
@%end-if:%@
@%if:AllowedPII;Totales;%@
><div name="Efectos" >Efectes Pagados</div
@%end-if:%@
></div>

<div class="PIIFicha" id="Gastos" >
@%plt:Gastos%@
</div>

</form>

<div class="PIIFicha" id="Citas" >
@%plt:Citas%@
</div>

<div class="PIIFicha" id="Efectos" >
@%plt:Totales%@
</div>

@%if:AllowedAction;Recorridos;edit;%@
@%if:esta_vacio;estado_cerrado;%@
	<div class="AccionesEnvio"><ul>
	<li><a href="#" onClick="return sendForm('modif_recorridos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
	@%if:!esta_vacio;estado_noiniciado;%@
	<li><a href="#" onClick="return sendForm('modif_recorridos','accion_ejecutar','Iniciar');" class="iniciar" 
		><img src="images/pixel.png" class="icono" /><span>Iniciar Ruta</span></a></li>
	@%else:%@
	<li><a href="#" onClick="return sendForm('modif_recorridos','accion_ejecutar','Finalizar');" class="finalizar" 
		><img src="images/pixel.png" class="icono" /><span>Finalitzar</span></a></li>
	@%end-if:%@
	</ul></div>
@%end-if:%@
@%end-if:%@

<script >
<!-- 
TabRecorrido = new TabGroup(document.getElementById('FichaTab_Recorrido'));
// -->
</script>


@%end-where:%@ 
