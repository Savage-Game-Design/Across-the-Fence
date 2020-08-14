import json
import socket
import time

def sendMsg(fncName: str, data: dict, con: socket.socket):
	"""
	Properly prepare and send a message to the given connection.

	:param fncName: Function name/Indicator for the Arma Callback Eventhandler
	:param data:    Arguments as String
	:param con:     selected socket connection (client connection)
	:return:        None
	"""
	try:
		msg_data = {"fnc": fncName, "data": data}
		msg = bytes(json.dumps(msg_data), "ascii")
		con.sendall(msg)
	except Exception as e:
		print(f"ERROR: SendMSG: EXCEPTION TRIGGERED: {e}")


def getMulti(client_con: socket.socket, msg: bytes = b""):
	"""
	get a multi Message, by recursively getting messages (if a message is above the given buffer size)

	:param client_con:  selected socket connection (client connection)
	:param msg:         prev. message
	:return: byteString
	"""
	buffer = 1000
	try:
		msg_new = client_con.recv(buffer)
		if not msg_new:
			return None

		# Todo: Re-check method to determine endless spam
		# if a message exceeds a certain bytes limit (e.g. endless Message)
		if len(msg) > 20000:
			print('WARNING: GETMULTI: "POSSIBLE" SPAM DETECTED: Message length >20000')
			print(f"Message:\n{len(msg)} - {client_con.getpeername()}")
			# Todo: forced disconnect currently disabled
			# try:
			# 	client_con.shutdown(socket.SHUT_RDWR)
			# 	client_con.close()
			# 	pass
			# except ConnectionResetError:
		# 	return

		msg_len = len(msg_new)
		if msg_len < buffer:
			msg += msg_new
			return msg

		elif msg_len == buffer:
			msg += msg_new
			return getMulti(client_con, msg)

		else:
			print("EEEEEELLLLLLLLLLLSSSSSSSSSSSSSEEEEEEEEEEEEEEEE")
			# no idea what happened there /shrug
			return None

	except (ConnectionResetError, OSError, ConnectionAbortedError):
		print("getMulti - connection aborted")
		return None
