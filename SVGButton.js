// Generated by CoffeeScript 1.7.1
var SVGButton, root, updateButtonState,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

root = typeof exports !== "undefined" && exports !== null ? exports : window;

SVGButton = (function() {
  var addButtonBehavioursForId, merge, typeIsArray;

  function SVGButton(parent) {
    this.parent = parent;
    this.rectDefaults = {
      rx: 5,
      ry: 5,
      'stroke-width': 2,
      stroke: 'grey',
      fill: 'none'
    };
    this.textDefaults = {
      stroke: 'grey',
      fill: 'none',
      'font-family': 'sans-serif',
      fill: 'grey',
      'font-size': 14
    };
    this.pathDefaults = {
      'stroke-width': 2,
      stroke: 'grey',
      fill: 'none',
      d: ''
    };
  }

  typeIsArray = Array.isArray || function(value) {
    return {}.toString.call(value) === '[object Array]';
  };

  merge = function(defaults, opts) {
    var idx, item, key, result, value, _i, _j, _len, _len1, _ref;
    result = {};
    for (key in defaults) {
      value = defaults[key];
      if (typeIsArray(value)) {
        result[key] = [];
        for (idx = _i = 0, _len = value.length; _i < _len; idx = ++_i) {
          item = value[idx];
          result[key].push(merge(value[idx], opts[key][idx]));
        }
      } else if (value === Object(value)) {
        if (opts[key] != null) {
          result[key] = merge(value, opts[key]);
        } else {
          result[key] = value;
        }
      } else {
        if (opts[key] != null) {
          result[key] = opts[key];
        } else {
          result[key] = value;
        }
      }
    }
    _ref = Object.keys(opts);
    for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
      key = _ref[_j];
      if (__indexOf.call(Object.keys(defaults), key) < 0) {
        result[key] = opts[key];
      }
    }
    return result;
  };

  addButtonBehavioursForId = function(elem, id, hoverfill, unhoverfill, action) {
    return elem.attr("onmouseover", "d3.select('#" + id + "').style('fill','" + hoverfill + "')").attr("onmouseout", "d3.select('#" + id + "').style('fill','" + unhoverfill + "')").attr("onmouseup", action).attr("ontouchstart", "d3.select('#" + id + "').style('fill','" + hoverfill + "')").attr("ontouchend", "d3.select('#" + id + "').style('fill','" + unhoverfill + "')").attr("ontouchleave", "d3.select('#" + id + "').style('fill','" + unhoverfill + "')");
  };

  SVGButton.prototype.createRect = function(id, x, y, action, opts) {
    var key, rect, val, _ref;
    rect = d3.select(this.parent).append("rect").attr("id", id).attr("x", x).attr("y", y).attr("width", opts.width).attr("height", opts.height);
    addButtonBehavioursForId(rect, id, opts.hover, opts.rect.fill, action);
    _ref = opts.rect;
    for (key in _ref) {
      val = _ref[key];
      rect.attr(key, val);
    }
    return rect;
  };

  SVGButton.prototype.createText = function(id, x, y, text, action, opts) {
    var elem, key, val, _ref;
    elem = d3.select(this.parent).append("text").text(text).attr("id", id).attr("x", x).attr("y", y);
    addButtonBehavioursForId(elem, id, opts.hover, opts.text.fill, action);
    _ref = opts.text;
    for (key in _ref) {
      val = _ref[key];
      elem.attr(key, val);
    }
    return elem;
  };

  SVGButton.prototype.createPath = function(id, x, y, opts) {
    var elem, key, val;
    elem = d3.select(this.parent).append("path").attr("transform", "translate(" + x + "," + y + ")").attr("id", id);
    for (key in opts) {
      val = opts[key];
      elem.attr(key, val);
    }
    return elem;
  };

  SVGButton.prototype.makeTextButton = function(id, x, y, text, action, opts) {
    var elem, mergedOpts;
    if (opts == null) {
      opts = {};
    }
    mergedOpts = merge({
      rect: this.rectDefaults,
      text: this.textDefaults,
      hover: 'lightgrey'
    }, opts);
    elem = this.createText(id + "text", x + 2, y + 2, text, action, mergedOpts);
    return console.log(elem);
  };

  SVGButton.prototype.makeButton = function(id, x, y, action, opts) {
    var defaults, elem, idx, instance, mergedOpts, _i, _j, _len, _len1, _ref, _ref1, _results;
    if (opts == null) {
      opts = {};
    }
    defaults = {
      width: 30,
      height: 30,
      hover: 'lightgrey',
      rect: this.rectDefaults,
      text: this.textDetaults
    };
    if (opts.path != null) {
      if (typeIsArray(opts.path)) {
        defaults.path = [];
        _ref = opts.path;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          instance = _ref[_i];
          defaults.path.push(this.pathDefaults);
        }
      } else {
        defaults.path = this.pathDefaults;
      }
    }
    mergedOpts = merge(defaults, opts);
    this.createRect(id, x, y, action, mergedOpts);
    if (mergedOpts.path != null) {
      if (typeIsArray(mergedOpts.path)) {
        _ref1 = mergedOpts.path;
        _results = [];
        for (idx = _j = 0, _len1 = _ref1.length; _j < _len1; idx = ++_j) {
          instance = _ref1[idx];
          elem = this.createPath("" + id + "path" + idx, x, y, mergedOpts.path[idx]);
          _results.push(addButtonBehavioursForId(elem, id, mergedOpts.hover, mergedOpts.rect.fill, action));
        }
        return _results;
      } else {
        elem = this.createPath("" + id + "path", x, y, mergedOpts.path);
        return addButtonBehavioursForId(elem, id, mergedOpts.hover, mergedOpts.rect.fill, action);
      }
    }
  };

  SVGButton.prototype.makeStatefulButton = function(id, x, y, states, opts) {
    var clazz, defaults, elem, idx, instance, mergedOpts, mergedstate, pathidx, state, _i, _j, _len, _len1, _ref, _results;
    if (opts == null) {
      opts = {};
    }
    defaults = {
      width: 30,
      height: 30,
      hover: 'lightgrey',
      rect: this.rectDefaults
    };
    mergedOpts = merge(defaults, opts);
    if (typeIsArray(states)) {
      root[id] = 0;
      _results = [];
      for (idx = _i = 0, _len = states.length; _i < _len; idx = ++_i) {
        state = states[idx];
        state.action = ("updateButtonState('" + id + "', " + states.length + ");") + state.action;
        if (state.path != null) {
          if (typeIsArray(state.path)) {
            defaults.path = [];
            _ref = state.path;
            for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
              instance = _ref[_j];
              defaults.path.push(this.pathDefaults);
            }
          } else {
            defaults.path = this.pathDefaults;
          }
        }
        mergedstate = merge(mergedOpts, state);
        clazz = ("" + id + idx) + (idx === 0 ? '' : ' invisible');
        mergedstate.rect["class"] = clazz;
        this.createRect("" + id + idx, x, y, state.action, mergedstate);
        if (typeIsArray(mergedstate.path)) {
          _results.push((function() {
            var _k, _len2, _ref1, _results1;
            _ref1 = mergedstate.path;
            _results1 = [];
            for (pathidx = _k = 0, _len2 = _ref1.length; _k < _len2; pathidx = ++_k) {
              instance = _ref1[pathidx];
              mergedstate.path[idx]["class"] = clazz;
              elem = this.createPath("" + id + idx + "path" + pathidx, x, y, mergedstate.path[idx]);
              _results1.push(addButtonBehavioursForId(elem, "" + id + idx, mergedstate.hover, mergedstate.rect.fill, mergedstate.action));
            }
            return _results1;
          }).call(this));
        } else {
          mergedstate.path["class"] = clazz;
          elem = this.createPath("" + id + idx + "path", x, y, mergedstate.path);
          _results.push(addButtonBehavioursForId(elem, "" + id + idx, mergedstate.hover, mergedstate.rect.fill, mergedstate.action));
        }
      }
      return _results;
    } else {
      return console.log("expecting an array of opts for multiple states");
    }
  };

  return SVGButton;

})();

updateButtonState = function(id, numstates) {
  d3.selectAll("." + id + root[id]).classed('invisible', true);
  if (root[id] === (numstates - 1)) {
    root[id] = 0;
  } else {
    root[id]++;
  }
  return d3.selectAll("." + id + root[id]).classed('invisible', false);
};

root.updateButtonState = updateButtonState;

root.SVGButton = SVGButton;
