
<div class="resultados">
<div class="botonera">
 @%if:numero_resultados%@
<form name="paginado" action="?seccion=@%get:_krn_ss_name;%@" method="post" id="FormPaginacion" >
<input type="hidden" name="nombre_variable_paginado" value="pag"/>
<input type="hidden" name="pag"/>
<input type="hidden" name="checked_boxes"/>
</form>

Pages:

@%if:anterior%@
<a href="#" onClick="return arrastre_paginado('FormPaginacion','@%func:pg_ant%@');" >prev</a>
@%end-if:%@ 

@%where:nodb|nodbbotonera;%@
@%if:paginar%@
<a href="#" id="Pag@%db:disp_page;%@" onClick="return arrastre_paginado('FormPaginacion','@%db:link_page%@');">@%db:disp_page%@</a> 
@%else:%@
 <span class="botdestacado">@%db:disp_page%@</span>
@%end-if:%@
@%end-where:%@ 

@%if:siguiente%@
 <a href="#" onClick="return arrastre_paginado('FormPaginacion','@%func:pg_sig%@');">next</a>
@%end-if:%@
<script languaje="javascript">
<!--
// AppIface.linkEventToIdTags('Tabla@%get:formulario_botonera;%@','onclick',acciones_fila,'TBODY:TR');
-->
</script>

 @%end-if:%@

</div><div class="alinder">Resultats: @%func:numero_resultados;%@</div>
</div>
