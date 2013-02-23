@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.id_cliente%@ -->
<fieldset class="fsficha">
<legend>Notes</legend>
<table class="full">
 <tr>
 <td class="etiqueta">Recommended by:</td>
 <td>
 <!--@%db:Clientes_empresas.id_recomendador%@ @%set:id_reco=Clientes_empresas.id_recomendador;%@-->
 @%if:esta_vacio;id_reco;%@
 @%else:%@
 @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_reco ;%@
 @%db:Clientes.razon_social%@ (@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@)
 @%end-where:%@
 
 @%end-if:%@
</td>
 @%if:AllowedLink;bo_importar_recomendador;%@
 <td class="etiqueta"><a href="?seccion=bo_importar_recomendador" class="accesos">Assign</a></td>
 @%end-if:%@
 <td class="etiqueta" >Register date:</td>
 <td colspan="2">@%db:colocar_fecha{Clientes_empresas.fecha_alta}%@</td>
 </tr>

 </table>
 </fieldset>
