<?php

function pre_bo_ayuda(&$Sesion) {
	$estado=$Sesion->fetchVar('estado','POST');
			
	$registro=$Sesion->fetchVar('registro','POST');
	$registro_borrar=$Sesion->fetchVar('registro_borrar','POST');
	$old_idsub=$Sesion->fetchVar('old_idsub','POST');
	$borrar_epigrafes=$Sesion->fetchVar('borrar_epigrafes','POST');

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) return NULL;

	switch($estado) {
		case 1: // Nuevo.
		   if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
			   if (!$oDb->tb_replace("Ayuda",$registro)) {
			  		$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Ayuda'));
			   }
		   }
		   break;

		case 2: 
		   // Borrar los que tengan las checkboxes.
		   // debug("Borramos registros de Ayuda...");
		   // print_r($registro_borrar);
		   foreach ($registro_borrar as $idsub => $bool)
				if ((int)$bool) {
					$oDb->tb_delete("Ayuda",array("id_sub" => $idsub));
					$oDb->tb_delete("Ayuda_epigrafes",array("id_sub" => $idsub));
				}
		   break;

		case 3: 
		   // Modificar una Ayuda existente.
		   if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
		      if (!is_array($registro) OR !(int)$registro['id_sub']) return NULL;
		      if (!(int)$old_idsub) $old_idsub = $registro['id_sub'];
		      $oDb->tb_update("Ayuda",$registro,array("id_sub" => $old_idsub));
		      if ($old_idsub != $registo['id_sub'])
					$oDb->tb_update("Ayuda_epigrafes",array("id_sub" => $registro['id_sub']),array("id_sub" => $old_idsub));

		      if (is_array($borrar_epigrafes))
			 foreach ($borrar_epigrafes as $idep) 
			    $oDb->tb_delete("Ayuda_epigrafes",array("id_epigrafe" => $idep));
		   }
		   break;

		default :
		   break;
	}

	return NULL;
}

function pre_modif_ayuda(&$Sesion) {
	$estado=$Sesion->fetchVar('estado','POST');
	$borrar_epigrafes=$Sesion->fetchVar('borrar_epigrafes','POST');
	$registro=$Sesion->fetchVar('registro','POST');
	$id_sub=$Sesion->fetchVar('id_sub','GET');
	if (is_numeric($id_sub)) $Sesion->set_var('id_sub',$id_sub,'SUBSECCION');
	$estado = (int)$estado;

	$oDb = $Sesion->get_db('data');
	if (!is_object($oDb)) return NULL;
	
	switch ($estado) {

		case 3: // Nuevo epigrafe
		   if ($Sesion->verifyVar('registro',IKRN_VAR_CRC_CHANGE) AND $Sesion->verifyVar('registro',IKRN_VAR_CRC_AUTHED)) {
				if (!is_numeric($registro['id_imagen'])) $registro['id_imagen'] = 'null';
		      if (!$oDb->tb_replace("Ayuda_epigrafes",$registro)) {
					$Sesion->lcMessage('LCS_DBERR',array('entidad' => 'Ayuda_epigrafes'));
		      }
		   }
		   break;

		case 2:
			if (is_array($borrar_epigrafes) AND sizeof($borrar_epigrafes)) 
				foreach ($borrar_epigrafes as $id) {
					$oDb->tb_delete('Ayuda_epigrafes',array('id_epigrafe' => $id));
				}
			break;

		default:
		   break;
	}
}

function pre_nuevo_epigrafe(&$Sesion) {
	$id_sub=$Sesion->fetchVar('id_sub','GET');
	
	if (!(int)$id_sub) return NULL;
	$db = $Sesion->get_db('conf');
	if (!is_object($db)) return NULL;
	$cons = "SELECT nombre_visual,nombre FROM Sub_Secc WHERE id_sub_secc = $id_sub";
	$rs = $db->query($cons);
	if (!$db->num_rows($rs)) return NULL;
	$aSub = $db->fetch_assoc($rs);
	$Sesion->set_var("ayuda_id",$id_sub,"SUBSECCION");
	$Sesion->set_var("ayuda_nombre",$aSub['nombre'],"SUBSECCION");
	$Sesion->set_var("ayuda_nombre_visual",$aSub['nombre_visual'],"SUBSECCION");
}

function pre_modif_epigrafe(&$Sesion) {
	$id_epigrafe=$Sesion->fetchVar('id_epigrafe','GET');
	
	if (!is_object($Sesion->get_db("db_catalogo"))) {
	  $db_user = $Sesion->read_main_value("db_catalogo_login");
	  $db_pass = $Sesion->read_main_value("db_catalogo_passwd");
	  $db_host = $Sesion->read_main_value("db_catalogo_server");
	  $db_dbase= $Sesion->read_main_value("db_catalogo_dbase");
	  if (!empty($db_user) AND !empty($db_pass) AND !empty($db_host) AND !empty($db_dbase))
		  $Sesion->set_db("db_catalogo",new wol_db("db_catalogo",$db_user,$db_pass,$db_host,$db_dbase),1);
	  else
		  $Sesion->set_db("db_catalogo",$Sesion->get_db("data"),1);
	}

}

?>
