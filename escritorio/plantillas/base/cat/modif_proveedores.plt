@%where:name|Proveedor;where|id_proveedor = $id_proveedor;%@

<form name="modif_proveedores" action="?seccion=modif_proveedores" method="post">
<input type="hidden" name="registro[id_proveedor]" value="@%db:Proveedores.id_proveedor;%@" />
<input type="hidden" name="id_proveedor" value="@%db:Proveedores.id_proveedor;%@" />
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<div class="barraoscura"><div class="titsuperior">&gt; Fitxa Prove�dor (ID: @%db:Proveedores.id_proveedor;%@)</div></div> 

<div id="AccionesEncabezado"><ul>
<li><a href="?seccion=nuevo_proveedores" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nou Prove�dor</span></a></li>
</ul></div>

<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Datos_Generales%@
</div>

<div class="PIIContainer" id="FichaTab_Proveedor" 
@%if:AllowedPII;Condiciones;%@
><div name="Condiciones" class="activo" >Condicions</div
@%end-if:%@
@%if:AllowedPII;Descuentos;%@
><div name="Descuentos" >Comercial</div
@%end-if:%@
@%if:AllowedPII;Reposicion;%@
><div name="Reposicion" >Reposici�</div
@%end-if:%@
@%if:AllowedPII;Cuentas_Contables;%@
><div name="CuentasContables" >Financer</div
@%end-if:%@
@%if:AllowedPII;Login;%@
><div name="Acceso" >Accessos</div
@%end-if:%@
@%if:AllowedPII;Observaciones;%@
><div name="Observaciones" >Observacions</div
@%end-if:%@
></div>


<div class="PIIFicha" id="Condiciones" >
@%plt:Condiciones%@
</div>

<div class="PIIFicha" id="Descuentos" >
@%plt:Descuentos%@
</div>

<div class="PIIFicha" id="CuentasContables" >
@%plt:Cuentas_Contables%@
</div>

<div class="PIIFicha" id="Acceso" >
@%plt:Login%@
</div>

<div class="PIIFicha" id="Observaciones" >
@%plt:Observaciones%@
</div>

</form>

<div class="PIIFicha" id="Reposicion" >
@%plt:Reposicion%@
</div>


<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('modif_proveedores');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul></div>

<script >
<!-- 
TabProveedor = new TabGroup(document.getElementById('FichaTab_Proveedor'));
// -->
</script>

