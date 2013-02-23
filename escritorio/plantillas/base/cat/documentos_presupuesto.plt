<fieldset id="DocumentosPresupuesto" class="fsficha">
<legend>Documents per a Pressupostos</legend>
<div class="AccionesFicha" >
<ul>
@%if:esta_vacio;id_grupo_docs;%@
@%else:%@
@%if:AllowedAction;Presupuestos_Documentos_CRM;new;%@
<li><a href="#" onClick="return onHRefClick('documentos','accion_ejecutar','NuevoDocumento');" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nou</span></a></li>
@%end-if:%@
@%end-if:%@

@%if:AllowedAction;Presupuestos_Documentos_CRM;edit;%@
<li><a href="?seccion=crm_seleccionar_documento&varios=1&id_presupuesto=@%get:id_presupuesto;%@" 
	class="asociar" ><img src="images/pixel.png" class="icono" /><span>Seleccionar Document</span></a></li>
<li><a href="#" onClick="return sendForm('documentos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Guardar</span></a></li>
@%end-if:%@

@%if:AllowedAction;Presupuestos_Documentos_CRM;del;%@
<li><a href="#" onClick="return sendForm('documentos','accion_ejecutar','BorrarDocumentos',null,'�Est� segur que desitja esborrar els registres seleccionats?');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
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
   <td>Nom</td>
   <td>Tipus</td>
   <td>Grup</td>
   <td>Nota</td>
   </tr>
   </thead>
   <tbody>
   @%where:tabla|Presupuestos_Documentos_CRM;where|id_presupuesto = $id_presupuesto;%@
   <!-- @%db:Presupuestos_Documentos_CRM.id_documento;%@ @%set:iddoc = Presupuestos_Documentos_CRM.id_documento;%@ 
   @%db:Presupuestos_Documentos_CRM.nota;%@ @%set:nota=Presupuestos_Documentos_CRM.nota;value|var;%@ -->
   <tr>
   	@%where:db|crm;Documentos;where|Documentos.id_documento = $iddoc;%@
	<td class="check">
@%if:AllowedAction;Presupuestos_Documentos_CRM;del;%@
	<input type="checkbox" name="documento[@%db:Documentos.id_documento;%@][id_documento]" value="@%db:Documentos.id_documento;%@" >
@%end-if:%@
	</td>
	<td><a href="?seccion=download&id=@%db:Documentos.id_documento;%@" >@%db:Documentos.nombre;%@</a> 
	<!-- @%db:Documentos.file_size;%@ --> (@%calc:Documentos.file_size/1024;output|1;round|0;%@ Kbs)</td>
	<td>@%db:Tipos_documento.nombre;%@</td>
	<td>@%db:Agrupaciones_documentos.nombre;%@</td>
   	<td>
@%if:AllowedAction;Presupuestos_Documentos_CRM;edit;%@
	<textarea name="documento[@%db:Documentos.id_documento;%@][nota]" rows="2" cols="80" wrap="VIRTUAL">@%get:nota;%@</textarea>
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
@%if:AllowedAction;Presupuestos_Documentos_CRM;new;%@
   <div class="documentos">Nou Document<input type="text" name="documento[nombre]" ><input type="file" name="document_file" /><br />
   <input type="hidden" name="documento[id_agrupacion_documentos]" value="@%get:id_grupo_docs;%@" />
   <textarea name="documento[sinopsis]" rows="5" cols="80" wrap="VIRTUAL"></textarea></div>
@%end-if:%@
   @%end-if:%@
</div>

</form>
</fieldset>

