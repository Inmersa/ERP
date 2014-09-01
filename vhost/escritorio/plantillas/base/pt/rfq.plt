@%where:nodb|class_dbItemMultiEntity_iface;nombre|FichaEstadoEvento;%@

<div class="tituloseccion" >Ficha de RFQ </div>
<form name="rfq" method="post" action="?seccion=@%get:_krn_ss_name;%@" enctype="multipart/form-data" >
<input type="hidden" name="accion_ejecutar" value="Modificar" />
@%set:formvar_name=rfq;%@
@%plt:ICRMEvent;%@

<div class="AccionesEnvio" >
<ul>
<li><a href="#" onClick="return sendForm('rfq','accion_ejecutar','Modificar');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>
</form>

@%if:esta_vacio;estado;id;%@
@%else:%@
@%plt:Documentos;%@

<!-- @%set:documento_formvarname=presupuesto;%@ -->
<fieldset id="RFQPresupuesto" class="fsficha" >
<legend>Produtos RFQ</legend>

<table class="full" >
<thead>
<td>Ref.</td>
<td>Data</td>
<td>Estado</td>
</thead>
<tbody>
<!-- @%set:bad=negro.gif;%@ @%set:none=triangulo.png;%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ -->
@%where:tabla|Presupuestos;no_results|1;cfunc|cf_presupuesto;where|id_rfq = $id_rfq_actual;order|Presupuestos.fecha desc, Presupuestos.referencia desc;%@ 
<td><a href="?seccion=bo_presupuesto_cliente&id_presupuesto=@%db:Presupuestos.id_presupuesto;%@">@%db:not_empty{Presupuestos.referencia};%@</a></td>
<td>@%db:colocar_fecha{Presupuestos.fecha};%@</td>
<td align="center">
@%if:esta_vacio;pedido_de_presupuesto;%@
	<img src="imag/@%get:icono_estado;;%@" />
@%else:%@
	@%if:AllowedLink;bo_pedido_cliente;%@
	<a href="?seccion=bo_pedido_cliente&id_pedido=@%get:pedido_de_presupuesto;%@" ><img src="imag/iconos/ver.png" border="0"/></a>
	@%end-if:%@
@%end-if:%@
</td>
@%end-where:%@

</tbody>
</table>

@%if:esta_vacio;fecha_inicio;%@
<div class="AccionesFicha" >
	<ul>
	@%if:AllowedAction;RFQ;edit;%@
		<li><a href="#" onclick="return onHRefClick('@%get:documento_formvarname;%@','accion_ejecutar','ModificarPresupuesto');" class="guardar" ><img 
		src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
	@%end-if:%@
	@%if:AllowedLink;hacer_pedido;%@
		@%if:AllowedAction;RFQ;edit;%@
		<li><a href="?seccion=hacer_pedido&returnlink=rfq" class="seleccionar" ><img src="imag/pixel.png" class="icono" 
			/><span>Seleccionar Produto</span></a></li>
		@%end-if:%@
	@%end-if:%@
	@%if:AllowedAction;RFQ;edit;%@
	@%if:esta_vacio;fecha_inicio;%@
		<li><a href="#" onclick="return onHRefClick('@%get:documento_formvarname;%@','accion_ejecutar','BorrarDetalle');" class="borrar" ><img src="imag/pixel.png" 
			class="icono" /><span>Eliminar Artigo(s)</span></a></li>
		@%set:documento_permitir_selecciones=1;%@
	@%end-if:%@
	@%end-if:%@
	</ul>
</div>
<form name="@%get:documento_formvarname;%@" method="post" action="?seccion=@%get:_krn_ss_name;%@" > 
<input type="hidden" name="accion_ejecutar" value="ModificarDetalles" />
@%plt:Presupuesto;%@
</form>
</fieldset>
@%end-if:%@

@%end-if:%@


