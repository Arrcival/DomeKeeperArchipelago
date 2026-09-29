class_name WebSocketClient extends Node

signal connected
signal disconnected_without_connection
signal connection_closed(should_retry: bool, message: String)
signal data_received(packet: PackedByteArray)
signal server_close_request

var socket: WebSocketPeer = WebSocketPeer.new()

var should_process = false

var is_connected = false

func _init():
	create_new_socket()

func create_new_socket():
	socket = WebSocketPeer.new()
	socket.inbound_buffer_size = 65536 * 128
	is_connected = false

func connect_to_url(url: String) -> Error:
	is_connected = false
	should_process = true
	var error = socket.connect_to_url(url)
	return error

func poll():
	if not should_process:
		return
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if not is_connected:
			connected.emit()
			is_connected = true
		while socket.get_available_packet_count():
			var packet: PackedByteArray = socket.get_packet()
			data_received.emit(packet)
			
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		if not is_connected:
			disconnected_without_connection.emit()
		else:
			var code = socket.get_close_code()
			var reason = socket.get_close_reason()
			if code == -1:
				connection_closed.emit(true, "Closure wasn't clear, code %d, reason %s" % [code, reason])
			else:
				connection_closed.emit(false, "Connection closed, code %d" % [code])
		should_process = false
		is_connected = false
		create_new_socket()

func close():
	socket.close()
	should_process = true

func send_text(text: String):
	var error : Error= socket.send_text(text)
	if error != OK:
		print("Something went wrong sending data to ws. %s" % error)
