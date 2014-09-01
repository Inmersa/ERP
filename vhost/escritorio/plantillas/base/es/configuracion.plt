
<div class="tituloseccion">Configuración General</div>

<form name="configuracion" method="post" action="#">
<input type="hidden" name="accion_ejecutar" value="Modificar" />

<div class="PIIContainer" id="CfgTab_General" 
><div name="Impresion" class="activo" >Impresión</div
><div name="Facturas" >Facturas</div
><div name="Email" >Mail</div
><div name="General" >Configuración General</div
></div>

<div class="PIIFicha" id="General" >
@%plt:general;%@
</div>

<div class="PIIFicha" id="Facturas" >
@%plt:facturas;%@
</div>

<div class="PIIFicha" id="Email" >
@%plt:email;%@
</div>

<div class="PIIFicha" id="Impresion" >
@%plt:impresion;%@
</div>


@%if:!esta_vacio;LinkCRM;_aAppConf[iconta_dbname];%@

<div class="PIIContainer" id="CfgTab_Modulos" 
@%if:!esta_vacio;LinkCRM;%@
><div name="CRM" >CRM</div
@%end-if:%@
@%if:!esta_vacio;_aAppConf[iconta_dbname];%@
><div name="iConta" >Conta</div
@%end-if:%@
></div>

@%if:!esta_vacio;LinkCRM;%@
<div class="PIIFicha" id="CRM" >
@%plt:crm;%@
</div>
@%end-if:%@

@%if:!esta_vacio;_aAppConf[iconta_dbname];%@
<div class="PIIFicha" id="iConta" >
@%plt:contabilidad;%@
</div>
@%end-if:%@

@%end-if:%@

<script >
<!-- 
TabCfg = new TabGroup(document.getElementById('CfgTab_General'));
TabMods = new TabGroup(document.getElementById('CfgTab_Modulos'));
// -->
</script>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('configuracion');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

</form>

