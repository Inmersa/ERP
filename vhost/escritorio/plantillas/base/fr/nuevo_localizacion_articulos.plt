<table class="full">
 <tr> <td bgcolor="#CCD2D7"> <table class="full">
 <tr> <td width="6" ></td>
 <td class="titocho" >&gt; Nouvelle Localisation Article</td>
 <td ><a href="javascript: history.go(-1);" >Tourner</a></td>
 </tr>
 </table>
 </td>
 </tr>

 <tr> <td> <table class="full">
 <tr> <td width="194" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> <td >Resultats: </td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 <tr> <td >Criteri � recherche: </td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td width="3"></td>
 <td bgcolor="@%get:color_accesos_mensaka%@" valign="top">
 @%plt:mensajero%@
 </td>
 </tr>
 </table>
 </td>
 </tr>

 <tr> <td > <table class="full">
 <form name="nuevo_localizacion_articulos" action="?seccion=bo_inventario_almacen_logico" method=post>
 <input type="hidden" name="accion_ejecutar" value="Nuevo">
 <tr> <td colspan="13" class="etiqueta" bgcolor="#CCD2D7">Ordre M�me fabrication: <select name="registro[lote]" >
@%where:tabla|Ordenes_fabricacion;nolink|1;%@
 <option value="@%db:Ordenes_fabricacion.lote;%@*@%db:Articulos.id_articulo;%@*@%db:Ordenes_fabricacion.fecha_caducidad;%@"> @%db:Articulos.nombre;%@ @%db:colocar_fecha{Ordenes_fabricacion.fecha_caducidad};%@ @%db:Ordenes_fabricacion.lote;%@ </option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="13"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Lot </td>
 <td ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Plante</td>
 <td ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Couloi</td>
 <td class="etiqueta" ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Rang</td>
 <td ></td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Colonne</td>
 <td ></td>
 <td class="etiqueta" bgcolor="#DBE0E3" >Quantite</td>
 <td bgcolor="#DBE0E3" ></td>
 </tr>
 <tr> <td colspan="13" ></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" ></td>
 <td > <input type="checkbox" name="registro[lote_propio]" value=1 >
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td > <input type="text" name="registro[planta]" size="5">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td > <input type="text" name="registro[pasillo]" size="5">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td > <input type="text" name="registro[fila]" size="5">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td > <input type="text" name="registro[columna]" size="5">
 </td>
 <td bgcolor="#DBE0E3"></td>
 <td > <input type="text" name="registro[cantidad]" size="8">
 </td>
 <td bgcolor="#DBE0E3" ></td>
 </tr>
 <tr > <td colspan="13" bgcolor="#CCD2D7"><a href="javascript:document.forms['nuevo_localizacion_articulos'].submit();" >Garder</a> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td ></td>
 </tr>
</table>
