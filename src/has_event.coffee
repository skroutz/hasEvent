###
Utility class that may host checks
for bound event handlers on elements
as that feature is currenty a wontfix
@see http://bugs.jquery.com/ticket/11945
###
class HasEvent
  ###
  Internal

  @param $el [Object] The jQuery element on which
  the check will be performed
  @param type [String] Event type such as 'click', 'focus', etc.
  @param selector [String|Object] The selector defined for event delegation
  @param handler [Function] The expected event handler
  @return [Boolean] True when the given handler is bound
  to the given element on the given event type
  ###
  @_performCheck: ($el, type, selector, handler, is_global) ->
    # jQuery internally keeps in the cache the events bound on each
    # element. We perform a search in the cache manually to avoid
    # known api inconsistencies ($._data() and $(el).data()) between versions

    # Perform a different check when the target is the window|document object
    if is_global
      data = $._data($el)
    else
      return false if $el.length is 0
      data = $._data($el[0])

    if data?.events?[type]?
      for v in data.events[type]
        if v.handler is handler
          return true

    return false

  ###
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
  ###
  @check: ($el, type, selector, handler) ->
    throw Error 'Expected at least 3 parameters' if arguments.length < 3

    el_string = $el.toString()
    if /Window/.test(el_string) or /HTMLDocument/.test(el_string)
      is_global = true
    else
      is_global = false

    # Care to throw an error indicating invalid usage
    if !($el instanceof jQuery) and !is_global
      throw Error 'Expected 1st parameter to be a jQuery object or the window object'

    if toString.call(type) isnt '[object String]'
      throw Error 'Expected type parameter to be a String'

    if arguments.length is 3
      if typeof selector isnt 'function'
        throw Error 'Expected handler to be a Function'

      @_performCheck($el, type, null, selector, is_global)
    else
      if toString.call(selector) isnt '[object String]'
        throw Error 'Expected selector parameter to be a String'

      if typeof handler isnt 'function'
        throw Error 'Expected handler to be a Function'

      @_performCheck($el, type, selector, handler, is_global)

# Make it global and avoid overwritting existing property
window.HasEvent = window.HasEvent || HasEvent

jQuery.fn.hasEvent = (type, selector, handler) ->
  args = Array.prototype.slice.call arguments
  args.unshift(@)

  any = @map(->
    return HasEvent.check.apply(HasEvent, args)
  ).get()

  return false if !any.length
  if any.indexOf(false) is -1 then true else false
