
<div class="barraoscura">
<div class="titsuperior">&gt; Rappel anual (
      @%where:tabla|Clientes;nolink|1;where|id_cliente = $id_cliente_promocion;%@
      @%db:Clientes.razon_social;%@ 
      @%end-where:%@

      )
</div>
<div class="alinder"><a href="javascript: history.go(-1);">Tornar</a>
</div>
</div>
<form name="rappel_cliente" method="post" action="?seccion=bo_rappel_cliente">
<div class="barraoscurai">Finalitzat 12 messos</div>
<table class="full">
<tr>
<td colspan="2">
</td>
<td class="etiqueta">Data d´inici
</td>
</tr>@%set:_iterate_times=15%@
@%where:nodb|nodb_iterate;%@
<tr>
<td class="etiqueta">de
<input type="text" name="rappel[@%db:iterate_num%@][monto_inicial]" size="15" maxlength="9" />A
<input type="text" name="rappel[@%db:iterate_num%@][monto_final]" size="15" maxlength="9" />
</td>
<td>
<input type="text" name="rappel[@%db:iterate_num%@][porcentaje]" size="5" maxlength="5" />%
</td>
<td>
<input type="text" name="rappel[@%db:iterate_num%@][fecha_inicial]" size="12" value="dd/mm/aaaa" maxlength="10" />
</td>
</tr>
@%end-where:%@

</table>
<input type="hidden" name="accion_ejecutar" value="Anyadir" />
<div class="enviar"><a href="" onClick="document.forms['rappel_cliente'].submit();return false;">Afegir</a>
</div>
</form>
