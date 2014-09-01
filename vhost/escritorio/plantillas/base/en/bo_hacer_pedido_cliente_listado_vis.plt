

@%plt:botonera%@

<form name="compra_articulos" method="post" action="?seccion=hacer_pedido">
<input type="hidden" name="nuevo" value="1" />
<input type="hidden" name="pedido" value="@%get:es_pedido;%@" />
<input type="hidden" name="presupuesto" value="@%get:es_presupuesto;%@" />
<input type="hidden" name="factura" value="@%get:es_factura;%@" />
<input type="hidden" name="proforma" value="@%get:es_proforma;%@" />

<table class="full">
<tr>
<td class="caption">Code</td>
<td></td>
<td class="caption">Client | Company Name</td>
<td class="caption">Contact</td>
<td class="caption">EIN</td>
<td class="caption">CT</td>
 </tr>
 <!-- aqui viene el registro -->
@%set:_selected_value=_st_crm_id_usuario;%@
@%where:tabla|Clientes;nombre|busc;no_results|1;%@
<tr>
<td>@%db:Clientes.id_cliente;%@</td>
<td class="check"> <input type="radio" name="id_cliente" value="@%db:Clientes.id_cliente;%@" 
@%db:selected_value{Clientes_empresas.crm_id_usuario};%@
/></td>
<td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a>
 @%db:Clientes.razon_social;%@ @%db:Clientes.poblacion;%@</td>
<td>@%db:Clientes.persona_contacto;%@ - @%db:Clientes.cargo_persona_contacto;%@
 <a href="mailto:@%db:Clientes.email;%@">@%db:Clientes.email;%@</a>
 Tel.: @%db:Clientes.telefono1;%@</td>
<td>@%db:Clientes.prefijo_cif;%@ - @%db:Clientes.cif;%@</td>
<td>Rd@%db:Tipo_cliente.nombre%@</td>
</tr>
 <!-- Fin del registro -->
 @%end-where:%@

 </table>
<input type="hidden" name="Continuar" value="Continuar" /></td>
 </form>
@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('compra_articulos');" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Select</span></a></li>
</ul></div>

