
@%plt:botonera%@

<div id="AccionesListado" ><ul>
@%if:AllowedLink;bo_importar_clientes_agente;%@
<li><a href="?seccion=bo_importar_clientes_agente" class="importarusuario"><img src="images/pixel.png" class="icono" /><span>Importer clients</span></a></li>
@%end-if:%@
@%if:AllowedAction;Agentes;del;%@
<li><a href="#" onClick="return onHRefClick('agentes_clientes','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
@%set:permitir_selecciones=1;%@
@%end-if:%@
</ul></div>

<form action="?seccion=bo_agentes_clientes" method="post" name="agentes_clientes">
<input type="hidden" name="accion_ejecutar" value="0" />
<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Clientes.id_cliente" >Codi<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.id_cliente;%@" /></a></td>
<td></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Nom<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Agentes_clientes.fecha_captacion" >Data captaci�<img src="images/pixel.png" 
	class="@%func:class_searchsort;Agentes_clientes.fecha_captacion;%@" /></a> </td>
<td ><a href="?_search_sort=Agentes_clientes.comision" >Comissi�<img src="images/pixel.png" class="@%func:class_searchsort;Agentes_clientes.comision;%@" /></a></td>
<td ><a href="?_search_sort=Agentes_clientes.comision_repartida" >Comissi� repartida<img src="images/pixel.png" 
class="@%func:class_searchsort;Agentes_clientes.comision_repartida;%@" /></a></td>
 </tr>
</thead>
<tbody>
 @%where:tabla|Agentes_clientes;order|Clientes.nombre, Clientes.apellidos;no_results|1;nombre|busc;%@ 
<input type="hidden" name="indices[]" value="@%db:Clientes.id_cliente%@" />
<tr
@%if:!esta_vacio;Clientes_empresas.fecha_baja;%@
class="impropio"
@%end-if:%@
> 
<td>@%db:Clientes.id_cliente;%@</td>
<td class="check"><input type="checkbox" name="borrar_cliente_agente[@%db:Clientes.id_cliente%@]" value="1" /></td>
<td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social;%@</a></td>
<td>@%db:colocar_fecha{Agentes_clientes.fecha_captacion};%@</td>
<td>
@%if:AllowedAction;Agentes_clientes;edit;%@
<input type="text" size="10" name="agentes_clientes_comision[@%db:Clientes.id_cliente%@]" value="@%db:Agentes_clientes.comision;%@" />
@%else:%@
@%db:Agentes_clientes.comision;%@
@%end-if:%@
</td>
<td>
@%if:AllowedAction;Agentes_clientes;edit;%@
<input type="text" size="10" name="agentes_clientes_comision_repartida[@%db:Clientes.id_cliente%@]" value="@%db:Agentes_clientes.comision_repartida;%@" />
@%else:%@
@%db:Agentes_clientes.comision_repartida;%@
@%end-if:%@
</td>
</tr>
 @%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@

@%if:AllowedAction;Agentes_clientes;edit;%@
<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('agentes_clientes','accion_ejecutar','Modificar');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>
@%end-if:%@

