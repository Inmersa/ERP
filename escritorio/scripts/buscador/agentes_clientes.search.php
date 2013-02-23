<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_agente , id_empresa */
function fd_agentes_clientes(&$Sesion,&$oSearch){
   global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $id_agente;
   global $excluir_bajas;
	global $hp;

	$id_agente_sesion = $Sesion->get_var("id_agente_promocion");
	$usuario = identifica_usuarios($Sesion);
	$aSt = NULL;

   if (empty($id_agente)) {
      $id_agente= (int)$id_agente_sesion;
	}
   if (empty($id_empresa)) {
      $id_empresa= (int)$usuario['id'];
	}
	if (!empty($nombre)) {
		$aSt['nombre'] = $nombre;
	}
	if (!empty($excluir_bajas)) {
		$aSt['excluir_bajas'] = $excluir_bajas;
		$oSearch->add_where('Clientes_empresas.fecha_baja IS NULL','AND');
	}

	$Sesion->set_var('st',$aSt,'SUBSECCION');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
	
}
?>
