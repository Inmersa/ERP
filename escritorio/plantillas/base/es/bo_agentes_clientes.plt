<div class="tituloseccion">LISTADO CLIENTES DE AGENTE (
       @%where:tabla|Agentes;nolink|1;where|id_agente = $id_agente;%@
       @%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@
       @%end-where:%@

       )</div>

 @%plt:Agentes_Cliente%@ 

