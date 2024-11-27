class_name WebSocketClient extends Node

signal connected
signal disconnected_without_connection
signal connection_closed(message: String)
signal data_received(packet: PackedByteArray)
signal server_close_request

var socket = WebSocketPeer.new()

var should_process = false

var is_connected = false

func connect_to_url(url: String) -> Error:
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
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		if code == -1:
			connection_closed.emit("Closure wasn't clear, code %d, reason %s. Clean: %s" % [code, reason])
		should_process = false

func close():
	socket.close()
	socket = WebSocketPeer.new()

func send_text(text: String):
	var error : Error= socket.send_text(text)
	if error != OK:
		print("Something went wrong sending data to ws. %s" % error)
