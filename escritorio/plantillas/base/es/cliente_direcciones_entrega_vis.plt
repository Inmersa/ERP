
<fieldset class="fsficha">
<legend>Direcciones de entrega</legend>
<div class="barraoscura"><div class="alinder">
@%if:AllowedLink;nuevo_direcciones_entrega;%@
	@%if:AllowedAction;Direcciones_entrega;new;%@
	<a href="?seccion=nuevo_direcciones_entrega&amp;id_cliente=@%get:id_cliente_promocion%@">Añadir dirección</a> 
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Direcciones_entrega;del;%@
<a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','Borrar');">Borrar direcciones</a>
@%end-if:%@
</div></div>

<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#EBECED"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" height="20" ></td>
 <td class="etiqueta" height="20" width="172" >Direcciones de entrega:</td>
 </table>
 </td>
 </tr>
 <tr> <td height="10"></td>
 </tr>
 <tr><td> 
 @%where:tabla|Direcciones_entrega;where|Clientes.id_cliente= $id_cliente_promocion;order|Direcciones_entrega.nombre,Direcciones_entrega.direccion;%@
 <table width="500" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="10"></td>
 <td class="texto">
@%if:AllowedLink;modif_direcciones_entrega;%@ 
	@%if:AllowedAction;Direcciones_entrega;edit;%@
	<a href="?seccion=modif_direcciones_entrega&amp;id_direccion=@%db:Direcciones_entrega.id_direccion%@" 
		>@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@</a>
	@%else:%@
	@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@
	@%end-if:%@
@%else:%@
@%db:Direcciones_entrega.nombre%@ @%db:Direcciones_entrega.direccion%@ - @%db:Direcciones_entrega.poblacion;%@
@%end-if:%@
 </td>
 </tr>
 </table>
 @%end-where:%@

 </td>
 </tr>
 </table>
 </fieldset>
