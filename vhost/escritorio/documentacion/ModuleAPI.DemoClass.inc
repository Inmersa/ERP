<?php

class DeliveryEntry extends dbListItem {
}

class DeliveryEntries extends IndexList {

	function DeliveryEntries () {
	}
}

class DeliveryNote extends dbItemMultiEntity {
	var $oDetails = NULL;

	function DeliveryNote( $dbname = 'data', $AppName = NULL , $aData = NULL) {

		if (empty($AppName)) $AppName = $GLOBALS['APP_NAME'];
		$tabla = 'Albaranes';

		$aFlds['Albaranes:Albaran'] = array(
			// Claves, propia y foraneas
			'id_albaran', 'id_transportista', 'id_pedido', 'id_direccion', 'id_almacen', 
			// Fechas
			'fecha','id_dia','fecha_envio','id_dia_envio','fecha_recepcion','id_dia_recepcion',
			// Estados
			'preparado','enviado','confirmacion','devolucion',
			// Datos propiamente dicho
			'referencia','referencia_externa','observaciones','bultos'
			);
		$aFlds['Transportistas:Transportista'] = array(
			// Claves
			'id_transportista',
			// Datos
			'nombre','apellidos','razon_social','cif','direccion','poblacion','cp','telefono','telefono2','fax','email',
			'iban','bic','bban','entidad','dc_ccc','oficina','cuenta_bancaria'
			);
		$aFlds['Pedidos:Pedido'] = array(
			// Claves
			'id_pedido','id_empresa','id_direccion','id_proveedor',
			// Datos
			'referencia','referencia_externa','nombre','observaciones','fecha','id_dia','preparado','id_pedido_incompleto','residual'
			);
		$aFlds['Empresas:Empresa'] = array(
			// Claves
			'id_empresa',
			// Datos
			'nombre','apellidos','razon_social','direccion_facturacion','cp','email','web','poblacion','telefono1','telefono2',
			'fax','stock_negativo',
			// Contadores
			'prefijo_alb_ventas','sufijo_alb_ventas','contador_alb_ventas','digitos_alb_ventas',
			'prefijo_alb_compras','sufijo_alb_compras','contador_alb_compras','digitos_alb_compras',
			);
		$aFlds['Direcciones_entrega:Direccion'] = array(
			// Claves
			'id_direccion','id_cliente','id_provincia',
			// Datos
			'nombre','direccion','cp','poblacion','email','telefono1','fax','persona_contacto','cargo_persona_contacto','observaciones'
			);
		$aFlds['Clientes:Cliente'] = array(
			// Claves
			'id_cliente',
			// Datos
			'razon_social','prefijo_cif','cif','nombre','apellidos','direccion_facturacion','cp',
			'poblacion','id_provincia','email','telefono1','telefono2','fax'
			);
		$aFlds['Proveedores:Proveedor'] = array(
			// Claves
			'id_proveedor',
			// Datos
			'razon_social','prefijo_cif','cif','nombre','apellidos','domicilio','cp',
			'poblacion','id_provincia','email','telefono1','telefono2','fax'
			);
		$aFlds['Almacenes:Almacen'] = array(
			// Claves
			'id_almacen', 'id_empresa', 'id_provincia',
			// Datos
			'nombre','direccion','cp','poblacion','telefono','fax','email','nota_pie_albaran','persona_contacto','cargo_persona_contacto'
			);

		$aAcciones['id_transportista'] = array('method' => 'updateCarrier');

		if (!parent::dbItemMultiEntity($AppName,$dbname,$tabla,$aFlds,$aData,$aAcciones)) {
			debug("FAAAAAAlso ");
			$this->setFlag($this->ST_CORRUPT);
			return false;
		}

	}

	/** Metodos para una clase dbItemMultiEntityWithIndexList 
		TODO:
		Lo suyo seria, crear una clase que permita indicarle en el constructor las distintas
		variables contenedores de listas indexadas y sus respectivas clases. Pudiendo activar
		una u otra, para que las llamadas a los metodos 'permeados' de la clase IndexList, si 
		no se le indica objeto de trabajo, pille el 'activo' en dicho momento.
	 **/
	function &getEntries() {
	}

	function newEntry() {
	}

	function delEntry() {
	}

	function getEntryData($idx) {
	}

	function _factoryEntries() {
	}
	/** Fin de metodos para una clase dbItemMultiEntityWithIndexList **/

	function updateCarrier($a, $b) {
		$this->debug("param a $a y b $b ",'updateCarrier');
		$rval = $this->dbFillEntity(array($b => $a),'Transportista');
		return $rval;
	}

}

?>
