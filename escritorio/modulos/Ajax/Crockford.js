
String.prototype.toInt = function() {
	retval = '';
	for (var i = 0; i < this.length; i++) {
		if (this.charCodeAt(i) >= 48 && this.charCodeAt(i) <= 57)
		retval += String.fromCharCode(this.charCodeAt(i))
	}
	return retval;
}

String.prototype.ltrim = function leftTrim(c) {
	var self = this;
	if (!isString(c)) c = ' ';
	while (self.substring(0,1) == c) { self = self.substring(1, self.length); }
	return self;
} 

String.prototype.rtrim = function righTrim(c) {
	var self = this;
	if (!isString(c)) c = ' ';
	while (self.substr((self.length-1),1) == c) { self = self.substring(0, (self.length-1)); }
	return self;
} 

document.getElementsByTagAndName = function findElements(oBase,tag,name) {
	oId = $(oBase);
	if (!tag && !name) return;
	if (!oId) oId = document.body;

	if (tag) { 
		var bName = false;
		aTmpList = document.getElementsByTagName(tag); 
	} else { 
		// Antes estaba este primero. Pero getElementsByName, aunque existe en IE para WinCE, devuelve una lista vacia :(
		// Asi que, siempre vamos a hacer la busqueda con getElementsByTagName.
		aTmpList = document.getElementsByName(name); 
		var bName = true;
	}

	var aRetVal = new Array();
	for (i=0; i<aTmpList.length; i++) {
		// Comprobamos que es el tag que buscamos
		if (bName) {
			if (tag && aTmpList[i].tagName.toUpperCase() != tag.toUpperCase()) { continue; }
		} else {
			if (name && aTmpList[i].getAttribute('name').toUpperCase() != name.toUpperCase()) { continue; }
		}
		// Comprobamos que sea descendiente de la base.
		for (element = aTmpList[i]; element.parentNode; element = element.parentNode) { if (element == oId) { aRetVal[aRetVal.length] = aTmpList[i]; } }
	}
	return aRetVal;
	// if (aRetVal.length == 1) return aRetVal.shift();
	// else return aRetVal;
}

Element.setValue = function set(el,value) {
	if (!isObject(el)) return false;
	var var1, var2, idx;
	if ((el.tagName).toLowerCase() == "input") { 
		el.value = value; 
	} else if ((el.tagName).toLowerCase() == 'select') {
		if (value.substring(0,1) == '0' && value.length>1) {
			var2 = value.ltrim('0');
			if (!var2.length) var2 = '0';
		} else var2 = value;
		if (value=='') {
			el.selectedIndex = null;
		} else {
			var actualValue = Form.Element.getValue(el);
			for (idx=el.options.length-1; idx>=0; idx--) {
				if (isFunction(el.options[idx])) { continue; }
				//Si los valores tienen un 0 delante, lo quitamos
				if (actualValue.substring(0,1) == '0' && actualValue.length>1) 
					var1 = el.options[idx].value.ltrim('0');
				else var1 = el.options[idx].value;
				if (var1 == var2) { 
					el.selectedIndex = idx; 
					break; 
				}
			}
		}
	}
}

var $F = function (el) {
	var id = $(el);
	if (id) return Form.Element.getValue(el);
	else {
		var oEl = document.getElementsByTagAndName(null,null,el);
		if (oEl) return Form.Element.getValue(oEl.shift());
		else return null;
	}
}

/** Los de Arriba ... propios ... los de Abajo, de Douglas **/

Object.prototype.method = function (name, func) {
    this.prototype[name] = func;
    return this;
};

Object.method('inherits', function (parent) {
    var d = 0, p = (this.prototype = new parent());
    this.method('uber', function uber(name) {
        var f, r, t = d, v = parent.prototype;
        if (t) {
            while (t) {
                v = v.constructor.prototype;
                t -= 1;
            }
            f = v[name];
        } else {
            f = p[name];
            if (f == this[name]) {
                f = v[name];
            }
        }
        d += 1;
        if (f) { r = f.apply(this, Array.prototype.slice.apply(arguments, [1])); }
	else { r = {}; }
        d -= 1;
        return r;
    });
    return this;
});

Object.method('swiss', function (parent) {
    for (var i = 1; i < arguments.length; i += 1) {
        var name = arguments[i];
        this.prototype[name] = parent.prototype[name];
    }
    return this;
});

/********** Resultados de las pruebas : *********
OJO: Tiene que descender de una funcion/clase no vale una instancia ya creada

alert("Vamos a por las pruebas ");

function CNBase() {
        this.variable = "La Base ";
        var varia = "CNBase";

        this.metodoBase = function () {
                return "Metodo Base " + this.variable;
        }
}

function CN1() {
        this.variable = "CN1";
        var varia = "CN1";

        this.metodoBase = function () {
                return "Sobrescrito Metodo Base en CN1 Pub: " + this.variable + " Priv: " + varia;
        }
}

CN1.inherits(CNBase);

myN1 = new CN1();
alert("Valor de la instancia de CN1: " + myN1.metodoBase());
// Valor de la instancia de CN1: Sobrescrito Metodo Base en CN1 Pub: CN1 Priv: CN1

function CN2() {
        this.variable = "CN2";
        var varia = "CN2";
}
CN2.inherits(CN1);
myN2 = new CN2();
alert("Valor de la instancia de CN2: " + myN2.metodoBase());
// Valor de la instancia de CN1: Sobrescrito Metodo Base en CN1 Pub: CN2 Priv: CN1

function CN3() {
        this.variable = "CN3";
        var varia = "CN3";
}
CN3.inherits(CN2);
myN3 = new CN3();
alert("Valor de la instancia de CN3: " + myN3.metodoBase());
// Valor de la instancia de CN1: Sobrescrito Metodo Base en CN1 Pub: CN3 Priv: CN1

/** **/

function isAlien(a) {
   return isObject(a) && typeof a.constructor != 'function';
}

function isArray(a) {
    return isObject(a) && a.constructor == Array;
}

function isBoolean(a) {
    return typeof a == 'boolean';
}

function isEmpty(o) {
    var i, v;
    if (isObject(o)) {
        for (i in o) {
            v = o[i];
            if (!isUndefined(v) && isFunction(v)) {
                return false;
            }
        }
    }
    return true;
}

function isFunction(a) {
    return typeof a == "function";
}

function isNull(a) {
    return typeof a == "object" && !a;
}

function isNumber(a) {
    return typeof a == "number" && isFinite(a);
}

function isObject(a) {
    return (a && typeof a == "object") || isFunction(a);
}

function isString(a) {
    return typeof a == "string";
}

function isUndefined(a) {
    return typeof a == "undefined";
}

String.
    method("entityify", function () {
        return this.replace(/&/g, "&amp;").replace(/</g,
            "&lt;").replace(/>/g, "&gt;");
    }).
    method("quote", function () {
        var c, i, l = this.length, o = '"';
        for (i = 0; i < l; i += 1) {
            c = this.charAt(i);
            if (c >= ' ') {
                if (c == '\\' || c == '"') {
                    o += '\\';
                }
                o += c;
            } else {
                switch (c) {
                case '\b':
                    o += '\\b';
                    break;
                case '\f':
                    o += '\\f';
                    break;
                case '\n':
                    o += '\\n';
                    break;
                case '\r':
                    o += '\\r';
                    break;
                case '\t':
                    o += '\\t';
                    break;
                default:
                    c = c.charCodeAt();
                    o += '\\u00' + Math.floor(c / 16).toString(16) +
                        (c % 16).toString(16);
                }
            }
        }
        return o + '"';
    }).
    method('supplant', function (o) {
        var i, j, s = this, v;
        for (;;) {
            i = s.lastIndexOf('{');
            if (i < 0) {
                break;
            }
            j = s.indexOf('}', i);
            if (i + 1 >= j) {
                break;
            }
            v = o[s.substring(i + 1, j)];
            if (!isString(v) && !isNumber(v)) {
                break;
            }
            s = s.substring(0, i) + v + s.substring(j + 1);
        }
        return s;
    }).
    method('trim', function () {
        return this.replace(/^\s*(\S*(\s+\S+)*)\s*$/, "$1");
    });

if (!isFunction(Function.apply)) {
    Function.method('apply', function (o, a) {
        var r, x = '____apply';
        if (!isObject(o)) {
            o = {};
        }
        o[x] = this;
        switch ((a && a.length) || 0) {
        case 0:
            r = o[x]();
            break;
        case 1:
            r = o[x](a[0]);
            break;
        case 2:
            r = o[x](a[0], a[1]);
            break;
        case 3:
            r = o[x](a[0], a[1], a[2]);
            break;
        case 4:
            r = o[x](a[0], a[1], a[2], a[3]);
            break;
        case 5:
            r = o[x](a[0], a[1], a[2], a[3], a[4]);
            break;
        case 6:
            r = o[x](a[0], a[1], a[2], a[3], a[4], a[5]);
            break;
        default:
            alert('Too many arguments to apply.');
        }
        delete o[x];
        return r;
    });
}

if (!isFunction(Array.prototype.pop)) {
    Array.method('pop', function () {
        return this.splice(this.length - 1, 1)[0];
    });
}

if (!isFunction(Array.prototype.push)) {
    Array.method('push', function () {
        this.splice.apply(this,
            [this.length, 0].concat(Array.prototype.slice.apply(arguments)));
        return this.length;
    });
}

if (!isFunction(Array.prototype.shift)) {
    Array.method('shift', function () {
        return this.splice(0, 1)[0];
    });
}

if (!isFunction(Array.prototype.splice)) {
    Array.method('splice', function (s, d) {
        var max = Math.max,
            min = Math.min,
            a = [], // The return value array
            e,  // element
            i = max(arguments.length - 2, 0),   // insert count
            k = 0,
            l = this.length,
            n,  // new length
            v,  // delta
            x;  // shift count

        s = s || 0;
        if (s < 0) {
            s += l;
        }
        s = max(min(s, l), 0);  // start point
        d = max(min(isNumber(d) ? d : l, l - s), 0);    // delete count
        v = i - d;
        n = l + v;
        while (k < d) {
            e = this[s + k];
            if (!isUndefined(e)) {
                a[k] = e;
            }
            k += 1;
        }
        x = l - s - d;
        if (v < 0) {
            k = s + i;
            while (x) {
                this[k] = this[k - v];
                k += 1;
                x -= 1;
            }
            this.length = n;
        } else if (v > 0) {
            k = 1;
            while (x) {
                this[n - k] = this[l - k];
                k += 1;
                x -= 1;
            }
        }
        for (k = 0; k < i; ++k) {
            this[s + k] = arguments[k + 2];
        }
        return a;
    });
}

if (!isFunction(Array.prototype.unshift)) {
    Array.method('unshift', function () {
        this.splice.apply(this,
            [0, 0].concat(Array.prototype.slice.apply(arguments)));
        return this.length;
    });
}

