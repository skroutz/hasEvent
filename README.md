hasEvent
========

JavaScript test support utility for jQuery events

[![Build Status](https://travis-ci.org/Zorbash/hasEvent.png?branch=master)](https://travis-ci.org/Zorbash/hasEvent)

A way to detect the presence of jQuery events is currently a [wontfix](http://bugs.jquery.com/ticket/11945), thus this helper.


## Installation

`bower install hasEvent`

Don't forget to include the lib itself, located in dist/has_event.js

## Usage

The examples below use [chai](http://chaijs.com/api/bdd/) should style
assertions.

```javascript
  // Native event
  $('.foo').hasEvent('click', someHandler).should.be.true

  // Custom event
  $('.foo').hasEvent('custom', someHandler).should.be.true

  // Delegated event
  $('body').hasEvent('click', '.foo .bar', somehandler).should.be.true

  // 'Live' event
  $(document).hasEvent('click', '.foo .bar', someHandler).should.be.true

  // Event on window
  $(window).hasEvent('scroll', someHandler).should.be.false

```

## Tests

Currently there are tests against jQuery versions
1.7 up to 2.0.3

Browse the builds [here](https://travis-ci.org/Zorbash/hasEvent/builds/)


## Author

[Dimitris Zorbas](https://github.com/Zorbash) ([@zorbash](https://twitter/_zorbash))


## Licence
Copyright (c) 2013 Dimitris Zorbash
Licensed under the MIT license.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Zorbash/hasevent/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

