// Simple phantom.js integration script
// Adapted from Modernizr

function waitFor(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis :  5001 //< Default Max Timout is 5s
    , start = new Date().getTime()
    , condition = false
    , interval = setInterval(function () {
        if ((new Date().getTime() - start < maxtimeOutMillis) && !condition) {
          // If not time-out yet and condition not yet fulfilled
          condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()) //< defensive code
        } else {
          if (!condition) {
            // If condition still not fulfilled (timeout but condition is 'false')
            console.log("'waitFor()' timeout")
            phantom.exit(1)
          } else {
            // Condition fulfilled (timeout and/or condition is 'true')
            typeof(onReady) === "string" ? eval(onReady) : onReady() //< Do what it's supposed to do once the condition is fulfilled
            clearInterval(interval) //< Stop this interval
          }
        }
    }, 100) //< repeat check every 100ms
}


if (phantom.args.length === 0 || phantom.args.length > 2) {
  console.log('Usage: phantom.js URL')
  phantom.exit()
}

var page = new WebPage()

// Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = function(msg) {
  console.log(msg)
};

page.open(phantom.args[0], function(status){
  if (status !== "success") {
    console.log("Unable to access network")
    phantom.exit()
  } else {
    waitFor(function(){
      return page.evaluate(function(){
        // TODO: replace the ids with the mocha equivalent
        // var el = document.getElementById('qunit-testresult')
        if (true || el && el.innerText.match('completed')) {
          return true
        }
        return false
      })
    }, function(){
      var failedNum = page.evaluate(function(){
        try {
          // console.log('passed: ', document.getElementsByClassName('pass').length);
          // console.log('failed:', document.getElementsByClassName('fail').length);
          return document.getElementsByClassName('fail').length
        } catch (e) {

        }
        return 10000
      });
      // console.log('exit_code: ', (parseInt(failedNum, 10) > 0) ? 1 : 0);
      phantom.exit((parseInt(failedNum, 10) > 0) ? 1 : 0)
    })
  }
})