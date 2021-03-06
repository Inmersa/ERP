@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.id_cliente%@ -->
<fieldset class="fsficha">
<legend>Observationes</legend>
<table class="full">
 @%if:esta_vacio;LinkCRM;%@
 @%else:%@
 <tr>
 <td class="etiqueta">Utilisateur CRM:</td>
 <td>
 <!--@%db:Clientes_empresas.crm_id_usuario%@ @%set:id_crm=Clientes_empresas.crm_id_usuario;%@ @%set:usuario_actual=0;%@ -->
 @%if:esta_vacio;Clientes_empresas.crm_id_usuario;%@
 @%else:%@
 @%where:tabla|Usuarios;db|crm;nolink|1;where|id_usuario = $id_crm ;%@
 @%db:Usuarios.nombre;%@ @%db:Usuarios.apellidos;%@ (@%db:Usuarios.email;%@)
 <!-- @%db:Usuarios.id_usuario;%@ @%set:usuario_actual=Usuarios.id_usuario;%@ -->
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" colspan="2">
 @%if:AllowedLink;crm_seleccionar_usuario;%@
 <a href="?seccion=crm_seleccionar_usuario&id=@%get:usuario_actual;%@" >Asigner</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">D�marquer</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_usuario_crm]" value="1" ></td>
 </tr>
 @%end-if:%@

 <tr>
 <td class="etiqueta">Recommand� par:</td>
 <td>
 <!--@%db:Clientes_empresas.id_recomendador%@ @%set:id_reco=Clientes_empresas.id_recomendador;%@-->
 @%if:esta_vacio;id_reco;%@
 @%else:%@
 @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_reco ;%@
 @%db:Clientes.razon_social%@ (@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@)
 @%end-where:%@
 
 @%end-if:%@
</td>
 <td class="etiqueta" colspan="2">
 @%if:AllowedLink;bo_importar_recomendador;%@
 <a href="?seccion=bo_importar_recomendador" >Asigner</a>
 @%end-if:%@
 
 </td>
 <td class="etiqueta">D�marquer</td>
 <td class="check"><input type="checkbox" name="acciones[descartar_recomendador]" value="1" ></td>
 </tr>

 <tr><td class="etiqueta" >D�but de p�riode:</td>
 <td colspan="2">@%db:colocar_fecha{Clientes_empresas.fecha_alta}%@</td>
 <td class="etiqueta" >Derni�re Modification:</td>
 <td colspan="2">@%db:colocar_fecha{Clientes_empresas.ultima_modificacion}%@</td>
 </tr>
 <tr> <td class="etiqueta" >Observationes:</td>
 <td colspan="5"><textarea name="registro2[observaciones]" class="insertext" cols="60">@%db:Clientes_empresas.observaciones;%@</textarea></td>
 </tr>
 </table>
 </fieldset>
