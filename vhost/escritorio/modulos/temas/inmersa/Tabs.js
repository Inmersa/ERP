
/** **

				if (document.layers) {
					capa.visibility="hide";
					capa.display = "none";
				} else {
					capa.style.visibility = "hidden";
					capa.style.display = "none";
				}

if (document.getElementsByTagName)
	var x = document.getElementsByTagName('DIV');
else if (document.all)
	var x = document.all.tags('DIV');
else return;
for (var i=0;i<x.length;i++)
{
	x[i].onmouseover = over;
	x[i].onmouseout = out;
}

if (e.keyCode) code = e.keyCode;
else if (e.which) code = e.which;

// Mouce-Click - el boton (derecho)
	var rightclick;
	if (!e) var e = window.event;
	if (e.which) rightclick = (e.which == 3);
	else if (e.button) rightclick = (e.button == 2);
	alert('Rightclick: ' + rightclick); // true or false

// Coordenadas x, y relativas al documento
	var posx = 0;
	var posy = 0;
	if (!e) var e = window.event;
	if (e.pageX || e.pageY)
	{
		posx = e.pageX;
		posy = e.pageY;
	}
	else if (e.clientX || e.clientY)
	{
		posx = e.clientX + document.body.scrollLeft;
		posy = e.clientY + document.body.scrollTop;
	}
	// posx and posy contain the mouse position relative to the document
	// Do something with this information

/** **
Another show stopper is that when you move the mouse into the layer, and then onto a link, browsers register a mouseout event on the layer! It doesn't make much sense to me (the mouse is still in the layer), but all browsers agree on this one.

So how do we reject any mouseout that does not take place when the mouse actually leaves the layer?

function doSomething(e)
{
	if (!e) var e = window.event;
	var tg = (window.event) ? e.srcElement : e.target;
	if (tg.nodeName != 'DIV') return;
	var reltg = (e.relatedTarget) ? e.relatedTarget : e.toElement;
	while (reltg != tg && reltg.nodeName != 'BODY')
		reltg= reltg.parentNode
	if (reltg== tg) return;
	// Mouseout took place when mouse actually left layer
	// Handle event
}

First get the event target, ie. the element the mouse moved out of. If the target is not the DIV (layer), end the function immediately, since the mouse has certainly not left the layer.

If the target is the layer, we're still not sure if the mouse left the layer or entered a link within the layer. Therefore we're going to check the relatedTarget/toElement of the event, ie. the element the mouse moved to.

We read out this element, and then we're going to move upwards through the DOM tree until we either encounter the target of the event (ie. the DIV), or the body element.

If we encounter the target the mouse moves towards a child element of the layer, so the mouse has not actually left the layer. We stop the function.

When the function has survived all these checks we're certain that the mouse has actually left the layer and we can take appropriate action (usually making the layer invisible).


** **

				/** **/


function TabGroup(base) {
	var i = 0;
	var j = 0;
	var k = 0;

	if (!base || !base.id) return false;

	this.nombre = base.id;

	this.cssContentHidden = 'PIIFichaOculto';
	this.cssContent = 'PIIFicha';
	this.cssLegendShow = 'imprescindible';

	this.cssActive = 'activo';
	this.cssLink = 'cambio_ss';
	this.iActivo = -1;
	this.aActivoData = new Array();
	this.aTabs = new Array();

	this.triggerTab = TabGroup_triggerTabFromBar;
	this.ActiveTab = TabGroup_ActiveTab;

	numtabs = 0;
	for (i = 0; i < base.childNodes.length; i++) {
		if (base.childNodes[i].nodeName == 'DIV') {
			oNode = base.childNodes[i];
			if (oNode.getAttribute('name')) {

				capa = document.getElementById(oNode.getAttribute('name'));
				if (!capa) continue;

				// Registramos el evento onclick para la pestanya, asociado a este grupo.
				if (!oNode.addEventListener) oNode.attachEvent('onclick',this.triggerTab);
				else oNode.addEventListener('click',this.triggerTab,true);

				this.aTabs[numtabs] = oNode;

				// alert('Tenemos de elementos... ' + oNode.nodeName + ' nombre: ' + oNode.getAttribute('name') );

				// Ocultamos las capas con el contenido
				capa.className = this.cssContentHidden;
				// Las leyendas de los frameset contenidos, a partir de la primera, habran de estar visibles siempre:
				bShow = false;
				for (j = 0; j < capa.childNodes.length; j++) {
					if (capa.childNodes[j].nodeName == 'FIELDSET') {
						for (k=0; k<capa.childNodes[j].childNodes.length; k++) {
							if (capa.childNodes[j].childNodes[k].nodeName == 'LEGEND') {
								if (bShow) {
									capa.childNodes[j].childNodes[k].className = this.cssLegendShow;
								} else {
									bShow = true;
								}
							}
						}
					}
				}

				if (oNode.className == this.cssActive) {
					this.ActiveTab(oNode.getAttribute('name'));
				}
				numtabs++;

			}
		}
	}
	oCache.register(this.nombre,this);
}

function TabGroup_ActiveTab(newtab) {
	var i;

	// Desactivando pestanya anterior.. 
	if (this.iActivo >= 0) {
			
		// Le quitamos la clase al elemento
		this.aTabs[this.iActivo].className = null;

		oldtab = this.aTabs[this.iActivo].getAttribute('name');
		oldcapa = document.getElementById(oldtab);
		oldcapa.className=this.cssContentHidden;
		// alert('Ocultando ' + oldtab + ' con clase: ' + oldcapa.className);
	} 

	// Activando pestanya nueva
	for (i=0; i < this.aTabs.length; i++) {
		if (newtab == this.aTabs[i].getAttribute('name')) {

			// Cambiamos los estilos de la pestanya
			if (this.cssActive) this.aTabs[i].className = this.cssActive;
			this.iActivo = i;

			// Mostrando la capa correspondiente al contenido de la pestanya.
			capa = document.getElementById(newtab);
			// alert('Cambiando visibilidad e la capa: ' + capa.id);
			if (capa) {
				capa.className=this.cssContent;
				// alert('Mostrando ' + newtab + ' con clase: ' + capa.className );
			}
			break;
		}
	}

	return true;
}


function TabGroup_triggerTabFromBar(evento) {

	if (!evento) var evento = window.event;

	if (evento.target) {
		// Safari Fix
		if ( evento.target!='[object Text]' && evento.target!='[object DIV]') {
			target = evento.target;
			padre = target.parentNode;
		} else {
			// Safari Bug, solo se accede por this a tos los laos
			padre = this.parentNode;
		}
	} else if (evento.srcElement) {
		target = event.srcElement;
		padre = event.srcElement.parentElement;
	} 

	/** 
	if (target && target.nodeType == 3) { // Safari Bug
		target = target.parentNode;
		padre = target.parentNode;
	}
	/** **/

	if (!padre || !padre.id) {
		return false;
	}

	// Si la pestaña contiene un link, no activamos ninguna capa.
	for (i = 0; i < target.childNodes.length; i++) {
		if (target.childNodes[i].nodeName == 'A' && target.childNodes[i].className == this.cssLink) {
			return false;
		}
	}

	TabGroup = oCache.search(padre.id);
	if (!TabGroup) return false;

	if (target) newtabname = target.getAttribute('name');
	else newtabname = this.getAttribute('name');

	TabGroup.ActiveTab(newtabname);

	return false;
}

