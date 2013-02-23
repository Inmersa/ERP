@%where:format_name|classDocumentDetail;%@

@%set:_page_css = pagina;%@
@%plt:print_pagebreak;%@

<!-- @%set:resume_index=origen;%@ @%set:primera_vez=1;%@ -->
@%where:nodb|voipnodb_order_orig_resume_detail;nombre|resumenGrupo;%@

@%if:poner_cabecera;%@

</tbody></table></div>
@%plt:print_pagebreak;%@
<!-- @%set:_var_x_reset = 1;%@ @%set:primera_vez=1;%@-->

@%end-if:%@

<!-- @%set:_var_x = grupo0;%@ -->

@%if:cambia_var_x;%@

@%if:esta_vacio;primera_vez;%@
</tbody></table></div>
@%else:%@
<!-- @%set:primera_vez=0;%@ -->
@%end-if:%@

<div class="titulo">Detalhe por Número</div>
<div class="resumen" >

<div class="grupo" >Telefone @%db:grupo0;%@</div>

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td >Data</td>
 <td >Hora de Início</td>

 <td >Tipo de chamada</td>
 <td >Receptor</td>
 <td >Destino</td>

 <td >Consumo</td>
 <td >Preço</td>
 <td class="@%css:descuento;label;%@" >Desconto</td>
 <td >Montante</td>
<tr>
</thead>
<tbody>

@%end-if:%@

<!--
@%set:id_art=id_articulo;%@
@%set:_inm_count_times=2;%@
@%if:inm_count;%@
@%set:clase_fila=resalte;%@
@%else:%@
@%unset:clase_fila;%@
@%end-if:%@
-->
<tr class="@%get:clase_fila;%@"> 
 <td >@%db:lcfecha{iextra3};%@</td>
 <td >@%db:lchora{iextra3};%@</td>

 <td >@%db:nombre_familia;%@</td>
 <td >@%db:iextra2;%@</td>
 <td >@%db:nombre;%@</td>

 <td >@%db:cantidad;%@</td>
 <td class="importe" >@%db:precio_articulo;%@</td>
 <td class="importe @%css:descuento;%@" >@%db:descuento;%@</td>
 <td class="importe" >@%db:base_imponible;%@</td>

</tr>

@%if:esta_vacio;_aAppConf[print_observaciones_enlinea];%@
@%if:!esta_vacio;observaciones;%@
<tr class="@%get:clase_fila;%@" ><td colspan="10">@%db:observaciones;%@</td></tr> 
@%end-if:%@
@%end-if:%@

@%end-where:%@

</tbody></table>
</div>

</div>

