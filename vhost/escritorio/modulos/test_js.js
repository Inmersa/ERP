/*  Prototype JavaScript framework, version 1.4.0
 *  (c) 2005 Sam Stephenson <sam@conio.net>
 *
 *  Prototype is freely distributable under the terms of an MIT-style license.
 *  For details, see the Prototype web site: http://prototype.conio.net/
 *
/*--------------------------------------------------------------------------*/

var Prototype = {
  Version: '1.4.0',
  ScriptFragment: '(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)',

  emptyFunction: function() {},
  K: function(x) {return x}
}

var Class = {
  create: function() {
    return function() {
      this.initialize.apply(this, arguments);
    }
  }
}

var Abstract = new Object();

Object.extend = function(destination, source) {
  for (property in source) {
    destination[property] = source[property];
  }
  return destination;
}

Object.inspect = function(object) {
  try {
    if (object == undefined) return 'undefined';
    if (object == null) return 'null';
    return object.inspect ? object.inspect() : object.toString();
  } catch (e) {
    if (e instanceof RangeError) return '...';
    throw e;
  }
}

Function.prototype.bind = function() {
  var __method = this, args = $A(arguments), object = args.shift();
  return function() {
    return __method.apply(object, args.concat($A(arguments)));
  }
}

Function.prototype.bindAsEventListener = function(object) {
  var __method = this;
  return function(event) {
    return __method.call(object, event || window.event);
  }
}

Object.extend(Number.prototype, {
  toColorPart: function() {
    var digits = this.toString(16);
    if (this < 16) return '0' + digits;
    return digits;
  },

  succ: function() {
    return this + 1;
  },

  times: function(iterator) {
    $R(0, this, true).each(iterator);
    return this;
  }
});

var Try = {
  these: function() {
    var returnValue;

    for (var i = 0; i < arguments.length; i++) {
      var lambda = arguments[i];
      try {
        returnValue = lambda();
        break;
      } catch (e) {
      	alert("Err: "+e);
      }
    }

    return returnValue;
  }
}

/*--------------------------------------------------------------------------*/

var PeriodicalExecuter = Class.create();
PeriodicalExecuter.prototype = {
  initialize: function(callback, frequency) {
    this.callback = callback;
    this.frequency = frequency;
    this.currentlyExecuting = false;

    this.registerCallback();
  },

  registerCallback: function() {
    setInterval(this.onTimerEvent.bind(this), this.frequency * 1000);
  },

  onTimerEvent: function() {
    if (!this.currentlyExecuting) {
      try {
        this.currentlyExecuting = true;
        this.callback();
      } finally {
        this.currentlyExecuting = false;
      }
    }
  }
}

/*--------------------------------------------------------------------------*/

function $() {
  var elements = new Array();

  for (var i = 0; i < arguments.length; i++) {
    var element = arguments[i];
    if (typeof element == 'string')
      element = document.getElementById(element);

    if (arguments.length == 1)
      return element;

    elements.push(element);
  }

  return elements;
}
Object.extend(String.prototype, {
  stripTags: function() {
    return this.replace(/<\/?[^>]+>/gi, '');
  },

  stripScripts: function() {
    return this.replace(new RegExp(Prototype.ScriptFragment, 'img'), '');
  },

  extractScripts: function() {
    var matchAll = new RegExp(Prototype.ScriptFragment, 'img');
    var matchOne = new RegExp(Prototype.ScriptFragment, 'im');
    return (this.match(matchAll) || []).map(function(scriptTag) {
      return (scriptTag.match(matchOne) || ['', ''])[1];
    });
  },

  evalScripts: function() {
    return this.extractScripts().map(eval);
  },

  escapeHTML: function() {
    var div = document.createElement('div');
    var text = document.createTextNode(this);
    div.appendChild(text);
    return div.innerHTML;
  },

  unescapeHTML: function() {
    var div = document.createElement('div');
    div.innerHTML = this.stripTags();
    return div.childNodes[0] ? div.childNodes[0].nodeValue : '';
  },

  toQueryParams: function() {
    var pairs = this.match(/^\??(.*)$/)[1].split('&');
    return pairs.inject({}, function(params, pairString) {
      var pair = pairString.split('=');
      params[pair[0]] = pair[1];
      return params;
    });
  },

  toArray: function() {
    return this.split('');
  },

  camelize: function() {
    var oStringList = this.split('-');
    if (oStringList.length == 1) return oStringList[0];

    var camelizedString = this.indexOf('-') == 0
      ? oStringList[0].charAt(0).toUpperCase() + oStringList[0].substring(1)
      : oStringList[0];

    for (var i = 1, len = oStringList.length; i < len; i++) {
      var s = oStringList[i];
      camelizedString += s.charAt(0).toUpperCase() + s.substring(1);
    }

    return camelizedString;
  },

  inspect: function() {
    return "'" + this.replace('\\', '\\\\').replace("'", '\\\'') + "'";
  }
});

String.prototype.parseQuery = String.prototype.toQueryParams;

var $break    = new Object();
var $continue = new Object();

var Enumerable = {
  each: function(iterator) {
    var index = 0;
    try {
      this._each(function(value) {
        try {
          iterator(value, index++);
        } catch (e) {
          if (e != $continue) throw e;
        }
      });
    } catch (e) {
      if (e != $break) throw e;
    }
  },

  all: function(iterator) {
    var result = true;
    this.each(function(value, index) {
      result = result && !!(iterator || Prototype.K)(value, index);
      if (!result) throw $break;
    });
    return result;
  },

  any: function(iterator) {
    var result = true;
    this.each(function(value, index) {
      if (result = !!(iterator || Prototype.K)(value, index))
        throw $break;
    });
    return result;
  },

  collect: function(iterator) {
    var results = [];
    this.each(function(value, index) {
      results.push(iterator(value, index));
    });
    return results;
  },

  detect: function (iterator) {
    var result;
    this.each(function(value, index) {
      if (iterator(value, index)) {
        result = value;
        throw $break;
      }
    });
    return result;
  },

  findAll: function(iterator) {
    var results = [];
    this.each(function(value, index) {
      if (iterator(value, index))
        results.push(value);
    });
    return results;
  },

  grep: function(pattern, iterator) {
    var results = [];
    this.each(function(value, index) {
      var stringValue = value.toString();
      if (stringValue.match(pattern))
        results.push((iterator || Prototype.K)(value, index));
    })
    return results;
  },

  include: function(object) {
    var found = false;
    this.each(function(value) {
      if (value == object) {
        found = true;
        throw $break;
      }
    });
    return found;
  },

  inject: function(memo, iterator) {
    this.each(function(value, index) {
      memo = iterator(memo, value, index);
    });
    return memo;
  },

  invoke: function(method) {
    var args = $A(arguments).slice(1);
    return this.collect(function(value) {
      return value[method].apply(value, args);
    });
  },

  max: function(iterator) {
    var result;
    this.each(function(value, index) {
      value = (iterator || Prototype.K)(value, index);
      if (value >= (result || value))
        result = value;
    });
    return result;
  },

  min: function(iterator) {
    var result;
    this.each(function(value, index) {
      value = (iterator || Prototype.K)(value, index);
      if (value <= (result || value))
        result = value;
    });
    return result;
  },

  partition: function(iterator) {
    var trues = [], falses = [];
    this.each(function(value, index) {
      ((iterator || Prototype.K)(value, index) ?
        trues : falses).push(value);
    });
    return [trues, falses];
  },

  pluck: function(property) {
    var results = [];
    this.each(function(value, index) {
      results.push(value[property]);
    });
    return results;
  },

  reject: function(iterator) {
    var results = [];
    this.each(function(value, index) {
      if (!iterator(value, index))
        results.push(value);
    });
    return results;
  },

  sortBy: function(iterator) {
    return this.collect(function(value, index) {
      return {value: value, criteria: iterator(value, index)};
    }).sort(function(left, right) {
      var a = left.criteria, b = right.criteria;
      return a < b ? -1 : a > b ? 1 : 0;
    }).pluck('value');
  },

  toArray: function() {
    return this.collect(Prototype.K);
  },

  zip: function() {
    var iterator = Prototype.K, args = $A(arguments);
    if (typeof args.last() == 'function')
      iterator = args.pop();

    var collections = [this].concat(args).map($A);
    return this.map(function(value, index) {
      iterator(value = collections.pluck(index));
      return value;
    });
  },

  inspect: function() {
    return '#<Enumerable:' + this.toArray().inspect() + '>';
  }
}

Object.extend(Enumerable, {
  map:     Enumerable.collect,
  find:    Enumerable.detect,
  select:  Enumerable.findAll,
  member:  Enumerable.include,
  entries: Enumerable.toArray
});
var $A = Array.from = function(iterable) {
  if (!iterable) return [];
  if (iterable.toArray) {
    return iterable.toArray();
  } else {
    var results = [];
    for (var i = 0; i < iterable.length; i++)
      results.push(iterable[i]);
    return results;
  }
}

Object.extend(Array.prototype, Enumerable);

Array.prototype._reverse = Array.prototype.reverse;

Object.extend(Array.prototype, {
  _each: function(iterator) {
    for (var i = 0; i < this.length; i++)
      iterator(this[i]);
  },

  clear: function() {
    this.length = 0;
    return this;
  },

  first: function() {
    return this[0];
  },

  last: function() {
    return this[this.length - 1];
  },

  compact: function() {
    return this.select(function(value) {
      return value != undefined || value != null;
    });
  },

  flatten: function() {
    return this.inject([], function(array, value) {
      return array.concat(value.constructor == Array ?
        value.flatten() : [value]);
    });
  },

  without: function() {
    var values = $A(arguments);
    return this.select(function(value) {
      return !values.include(value);
    });
  },

  indexOf: function(object) {
    for (var i = 0; i < this.length; i++)
      if (this[i] == object) return i;
    return -1;
  },

  reverse: function(inline) {
    return (inline !== false ? this : this.toArray())._reverse();
  },

  shift: function() {
    var result = this[0];
    for (var i = 0; i < this.length - 1; i++)
      this[i] = this[i + 1];
    if (!isArray(this) || this.length==0) return result;
    if (this.length==1) this.length = 0;
    else this.length--;
    return result;
  },

  inspect: function() {
    return '[' + this.map(Object.inspect).join(', ') + ']';
  }
});
var Hash = {
  _each: function(iterator) {
    for (key in this) {
      var value = this[key];
      if (typeof value == 'function') continue;

      var pair = [key, value];
      pair.key = key;
      pair.value = value;
      iterator(pair);
    }
  },

  keys: function() {
    return this.pluck('key');
  },

  values: function() {
    return this.pluck('value');
  },

  merge: function(hash) {
    return $H(hash).inject($H(this), function(mergedHash, pair) {
      mergedHash[pair.key] = pair.value;
      return mergedHash;
    });
  },

  toQueryString: function() {
    return this.map(function(pair) {
      return pair.map(encodeURIComponent).join('=');
    }).join('&');
  },

  inspect: function() {
    return '#<Hash:{' + this.map(function(pair) {
      return pair.map(Object.inspect).join(': ');
    }).join(', ') + '}>';
  }
}

function $H(object) {
  var hash = Object.extend({}, object || {});
  Object.extend(hash, Enumerable);
  Object.extend(hash, Hash);
  return hash;
}
ObjectRange = Class.create();
Object.extend(ObjectRange.prototype, Enumerable);
Object.extend(ObjectRange.prototype, {
  initialize: function(start, end, exclusive) {
    this.start = start;
    this.end = end;
    this.exclusive = exclusive;
  },

  _each: function(iterator) {
    var value = this.start;
    do {
      iterator(value);
      value = value.succ();
    } while (this.include(value));
  },

  include: function(value) {
    if (value < this.start)
      return false;
    if (this.exclusive)
      return value < this.end;
    return value <= this.end;
  }
});

var $R = function(start, end, exclusive) {
  return new ObjectRange(start, end, exclusive);
}

var Ajax = {
  getTransport: function() {
    return Try.these(
      function() {return new ActiveXObject('Msxml2.XMLHTTP')},
      function() {return new ActiveXObject('Microsoft.XMLHTTP')},
      function() {return new XMLHttpRequest()}
    ) || false;
  },

  activeRequestCount: 0
}

Ajax.Responders = {
  responders: [],

  _each: function(iterator) {
    this.responders._each(iterator);
  },

  register: function(responderToAdd) {
    if (!this.include(responderToAdd))
      this.responders.push(responderToAdd);
  },

  unregister: function(responderToRemove) {
    this.responders = this.responders.without(responderToRemove);
  },

  dispatch: function(callback, request, transport, json) {
    this.each(function(responder) {
      if (responder[callback] && typeof responder[callback] == 'function') {
        try {
          responder[callback].apply(responder, [request, transport, json]);
        } catch (e) {}
      }
    });
  }
};

Object.extend(Ajax.Responders, Enumerable);

Ajax.Responders.register({
  onCreate: function() {
    Ajax.activeRequestCount++;
  },

  onComplete: function() {
    Ajax.activeRequestCount--;
  }
});

Ajax.Base = function() {};
Ajax.Base.prototype = {
  setOptions: function(options) {
    this.options = {
      method:       'post',
      asynchronous: true,
      parameters:   ''
    }
    Object.extend(this.options, options || {});
  },

  responseIsSuccess: function() {
    return this.transport.status == undefined
        || this.transport.status == 0
        || (this.transport.status >= 200 && this.transport.status < 300);
  },

  responseIsFailure: function() {
    return !this.responseIsSuccess();
  }
}

Ajax.Request = Class.create();
Ajax.Request.Events =
  ['Uninitialized', 'Loading', 'Loaded', 'Interactive', 'Complete'];

Ajax.Request.prototype = Object.extend(new Ajax.Base(), {
  initialize: function(url, options) {
    this.transport = Ajax.getTransport();
    this.setOptions(options);
    this.request(url);
  },

  request: function(url) {
    var parameters = this.options.parameters || '';
    if (parameters.length > 0) parameters += '&_=';

    try {
      this.url = url;
      if (this.options.method == 'get' && parameters.length > 0)
        this.url += (this.url.match(/\?/) ? '&' : '?') + parameters;

      Ajax.Responders.dispatch('onCreate', this, this.transport);

      this.transport.open(this.options.method, this.url,
        this.options.asynchronous);

      if (this.options.asynchronous) {
        this.transport.onreadystatechange = this.onStateChange.bind(this);
        setTimeout((function() {this.respondToReadyState(1)}).bind(this), 10);
      }

      this.setRequestHeaders();

      var body = this.options.postBody ? this.options.postBody : parameters;
      this.transport.send(this.options.method == 'post' ? body : null);

    } catch (e) {
      this.dispatchException(e);
    }
  },

  setRequestHeaders: function() {
    var requestHeaders =
      ['X-Requested-With', 'XMLHttpRequest',
       'X-Prototype-Version', Prototype.Version];

    if (this.options.method == 'post') {
      requestHeaders.push('Content-type',
        'application/x-www-form-urlencoded');

      /* Force "Connection: close" for Mozilla browsers to work around
       * a bug where XMLHttpReqeuest sends an incorrect Content-length
       * header. See Mozilla Bugzilla #246651.
       */
      if (this.transport.overrideMimeType)
        requestHeaders.push('Connection', 'close');
    }

    if (this.options.requestHeaders)
      requestHeaders.push.apply(requestHeaders, this.options.requestHeaders);

    for (var i = 0; i < requestHeaders.length; i += 2)
      this.transport.setRequestHeader(requestHeaders[i], requestHeaders[i+1]);
  },

  onStateChange: function() {
    var readyState = this.transport.readyState;
    if (readyState != 1)
      this.respondToReadyState(this.transport.readyState);
  },

  header: function(name) {
    try {
      return this.transport.getResponseHeader(name);
    } catch (e) {}
  },

  evalJSON: function() {
    try {
      return eval(this.header('X-JSON'));
    } catch (e) {}
  },

  evalResponse: function() {
    try {
      return eval(this.transport.responseText);
    } catch (e) {
      this.dispatchException(e);
    }
  },

  respondToReadyState: function(readyState) {
    var event = Ajax.Request.Events[readyState];
    var transport = this.transport, json = this.evalJSON();

    if (event == 'Complete') {
      try {
        (this.options['on' + this.transport.status]
         || this.options['on' + (this.responseIsSuccess() ? 'Success' : 'Failure')]
         || Prototype.emptyFunction)(transport, json);
      } catch (e) {
        this.dispatchException(e);
      }

      if ((this.header('Content-type') || '').match(/^text\/javascript/i))
        this.evalResponse();
    }

    try {
      (this.options['on' + event] || Prototype.emptyFunction)(transport, json);
      Ajax.Responders.dispatch('on' + event, this, transport, json);
    } catch (e) {
      this.dispatchException(e);
    }

    /* Avoid memory leak in MSIE: clean up the oncomplete event handler */
    if (event == 'Complete')
      this.transport.onreadystatechange = Prototype.emptyFunction;
  },

  dispatchException: function(exception) {
    (this.options.onException || Prototype.emptyFunction)(this, exception);
    Ajax.Responders.dispatch('onException', this, exception);
  }
});

Ajax.Updater = Class.create();

Object.extend(Object.extend(Ajax.Updater.prototype, Ajax.Request.prototype), {
  initialize: function(container, url, options) {
    this.containers = {
      success: container.success ? $(container.success) : $(container),
      failure: container.failure ? $(container.failure) :
        (container.success ? null : $(container))
    }

    this.transport = Ajax.getTransport();
    this.setOptions(options);

    var onComplete = this.options.onComplete || Prototype.emptyFunction;
    this.options.onComplete = (function(transport, object) {
      this.updateContent();
      onComplete(transport, object);
    }).bind(this);

    this.request(url);
  },

  updateContent: function() {
    var receiver = this.responseIsSuccess() ?
      this.containers.success : this.containers.failure;
    var response = this.transport.responseText;

    if (!this.options.evalScripts)
      response = response.stripScripts();

    if (receiver) {
      if (this.options.insertion) {
        new this.options.insertion(receiver, response);
      } else {
        Element.update(receiver, response);
      }
    }

    if (this.responseIsSuccess()) {
      if (this.onComplete)
        setTimeout(this.onComplete.bind(this), 10);
    }
  }
});

Ajax.PeriodicalUpdater = Class.create();
Ajax.PeriodicalUpdater.prototype = Object.extend(new Ajax.Base(), {
  initialize: function(container, url, options) {
    this.setOptions(options);
    this.onComplete = this.options.onComplete;

    this.frequency = (this.options.frequency || 2);
    this.decay = (this.options.decay || 1);

    this.updater = {};
    this.container = container;
    this.url = url;

    this.start();
  },

  start: function() {
    this.options.onComplete = this.updateComplete.bind(this);
    this.onTimerEvent();
  },

  stop: function() {
    this.updater.onComplete = undefined;
    clearTimeout(this.timer);
    (this.onComplete || Prototype.emptyFunction).apply(this, arguments);
  },

  updateComplete: function(request) {
    if (this.options.decay) {
      this.decay = (request.responseText == this.lastText ?
        this.decay * this.options.decay : 1);

      this.lastText = request.responseText;
    }
    this.timer = setTimeout(this.onTimerEvent.bind(this),
      this.decay * this.frequency * 1000);
  },

  onTimerEvent: function() {
    this.updater = new Ajax.Updater(this.container, this.url, this.options);
  }
});
document.getElementsByClassName = function(className, parentElement) {
  var children = ($(parentElement) || document.body).getElementsByTagName('*');
  return $A(children).inject([], function(elements, child) {
    if (child.className.match(new RegExp("(^|\\s)" + className + "(\\s|$)")))
      elements.push(child);
    return elements;
  });
}

/*--------------------------------------------------------------------------*/

if (!window.Element) {
  var Element = new Object();
}

Object.extend(Element, {
  visible: function(element) {
    return $(element).style.display != 'none';
  },

  toggle: function() {
    for (var i = 0; i < arguments.length; i++) {
      var element = $(arguments[i]);
      Element[Element.visible(element) ? 'hide' : 'show'](element);
    }
  },

  hide: function() {
    for (var i = 0; i < arguments.length; i++) {
      var element = $(arguments[i]);
      element.style.display = 'none';
    }
  },

  show: function() {
    for (var i = 0; i < arguments.length; i++) {
      var element = $(arguments[i]);
      element.style.display = '';
    }
  },

  remove: function(element) {
    element = $(element);
    element.parentNode.removeChild(element);
  },

  update: function(element, html) {
    $(element).innerHTML = html.stripScripts();
    setTimeout(function() {html.evalScripts()}, 10);
  },

  getHeight: function(element) {
    element = $(element);
    return element.offsetHeight;
  },

  classNames: function(element) {
    return new Element.ClassNames(element);
  },

  hasClassName: function(element, className) {
    if (!(element = $(element))) return;
    return Element.classNames(element).include(className);
  },

  addClassName: function(element, className) {
    if (!(element = $(element))) return;
    return Element.classNames(element).add(className);
  },

  removeClassName: function(element, className) {
    if (!(element = $(element))) return;
    return Element.classNames(element).remove(className);
  },

  // removes whitespace-only text node children
  cleanWhitespace: function(element) {
    element = $(element);
    for (var i = 0; i < element.childNodes.length; i++) {
      var node = element.childNodes[i];
      if (node.nodeType == 3 && !/\S/.test(node.nodeValue))
        Element.remove(node);
    }
  },

  empty: function(element) {
    return $(element).innerHTML.match(/^\s*$/);
  },

  scrollTo: function(element) {
    element = $(element);
    var x = element.x ? element.x : element.offsetLeft,
        y = element.y ? element.y : element.offsetTop;
    window.scrollTo(x, y);
  },

  getStyle: function(element, style) {
    element = $(element);
    var value = element.style[style.camelize()];
    if (!value) {
      if (document.defaultView && document.defaultView.getComputedStyle) {
        var css = document.defaultView.getComputedStyle(element, null);
        value = css ? css.getPropertyValue(style) : null;
      } else if (element.currentStyle) {
        value = element.currentStyle[style.camelize()];
      }
    }

    if (window.opera && ['left', 'top', 'right', 'bottom'].include(style))
      if (Element.getStyle(element, 'position') == 'static') value = 'auto';

    return value == 'auto' ? null : value;
  },

  setStyle: function(element, style) {
    element = $(element);
    for (name in style)
      element.style[name.camelize()] = style[name];
  },

  getDimensions: function(element) {
    element = $(element);
    if (Element.getStyle(element, 'display') != 'none')
      return {width: element.offsetWidth, height: element.offsetHeight};

    // All *Width and *Height properties give 0 on elements with display none,
    // so enable the element temporarily
    var els = element.style;
    var originalVisibility = els.visibility;
    var originalPosition = els.position;
    els.visibility = 'hidden';
    els.position = 'absolute';
    els.display = '';
    var originalWidth = element.clientWidth;
    var originalHeight = element.clientHeight;
    els.display = 'none';
    els.position = originalPosition;
    els.visibility = originalVisibility;
    return {width: originalWidth, height: originalHeight};
  },

  makePositioned: function(element) {
    element = $(element);
    var pos = Element.getStyle(element, 'position');
    if (pos == 'static' || !pos) {
      element._madePositioned = true;
      element.style.position = 'relative';
      // Opera returns the offset relative to the positioning context, when an
      // element is position relative but top and left have not been defined
      if (window.opera) {
        element.style.top = 0;
        element.style.left = 0;
      }
    }
  },

  undoPositioned: function(element) {
    element = $(element);
    if (element._madePositioned) {
      element._madePositioned = undefined;
      element.style.position =
        element.style.top =
        element.style.left =
        element.style.bottom =
        element.style.right = '';
    }
  },

  makeClipping: function(element) {
    element = $(element);
    if (element._overflow) return;
    element._overflow = element.style.overflow;
    if ((Element.getStyle(element, 'overflow') || 'visible') != 'hidden')
      element.style.overflow = 'hidden';
  },

  undoClipping: function(element) {
    element = $(element);
    if (element._overflow) return;
    element.style.overflow = element._overflow;
    element._overflow = undefined;
  }
});

var Toggle = new Object();
Toggle.display = Element.toggle;

/*--------------------------------------------------------------------------*/

Abstract.Insertion = function(adjacency) {
  this.adjacency = adjacency;
}

Abstract.Insertion.prototype = {
  initialize: function(element, content) {
    this.element = $(element);
    this.content = content.stripScripts();

    if (this.adjacency && this.element.insertAdjacentHTML) {
      try {
        this.element.insertAdjacentHTML(this.adjacency, this.content);
      } catch (e) {
        if (this.element.tagName.toLowerCase() == 'tbody') {
          this.insertContent(this.contentFromAnonymousTable());
        } else {
          throw e;
        }
      }
    } else {
      this.range = this.element.ownerDocument.createRange();
      if (this.initializeRange) this.initializeRange();
      this.insertContent([this.range.createContextualFragment(this.content)]);
    }

    setTimeout(function() {content.evalScripts()}, 10);
  },

  contentFromAnonymousTable: function() {
    var div = document.createElement('div');
    div.innerHTML = '<table><tbody>' + this.content + '</tbody></table>';
    return $A(div.childNodes[0].childNodes[0].childNodes);
  }
}

var Insertion = new Object();

Insertion.Before = Class.create();
Insertion.Before.prototype = Object.extend(new Abstract.Insertion('beforeBegin'), {
  initializeRange: function() {
    this.range.setStartBefore(this.element);
  },

  insertContent: function(fragments) {
    fragments.each((function(fragment) {
      this.element.parentNode.insertBefore(fragment, this.element);
    }).bind(this));
  }
});

Insertion.Top = Class.create();
Insertion.Top.prototype = Object.extend(new Abstract.Insertion('afterBegin'), {
  initializeRange: function() {
    this.range.selectNodeContents(this.element);
    this.range.collapse(true);
  },

  insertContent: function(fragments) {
    fragments.reverse(false).each((function(fragment) {
      this.element.insertBefore(fragment, this.element.firstChild);
    }).bind(this));
  }
});

Insertion.Bottom = Class.create();
Insertion.Bottom.prototype = Object.extend(new Abstract.Insertion('beforeEnd'), {
  initializeRange: function() {
    this.range.selectNodeContents(this.element);
    this.range.collapse(this.element);
  },

  insertContent: function(fragments) {
    fragments.each((function(fragment) {
      this.element.appendChild(fragment);
    }).bind(this));
  }
});

Insertion.After = Class.create();
Insertion.After.prototype = Object.extend(new Abstract.Insertion('afterEnd'), {
  initializeRange: function() {
    this.range.setStartAfter(this.element);
  },

  insertContent: function(fragments) {
    fragments.each((function(fragment) {
      this.element.parentNode.insertBefore(fragment,
        this.element.nextSibling);
    }).bind(this));
  }
});

/*--------------------------------------------------------------------------*/

Element.ClassNames = Class.create();
Element.ClassNames.prototype = {
  initialize: function(element) {
    this.element = $(element);
  },

  _each: function(iterator) {
    this.element.className.split(/\s+/).select(function(name) {
      return name.length > 0;
    })._each(iterator);
  },

  set: function(className) {
    this.element.className = className;
  },

  add: function(classNameToAdd) {
    if (this.include(classNameToAdd)) return;
    this.set(this.toArray().concat(classNameToAdd).join(' '));
  },

  remove: function(classNameToRemove) {
    if (!this.include(classNameToRemove)) return;
    this.set(this.select(function(className) {
      return className != classNameToRemove;
    }).join(' '));
  },

  toString: function() {
    return this.toArray().join(' ');
  }
}

Object.extend(Element.ClassNames.prototype, Enumerable);
var Field = {
  clear: function() {
    for (var i = 0; i < arguments.length; i++)
      $(arguments[i]).value = '';
  },

  focus: function(element) {
    $(element).focus();
  },

  present: function() {
    for (var i = 0; i < arguments.length; i++)
      if ($(arguments[i]).value == '') return false;
    return true;
  },

  select: function(element) {
    $(element).select();
  },

  activate: function(element) {
    element = $(element);
    element.focus();
    if (element.select)
      element.select();
  }
}

/*--------------------------------------------------------------------------*/

var Form = {
  serialize: function(form) {
    var elements = Form.getElements($(form));
    var queryComponents = new Array();

    for (var i = 0; i < elements.length; i++) {
      var queryComponent = Form.Element.serialize(elements[i]);
      if (queryComponent)
        queryComponents.push(queryComponent);
    }

    return queryComponents.join('&');
  },

  getElements: function(form) {
    form = $(form);
    var elements = new Array();

    // alert('Form.getElements con formID: ' + form.id + ' y nombre: ' + form.getAttribute('name') + ' el(paempezar): ' + elements.length);
    for (tagName in Form.Element.Serializers) {
      var tagElements = form.getElementsByTagName(tagName);
      for (var j = 0; j < tagElements.length; j++) {
        // elements.push(tagElements[j]);
        elements[elements.length] = tagElements[j];
	// alert('Form.getElements->tagElement('+tagName+' ID: ' + tagElements[j].id + ' y nombre: ' + tagElements[j].getAttribute('name') + ' el(now): ' + elements.length);
      }
    }
    return elements;
  },

  getInputs: function(form, typeName, name) {
    form = $(form);
    var inputs = form.getElementsByTagName('input');

    if (!typeName && !name)
      return inputs;

    var matchingInputs = new Array();
    for (var i = 0; i < inputs.length; i++) {
      var input = inputs[i];
      if ((typeName && input.type != typeName) ||
          (name && input.name != name))
        continue;
      matchingInputs.push(input);
    }

    return matchingInputs;
  },

  disable: function(form) {
    var elements = Form.getElements(form);
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i];
      element.blur();
      element.disabled = 'true';
    }
  },

  enable: function(form) {
    var elements = Form.getElements(form);
    for (var i = 0; i < elements.length; i++) {
      var element = elements[i];
      element.disabled = '';
    }
  },

  findFirstElement: function(form) {
    return Form.getElements(form).find(function(element) {
      return element.type != 'hidden' && !element.disabled &&
        ['input', 'select', 'textarea'].include(element.tagName.toLowerCase());
    });
  },

  focusFirstElement: function(form) {
    Field.activate(Form.findFirstElement(form));
  },

  reset: function(form) {
    $(form).reset();
  }
}

Form.Element = {
  serialize: function(element) {
    element = $(element);
    var method = element.tagName.toLowerCase();
    var parameter = Form.Element.Serializers[method](element);

    if (parameter) {
      var key = encodeURIComponent(parameter[0]);
      if (key.length == 0) return;

      if (parameter[1].constructor != Array)
        parameter[1] = [parameter[1]];

      return parameter[1].map(function(value) {
        return key + '=' + encodeURIComponent(value);
      }).join('&');
    }
  },

  getValue: function(element) {
    element = $(element);
    if (!element) { return; }
    var method = element.tagName.toLowerCase();
    var parameter = Form.Element.Serializers[method](element);

    if (parameter)
      return parameter[1];
  }
}

Form.Element.Serializers = {
  input: function(element) {
    switch (element.type.toLowerCase()) {
      case 'submit':
      case 'hidden':
      case 'password':
      case 'text':
        return Form.Element.Serializers.textarea(element);
      case 'checkbox':
      case 'radio':
        return Form.Element.Serializers.inputSelector(element);
    }
    return false;
  },

  inputSelector: function(element) {
    if (element.checked)
      return [element.name, element.value];
  },

  textarea: function(element) {
    return [element.name, element.value];
  },

  select: function(element) {
    return Form.Element.Serializers[element.type == 'select-one' ?
      'selectOne' : 'selectMany'](element);
  },

  selectOne: function(element) {
    var value = '', opt, index = element.selectedIndex;
    if (index >= 0) {
      opt = element.options[index];
      value = opt.value;
      if (!value && !('value' in opt))
        value = opt.text;
    }
    return [element.name, value];
  },

  selectMany: function(element) {
    var value = new Array();
    for (var i = 0; i < element.length; i++) {
      var opt = element.options[i];
      if (opt.selected) {
        var optValue = opt.value;
        if (!optValue && !('value' in opt))
          optValue = opt.text;
        value.push(optValue);
      }
    }
    return [element.name, value];
  }
}

/*--------------------------------------------------------------------------*/

var $F = Form.Element.getValue;

/*--------------------------------------------------------------------------*/

Abstract.TimedObserver = function() {}
Abstract.TimedObserver.prototype = {
  initialize: function(element, frequency, callback) {
    this.frequency = frequency;
    this.element   = $(element);
    this.callback  = callback;

    this.lastValue = this.getValue();
    this.registerCallback();
  },

  registerCallback: function() {
    setInterval(this.onTimerEvent.bind(this), this.frequency * 1000);
  },

  onTimerEvent: function() {
    var value = this.getValue();
    if (this.lastValue != value) {
      this.callback(this.element, value);
      this.lastValue = value;
    }
  }
}

Form.Element.Observer = Class.create();
Form.Element.Observer.prototype = Object.extend(new Abstract.TimedObserver(), {
  getValue: function() {
    return Form.Element.getValue(this.element);
  }
});

Form.Observer = Class.create();
Form.Observer.prototype = Object.extend(new Abstract.TimedObserver(), {
  getValue: function() {
    return Form.serialize(this.element);
  }
});

/*--------------------------------------------------------------------------*/

Abstract.EventObserver = function() {}
Abstract.EventObserver.prototype = {
  initialize: function(element, callback) {
    this.element  = $(element);
    this.callback = callback;

    this.lastValue = this.getValue();
    if (this.element.tagName.toLowerCase() == 'form')
      this.registerFormCallbacks();
    else
      this.registerCallback(this.element);
  },

  onElementEvent: function() {
    var value = this.getValue();
    if (this.lastValue != value) {
      this.callback(this.element, value);
      this.lastValue = value;
    }
  },

  registerFormCallbacks: function() {
    var elements = Form.getElements(this.element);
    for (var i = 0; i < elements.length; i++)
      this.registerCallback(elements[i]);
  },

  registerCallback: function(element) {
    if (element.type) {
      switch (element.type.toLowerCase()) {
        case 'checkbox':
        case 'radio':
          Event.observe(element, 'click', this.onElementEvent.bind(this));
          break;
        case 'password':
        case 'text':
        case 'textarea':
        case 'select-one':
        case 'select-multiple':
          Event.observe(element, 'change', this.onElementEvent.bind(this));
          break;
      }
    }
  }
}

Form.Element.EventObserver = Class.create();
Form.Element.EventObserver.prototype = Object.extend(new Abstract.EventObserver(), {
  getValue: function() {
    return Form.Element.getValue(this.element);
  }
});

Form.EventObserver = Class.create();
Form.EventObserver.prototype = Object.extend(new Abstract.EventObserver(), {
  getValue: function() {
    return Form.serialize(this.element);
  }
});
if (!window.Event) {
  var Event = new Object();
}

Object.extend(Event, {
  KEY_BACKSPACE: 8,
  KEY_TAB:       9,
  KEY_RETURN:   13,
  KEY_ESC:      27,
  KEY_LEFT:     37,
  KEY_UP:       38,
  KEY_RIGHT:    39,
  KEY_DOWN:     40,
  KEY_DELETE:   46,

  element: function(event) {
    return event.target || event.srcElement;
  },

  isLeftClick: function(event) {
    return (((event.which) && (event.which == 1)) ||
            ((event.button) && (event.button == 1)));
  },

  pointerX: function(event) {
    return event.pageX || (event.clientX +
      (document.documentElement.scrollLeft || document.body.scrollLeft));
  },

  pointerY: function(event) {
    return event.pageY || (event.clientY +
      (document.documentElement.scrollTop || document.body.scrollTop));
  },

  stop: function(event) {
    if (event.preventDefault) {
      event.preventDefault();
      event.stopPropagation();
    } else {
      event.returnValue = false;
      event.cancelBubble = true;
    }
  },

  // find the first node with the given tagName, starting from the
  // node the event was triggered on; traverses the DOM upwards
  findElement: function(event, tagName) {
    var element = Event.element(event);
    while (element.parentNode && (!element.tagName ||
        (element.tagName.toUpperCase() != tagName.toUpperCase())))
      element = element.parentNode;
    return element;
  },

  observers: false,

  _observeAndCache: function(element, name, observer, useCapture) {
    if (!this.observers) this.observers = [];
    if (element.addEventListener) {
      this.observers.push([element, name, observer, useCapture]);
      element.addEventListener(name, observer, useCapture);
    } else if (element.attachEvent) {
      this.observers.push([element, name, observer, useCapture]);
      element.attachEvent('on' + name, observer);
    }
  },

  unloadCache: function() {
    if (!Event.observers) return;
    for (var i = 0; i < Event.observers.length; i++) {
      Event.stopObserving.apply(this, Event.observers[i]);
      Event.observers[i][0] = null;
    }
    Event.observers = false;
  },

  observe: function(element, name, observer, useCapture) {
    var element = $(element);
    useCapture = useCapture || false;

    if (name == 'keypress' &&
        (navigator.appVersion.match(/Konqueror|Safari|KHTML/)
        || element.attachEvent))
      name = 'keydown';

    this._observeAndCache(element, name, observer, useCapture);
  },

  stopObserving: function(element, name, observer, useCapture) {
    var element = $(element);
    useCapture = useCapture || false;

    if (name == 'keypress' &&
        (navigator.appVersion.match(/Konqueror|Safari|KHTML/)
        || element.detachEvent))
      name = 'keydown';

    if (element.removeEventListener) {
      element.removeEventListener(name, observer, useCapture);
    } else if (element.detachEvent) {
      element.detachEvent('on' + name, observer);
    }
  }
});

/* prevent memory leaks in IE */
Event.observe(window, 'unload', Event.unloadCache, false);
var Position = {
  // set to true if needed, warning: firefox performance problems
  // NOT neeeded for page scrolling, only if draggable contained in
  // scrollable elements
  includeScrollOffsets: false,

  // must be called before calling withinIncludingScrolloffset, every time the
  // page is scrolled
  prepare: function() {
    this.deltaX =  window.pageXOffset
                || document.documentElement.scrollLeft
                || document.body.scrollLeft
                || 0;
    this.deltaY =  window.pageYOffset
                || document.documentElement.scrollTop
                || document.body.scrollTop
                || 0;
  },

  realOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.scrollTop  || 0;
      valueL += element.scrollLeft || 0;
      element = element.parentNode;
    } while (element);
    return [valueL, valueT];
  },

  cumulativeOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      element = element.offsetParent;
    } while (element);
    return [valueL, valueT];
  },

  positionedOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      element = element.offsetParent;
      if (element) {
        p = Element.getStyle(element, 'position');
        if (p == 'relative' || p == 'absolute') break;
      }
    } while (element);
    return [valueL, valueT];
  },

  offsetParent: function(element) {
    if (element.offsetParent) return element.offsetParent;
    if (element == document.body) return element;

    while ((element = element.parentNode) && element != document.body)
      if (Element.getStyle(element, 'position') != 'static')
        return element;

    return document.body;
  },

  // caches x/y coordinate pair to use with overlap
  within: function(element, x, y) {
    if (this.includeScrollOffsets)
      return this.withinIncludingScrolloffsets(element, x, y);
    this.xcomp = x;
    this.ycomp = y;
    this.offset = this.cumulativeOffset(element);

    return (y >= this.offset[1] &&
            y <  this.offset[1] + element.offsetHeight &&
            x >= this.offset[0] &&
            x <  this.offset[0] + element.offsetWidth);
  },

  withinIncludingScrolloffsets: function(element, x, y) {
    var offsetcache = this.realOffset(element);

    this.xcomp = x + offsetcache[0] - this.deltaX;
    this.ycomp = y + offsetcache[1] - this.deltaY;
    this.offset = this.cumulativeOffset(element);

    return (this.ycomp >= this.offset[1] &&
            this.ycomp <  this.offset[1] + element.offsetHeight &&
            this.xcomp >= this.offset[0] &&
            this.xcomp <  this.offset[0] + element.offsetWidth);
  },

  // within must be called directly before
  overlap: function(mode, element) {
    if (!mode) return 0;
    if (mode == 'vertical')
      return ((this.offset[1] + element.offsetHeight) - this.ycomp) /
        element.offsetHeight;
    if (mode == 'horizontal')
      return ((this.offset[0] + element.offsetWidth) - this.xcomp) /
        element.offsetWidth;
  },

  clone: function(source, target) {
    source = $(source);
    target = $(target);
    target.style.position = 'absolute';
    var offsets = this.cumulativeOffset(source);
    target.style.top    = offsets[1] + 'px';
    target.style.left   = offsets[0] + 'px';
    target.style.width  = source.offsetWidth + 'px';
    target.style.height = source.offsetHeight + 'px';
  },

  page: function(forElement) {
    var valueT = 0, valueL = 0;

    var element = forElement;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;

      // Safari fix
      if (element.offsetParent==document.body)
        if (Element.getStyle(element,'position')=='absolute') break;

    } while (element = element.offsetParent);

    element = forElement;
    do {
      valueT -= element.scrollTop  || 0;
      valueL -= element.scrollLeft || 0;
    } while (element = element.parentNode);

    return [valueL, valueT];
  },

  clone: function(source, target) {
    var options = Object.extend({
      setLeft:    true,
      setTop:     true,
      setWidth:   true,
      setHeight:  true,
      offsetTop:  0,
      offsetLeft: 0
    }, arguments[2] || {})

    // find page position of source
    source = $(source);
    var p = Position.page(source);

    // find coordinate system to use
    target = $(target);
    var delta = [0, 0];
    var parent = null;
    // delta [0,0] will do fine with position: fixed elements,
    // position:absolute needs offsetParent deltas
    if (Element.getStyle(target,'position') == 'absolute') {
      parent = Position.offsetParent(target);
      delta = Position.page(parent);
    }

    // correct by body offsets (fixes Safari)
    if (parent == document.body) {
      delta[0] -= document.body.offsetLeft;
      delta[1] -= document.body.offsetTop;
    }

    // set position
    if(options.setLeft)   target.style.left  = (p[0] - delta[0] + options.offsetLeft) + 'px';
    if(options.setTop)    target.style.top   = (p[1] - delta[1] + options.offsetTop) + 'px';
    if(options.setWidth)  target.style.width = source.offsetWidth + 'px';
    if(options.setHeight) target.style.height = source.offsetHeight + 'px';
  },

  absolutize: function(element) {
    element = $(element);
    if (element.style.position == 'absolute') return;
    Position.prepare();

    var offsets = Position.positionedOffset(element);
    var top     = offsets[1];
    var left    = offsets[0];
    var width   = element.clientWidth;
    var height  = element.clientHeight;

    element._originalLeft   = left - parseFloat(element.style.left  || 0);
    element._originalTop    = top  - parseFloat(element.style.top || 0);
    element._originalWidth  = element.style.width;
    element._originalHeight = element.style.height;

    element.style.position = 'absolute';
    element.style.top    = top + 'px';;
    element.style.left   = left + 'px';;
    element.style.width  = width + 'px';;
    element.style.height = height + 'px';;
  },

  relativize: function(element) {
    element = $(element);
    if (element.style.position == 'relative') return;
    Position.prepare();

    element.style.position = 'relative';
    var top  = parseFloat(element.style.top  || 0) - (element._originalTop || 0);
    var left = parseFloat(element.style.left || 0) - (element._originalLeft || 0);

    element.style.top    = top + 'px';
    element.style.left   = left + 'px';
    element.style.height = element._originalHeight;
    element.style.width  = element._originalWidth;
  }
}

// Safari returns margins on body which is incorrect if the child is absolutely
// positioned.  For performance reasons, redefine Position.cumulativeOffset for
// KHTML/WebKit only.
if (/Konqueror|Safari|KHTML/.test(navigator.userAgent)) {
  Position.cumulativeOffset = function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      if (element.offsetParent == document.body)
        if (Element.getStyle(element, 'position') == 'absolute') break;

      element = element.offsetParent;
    } while (element);

    return [valueL, valueT];
  }
}

String.prototype.toInt = function() {
	retval = '';
	for (var i = 0; i < this.length; i++) {
		if (this.charCodeAt(i) >= 48 && this.charCodeAt(i) <= 57)
		retval += String.fromCharCode(this.charCodeAt(i))
	}
	return retval;
}

String.prototype.ltrim = function leftTrim(c) {
	self = this;
	if (isUndefined(c)) c = ' ';
	while (self.substring(0,1) == c) { self = self.substring(1, self.length); }
	return self;
} 

String.prototype.rtrim = function righTrim(c) {
	self = this;
	if (isUndefined(c)) c = ' ';
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
	if (isUndefined(el)) return false;
	var var1, var2;
	if (el.tagName.toLowerCase() == 'input') { el.value = value; }
	else if (el.tagName.toLowerCase() == 'select') {
		if (value.toInt().length == value.length) var2 = value.ltrim('0');
		else var2 = value;
		if (value=='') {
			el.selectedIndex = null;
		} else {
			for (idx in el.options) {
				if (!isNumber(idx)) continue;
				if (el.options[idx].value.toInt().length == el.options[idx].value.length) var1 = el.options[idx].value.ltrim('0');
				else var1 = el.options[idx].value;
				if (var1 == var2) { el.selectedIndex = idx; break; }
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
    return typeof a == 'function';
}

function isNull(a) {
    return typeof a == 'object' && !a;
}

function isNumber(a) {
    return typeof a == 'number' && isFinite(a);
}

function isObject(a) {
    return (a && typeof a == 'object') || isFunction(a);
}

function isString(a) {
    return typeof a == 'string';
}

function isUndefined(a) {
    return typeof a == 'undefined';
}

String.
    method('entityify', function () {
        return this.replace(/&/g, "&amp;").replace(/</g,
            "&lt;").replace(/>/g, "&gt;");
    }).
    method('quote', function () {
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

/** INICIO de para desplzara a una extension de prototipos **/

var sendForm; // Con esto, simpiamos la funcion sendForm
if (!sendForm || isUndefined(sendForm) || !isFunction(sendForm)) {
function sendForm(form,element,value,action,confirm_text) {
   // alert(document.forms[form].action);
   //alert ( document.forms[form].elements[element].name + document.forms[0].elements[0].value );
   if (element && value && form) {
      document.forms[form].elements[element].value = value;
   }
   if (action) document.forms[form].action = '?seccion=' + action;
   //alert ( document.forms[form].action + " -- " + document.forms[form].elements[element].name + " -- " + document.forms[form].elements[element].value );
   if (confirm_text) {
      if (confirm(confirm_text)) document.forms[form].submit();
   } else {
      document.forms[form].submit();
   }
   return false;
}
}

/*
* This function will not return until (at least)
* the specified number of milliseconds have passed.
* It does a busy-wait loop.
*/
function pause(numberMillis) {
	var now = new Date();
	var exitTime = now.getTime() + numberMillis;
	while (true) {
		now = new Date();
		if (now.getTime() > exitTime) return;
	}
}

var inmForm = Class.create();
Object.extend(inmForm,Form);
inmForm.disableDescendants = function (id,whichElements,typeName,name) {
	oId = $(id);
	var oInputs = Form.getElements(oId);
	var oItem;
	if (oInputs.length) {
		for (i=0; i<oInputs.length; i++) {
			if (isObject(oInputs[i])) {
				oItem = oInputs[i];
				oItem.disabled = true;
			}
		}
	}
}
inmForm.enableDescendants = function (id,whichElements,typeName,name) {
	// alert("Form.disableDescendants .... ");
	oId = $(id);

	var oInputs = Form.getElements(oId);
	if (oInputs.length) {
		for (i=0; i<oInputs.length; i++) {
			var oItem = oInputs[i];
			if (oItem.glow) oItem.glow();
			oItem.disabled = false;
		}
	}
}
inmForm.findFirstElement = function (id,bCheckDisabled,bCheckHidden) {
	if (isUndefined(bCheckDisabled) || !isBoolean(bCheckDisabled)) bCheckDisabled = true;
	if (isUndefined(bCheckHidden) || !isBoolean(bCheckHidden)) bCheckHidden = true;
	
	if (bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (bCheckDisabled && !bCheckHidden) {
		var anonFunc = function(element) { return !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (!bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else {
		var anonFunc = function(element) { return ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	}
	return inmForm.getElements(id).find(anonFunc);
}

var HashMap = Class.create();
HashMap.prototype = {
	initialize: function HashMap() {
		this.aKeys = new Array();
		this.aVals = new Array();
	},
	put: function put (key,val) {
		pos = this.aKeys.length;
		this.aKeys[pos] = key;
		this.aVals[pos] = val;
	},
	get: function get (key) {
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) return this.aVals[i];
		}
	},
	remove: function remove (key) {
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) {
				this.aKeys[i] = null;
				this.aVals[i] = null;
				return true;
			}
		}
		return false;
	},
	keys: function keys () {
		return this.aKeys;
	}
}

var KeyboardDriver = Class.create();
KeyboardDriver.prototype = {
	debug: false,
	initialize: function KeyboardDriver(doc) {
		if (doc) {
			Event.observe(doc,'keydown',this.keyPress.bindAsEventListener(this),true);
			// Event.observe(doc,'keydown',function (ev) { alert("Tecla: "+ev); return true;},true);
		}
		this.aEvents = new HashMap();
		this.aEvents.put('DOWN',new Array());
		this.aEvents.put('UP',new Array());
		this.aEvents.put('RIGHT',new Array());
		this.aEvents.put('LEFT',new Array());
		this.aEvents.put('ESC',new Array());
		this.aEvents.put('INTRO',new Array());
		this.aEvents.put('TAB',new Array());
		this.aEvents.put('NUM_0',new Array());
		this.aEvents.put('NUM_1',new Array());
		this.aEvents.put('NUM_2',new Array());
		this.aEvents.put('NUM_3',new Array());
		this.aEvents.put('NUM_4',new Array());
		this.aEvents.put('NUM_5',new Array());
		this.aEvents.put('NUM_6',new Array());
		this.aEvents.put('NUM_7',new Array());
		this.aEvents.put('NUM_8',new Array());
		this.aEvents.put('NUM_9',new Array());
		this.aEvents.put('ALL',new Array());
	},

	mapKeyCode: function mapKeyCode(code) {
		var retval;
		if (!code) return null;

		aRetVal = {};
		switch (code) {
			case 40:
				retval = "DOWN";
				break;
			case 38:
				retval = "UP";
				break;
			case 39:
				retval = "RIGHT";
				break;
			case 37:
				retval = "LEFT";
				break;
			case 27:
				retval = "ESC";
				break;
			case 13:
				retval = "INTRO";
				break;
			case 9:
				retval = "TAB";
				break;
			default:
				if (code >= 48 && code <= 57) {
					retval = 'NUM_' + (code-48);
				} else if (code >= 96 && code <= 105) {
					retval = 'NUM_' + (code-96);
				} else {
					retval = '';
					// alert("Codigo desconocido: "+code);
				}
				break;
		}
		aRetVal['keyCode'] = code;
		aRetVal['strKey'] = retval;
		aRetVal['char'] = String.fromCharCode(code);
		return aRetVal;
	},

	register: function registerKey (tecla,method,instance) {
		var aK = this.aEvents.keys();
		for (i=0;i<aK.length;i++) {
			if (tecla==aK[i] || tecla=="all") {
				aL = this.aEvents.get(aK[i]);
				pos = aL.length;
				if (instance && instance != 'undefined') aL[pos] = method.bind(instance);
				else aL[pos] = method;
			}
		}
	},

	keyPress: function (evento) {
		var retval = true;
		var evList = null;

		var targ;
		if (!evento) var evento = window.event;
		// alert("KeyboardDriver::keyPress, con este: " + this + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) code = evento.keyCode;
		aTecla = this.mapKeyCode(code);
		// if (aTecla.strKey=="UP") alert(" KeyboardDriver:: keypress UP ");

		var tecla = aTecla.strKey;
		evList = this.aEvents.get(tecla);
		//alert("keyPress, con este: " + tecla + " y eventos: " + evList.length);
		if (evList && evList.length) {
			var rval;
			for (i=0; i<evList.length; i++) {
				if (isUndefined(evList[i])==true) { continue; }
				if (isUndefined(evList[i])) {
					alert("Siguienteeeeeeeee");
					continue;
				}
				rval = false;
				//PaBorrar: if (evList[i][1].call(evList[i][0],aTecla,evento)) break;
				// alert("Llamar a: " + evList[i]);
				//alert("fnc: "+(evList[i])+" rval is "+rval+" con tipo: "+typeof evList[i]+" El is: "+isUndefined(evList[i]));
				//alert("fnc: "+(evList[i])+" evento: "+evento+" target: "+evento.target+" src: "+evento.srcElement);
				rval = evList[i](aTecla,evento);
				//if (evList[i](aTecla,evento)==true) 
				if (isUndefined(evList[i])) {
					// alert(" putaaAaAaAaaAaaAAaaAaAaaAaaaa ");
					continue;
				}
				if (rval) {
					//alert("Ya tenemos quien se encarge. no permea ");
					if (evento.preventDefault) {
						// alert("CANCELANDO el evento "+evento+" rval: "+rval);
						evento.preventDefault();
					}
					retval = false;
					// alert("Un break ... ");
					break;
				}
			}
		}
		// alert(" keyPress rval "+retval);
		pause(100);
		return retval;
	}
}

/** FIN de para desplzara a una extension de prototipos **/

var TableSwitcher = Class.create();
TableSwitcher.prototype = {
	initialize: function TableSwitcher() {
		this.current = -1;
		this.aTables = new Array();
		this.aKeys = new Array();
		document.bgColor = "#FFFFCC";
	},

	add: function add(oTb,strKey) {
		var pos =  this.aTables.length;
		oTb.registerSwitch(this,pos);
		this.aTables[pos] = oTb;
		this.aKeys[pos] = strKey;
	},

	keyPress: function keyPress(aT,ev) {
		var retval;
		//alert('TableSwitcher::keypress() ');
		if (this.current!=-1) {
			//alert("Nuestro current es: "+this.current);
			// alert("El contenido es: "+this.aTables[this.current]);
			retval = this.aTables[this.current].keyPress(aT,ev);
		} else {
			// true, es en realidad "yo me encargo"
			retval = false;
			for (i=0;i<this.aKeys.length;i++) {
				if (aT.strKey==this.aKeys[i]) {
					this.activate(i);
					retval = true;
					break;
				}
			}
		}
		return retval;
	},

	activate: function (pos) {
		//alert("Activando "+this.aTables[this.current]+" num: "+this.current);
		if (this.current != -1) {
			this.deactivate(this.current);
		}
		document.bgColor = "#FFFFFF";
		this.current = pos;
		this.aTables[this.current].focus();
	},

	deactivate: function (pos) {
		//if (this.current != pos) return;
		//alert("DE-Activando "+this.aTables[pos]+" num: "+pos+" cur:"+this.current);
		document.bgColor = "#FFFFCC";
		this.aTables[pos].blur();
		this.current = -1;
	}
}

var TableBrowser = Class.create();
TableBrowser.prototype = {
	cssContentHidden: 'oculto',
	cssContentVisible: 'RowStd',
	form_id: '',
/** 
  aDescendants ha de ser un array de 3 elementos con los siguientes valores:
  0 - Nombre de Etiqueta del descendiente.
  1 - ID, o substring inicial del id
  2 - Clase a construir y enlazar
  **/
	initialize: function TableBrowser(base,aDesc, methodSelect) {
		if (!base || !base.id) return false;

		var i;
		if (isObject(aDesc)) { var aDescendants = aDesc; } else { var aDescendants = {}; }

		this.nombre = base.id;
		this.domTable = base;
		this.aRealRows = new Array();
		this.iRowAct = 0;
		this.bBlockedKeys = false;
		this.oTbSwitch = null;
		this.oTbPos = null;

		this.aChildren = new Array();
		this.accSelect = methodSelect;
					
		for (i=0; i<this.domTable.childNodes.length; i++) {
			if (this.domTable.childNodes[i].nodeName == 'TBODY') {
				this.domTableBody = this.domTable.childNodes[i];
				break;
			}
		}
		// if (!this.domTableBody) return false;

		//Event.observe(document,'keydown',this.keyPress.bindAsEventListener(this),true);

		if (isUndefined(aDesc) || isEmpty(aDesc)) {
			if (this.domTableBody.hasChildNodes()) { aDescendants['list'] = this.domTableBody.childNodes; }
			// aDescendants['class'] = SonSwitchByCSS;
		} else {
			// alert("vamos a sacar los tag: " + aDescendants.tagname + " con clase: " + aDescendants['class']);
			aDescendants['list'] = this.findElement(this.domTableBody,aDescendants['tagname'],aDescendants['name']);
			// alert("La lista: " + aDescendants['list'] + " Con size: " + aDescendants['list'].length);
		}
		if (!(aDescendants['tagname'])) aDescendants['tagname'] = 'TR';

		// Primero Deshabilitamos todos los Items.
		if (isObject(aDescendants['list']) && aDescendants['list'] && aDescendants['list'].length) {
			for (i=0; i<aDescendants['list'].length;i++) {
				if (aDescendants['list'][i].nodeName==aDescendants['tagname']) {
					pos = this.aChildren.length;
					if (pos == -1) pos = 0;
					// alert("Vamos a contruir en " + pos + " con " + aDescendants['class'] + ' id: ' + aDescendants['list'][i].id);
					if (isUndefined(aDescendants['class']) || !isFunction(aDescendants['class'])) {
						// Clase por defecto
						this.aChildren[pos] = new SonSwitchByCSS(this,aDescendants['list'][i]);
					} else {
						this.aChildren[pos] = new aDescendants['class'](this,aDescendants['list'][i]);
					}
					this.aChildren[pos].blur();
				}
			}
			/** **
			alert("La lista contiene : " + this.aRealRows.length + " con valor 0: " + this.aRealRows[0] + " y ref: " 
						+ this.domTableBody.childNodes[this.aRealRows[0]] + ' valor(-1): ' + this.aRealRows[-1] + " su ref: "
						+ this.domTableBody.childNodes[this.aRealRows[-1]] );
			/** **/
			if (this.aChildren.length) {
				this.aChildren[0].glow();
				this.iRowAct = 0;
			}
			// alert("Hay un total de: " + this.aRealRows.length);
		} else {
			oFrm = this.findForm();
			var ss_name = $F('__iface_followup');
			if (ss_name && ss_name.length > 1) {
				var vname = $F('__iface_followup_setvar');
				var vvalue = $F('__iface_followup_setval');
				if (vname && vname.length && vvalue ) {
					sendForm(oFrm.name,vname,vvalue,ss_name);
				} else sendForm(oFrm.name,null,null,ss_name);
			}
		}

		// Buscamos los descendientes, para engancharlos:
		if (aDescendants) {
			if (aDescendants[0] && aDescendants[1] && aDescendants[2]) {
				aTList = this.domTable.getElementsByTagName(aDescendants[0]);
				if (aTList.length) {
					for (i=0;i<aTList.length;i++) {
						oItem = aTList.item(i);
						elid = oItem.id;
						if (elid.substr(0,aDescendants[1].length)) {
							// alert("Yiu ID: " + elid + " param: " + aDescendants[2]);
							// this.aChildren[this.aChildren.length] = new aDescendants[2].constructor(oItem,this)
						}
					}
				}
			}
		}
	},

	registerSwitch: function (oSWitch,pos) {
		this.oTbSwitch = oSWitch;
		this.oTbPos = pos;
	},

	focus: function () {
		//alert('Activando foco a '+this.domTable);
		this.domTable.className = this.cssContentVisible;
	},

	blur: function () {
		//alert('De-Activando foco a .. '+this.domTable);
		if (!isUndefined(this.domTable)) 
			this.domTable.className = this.cssContentHidden;
	},

	keyPress: function (aT,evento) {
		var retval = false;

		//alert("TableBrowser::keyPress, con este: " + aT + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) {
			code = evento.keyCode;
			aTecla = mapKeyCode(code);
		} else if (aT && isString(aT.strKey)) aTecla = aT;
		else if (aT && isNumber(aT.keyCode)) {
			code = aT.keyCode;
			aTecla = mapKeyCode(code);
		} else aTecla = aT;

		if (!self.bBlockedKeys) {
			var tecla = aTecla.strKey;
			switch (tecla) {
				case "ESC":
					if (this.oTbSwitch) {
						this.oTbSwitch.deactivate(this.oTbPos);
					}
					break;

				case "UP":
					self.moveUp();
					retval = true;
					break;

				case "DOWN":
					self.moveDown();
					retval = true;
					break;

				case "LEFT":
					self.moveUp();
					retval = true;
					break;

				case "RIGHT":
					self.moveDown();
					retval = true;
					break;

				case "INTRO":
					retval = self.selectItem();
					// alert("el rval de la seleccion: "+retval);
					break;

				case "NUM_0":
					oFrm = self.findForm();
					// Activamos los que esten ocultos, y mandamoslo
					if (oFrm) {
						inmForm.enable(oFrm);
						oFrm.submit();
						retval = true;
					}
					break;

				case "NUM_5":
					oFrm = self.findForm();
					var ss_name = $F('__iface_key_5');
					if (ss_name && ss_name.length > 1) {
						var vname = $F('__iface_key_5_setvar');
						var vvalue = $F('__iface_key_5_setval');
						if (vname && vname.length && vvalue ) {
							sendForm(oFrm.name,vname,vvalue,ss_name);
						} else sendForm(oFrm.name,null,null,ss_name);
						retval = true;
					} else {
						sendForm(oFrm.name,'accion','Revisar','pkg_revisar_venta');
						retval = true;
					}
					break;

				case "NUM_3":
					oFrm = self.findForm();
					var ss_name = $F('__iface_key_3');
					if (ss_name && ss_name.length > 1) {
						var vname = $F('__iface_key_3_setvar');
						var vvalue = $F('__iface_key_3_setval');
						if (vname && vname.length && vvalue ) {
							sendForm(oFrm.name,vname,vvalue,ss_name);
						} else sendForm(oFrm.name,null,null,ss_name);
						retval = true;
					} else {
						sendForm(oFrm.name,'accion','Confirmar','pkg_inicio');
						retval = true;
					}
					break;

				case "NUM_1":
					oFrm = self.findForm();
					var ss_name = $F('__iface_key_1');
					if (ss_name && ss_name.length > 1) {
						var vname = $F('__iface_key_1_setvar');
						var vvalue = $F('__iface_key_1_setval');
						if (vname && vname.length && vvalue ) {
							sendForm(oFrm.name,vname,vvalue,ss_name);
						} else sendForm(oFrm.name,null,null,ss_name);
						retval = true;
					}
					break;
			}
		} else {
			//alert(self.iRowAct+" Pabajo ! ... "+self.aChildren[self.iRowAct]+" keyPress: "+self.aChildren[self.iRowAct].keyPress);
			retval = self.aChildren[self.iRowAct].keyPress(aTecla,evento);
		}
		//alert("retval del keypress general: " + retval);

		return retval;
	},

	moveUp: function () {
		var oI;
		if (this.aChildren.length) {
			/** **
			alert("Empezamos en: " + this.iRowAct + " con valor: " + this.aRealRows[this.iRowAct] + " y ref: " 
						+ this.domTableBody.childNodes[this.aRealRows[this.iRowAct]]);
			/** **/
			if (this.iRowAct > 0) {
				this.aChildren[this.iRowAct].blur();
				this.iRowAct--;
				this.aChildren[this.iRowAct].glow();
				oI = this.aChildren[this.iRowAct].getItem();
				// alert("llamando a scroll to 0,"+oI.offsetTop+ " Item id: " + oI.id + " tag: " + oI.tagName + " name: " + oI.getAttribute('name'));
				if (!isUndefined(oI)) window.scrollTo(0,oI.offsetTop);
				// Element.scrollTo(oI);
			}
		}
		return true;
	},

	moveDown: function () {
		var retval = true;
		if (this.aChildren.length) {
			if (this.iRowAct < (this.aChildren.length-1)) {
				this.aChildren[this.iRowAct].blur();
				this.iRowAct++;
				this.aChildren[this.iRowAct].glow();
				oI = this.aChildren[this.iRowAct].getItem();
				window.scrollTo(0,oI.offsetTop);
			} else retval = false;
		} else retval = false;
		return retval;
	},

	selectItem: function () {
		rval = false;
		if (this.iRowAct < this.aChildren.length) {
			if (this.aChildren[this.iRowAct].activate && this.aChildren[this.iRowAct].keyPress) {
				if (this.aChildren[this.iRowAct].activate()) {
					this.bBlockedKeys = true;
				}
				rval = true;
			} else {
				this.aChildren[this.iRowAct].highLight();

				if (this.accSelect) {
					//alert("Accion del select: ");
					this.accSelect(this.aChildren[this.iRowAct]); 
				} else {
					//Ojo, en teoria, el metodo getInpust(),  tiene que recibir una instancia de form ulario. 
					//   pero nos aprovechamos de que no lo comprueba en prototype.js
					oInputs = inmForm.getInputs(this.aChildren[this.iRowAct].getItem(),'checkbox');
					if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; } }

					oInputs = inmForm.getInputs(this.aChildren[this.iRowAct].getItem(),'radio');
					if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; } }
				}
			}
		}
		return rval;
	},

	firstIdx: function firstIdx () {
		if (isArray(this.aChildren)) { for (var i in this.aChildren) { if (i.toInt().length) { return i; } } }
		return;
	},

	lastIdx: function lastIdx () {
		var retval;
		if (isArray(this.aChildren)) { for (var i in this.aChildren) { if (i.toInt().length) { retval = i; } } }
		return retval;
	},

	actualIdx: function actualIdx () {
		return this.iRowAct;
	},

	getRow: function getRow (idx) {
		return this.aChildren[this.iRowAct];
	},
	findForm: function () {
		var oFrm;
		// Buscamos el formulario.
		if (this.form_id && !isUndefined($(this.form_id))) return $(this.form_id);
		if (this.aChildren.length) {
			oEl = inmForm.findFirstElement(this.aChildren[0].getItem(),false,false);
			if (oEl && oEl.form) oFrm = oEl.form;
		} else {
			oEl = inmForm.findFirstElement(document,false,false);
			if (oEl && oEl.form) oFrm = oEl.form;
		}
		return oFrm;
	},

	findElement: function findElement(oBase,tag,name) {
		var aRetVal = new Array();

		oId = $(oBase);
		if (!tag && !name) return;

		if (tag) { 
			var bName = false;
			aTmpList = document.getElementsByTagName(tag); 
		} else { 
			// Antes estaba este primero. Pero getElementsByName, aunque existe en IE para WinCE, devuelve una lista vacia :(
			// Asi que, siempre vamos a hacer la busqueda con getElementsByTagName.
			aTmpList = document.getElementsByName(name); 
			var bName = true;
		}

		for (i=0; i<aTmpList.length; i++) {
			// Comprobamos que es el tag que buscamos
			if (bName) {
				if (tag && aTmpList[i].tagName.toUpperCase() != tag.toUpperCase()) { continue; }
			} else {
				if (name && aTmpList[i].getAttribute('name').toUpperCase() != name.toUpperCase()) { continue; }
				// alert("Comprarando ahora " + name + " con " + aTmpList[i].getAttribute('name'));
			}
			// Comprobamos que sea descendiente de la base.
			for (element = aTmpList[i]; element.parentNode; element = element.parentNode) {
				if (element == oBase) {
					// alert("OK!! ");
					aRetVal[aRetVal.length] = aTmpList[i];
				}
			}
		}
		return aRetVal;
		// if (aRetVal.length == 1) return aRetVal.shift();
		// else return aRetVal;
	}
}

    
function mapKeyCode(code) {
	var retval;
	if (!code) return null;

	aRetVal = {};
	switch (code) {
		case 40:
			retval = "DOWN";
			break;

		case 38:
			retval = "UP";
			break;

		case 39:
			retval = "RIGHT";
			break;

		case 37:
			retval = "LEFT";
			break;

		case 27:
			retval = "ESC";
			break;

		case 13:
			retval = "INTRO";
			break;

		case 9:
			retval = "TAB";
			break;

		default:
			if (code >= 48 && code <= 57) {
				retval = 'NUM_' + (code-48);
			} else retval = '';
			break;
	}
	aRetVal['keyCode'] = code;
	aRetVal['strKey'] = retval;
	aRetVal['char'] = String.fromCharCode(code);
	return aRetVal;
}

var SonSwitchByCSS = Class.create();
SonSwitchByCSS.prototype = {
	cssContentHidden: 'RowBlur',
	cssContent: 'RowStd',
	cssContentHighLight: 'RowHi',
	oItem: null,
	initialize: function SonSwitchByCSS(oParent,oDomItem) {
		this.oItem = $(oDomItem);
		this.oParent = $(oParent);
		return this;
	},

	blur: function SonSwitchByCSS__blur() {
		oRow = this.getItem();
		//inmForm.disableDescendants(oRow);
		oRow.className = this.cssContentHidden;
		//alert("blur base (" +oRow.id+ ") para " + oRow.getAttribute('name') + " tipo: " + oRow + " poniendo clas: " + oRow.className);
	},

	glow: function SonSwitchByCSS__glow() {
		oRow = this.oItem;
		// alert("Glow sobre " + oRow + " nombre: " + oRow.getAttribute('name') + " css: " + this.cssContent);
		oRow.className = this.cssContent;

		inmForm.enableDescendants(oRow);
	},

	highLight: function SonSwitchByCSS__highLight() {
		oRow = this.oItem;
		oRow.className = this.cssContentHighLight;
	},

	restore: function SonSwitchByCSS__restore() {
		oRow = this.oItem;
		oRow.className = this.cssContent;
	},

	getItem: function SonSwitchByCSS__getItem() {
		return this.oItem;
	},

	getRoot: function SonSwitchByCSS__getRoot() {
		if (this.oParent && this.oParent.getRoot) return this.oParent.getRoot();
		else if (this.oParent) return this.oParent;
		else return this;
	},

	submitForm: function SonSwitchByCSS__submitForm() {
		var oI = this.getItem();
		var aTmp, vname, vvalue, target, vtext, oFrm, oTarget, retval = false;
		var aInputs = inmForm.getInputs(oI,'hidden','__target');
		if (aInputs.length) {
			oRaiz = this.getRoot();
			aTmp = oRaiz.findElement(oI,'input','__target');
			if (aTmp && aTmp.length>0) {
				oTarget = aTmp.shift();
				target = $F(oTarget);
				oFrm = oTarget.form;
			}
			if (isObject(oFrm)) {
				aTmp = oRaiz.findElement(oI,'input','__target_setvar');
				if (aTmp && aTmp.length>0) vname = $F(aTmp.shift());
				aTmp = oRaiz.findElement(oI,'input','__target_setval');
				if (aTmp && aTmp.length>0) vvalue = $F(aTmp.shift());
				aTmp = oRaiz.findElement(oI,'input','__target_confirm');
				if (aTmp && aTmp.length>0) vtext = $F(aTmp.shift());
				// var vname = oRaiz.findElement(oI,'input','__target_followup_setvar');
				// var vvalue = $F('__target_followup_setval');
				// alert("Tenemos para mandar a " + target + " variable: " + vname + " con valor: " + vvalue);
				if (oFrm) {
					inmForm.enableDescendants(oFrm);
					sendForm(oFrm.getAttribute('name'),vname,vvalue,target,vtext);
					retval = true;
				}
			}
		}
		return retval;
	}
}


/** Esto, en realidad seria lo unico que se tendria que quedar aqui. (esto es, las clases propias del iface del almacen, Loczlizacion, etc .. **/

var TBItem_Location = Class.create();
//No soporta herencia:  Object.extend(TBItem_Location.prototype,TableBrowserItem.prototype);
TBItem_Location.inherits(SonSwitchByCSS);

// TBItem_Location.prototype.initialize = function TBItem_Location(oParent,oDomItem) 
var tmpMethods = {
		// oCodBarras : false,
		// oLoc : false,
		// oSKU : false,
		// oCnt : false,
		// bCodigoOK : false,
		// sActivo : false,
		// aIdx : {},
	initialize: function TBItem_Location(oParent,oDomItem) {
		this.uber('initialize',oParent,oDomItem);
		this.aIdx = {};
		this.sActivo = false;
		var oI = this.getItem();
		//alert('TBItem_Location.constructor->oItem ID: ' + oI.id + " Nombre: " + oI.getAttribute('nombre'));

		aICodBarras = this.oParent.findElement(oI,'div','CodigoBarras');
		if (aICodBarras.length) { this.oCodBarras = new CodigoBarras(this,aICodBarras.shift()); }

		aILoc = this.oParent.findElement(oI,'div','Localizacion');
		if (aILoc.length) { this.oLoc = new Localizacion(this,aILoc.shift()); }
		this.aIdx['Localizacion'] = this.oLoc;
		// this.oLoc.aLoc['planta'].addEventListener('change',this.oCodBarras.changedCode,true);
		// this.oCodBarras.oCodigoInput.addEventListener('change',this.oCodBarras.changedCode,true);

		aISKU = this.oParent.findElement(oI,'div','SKU');
		if (aISKU.length) { this.oSKU = new SKU(this,aISKU.shift()); }
		this.aIdx['SKU'] = this.oSKU;

		// alert("Las cantidades desde " + oI.tagName + " con id: " + oI.id + " y nombre: " + oI.getAttribute('name') );
		aICnt = this.oParent.findElement(oI,'div','Cantidades');
		if (aICnt.length) { this.oCnt = new Cantidad(this,aICnt.shift()); }
		this.aIdx['Cantidad'] = this.oCnt;
	},

	KBControl: function blockKB(bVal) {
		if (isUndefined(bVal)) { bVal = true; }
		this.oParent.bBlockedKeys = bVal;
	},

	keyPress: function TBItem_keyPress(aTecla,ev) {
		// alert("Apretaba tecla  en el hijito CB: " + this.oCodigoBarras);
		strKey = aTecla.strKey;
		retval = true;
//alert("strkey: " + strKey + " con barras: " + this.oCodBarras + "Codigo ok? " + this.bCodigoOK);
		if (!this.oCodBarras || this.oCodBarras.bCodigoOK) {
// alert("strkey: " + strKey + " con barras: " + this.oCodBarras + "Codigo ok? " + this.bCodigoOK);
			switch (strKey) {
				case "ESC":
					if (this.sActivo) {
						if (this.aIdx[this.sActivo] && this.aIdx[this.sActivo].blur) { this.aIdx[this.sActivo].blur(); }
						this.sActivo = false;
						this.glow();
					}
					this.oParent.bBlockedKeys = false;
					break;

				default:
					if (isObject(this.aIdx[this.sActivo]) && this.aIdx[this.sActivo].keyPress && isFunction(this.aIdx[this.sActivo].keyPress)) {
						retval = this.aIdx[this.sActivo].keyPress(aTecla,ev);
					} else {
						retval = this.defaultKeyPress(aTecla);
					}
					break;
			}
		} else {
			// alert("Codigo no bene, pal codbarras con : " + aTecla);
			if (this.oCodBarras.activo) retval = this.oCodBarras.keyPress(aTecla,ev);
		}
		return retval;
	},

	defaultKeyPress: function TBItem_keyPressLocal(aTecla) {
		strKey = aTecla.strKey;
		retval = false;
		switch (strKey) {
			case "INTRO":
				if (this.aIdx[this.sActivo] && this.aIdx[this.sActivo].blur) { this.aIdx[this.sActivo].blur(); }

				if (this.oParent.actualIdx() == this.oParent.lastIdx()) {
					oFrm = this.oParent.findForm();
					// Activamos los que esten ocultos, y mandamoslo
					if (oFrm) {
						inmForm.enable(oFrm);
						oFrm.submit();
					}
				}
				this.oParent.moveDown();
				this.oParent.selectItem();
				// retval = false;
				retval = true;
				break;

			case "UP":
				if (!this.sActivo) {
					this.oParent.bBlockedKeys = false;
					this.oParent.moveUp();
				} else {
					this.moveUp();
				}
				retval = true;
				break;

			case "DOWN":
				if (!this.sActivo) {
					this.oParent.bBlockedKeys = false;
					this.oParent.moveDown();
				} else {
					this.moveDown();
				}
				retval = true;
				break;
		}
		//alert("defaultKeypress de registro-TBItem. con retorno "+retval);
		return retval;
	},

	activate: function TBItem_activate() {
		var retval = true;
		if (this.oCodBarras && !this.oCodBarras.bCodigoOK) {
			this.sActivo = false;
			this.oParent.bBlockedKeys = true;
			this.oCodBarras.focus();
		} else {
		   	if (this.oCnt) {
				if (this.oCnt.focus) {
					if (this.oLoc && this.oLoc.blur) this.oLoc.blur();
					if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
					if (this.oCnt.focus()) {
						this.sActivo = 'Cantidad';
					}
				} else {
					this.sActivo = 'Cantidad';
				}
			}  
			if (!this.sActivo && this.oSKU) {
			   // alert("La cantidad no existe, vamos a por el SKU ");
			} 
			if (!this.sActivo && this.oLoc) {
				if (this.oLoc.focus) {
					if (this.oCnt && this.oCnt.blur) this.oCnt.blur();
					if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
					if (this.oLoc.focus()) this.sActivo = 'Localizacion';
				} else {
					this.sActivo = 'Localizacion';
				}
			}
			if (!this.sActivo) {
				// alert("Ningun campo coge foco en activacion, comprobando lo de las checkboxes. ");
				var oI = this.getItem();
				var oInputs = inmForm.getInputs(oI,'checkbox');
				if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }
				else { this.submitForm(); }
				// No queremos bloquear esta entrada, no hay nada que hacer aqui.
				retval = false;
			}
		}
		return retval;
	},

	moveUp: function moveUp() {
		if (!this.sActivo) return;
		switch (this.sActivo) {
			case 'Cantidad':
				if (this.oCnt && this.oCnt.blur) this.oCnt.blur();
				if (this.oSKU) {
					this.oSKU.focus();
					this.sActivo = 'SKU';
				}
				break;
			case 'SKU':
				if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
				if (this.oLoc) {
					this.oLoc.focus();
					this.sActivo = 'Localizacion';
				}
				break;
			case 'Localizacion':
				break;
		}
	},

	moveDown: function moveDown() {
		if (!this.sActivo) return;
		switch (this.sActivo) {
			case 'Localizacion':
				if (this.oLoc && this.oLoc.blur) this.oLoc.blur();
				if (this.oSKU && this.oSKU.focus) { if (this.oSKU.focus()) { this.sActivo = 'SKU'; } }
				if (this.sActivo == 'Localizacion') { if (this.oCnt && this.oCnt.focus) { if (this.oCnt.focus()) { this.sActivo = 'Cantidad'; } } }
				if (this.sActivo == 'Localizacion') { this.oParent.moveDown(); }
				break;
			case 'SKU':
				if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
				if (this.oCnt) {
					if (this.oCnt.focus()) {
						this.sActivo = 'Cantidad';
					} else {
						alert("La cantidad no quiere el foco, alguna sugerencia? ");
					}
				}
				break;

			case 'Cantidad':
				break;
		}
	}
}
Object.extend(TBItem_Location.prototype,tmpMethods);
tmpMethods = null;

var CodigoBarras = Class.create();
CodigoBarras.inherits(SonSwitchByCSS);
var tmpMethods = {
	actual_code: '',
	initialize: function CodigoBarras (parent,id,oChange,bBlock) {
		this.uber('initialize',parent,id);
		this.activo = true;
		this.bCodigoOK = false;
		if (isUndefined(bBlock)) bBlock = false //FixMe: Cambiar esto a true;
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				// alert("Elemento: " + aEl[i].getAttribute('name') + " tipo: " + aEl[i].type );
				if (Element.hasClassName(aEl[i],'codigobarras') && aEl[i].type == 'text') {
					this.oCodigoInput = aEl[i];
					if (isUndefined(oChange) || !isObject(oChange)) {
						Event.observe(this.oCodigoInput,'change',this.changedBarCode.bindAsEventListener(this));
					} else {
						Event.observe(this.oCodigoInput,'change',oChange.changedBarCode.bindAsEventListener(oChange));
					}
					if (!isUndefined(bBlock) && bBlock) Event.observe(this.oCodigoInput,'blur',this.blockField.bindAsEventListener(this));
				} else if (aEl[i].type == 'hidden' && Element.hasClassName(aEl[i],'codigobarras')) {
					this.oCodigoCheck = aEl[i];
				}
			}
		}
	},

	focus: function focus() {
		oI = this.getItem();
		oI.className = 'visible';
		this.activo = true;

		this.glow();
		this.highLight();
		if (this.oCodigoInput) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	blur: function blur() {
		this.uber('blur');
		this.getItem().className = 'oculto';
		this.activo = false;
	},

	keyPress: function keyPress(aT,ev) {
		retval = false;
		// alert("keycode: " + aT.keyCode);
		switch (aT.strKey) {
			case "ESC":
				this.oParent.oParent.bBlockedKeys = false;
				this.blur();
				break;

			/** SOBRA , ya se registra el evento onChange **/
			case "INTRO":
				// alert("INTRO En CodigoBarras " + this);
				if (!this.bCodigoOK) retval = this.changedBarCode();
				retval = false;
				break;
			/** **/
		}
		return retval;
	},

	changedBarCode: function changed(ev) {
		retval = true;
		if ($F(this.oCodigoInput) != $F(this.oCodigoCheck)) {
			// alert("Codigo de Barras Incorrecto " + $F(this.oCodigoInput) + ". Deberia ser: " + $F(this.oCodigoCheck));
			if ($F(this.oCodigoInput) == '..') {
				oCnt = this.oParent.oCnt;
				oCnt.set(0);
				this.oParent.oParent.bBlockedKeys = false;
				this.blur();
				this.oParent.oParent.moveDown();
				this.activo = false;
			}
		} else {
			// alert("changedCode con ok? " + this.bCodigoOK);
			this.bCodigoOK = true;
			this.blur();
			this.oParent.activate();
		}
		return retval;
	},

	blockField: function block(ev) {
		if (!this.bCodigoOK) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	get: function get() {
		return $F(this.oCodigoInput);
	},

	clean: function CodigoBarras__clean() {
		Element.setValue(this.oCodigoInput,'');
	}
}
Object.extend(CodigoBarras.prototype,tmpMethods);
tmpMethods = null;

var Localizacion = Class.create();
Localizacion.inherits(SonSwitchByCSS);
var tmpMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',

	initialize: function Localizacion (parent,id) {
		this.uber('initialize',parent,id);
		this.aLoc = { zona: null, planta: null, pasillo: null, columna: null, fila: null };
		this.oCodBarras = null;
		this.fldActivo = false;
		oI = this.getItem();
		if (oI) {
			aEl = inmForm.getElements(oI);
			for (var i=0; i<aEl.length; i++) {
				for (css in this.aLoc) { if (!this.aLoc[css]) { if (Element.hasClassName(aEl[i],css)) { this.aLoc[css] = aEl[i]; } } }
			}
			// Buscando Input de localizacion por Codigo de Barras
			aICodBarras = this.oParent.oParent.findElement(oI,'div','CBarras_localizacion');
			if (aICodBarras.length) { this.oCB = new CodigoBarras(this,aICodBarras.shift(),this,false); }
		}
	},

	changedBarCode: function keypress(ev) {
		var val = this.oCB.get();
		bDone = false;
		this.oCB.bCodigoOK = true;
		if (val) {
			if (val=='..') {
				this.oCB.clean();
				for (k in this.aLoc) { if (isObject(this.aLoc[k]) && !isFunction(this.aLoc[k])) { Element.setValue(this.aLoc[k],''); } } 
				this.oCB.bCodigoOK = false;
			} else {
				aLoc = this.parseLocation(val);
				if (isObject(aLoc)) {
					for (k in aLoc) { 
						if (!isFunction(k) && !isFunction(this.aLoc[k]) && !isObject(k) && this.aLoc[k]) { Element.setValue(this.aLoc[k],aLoc[k]); }
					}
					bDone = true;
					this.oParent.sActivo = false;
					this.oParent.bBlockedKeys = false;
				}
			}
		} 
		if (bDone) { this.submitForm(); }
		return false;
	},

	parseLocation: function parseBarCode(strCode) {
		if (strCode.indexOf(':')==-1) return;

		aRetVal = {};
		if (strCode.indexOf('-') != -1) {
			aCod = strCode.split('-');
			aRetVal['zona'] = aCod[0];
			strCode = aCod[1];
		}
		aL = strCode.split(':');
		aRetVal['planta'] = aL[0];
		aRetVal['pasillo'] = aL[1];
		aRetVal['columna'] = aL[2];
		aRetVal['fila'] = aL[3];
		return aRetVal;
		return $H(aRetVal);
	},

	keyPress: function keypress(aTecla,ev) {
		strKey = aTecla.strKey;
		switch (strKey) {
			case "INTRO":
				// alert("Intro sin guay ... " + ev + " en realidad: " + Event.element(ev));
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				// alert("Siguiente campo .. ");
				this.nextField();
				// alert("Intro de guay ... ");
		}
		return true;
	},

	nextField: function next() {
		switch (this.fldActivo) {
			case 'zona':
				this.aLoc['planta'].focus();
				this.fldActivo = 'planta';
				break;
			case 'planta':
				this.aLoc['pasillo'].focus();
				this.fldActivo = 'pasillo';
				break;
			case 'pasillo':
				this.aLoc['columna'].focus();
				this.fldActivo = 'columna';
				break;
			case 'columna':
				this.aLoc['fila'].focus();
				this.fldActivo = 'fila';
				break;
			case 'fila':
				this.fldActivo = false;
				this.oParent.oParent.bBlockedKeys = false;
				if (this.oParent.glow) this.oParent.glow();
				// this.aLoc['fila'].focus();
				this.oCB.bCodigoOK = true;
				this.done();
				break;
			default:
				if (this.aLoc && this.aLoc['zona']) {
					this.aLoc['zona'].focus();
					this.fldActivo = 'zona';
				}
				break;
		}
	},

	done: function Location__done() {
		if (this.glow) this.glow();
		// COmprobamos si hay campos que marquen envio de formulario.
		if (!this.submitForm()) {
			// Si no hay formulario que enviar, hay que seguir navegando.
			this.oParent.moveDown();
		} else {
			this.oParent.sActivo = false;
		}
	},

	blur: function blur() {
		if (this.oCB && this.oCB.blur) this.oCB.blur();
		this.uber('blur');
		this.fldActivo = false;
		return true;
	},

	focus: function focus() {
		// alert("Focus de la localizacion! ");
		this.glow();
		this.highLight();
		this.oParent.bBlockedKeys = true;
		retval = true;
		if (this.oCB) {
			this.oCB.focus();
		} else {
			if (this.aLoc && this.aLoc['zona']) {
				this.aLoc['zona'].focus();
				this.fldActivo = 'zona';
			} else { retval = false; }
		}
		return retval;
	}
}
Object.extend(Localizacion.prototype,tmpMethods);
tmpMethods = null;

var SKU = Class.create();
SKU.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function SKU (parent,id) {
		this.uber('initialize',parent,id);

		this.cssContentHidden = 'FrameSetBlur';
		this.cssContent = 'FrameSetStd';
		this.cssContentHighlight = 'FrameSetHi';

		this.aSKU = { dia: null, mes: null, anyo: null, lote: null };
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				for (css in this.aSKU) { if (!this.aSKU[css]) { if (Element.hasClassName(aEl[i],css)) { this.aSKU[css] = aEl[i]; } } }
			}
		}
	}, 

	focus: function focus() {
		this.glow();
		this.highLight();
		if (this.aSKU['dia']) {
			this.aSKU['dia'].focus();
			this.aSKU['dia'].select();
		}
	},

	keyPress: function keypress(aTecla,ev) {
		strKey = aTecla.strKey;
		alert("Keypress de ski: "+strKey);
		switch (strKey) {
			case "INTRO":
				alert("Intro sin guay ... " + ev );
				//alert("Intro sin guay ... " + ev + " en realidad: " + Event.element(ev));
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				this.nextField(ev.target);
		}
		return true;
	},

	nextField: function next(target) {
		alert(' Siguiente campo ... '+target);
	}
}
Object.extend(SKU.prototype,tmpMethods);
tmpMethods = null;

var Cantidad = Class.create();
Cantidad.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function Cantidad (parent,id) {
		this.aCnt = { cantidad: null };
		this.uber('initialize',parent,id);

		this.cssContentHidden = 'FrameSetBlur';
		this.cssContent = 'FrameSetStd';
		this.cssContentHighlight = 'FrameSetHi';

		// alert("Constructor de Cantidad ");
		if (this.oItem) {
			aEl2 = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl2.length; i++) {
				for (css in this.aCnt) { if (!this.aCnt[css]) { if (Element.hasClassName(aEl2[i],css)) { this.aCnt[css] = aEl2[i]; } } }
			}
		}
	},

	focus: function focus() {
		var retval;
		if (this.aCnt['cantidad'] && this.aCnt['cantidad'].focus) {
			this.glow();
			this.highLight();
			this.aCnt['cantidad'].focus();
			this.aCnt['cantidad'].select($F(this.aCnt['cantidad']).length);
			retval = true;
		} else {
			retval = false;
		}
		return retval;
	},

	get: function get() {
		return $F(this.aCnt['cantidad']);
	},

	set: function set(value) {
		if (!isUndefined(value)) {
			if (this.aCnt['cantidad']) {
				this.aCnt['cantidad'].value = value;
			}
		}
	}
}
Object.extend(Cantidad.prototype,tmpMethods);
tmpMethods = null;

/** No se porque estaba esto duplicado **
var Menu = Class.create();
Menu.prototype = {
	initialize: function Menu() {
		var a = 0;
	},

	selectItem: function select(oRow) {
		if (oRow.getItem) oI = oRow.getItem();
		else oI = oRow;
		aInputs = inmForm.getInputs(oI,'radio','target');
		if (aInputs.length) {
			for (i=0; i<aInputs.length; i++) {
				aInputs[i].checked = !aInputs[i].checked;
				if ($F(aInputs[i])) {
					oFrm = aInputs[i].form;
					sendForm(oFrm.getAttribute('name'),null,null,$F(aInputs[i]));
				}
			}
		} else {
			oEl = 0;
			oInputs = inmForm.getInputs(oI,'checkbox');
			if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }

			if (!oEl) {
				oInputs = inmForm.getInputs(oI,'radio');
				if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }
			}

			oFrm = oEl.form;
			inmForm.enableDescendants(oFrm);
			// pause(1000);
			sendForm(oFrm.getAttribute('name'));
		}
	}
}
/** **/

var Menu = Class.create();
Menu.prototype = {
	initialize: function Menu() {
		var a = 0;
		this.bBlockedKeys = false;
	},

	selectItem: function select(oRow) {
		if (oRow.getItem) oI = oRow.getItem();
		else oI = oRow;
		aInputs = inmForm.getInputs(oI,'radio','target');
		var oFrm;
		if (aInputs.length) {
			for (i=0; i<aInputs.length; i++) {
				aInputs[i].checked = !aInputs[i].checked;
				if ($F(aInputs[i])) {
					oFrm = aInputs[i].form;
					sendForm(oFrm.getAttribute('name'),null,null,$F(aInputs[i]));
				}
			}
		} else {
			oEl = 0;
			oInputs = inmForm.getInputs(oI,'checkbox');
			if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }

			if (!oEl) {
				oInputs = inmForm.getInputs(oI,'radio');
				if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }
			}

			if (!oEl) { 
				if (oRow.getRoot) {
					var oR = oRow.getRoot();
					oFrm = oR.findForm();
					if (!oFrm) return true;
				} else {
					return true;
				}
			} else {
				oFrm = oEl.form;
			}

			inmForm.enableDescendants(oFrm);
			// pause(1000);
			sendForm(oFrm.getAttribute('name'));
		}
	},

	// No se llama nunca a este metodo
	keyPress: function (evento) {
		var retval = true;

		// alert("keyPress, con este: " + this + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) code = evento.keyCode;
		aTecla = mapKeyCode(code);

		if (!self.bBlockedKeys) {
			var tecla = aTecla.strKey;
			switch (tecla) {
				case "NUM_3":
					oFrm = self.findForm();
					var ss_name = $F('__iface_key_3');
					if (ss_name && ss_name.length > 1) {
						var vname = $F('__iface_key_3_setvar');
						var vvalue = $F('__iface_key_3_setval');
						if (vname && vname.length && vvalue ) {
							sendForm(oFrm.name,vname,vvalue,ss_name);
						} else sendForm(oFrm.name,null,null,ss_name);
					} else {
						sendForm(oFrm.name,'accion','Confirmar','pkg_inicio');
					}
					retval = false;
					break;
			}
		} else {
			retval = true;
		}
		return retval;
	}
}

var SKU_Selection = Class.create();
//No soporta herencia:  Object.extend(TBItem_Location.prototype,TableBrowserItem.prototype);
SKU_Selection.inherits(SonSwitchByCSS);
// SKU_Selection.swiss(KeyboardDriver);
//SKU_Selection.inherits(KeyboardDriver);
var methodList = {
	cssContentHidden: 'RowBlur',
	cssContent: 'RowStd',
	cssContentHighLight: 'RowHi',
	oItem: null,
	initialize: function SKU_Selection(oParent,oDomItem) {
		this.uber('initialize',oParent,oDomItem);
		var oI = this.getItem();
		this.oKb = new KeyboardDriver();
		this.oKb.register("ESC",this.deactivate.bind(this));
		this.oKb.register("INTRO",this.enter.bind(this));
		this.oKb.debug = true;
		//this.keyPress = this.oKb.keyPress.bind(this.oKb);
		// this.cssContentHidden = 'oculto';
	},

	keyPress: function (aT,e) {
		rval = this.oKb.keyPress(e);
		//alert("SKULoc::keyPress - Evento: "+e+" rval: "+rval);
		return !rval;
	},

	enter: function (aT,e) {
		var targ;
		if (e.target) targ = e.target;
		else if (e.srcElement) targ = e.srcElement;
		//var itm = this.getRoot();
		var itm = this.getItem();
		aList = inmForm.getInputs(itm,'text');
		if (aList.length) {
			for (i=0; i<aList.length; i++) {
				if (aList[i]==targ) {
					if (!isUndefined(aList[i+1])) {
						if (aList[i+1].type=="text") aList[i+1].select();
						aList[i+1].focus();
					} else {
						if (this.oParent.moveDown()) {
							this.oParent.selectItem();
						} else {
							//alert("Falta enviar el formulario ");
							oFrm = this.oParent.findForm();
							// Activamos los que esten ocultos, y mandamoslo
							if (oFrm) {
								inmForm.enable(oFrm);
								oFrm.submit();
							}
						}
					}
				}
			}
		}
	},

	deactivate: function () {
		//this.oParent.KBControl();
		this.oParent.bBlockedKeys = false;
		//oTmp = this.getRoot();
		//oR = oTmp.getItem();
		//alert("foc: "+oR.focus);
		//oR.focus();
		this.blur();
		//document.focus();
		return false;
	},

	activate: function () {
		this.highLight();
		aItms = inmForm.getInputs(this.getItem(),'text');
		if (aItms.length) {
			oTarget = aItms.shift();
			// alert("Elementos: "+oTarget.name);
			oTarget.select();
			oTarget.focus();
		}
		return true;
	},

	moveUp: function moveUp() {
		alert("SKU_Selection::moveUp()");
	},

	moveDown: function moveUp() {
		alert("SKU_Selection::moveDown()");
	}
}
Object.extend(SKU_Selection.prototype,methodList);
methodList = null;

