<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre , id_empresa */
function fd_rutas(&$Sesion,&$Search){
	global $nom_bus;
   global $nombre_ruta;
   global $nombre_cliente;
	global $codigo_cliente;
   global $nombre_agente;
	global $codigo_agente;
   global $id_cli;
   global $id_empresa;
   global $codigo_cliente;
	global $id_agente;
	global $hp;

	$usuario = identifica_usuarios($Sesion);
   if (empty($id_empresa)) $id_empresa =(int)$usuario['id'];

	if (!strcasecmp($usuario['group_name'],"Agentes")) $id_agente = $usuario['valor'];

   if (!empty($nombre_agente)) {
      $st_nombre_agente = $nombre_agente;
		if (is_numeric($nombre_agente)) {
			$codigo_agente = (int)$nombre_agente;
			$nombre_agente = NULL;
			unset($nombre_agente);
		} else {
			$codigo_agente = NULL;
			unset($codigo_agente);
		}
	}
   if (!empty($nombre_cliente)) {
      $st_nombre_cliente = $nombre_cliente;
		if (is_numeric($nombre_cliente)) {
			$codigo_cliente = (int)$nombre_cliente;
			$nombre_cliente = NULL;
			unset($nombre_cliente);
		} else {
			$codigo_cliente = NULL;
			unset($codigo_cliente);
		}
	}

	$Search->set_not_ruta_path(array('Agentes_clientes','Presupuestos','Facturas','Empresas','Pedidos','Citas'));
	$Search->set_ruta_path(array('Rutas_clientes'));
	if (!empty($nombre_ruta)) $Sesion->set_var('st_nombre_ruta',$nombre_ruta,'SUBSECCION');
	else $Sesion->unset_var('st_nombre_ruta');
	if (!empty($st_nombre_agente)) $Sesion->set_var('st_nombre_agente',$st_nombre_agente,'SUBSECCION');
	else $Sesion->unset_var('st_nombre_agente');
	if (!empty($st_nombre_cliente)) $Sesion->set_var('st_nombre_cliente',$st_nombre_cliente,'SUBSECCION');
	else $Sesion->unset_var('st_nombre_cliente');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}

}

function fd_recorridos(&$Sesion,&$Search){
	global $nombre_agente;
	global $codigo_agente;
	global $nombre_ruta;
	global $nombre_cliente;
	global $codigo_cliente;
	global $fecha_inicio;
	global $fecha_fin;
	global $hp;

   if (is_numeric($nombre)) {
      $id_cli =(int)$nombre;
      $codigo_cliente =(int)$nombre;
      $nombre=NULL;
      unset($nombre);
   } else unset($id_cli);

   if (!empty($nombre_agente)) {
      $st_nombre_agente = $nombre_agente;
		if (is_numeric($nombre_agente)) {
			$codigo_agente = (int)$nombre_agente;
			$nombre_agente = NULL;
			unset($nombre_agente);
		} else {
			$codigo_agente = NULL;
			unset($codigo_agente);
		}
	} else {
		if (!$Sesion->bRecarga) {
			$id_ag = id_entidad($Sesion,'id_agente');
			if (is_numeric($id_ag)) {
				$codigo_agente = $id_ag;
				$st_nombre_agente = $id_ag;
			}
		}
	}

	$aUsr = identifica_usuarios($Sesion);
	if (!strcasecmp($aUsr['desktop_name'],'Agentes')) {
		$codigo_agente = $aUsr['valor'];
		$nombre_agente = NULL;
		$_POST['nombre_agente'] = NULL;
		$st_nombre_agente = NULL;
	}

   if (!empty($nombre_cliente)) {
      $st_nombre_cliente = $nombre_cliente;
		if (is_numeric($nombre_cliente)) {
			$codigo_cliente = (int)$nombre_cliente;
			$nombre_cliente = NULL;
			unset($nombre_cliente);
		} else {
			$codigo_cliente = NULL;
			unset($codigo_cliente);
		}
	}
   if (!empty($nombre_ruta)) {
      $st_nombre_ruta = $nombre_ruta;
	}
	if (empty($fecha_fin) OR wol_db::formatear_fecha($fecha_fin,FALSE) == 'NULL') {
		$fecha_fin = NULL;
		unset($fecha_fin); 
		$st_fecha_fin = 'dd/mm/aaaa';
	} else $st_fecha_fin = $fecha_fin;

	if (empty($fecha_inicio) OR wol_db::formatear_fecha($fecha_inicio,FALSE) == 'NULL') {
		$fecha_inicio = NULL;
		unset($fecha_inicio); 
		$st_fecha_inicio = 'dd/mm/aaaa';
	} else $st_fecha_inicio = $fecha_inicio;

	$Search->add_select('COUNT(DISTINCT Citas.id_cliente) as "numero_clientes"');
	$Search->add_select('COUNT(DISTINCT Citas.id_pedido) as "numero_pedidos"');
	$Search->add_select('COUNT(DISTINCT Citas.id_pedido) / COUNT(DISTINCT Citas.id_cliente) * 100 as "efectividad"',false);
	$Search->add_where('Recorridos.id_recorrido = Citas.id_recorrido');
	$Search->groupby('Recorridos.id_recorrido');

	if (!empty($st_nombre_agente)) {
		$Sesion->set_var('st_nombre_agente',$st_nombre_agente,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre_agente');
	}
	if (!empty($st_nombre_cliente)) {
		$Sesion->set_var('st_nombre_cliente',$st_nombre_cliente,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre_cliente');
	}
	if (!empty($st_nombre_ruta)) {
		$Sesion->set_var('st_nombre_ruta',$st_nombre_ruta,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre_ruta');
	}
	if (!empty($st_fecha_inicio)) {
		$Sesion->set_var('st_fecha_inicio',$st_fecha_inicio,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_inicio');
	}
	if (!empty($st_fecha_fin)) {
		$Sesion->set_var('st_fecha_fin',$st_fecha_fin,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha_fin');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$Search->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$Search->get_hits_page(),'SUBSECCION');
	}
}

function fd_pda_recorrido(&$Sesion,&$oSearch) {
	global $fecha;
	global $id_ag;
	global $id_rec;
	global $id_recorrido;
	global $hp;

	if (!empty($fecha)) {
		$id_rec = NULL;
		unset($id_rec);
	} else {
		$id_recorrido_sess = $Sesion->get_var('id_recorrido_pda');
		if (is_numeric($id_recorrido)) {
			$id_rec = $id_recorrido;
		} else {
			if (is_numeric($id_recorrido_sess))
				$id_rec = $id_recorrido_sess;
			else
				$fecha = date('Y-m-d');
		}
	}
		
	$user = identifica_usuarios($Sesion);
	if (!strcasecmp($user['desktop_name'],'Agentes')) {
		$id_ag = $user['valor'];
	}
   if (!empty($nombre)) {
      $st_nombre = $nombre;
	}

	if (!empty($st_fecha)) {
		$Sesion->set_var('st_fecha',$st_fecha,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_fecha');
	}
	if (!empty($st_nombre)) {
		$Sesion->set_var('st_nombre',$st_nombre,'SUBSECCION');
	} else {
		$Sesion->unset_var('st_nombre');
	}
	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}

?>
