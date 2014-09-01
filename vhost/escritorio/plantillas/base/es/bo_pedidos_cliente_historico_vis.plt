
@%plt:botonera%@

 <table class="full">

 <tr>
 <td class="caption">Código</td>
 <td class="caption">Fecha</td>
 <td class="caption">Dir. entrega</td>
 <td class="caption">Base Imp.</td>
 <td class="caption">P</td>
 <td class="caption">A</td>
 <td class="caption">F</td>
 </tr>

<form name="bo_pedidos_cliente" method="post" action="?seccion=bo_pedidos_cliente">
<input type="hidden" name="accion_ejecutar" value="j" />
<!-- @%set:none=triangulo.png%@ @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ @%set:bad=negro.gif%@ -->
 @%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.fecha desc;cfunc|cf_pedidos%@ 
 <tr>
 <td>
 @%if:AllowedLink;bo_pedido_cliente;%@
 <a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" >@%db:Pedidos.referencia;%@</a>
 @%end-if:%@
 </td>
 <td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td>@%db:Direcciones_entrega.direccion;%@@%db:Direcciones_entrega.nombre;%@</td>
 <td>@%db:monto_pedido%@</td>
 <td><img src="imag/@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>
 <td><img src="imag/@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" /></td>
 <td><img src="imag/@%func:switch_alfa_dec;estado_factura;none;do;ok;%@" /></td>
 @%end-where:%@ 

</form>
</table>


 @%plt:botonera%@ 


