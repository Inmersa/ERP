 
@%plt:botonera%@ 

<form name="importar_clientes" action="?seccion=bo_clientes" method="post">
<input type="hidden" name="accion_ejecutar" value="Importar">
 <table class="full">
 <thead>
 <tr> 
 <td >Code</td>
 <td ></td>
 <td >Company| Company</td>
 <td >Contact</td>
 <td >EIN</td>
 </tr>
 </thead>
 <!-- aqui viene el registro -->
 @%where:tabla|Clientes;nombre|busc;no_results|1;%@
 <tr> 
 <td>@%db:Clientes.id_cliente;%@
 <td class="check" ><input type="checkbox" name="importar_clientes[@%db:Clientes.id_cliente;%@]" value="1"></td>

 <td><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" >@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a><br>
 @%db:Clientes.razon_social;%@<br>
 @%db:Provincias.nombre;%@ - @%db:Clientes.poblacion;%@</td>

 <td>@%db:Clientes.cargo_persona_contacto;%@<br>
 <a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a><br>
 @%db:Clientes.telefono1;%@</td>

 <td>@%db:Clientes.prefijo_cif;%@ - @%db:Clientes.cif;%@
 </td>

 </tr>
 @%end-where:%@ 
 
 </table>
 </form>

 @%plt:botonera%@ 

 <div class="AccionesEnvio">
 <ul>
 <li><a href="#" onclick="return sendForm('importar_clientes');" class="enviar"><img src="images/pixel.png" class="icono" /><span>Import</span></a></li>
 </ul>
 </div>






