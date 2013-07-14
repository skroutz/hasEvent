test:
	node tests/server.js &
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.1.7.0_spec.html"
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.1.8.0_spec.html"
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.1.9.0_spec.html"
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.1.10.2_spec.html"
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.2.0.0_spec.html"
	phantomjs tests/phantom.js "http://localhost:3000/tests/jquery.2.0.3_spec.html"
	kill -9 `cat tests/pid.txt`
	rm tests/pid.txt

clean:
	kill -9 `cat tests/pid.txt`
	rm tests/pid.txt
