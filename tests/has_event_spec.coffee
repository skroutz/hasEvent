describe 'HasEvent', ->
  it 'is a class', ->
    HasEvent.should.be.a 'function'

  describe '.check', ->
    context 'less than 3 params', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check($('.foo'), 'click')
        catch err
          did_throw = true
        finally
          did_throw.should.be.true

    context '1st param not a jQuery object', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check({}, 'click', -> 'foo')
        catch err
          did_throw = true
        finally
          did_throw.should.be.true

    context '2nd param not a String', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check($('.foo'), {}, -> 'foo')
        catch err
          did_throw = true
        finally
          did_throw.should.be.true

    context 'params length is 3', ->
      context '3rd param is not a function', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', {})
          catch err
            did_throw = true
          finally
            did_throw.should.be.true

    context 'params length is 4', ->
      context '3rd param is not a String', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', {}, -> 'foo')
          catch err
            did_throw = true
          finally
            did_throw.should.be.true

      context '4rth param is not a function', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', '.bar', {})
          catch err
            did_throw = true
          finally
            did_throw.should.be.true

    context 'the supplied jQuery element exists', ->
      beforeEach ->
        $('body').append """
          <div class="foo">
            <div>
              <div class="bar"></div>
            </div>
          </div>
        """

      afterEach ->
        $('.foo').remove()

      context 'an event handler has been bound', ->

        context 'native event', ->
          beforeEach ->
            @handler = -> 'something'
            $('.foo').on 'click.test', @handler

          afterEach ->
            $('.foo').off '.test'

          it 'returns true', ->
            HasEvent.check($('.foo'), 'click', @handler).should.be.true

          it 'makes the plugin return true', ->
            $('.foo').hasEvent('click', @handler).should.be.true

        context 'custom event', ->
          beforeEach ->
            @handler = -> 'something'
            $('.foo').on 'custom.test', @handler

          afterEach ->
            $('.foo').off '.test'

          it 'returns true', ->
            HasEvent.check($('.foo'), 'custom', @handler).should.be.true

          it 'makes the plugin return true', ->
            $('.foo').hasEvent('custom', @handler).should.be.true

        context 'delegation', ->
          beforeEach ->
            @handler = -> 'foo'
            $('body').on 'click.test', '.foo .bar', @handler

          afterEach ->
            @handler = 'something'
            $('body').off '.test'

          it 'returns true', ->
            HasEvent.check($('body'), 'click', '.foo .bar', @handler).should.be.true

          it 'makes the plugin return true', ->
            $('body').hasEvent('click', '.foo .bar', @handler).should.be.true

        context 'live', ->
          beforeEach ->
            @handler = -> 'foo'
            $(document).on 'click.test', '.foo .bar', @handler

          afterEach ->
            $(document).off '.test'

          it 'returns true', ->
            HasEvent.check($(document), 'click', '.foo .bar', @handler).should.be.true

          it 'makes the plugin return true', ->
            $(document).hasEvent('click', '.foo .bar', @handler).should.be.true

      context 'no event handler has been bound', ->
        context 'default', ->
          it 'returns false', ->
            HasEvent.check($('.foo'), 'click', ->).should.be.false

          it 'makes the plugin return false', ->
            $('.foo').hasEvent('click', ->).should.be.false

        context 'delegation', ->
          it 'returns true', ->
            $('body').off '.test', '.foo .bar'
            HasEvent.check($('body'), 'click', '.foo .bar', ->).should.be.false

          it 'makes the plugin return false', ->
            $('body').hasEvent('click', '.foo .bar', ->).should.be.false

        context 'live', ->
          it 'returns false', ->
            $(document).off '.test'
            HasEvent.check($(document), 'click', '.foo .bar', ->).should.be.false

          it 'makes the plugin return false', ->
            $(document).hasEvent('click', '.foo .bar', ->).should.be.false

      context 'there is a cache_obj with no handle property', ->
        it 'does not throw Error', ->
          $('body').data 'test', -> 'test'

          did_throw = false
          try
            HasEvent.check($(document), 'click', '.foo .bar', ->)
          catch e
            did_throw = true
          finally
            did_throw.should.not.be.true
            $('body').removeData 'test'

    context 'the target is the window object', ->
      context 'an event handler has been bound', ->
        beforeEach ->
          @handler = -> 'foo'
          $(window).on 'scroll.test', @handler

        afterEach ->
          $(window).off '.test'

        it 'returns true', ->
          HasEvent.check(window, 'scroll', @handler).should.be.true

      context 'no event handler has been bound', ->
        beforeEach ->
          @handler = -> 'foo'
          $(window).off '**'

        it 'returns false', ->
          HasEvent.check(window, 'scroll', @handler).should.be.false

        it 'makes the jQuery plugin return false', ->
          $(window).hasEvent('scroll', @handler).should.be.false

    context 'the supplied jQuery element does not exist', ->
      it 'returns false', ->
        HasEvent.check($('.bar'), 'click', ->).should.be.false

      it 'makes the jQuery plugin return false', ->
        $('.bar').hasEvent('click', ->).should.be.false

  describe 'jQuery plugin', ->
    it 'is a property on jQuery.fn', ->
      jQuery.fn.should.have.property 'hasEvent'
