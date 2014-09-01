@%where:tabla|Albaranes;where|Albaranes.id_albaran = $id_albaran_cabecera;nolink|1;%@
<!-- @%db:Albaranes.id_albaran;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >Guias de Remessa de Reembolso</td>
 <td >Referência Externa</td>
 <td >Encomenda</td>
 <td >Data</td>
 <td >Data de Saída</td>
 <td >Embalagens</td>
 <td >Peso Total</td>
 <td >Armazém</td>
 <td >Transportador</td>
</tr>
</thead>
<tbody class="centrado">
<tr>
 <td>@%db:Albaranes.referencia;%@</td>
 <td>@%db:Albaranes.referencia_externa;%@</td>
 <td >@%db:Pedidos.referencia;%@</td>
 <td >@%db:colocar_fecha{Albaranes.fecha};%@</td>
 <td >@%db:colocar_fecha{Albaranes.fecha_envio};%@</td>
 <td >@%db:Albaranes.bultos;%@</td>
 <td >
	  @%where:tabla|Detalles_albaran;group|Albaranes.id_albaran%@
	  <!-- 
	  @%db:SUM(Detalles_albaran.cantidad_devuelta * Articulos.peso_unidad) as 'peso';%@
	  @%db:Articulos.id_articulo;%@ 
	  -->
	  @%calc:peso;output|1;round|2;%@
	  @%end-where:%@
	  
 Kg</td>
 <td >@%db:Almacenes.nombre;%@</td>
 <td >@%db:Transportistas.nombre;%@</td>
</tr>
</tbody>
</table>

@%end-where:%@ 
