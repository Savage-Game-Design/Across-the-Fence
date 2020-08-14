from cmdList import cmdList


def message_handler_c(client=None, code: str = "None", args=()):
	"""
	:param client:      client Data
	:param code:        message send
	:param args:        opt. additional arguments, passed to selected function
	:return:            nothing
	"""

	if client is None:
		print("ERROR: MESSAGE_HANDLER: CLIENT DATA NOT PASSED")
		return
	print(f"DEBUG: ################# MSG_HANDLER ########################")
	print(f"DEBUG: MSG_HANDLER_C: code       : {code}")
	print(f"DEBUG: MSG_HANDLER_C: *args      : {args}")
	print(f"DEBUG: ######################################################")

	try:
		if len(args) > 0:
			# print("cmdList WITH Args")
			cmdList["client"][code](client=client, args=args)
		else:
			# print("cmdList WITHOUT Args")
			cmdList["client"][code](client=client)

	except KeyError as e:
		print(f"ERROR: MSG_HANDLER_C: KeyError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except UnicodeDecodeError as e:
		print(f"ERROR: MSG_HANDLER_C: UnicodeDecodeError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except AttributeError as e:
		print(f"ERROR: MSG_HANDLER_C: AttributeError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except Exception as e:
		print(f"ERROR: MSG_HANDLER_C: Exception:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass


def message_handler_s(sData=None, code: str = "None", args=None):
	"""
	:param code:        message send
	:param sData:
	:param args:        opt. additional arguments, passed to selected function
	:return:            nothing
	"""
	if sData is None:
		# DEV
		print("DEBUG: ################# MSG_HANDLER ########################")
		print("DEBUG: sData NOT PASSED AS ARGUMENT!")
		print(f"DEBUG: ######################################################")
		return
	if args is None:
		args = ()
	print(f"DEBUG: ################# MSG_HANDLER ########################")
	print(f"DEBUG: MSG_HANDLER_S: code       : {code}")
	print(f"DEBUG: MSG_HANDLER_S: *args      : {args}")
	print(f"DEBUG: ######################################################")

	try:
		if len(args) > 0:
			# print("cmdList WITH Args")
			cmdList["server"][code](sData, *args)
		else:
			# print("cmdList WITHOUT Args")
			cmdList["server"][code](sData)

	except KeyError as e:
		print(f"ERROR: MSG_HANDLER_S: KeyError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except UnicodeDecodeError as e:
		print(f"ERROR: MSG_HANDLER_S: UnicodeDecodeError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except AttributeError as e:
		print(f"ERROR: MSG_HANDLER_S: AttributeError:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
	except Exception as e:
		print(f"ERROR: MSG_HANDLER_S: Exception:\ncode: {code}\nargs: {args}\nERROR MESSAGE: {e}")
		pass
