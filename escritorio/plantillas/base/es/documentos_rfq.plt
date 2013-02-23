@%where:nodb|class_dbItemMultiEntity_iface;nombre|FichaDeEvento;%@
@%if:esta_vacio;grupodocs_interno;%@
@%set:id_grupo_docs=Tipo.id_agrupacion_documentos_externos;value|var;%@
@%else:@
@%set:id_grupo_docs=Tipo.id_agrupacion_documentos_internos;value|var;%@
@%end-if:%@

<fieldset id="DocumentosPresupuesto" class="fsficha">
<legend>Documentos de RFQ</legend>
<div class="AccionesFicha" >
<ul>
@%if:esta_vacio;id_grupo_docs;%@
@%else:%@
@%if:AllowedAction;RFQ_documentos;new;%@
<li><a href="#" onClick="return onHRefClick('documentos','accion_ejecutar','NuevoDocumento');" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
@%end-if:%@
@%end-if:%@

@%if:AllowedAction;RFQ_documentos;edit;%@
<li><a href="?seccion=crm_seleccionar_documento&varios=1" 
	class="asociar" ><img src="imag/pixel.png" class="icono" /><span>Seleccionar Documento</span></a></li>
<li><a href="#" onClick="return sendForm('documentos');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
@%end-if:%@

@%if:AllowedAction;RFQ_documentos;del;%@
<li><a href="#" onClick="return sendForm('documentos','accion_ejecutar','BorrarDocumentos',null,'¿Está ud. seguro de que desea borrar los registros seleccionados?');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
@%end-if:%@

</ul>
   </div>

<form name="documentos" action="#" method="post" enctype="multipart/form-data" >
<input type="hidden" name="accion_ejecutar" value="ModificarDocumentos" />
<div id="NuevosComentarios" class="documentos">
   <div class="encabezado">
   <table class="full">
   <thead>
   <tr>
   <td>&nbsp;</td>
   <td>Nombre</td>
   <td>Tipo</td>
   <td>Grupo</td>
   <td>Nota</td>
   </tr>
   </thead>
   <tbody>
   @%where:nodb|class_CRMEvent_getfirstdocs;%@
   <!-- @%set:iddoc = id_documento;value|var;%@ @%set:idx=idx;%@ @%set:nota=texto_publico;%@ -->
   <tr>
   	@%where:db|crm;Documentos;where|Documentos.id_documento = $iddoc;limit|1;%@
	<td class="check">
@%if:AllowedAction;RFQ_documentos;del;%@
	<input type="checkbox" name="documento[@%get:idx;%@][id_documento]" value="@%db:Documentos.id_documento;%@" >
@%end-if:%@
	</td>
	<td><a href="?seccion=download&id=@%db:Documentos.id_documento;%@" >@%db:Documentos.nombre;%@</a> 
	<!-- @%db:Documentos.file_size;%@ --> (@%calc:Documentos.file_size/1024;output|1;round|0;%@ Kbs)</td>
	<td>@%db:Tipos_documento.nombre;%@</td>
	<td>@%db:Agrupaciones_documentos.nombre;%@</td>
   	<td>
@%if:AllowedAction;RFQ_documentos;edit;%@
	<textarea name="documento[@%get:idx;%@][nota]" rows="2" cols="80" wrap="VIRTUAL">@%get:nota;%@</textarea>
@%else:%@
	@%get:nota;%@
@%end-if:%@
	</td>
	@%end-where:%@

   </tr>
   @%end-where:%@

   </tbody>
   </table>
   </div>

   @%if:esta_vacio;id_grupo_docs;%@
   @%else:%@
	@%if:AllowedAction;RFQ_documentos;new;%@
	   <div class="documentos">Nuevo Documento<input type="text" name="documento[nombre]" ><input type="file" name="document_file" /><br />
	   <input type="hidden" name="documento[id_agrupacion_documentos]" value="@%get:id_grupo_docs;%@" />
	   <textarea name="documento[sinopsis]" rows="5" cols="80" wrap="VIRTUAL"></textarea></div>
	@%end-if:%@
   @%end-if:%@
</div>

</form>
</fieldset>

