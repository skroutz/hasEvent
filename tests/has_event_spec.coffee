describe 'HasEvent', ->
  it 'is a class', ->
    expect(HasEvent).to.be.a 'function'

  describe '.check', ->
    context 'less than 3 params', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check($('.foo'), 'click')
        catch err
          did_throw = true
        finally
          expect(did_throw).to.be.true

    context '1st param not a jQuery object', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check({}, 'click', -> 'foo')
        catch err
          did_throw = true
        finally
          expect(did_throw).to.be.true

    context '2nd param not a String', ->
      it 'throws error', ->
        did_throw = false
        try
          HasEvent.check($('.foo'), {}, -> 'foo')
        catch err
          did_throw = true
        finally
          expect(did_throw).to.be.true

    context 'params length is 3', ->
      context '3rd param is not a function', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', {})
          catch err
            did_throw = true
          finally
            expect(did_throw).to.be.true

    context 'params length is 4', ->
      context '3rd param is not a String', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', {}, -> 'foo')
          catch err
            did_throw = true
          finally
            expect(did_throw).to.be.true

      context '4rth param is not a function', ->
        it 'throws error', ->
          did_throw = false
          try
            HasEvent.check($('.foo'), 'click', '.bar', {})
          catch err
            did_throw = true
          finally
            expect(did_throw).to.be.true

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
            expect(HasEvent.check($('.foo'), 'click', @handler)).to.be.true

          it 'makes the plugin return true', ->
            expect($('.foo').hasEvent('click', @handler)).to.be.true

        context 'custom event', ->
          beforeEach ->
            @handler = -> 'something'
            $('.foo').on 'custom.test', @handler

          afterEach ->
            $('.foo').off '.test'

          it 'returns true', ->
            expect(HasEvent.check($('.foo'), 'custom', @handler)).to.be.true

          it 'makes the plugin return true', ->
            expect($('.foo').hasEvent('custom', @handler)).to.be.true

        context 'delegation', ->
          beforeEach ->
            @handler = -> 'foo'
            $('body').on 'click.test', '.foo .bar', @handler

          afterEach ->
            @handler = 'something'
            $('body').off '.test'

          it 'returns true', ->
            expect(HasEvent.check($('body'), 'click', '.foo .bar', @handler)).to.be.true

          it 'makes the plugin return true', ->
            expect($('body').hasEvent('click', '.foo .bar', @handler)).to.be.true

        context 'live', ->
          beforeEach ->
            @handler = -> 'foo'
            $(document).on 'click.test', '.foo .bar', @handler

          afterEach ->
            $(document).off '.test'

          it 'returns true', ->
            expect(HasEvent.check($(document), 'click', '.foo .bar', @handler)).to.be.true

          it 'makes the plugin return true', ->
            expect($(document).hasEvent('click', '.foo .bar', @handler)).to.be.true

      context 'no event handler has been bound', ->
        context 'default', ->
          it 'returns false', ->
            expect(HasEvent.check($('.foo'), 'click', ->)).to.be.false

          it 'makes the plugin return false', ->
            expect($('.foo').hasEvent('click', ->)).to.be.false

        context 'delegation', ->
          it 'returns true', ->
            $('body').off '.test', '.foo .bar'
            expect(HasEvent.check($('body'), 'click', '.foo .bar', ->)).to.be.false

          it 'makes the plugin return false', ->
            expect($('body').hasEvent('click', '.foo .bar', ->)).to.be.false

        context 'live', ->
          it 'returns false', ->
            $(document).off '.test'
            expect(HasEvent.check($(document), 'click', '.foo .bar', ->)).to.be.false

          it 'makes the plugin return false', ->
            expect($(document).hasEvent('click', '.foo .bar', ->)).to.be.false

      context 'there is a cache_obj with no handle property', ->
        it 'does not throw Error', ->
          $('body').data 'test', -> 'test'

          did_throw = false
          try
            HasEvent.check($(document), 'click', '.foo .bar', ->)
          catch e
            did_throw = true
          finally
            expect(did_throw).not.be.true
            $('body').removeData 'test'

    context 'the target is the window object', ->
      context 'an event handler has been bound', ->
        beforeEach ->
          @handler = -> 'foo'
          $(window).on 'scroll.test', @handler

        afterEach ->
          $(window).off '.test'

        it 'returns true', ->
          expect(HasEvent.check(window, 'scroll', @handler)).to.be.true

      context 'no event handler has been bound', ->
        beforeEach ->
          @handler = -> 'foo'
          $(window).off '**'

        it 'returns false', ->
          expect(HasEvent.check(window, 'scroll', @handler)).to.be.false

        it 'makes the jQuery plugin return false', ->
          expect($(window).hasEvent('scroll', @handler)).to.be.false

    context 'the supplied jQuery element does not exist', ->
      it 'returns false', ->
        expect(HasEvent.check($('.bar'), 'click', ->)).to.be.false

      it 'makes the jQuery plugin return false', ->
        expect($('.bar').hasEvent('click', ->)).to.be.false

  describe 'jQuery plugin', ->
    it 'is a property on jQuery.fn', ->
      expect(jQuery.fn).to.have.property 'hasEvent'
