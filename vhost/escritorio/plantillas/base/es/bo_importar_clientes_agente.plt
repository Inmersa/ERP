<div class="barraoscura">
<div class="titsuperior">&gt; IMPORTAR CLIENTE AGENTE (
       @%where:tabla|Agentes;nolink|1;where|id_agente = $id_agente_promocion;%@
       @%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@
       @%end-where:%@

       )</div>
 
</div> 

 @%plt:Importar_Agentes%@ 

