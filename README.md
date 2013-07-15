hasEvent
========

JavaScript test support utility for jQuery events

[![Build Status](https://travis-ci.org/Zorbash/hasEvent.png?branch=master)](https://travis-ci.org/Zorbash/hasEvent)

A way to detect the presence of jQuery events is currently a [wontfix](http://bugs.jquery.com/ticket/11945), thus this helper.


## Usage

The examples below use [chai](http://chaijs.com/api/bdd/) should style
assertions.

```javascript
  // Native event
  $('.foo').hasEvent('click', someHandler).should.be.true

  // Custom event
  $('.foo').hasEvent('custom', someHandler).should.be.true

  // Delegated event
  $('body').hasEvent('click', '.foo .bar', @handler).should.be.true

  // 'Live' event
  $(document).hasEvent('click', '.foo .bar', @handler).should.be.true

  // Event on window
  $(window).hasEvent('scroll', @handler).should.be.false

```

## Tests

Currently there are tests against jQuery versions
1.7 up to 2.0.3

Browse the builds [here](https://travis-ci.org/Zorbash/hasEvent/builds/)