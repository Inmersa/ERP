<?php
include_inm("scripts/buscador/botonera.php");

function fd_hacer_pedido_cliente(&$Sesion,&$oSearch){
  	global $nom_bus;
   global $nombre;
   global $id_empresa;
   global $id_direccion;
   global $codigo_cliente;
   global $hp;

   global $id_cli;
   global $id_ag;
	global $id_rfq;
	global $crm_id_usuario;

 	$usuario = identifica_usuarios($Sesion);

   if (empty($id_empresa)) {
      $id_empresa =(int)$usuario['id'];
   }
	if (!strcmp($usuario['desktop_name'],'Clientes')) {
		$codigo_cliente = (int)$usuario['valor'];
   } elseif (empty($nombre) AND is_numeric($id_rfq)) {
		$linkcrm = $Sesion->get_var('LinkCRM');
		if (!empty($linkcrm)) {
			$oRFQ = new RFQ($Sesion->App_Name,'crm','crmcfg',NULL);
			if ($oRFQ->dbFill($id_rfq)) {
				$crm_id_usuario = $oRFQ->getAttribute('id_usuario','Implicado');
				$Sesion->set_var('_st_crm_id_usuario',$crm_id_usuario,'SUBSECCION');
				$Sesion->set_var('_presupuesto_id_rfq',$id_rfq,'NOEXPIRE');
				$Sesion->set_var('_presupuesto_rfq',$oRFQ,'NOEXPIRE');
			}
		}
	}
	if (!strcasecmp($usuario['desktop_name'],'Agentes')) {
		$id_ag = $usuario['valor'];
	}

	$id_direccion = (int)0;

   $oSearch->set_distinct("ROW");
   $oSearch->add_where('Clientes_empresas.fecha_baja IS NULL','AND',false);

   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}
   if (!empty($id_cli)) {
		$codigo_cliente = $id_cli;
      $st_id_cli = $id_cli;
	}

	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($st_id_cli)) {
		$Sesion->set_var('st_id_cli',$st_id_cli,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_id_cli');
	}

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
