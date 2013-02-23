@%where:tabla|Clientes;where|Clientes.id_cliente = $id_cliente_promocion ;nolink|1;%@

<div class="tituloseccion">&gt; Ficha de Cliente &nbsp;&nbsp; (ID: @%db:Clientes.id_cliente;%@) @%db:Clientes.razon_social;%@</div>

<div id="AccionesEncabezado"><ul>
@%if:AllowedAction;Clientes;new;%@
<li><a href="?seccion=nuevo_clientes" class="nuevo"><img src="imag/pixel.png" class="icono" /><span>Novo Cliente</span></a></li>
@%end-if:%@
@%if:AllowedLink;bo_importar_clientes;%@
<li><a href="?seccion=bo_importar_clientes" class="importarusuario"><img src="imag/pixel.png" class="icono" /><span>Recuperar Cliente</span></a></li>
@%end-if:%@
</ul></div>

<form name="modif_clientes" action="?seccion=modif_clientes" method="post" id="FichaCliente">
<input type="hidden" name="accion_ejecutar" value="j" />

<div class="PIIFichaBase" id="Datos_Generales" >
@%plt:Datos_Generales%@
</div>

<div class="PIIContainer" id="FichaTab_Cliente1" 
@%if:AllowedPII;Personas_Contacto;%@
><div name="Personas_Contacto" >Contacto</div
@%end-if:%@
@%if:AllowedPII;Acceso_Sistema;%@
><div name="Acceso_Sistema" >Acesso</div
@%end-if:%@
@%if:AllowedPII;Direccion_Entrega;%@
><div name="Direccion_Entrega" >Direc��es</div
@%end-if:%@
@%if:AllowedPII;Cliente_Agente;%@
><div name="Cliente_Agente" >Agentes</div
@%end-if:%@
@%if:AllowedPII;Cliente_Empresa;%@
><div name="Cliente_Empresa" class="activo" >Condi��es</div
@%end-if:%@
></div>

<div class="PIIFicha" id="Personas_Contacto" >
@%plt:Personas_Contacto;%@
</div>

<div class="PIIFicha" id="Acceso_Sistema" >
@%plt:Acceso_Sistema%@
</div>

<div class="PIIFicha" id="Direccion_Entrega" >
@%plt:Direccion_Entrega%@
</div>

<div class="PIIFicha" id="Cliente_Agente" >
@%plt:Cliente_Agente%@
</div>

<div class="PIIFicha" id="Cliente_Empresa" >
@%plt:Cliente_Empresa%@
</div>

<div class="PIIContainer" id="FichaTab_Cliente2" 
@%if:AllowedPII;Cuentas_Contables;%@
><div name="Cuentas_Contables" >Financeiro</div
@%end-if:%@
@%if:AllowedPII;Efectos_Pendientes;%@
><div name="EfectosPendientes" >Ordens em suspenso</div
@%end-if:%@
@%if:AllowedPII;Mostrar_Ofertas;%@
><div name="Mostrar_Ofertas" >Comercial</div
@%end-if:%@
@%if:AllowedPII;Cliente_Observaciones;%@
><div name="Cliente_Observaciones" >Observa��es</div
@%end-if:%@
@%if:AllowedPII;Enlaces;%@
><div name="Enlaces" >Liga��es</div
@%end-if:%@
></div>

<div class="PIIFicha" id="Cuentas_Contables" >
@%plt:Cuentas_Contables%@
</div>

<div class="PIIFicha" id="Mostrar_Ofertas" >
@%plt:Mostrar_Ofertas%@
</div>

<div class="PIIFicha" id="Cliente_Observaciones" >
@%plt:Cliente_Observaciones%@
</div>

<div class="PIIFicha" id="Enlaces" >
@%plt:Enlaces;%@
</div>


<div class="PIIFicha" id="EfectosPendientes" >
<!-- @%set:form_name=modif_clientes;%@ @%set:efectos_nodate=1;%@-->
@%plt:Efectos_Pendientes;%@
</div>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Modificar');" class="guardar"
	><img src="imag/pixel.png" class="icono" /><span>Alterar</span></a></li>
</ul></div>

<input type="hidden" name="registro[id_cliente]" value="@%db:Clientes.id_cliente;%@" />
<input type="hidden" name="borratore" value="0" />
</form>

<script >
<!-- 
TabClienteUno = new TabGroup(document.getElementById('FichaTab_Cliente1'));
TabClienteDos = new TabGroup(document.getElementById('FichaTab_Cliente2'));
// -->
</script>

@%end-where:%@
