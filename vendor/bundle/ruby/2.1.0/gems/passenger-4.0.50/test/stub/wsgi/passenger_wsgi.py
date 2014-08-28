import os, sys, time, cgi

def file_exist(filename):
	try:
		os.stat(filename)
		return True
	except OSError:
		return False

if sys.version_info[0] >= 3:
	def bytes_to_str(b):
		return b.decode()

	def str_to_bytes(s):
		return s.encode('latin-1')
else:
	def bytes_to_str(b):
		return b

	def str_to_bytes(s):
		return s

def application(env, start_response):
	status = '200 OK'
	body   = None
	
	method = env.get('REQUEST_METHOD')
	if method == 'OOBW':
		time.sleep(1)
		start_response(status, [('Content-Type', 'text/html')])
		return [str('oobw ok')]
	
	filename = env.get('HTTP_X_WAIT_FOR_FILE')
	if filename is not None:
		while not file_exist(filename):
			time.sleep(0.01)
	
	path = env['PATH_INFO']
	if path == '/':
		if file_exist("front_page.txt"):
			with file("front_page.txt", "r") as f:
				body = f.read()
		else:
			body = "front page"
	elif path == '/parameters':
		method = env['REQUEST_METHOD']
		params = cgi.parse(env['wsgi.input'], env)
		first  = params['first'][0]
		second = params['second'][0]
		body = "Method: %s\nFirst: %s\nSecond: %s\n" % (method, first, second)
	elif path == '/chunked':
		def body():
			yield str("7\r\nchunk1\n\r\n")
			yield str("7\r\nchunk2\n\r\n")
			yield str("7\r\nchunk3\n\r\n")
			yield str("0\r\n\r\n")
			sleep_time = float(env.get('HTTP_X_SLEEP_WHEN_DONE', 0))
			time.sleep(sleep_time)
			if env.get('HTTP_X_EXTRA_DATA') is not None:
				status = False
				try:
					yield str("7\r\nchunk4\n\r\n")
					status = True
				finally:
					filename = env.get('HTTP_X_TAIL_STATUS_FILE')
					if filename is not None:
						f = open(filename, "w")
						try:
							f.write(str(status))
						finally:
							f.close()
		start_response(status, [('Content-Type', 'text/html'), ('Transfer-Encoding', 'chunked')])
		return body()
	elif path == '/pid':
		body = os.getpid()
	elif path.startswith('/env'):
		body = ''
		for pair in env.iteritems():
			body += pair[0] + ' = ' + str(pair[1]) + "\n"
		body = body
	elif path == '/touch_file':
		params = cgi.parse(env['wsgi.input'], env)
		filename = params["file"][0]
		file(filename, 'w').close()
		body = "ok"
	elif path == '/extra_header':
		start_response(status, [('Content-Type', 'text/html'), ('X-Foo', 'Bar')])
		return ["ok"]
	elif path == '/cached':
		body = "This is the uncached version of /cached"
	elif path == '/upload_with_params':
		params = cgi.FieldStorage(fp = env['wsgi.input'], environ = env)
		name1 = params["name1"].value
		name2 = params["name2"].value
		data  = params["data"].value
		format = \
			b"name 1 = %s\n" + \
			b"name 2 = %s\n" + \
			b"data = %s"
		body = format % (name1, name2, data)
	elif path == '/raw_upload_to_file':
		sleep_time = float(env.get('HTTP_X_SLEEP', 0))
		f = open(env['HTTP_X_OUTPUT'], 'w')
		try:
			line = env['wsgi.input'].readline()
			while line != "":
				f.write(line)
				f.flush()
				line = env['wsgi.input'].readline()
				if sleep_time > 0:
					time.sleep(sleep_time)
		finally:
			f.close()
		body = 'ok'
	elif path == '/custom_status':
		status = env['HTTP_X_CUSTOM_STATUS']
		body = 'ok'
	elif path == '/stream':
		sleep_time = float(env.get('HTTP_X_SLEEP', 0.1))
		def body():
			i = 0
			while True:
				data = ' ' * 32 + str(i) + "\n"
				yield("%x\r\n" % len(data))
				yield(data)
				yield("\r\n")
				time.sleep(sleep_time)
				i += 1
		start_response(status, [('Content-Type', 'text/html'), ('Transfer-Encoding', 'chunked')])
		return body()
	elif path == '/chunked_stream':
		sleep_time = float(env.get('HTTP_X_SLEEP', 0.05))
		count = float(env.get('HTTP_X_COUNT', 3))
		def body():
			i = 0
			while i < count:
				data = "Counter: " + str(i) + "\n"
				yield("%x\r\n" % len(data))
				yield(data)
				yield("\r\n")
				time.sleep(sleep_time)
				i += 1
			yield("0\r\n\r\n")
			time.sleep(2)
		start_response(status, [('Content-Type', 'text/html'), ('Transfer-Encoding', 'chunked')])
		return body()
	elif path == '/sleep':
		sleep_time = float(env.get('HTTP_X_SLEEP', 5))
		time.sleep(sleep_time)
		status = 200
		body = 'ok'
	elif path == '/blob':
		size = int(env.get('HTTP_X_SIZE', 1024 * 1024 * 10))
		headers = [('Content-Type', 'text/plain')]
		if env.get('HTTP_X_CONTENT_LENGTH') is not None:
			headers.append(('Content-Length', size))
		def body():
			written = 0
			while written < size:
				data = 'x' * min(1024 * 8, size - written)
				yield(data)
				written += len(data)
			sleep_time = float(env.get('HTTP_X_SLEEP_WHEN_DONE', 0))
			time.sleep(sleep_time)
			if env.get('HTTP_X_EXTRA_DATA') is not None:
				status = False
				try:
					yield str("tail")
					status = True
				finally:
					filename = env.get('HTTP_X_TAIL_STATUS_FILE')
					if filename is not None:
						f = open(filename, "w")
						try:
							f.write(str(status))
						finally:
							f.close()
		start_response(status, headers)
		return body()
	elif path == '/oobw':
		start_response(status, [('Content-Type', 'text/plain'), ('X-Passenger-Request-OOB-Work', 'true')])
		return [str(os.getpid())]
	elif path == '/switch_protocol':
		if env['HTTP_UPGRADE'] != 'raw' or env['HTTP_CONNECTION'].lower() != 'upgrade':
			status = '500 Internal Server Error'
			body = str('Invalid headers')
			start_response(status, [('Content-Type', 'text/plain'), ('Content-Length', len(body))])
			return [body]
		socket = env['passenger.hijack'](True)
		io = socket.makefile()
		socket.close()
		try:
			io.write(
				b"HTTP/1.1 101 Switching Protocols\r\n" +
				b"Upgrade: raw\r\n" +
				b"Connection: Upgrade\r\n" +
				b"\r\n")
			io.flush()
			line = io.readline()
			while line != "":
				io.write("Echo: " + line)
				io.flush()
				line = io.readline()
		finally:
			io.close()
	else:
		status = "404 Not Found"
		body = "Unknown URI"
	
	body = str(body)
	start_response(status, [('Content-Type', 'text/plain'), ('Content-Length', len(body))])
	return [body]
