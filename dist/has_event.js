// Generated by CoffeeScript 1.6.2
/*
Utility class that may host checks
for bound event handlers on elements
as that feature is currenty a wontfix
@see http://bugs.jquery.com/ticket/11945
*/


(function() {
  var HasEvent;

  HasEvent = (function() {
    function HasEvent() {}

    /*
    Internal
    
    @param $el [Object] The jQuery element on which
    the check will be performed
    @param type [String] Event type such as 'click', 'focus', etc.
    @param selector [String|Object] The selector defined for event delegation
    @param handler [Function] The expected event handler
    @return [Boolean] True when the given handler is bound
    to the given element on the given event type
    */


    HasEvent._performCheck = function($el, type, selector, handler, is_global) {
      var data, v, _i, _len, _ref, _ref1;

      if (is_global) {
        data = $._data($el);
      } else {
        if ($el.length === 0) {
          return false;
        }
        data = $._data($el[0]);
      }
      if ((data != null ? (_ref = data.events) != null ? _ref[type] : void 0 : void 0) != null) {
        _ref1 = data.events[type];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          v = _ref1[_i];
          if (v.handler === handler) {
            return true;
          }
        }
      }
      return false;
    };

    /*
    Tests if the supplied event is bound on the supplied
    element optionally delegated to the supplied selector
    and is handled bu the supplied handler
    
    usage: .check(event, type [, selector], handler)
    
    @param $el [Object] The jQuery element on which
    the check will be performed
    @param type [String] Event type such as 'click', 'focus', etc.
    @param selector [String] (optional) The selector defined for event delegation
    @param handler [Function] The expected event handler
    @return [Boolean] True when the given handler is bound
    to the given element on the given event type
    @see http://robflaherty.github.io/jquery-annotated-source/docs/07-event.html#section-38
    */


    HasEvent.check = function($el, type, selector, handler) {
      var el_string, is_global;

      if (arguments.length < 3) {
        throw Error('Expected at least 3 parameters');
      }
      el_string = $el.toString();
      if (/Window/.test(el_string) || /HTMLDocument/.test(el_string)) {
        is_global = true;
      } else {
        is_global = false;
      }
      if (!($el instanceof jQuery) && !is_global) {
        throw Error('Expected 1st parameter to be a jQuery object or the window object');
      }
      if (toString.call(type) !== '[object String]') {
        throw Error('Expected type parameter to be a String');
      }
      if (arguments.length === 3) {
        if (typeof selector !== 'function') {
          throw Error('Expected handler to be a Function');
        }
        return this._performCheck($el, type, null, selector, is_global);
      } else {
        if (toString.call(selector) !== '[object String]') {
          throw Error('Expected selector parameter to be a String');
        }
        if (typeof handler !== 'function') {
          throw Error('Expected handler to be a Function');
        }
        return this._performCheck($el, type, selector, handler, is_global);
      }
    };

    return HasEvent;

  })();

  window.HasEvent = window.HasEvent || HasEvent;

  jQuery.fn.hasEvent = function(type, selector, handler) {
    var any, args;

    args = Array.prototype.slice.call(arguments);
    args.unshift(this);
    any = this.map(function() {
      return HasEvent.check.apply(HasEvent, args);
    }).get();
    if (!any.length) {
      return false;
    }
    if (any.indexOf(false) === -1) {
      return true;
    } else {
      return false;
    }
  };

}).call(this);
