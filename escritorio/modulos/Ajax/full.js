/*  Prototype JavaScript framework, version 1.6.0.2
 *  (c) 2005-2008 Sam Stephenson
 *
 *  Prototype is freely distributable under the terms of an MIT-style license.
 *  For details, see the Prototype web site: http://www.prototypejs.org/
 *
 *--------------------------------------------------------------------------*/

var Prototype = {
  Version: '1.6.0.2',

  Browser: {
    IE:     !!(window.attachEvent && !window.opera),
    Opera:  !!window.opera,
    WebKit: navigator.userAgent.indexOf('AppleWebKit/') > -1,
    Gecko:  navigator.userAgent.indexOf('Gecko') > -1 && navigator.userAgent.indexOf('KHTML') == -1,
    MobileSafari: !!navigator.userAgent.match(/Apple.*Mobile.*Safari/)
  },

  BrowserFeatures: {
    XPath: !!document.evaluate,
    ElementExtensions: !!window.HTMLElement,
    SpecificElementExtensions:
      document.createElement('div').__proto__ &&
      document.createElement('div').__proto__ !==
        document.createElement('form').__proto__
  },

  ScriptFragment: '<script[^>]*>([\\S\\s]*?)<\/script>',
  JSONFilter: /^\/\*-secure-([\s\S]*)\*\/\s*$/,

  emptyFunction: function() { },
  K: function(x) { return x }
};

if (Prototype.Browser.MobileSafari)
  Prototype.BrowserFeatures.SpecificElementExtensions = false;


/* Based on Alex Arnell's inheritance implementation. */
var Class = {
  create: function() {
    var parent = null, properties = $A(arguments);
    if (Object.isFunction(properties[0]))
      parent = properties.shift();

    function klass() {
      this.initialize.apply(this, arguments);
    }

    Object.extend(klass, Class.Methods);
    klass.superclass = parent;
    klass.subclasses = [];

    if (parent) {
      var subclass = function() { };
      subclass.prototype = parent.prototype;
      klass.prototype = new subclass;
      parent.subclasses.push(klass);
    }

    for (var i = 0; i < properties.length; i++)
      klass.addMethods(properties[i]);

    if (!klass.prototype.initialize)
      klass.prototype.initialize = Prototype.emptyFunction;

    klass.prototype.constructor = klass;

    return klass;
  }
};

Class.Methods = {
  addMethods: function(source) {
    var ancestor   = this.superclass && this.superclass.prototype;
    var properties = Object.keys(source);

    if (!Object.keys({ toString: true }).length)
      properties.push("toString", "valueOf");

    for (var i = 0, length = properties.length; i < length; i++) {
      var property = properties[i], value = source[property];
      if (ancestor && Object.isFunction(value) &&
          value.argumentNames().first() == "$super") {
        var method = value, value = Object.extend((function(m) {
          return function() { if (isUndefined(ancestor[m])) return false; else return ancestor[m].apply(this, arguments);  };
        })(property).wrap(method), {
          valueOf:  function() { return method },
          toString: function() { return method.toString() }
        });
      }
      this.prototype[property] = value;
    }

    return this;
  }
};

var Abstract = { };

Object.extend = function(destination, source) {
  for (var property in source)
    destination[property] = source[property];
  return destination;
};

Object.extend(Object, {
  inspect: function(object) {
    try {
      if (Object.isUndefined(object)) return 'undefined';
      if (object === null) return 'null';
      return object.inspect ? object.inspect() : String(object);
    } catch (e) {
      if (e instanceof RangeError) return '...';
      throw e;
    }
  },

  toJSON: function(object) {
    var type = typeof object;
    switch (type) {
      case 'undefined':
      case 'function':
      case 'unknown': return;
      case 'boolean': return object.toString();
    }

    if (object === null) return 'null';
    if (object.toJSON) return object.toJSON();
    if (Object.isElement(object)) return;

    var results = [];
    for (var property in object) {
      var value = Object.toJSON(object[property]);
      if (!Object.isUndefined(value))
        results.push(property.toJSON() + ': ' + value);
    }

    return '{' + results.join(', ') + '}';
  },

  toQueryString: function(object) {
    return $H(object).toQueryString();
  },

  toHTML: function(object) {
    return object && object.toHTML ? object.toHTML() : String.interpret(object);
  },

  keys: function(object,bIgnoreFunc) {
    var keys = [];
    if (!bIgnoreFunc || isUndefined(bIgnoreFunc)) bIgnoreFunc = false;
    else bIgnoreFunc = true;
    for (var property in object)
      if (bIgnoreFunc && (isFunction(property) || isFunction(object[property]))) continue;
      else keys.push(property);
    return keys;
  },

  values: function(object) {
    var values = [];
    for (var property in object)
      values.push(object[property]);
    return values;
  },

  clone: function(object) {
    return Object.extend({ }, object);
  },

  isElement: function(object) {
    return object && object.nodeType == 1;
  },

  isArray: function(object) {
    return object != null && typeof object == "object" &&
      'splice' in object && 'join' in object;
  },

  isHash: function(object) {
    return object instanceof Hash;
  },

  isFunction: function(object) {
    return typeof object == "function";
  },

  isString: function(object) {
    return typeof object == "string";
  },

  isNumber: function(object) {
    return typeof object == "number";
  },

  isUndefined: function(object) {
    return typeof object == "undefined";
  }
});

Object.extend(Function.prototype, {
  argumentNames: function() {
    var names = this.toString().match(/^[\s\(]*function[^(]*\((.*?)\)/)[1].split(",").invoke("strip");
    return names.length == 1 && !names[0] ? [] : names;
  },

  bind: function() {
    if (arguments.length < 2 && Object.isUndefined(arguments[0])) return this;
    var __method = this, args = $A(arguments), object = args.shift();
    return function() {
      return __method.apply(object, args.concat($A(arguments)));
    }
  },

  bindAsEventListener: function() {
    var __method = this, args = $A(arguments), object = args.shift();
    return function(event) {
      return __method.apply(object, [event || window.event].concat(args));
    }
  },

  curry: function() {
    if (!arguments.length) return this;
    var __method = this, args = $A(arguments);
    return function() {
      return __method.apply(this, args.concat($A(arguments)));
    }
  },

  delay: function() {
    var __method = this, args = $A(arguments), timeout = args.shift() * 1000;
    return window.setTimeout(function() {
      return __method.apply(__method, args);
    }, timeout);
  },

  wrap: function(wrapper) {
    var __method = this;
    return function() {
      return wrapper.apply(this, [__method.bind(this)].concat($A(arguments)));
    }
  },

  methodize: function() {
    if (this._methodized) return this._methodized;
    var __method = this;
    return this._methodized = function() {
      return __method.apply(null, [this].concat($A(arguments)));
    };
  }
});

Function.prototype.defer = Function.prototype.delay.curry(0.01);

Date.prototype.toJSON = function() {
  return '"' + this.getUTCFullYear() + '-' +
    (this.getUTCMonth() + 1).toPaddedString(2) + '-' +
    this.getUTCDate().toPaddedString(2) + 'T' +
    this.getUTCHours().toPaddedString(2) + ':' +
    this.getUTCMinutes().toPaddedString(2) + ':' +
    this.getUTCSeconds().toPaddedString(2) + 'Z"';
};

var Try = {
  these: function() {
    var returnValue;

    for (var i = 0, length = arguments.length; i < length; i++) {
      var lambda = arguments[i];
      try {
        returnValue = lambda();
        break;
      } catch (e) { }
    }

    return returnValue;
  }
};

RegExp.prototype.match = RegExp.prototype.test;

RegExp.escape = function(str) {
  return String(str).replace(/([.*+?^=!:${}()|[\]\/\\])/g, '\\$1');
};

/*--------------------------------------------------------------------------*/

var PeriodicalExecuter = Class.create({
  initialize: function(callback, frequency) {
    this.callback = callback;
    this.frequency = frequency;
    this.currentlyExecuting = false;

    this.registerCallback();
  },

  registerCallback: function() {
    this.timer = setInterval(this.onTimerEvent.bind(this), this.frequency * 1000);
  },

  execute: function() {
    this.callback(this);
  },

  stop: function() {
    if (!this.timer) return;
    clearInterval(this.timer);
    this.timer = null;
  },

  onTimerEvent: function() {
    if (!this.currentlyExecuting) {
      try {
        this.currentlyExecuting = true;
        this.execute();
      } finally {
        this.currentlyExecuting = false;
      }
    }
  }
});
Object.extend(String, {
  interpret: function(value) {
    return value == null ? '' : String(value);
  },
  specialChar: {
    '\b': '\\b',
    '\t': '\\t',
    '\n': '\\n',
    '\f': '\\f',
    '\r': '\\r',
    '\\': '\\\\'
  }
});

Object.extend(String.prototype, {
  gsub: function(pattern, replacement) {
    var result = '', source = this, match;
    replacement = arguments.callee.prepareReplacement(replacement);

    while (source.length > 0) {
      if (match = source.match(pattern)) {
        result += source.slice(0, match.index);
        result += String.interpret(replacement(match));
        source  = source.slice(match.index + match[0].length);
      } else {
        result += source, source = '';
      }
    }
    return result;
  },

  sub: function(pattern, replacement, count) {
    replacement = this.gsub.prepareReplacement(replacement);
    count = Object.isUndefined(count) ? 1 : count;

    return this.gsub(pattern, function(match) {
      if (--count < 0) return match[0];
      return replacement(match);
    });
  },

  scan: function(pattern, iterator) {
    this.gsub(pattern, iterator);
    return String(this);
  },

  truncate: function(length, truncation) {
    length = length || 30;
    truncation = Object.isUndefined(truncation) ? '...' : truncation;
    return this.length > length ?
      this.slice(0, length - truncation.length) + truncation : String(this);
  },

  strip: function() {
    return this.replace(/^\s+/, '').replace(/\s+$/, '');
  },

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
    return this.extractScripts().map(function(script) { return eval(script) });
  },

  escapeHTML: function() {
    var self = arguments.callee;
    self.text.data = this;
    return self.div.innerHTML;
  },

  unescapeHTML: function() {
    var div = new Element('div');
    div.innerHTML = this.stripTags();
    return div.childNodes[0] ? (div.childNodes.length > 1 ?
      $A(div.childNodes).inject('', function(memo, node) { return memo+node.nodeValue }) :
      div.childNodes[0].nodeValue) : '';
  },

  toQueryParams: function(separator) {
    var match = this.strip().match(/([^?#]*)(#.*)?$/);
    if (!match) return { };

    return match[1].split(separator || '&').inject({ }, function(hash, pair) {
      if ((pair = pair.split('='))[0]) {
        var key = decodeURIComponent(pair.shift());
        var value = pair.length > 1 ? pair.join('=') : pair[0];
        if (value != undefined) value = decodeURIComponent(value);

        if (key in hash) {
          if (!Object.isArray(hash[key])) hash[key] = [hash[key]];
          hash[key].push(value);
        }
        else hash[key] = value;
      }
      return hash;
    });
  },

  toArray: function() {
    return this.split('');
  },

  succ: function() {
    return this.slice(0, this.length - 1) +
      String.fromCharCode(this.charCodeAt(this.length - 1) + 1);
  },

  times: function(count) {
    return count < 1 ? '' : new Array(count + 1).join(this);
  },

  camelize: function() {
    var parts = this.split('-'), len = parts.length;
    if (len == 1) return parts[0];

    var camelized = this.charAt(0) == '-'
      ? parts[0].charAt(0).toUpperCase() + parts[0].substring(1)
      : parts[0];

    for (var i = 1; i < len; i++)
      camelized += parts[i].charAt(0).toUpperCase() + parts[i].substring(1);

    return camelized;
  },

  capitalize: function() {
    return this.charAt(0).toUpperCase() + this.substring(1).toLowerCase();
  },

  underscore: function() {
    return this.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'#{1}_#{2}').gsub(/([a-z\d])([A-Z])/,'#{1}_#{2}').gsub(/-/,'_').toLowerCase();
  },

  dasherize: function() {
    return this.gsub(/_/,'-');
  },

  inspect: function(useDoubleQuotes) {
    var escapedString = this.gsub(/[\x00-\x1f\\]/, function(match) {
      var character = String.specialChar[match[0]];
      return character ? character : '\\u00' + match[0].charCodeAt().toPaddedString(2, 16);
    });
    if (useDoubleQuotes) return '"' + escapedString.replace(/"/g, '\\"') + '"';
    return "'" + escapedString.replace(/'/g, '\\\'') + "'";
  },

  toJSON: function() {
    return this.inspect(true);
  },

  unfilterJSON: function(filter) {
    return this.sub(filter || Prototype.JSONFilter, '#{1}');
  },

  isJSON: function() {
    var str = this;
    if (str.blank()) return false;
    str = this.replace(/\\./g, '@').replace(/"[^"\\\n\r]*"/g, '');
    return (/^[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]*$/).test(str);
  },

  evalJSON: function(sanitize) {
    var json = this.unfilterJSON();
    try {
      if (!sanitize || json.isJSON()) return eval('(' + json + ')');
    } catch (e) { }
    throw new SyntaxError('Badly formed JSON string: ' + this.inspect());
  },

  include: function(pattern) {
    return this.indexOf(pattern) > -1;
  },

  startsWith: function(pattern) {
    return this.indexOf(pattern) === 0;
  },

  endsWith: function(pattern) {
    var d = this.length - pattern.length;
    return d >= 0 && this.lastIndexOf(pattern) === d;
  },

  empty: function() {
    return this == '';
  },

  blank: function() {
    return /^\s*$/.test(this);
  },

  interpolate: function(object, pattern) {
    return new Template(this, pattern).evaluate(object);
  }
});

if (Prototype.Browser.WebKit || Prototype.Browser.IE) Object.extend(String.prototype, {
  escapeHTML: function() {
    return this.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  },
  unescapeHTML: function() {
    return this.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>');
  }
});

String.prototype.gsub.prepareReplacement = function(replacement) {
  if (Object.isFunction(replacement)) return replacement;
  var template = new Template(replacement);
  return function(match) { return template.evaluate(match) };
};

String.prototype.parseQuery = String.prototype.toQueryParams;

Object.extend(String.prototype.escapeHTML, {
  div:  document.createElement('div'),
  text: document.createTextNode('')
});

with (String.prototype.escapeHTML) div.appendChild(text);

var Template = Class.create({
  initialize: function(template, pattern) {
    this.template = template.toString();
    this.pattern = pattern || Template.Pattern;
  },

  evaluate: function(object) {
    if (Object.isFunction(object.toTemplateReplacements))
      object = object.toTemplateReplacements();

    return this.template.gsub(this.pattern, function(match) {
      if (object == null) return '';

      var before = match[1] || '';
      if (before == '\\') return match[2];

      var ctx = object, expr = match[3];
      var pattern = /^([^.[]+|\[((?:.*?[^\\])?)\])(\.|\[|$)/;
      match = pattern.exec(expr);
      if (match == null) return before;

      while (match != null) {
        var comp = match[1].startsWith('[') ? match[2].gsub('\\\\]', ']') : match[1];
        ctx = ctx[comp];
        if (null == ctx || '' == match[3]) break;
        expr = expr.substring('[' == match[3] ? match[1].length : match[0].length);
        match = pattern.exec(expr);
      }

      return before + String.interpret(ctx);
    });
  }
});
Template.Pattern = /(^|.|\r|\n)(#\{(.*?)\})/;

var $break = { };

var Enumerable = {
  each: function(iterator, context) {
    var index = 0;
    iterator = iterator.bind(context);
    try {
      this._each(function(value) {
        iterator(value, index++);
      });
    } catch (e) {
      if (e != $break) throw e;
    }
    return this;
  },

  eachSlice: function(number, iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var index = -number, slices = [], array = this.toArray();
    while ((index += number) < array.length)
      slices.push(array.slice(index, index+number));
    return slices.collect(iterator, context);
  },

  all: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var result = true;
    this.each(function(value, index) {
      result = result && !!iterator(value, index);
      if (!result) throw $break;
    });
    return result;
  },

  any: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var result = false;
    this.each(function(value, index) {
      if (result = !!iterator(value, index))
        throw $break;
    });
    return result;
  },

  collect: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var results = [];
    this.each(function(value, index) {
      results.push(iterator(value, index));
    });
    return results;
  },

  detect: function(iterator, context) {
    iterator = iterator.bind(context);
    var result;
    this.each(function(value, index) {
      if (iterator(value, index)) {
        result = value;
        throw $break;
      }
    });
    return result;
  },

  findAll: function(iterator, context) {
    iterator = iterator.bind(context);
    var results = [];
    this.each(function(value, index) {
      if (iterator(value, index))
        results.push(value);
    });
    return results;
  },

  grep: function(filter, iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var results = [];

    if (Object.isString(filter))
      filter = new RegExp(filter);

    this.each(function(value, index) {
      if (filter.match(value))
        results.push(iterator(value, index));
    });
    return results;
  },

  include: function(object) {
    if (Object.isFunction(this.indexOf))
      if (this.indexOf(object) != -1) return true;

    var found = false;
    this.each(function(value) {
      if (value == object) {
        found = true;
        throw $break;
      }
    });
    return found;
  },

  inGroupsOf: function(number, fillWith) {
    fillWith = Object.isUndefined(fillWith) ? null : fillWith;
    return this.eachSlice(number, function(slice) {
      while(slice.length < number) slice.push(fillWith);
      return slice;
    });
  },

  inject: function(memo, iterator, context) {
    iterator = iterator.bind(context);
    this.each(function(value, index) {
      memo = iterator(memo, value, index);
    });
    return memo;
  },

  invoke: function(method) {
    var args = $A(arguments).slice(1);
    return this.map(function(value) {
      return value[method].apply(value, args);
    });
  },

  max: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var result;
    this.each(function(value, index) {
      value = iterator(value, index);
      if (result == null || value >= result)
        result = value;
    });
    return result;
  },

  min: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var result;
    this.each(function(value, index) {
      value = iterator(value, index);
      if (result == null || value < result)
        result = value;
    });
    return result;
  },

  partition: function(iterator, context) {
    iterator = iterator ? iterator.bind(context) : Prototype.K;
    var trues = [], falses = [];
    this.each(function(value, index) {
      (iterator(value, index) ?
        trues : falses).push(value);
    });
    return [trues, falses];
  },

  pluck: function(property) {
    var results = [];
    this.each(function(value) {
      results.push(value[property]);
    });
    return results;
  },

  reject: function(iterator, context) {
    iterator = iterator.bind(context);
    var results = [];
    this.each(function(value, index) {
      if (!iterator(value, index))
        results.push(value);
    });
    return results;
  },

  sortBy: function(iterator, context) {
    iterator = iterator.bind(context);
    return this.map(function(value, index) {
      return {value: value, criteria: iterator(value, index)};
    }).sort(function(left, right) {
      var a = left.criteria, b = right.criteria;
      return a < b ? -1 : a > b ? 1 : 0;
    }).pluck('value');
  },

  toArray: function() {
    return this.map();
  },

  zip: function() {
    var iterator = Prototype.K, args = $A(arguments);
    if (Object.isFunction(args.last()))
      iterator = args.pop();

    var collections = [this].concat(args).map($A);
    return this.map(function(value, index) {
      return iterator(collections.pluck(index));
    });
  },

  size: function() {
    return this.toArray().length;
  },

  inspect: function() {
    return '#<Enumerable:' + this.toArray().inspect() + '>';
  }
};

Object.extend(Enumerable, {
  map:     Enumerable.collect,
  find:    Enumerable.detect,
  select:  Enumerable.findAll,
  filter:  Enumerable.findAll,
  member:  Enumerable.include,
  entries: Enumerable.toArray,
  every:   Enumerable.all,
  some:    Enumerable.any
});
function $A(iterable) {
  if (!iterable) return [];
  if (iterable.toArray) return iterable.toArray();
  var length = iterable.length || 0, results = new Array(length);
  while (length--) results[length] = iterable[length];
  return results;
}

if (Prototype.Browser.WebKit) {
  $A = function(iterable) {
    if (!iterable) return [];
    if (!(Object.isFunction(iterable) && iterable == '[object NodeList]') &&
        iterable.toArray) return iterable.toArray();
    var length = iterable.length || 0, results = new Array(length);
    while (length--) results[length] = iterable[length];
    return results;
  };
}

Array.from = $A;

Object.extend(Array.prototype, Enumerable);

if (!Array.prototype._reverse) Array.prototype._reverse = Array.prototype.reverse;

Object.extend(Array.prototype, {
  _each: function(iterator) {
    for (var i = 0, length = this.length; i < length; i++)
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
      return value != null;
    });
  },

  flatten: function() {
    return this.inject([], function(array, value) {
      return array.concat(Object.isArray(value) ?
        value.flatten() : [value]);
    });
  },

  without: function() {
    var values = $A(arguments);
    return this.select(function(value) {
      return !values.include(value);
    });
  },

  reverse: function(inline) {
    return (inline !== false ? this : this.toArray())._reverse();
  },

  reduce: function() {
    return this.length > 1 ? this : this[0];
  },

  uniq: function(sorted) {
    return this.inject([], function(array, value, index) {
      if (0 == index || (sorted ? array.last() != value : !array.include(value)))
        array.push(value);
      return array;
    });
  },

  intersect: function(array) {
    return this.uniq().findAll(function(item) {
      return array.detect(function(value) { return item === value });
    });
  },

  clone: function() {
    return [].concat(this);
  },

  size: function() {
    return this.length;
  },

  inspect: function() {
    return '[' + this.map(Object.inspect).join(', ') + ']';
  },

  toJSON: function() {
    var results = [];
    this.each(function(object) {
      var value = Object.toJSON(object);
      if (!Object.isUndefined(value)) results.push(value);
    });
    return '[' + results.join(', ') + ']';
  }
});

// use native browser JS 1.6 implementation if available
if (Object.isFunction(Array.prototype.forEach))
  Array.prototype._each = Array.prototype.forEach;

if (!Array.prototype.indexOf) Array.prototype.indexOf = function(item, i) {
  i || (i = 0);
  var length = this.length;
  if (i < 0) i = length + i;
  for (; i < length; i++)
    if (this[i] === item) return i;
  return -1;
};

if (!Array.prototype.lastIndexOf) Array.prototype.lastIndexOf = function(item, i) {
  i = isNaN(i) ? this.length : (i < 0 ? this.length + i : i) + 1;
  var n = this.slice(0, i).reverse().indexOf(item);
  return (n < 0) ? n : i - n - 1;
};

Array.prototype.toArray = Array.prototype.clone;

function $w(string) {
  if (!Object.isString(string)) return [];
  string = string.strip();
  return string ? string.split(/\s+/) : [];
}

if (Prototype.Browser.Opera){
  Array.prototype.concat = function() {
    var array = [];
    for (var i = 0, length = this.length; i < length; i++) array.push(this[i]);
    for (var i = 0, length = arguments.length; i < length; i++) {
      if (Object.isArray(arguments[i])) {
        for (var j = 0, arrayLength = arguments[i].length; j < arrayLength; j++)
          array.push(arguments[i][j]);
      } else {
        array.push(arguments[i]);
      }
    }
    return array;
  };
}
Object.extend(Number.prototype, {
  toColorPart: function() {
    return this.toPaddedString(2, 16);
  },

  succ: function() {
    return this + 1;
  },

  times: function(iterator) {
    $R(0, this, true).each(iterator);
    return this;
  },

  toPaddedString: function(length, radix) {
    var string = this.toString(radix || 10);
    return '0'.times(length - string.length) + string;
  },

  toJSON: function() {
    return isFinite(this) ? this.toString() : 'null';
  }
});

$w('abs round ceil floor').each(function(method){
  Number.prototype[method] = Math[method].methodize();
});
function $H(object) {
  return new Hash(object);
};

var Hash = Class.create(Enumerable, (function() {

  function toQueryPair(key, value) {
    if (Object.isUndefined(value)) return key;
    return key + '=' + encodeURIComponent(String.interpret(value));
  }

  return {
    initialize: function(object) {
      this._object = Object.isHash(object) ? object.toObject() : Object.clone(object);
    },

    _each: function(iterator) {
      for (var key in this._object) {
        var value = this._object[key], pair = [key, value];
        pair.key = key;
        pair.value = value;
        iterator(pair);
      }
    },

    set: function(key, value) {
      return this._object[key] = value;
    },

    get: function(key) {
      return this._object[key];
    },

    unset: function(key) {
      var value = this._object[key];
      delete this._object[key];
      return value;
    },

    toObject: function() {
      return Object.clone(this._object);
    },

    keys: function() {
      return this.pluck('key');
    },

    values: function() {
      return this.pluck('value');
    },

    index: function(value) {
      var match = this.detect(function(pair) {
        return pair.value === value;
      });
      return match && match.key;
    },

    merge: function(object) {
      return this.clone().update(object);
    },

    update: function(object) {
      return new Hash(object).inject(this, function(result, pair) {
        result.set(pair.key, pair.value);
        return result;
      });
    },

    toQueryString: function() {
      return this.map(function(pair) {
        var key = encodeURIComponent(pair.key), values = pair.value;

        if (values && typeof values == 'object') {
          if (Object.isArray(values))
            return values.map(toQueryPair.curry(key)).join('&');
        }
        return toQueryPair(key, values);
      }).join('&');
    },

    inspect: function() {
      return '#<Hash:{' + this.map(function(pair) {
        return pair.map(Object.inspect).join(': ');
      }).join(', ') + '}>';
    },

    toJSON: function() {
      return Object.toJSON(this.toObject());
    },

    clone: function() {
      return new Hash(this);
    }
  }
})());

Hash.prototype.toTemplateReplacements = Hash.prototype.toObject;
Hash.from = $H;
var ObjectRange = Class.create(Enumerable, {
  initialize: function(start, end, exclusive) {
    this.start = start;
    this.end = end;
    this.exclusive = exclusive;
  },

  _each: function(iterator) {
    var value = this.start;
    while (this.include(value)) {
      iterator(value);
      value = value.succ();
    }
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
};

var Ajax = {
  getTransport: function() {
    return Try.these(
      function() {return new XMLHttpRequest()},
      function() {return new ActiveXObject('Msxml2.XMLHTTP')},
      function() {return new ActiveXObject('Microsoft.XMLHTTP')}
    ) || false;
  },

  activeRequestCount: 0
};

Ajax.Responders = {
  responders: [],

  _each: function(iterator) {
    this.responders._each(iterator);
  },

  register: function(responder) {
    if (!this.include(responder))
      this.responders.push(responder);
  },

  unregister: function(responder) {
    this.responders = this.responders.without(responder);
  },

  dispatch: function(callback, request, transport, json) {
    this.each(function(responder) {
      if (Object.isFunction(responder[callback])) {
        try {
          responder[callback].apply(responder, [request, transport, json]);
        } catch (e) { }
      }
    });
  }
};

Object.extend(Ajax.Responders, Enumerable);

Ajax.Responders.register({
  onCreate:   function() { Ajax.activeRequestCount++ },
  onComplete: function() { Ajax.activeRequestCount-- }
});

Ajax.Base = Class.create({
  initialize: function(options) {
    this.options = {
      method:       'post',
      asynchronous: true,
      contentType:  'application/x-www-form-urlencoded',
      encoding:     'UTF-8',
      parameters:   '',
      evalJSON:     true,
      evalJS:       true
    };
    Object.extend(this.options, options || { });

    this.options.method = this.options.method.toLowerCase();

    if (Object.isString(this.options.parameters))
      this.options.parameters = this.options.parameters.toQueryParams();
    else if (Object.isHash(this.options.parameters))
      this.options.parameters = this.options.parameters.toObject();
  }
});

Ajax.Request = Class.create(Ajax.Base, {
  _complete: false,

  initialize: function($super, url, options) {
    $super(options);
    this.transport = Ajax.getTransport();
    this.request(url);
  },

  request: function(url) {
    this.url = url;
    this.method = this.options.method;
    var params = Object.clone(this.options.parameters);

    if (!['get', 'post'].include(this.method)) {
      // simulate other verbs over post
      params['_method'] = this.method;
      this.method = 'post';
    }

    this.parameters = params;

    if (params = Object.toQueryString(params)) {
      // when GET, append parameters to URL
      if (this.method == 'get')
        this.url += (this.url.include('?') ? '&' : '?') + params;
      else if (/Konqueror|Safari|KHTML/.test(navigator.userAgent))
        params += '&_=';
    }

    try {
      var response = new Ajax.Response(this);
      if (this.options.onCreate) this.options.onCreate(response);
      Ajax.Responders.dispatch('onCreate', this, response);

      this.transport.open(this.method.toUpperCase(), this.url,
        this.options.asynchronous);

      if (this.options.asynchronous) this.respondToReadyState.bind(this).defer(1);

      this.transport.onreadystatechange = this.onStateChange.bind(this);
      this.setRequestHeaders();

      this.body = this.method == 'post' ? (this.options.postBody || params) : null;
      this.transport.send(this.body);

      /* Force Firefox to handle ready state 4 for synchronous requests */
      if (!this.options.asynchronous && this.transport.overrideMimeType)
        this.onStateChange();

    }
    catch (e) {
      this.dispatchException(e);
    }
  },

  onStateChange: function() {
    var readyState = this.transport.readyState;
    if (readyState > 1 && !((readyState == 4) && this._complete))
      this.respondToReadyState(this.transport.readyState);
  },

  setRequestHeaders: function() {
    var headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'X-Prototype-Version': Prototype.Version,
      'Accept': 'text/javascript, text/html, application/xml, text/xml, */*'
    };

    if (this.method == 'post') {
      headers['Content-type'] = this.options.contentType +
        (this.options.encoding ? '; charset=' + this.options.encoding : '');

      /* Force "Connection: close" for older Mozilla browsers to work
       * around a bug where XMLHttpRequest sends an incorrect
       * Content-length header. See Mozilla Bugzilla #246651.
       */
      if (this.transport.overrideMimeType &&
          (navigator.userAgent.match(/Gecko\/(\d{4})/) || [0,2005])[1] < 2005)
            headers['Connection'] = 'close';
    }

    // user-defined headers
    if (typeof this.options.requestHeaders == 'object') {
      var extras = this.options.requestHeaders;

      if (Object.isFunction(extras.push))
        for (var i = 0, length = extras.length; i < length; i += 2)
          headers[extras[i]] = extras[i+1];
      else
        $H(extras).each(function(pair) { headers[pair.key] = pair.value });
    }

    for (var name in headers) {
      if (isFunction(headers[name])) continue;
      this.transport.setRequestHeader(name, headers[name]);
    }
  },

  success: function() {
    var status = this.getStatus();
    return !status || (status >= 200 && status < 300);
  },

  getStatus: function() {
    try {
      return this.transport.status || 0;
    } catch (e) { return 0 }
  },

  respondToReadyState: function(readyState) {
    var state = Ajax.Request.Events[readyState], response = new Ajax.Response(this);

    if (state == 'Complete') {
      try {
        this._complete = true;
        (this.options['on' + response.status]
         || this.options['on' + (this.success() ? 'Success' : 'Failure')]
         || Prototype.emptyFunction)(response, response.headerJSON);
      } catch (e) {
        this.dispatchException(e);
      }

      var contentType = response.getHeader('Content-type');
      if (this.options.evalJS == 'force'
          || (this.options.evalJS && this.isSameOrigin() && contentType
          && contentType.match(/^\s*(text|application)\/(x-)?(java|ecma)script(;.*)?\s*$/i)))
        this.evalResponse();
    }

    try {
      (this.options['on' + state] || Prototype.emptyFunction)(response, response.headerJSON);
      Ajax.Responders.dispatch('on' + state, this, response, response.headerJSON);
    } catch (e) {
      this.dispatchException(e);
    }

    if (state == 'Complete') {
      // avoid memory leak in MSIE: clean up
      this.transport.onreadystatechange = Prototype.emptyFunction;
    }
  },

  isSameOrigin: function() {
    var m = this.url.match(/^\s*https?:\/\/[^\/]*/);
    return !m || (m[0] == '#{protocol}//#{domain}#{port}'.interpolate({
      protocol: location.protocol,
      domain: document.domain,
      port: location.port ? ':' + location.port : ''
    }));
  },

  getHeader: function(name) {
    try {
      return this.transport.getResponseHeader(name) || null;
    } catch (e) { return null }
  },

  evalResponse: function() {
    try {
      return eval((this.transport.responseText || '').unfilterJSON());
    } catch (e) {
      this.dispatchException(e);
    }
  },

  dispatchException: function(exception) {
    (this.options.onException || Prototype.emptyFunction)(this, exception);
    Ajax.Responders.dispatch('onException', this, exception);
  }
});

Ajax.Request.Events =
  ['Uninitialized', 'Loading', 'Loaded', 'Interactive', 'Complete'];

Ajax.Response = Class.create({
  initialize: function(request){
    this.request = request;
    var transport  = this.transport  = request.transport,
        readyState = this.readyState = transport.readyState;

    if((readyState > 2 && !Prototype.Browser.IE) || readyState == 4) {
      this.status       = this.getStatus();
      this.statusText   = this.getStatusText();
      this.responseText = String.interpret(transport.responseText);
      this.headerJSON   = this._getHeaderJSON();
    }

    if(readyState == 4) {
      var xml = transport.responseXML;
      this.responseXML  = Object.isUndefined(xml) ? null : xml;
      this.responseJSON = this._getResponseJSON();
    }
  },

  status:      0,
  statusText: '',

  getStatus: Ajax.Request.prototype.getStatus,

  getStatusText: function() {
    try {
      return this.transport.statusText || '';
    } catch (e) { return '' }
  },

  getHeader: Ajax.Request.prototype.getHeader,

  getAllHeaders: function() {
    try {
      return this.getAllResponseHeaders();
    } catch (e) { return null }
  },

  getResponseHeader: function(name) {
    return this.transport.getResponseHeader(name);
  },

  getAllResponseHeaders: function() {
    return this.transport.getAllResponseHeaders();
  },

  _getHeaderJSON: function() {
    var json = this.getHeader('X-JSON');
    if (!json) return null;
    json = decodeURIComponent(escape(json));
    try {
      return json.evalJSON(this.request.options.sanitizeJSON ||
        !this.request.isSameOrigin());
    } catch (e) {
      this.request.dispatchException(e);
    }
  },

  _getResponseJSON: function() {
    var options = this.request.options;
    if (!options.evalJSON || (options.evalJSON != 'force' &&
      !(this.getHeader('Content-type') || '').include('application/json')) ||
        this.responseText.blank())
          return null;
    try {
      return this.responseText.evalJSON(options.sanitizeJSON ||
        !this.request.isSameOrigin());
    } catch (e) {
      this.request.dispatchException(e);
    }
  }
});

Ajax.Updater = Class.create(Ajax.Request, {
  initialize: function($super, container, url, options) {
    this.container = {
      success: (container.success || container),
      failure: (container.failure || (container.success ? null : container))
    };

    options = Object.clone(options);
    var onComplete = options.onComplete;
    options.onComplete = (function(response, json) {
      this.updateContent(response.responseText);
      if (Object.isFunction(onComplete)) onComplete(response, json);
    }).bind(this);

    $super(url, options);
  },

  updateContent: function(responseText) {
    var receiver = this.container[this.success() ? 'success' : 'failure'],
        options = this.options;

    if (!options.evalScripts) responseText = responseText.stripScripts();

    if (receiver = $(receiver)) {
      if (options.insertion) {
        if (Object.isString(options.insertion)) {
          var insertion = { }; insertion[options.insertion] = responseText;
          receiver.insert(insertion);
        }
        else options.insertion(receiver, responseText);
      }
      else receiver.update(responseText);
    }
  }
});

Ajax.PeriodicalUpdater = Class.create(Ajax.Base, {
  initialize: function($super, container, url, options) {
    $super(options);
    this.onComplete = this.options.onComplete;

    this.frequency = (this.options.frequency || 2);
    this.decay = (this.options.decay || 1);

    this.updater = { };
    this.container = container;
    this.url = url;

    this.start();
  },

  start: function() {
    this.options.onComplete = this.updateComplete.bind(this);
    this.onTimerEvent();
  },

  stop: function() {
    this.updater.options.onComplete = undefined;
    clearTimeout(this.timer);
    (this.onComplete || Prototype.emptyFunction).apply(this, arguments);
  },

  updateComplete: function(response) {
    if (this.options.decay) {
      this.decay = (response.responseText == this.lastText ?
        this.decay * this.options.decay : 1);

      this.lastText = response.responseText;
    }
    this.timer = this.onTimerEvent.bind(this).delay(this.decay * this.frequency);
  },

  onTimerEvent: function() {
    this.updater = new Ajax.Updater(this.container, this.url, this.options);
  }
});
function $(element) {
  if (arguments.length > 1) {
    for (var i = 0, elements = [], length = arguments.length; i < length; i++)
      elements.push($(arguments[i]));
    return elements;
  }
  if (Object.isString(element))
    element = document.getElementById(element);
  return Element.extend(element);
}

if (Prototype.BrowserFeatures.XPath) {
  document._getElementsByXPath = function(expression, parentElement) {
    var results = [];
    var query = document.evaluate(expression, $(parentElement) || document,
      null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    for (var i = 0, length = query.snapshotLength; i < length; i++)
      results.push(Element.extend(query.snapshotItem(i)));
    return results;
  };
}

/*--------------------------------------------------------------------------*/

if (!window.Node) var Node = { };

if (!Node.ELEMENT_NODE) {
  // DOM level 2 ECMAScript Language Binding
  Object.extend(Node, {
    ELEMENT_NODE: 1,
    ATTRIBUTE_NODE: 2,
    TEXT_NODE: 3,
    CDATA_SECTION_NODE: 4,
    ENTITY_REFERENCE_NODE: 5,
    ENTITY_NODE: 6,
    PROCESSING_INSTRUCTION_NODE: 7,
    COMMENT_NODE: 8,
    DOCUMENT_NODE: 9,
    DOCUMENT_TYPE_NODE: 10,
    DOCUMENT_FRAGMENT_NODE: 11,
    NOTATION_NODE: 12
  });
}

(function() {
  var element = this.Element;
  this.Element = function(tagName, attributes) {
    attributes = attributes || { };
    tagName = tagName.toLowerCase();
    var cache = Element.cache;
    if (Prototype.Browser.IE && attributes.name) {
      tagName = '<' + tagName + ' name="' + attributes.name + '">';
      delete attributes.name;
      return Element.writeAttribute(document.createElement(tagName), attributes);
    }
    if (!cache[tagName]) cache[tagName] = Element.extend(document.createElement(tagName));
    return Element.writeAttribute(cache[tagName].cloneNode(false), attributes);
  };
  Object.extend(this.Element, element || { });
}).call(window);

Element.cache = { };

Element.Methods = {
  visible: function(element) {
    return $(element).style.display != 'none';
  },

  toggle: function(element) {
    element = $(element);
    Element[Element.visible(element) ? 'hide' : 'show'](element);
    return element;
  },

  hide: function(element) {
    $(element).style.display = 'none';
    return element;
  },

  show: function(element) {
    $(element).style.display = '';
    return element;
  },

  remove: function(element) {
    element = $(element);
    element.parentNode.removeChild(element);
    return element;
  },

  update: function(element, content) {
    element = $(element);
    if (content && content.toElement) content = content.toElement();
    if (Object.isElement(content)) return element.update().insert(content);
    content = Object.toHTML(content);
    element.innerHTML = content.stripScripts();
    content.evalScripts.bind(content).defer();
    return element;
  },

  replace: function(element, content) {
    element = $(element);
    if (content && content.toElement) content = content.toElement();
    else if (!Object.isElement(content)) {
      content = Object.toHTML(content);
      var range = element.ownerDocument.createRange();
      range.selectNode(element);
      content.evalScripts.bind(content).defer();
      content = range.createContextualFragment(content.stripScripts());
    }
    element.parentNode.replaceChild(content, element);
    return element;
  },

  insert: function(element, insertions) {
    element = $(element);

    if (Object.isString(insertions) || Object.isNumber(insertions) ||
        Object.isElement(insertions) || (insertions && (insertions.toElement || insertions.toHTML)))
          insertions = {bottom:insertions};

    var content, insert, tagName, childNodes;

    for (var position in insertions) {
      content  = insertions[position];
      position = position.toLowerCase();
      insert = Element._insertionTranslations[position];

      if (content && content.toElement) content = content.toElement();
      if (Object.isElement(content)) {
        insert(element, content);
        continue;
      }

      content = Object.toHTML(content);

      tagName = ((position == 'before' || position == 'after')
        ? element.parentNode : element).tagName.toUpperCase();

      childNodes = Element._getContentFromAnonymousElement(tagName, content.stripScripts());

      if (position == 'top' || position == 'after') childNodes.reverse();
      childNodes.each(insert.curry(element));

      content.evalScripts.bind(content).defer();
    }

    return element;
  },

  wrap: function(element, wrapper, attributes) {
    element = $(element);
    if (Object.isElement(wrapper))
      $(wrapper).writeAttribute(attributes || { });
    else if (Object.isString(wrapper)) wrapper = new Element(wrapper, attributes);
    else wrapper = new Element('div', wrapper);
    if (element.parentNode)
      element.parentNode.replaceChild(wrapper, element);
    wrapper.appendChild(element);
    return wrapper;
  },

  inspect: function(element) {
    element = $(element);
    var result = '<' + element.tagName.toLowerCase();
    $H({'id': 'id', 'className': 'class'}).each(function(pair) {
      var property = pair.first(), attribute = pair.last();
      var value = (element[property] || '').toString();
      if (value) result += ' ' + attribute + '=' + value.inspect(true);
    });
    return result + '>';
  },

  recursivelyCollect: function(element, property) {
    element = $(element);
    var elements = [];
    while (element = element[property])
      if (element.nodeType == 1)
        elements.push(Element.extend(element));
    return elements;
  },

  ancestors: function(element) {
    return $(element).recursivelyCollect('parentNode');
  },

  descendants: function(element) {
    return $(element).select("*");
  },

  firstDescendant: function(element) {
    element = $(element).firstChild;
    while (element && element.nodeType != 1) element = element.nextSibling;
    return $(element);
  },

  immediateDescendants: function(element) {
    if (!(element = $(element).firstChild)) return [];
    while (element && element.nodeType != 1) element = element.nextSibling;
    if (element) return [element].concat($(element).nextSiblings());
    return [];
  },

  previousSiblings: function(element) {
    return $(element).recursivelyCollect('previousSibling');
  },

  nextSiblings: function(element) {
    return $(element).recursivelyCollect('nextSibling');
  },

  siblings: function(element) {
    element = $(element);
    return element.previousSiblings().reverse().concat(element.nextSiblings());
  },

  match: function(element, selector) {
    if (Object.isString(selector))
      selector = new Selector(selector);
    return selector.match($(element));
  },

  up: function(element, expression, index) {
    element = $(element);
    if (arguments.length == 1) return $(element.parentNode);
    var ancestors = element.ancestors();
    return Object.isNumber(expression) ? ancestors[expression] :
      Selector.findElement(ancestors, expression, index);
  },

  down: function(element, expression, index) {
    element = $(element);
    if (arguments.length == 1) return element.firstDescendant();
    return Object.isNumber(expression) ? element.descendants()[expression] :
      element.select(expression)[index || 0];
  },

  previous: function(element, expression, index) {
    element = $(element);
    if (arguments.length == 1) return $(Selector.handlers.previousElementSibling(element));
    var previousSiblings = element.previousSiblings();
    return Object.isNumber(expression) ? previousSiblings[expression] :
      Selector.findElement(previousSiblings, expression, index);
  },

  next: function(element, expression, index) {
    element = $(element);
    if (arguments.length == 1) return $(Selector.handlers.nextElementSibling(element));
    var nextSiblings = element.nextSiblings();
    return Object.isNumber(expression) ? nextSiblings[expression] :
      Selector.findElement(nextSiblings, expression, index);
  },

  select: function() {
    var args = $A(arguments), element = $(args.shift());
    return Selector.findChildElements(element, args);
  },

  adjacent: function() {
    var args = $A(arguments), element = $(args.shift());
    return Selector.findChildElements(element.parentNode, args).without(element);
  },

  identify: function(element) {
    element = $(element);
    var id = element.readAttribute('id'), self = arguments.callee;
    if (id) return id;
    do { id = 'anonymous_element_' + self.counter++ } while ($(id));
    element.writeAttribute('id', id);
    return id;
  },

  readAttribute: function(element, name) {
    element = $(element);
    if (Prototype.Browser.IE) {
      var t = Element._attributeTranslations.read;
      if (t.values[name]) return t.values[name](element, name);
      if (t.names[name]) name = t.names[name];
      if (name.include(':')) {
        return (!element.attributes || !element.attributes[name]) ? null :
         element.attributes[name].value;
      }
    }
    return element.getAttribute(name);
  },

  writeAttribute: function(element, name, value) {
    element = $(element);
    var attributes = { }, t = Element._attributeTranslations.write;

    if (typeof name == 'object') attributes = name;
    else attributes[name] = Object.isUndefined(value) ? true : value;

    for (var attr in attributes) {
      name = t.names[attr] || attr;
      value = attributes[attr];
      if (t.values[attr]) name = t.values[attr](element, value);
      if (value === false || value === null)
        element.removeAttribute(name);
      else if (value === true)
        element.setAttribute(name, name);
      else element.setAttribute(name, value);
    }
    return element;
  },

  getHeight: function(element) {
    return $(element).getDimensions().height;
  },

  getWidth: function(element) {
    return $(element).getDimensions().width;
  },

  classNames: function(element) {
    return new Element.ClassNames(element);
  },

  hasClassName: function(element, className) {
    if (!(element = $(element))) return;
    var elementClassName = element.className;
    return (elementClassName.length > 0 && (elementClassName == className ||
      new RegExp("(^|\\s)" + className + "(\\s|$)").test(elementClassName)));
  },

  addClassName: function(element, className) {
    if (!(element = $(element))) return;
    if (!element.hasClassName(className))
      element.className += (element.className ? ' ' : '') + className;
    return element;
  },

  removeClassName: function(element, className) {
    if (!(element = $(element))) return;
    element.className = element.className.replace(
      new RegExp("(^|\\s+)" + className + "(\\s+|$)"), ' ').strip();
    return element;
  },

  toggleClassName: function(element, className) {
    if (!(element = $(element))) return;
    return element[element.hasClassName(className) ?
      'removeClassName' : 'addClassName'](className);
  },

  // removes whitespace-only text node children
  cleanWhitespace: function(element) {
    element = $(element);
    var node = element.firstChild;
    while (node) {
      var nextNode = node.nextSibling;
      if (node.nodeType == 3 && !/\S/.test(node.nodeValue))
        element.removeChild(node);
      node = nextNode;
    }
    return element;
  },

  empty: function(element) {
    return $(element).innerHTML.blank();
  },

  descendantOf: function(element, ancestor) {
    element = $(element), ancestor = $(ancestor);
    var originalAncestor = ancestor;

    if (element.compareDocumentPosition)
      return (element.compareDocumentPosition(ancestor) & 8) === 8;

    if (element.sourceIndex && !Prototype.Browser.Opera) {
      var e = element.sourceIndex, a = ancestor.sourceIndex,
       nextAncestor = ancestor.nextSibling;
      if (!nextAncestor) {
        do { ancestor = ancestor.parentNode; }
        while (!(nextAncestor = ancestor.nextSibling) && ancestor.parentNode);
      }
      if (nextAncestor && nextAncestor.sourceIndex)
       return (e > a && e < nextAncestor.sourceIndex);
    }

    while (element = element.parentNode)
      if (element == originalAncestor) return true;
    return false;
  },

  scrollTo: function(element) {
    element = $(element);
    var pos = element.cumulativeOffset();
    window.scrollTo(pos[0], pos[1]);
    return element;
  },

  getStyle: function(element, style) {
    element = $(element);
    style = style == 'float' ? 'cssFloat' : style.camelize();
    var value = element.style[style];
    if (!value) {
      var css = document.defaultView.getComputedStyle(element, null);
      value = css ? css[style] : null;
    }
    if (style == 'opacity') return value ? parseFloat(value) : 1.0;
    return value == 'auto' ? null : value;
  },

  getOpacity: function(element) {
    return $(element).getStyle('opacity');
  },

  setStyle: function(element, styles) {
    element = $(element);
    var elementStyle = element.style, match;
    if (Object.isString(styles)) {
      element.style.cssText += ';' + styles;
      return styles.include('opacity') ?
        element.setOpacity(styles.match(/opacity:\s*(\d?\.?\d*)/)[1]) : element;
    }
    for (var property in styles)
      if (property == 'opacity') element.setOpacity(styles[property]);
      else
        elementStyle[(property == 'float' || property == 'cssFloat') ?
          (Object.isUndefined(elementStyle.styleFloat) ? 'cssFloat' : 'styleFloat') :
            property] = styles[property];

    return element;
  },

  setOpacity: function(element, value) {
    element = $(element);
    element.style.opacity = (value == 1 || value === '') ? '' :
      (value < 0.00001) ? 0 : value;
    return element;
  },

  getDimensions: function(element) {
    element = $(element);
    var display = $(element).getStyle('display');
    if (display != 'none' && display != null) // Safari bug
      return {width: element.offsetWidth, height: element.offsetHeight};

    // All *Width and *Height properties give 0 on elements with display none,
    // so enable the element temporarily
    var els = element.style;
    var originalVisibility = els.visibility;
    var originalPosition = els.position;
    var originalDisplay = els.display;
    els.visibility = 'hidden';
    els.position = 'absolute';
    els.display = 'block';
    var originalWidth = element.clientWidth;
    var originalHeight = element.clientHeight;
    els.display = originalDisplay;
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
    return element;
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
    return element;
  },

  makeClipping: function(element) {
    element = $(element);
    if (element._overflow) return element;
    element._overflow = Element.getStyle(element, 'overflow') || 'auto';
    if (element._overflow !== 'hidden')
      element.style.overflow = 'hidden';
    return element;
  },

  undoClipping: function(element) {
    element = $(element);
    if (!element._overflow) return element;
    element.style.overflow = element._overflow == 'auto' ? '' : element._overflow;
    element._overflow = null;
    return element;
  },

  cumulativeOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      element = element.offsetParent;
    } while (element);
    return Element._returnOffset(valueL, valueT);
  },

  positionedOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      element = element.offsetParent;
      if (element) {
        if (element.tagName == 'BODY') break;
        var p = Element.getStyle(element, 'position');
        if (p !== 'static') break;
      }
    } while (element);
    return Element._returnOffset(valueL, valueT);
  },

  absolutize: function(element) {
    element = $(element);
    if (element.getStyle('position') == 'absolute') return;
    // Position.prepare(); // To be done manually by Scripty when it needs it.

    var offsets = element.positionedOffset();
    var top     = offsets[1];
    var left    = offsets[0];
    var width   = element.clientWidth;
    var height  = element.clientHeight;

    element._originalLeft   = left - parseFloat(element.style.left  || 0);
    element._originalTop    = top  - parseFloat(element.style.top || 0);
    element._originalWidth  = element.style.width;
    element._originalHeight = element.style.height;

    element.style.position = 'absolute';
    element.style.top    = top + 'px';
    element.style.left   = left + 'px';
    element.style.width  = width + 'px';
    element.style.height = height + 'px';
    return element;
  },

  relativize: function(element) {
    element = $(element);
    if (element.getStyle('position') == 'relative') return;
    // Position.prepare(); // To be done manually by Scripty when it needs it.

    element.style.position = 'relative';
    var top  = parseFloat(element.style.top  || 0) - (element._originalTop || 0);
    var left = parseFloat(element.style.left || 0) - (element._originalLeft || 0);

    element.style.top    = top + 'px';
    element.style.left   = left + 'px';
    element.style.height = element._originalHeight;
    element.style.width  = element._originalWidth;
    return element;
  },

  cumulativeScrollOffset: function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.scrollTop  || 0;
      valueL += element.scrollLeft || 0;
      element = element.parentNode;
    } while (element);
    return Element._returnOffset(valueL, valueT);
  },

  getOffsetParent: function(element) {
    if (element.offsetParent) return $(element.offsetParent);
    if (element == document.body) return $(element);

    while ((element = element.parentNode) && element != document.body)
      if (Element.getStyle(element, 'position') != 'static')
        return $(element);

    return $(document.body);
  },

  viewportOffset: function(forElement) {
    var valueT = 0, valueL = 0;

    var element = forElement;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;

      // Safari fix
      if (element.offsetParent == document.body &&
        Element.getStyle(element, 'position') == 'absolute') break;

    } while (element = element.offsetParent);

    element = forElement;
    do {
      if (!Prototype.Browser.Opera || element.tagName == 'BODY') {
        valueT -= element.scrollTop  || 0;
        valueL -= element.scrollLeft || 0;
      }
    } while (element = element.parentNode);

    return Element._returnOffset(valueL, valueT);
  },

  clonePosition: function(element, source) {
    var options = Object.extend({
      setLeft:    true,
      setTop:     true,
      setWidth:   true,
      setHeight:  true,
      offsetTop:  0,
      offsetLeft: 0
    }, arguments[2] || { });

    // find page position of source
    source = $(source);
    var p = source.viewportOffset();

    // find coordinate system to use
    element = $(element);
    var delta = [0, 0];
    var parent = null;
    // delta [0,0] will do fine with position: fixed elements,
    // position:absolute needs offsetParent deltas
    if (Element.getStyle(element, 'position') == 'absolute') {
      parent = element.getOffsetParent();
      delta = parent.viewportOffset();
    }

    // correct by body offsets (fixes Safari)
    if (parent == document.body) {
      delta[0] -= document.body.offsetLeft;
      delta[1] -= document.body.offsetTop;
    }

    // set position
    if (options.setLeft)   element.style.left  = (p[0] - delta[0] + options.offsetLeft) + 'px';
    if (options.setTop)    element.style.top   = (p[1] - delta[1] + options.offsetTop) + 'px';
    if (options.setWidth)  element.style.width = source.offsetWidth + 'px';
    if (options.setHeight) element.style.height = source.offsetHeight + 'px';
    return element;
  }
};

Element.Methods.identify.counter = 1;

Object.extend(Element.Methods, {
  getElementsBySelector: Element.Methods.select,
  childElements: Element.Methods.immediateDescendants
});

Element._attributeTranslations = {
  write: {
    names: {
      className: 'class',
      htmlFor:   'for'
    },
    values: { }
  }
};

if (Prototype.Browser.Opera) {
  Element.Methods.getStyle = Element.Methods.getStyle.wrap(
    function(proceed, element, style) {
      switch (style) {
        case 'left': case 'top': case 'right': case 'bottom':
          if (proceed(element, 'position') === 'static') return null;
        case 'height': case 'width':
          // returns '0px' for hidden elements; we want it to return null
          if (!Element.visible(element)) return null;

          // returns the border-box dimensions rather than the content-box
          // dimensions, so we subtract padding and borders from the value
          var dim = parseInt(proceed(element, style), 10);

          if (dim !== element['offset' + style.capitalize()])
            return dim + 'px';

          var properties;
          if (style === 'height') {
            properties = ['border-top-width', 'padding-top',
             'padding-bottom', 'border-bottom-width'];
          }
          else {
            properties = ['border-left-width', 'padding-left',
             'padding-right', 'border-right-width'];
          }
          return properties.inject(dim, function(memo, property) {
            var val = proceed(element, property);
            return val === null ? memo : memo - parseInt(val, 10);
          }) + 'px';
        default: return proceed(element, style);
      }
    }
  );

  Element.Methods.readAttribute = Element.Methods.readAttribute.wrap(
    function(proceed, element, attribute) {
      if (attribute === 'title') return element.title;
      return proceed(element, attribute);
    }
  );
}

else if (Prototype.Browser.IE) {
  // IE doesn't report offsets correctly for static elements, so we change them
  // to "relative" to get the values, then change them back.
  Element.Methods.getOffsetParent = Element.Methods.getOffsetParent.wrap(
    function(proceed, element) {
      element = $(element);
      var position = element.getStyle('position');
      if (position !== 'static') return proceed(element);
      element.setStyle({ position: 'relative' });
      var value = proceed(element);
      element.setStyle({ position: position });
      return value;
    }
  );

  $w('positionedOffset viewportOffset').each(function(method) {
    Element.Methods[method] = Element.Methods[method].wrap(
      function(proceed, element) {
        element = $(element);
        var position = element.getStyle('position');
        if (position !== 'static') return proceed(element);
        // Trigger hasLayout on the offset parent so that IE6 reports
        // accurate offsetTop and offsetLeft values for position: fixed.
        var offsetParent = element.getOffsetParent();
        if (offsetParent && offsetParent.getStyle('position') === 'fixed')
          offsetParent.setStyle({ zoom: 1 });
        element.setStyle({ position: 'relative' });
        var value = proceed(element);
        element.setStyle({ position: position });
        return value;
      }
    );
  });

  Element.Methods.getStyle = function(element, style) {
    element = $(element);
    style = (style == 'float' || style == 'cssFloat') ? 'styleFloat' : style.camelize();
    var value = element.style[style];
    if (!value && element.currentStyle) value = element.currentStyle[style];

    if (style == 'opacity') {
      if (value = (element.getStyle('filter') || '').match(/alpha\(opacity=(.*)\)/))
        if (value[1]) return parseFloat(value[1]) / 100;
      return 1.0;
    }

    if (value == 'auto') {
      if ((style == 'width' || style == 'height') && (element.getStyle('display') != 'none'))
        return element['offset' + style.capitalize()] + 'px';
      return null;
    }
    return value;
  };

  Element.Methods.setOpacity = function(element, value) {
    function stripAlpha(filter){
      return filter.replace(/alpha\([^\)]*\)/gi,'');
    }
    element = $(element);
    var currentStyle = element.currentStyle;
    if ((currentStyle && !currentStyle.hasLayout) ||
      (!currentStyle && element.style.zoom == 'normal'))
        element.style.zoom = 1;

    var filter = element.getStyle('filter'), style = element.style;
    if (value == 1 || value === '') {
      (filter = stripAlpha(filter)) ?
        style.filter = filter : style.removeAttribute('filter');
      return element;
    } else if (value < 0.00001) value = 0;
    style.filter = stripAlpha(filter) +
      'alpha(opacity=' + (value * 100) + ')';
    return element;
  };

  Element._attributeTranslations = {
    read: {
      names: {
        'class': 'className',
        'for':   'htmlFor'
      },
      values: {
        _getAttr: function(element, attribute) {
          return element.getAttribute(attribute, 2);
        },
        _getAttrNode: function(element, attribute) {
          var node = element.getAttributeNode(attribute);
          return node ? node.value : "";
        },
        _getEv: function(element, attribute) {
          attribute = element.getAttribute(attribute);
          return attribute ? attribute.toString().slice(23, -2) : null;
        },
        _flag: function(element, attribute) {
          return $(element).hasAttribute(attribute) ? attribute : null;
        },
        style: function(element) {
          return element.style.cssText.toLowerCase();
        },
        title: function(element) {
          return element.title;
        }
      }
    }
  };

  Element._attributeTranslations.write = {
    names: Object.extend({
      cellpadding: 'cellPadding',
      cellspacing: 'cellSpacing'
    }, Element._attributeTranslations.read.names),
    values: {
      checked: function(element, value) {
        element.checked = !!value;
      },

      style: function(element, value) {
        element.style.cssText = value ? value : '';
      }
    }
  };

  Element._attributeTranslations.has = {};

  $w('colSpan rowSpan vAlign dateTime accessKey tabIndex ' +
      'encType maxLength readOnly longDesc').each(function(attr) {
    Element._attributeTranslations.write.names[attr.toLowerCase()] = attr;
    Element._attributeTranslations.has[attr.toLowerCase()] = attr;
  });

  (function(v) {
    Object.extend(v, {
      href:        v._getAttr,
      src:         v._getAttr,
      type:        v._getAttr,
      action:      v._getAttrNode,
      disabled:    v._flag,
      checked:     v._flag,
      readonly:    v._flag,
      multiple:    v._flag,
      onload:      v._getEv,
      onunload:    v._getEv,
      onclick:     v._getEv,
      ondblclick:  v._getEv,
      onmousedown: v._getEv,
      onmouseup:   v._getEv,
      onmouseover: v._getEv,
      onmousemove: v._getEv,
      onmouseout:  v._getEv,
      onfocus:     v._getEv,
      onblur:      v._getEv,
      onkeypress:  v._getEv,
      onkeydown:   v._getEv,
      onkeyup:     v._getEv,
      onsubmit:    v._getEv,
      onreset:     v._getEv,
      onselect:    v._getEv,
      onchange:    v._getEv
    });
  })(Element._attributeTranslations.read.values);
}

else if (Prototype.Browser.Gecko && /rv:1\.8\.0/.test(navigator.userAgent)) {
  Element.Methods.setOpacity = function(element, value) {
    element = $(element);
    element.style.opacity = (value == 1) ? 0.999999 :
      (value === '') ? '' : (value < 0.00001) ? 0 : value;
    return element;
  };
}

else if (Prototype.Browser.WebKit) {
  Element.Methods.setOpacity = function(element, value) {
    element = $(element);
    element.style.opacity = (value == 1 || value === '') ? '' :
      (value < 0.00001) ? 0 : value;

    if (value == 1)
      if(element.tagName == 'IMG' && element.width) {
        element.width++; element.width--;
      } else try {
        var n = document.createTextNode(' ');
        element.appendChild(n);
        element.removeChild(n);
      } catch (e) { }

    return element;
  };

  // Safari returns margins on body which is incorrect if the child is absolutely
  // positioned.  For performance reasons, redefine Element#cumulativeOffset for
  // KHTML/WebKit only.
  Element.Methods.cumulativeOffset = function(element) {
    var valueT = 0, valueL = 0;
    do {
      valueT += element.offsetTop  || 0;
      valueL += element.offsetLeft || 0;
      if (element.offsetParent == document.body)
        if (Element.getStyle(element, 'position') == 'absolute') break;

      element = element.offsetParent;
    } while (element);

    return Element._returnOffset(valueL, valueT);
  };
}

if (Prototype.Browser.IE || Prototype.Browser.Opera) {
  // IE and Opera are missing .innerHTML support for TABLE-related and SELECT elements
  Element.Methods.update = function(element, content) {
    element = $(element);

    if (content && content.toElement) content = content.toElement();
    if (Object.isElement(content)) return element.update().insert(content);

    content = Object.toHTML(content);
    var tagName = element.tagName.toUpperCase();

    if (tagName in Element._insertionTranslations.tags) {
      $A(element.childNodes).each(function(node) { element.removeChild(node) });
      Element._getContentFromAnonymousElement(tagName, content.stripScripts())
        .each(function(node) { element.appendChild(node) });
    }
    else element.innerHTML = content.stripScripts();

    content.evalScripts.bind(content).defer();
    return element;
  };
}

if ('outerHTML' in document.createElement('div')) {
  Element.Methods.replace = function(element, content) {
    element = $(element);

    if (content && content.toElement) content = content.toElement();
    if (Object.isElement(content)) {
      element.parentNode.replaceChild(content, element);
      return element;
    }

    content = Object.toHTML(content);
    var parent = element.parentNode, tagName = parent.tagName.toUpperCase();

    if (Element._insertionTranslations.tags[tagName]) {
      var nextSibling = element.next();
      var fragments = Element._getContentFromAnonymousElement(tagName, content.stripScripts());
      parent.removeChild(element);
      if (nextSibling)
        fragments.each(function(node) { parent.insertBefore(node, nextSibling) });
      else
        fragments.each(function(node) { parent.appendChild(node) });
    }
    else element.outerHTML = content.stripScripts();

    content.evalScripts.bind(content).defer();
    return element;
  };
}

Element._returnOffset = function(l, t) {
  var result = [l, t];
  result.left = l;
  result.top = t;
  return result;
};

Element._getContentFromAnonymousElement = function(tagName, html) {
  var div = new Element('div'), t = Element._insertionTranslations.tags[tagName];
  if (t) {
    div.innerHTML = t[0] + html + t[1];
    t[2].times(function() { div = div.firstChild });
  } else div.innerHTML = html;
  return $A(div.childNodes);
};

Element._insertionTranslations = {
  before: function(element, node) {
    element.parentNode.insertBefore(node, element);
  },
  top: function(element, node) {
    element.insertBefore(node, element.firstChild);
  },
  bottom: function(element, node) {
    element.appendChild(node);
  },
  after: function(element, node) {
    element.parentNode.insertBefore(node, element.nextSibling);
  },
  tags: {
    TABLE:  ['<table>',                '</table>',                   1],
    TBODY:  ['<table><tbody>',         '</tbody></table>',           2],
    TR:     ['<table><tbody><tr>',     '</tr></tbody></table>',      3],
    TD:     ['<table><tbody><tr><td>', '</td></tr></tbody></table>', 4],
    SELECT: ['<select>',               '</select>',                  1]
  }
};

(function() {
  Object.extend(this.tags, {
    THEAD: this.tags.TBODY,
    TFOOT: this.tags.TBODY,
    TH:    this.tags.TD
  });
}).call(Element._insertionTranslations);

Element.Methods.Simulated = {
  hasAttribute: function(element, attribute) {
    attribute = Element._attributeTranslations.has[attribute] || attribute;
    var node = $(element).getAttributeNode(attribute);
    return node && node.specified;
  }
};

Element.Methods.ByTag = { };

Object.extend(Element, Element.Methods);

if (!Prototype.BrowserFeatures.ElementExtensions &&
    document.createElement('div').__proto__) {
  window.HTMLElement = { };
  window.HTMLElement.prototype = document.createElement('div').__proto__;
  Prototype.BrowserFeatures.ElementExtensions = true;
}

Element.extend = (function() {
  if (Prototype.BrowserFeatures.SpecificElementExtensions)
    return Prototype.K;

  var Methods = { }, ByTag = Element.Methods.ByTag;

  var extend = Object.extend(function(element) {
    if (!element || element._extendedByPrototype ||
        element.nodeType != 1 || element == window) return element;

    var methods = Object.clone(Methods),
      tagName = element.tagName, property, value;

    // extend methods for specific tags
    if (ByTag[tagName]) Object.extend(methods, ByTag[tagName]);

    for (property in methods) {
      value = methods[property];
      if (Object.isFunction(value) && !(property in element))
        element[property] = value.methodize();
    }

    element._extendedByPrototype = Prototype.emptyFunction;
    return element;

  }, {
    refresh: function() {
      // extend methods for all tags (Safari doesn't need this)
      if (!Prototype.BrowserFeatures.ElementExtensions) {
        Object.extend(Methods, Element.Methods);
        Object.extend(Methods, Element.Methods.Simulated);
      }
    }
  });

  extend.refresh();
  return extend;
})();

Element.hasAttribute = function(element, attribute) {
  if (element.hasAttribute) return element.hasAttribute(attribute);
  return Element.Methods.Simulated.hasAttribute(element, attribute);
};

Element.addMethods = function(methods) {
  var F = Prototype.BrowserFeatures, T = Element.Methods.ByTag;

  if (!methods) {
    Object.extend(Form, Form.Methods);
    Object.extend(Form.Element, Form.Element.Methods);
    Object.extend(Element.Methods.ByTag, {
      "FORM":     Object.clone(Form.Methods),
      "INPUT":    Object.clone(Form.Element.Methods),
      "SELECT":   Object.clone(Form.Element.Methods),
      "TEXTAREA": Object.clone(Form.Element.Methods)
    });
  }

  if (arguments.length == 2) {
    var tagName = methods;
    methods = arguments[1];
  }

  if (!tagName) Object.extend(Element.Methods, methods || { });
  else {
    if (Object.isArray(tagName)) tagName.each(extend);
    else extend(tagName);
  }

  function extend(tagName) {
    tagName = tagName.toUpperCase();
    if (!Element.Methods.ByTag[tagName])
      Element.Methods.ByTag[tagName] = { };
    Object.extend(Element.Methods.ByTag[tagName], methods);
  }

  function copy(methods, destination, onlyIfAbsent) {
    onlyIfAbsent = onlyIfAbsent || false;
    for (var property in methods) {
      var value = methods[property];
      if (!Object.isFunction(value)) continue;
      if (!onlyIfAbsent || !(property in destination))
        destination[property] = value.methodize();
    }
  }

  function findDOMClass(tagName) {
    var klass;
    var trans = {
      "OPTGROUP": "OptGroup", "TEXTAREA": "TextArea", "P": "Paragraph",
      "FIELDSET": "FieldSet", "UL": "UList", "OL": "OList", "DL": "DList",
      "DIR": "Directory", "H1": "Heading", "H2": "Heading", "H3": "Heading",
      "H4": "Heading", "H5": "Heading", "H6": "Heading", "Q": "Quote",
      "INS": "Mod", "DEL": "Mod", "A": "Anchor", "IMG": "Image", "CAPTION":
      "TableCaption", "COL": "TableCol", "COLGROUP": "TableCol", "THEAD":
      "TableSection", "TFOOT": "TableSection", "TBODY": "TableSection", "TR":
      "TableRow", "TH": "TableCell", "TD": "TableCell", "FRAMESET":
      "FrameSet", "IFRAME": "IFrame"
    };
    if (trans[tagName]) klass = 'HTML' + trans[tagName] + 'Element';
    if (window[klass]) return window[klass];
    klass = 'HTML' + tagName + 'Element';
    if (window[klass]) return window[klass];
    klass = 'HTML' + tagName.capitalize() + 'Element';
    if (window[klass]) return window[klass];

    window[klass] = { };
    window[klass].prototype = document.createElement(tagName).__proto__;
    return window[klass];
  }

  if (F.ElementExtensions) {
    copy(Element.Methods, HTMLElement.prototype);
    copy(Element.Methods.Simulated, HTMLElement.prototype, true);
  }

  if (F.SpecificElementExtensions) {
    for (var tag in Element.Methods.ByTag) {
      var klass = findDOMClass(tag);
      if (Object.isUndefined(klass)) continue;
      copy(T[tag], klass.prototype);
    }
  }

  Object.extend(Element, Element.Methods);
  delete Element.ByTag;

  if (Element.extend.refresh) Element.extend.refresh();
  Element.cache = { };
};

document.viewport = {
  getDimensions: function() {
    var dimensions = { };
    var B = Prototype.Browser;
    $w('width height').each(function(d) {
      var D = d.capitalize();
      dimensions[d] = (B.WebKit && !document.evaluate) ? self['inner' + D] :
        (B.Opera) ? document.body['client' + D] : document.documentElement['client' + D];
    });
    return dimensions;
  },

  getWidth: function() {
    return this.getDimensions().width;
  },

  getHeight: function() {
    return this.getDimensions().height;
  },

  getScrollOffsets: function() {
    return Element._returnOffset(
      window.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft,
      window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop);
  }
};
/* Portions of the Selector class are derived from Jack Slocum’s DomQuery,
 * part of YUI-Ext version 0.40, distributed under the terms of an MIT-style
 * license.  Please see http://www.yui-ext.com/ for more information. */

var Selector = Class.create({
  initialize: function(expression) {
    this.expression = expression.strip();
    this.compileMatcher();
  },

  shouldUseXPath: function() {
    if (!Prototype.BrowserFeatures.XPath) return false;

    var e = this.expression;

    // Safari 3 chokes on :*-of-type and :empty
    if (Prototype.Browser.WebKit &&
     (e.include("-of-type") || e.include(":empty")))
      return false;

    // XPath can't do namespaced attributes, nor can it read
    // the "checked" property from DOM nodes
    if ((/(\[[\w-]*?:|:checked)/).test(this.expression))
      return false;

    return true;
  },

  compileMatcher: function() {
    if (this.shouldUseXPath())
      return this.compileXPathMatcher();

    var e = this.expression, ps = Selector.patterns, h = Selector.handlers,
        c = Selector.criteria, le, p, m;

    if (Selector._cache[e]) {
      this.matcher = Selector._cache[e];
      return;
    }

    this.matcher = ["this.matcher = function(root) {",
                    "var r = root, h = Selector.handlers, c = false, n;"];

    while (e && le != e && (/\S/).test(e)) {
      le = e;
      for (var i in ps) {
        p = ps[i];
        if (m = e.match(p)) {
          this.matcher.push(Object.isFunction(c[i]) ? c[i](m) :
    	      new Template(c[i]).evaluate(m));
          e = e.replace(m[0], '');
          break;
        }
      }
    }

    this.matcher.push("return h.unique(n);\n}");
    eval(this.matcher.join('\n'));
    Selector._cache[this.expression] = this.matcher;
  },

  compileXPathMatcher: function() {
    var e = this.expression, ps = Selector.patterns,
        x = Selector.xpath, le, m;

    if (Selector._cache[e]) {
      this.xpath = Selector._cache[e]; return;
    }

    this.matcher = ['.//*'];
    while (e && le != e && (/\S/).test(e)) {
      le = e;
      for (var i in ps) {
        if (m = e.match(ps[i])) {
          this.matcher.push(Object.isFunction(x[i]) ? x[i](m) :
            new Template(x[i]).evaluate(m));
          e = e.replace(m[0], '');
          break;
        }
      }
    }

    this.xpath = this.matcher.join('');
    Selector._cache[this.expression] = this.xpath;
  },

  findElements: function(root) {
    root = root || document;
    if (this.xpath) return document._getElementsByXPath(this.xpath, root);
    return this.matcher(root);
  },

  match: function(element) {
    this.tokens = [];

    var e = this.expression, ps = Selector.patterns, as = Selector.assertions;
    var le, p, m;

    while (e && le !== e && (/\S/).test(e)) {
      le = e;
      for (var i in ps) {
        p = ps[i];
        if (m = e.match(p)) {
          // use the Selector.assertions methods unless the selector
          // is too complex.
          if (as[i]) {
            this.tokens.push([i, Object.clone(m)]);
            e = e.replace(m[0], '');
          } else {
            // reluctantly do a document-wide search
            // and look for a match in the array
            return this.findElements(document).include(element);
          }
        }
      }
    }

    var match = true, name, matches;
    for (var i = 0, token; token = this.tokens[i]; i++) {
      name = token[0], matches = token[1];
      if (!Selector.assertions[name](element, matches)) {
        match = false; break;
      }
    }

    return match;
  },

  toString: function() {
    return this.expression;
  },

  inspect: function() {
    return "#<Selector:" + this.expression.inspect() + ">";
  }
});

Object.extend(Selector, {
  _cache: { },

  xpath: {
    descendant:   "//*",
    child:        "/*",
    adjacent:     "/following-sibling::*[1]",
    laterSibling: '/following-sibling::*',
    tagName:      function(m) {
      if (m[1] == '*') return '';
      return "[local-name()='" + m[1].toLowerCase() +
             "' or local-name()='" + m[1].toUpperCase() + "']";
    },
    className:    "[contains(concat(' ', @class, ' '), ' #{1} ')]",
    id:           "[@id='#{1}']",
    attrPresence: function(m) {
      m[1] = m[1].toLowerCase();
      return new Template("[@#{1}]").evaluate(m);
    },
    attr: function(m) {
      m[1] = m[1].toLowerCase();
      m[3] = m[5] || m[6];
      return new Template(Selector.xpath.operators[m[2]]).evaluate(m);
    },
    pseudo: function(m) {
      var h = Selector.xpath.pseudos[m[1]];
      if (!h) return '';
      if (Object.isFunction(h)) return h(m);
      return new Template(Selector.xpath.pseudos[m[1]]).evaluate(m);
    },
    operators: {
      '=':  "[@#{1}='#{3}']",
      '!=': "[@#{1}!='#{3}']",
      '^=': "[starts-with(@#{1}, '#{3}')]",
      '$=': "[substring(@#{1}, (string-length(@#{1}) - string-length('#{3}') + 1))='#{3}']",
      '*=': "[contains(@#{1}, '#{3}')]",
      '~=': "[contains(concat(' ', @#{1}, ' '), ' #{3} ')]",
      '|=': "[contains(concat('-', @#{1}, '-'), '-#{3}-')]"
    },
    pseudos: {
      'first-child': '[not(preceding-sibling::*)]',
      'last-child':  '[not(following-sibling::*)]',
      'only-child':  '[not(preceding-sibling::* or following-sibling::*)]',
      'empty':       "[count(*) = 0 and (count(text()) = 0 or translate(text(), ' \t\r\n', '') = '')]",
      'checked':     "[@checked]",
      'disabled':    "[@disabled]",
      'enabled':     "[not(@disabled)]",
      'not': function(m) {
        var e = m[6], p = Selector.patterns,
            x = Selector.xpath, le, v;

        var exclusion = [];
        while (e && le != e && (/\S/).test(e)) {
          le = e;
          for (var i in p) {
            if (m = e.match(p[i])) {
              v = Object.isFunction(x[i]) ? x[i](m) : new Template(x[i]).evaluate(m);
              exclusion.push("(" + v.substring(1, v.length - 1) + ")");
              e = e.replace(m[0], '');
              break;
            }
          }
        }
        return "[not(" + exclusion.join(" and ") + ")]";
      },
      'nth-child':      function(m) {
        return Selector.xpath.pseudos.nth("(count(./preceding-sibling::*) + 1) ", m);
      },
      'nth-last-child': function(m) {
        return Selector.xpath.pseudos.nth("(count(./following-sibling::*) + 1) ", m);
      },
      'nth-of-type':    function(m) {
        return Selector.xpath.pseudos.nth("position() ", m);
      },
      'nth-last-of-type': function(m) {
        return Selector.xpath.pseudos.nth("(last() + 1 - position()) ", m);
      },
      'first-of-type':  function(m) {
        m[6] = "1"; return Selector.xpath.pseudos['nth-of-type'](m);
      },
      'last-of-type':   function(m) {
        m[6] = "1"; return Selector.xpath.pseudos['nth-last-of-type'](m);
      },
      'only-of-type':   function(m) {
        var p = Selector.xpath.pseudos; return p['first-of-type'](m) + p['last-of-type'](m);
      },
      nth: function(fragment, m) {
        var mm, formula = m[6], predicate;
        if (formula == 'even') formula = '2n+0';
        if (formula == 'odd')  formula = '2n+1';
        if (mm = formula.match(/^(\d+)$/)) // digit only
          return '[' + fragment + "= " + mm[1] + ']';
        if (mm = formula.match(/^(-?\d*)?n(([+-])(\d+))?/)) { // an+b
          if (mm[1] == "-") mm[1] = -1;
          var a = mm[1] ? Number(mm[1]) : 1;
          var b = mm[2] ? Number(mm[2]) : 0;
          predicate = "[((#{fragment} - #{b}) mod #{a} = 0) and " +
          "((#{fragment} - #{b}) div #{a} >= 0)]";
          return new Template(predicate).evaluate({
            fragment: fragment, a: a, b: b });
        }
      }
    }
  },

  criteria: {
    tagName:      'n = h.tagName(n, r, "#{1}", c);      c = false;',
    className:    'n = h.className(n, r, "#{1}", c);    c = false;',
    id:           'n = h.id(n, r, "#{1}", c);           c = false;',
    attrPresence: 'n = h.attrPresence(n, r, "#{1}", c); c = false;',
    attr: function(m) {
      m[3] = (m[5] || m[6]);
      return new Template('n = h.attr(n, r, "#{1}", "#{3}", "#{2}", c); c = false;').evaluate(m);
    },
    pseudo: function(m) {
      if (m[6]) m[6] = m[6].replace(/"/g, '\\"');
      return new Template('n = h.pseudo(n, "#{1}", "#{6}", r, c); c = false;').evaluate(m);
    },
    descendant:   'c = "descendant";',
    child:        'c = "child";',
    adjacent:     'c = "adjacent";',
    laterSibling: 'c = "laterSibling";'
  },

  patterns: {
    // combinators must be listed first
    // (and descendant needs to be last combinator)
    laterSibling: /^\s*~\s*/,
    child:        /^\s*>\s*/,
    adjacent:     /^\s*\+\s*/,
    descendant:   /^\s/,

    // selectors follow
    tagName:      /^\s*(\*|[\w\-]+)(\b|$)?/,
    id:           /^#([\w\-\*]+)(\b|$)/,
    className:    /^\.([\w\-\*]+)(\b|$)/,
    pseudo:
/^:((first|last|nth|nth-last|only)(-child|-of-type)|empty|checked|(en|dis)abled|not)(\((.*?)\))?(\b|$|(?=\s|[:+~>]))/,
    attrPresence: /^\[([\w]+)\]/,
    attr:         /\[((?:[\w-]*:)?[\w-]+)\s*(?:([!^$*~|]?=)\s*((['"])([^\4]*?)\4|([^'"][^\]]*?)))?\]/
  },

  // for Selector.match and Element#match
  assertions: {
    tagName: function(element, matches) {
      return matches[1].toUpperCase() == element.tagName.toUpperCase();
    },

    className: function(element, matches) {
      return Element.hasClassName(element, matches[1]);
    },

    id: function(element, matches) {
      return element.id === matches[1];
    },

    attrPresence: function(element, matches) {
      return Element.hasAttribute(element, matches[1]);
    },

    attr: function(element, matches) {
      var nodeValue = Element.readAttribute(element, matches[1]);
      return nodeValue && Selector.operators[matches[2]](nodeValue, matches[5] || matches[6]);
    }
  },

  handlers: {
    // UTILITY FUNCTIONS
    // joins two collections
    concat: function(a, b) {
      for (var i = 0, node; node = b[i]; i++)
        a.push(node);
      return a;
    },

    // marks an array of nodes for counting
    mark: function(nodes) {
      var _true = Prototype.emptyFunction;
      for (var i = 0, node; node = nodes[i]; i++)
        node._countedByPrototype = _true;
      return nodes;
    },

    unmark: function(nodes) {
      for (var i = 0, node; node = nodes[i]; i++)
        node._countedByPrototype = undefined;
      return nodes;
    },

    // mark each child node with its position (for nth calls)
    // "ofType" flag indicates whether we're indexing for nth-of-type
    // rather than nth-child
    index: function(parentNode, reverse, ofType) {
      parentNode._countedByPrototype = Prototype.emptyFunction;
      if (reverse) {
        for (var nodes = parentNode.childNodes, i = nodes.length - 1, j = 1; i >= 0; i--) {
          var node = nodes[i];
          if (node.nodeType == 1 && (!ofType || node._countedByPrototype)) node.nodeIndex = j++;
        }
      } else {
        for (var i = 0, j = 1, nodes = parentNode.childNodes; node = nodes[i]; i++)
          if (node.nodeType == 1 && (!ofType || node._countedByPrototype)) node.nodeIndex = j++;
      }
    },

    // filters out duplicates and extends all nodes
    unique: function(nodes) {
      if (nodes.length == 0) return nodes;
      var results = [], n;
      for (var i = 0, l = nodes.length; i < l; i++)
        if (!(n = nodes[i])._countedByPrototype) {
          n._countedByPrototype = Prototype.emptyFunction;
          results.push(Element.extend(n));
        }
      return Selector.handlers.unmark(results);
    },

    // COMBINATOR FUNCTIONS
    descendant: function(nodes) {
      var h = Selector.handlers;
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        h.concat(results, node.getElementsByTagName('*'));
      return results;
    },

    child: function(nodes) {
      var h = Selector.handlers;
      for (var i = 0, results = [], node; node = nodes[i]; i++) {
        for (var j = 0, child; child = node.childNodes[j]; j++)
          if (child.nodeType == 1 && child.tagName != '!') results.push(child);
      }
      return results;
    },

    adjacent: function(nodes) {
      for (var i = 0, results = [], node; node = nodes[i]; i++) {
        var next = this.nextElementSibling(node);
        if (next) results.push(next);
      }
      return results;
    },

    laterSibling: function(nodes) {
      var h = Selector.handlers;
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        h.concat(results, Element.nextSiblings(node));
      return results;
    },

    nextElementSibling: function(node) {
      while (node = node.nextSibling)
	      if (node.nodeType == 1) return node;
      return null;
    },

    previousElementSibling: function(node) {
      while (node = node.previousSibling)
        if (node.nodeType == 1) return node;
      return null;
    },

    // TOKEN FUNCTIONS
    tagName: function(nodes, root, tagName, combinator) {
      var uTagName = tagName.toUpperCase();
      var results = [], h = Selector.handlers;
      if (nodes) {
        if (combinator) {
          // fastlane for ordinary descendant combinators
          if (combinator == "descendant") {
            for (var i = 0, node; node = nodes[i]; i++)
              h.concat(results, node.getElementsByTagName(tagName));
            return results;
          } else nodes = this[combinator](nodes);
          if (tagName == "*") return nodes;
        }
        for (var i = 0, node; node = nodes[i]; i++)
          if (node.tagName.toUpperCase() === uTagName) results.push(node);
        return results;
      } else return root.getElementsByTagName(tagName);
    },

    id: function(nodes, root, id, combinator) {
      var targetNode = $(id), h = Selector.handlers;
      if (!targetNode) return [];
      if (!nodes && root == document) return [targetNode];
      if (nodes) {
        if (combinator) {
          if (combinator == 'child') {
            for (var i = 0, node; node = nodes[i]; i++)
              if (targetNode.parentNode == node) return [targetNode];
          } else if (combinator == 'descendant') {
            for (var i = 0, node; node = nodes[i]; i++)
              if (Element.descendantOf(targetNode, node)) return [targetNode];
          } else if (combinator == 'adjacent') {
            for (var i = 0, node; node = nodes[i]; i++)
              if (Selector.handlers.previousElementSibling(targetNode) == node)
                return [targetNode];
          } else nodes = h[combinator](nodes);
        }
        for (var i = 0, node; node = nodes[i]; i++)
          if (node == targetNode) return [targetNode];
        return [];
      }
      return (targetNode && Element.descendantOf(targetNode, root)) ? [targetNode] : [];
    },

    className: function(nodes, root, className, combinator) {
      if (nodes && combinator) nodes = this[combinator](nodes);
      return Selector.handlers.byClassName(nodes, root, className);
    },

    byClassName: function(nodes, root, className) {
      if (!nodes) nodes = Selector.handlers.descendant([root]);
      var needle = ' ' + className + ' ';
      for (var i = 0, results = [], node, nodeClassName; node = nodes[i]; i++) {
        nodeClassName = node.className;
        if (nodeClassName.length == 0) continue;
        if (nodeClassName == className || (' ' + nodeClassName + ' ').include(needle))
          results.push(node);
      }
      return results;
    },

    attrPresence: function(nodes, root, attr, combinator) {
      if (!nodes) nodes = root.getElementsByTagName("*");
      if (nodes && combinator) nodes = this[combinator](nodes);
      var results = [];
      for (var i = 0, node; node = nodes[i]; i++)
        if (Element.hasAttribute(node, attr)) results.push(node);
      return results;
    },

    attr: function(nodes, root, attr, value, operator, combinator) {
      if (!nodes) nodes = root.getElementsByTagName("*");
      if (nodes && combinator) nodes = this[combinator](nodes);
      var handler = Selector.operators[operator], results = [];
      for (var i = 0, node; node = nodes[i]; i++) {
        var nodeValue = Element.readAttribute(node, attr);
        if (nodeValue === null) continue;
        if (handler(nodeValue, value)) results.push(node);
      }
      return results;
    },

    pseudo: function(nodes, name, value, root, combinator) {
      if (nodes && combinator) nodes = this[combinator](nodes);
      if (!nodes) nodes = root.getElementsByTagName("*");
      return Selector.pseudos[name](nodes, value, root);
    }
  },

  pseudos: {
    'first-child': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++) {
        if (Selector.handlers.previousElementSibling(node)) continue;
          results.push(node);
      }
      return results;
    },
    'last-child': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++) {
        if (Selector.handlers.nextElementSibling(node)) continue;
          results.push(node);
      }
      return results;
    },
    'only-child': function(nodes, value, root) {
      var h = Selector.handlers;
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        if (!h.previousElementSibling(node) && !h.nextElementSibling(node))
          results.push(node);
      return results;
    },
    'nth-child':        function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, formula, root);
    },
    'nth-last-child':   function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, formula, root, true);
    },
    'nth-of-type':      function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, formula, root, false, true);
    },
    'nth-last-of-type': function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, formula, root, true, true);
    },
    'first-of-type':    function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, "1", root, false, true);
    },
    'last-of-type':     function(nodes, formula, root) {
      return Selector.pseudos.nth(nodes, "1", root, true, true);
    },
    'only-of-type':     function(nodes, formula, root) {
      var p = Selector.pseudos;
      return p['last-of-type'](p['first-of-type'](nodes, formula, root), formula, root);
    },

    // handles the an+b logic
    getIndices: function(a, b, total) {
      if (a == 0) return b > 0 ? [b] : [];
      return $R(1, total).inject([], function(memo, i) {
        if (0 == (i - b) % a && (i - b) / a >= 0) memo.push(i);
        return memo;
      });
    },

    // handles nth(-last)-child, nth(-last)-of-type, and (first|last)-of-type
    nth: function(nodes, formula, root, reverse, ofType) {
      if (nodes.length == 0) return [];
      if (formula == 'even') formula = '2n+0';
      if (formula == 'odd')  formula = '2n+1';
      var h = Selector.handlers, results = [], indexed = [], m;
      h.mark(nodes);
      for (var i = 0, node; node = nodes[i]; i++) {
        if (!node.parentNode._countedByPrototype) {
          h.index(node.parentNode, reverse, ofType);
          indexed.push(node.parentNode);
        }
      }
      if (formula.match(/^\d+$/)) { // just a number
        formula = Number(formula);
        for (var i = 0, node; node = nodes[i]; i++)
          if (node.nodeIndex == formula) results.push(node);
      } else if (m = formula.match(/^(-?\d*)?n(([+-])(\d+))?/)) { // an+b
        if (m[1] == "-") m[1] = -1;
        var a = m[1] ? Number(m[1]) : 1;
        var b = m[2] ? Number(m[2]) : 0;
        var indices = Selector.pseudos.getIndices(a, b, nodes.length);
        for (var i = 0, node, l = indices.length; node = nodes[i]; i++) {
          for (var j = 0; j < l; j++)
            if (node.nodeIndex == indices[j]) results.push(node);
        }
      }
      h.unmark(nodes);
      h.unmark(indexed);
      return results;
    },

    'empty': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++) {
        // IE treats comments as element nodes
        if (node.tagName == '!' || (node.firstChild && !node.innerHTML.match(/^\s*$/))) continue;
        results.push(node);
      }
      return results;
    },

    'not': function(nodes, selector, root) {
      var h = Selector.handlers, selectorType, m;
      var exclusions = new Selector(selector).findElements(root);
      h.mark(exclusions);
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        if (!node._countedByPrototype) results.push(node);
      h.unmark(exclusions);
      return results;
    },

    'enabled': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        if (!node.disabled) results.push(node);
      return results;
    },

    'disabled': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        if (node.disabled) results.push(node);
      return results;
    },

    'checked': function(nodes, value, root) {
      for (var i = 0, results = [], node; node = nodes[i]; i++)
        if (node.checked) results.push(node);
      return results;
    }
  },

  operators: {
    '=':  function(nv, v) { return nv == v; },
    '!=': function(nv, v) { return nv != v; },
    '^=': function(nv, v) { return nv.startsWith(v); },
    '$=': function(nv, v) { return nv.endsWith(v); },
    '*=': function(nv, v) { return nv.include(v); },
    '~=': function(nv, v) { return (' ' + nv + ' ').include(' ' + v + ' '); },
    '|=': function(nv, v) { return ('-' + nv.toUpperCase() + '-').include('-' + v.toUpperCase() + '-'); }
  },

  split: function(expression) {
    var expressions = [];
    expression.scan(/(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)/, function(m) {
      expressions.push(m[1].strip());
    });
    return expressions;
  },

  matchElements: function(elements, expression) {
    var matches = $$(expression), h = Selector.handlers;
    h.mark(matches);
    for (var i = 0, results = [], element; element = elements[i]; i++)
      if (element._countedByPrototype) results.push(element);
    h.unmark(matches);
    return results;
  },

  findElement: function(elements, expression, index) {
    if (Object.isNumber(expression)) {
      index = expression; expression = false;
    }
    return Selector.matchElements(elements, expression || '*')[index || 0];
  },

  findChildElements: function(element, expressions) {
    expressions = Selector.split(expressions.join(','));
    var results = [], h = Selector.handlers;
    for (var i = 0, l = expressions.length, selector; i < l; i++) {
      selector = new Selector(expressions[i].strip());
      h.concat(results, selector.findElements(element));
    }
    return (l > 1) ? h.unique(results) : results;
  }
});

if (Prototype.Browser.IE) {
  Object.extend(Selector.handlers, {
    // IE returns comment nodes on getElementsByTagName("*").
    // Filter them out.
    concat: function(a, b) {
      for (var i = 0, node; node = b[i]; i++)
        if (node.tagName !== "!") a.push(node);
      return a;
    },

    // IE improperly serializes _countedByPrototype in (inner|outer)HTML.
    unmark: function(nodes) {
      for (var i = 0, node; node = nodes[i]; i++)
        node.removeAttribute('_countedByPrototype');
      return nodes;
    }
  });
}

function $$() {
  return Selector.findChildElements(document, $A(arguments));
}
var Form = {
  reset: function(form) {
    $(form).reset();
    return form;
  },

  serializeElements: function(elements, options) {
    if (typeof options != 'object') options = { hash: !!options };
    else if (Object.isUndefined(options.hash)) options.hash = true;
    var key, value, submitted = false, submit = options.submit;

    var data = elements.inject({ }, function(result, element) {
      if (!element.disabled && element.name) {
        key = element.name; value = $(element).getValue();
        if (value != null && (element.type != 'submit' || (!submitted &&
            submit !== false && (!submit || key == submit) && (submitted = true)))) {
          if (key in result) {
            // a key is already present; construct an array of values
            if (!Object.isArray(result[key])) result[key] = [result[key]];
            result[key].push(value);
          }
          else result[key] = value;
        }
      }
      return result;
    });

    return options.hash ? data : Object.toQueryString(data);
  }
};

Form.Methods = {
  serialize: function(form, options) {
    return Form.serializeElements(Form.getElements(form), options);
  },

  getElements: function(form) {
    return $A($(form).getElementsByTagName('*')).inject([],
      function(elements, child) {
        if (Form.Element.Serializers[child.tagName.toLowerCase()])
          elements.push(Element.extend(child));
        return elements;
      }
    );
  },

  getInputs: function(form, typeName, name) {
    form = $(form);
    var inputs = form.getElementsByTagName('input');

    if (!typeName && !name) return $A(inputs).map(Element.extend);

    for (var i = 0, matchingInputs = [], length = inputs.length; i < length; i++) {
      var input = inputs[i];
      if ((typeName && input.type != typeName) || (name && input.name != name))
        continue;
      matchingInputs.push(Element.extend(input));
    }

    return matchingInputs;
  },

  disable: function(form) {
    form = $(form);
    Form.getElements(form).invoke('disable');
    return form;
  },

  enable: function(form) {
    form = $(form);
    Form.getElements(form).invoke('enable');
    return form;
  },

  findFirstElement: function(form) {
    var elements = $(form).getElements().findAll(function(element) {
      return 'hidden' != element.type && !element.disabled;
    });
    var firstByIndex = elements.findAll(function(element) {
      return element.hasAttribute('tabIndex') && element.tabIndex >= 0;
    }).sortBy(function(element) { return element.tabIndex }).first();

    return firstByIndex ? firstByIndex : elements.find(function(element) {
      return ['input', 'select', 'textarea'].include(element.tagName.toLowerCase());
    });
  },

  focusFirstElement: function(form) {
    form = $(form);
    form.findFirstElement().activate();
    return form;
  },

  request: function(form, options) {
    form = $(form), options = Object.clone(options || { });

    var params = options.parameters, action = form.readAttribute('action') || '';
    if (action.blank()) action = window.location.href;
    options.parameters = form.serialize(true);

    if (params) {
      if (Object.isString(params)) params = params.toQueryParams();
      Object.extend(options.parameters, params);
    }

    if (form.hasAttribute('method') && !options.method)
      options.method = form.method;

    return new Ajax.Request(action, options);
  }
};

/*--------------------------------------------------------------------------*/

Form.Element = {
  focus: function(element) {
    $(element).focus();
    return element;
  },

  select: function(element) {
    $(element).select();
    return element;
  }
};

Form.Element.Methods = {
  serialize: function(element) {
    element = $(element);
    if (!element.disabled && element.name) {
      var value = element.getValue();
      if (value != undefined) {
        var pair = { };
        pair[element.name] = value;
        return Object.toQueryString(pair);
      }
    }
    return '';
  },

  getValue: function(element) {
    element = $(element);
    var method = element.tagName.toLowerCase();
    return Form.Element.Serializers[method](element);
  },

  setValue: function(element, value) {
    element = $(element);
    var method = element.tagName.toLowerCase();
    Form.Element.Serializers[method](element, value);
    return element;
  },

  clear: function(element) {
    $(element).value = '';
    return element;
  },

  present: function(element) {
    return $(element).value != '';
  },

  activate: function(element) {
    element = $(element);
    try {
      element.focus();
      if (element.select && (element.tagName.toLowerCase() != 'input' ||
          !['button', 'reset', 'submit'].include(element.type)))
        element.select();
    } catch (e) { }
    return element;
  },

  disable: function(element) {
    element = $(element);
    element.blur();
    element.disabled = true;
    return element;
  },

  enable: function(element) {
    element = $(element);
    element.disabled = false;
    return element;
  }
};

/*--------------------------------------------------------------------------*/

var Field = Form.Element;
var $F = Form.Element.Methods.getValue;

/*--------------------------------------------------------------------------*/

Form.Element.Serializers = {
  input: function(element, value) {
    switch (element.type.toLowerCase()) {
      case 'checkbox':
      case 'radio':
        return Form.Element.Serializers.inputSelector(element, value);
      default:
        return Form.Element.Serializers.textarea(element, value);
    }
  },

  inputSelector: function(element, value) {
    if (Object.isUndefined(value)) return element.checked ? element.value : null;
    else element.checked = !!value;
  },

  textarea: function(element, value) {
    if (Object.isUndefined(value)) return element.value;
    else element.value = value;
  },

  select: function(element, index) {
    if (Object.isUndefined(index))
      return this[element.type == 'select-one' ?
        'selectOne' : 'selectMany'](element);
    else {
      var opt, value, single = !Object.isArray(index);
      for (var i = 0, length = element.length; i < length; i++) {
        opt = element.options[i];
        value = this.optionValue(opt);
        if (single) {
          if (value == index) {
            opt.selected = true;
            return;
          }
        }
        else opt.selected = index.include(value);
      }
    }
  },

  selectOne: function(element) {
    var index = element.selectedIndex;
    return index >= 0 ? this.optionValue(element.options[index]) : null;
  },

  selectMany: function(element) {
    var values, length = element.length;
    if (!length) return null;

    for (var i = 0, values = []; i < length; i++) {
      var opt = element.options[i];
      if (opt.selected) values.push(this.optionValue(opt));
    }
    return values;
  },

  optionValue: function(opt) {
    // extend element because hasAttribute may not be native
    return Element.extend(opt).hasAttribute('value') ? opt.value : opt.text;
  }
};

/*--------------------------------------------------------------------------*/

Abstract.TimedObserver = Class.create(PeriodicalExecuter, {
  initialize: function($super, element, frequency, callback) {
    $super(callback, frequency);
    this.element   = $(element);
    this.lastValue = this.getValue();
  },

  execute: function() {
    var value = this.getValue();
    if (Object.isString(this.lastValue) && Object.isString(value) ?
        this.lastValue != value : String(this.lastValue) != String(value)) {
      this.callback(this.element, value);
      this.lastValue = value;
    }
  }
});

Form.Element.Observer = Class.create(Abstract.TimedObserver, {
  getValue: function() {
    return Form.Element.getValue(this.element);
  }
});

Form.Observer = Class.create(Abstract.TimedObserver, {
  getValue: function() {
    return Form.serialize(this.element);
  }
});

/*--------------------------------------------------------------------------*/

Abstract.EventObserver = Class.create({
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
    Form.getElements(this.element).each(this.registerCallback, this);
  },

  registerCallback: function(element) {
    if (element.type) {
      switch (element.type.toLowerCase()) {
        case 'checkbox':
        case 'radio':
          Event.observe(element, 'click', this.onElementEvent.bind(this));
          break;
        default:
          Event.observe(element, 'change', this.onElementEvent.bind(this));
          break;
      }
    }
  }
});

Form.Element.EventObserver = Class.create(Abstract.EventObserver, {
  getValue: function() {
    return Form.Element.getValue(this.element);
  }
});

Form.EventObserver = Class.create(Abstract.EventObserver, {
  getValue: function() {
    return Form.serialize(this.element);
  }
});
if (!window.Event) var Event = { };

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
  KEY_HOME:     36,
  KEY_END:      35,
  KEY_PAGEUP:   33,
  KEY_PAGEDOWN: 34,
  KEY_INSERT:   45,

  cache: { },

  relatedTarget: function(event) {
    var element;
    switch(event.type) {
      case 'mouseover': element = event.fromElement; break;
      case 'mouseout':  element = event.toElement;   break;
      default: return null;
    }
    return Element.extend(element);
  }
});

Event.Methods = (function() {
  var isButton;

  if (Prototype.Browser.IE) {
    var buttonMap = { 0: 1, 1: 4, 2: 2 };
    isButton = function(event, code) {
      return event.button == buttonMap[code];
    };

  } else if (Prototype.Browser.WebKit) {
    isButton = function(event, code) {
      switch (code) {
        case 0: return event.which == 1 && !event.metaKey;
        case 1: return event.which == 1 && event.metaKey;
        default: return false;
      }
    };

  } else {
    isButton = function(event, code) {
      return event.which ? (event.which === code + 1) : (event.button === code);
    };
  }

  return {
    isLeftClick:   function(event) { return isButton(event, 0) },
    isMiddleClick: function(event) { return isButton(event, 1) },
    isRightClick:  function(event) { return isButton(event, 2) },

    element: function(event) {
      var node = Event.extend(event).target;
      return Element.extend(node.nodeType == Node.TEXT_NODE ? node.parentNode : node);
    },

    findElement: function(event, expression) {
      var element = Event.element(event);
      if (!expression) return element;
      var elements = [element].concat(element.ancestors());
      return Selector.findElement(elements, expression, 0);
    },

    pointer: function(event) {
      return {
        x: event.pageX || (event.clientX +
          (document.documentElement.scrollLeft || document.body.scrollLeft)),
        y: event.pageY || (event.clientY +
          (document.documentElement.scrollTop || document.body.scrollTop))
      };
    },

    pointerX: function(event) { return Event.pointer(event).x },
    pointerY: function(event) { return Event.pointer(event).y },

    stop: function(event) {
      Event.extend(event);
      event.preventDefault();
      event.stopPropagation();
      event.stopped = true;
    }
  };
})();

Event.extend = (function() {
  var methods = Object.keys(Event.Methods).inject({ }, function(m, name) {
    m[name] = Event.Methods[name].methodize();
    return m;
  });

  if (Prototype.Browser.IE) {
    Object.extend(methods, {
      stopPropagation: function() { this.cancelBubble = true },
      preventDefault:  function() { this.returnValue = false },
      inspect: function() { return "[object Event]" }
    });

    return function(event) {
      if (!event) return false;
      if (event._extendedByPrototype) return event;

      event._extendedByPrototype = Prototype.emptyFunction;
      var pointer = Event.pointer(event);
      Object.extend(event, {
        target: event.srcElement,
        relatedTarget: Event.relatedTarget(event),
        pageX:  pointer.x,
        pageY:  pointer.y
      });
      return Object.extend(event, methods);
    };

  } else {
    Event.prototype = Event.prototype || document.createEvent("HTMLEvents").__proto__;
    Object.extend(Event.prototype, methods);
    return Prototype.K;
  }
})();

Object.extend(Event, (function() {
  var cache = Event.cache;

  function getEventID(element) {
    if (element._prototypeEventID) return element._prototypeEventID[0];
    arguments.callee.id = arguments.callee.id || 1;
    return element._prototypeEventID = [++arguments.callee.id];
  }

  function getDOMEventName(eventName) {
    if (eventName && eventName.include(':')) return "dataavailable";
    return eventName;
  }

  function getCacheForID(id) {
    return cache[id] = cache[id] || { };
  }

  function getWrappersForEventName(id, eventName) {
    var c = getCacheForID(id);
    return c[eventName] = c[eventName] || [];
  }

  function createWrapper(element, eventName, handler) {
    var id = getEventID(element);
    var c = getWrappersForEventName(id, eventName);
    if (c.pluck("handler").include(handler)) return false;

    var wrapper = function(event) {
      if (!Event || !Event.extend ||
        (event.eventName && event.eventName != eventName))
          return false;

      Event.extend(event);
      handler.call(element, event);
    };

    wrapper.handler = handler;
    c.push(wrapper);
    return wrapper;
  }

  function findWrapper(id, eventName, handler) {
    var c = getWrappersForEventName(id, eventName);
    return c.find(function(wrapper) { return wrapper.handler == handler });
  }

  function destroyWrapper(id, eventName, handler) {
    var c = getCacheForID(id);
    if (!c[eventName]) return false;
    c[eventName] = c[eventName].without(findWrapper(id, eventName, handler));
  }

  function destroyCache() {
    for (var id in cache)
      for (var eventName in cache[id])
        cache[id][eventName] = null;
  }

  if (window.attachEvent) {
    window.attachEvent("onunload", destroyCache);
  }

  return {
    observe: function(element, eventName, handler) {
      element = $(element);
      var name = getDOMEventName(eventName);

      var wrapper = createWrapper(element, eventName, handler);
      if (!wrapper) return element;

      if (element.addEventListener) {
        element.addEventListener(name, wrapper, false);
      } else {
        element.attachEvent("on" + name, wrapper);
      }

      return element;
    },

    stopObserving: function(element, eventName, handler) {
      element = $(element);
      var id = getEventID(element), name = getDOMEventName(eventName);

      if (!handler && eventName) {
        getWrappersForEventName(id, eventName).each(function(wrapper) {
          element.stopObserving(eventName, wrapper.handler);
        });
        return element;

      } else if (!eventName) {
        Object.keys(getCacheForID(id)).each(function(eventName) {
          element.stopObserving(eventName);
        });
        return element;
      }

      var wrapper = findWrapper(id, eventName, handler);
      if (!wrapper) return element;

      if (element.removeEventListener) {
        element.removeEventListener(name, wrapper, false);
      } else {
        element.detachEvent("on" + name, wrapper);
      }

      destroyWrapper(id, eventName, handler);

      return element;
    },

    fire: function(element, eventName, memo) {
      element = $(element);
      if (element == document && document.createEvent && !element.dispatchEvent)
        element = document.documentElement;

      var event;
      if (document.createEvent) {
        event = document.createEvent("HTMLEvents");
        event.initEvent("dataavailable", true, true);
      } else {
        event = document.createEventObject();
        event.eventType = "ondataavailable";
      }

      event.eventName = eventName;
      event.memo = memo || { };

      if (document.createEvent) {
        element.dispatchEvent(event);
      } else {
        element.fireEvent(event.eventType, event);
      }

      return Event.extend(event);
    }
  };
})());

Object.extend(Event, Event.Methods);

Element.addMethods({
  fire:          Event.fire,
  observe:       Event.observe,
  stopObserving: Event.stopObserving
});

Object.extend(document, {
  fire:          Element.Methods.fire.methodize(),
  observe:       Element.Methods.observe.methodize(),
  stopObserving: Element.Methods.stopObserving.methodize(),
  loaded:        false
});

(function() {
  /* Support for the DOMContentLoaded event is based on work by Dan Webb,
     Matthias Miller, Dean Edwards and John Resig. */

  var timer;

  function fireContentLoadedEvent() {
    if (document.loaded) return;
    if (timer) window.clearInterval(timer);
    document.fire("dom:loaded");
    document.loaded = true;
  }

  if (document.addEventListener) {
    if (Prototype.Browser.WebKit) {
      timer = window.setInterval(function() {
        if (/loaded|complete/.test(document.readyState))
          fireContentLoadedEvent();
      }, 0);

      Event.observe(window, "load", fireContentLoadedEvent);

    } else {
      document.addEventListener("DOMContentLoaded",
        fireContentLoadedEvent, false);
    }

  } else {
    //document.write("<script id=__onDOMContentLoaded defer src=//:><\/script>");
    //document.write("<script id=\"__onDOMContentLoaded\" defer=\"defer\" ><\/script>");
    document.write("<script id=__onDOMContentLoaded defer='defer' >timer = window.setInterval("+
                "function() { if (this.readyState == 'complete') { this.onreadystatechange = null; fireContentLoadedEvent(); } },100);<\/script>");
    $("__onDOMContentLoaded").OFFonreadystatechange = function() {
      if (this.readyState == "complete") {
        this.onreadystatechange = null;
        fireContentLoadedEvent();
      }
    };
  }
})();
/*------------------------------- DEPRECATED -------------------------------*/

Hash.toQueryString = Object.toQueryString;

var Toggle = { display: Element.toggle };

Element.Methods.childOf = Element.Methods.descendantOf;

var Insertion = {
  Before: function(element, content) {
    return Element.insert(element, {before:content});
  },

  Top: function(element, content) {
    return Element.insert(element, {top:content});
  },

  Bottom: function(element, content) {
    return Element.insert(element, {bottom:content});
  },

  After: function(element, content) {
    return Element.insert(element, {after:content});
  }
};

var $continue = new Error('"throw $continue" is deprecated, use "return" instead');

// This should be moved to script.aculo.us; notice the deprecated methods
// further below, that map to the newer Element methods.
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

  // caches x/y coordinate pair to use with overlap
  within: function(element, x, y) {
    if (this.includeScrollOffsets)
      return this.withinIncludingScrolloffsets(element, x, y);
    this.xcomp = x;
    this.ycomp = y;
    this.offset = Element.cumulativeOffset(element);

    return (y >= this.offset[1] &&
            y <  this.offset[1] + element.offsetHeight &&
            x >= this.offset[0] &&
            x <  this.offset[0] + element.offsetWidth);
  },

  withinIncludingScrolloffsets: function(element, x, y) {
    var offsetcache = Element.cumulativeScrollOffset(element);

    this.xcomp = x + offsetcache[0] - this.deltaX;
    this.ycomp = y + offsetcache[1] - this.deltaY;
    this.offset = Element.cumulativeOffset(element);

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

  // Deprecation layer -- use newer Element methods now (1.5.2).

  cumulativeOffset: Element.Methods.cumulativeOffset,

  positionedOffset: Element.Methods.positionedOffset,

  absolutize: function(element) {
    Position.prepare();
    return Element.absolutize(element);
  },

  relativize: function(element) {
    Position.prepare();
    return Element.relativize(element);
  },

  realOffset: Element.Methods.cumulativeScrollOffset,

  offsetParent: Element.Methods.getOffsetParent,

  page: Element.Methods.viewportOffset,

  clone: function(source, target, options) {
    options = options || { };
    return Element.clonePosition(target, source, options);
  }
};

/*--------------------------------------------------------------------------*/

if (!document.getElementsByClassName) document.getElementsByClassName = function(instanceMethods){
  function iter(name) {
    return name.blank() ? null : "[contains(concat(' ', @class, ' '), ' " + name + " ')]";
  }

  instanceMethods.getElementsByClassName = Prototype.BrowserFeatures.XPath ?
  function(element, className) {
    className = className.toString().strip();
    var cond = /\s/.test(className) ? $w(className).map(iter).join('') : iter(className);
    return cond ? document._getElementsByXPath('.//*' + cond, element) : [];
  } : function(element, className) {
    className = className.toString().strip();
    var elements = [], classNames = (/\s/.test(className) ? $w(className) : null);
    if (!classNames && !className) return elements;

    var nodes = $(element).getElementsByTagName('*');
    className = ' ' + className + ' ';

    for (var i = 0, child, cn; child = nodes[i]; i++) {
      if (child.className && (cn = ' ' + child.className + ' ') && (cn.include(className) ||
          (classNames && classNames.all(function(name) {
            return !name.toString().blank() && cn.include(' ' + name + ' ');
          }))))
        elements.push(Element.extend(child));
    }
    return elements;
  };

  return function(className, parentElement) {
    return $(parentElement || document.body).getElementsByClassName(className);
  };
}(Element.Methods);

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
    this.set($A(this).concat(classNameToAdd).join(' '));
  },

  remove: function(classNameToRemove) {
    if (!this.include(classNameToRemove)) return;
    this.set($A(this).without(classNameToRemove).join(' '));
  },

  toString: function() {
    return $A(this).join(' ');
  }
};

Object.extend(Element.ClassNames.prototype, Enumerable);

/*--------------------------------------------------------------------------*/

Element.addMethods();

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
   if (!isUndefined(confirm_text)) {
      if (confirm(confirm_text)) $(form).submit();
   } else {
      if (!isUndefined(form)) {
      	$(form).submit();
	}
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
inmForm.getVisibleElements = function (id,bCheckDisabled,bCheckHidden) {
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
	return inmForm.getElements(id).select(anonFunc);
}
inmForm.focusNextElement = function (rootEl,actualEl,funcLast) {
	if (isUndefined(rootEl) || !rootEl) return false;
	aList = inmForm.getVisibleElements(rootEl).sortBy(function(el,pos) { return el.tabIndex; });
	if (aList.length) {
		if (isUndefined(actualEl)) {
			if (aList[0].select) aList[0].select();
			aList[0].focus();
		} else {
			for (i=0; i<aList.length; i++) {
				if (aList[i]==actualEl) {
					if (!isUndefined(aList[i+1])) {
						if (aList[i+1].type=="text") aList[i+1].select();
						aList[i+1].focus();
						rval = true;
					} else {
						if (isFunction(funcLast)) {
							rval = funcLast(aList[i]);
						} else rval = false;
					}
					break;
				}
			}
		}
	} else rval = false;
	return rval;
}

var $FLD = function (frm,type,name) {
	var tmp = inmForm.getInputs(frm,type,name);
	if (!tmp || isUndefined(tmp)) return;
	var tmpid = tmp[0];
	if (!tmpid || isUndefined(tmpid)) return;
	return Form.Element.getValue(tmpid);
}

var HashMap = Class.create();
HashMap.prototype = {
	initialize: function HashMap() {
		this.aKeys = new Array();
		this.aVals = new Array();
	},
	put: function put (key,val) {
		pos = this.aKeys.length;
		for (var i=0; i<this.aKeys.length; i++) 
			if (this.aKeys[i]==key) {
				pos = i;
				break;
			}
		this.aKeys[pos] = key;
		this.aVals[pos] = val;
	},
	get: function get (key) {
		for (var i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) return this.aVals[i];
		}
	},
	remove: function remove (key) {
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) {
				this.aKeys[i] = null;
				this.aVals[i] = null;
				for (var j=i; j<(this.aKeys.length-1); j++) {
					this.aKeys[j]=this.aKeys[j+1];
					this.aVals[j]=this.aVals[j+1];
				}
				this.aKeys.length--;
				this.aVals.length--;
				return true;
			}
		}
		return false;
	},
	keys: function keys () {
		return this.aKeys;
	},
	toQueryString: function () {
		rval = '';
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aVals[i] && !isUndefined(this.aVals[i]) && 
				(isNumber(this.aVals[i]) || this.aVals[i].length>0 ) ) {
				if (rval.length>0) rval += '&';
				rval += this.aKeys[i]+'='+this.aVals[i];
			}
		}
		return rval;
	},

	limitTo: function (n) {
		var strK="";
		//for (var k in this.aKeys) if (!isFunction(k) && !isFunction(this.aKeys[k])) strK+=" k: "+this.aKeys[k];
		//alert("limitTo "+n+" / "+this.aKeys.length+" que son: "+strK);
		if (this.aKeys.length>0 && this.aKeys.length>n) {
			this.remove(this.aKeys.first());
		}
	},

	count: function () {
		return this.aKeys.length;
	}
}

var mydom = Class.create();
mydom.findElements = function (oBase,tag,name) {
	var aRetVal = new Array();

	oId = $(oBase);
	if (!tag && !name) return;

	var bName = undefined;
	if (!isUndefined(tag)) { 
		bName = false;
		aTmpList = document.getElementsByTagName(tag); 
	} else { 
		// Antes estaba este primero. Pero getElementsByName, aunque existe en IE para WinCE, devuelve una lista vacia :(
		// Asi que, siempre vamos a hacer la busqueda con getElementsByTagName.
		aTmpList = document.getElementsByName(name); 
		bName = true;
	}
	if (!isUndefined(name)) bName = true;
	else bName = false;

	for (var i=0; i<aTmpList.length; i++) {
		// Comprobamos que es el tag que buscamos
		if (!isUndefined(tag) && aTmpList[i].tagName.toUpperCase() != tag.toUpperCase()) { continue; }
		if (!isUndefined(name) ) {
			try {
				tmp = Element.readAttribute(aTmpList[i],"name");
			} catch (e) { 
				tmp = undefined; 
			}
			if (isString(tmp) && tmp.toUpperCase() != name.toUpperCase()) { continue; }
		}
		// Comprobamos que sea descendiente de la base.
		for (var element = aTmpList[i]; element.parentNode; element = element.parentNode) {
			if (element == oBase) {
				//alert("OK!! ");
				aRetVal[aRetVal.length] = aTmpList[i];
			}
		}
	}
	return aRetVal;
}


var SonSwitchByCSS = Class.create();
SonSwitchByCSS.prototype = {
	cssContentHidden: 'RowBlur',
	cssContent: 'RowStd',
	cssContentHighLight: 'RowHi',
	bDisableForm: false,
	oItem: null,
	initialize: function SonSwitchByCSS(oParent,oDomItem) {
		this.oItem = $(oDomItem);
		//.domBasethis.oParent = $(oParent);
		this.oParent = oParent;
		return this;
	},

	blur: function SonSwitchByCSS__blur() {
		oRow = this.getItem();
		if (this.bDisableForm) inmForm.disableDescendants(oRow);
		oRow.className = this.cssContentHidden;
		//alert("blur base (" +oRow.id+ ") para " + oRow.getAttribute('name') + " tipo: " + oRow + " poniendo clas: " + oRow.className);
	},

	glow: function SonSwitchByCSS__glow() {
		oRow = this.oItem;
		// alert("Glow sobre " + oRow + " nombre: " + oRow.getAttribute('name') + " css: " + this.cssContent);
		oRow.className = this.cssContent;
		if (this.bDisableForm) inmForm.enableDescendants(oRow);
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
		this.aEvents.put('LET_A',new Array());
		this.aEvents.put('ALL',new Array());
	},

	abc: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
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
				} else if (code >= 65 && code <= 90) {
					retval = 'LET_' + this.abc[code-65];
					//alert("Codigo REconocido: "+retval);
				} else {
					retval = '';
					//alert("Codigo desconocido: "+code);
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
			for (var i=0; i<evList.length; i++) {
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
				if (false && !isFunction(evList[i])) {
					//alert(" putaaAaAaAaaAaaAAaaAaAaaAaaaa "+i+" de tot: "+evList.length);
					continue;
				}
				//alert("El rval: "+rval)
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
		//pause(100);
		return retval;
	}
}

/** FIN de para desplzara a una extension de prototipos **/

var TableSwitcher = Class.create();
TableSwitcher.prototype = {
	cssContentHidden: 'oculto',
	cssContentVisible: 'full',
	defaultHandler: undefined,
	initialize: function TableSwitcher(domID) {
		if (!isUndefined(domID) && domID != null) {
			this.domLegend = domID;
		} else this.domLegend = undefined;
		this.current = -1;
		this.aTables = new Array();
		this.aKeys = new Array();
		document.bgColor = "#FFFFCC";
	},

	add: function add(oTb,strKey) {
		if (isUndefined(oTb) || isUndefined(oTb.registerSwitch)) return;
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
			if (!isUndefined(this.aTables[this.current].keyPress)) {
				retval = this.aTables[this.current].keyPress(aT,ev);
			} else if (!isUndefined(this.defaultHandler)) { this.defaultHandler(aT,ev); }
		} else {
			// true, es en realidad "yo me encargo"
			retval = false;
			for (i=0;i<this.aKeys.length;i++) {
				if (aT.strKey==this.aKeys[i]) {
					this.activate(i);
					retval = true;
					//alert("Activando. "+i+" rv: "+retval);
					break;
				}
			}
			if (!retval && !isUndefined(this.defaultHandler)) { this.defaultHandler(aT,ev); }
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
		if (!isUndefined(this.domLegend)) this.domLegend.className = this.cssContentHidden;
		if (this.aTables[this.current].focus) this.aTables[this.current].focus();
	},

	deactivate: function (pos) {
		//if (this.current != pos) return;
		// alert("DE-Activando "+this.aTables[pos]+" num: "+pos+" cur:"+this.current+" mnu: "+this.domLegend);
		document.bgColor = "#FFFFCC";
		this.aTables[pos].blur();
		this.current = -1;
		if (!isUndefined(this.domLegend)) this.domLegend.className = this.cssContentVisible;
	},

	registerDefaultKeyHandler: function (fnc) {
		if (!isUndefined(fnc) && isFunction(fnc)) this.defaultHandler = fnc;
	}
}

var Menu = Class.create({
	formID: undefined,
	initialize: function(frmID) {
		if (!isUndefined(frmID)) this.formID = frmID;
	},

	keyPress: function key(aT,ev) {
		if (isUndefined(this.formID)) { return false; }
		switch (aT.strKey) {
			case "NUM_0":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_0');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_0_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_0_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_1":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_1');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_1_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_1_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_2":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_2');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_2_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_2_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_3":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_3');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_3_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_3_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_4":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_4');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_4_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_4_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_5":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_5');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_5_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_5_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_6":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_6');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_6_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_6_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_7":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_7');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_7_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_7_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;
		}
	},

	selectItem: function select(oRow) {
		//if (isUndefined(this.formID)) { return false; }
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
	}
});

var TableBrowser = Class.create();
TableBrowser.prototype = {
	cssContentHidden: 'oculto',
	cssContentVisible: 'RowStd',
	defaultHandler: undefined,
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
			var ss_name = $FLD(oFrm,'hidden','__iface_followup');
			if (ss_name && ss_name.length > 1) {
				var vname = $FLD(oFrm,'hidden','__iface_followup_setvar');
				var vvalue = $FLD(oFrm,'hidden','__iface_followup_setval');
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

	registerDefaultKeyHandler: function (fnc) {
		if (!isUndefined(fnc) && isFunction(fnc)) this.defaultHandler = fnc;
	},

	registerSwitch: function (oSWitch,pos) {
		this.oTbSwitch = oSWitch;
		this.oTbPos = pos;
	},

	focus: function () {
		//alert('Activando foco a '+this.domTable);
		this.domTable.className = this.cssContentVisible;
		if (this.aChildren.length>0) {
			for (var i = this.aChildren.length-1; i>=1; i--) {
				if (this.aChildren[i].blur) this.aChildren[i].blur();
			}
			if (this.aChildren[0].focus) this.aChildren[0].focus();
		}
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
			aTecla = KeyboardDriver.prototype.mapKeyCode(code);
		} else if (aT && isString(aT.strKey)) aTecla = aT;
		else if (aT && isNumber(aT.keyCode)) {
			code = aT.keyCode;
			aTecla = KeyboardDriver.prototype.mapKeyCode(code);
		} else aTecla = aT;

		if (!self.bBlockedKeys) {
			var tecla = aTecla.strKey;
			switch (tecla) {
				case "ESC":
					//alert("Escape en table broser ");
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

				default:
					if (!isUndefined(this.defaultHandler)) { this.defaultHandler(aT,evento); }
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
				//if (!isUndefined(oI)) window.scrollTo(0,oI.offsetTop);
				Element.scrollTo(oI);
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
				Element.scrollTo(oI);
				//window.scrollTo(0,oI.offsetTop);
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
		return mydom.findElements(oBase,tag,name);
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

//var CodigoBarras = Class.create();
//CodigoBarras.inherits(SonSwitchByCSS);
var tmpMethods = {
	actual_code: '',
	initialize: function CodigoBarras ($super,parent,id,oChange,bBlock) {
		//this.uber('initialize',parent,id);
		$super(parent,id);
		this.activo = true;
		this.bCodigoOK = false;
		if (isUndefined(bBlock)) bBlock = false; //FixMe: Cambiar esto a true
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

	blur: function blur($super) {
		//this.uber('blur');
		$super();
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
//Object.extend(CodigoBarras.prototype,tmpMethods);
var CodigoBarras = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var Localizacion = Class.create();
//Localizacion.inherits(SonSwitchByCSS);
var tmpMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',

	initialize: function Localizacion ($super,parent,id) {
		//this.uber('initialize',parent,id);
		$super(parent,id);
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
			if (!isUndefined(this.oParent) && !isUndefined(this.oParent.oParent)) 
				aICodBarras = this.oParent.oParent.findElement(oI,'div','CBarras_localizacion');
			else aICodBarras = mydom.findElements(oI,'div','CBarras_localizacion');
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
				if (this.setLocationFromString(val)) {
					bDone = true;
					if (!isUndefined(this.oParent.sActivo)) {
						this.oParent.sActivo = false;
						this.oParent.bBlockedKeys = false;
					} else if (!isUndefined(this.oParent.moveDown)) {
						this.oParent.moveDown();
						bDone = false;
					}
				}
			}
		} 
		//if (bDone) { alert("this.submitForm()"); }
		if (bDone) { this.submitForm(); }
		return false;
	},

	setLocationFromString: function (strCode) {
		var rval = false;
		var aLoc = this.parseLocation(strCode);
		if (isObject(aLoc)) {
			//for (var k in aLoc) 
			var aTmp = Object.keys(aLoc);
			var k;
			for (var j=aTmp.length; j>=0; j--) {
				k = aTmp[j];
				if (!isFunction(k) && !isFunction(this.aLoc[k]) && !isObject(k) && this.aLoc[k]) { 
					Element.setValue(this.aLoc[k],aLoc[k]); 
					rval = true;
				}
			}
		} else rval = false;
		return rval;
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

	formatLocation: function () {
		var rval = '', tmp='';
		tmp = this.aLoc['zona'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aLoc['planta'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['pasillo'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['columna'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['fila'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp;
		return rval;
	},

	keyPress: function keypress(aTecla,ev) {
		retval = false;
		strKey = aTecla.strKey;
		switch (strKey) {
			case "ESC":
				this.done();
				retval = true;
				break;

			case "INTRO":
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				// alert("Siguiente campo .. ");
				this.nextField(ev.element);
				retval = true;
				// alert("Intro de guay ... ");
				break;

		}
		return retval;
	},

	nextField: function next(tg) {
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
				if (this.oParent && this.oParent.oParent) {
					this.oParent.oParent.bBlockedKeys = false;
				}
				if (this.oParent.glow) this.oParent.glow();
				// this.aLoc['fila'].focus();
				if (isObject(this.oCB)) this.oCB.bCodigoOK = true;
				this.done();
				break;
			default:
				if (this.aLoc && this.aLoc['zona']) {
					this.aLoc['zona'].focus();
					this.fldActivo = 'zona';
				} else {
					var itm = this.getItem();
					aList = inmForm.getVisibleElements(itm).sortBy(function(el,pos) { return el.tabIndex; });
					if (aList.length) {
						if (!isUndefined(tg)) {
							for (i=0; i<aList.length; i++) {
								if (aList[i]==tg) {
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
					}
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

	blur: function blur($super) {
		if (this.oCB && this.oCB.blur) {
			this.oCB.blur();
		}
		//this.uber('blur');
		$super();
		this.fldActivo = false;
		return true;
	},

	focus: function focus() {
		this.highLight();
		this.oParent.bBlockedKeys = true;
		retval = true;
		if (isObject(this.oCB) && !isUndefined(this.oCB.focus)) {
			this.oCB.focus();
		} else {
			retval = true;
			if (this.aLoc && this.aLoc['zona']) {
				this.aLoc['zona'].focus();
				this.fldActivo = 'zona';
			} else { 
				var aItms = inmForm.getVisibleElements(this.getItem()).sortBy(function(el,pos) { return el.tabIndex; });
				if (aItms.length) {
					oTarget = aItms[0];
					if (oTarget.select) oTarget.select();
					oTarget.focus();
				}
			}
		}
		return retval;
	}
}
//Object.extend(Localizacion.prototype,tmpMethods);
var Localizacion = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var SKU = Class.create();
//SKU.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function SKU ($super,parent,id) {
		//this.uber('initialize',parent,id);
		$super(parent,id);

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

	formatSKU: function () {
		var rval = '', tmp='';
		tmp = this.aSKU['anyo'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aSKU['mes'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aSKU['dia'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'*';
		tmp = this.aSKU['lote'].getValue();
		rval += tmp;
		return rval;
	},

	setSKUFromArray: function (aRec) {
		var rval = false;
		if (isObject(aRec)) {
			for (k in aRec) { 
				if (!isFunction(k) && !isFunction(this.aSKU[k]) && !isObject(k) && this.aSKU[k]) { 
					Element.setValue(this.aSKU[k],aRec[k]); 
					rval = true;
				}
			}
		}
		return rval;
	},

	focus: function focus() {
		this.highLight();
		if (this.aSKU['dia']) {
			this.aSKU['dia'].focus();
			this.aSKU['dia'].select();
		}
	},

	keyPress: function keypress(aTecla,ev) {
		rval = false;
		strKey = aTecla.strKey;
		switch (strKey) {
			case "ESC":
				if (!isUndefined(this.oParent) && isFunction(this.oParent.moveDown)) {
					this.oParent.moveDown();
					rval = true;
				} else if (!isUndefined(this.oParent) && !isUndefined(this.oParent.oParent)) {
					this.oParent.oParent.bBlockedKeys = false;
					this.blur();
					rval = true;
				} else rval = false;
				break;

			case "INTRO":
				//alert("Intro sin guay ... " + ev + " en realidad: " + Event.element(ev));
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				//alert("Next field de "+ev.element());
				this.nextField(ev.element());
				rval = true;
				break;

			case "UP":
				if (!isUndefined(ev.element()) && ev.element().type=='text') {
					var fld = this.findFieldName(ev);
					if (isString(fld) && fld.length>0) {
						var cnt = 1, orig=0;
						if (fld=='dia') cnt=7;
						orig = this.aSKU[fld].getValue()*1;
						this.aSKU[fld].setValue(orig+cnt);
					}
					rval = true;
				}
				break;

			case "DOWN":
				if (!isUndefined(ev.element()) && ev.element().type=='text') {
					var fld = this.findFieldName(ev);
					if (isString(fld) && fld.length>0) {
						var cnt = 1, orig=0;
						if (fld=='dia') cnt=7;
						orig = this.aSKU[fld].getValue()*1;
						this.aSKU[fld].setValue(orig-cnt);
					}
					rval = true;
				}
		}
		return rval;
	},

	findFieldName: function (ev) {
		var fld = '';
		for (var key in this.aSKU) {
			if (isFunction(key) || isFunction(this.aSKU[key])) continue;
			if (this.aSKU[key]==ev.element()) {
				fld = key;
				break;
			}
		}
		return fld;
	},

	nextField: function next(target) {
		//alert(this+" Siguiente a: "+target);
		inmForm.focusNextElement(this.getItem(),target,this.lastField.bind(this));
	},

	lastField: function (target) {
		if (this.oParent)
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
//Object.extend(SKU.prototype,tmpMethods);
var SKU = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var Cantidad = Class.create();
//Cantidad.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function Cantidad ($super,parent,id) {
		this.aCnt = { cantidad: null };
		$super(parent,id);
		//this.uber('initialize',parent,id);

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

	keyPress: function(aK,ev) {
		rval = false;
		switch (aK.strKey) {
			case "UP":
				cnt = this.get()*1;
				this.set(cnt+1);
				rval = true;
				break;
			case "DOWN":
				cnt = this.get()*1;
				this.set(cnt-1);
				rval = true;
				break;
		}
		return rval;
	},

	focus: function focus() {
		var retval;
		//alert("el retval del foco "+retval+" fld: "+this.aCnt['cantidad']);
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
//Object.extend(Cantidad.prototype,tmpMethods);
var Cantidad = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

var Menu2 = Class.create();
Menu2.prototype = {
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
	oLastTArea: undefined,
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
		//alert("Letrita palla ke ");
		if (aT.strKey!="INTRO" && !isUndefined(this.oLastTArea)) {
			this.oLastTArea = undefined;
		}
		//KeyboardDrivers::keyPress retorna bool Seguir Propagando Evento
		// A este metodo se le pregunta bool Si Se ha Encargado del Evento
		rval = this.oKb.keyPress(e);
		//alert("SKULoc::keyPress - Evento: "+e+" rval: "+rval);
		//return rval;
		return !rval;
	},

	enter: function (aT,e) {
		var targ;
		if (e.target) targ = e.target;
		else if (e.srcElement) targ = e.srcElement;
		if (targ.type=="textarea") {
			if (isUndefined(this.oLastTArea)) {
				//alert("Es un text area .. ");
				this.oLastTArea = targ;
				return false;
			} 
		}
		var rval = true;
		//var itm = this.getRoot();
		var itm = this.getItem();
		aList = inmForm.getVisibleElements(itm).sortBy(function(el,pos) { return el.tabIndex; });
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
		} else rval = false;
		return rval;
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
		//aItms = inmForm.getInputs(this.getItem(),'text');
		aItms = inmForm.getVisibleElements(this.getItem()).sortBy(function(el,pos) { return el.tabIndex; });
		if (aItms.length) {
			oTarget = aItms[0];
			if (oTarget.select) oTarget.select();
			if (oTarget.focus) oTarget.focus();
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

//var CBAjax = Class.create();
//CBAjax.inherits(SonSwitchByCSS);
var someMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',
	bDisableForm: false,
	initialize: function ($super,parent,id,oChange) {
		$super(parent,id);
		this.oCodigoCheck = undefined;
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				// alert("Elemento: " + aEl[i].getAttribute('name') + " tipo: " + aEl[i].type );
				if (Element.hasClassName(aEl[i],'codigobarras') && aEl[i].type == 'text') {
					this.oCodigoInput = aEl[i];
					/** **
					if (isUndefined(oChange) || !isObject(oChange)) {
						Event.observe(this.oCodigoInput,'change',this.changedBarCode.bindAsEventListener(this));
					} else {
						Event.observe(this.oCodigoInput,'change',oChange.changedBarCode.bindAsEventListener(oChange));
					}
					/** **/
					//if (!isUndefined(bBlock) && bBlock) Event.observe(this.oCodigoInput,'blur',this.blockField.bindAsEventListener(this));
				} else if (aEl[i].type == 'hidden' && Element.hasClassName(aEl[i],'codigobarras')) {
					this.oCodigoCheck = aEl[i];
				}
			}
		}
	},

	keyPress: function(aT,ev) {
		rval = false;
		switch (aT.strKey) {
			case "ESC":
				this.oParent.blurItem(this);
				rval = true;
				break;

			case "INTRO":
				this.oParent.asyncGetRef();
				rval = this.oParent.moveDown();
				break;
		}
		return rval;
	},

	changedBarCode: function() {
		alert("Codigo barras cambiao ");
	},

	focus: function focus() {
		//oI = this.getItem();
		//oI.className = this.cssContent;
		this.activo = true;
		this.glow();
		this.highLight();
		if (this.oCodigoInput) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	getValue: function () {
		return $F(this.oCodigoInput);
	}
}
//Object.extend(CBAjax.prototype,someMethods);
var CBAjax = Class.create(SonSwitchByCSS,someMethods);
someMethods = undefined;

//var ExtendedLocalizacion = Class.create();
//ExtendedLocalizacion.inherits(Localizacion);
someMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',
	bDisableForm: false,
	initialize: function ($super,parent,id) {
		//this.uber('initialize',parent,id);
		//alert("Llamando a padre joder "+parent+" el id: "+id);
		$super(parent,id);
        },
	keyPress: function ($super,aT,ev) {
		//this.uber('keyPress',aT,ev);
		var rval = $super(aT,ev);
		// alert("El de arriba rtona: "+rval);
		if (!rval) {
			switch (aT.strKey) {
				case "ESC":
					this.oParent.blurItem(this);
					rval = true;
					break;
			}
		}
		return rval;
	},

	lastField: function ($super,tg) {
		//alert("someMethods::lastField() ");
		this.oParent.moveDown();
		/** **
		//alert("someMethods::lastField() "+this);
		if (this.oParent.moveDown()) {
			alert(" selectItm: "+this.oParent.selectItem);
		} else {
			//alert("Falta enviar el formulario ");
			oFrm = tg.form;
			// Activamos los que esten ocultos, y mandamoslo
			if (oFrm) {
				inmForm.enable(oFrm);
				alert(oFrm.action+" oFrm.action ");
			}
		}
		/** **/
	}
}
//ExtendedLocalizacion.prototype = Object.extend(new ExtendedLocalizacion(),someMethods);
var ExtendedLocalizacion = Class.create(Localizacion,someMethods);

var ExtendedSKU = Class.create(SKU,someMethods);
//var ExtendedSKU = Class.create();
//ExtendedSKU.inherits(SKU);
//Object.extend(ExtendedSKU.prototype,someMethods);

someMethods.keyPress = function ($super,aT,ev) {
	//this.uber('keyPress',aT,ev);
	var rval = $super(aT,ev);
	//alert("El de arriba rtona: "+rval);
	if (!rval) {
		switch (aT.strKey) {
			case "ESC":
				this.oParent.blurItem(this);
				rval = true;
				break;
			case "INTRO":
				var val = this.get();
				if (val && !isUndefined(val) && val.length>0) {
					this.oParent.asyncSendForm();
				}
				rval = this.oParent.moveDown(true);
				break;
		}
	}
	return rval;
}


var ExtendedCantidad = Class.create(Cantidad,someMethods);
//var ExtendedCantidad = Class.create();
//ExtendedCantidad.inherits(Cantidad);
//ExtendedCantidad.prototype = Object.extend(new ExtendedCantidad(),someMethods);
//Object.extend(ExtendedCantidad.prototype,someMethods);
someMethods = undefined;

someMethods = {
	cssContentHidden: 'oculto',
	cssContent: 'RowStd',
	cssContentVisible: 'RowStd',
	initialize: function ($super,domItem) {
		$super(this,domItem);
	},
	registerSwitch: function (oMenu,pos) {
		this.oMenu = oMenu;
		this.menuPos = pos;
	},
	focus: function() {
		this.getItem().className = this.cssContentVisible;
	},
	blur: function(oItm) {
		this.getItem().className = this.cssContentHidden;
	},
	keyPress: function (aT,ev) {
		switch (aT.strKey) {
			case "ESC":
				if (this.oMenu) { this.oMenu.deactivate(this.menuPos); }
				break;
		}
	}
}
var ReferenceInfo = Class.create(SonSwitchByCSS,someMethods);


var var1 = "uno";
var DeliveryEntry = Class.create();
DeliveryEntry.prototype = {
	cssContentHidden: 'oculto',
	cssContent: 'RowStd',
	cssContentVisible: 'RowStd',
	bBlockKeyboard: false,
	itemActivo: undefined,
	parkFocus: undefined,
	lastRequest: undefined,
	lastResponse: undefined,
	Locations: new HashMap(),
	SKUs: new HashMap(),
	nRefCacheLimit: 2,
	urlBase: 'index.php',
	ajaxRecCount: 1,
	ajaxInfoDiv: undefined,
	ajaxStockDiv: undefined,
	ajaxStatusDiv: undefined,
	ajaxLogDiv: undefined,
	dRecordRequests: new HashMap(),
	RecordForm: undefined,
	tpRecordRequest: new Template("ref #{cbarras} enviada .. "),
	tpRecordResponseUnknown: new Template("<b>Error</b> respuesta desconocida. HTTP: #{status} #{statusText} ; ReqID: #{request_id}"),
	tpRecordResponseStatus: new Template("Request #{token} Albaran #{albaran} Lineas (n/e/b) : #{ndet_new}/#{ndet_edi}/#{ndet_del}"),
	tpRecordResponse: new Template("ReqID #{token} Albaran #{albaran} nuevo #{ndet_new} editados #{ndet_edi} borrados #{ndet_del}"),
	tpRefRequest: new Template("buscando codigo de barras #{cbarras} .. "),
	tpRefFound: new Template("#{nombre} [#{marca}] encontrado. #{cantidad_pendiente} pendiente en #{albaran} "),
	tpRefNotFound: new Template("codigo #{cbarras} <b>no se encuentra</b> en este albaran."),
	tpStockNotFound: new Template("#{cbarras} <b>desconocido</b> en el stock."),
	tpStockFound: new Template("#{articulo} (#{id}) contiene #{nlocalizaciones} localizaciones y #{nskus} fechas en todo el Almacen."),
	initialize: function (base) {
		if (!base || !base.id) return false;
		this.domBase = base;
		this.oMenu = undefined;
		this.menuPos = -1;
		this.itemActivo = undefined;
		this.dItems = new HashMap();

		//aList = this.domBase.getElementsByTagName('DIV');
		aList = mydom.findElements(this.domBase,'DIV');
		for (var i=aList.length-1; i>=0; i--) {
			//alert("Los div son: "+aList[i].id+" o "+aList[i].getAttribute('name'));
			if (aList[i].parentNode==this.domBase) {
				switch (aList[i].getAttribute('name')) {
					case "Cantidad":
						this.dItems.put('Cantidad',new ExtendedCantidad(this,aList[i]));
						break;
					case "Localizacion":
						this.dItems.put('Localizacion',new ExtendedLocalizacion(this,aList[i]));
						break;
					case "SKU":
						this.dItems.put("SKU",new ExtendedSKU(this,aList[i]));
						break;
					case "CodigoBarras":
						this.dItems.put('CodigoBarras',new CBAjax(this,aList[i]));
						break;
				}
			}
		}
	},

	registerSwitch: function (oMenu,pos) {
		this.oMenu = oMenu;
		this.menuPos = pos;
	},

	focus: function() {
		this.domBase.className = this.cssContentVisible;
		if (isUndefined(this.itemActivo)) {
			this.itemActivo = "CodigoBarras";
			aKeys = this.dItems.keys();
			for (var k in aKeys) {
				if (isFunction(aKeys[k])) continue;
				//alert("Llamando al glow de: "+aKeys[k]);
				this.dItems.get(aKeys[k]).blur();
			}
		}
		tmp = this.dItems.get(this.itemActivo);
		tmp.glow();
		tmp.focus();
		this.bBlockKeyboard = true;
	},
	blur: function(oItm) {
		aTmp = this.dItems.keys();
		for (var i = aTmp.length-1; i>=0; i--) {
			var oI = this.dItems.get(aTmp[i]);
			oI.blur();
		}
		this.domBase.className = this.cssContentHidden;
	},

	blurItem: function(oItm) {
		aTmp = this.dItems.keys();
		for (var i = aTmp.length-1; i>=0; i--) {
			var oI = this.dItems.get(aTmp[i]);
			if (oI==oItm) {
				if (this.parkFocus) this.parkFocus.focus();
				oI.blur();
				this.bBlockKeyboard = false;
				break;
			}
		}
	},

	setParkingFocus: function (id,oKB) {
		//Event.observe($(id),'keydown',this.keyParking.bind(this),true);
		//Event.observe($(id),'keypress',this.keyParking.bind(this),true);
		this.parkFocus = $(id);
		this.oKB = oKB;
	},

	keyParking: function (ev) {
		var code;
		if (ev && isNumber(ev.keyCode)) code = ev.keyCode;
		// alert(" Tecla aparcada tronco! ");
		// this.keyPress(this.oKB.mapKeyCode(code),ev);
		// if (ev.preventDefault) { ev.preventDefault(); }
		return false;
	},

	keyPress: function(aT,ev) {
		rval = false;
		// alert("keypress y tal no ");
		if (!isUndefined(this.itemActivo) && this.itemActivo != null && this.bBlockKeyboard) {
			oItm = this.dItems.get(this.itemActivo);
			rval = oItm.keyPress(aT,ev);
			// alert("para este, el "+this.itemActivo+" dice: "+rval);
		} else {
			//alert("No hay activo nada ");
			switch (aT.strKey) {
				case "ESC":
					if (this.oMenu) {
						this.oMenu.deactivate(this.menuPos);
					}
					rval = true;
					break;

				case "UP":
					rval = this.moveUp();
					break;

				case "DOWN":
					rval = this.moveDown();
					break;

				case "INTRO":
					if (!isUndefined(this.itemActivo)) {
						this.bBlockKeyboard = true;
						this.dItems.get(this.itemActivo).focus();
						rval = true;
					} else rval = false;
					break;

				case "LEFT":
					if (!isUndefined(this.itemActivo)) {
						switch (this.itemActivo) {
							case "Localizacion":
								rval = this.prevLocation();
								break;
							case "SKU":
								rval = this.prevSKU();
								break;
							default:
								rval = false;
						}
					} else rval = false;
					break;

				case "RIGHT":
					if (!isUndefined(this.itemActivo)) {
						switch (this.itemActivo) {
							case "Localizacion":
								rval = this.nextLocation();
								break;
							case "SKU":
								rval = this.nextSKU();
								break;
							default:
								rval = false;
						}
					} else rval = false;
					break;
			}
		}
		return rval;
	},

	moveDown: function(bFocus) {
		if (isUndefined(bFocus) || bFocus==null) bFocus=false;
		var anterior = this.itemActivo;
		var actual = null;
		switch (this.itemActivo) {
			case "CodigoBarras":
				actual = 'Localizacion';
				break;
			case "Localizacion":
				actual = 'SKU';
				break;
			case "SKU":
				actual = 'Cantidad';
				break;
			case "Cantidad":
				actual = 'CodigoBarras';
				break;
			default:
				alert("No hay item activo reconocible. ");
				return false;
		}
		this.itemActivo = actual;
		nuevo = this.dItems.get(this.itemActivo);
		//alert("El item anterior es "+anterior+" el nuevo es: "+actual+" focus? "+bFocus);
		if (!bFocus) {
			this.bBlockKeyboard = false;
			nuevo.glow();
		} else nuevo.focus();
		if (!isUndefined(anterior) && anterior != null) {
			old = this.dItems.get(anterior);
			old.blur();
			if (this.parkFocus && this.parkFocus.focus && !bFocus) this.parkFocus.focus();
		}
		return true;
	},

	moveUp: function(bFocus) {
		if (isUndefined(bFocus) || bFocus==null) bFocus=false;
		var anterior = this.itemActivo;
		var actual = null;
		switch (this.itemActivo) {
			case "CodigoBarras":
				actual = 'Cantidad';
				break;
			case "Localizacion":
				actual = 'CodigoBarras';
				break;
			case "SKU":
				actual = 'Localizacion';
				break;
			case "Cantidad":
				actual = 'SKU';
				break;
			default:
				alert("No hay item activo reconocible. ");
				return;
		}
		if (!isUndefined(anterior) && anterior != null) {
			old = this.dItems.get(anterior);
			if (this.parkFocus) this.parkFocus.focus();
			old.blur();
		}
		this.itemActivo = actual;
		nuevo = this.dItems.get(this.itemActivo);
		if (!bFocus) {
			this.bBlockKeyboard = false;
			nuevo.glow();
		} else nuevo.focus();
		return true;
	},

	nextLocation: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var locList = this.Locations.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('Localizacion');
			var current = oBase.formatLocation();
			var aKeys = Object.keys(locList,true);
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "00-:::" || current == "01-:::" ) {
					oBase.setLocationFromString(k);
					break;
				} else if (cnt == aKeys.length) {
					oBase.setLocationFromString(aKeys.first());
					break;
				} else if (current == k) current = "00-:::";
			}
		}
		return rval;
	},

	prevLocation: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var locList = this.Locations.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('Localizacion');
			var current = oBase.formatLocation();
			var aKeys = Object.keys(locList,true).reverse();
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "00-:::" || current == "01-:::") {
					oBase.setLocationFromString(k);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setLocationFromString(aKeys.first());
					break;
				} else if (current == k) current = "00-:::";
			}
		}
		return rval;
	},

	nextSKU: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var skuList = this.SKUs.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('SKU');
			var current = oBase.formatSKU();
			var aKeys = Object.keys(skuList,true);
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				//alert("claves.lng: "+aKeys.length+" estamos en "+cnt+" k es: "+k);
				if (isFunction(k)) continue;
				if (current == "--*") {
					oBase.setSKUFromArray(skuList[k]);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setSKUFromArray(skuList[aKeys.first()]);
				} else if (current == k) { current = "--*"; }
			}
		}
		return rval;
	},

	prevSKU: function() {
		if (isUndefined(this.lastResponse)) return true;
		var rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var skuList = this.SKUs.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('SKU');
			var current = oBase.formatSKU();
			var aKeys = Object.keys(skuList,true).reverse();
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "--*") {
					oBase.setSKUFromArray(skuList[k]);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setSKUFromArray(skuList[aKeys.first()]);
					break;
				} else if (current == k) current = "--*";
			}
		}
		return rval;
	},

	addRefLocation: function(id,aLoc) {
		// Esta linea de inidizlizacion, es para borrar.
		if (isUndefined(this.Locations)) this.Locations = new HashMap();
		if (isUndefined(aLoc) || !aLoc.localizacion || !aLoc.localizacion.length) {
			alert("addRefLocation() - No hay localizacion ");
			for (var k in aLoc) {
				var strDebug = "Las claves: \n";
				if (!isFunction(k)) strDebug += k+"\n";
				alert(strDebug);
			}
			return;
		}
		var aRec = this.Locations.get(id);
		var aTmp = {};
		if (isUndefined(aRec)) {
			//Creamos contenedor para la primera. 
			aRec = {};
		} else {
			this.Locations.limitTo(this.nRefCacheLimit);
		} 
		//alert("El id: "+id);
		aTmp.localizacion = aLoc.localizacion;
		if (aLoc.zona) aTmp.zona = aLoc.zona;
		if (aLoc.id_almacen_logico) aTmp.zona = aLoc.id_almacen_logico;
		if (aLoc.planta) aTmp.planta = aLoc.planta;
		if (aLoc.pasillo) aTmp.pasillo = aLoc.pasillo;
		if (aLoc.columna) aTmp.columna = aLoc.columna;
		if (aLoc.fila) aTmp.fila = aLoc.fila;
		aRec[aTmp.localizacion] = aTmp;
		this.Locations.put(id,aRec);
	},

	addRefSKU: function(id,aSKU) {
		// Esta linea de inidizlizacion, es para borrar.
		if (isUndefined(this.SKUs)) this.SKUs = new HashMap();
		if (isUndefined(aSKU) || isUndefined(aSKU.sku) || !aSKU.sku.length) {
			alert("addRefLocation() - No hay SKU ");
			for (var k in aLoc) {
				var strDebug = "Las claves: \n";
				if (!isFunction(k)) strDebug += k+"\n";
				alert(strDebug);
			}
			return;
		}
		var aRec = this.SKUs.get(id);
		var aTmp = {};
		if (isUndefined(aRec)) {
			//Creamos contenedor para la primera. 
			aRec = {};
		} else {
			this.SKUs.limitTo(this.nRefCacheLimit);
		}
		aTmp.sku = aSKU.sku;
		if (aSKU.fecha_caducidad) aTmp.fecha_caducidad = aSKU.fecha_caducidad;
		if (aSKU.fecha) aTmp.fecha_caducidad = aSKU.fecha;
		if (aSKU.anyo) aTmp.anyo = aSKU.anyo;
		if (aSKU.mes) aTmp.mes = aSKU.mes;
		if (aSKU.dia) aTmp.dia = aSKU.dia;
		if (aSKU.lote) aTmp.lote = aSKU.lote;
		if ((!aTmp.anyo || !aTmp.mes || !aTmp.dia) && !isUndefined(aTmp.fecha_caducidad)) {
			var aTmp2 = aTmp.fecha_caducidad.split('-');
			if (aTmp2.length>2) {
				if (!aTmp.anyo) aTmp.anyo = aTmp2[0];
				if (!aTmp.mes) aTmp.mes = aTmp2[1];
				if (!aTmp.dia) aTmp.dia = aTmp2[2];
			}
		}
		aRec[aSKU.sku] = aTmp;
		this.SKUs.put(id,aRec);
	},

	findElement: function(el,tag,name) { return mydom.findElement(el,tag,name); },
	setAjaxInfo: function (id) { this.ajaxInfoDiv = $(id); },
	setAjaxStatus: function (id) { this.ajaxStatusDiv = $(id); },
	setAjaxStock: function (id) { this.ajaxStockDiv = $(id); },
	setAjaxLog: function (id) { this.ajaxLogDiv = $(id); },
	setRecordForm: function (id) { this.RecordForm = $(id); },

	asyncGetRef: function () {
		var dGet = new HashMap();
		var dPost = new HashMap();
		dGet.put('seccion','ajax_alb_cbarras');
		dPost.put('CodigoBarras',this.dItems.get('CodigoBarras').getValue());
		var myAjax = new Ajax.Updater(
			this.ajaxInfoDiv.id,
			this.urlBase+'?'+dGet.toQueryString(),
			{
				method: 'post',
				asynchronous: true,
				parameters: dPost.toQueryString(),
				onLoaded: this.showLoaded.bind(this),
				onComplete: this.showResponse.bind(this),
				evalScripts: true
			});
		oR = {cbarras: this.dItems.get('CodigoBarras').getValue()};
		this.loading(oR);
		this.lastRequest = oR;

	},

	asyncGetStock: function () {
		// Actualizanso asi... a veri si el inventario sale.
		var dGet = new HashMap();
		var dPost = new HashMap();
		dGet.put('seccion','pkg_inventario');
		dGet.put('__ajax_token','void');
		dPost.put('CodigoBarras',this.dItems.get('CodigoBarras').getValue());
		dPost.put('accion','SeleccionarCBarras');
		var InvRequest = new Ajax.Updater(
			this.ajaxStockDiv.id,
			this.urlBase+'?'+dGet.toQueryString(),
			{
				method: 'post',
				asynchronous: true,
				parameters: dPost.toQueryString(),
				onLoaded: this.showLoaded.bind(this),
				onComplete: this.storeStockInfo.bind(this),
				evalScripts: true
			});
	},

	asyncSendForm: function () {
		if (!isUndefined(this.RecordForm)) {
			//alert("Mandando el formulario. Y preparandose para registrar el log! "+this.RecordForm);
			var frm = new HashMap();
			var dGet = new HashMap();
			var flds = inmForm.getElements(this.RecordForm);
			for (var j=flds.length-1, i=0;j>=0;j--,i++) {
				if (flds[j].hasAttribute("name")) { 
					frm.put(flds[j].getAttribute("name"),Form.Element.getValue(flds[j])); 
				}
			}
			frm.put("__ajax_token",(this.ajaxRecCount++));
			var myAjax = new Ajax.Request(
				this.RecordForm.getAttribute('action'),
				{
					method: 'post',
					asynchronous: true,
					parameters: frm.toQueryString(),
					onLoaded: this.showLoaded.bind(this),
					onComplete: this.logResponse.bind(this)
				});
			this.RecordForm.reset();
			oR = {request_id: frm.get('__ajax_token'), hashForm: frm};
			oR.cbarras = this.dItems.get('CodigoBarras').getValue();
			this.loading(oR);
			//this.lastRequest = oR;
			this.lastRequest = undefined;
		}
	},

	loading: function (oReq) {
		if (!isObject(this.ajaxStatusDiv)) return;
		var strMsg = "";
		if (!isUndefined(oReq.request_id)) {
			strMsg = this.tpRecordRequest.evaluate(oReq);
			this.dRecordRequests.put(oReq.request_id,oReq);
		} else if (!isUndefined(oReq.cbarras)) {
			strMsg = this.tpRefRequest.evaluate(oReq);
		}
		this.ajaxStatusDiv.innerHTML = strMsg;
	},

	showLoaded: function (originalRequest) {
		//alert("Que deje de rodar la ruedecita ");
	},

	showResponse: function (originalRequest,oJSon) {
		//alert("ahora hay: "+$('Contenido').innerHTML);
		//$('Contenido').innerHTML = originalRequest.responseText;
		var strMsg = "", oRef;
		if (!isUndefined(this.lastRequest)) strMsg = this.tpRefNotFound.evaluate(this.lastRequest);
		if (!isUndefined(oJSon) && oJSon!=null) {
			this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			for (key in oJSon) { strDebug += key+"\n"; }
			if (!isUndefined(oJSon.referencia)) { 
				oRef = oJSon.referencia;
				oRef.albaran = oJSon.albaran;
				strMsg = this.tpRefFound.evaluate(oRef);
				if (this.lastResponse.localizaciones) {
					var aKeys = Object.keys(this.lastResponse.localizaciones,true);
					for (var j in aKeys) {
						var k = aKeys[j];
						if (isFunction(k) || isFunction(this.lastResponse.localizaciones[k])) continue;
						var tmp = this.lastResponse.localizaciones[k];
						tmp.localizacion = k;
						this.addRefLocation(oRef.id_articulo,tmp);
					}
				}
				if (this.lastResponse.skus) {
					var aKeys = Object.keys(this.lastResponse.skus,true);
					for (var j in aKeys) {
						var k = aKeys[j];
						if (isFunction(k) || isFunction(this.lastResponse.skus[k])) continue;
						var tmp = this.lastResponse.skus[k];
						tmp.sku = k;
						this.addRefSKU(oRef.id_articulo,tmp);
					}
				}
				//FixME: Consume demasiado en un cliente monohilo : this.asyncGetStock();
			} else {
				alert(strDebug);
			}
		} else this.lastResponse = undefined;
		this.ajaxStatusDiv.innerHTML = strMsg;
	},

	logResponse: function (originalRequest,oJSon) {
		var strMsg = "";
		var strLog;
		var doDebug = false;
		//if (!isUndefined(this.lastRequest)) strMsg = this.tpRefNotFound.evaluate(this.lastRequest);
		if (doDebug) alert("response seems ok. processing .. ");
		if (!isUndefined(oJSon) && oJSon!=null) {
			//this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			for (key in oJSon) { strDebug += key+"\n"; }
			if (doDebug) alert(strDebug);
			if (!isUndefined(oJSon.referencia)) { 
				strMsg = this.tpRefFound.evaluate(oJSon.referencia);
				strLog = this.tpRefFound.evaluate(oJSon.referencia);
			} else {
				//alert(strDebug);
				strMsg = this.tpRecordResponseStatus.evaluate(oJSon);
				strLog = this.tpRecordResponse.evaluate(oJSon);
			}
		} else {
			var tmpMsg = "";
			if (doDebug) alert(" las opts: "+originalRequest.request.options+"\n"+tmpMsg);
			if (isString(originalRequest.request.options.parameters['__ajax_token'])) {
				originalRequest.request_id = originalRequest.request.options.parameters.__ajax_token;
			}
			strMsg = this.tpRecordResponseUnknown.evaluate(originalRequest);
		}
		if (doDebug) {
			alert("stat-> "+strMsg);
			this.ajaxLogDiv.innerHTML = originalRequest.responseText+"<hr width='50%' /><br/>\n"+this.ajaxLogDiv.innerHTML;
		}
		this.ajaxStatusDiv.innerHTML = strMsg;
		this.logEvent(strMsg);
	},

	storeStockInfo: function (originalRequest,oJSon) {
		//alert("ahora hay: "+$('Contenido').innerHTML);
		//$('Contenido').innerHTML = originalRequest.responseText;
		var strMsg = "";
		if (!isUndefined(this.lastRequest)) strMsg = this.tpStockNotFound.evaluate(this.lastRequest);
		if (!isUndefined(oJSon) && oJSon!=null) {
			//TODO: Cambiar nombre a lastResponse. this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			var oRS = {}, aRec, aTmp;
			for (key in oJSon) { strDebug += key+"\n"; }
			//alert("vars: "+strDebug+" ln: "+oJSon.length);
			oRS.count = 0;
			oRS.id = null;
			oRS.articulo = null;
			oRS.marca = null;
			for (var i in Object.keys(oJSon)) {
				if (isFunction(oJSon[i]) || isFunction(i) || isUndefined(oJSon[i])) continue;
				oRS.count++;
				aRec = oJSon[i];
				if (!oRS.articulo) {
					oRS.id = aRec['id_articulo'];
					oRS.articulo = aRec['articulo'];
					oRS.marca = aRec['marca'];
				}
				//alert("rec en "+aRec.localizacion+" unit "+aRec.sku+" for: "+aRec.id_articulo);
				try {
					this.addRefLocation(aRec.id_articulo,aRec);
					this.addRefSKU(aRec.id_articulo,aRec);
				} catch (e) {
					alert("E: "+e);
				}
			}
			try {
				oRS.nlocalizaciones = oRS.count;
				oRS.nskus = oRS.count;
				strMsg = this.tpStockFound.evaluate(oRS);
			} catch (e) { alert("E: "+e); }
		} 
		this.logEvent(strMsg);
	},

	logEvent: function (msg) {
		var strMsg = "<div class=\"req_log_line\" >"+msg+"</div>";
		this.ajaxLogDiv.innerHTML = strMsg+"\n"+this.ajaxLogDiv.innerHTML;
	}
}

