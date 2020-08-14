import socket

# Keep track of connected Clients (very basic)
def clientCnt_add(sData):
	"""
	CheapAssConnectedClientsCounter

	:param sData:   Main Server-class
	:return: Nothing
	"""
	sData.cur += 1
	print(f"Client connected: ({sData.cur} connected)")


def clientCnt_rem(sData):
	"""
	CheapAssConnectedClientsCounter

	:param sData:   Main Server-class
	:return:
	"""
	sData.cur -= 1
	print(f"Client disconnected: ({sData.cur} connected)")


# add Clients to the await-list
def client_await_add(sData, *args):
	"""
	Add Client to the user_awaiting list, on connecting, to determine which Client uses which PUID

	:param sData:   Main Server-class
	:param tKey:    TemporaryKey, given by the GameServer
	:param puid:    PlayerUID (Arma 3)
	:return:        Nothing
	"""
	try:
		tKey, puid = args
		sData.user_awaiting[tKey] = puid
		print(f"user_awaiting: ADD: {sData.user_awaiting}")
	except Exception as e:
		print(f"ERROR: CAA: {e}")
		return


def client_active_rem(sData, *args):
	"""
	Remove user from user_active list on disconnect

	:param sData:   Main Server-class
	:param puid:     PlayerUID (Arma 3)
	:return:
	"""
	puid = args
	# close client socket Connection
	try:
		_clientDict = sData.user_active[puid]
		client_con = _clientDict["con"]
		client_con.shutdown(socket.SHUT_RDWR)
		client_con.close()
		del sData.user_active[puid]
		print('DEBUG: Player removed from "user_active"')
	# except Exception as e:
	#     print(e)
	except KeyError:
		# the disconnected Client didn't connect properly, so remove it from "self.user_awaiting"
		for tKey in sData.user_awaiting:
			print("CHECKING: ", sData.user_awaiting[tKey], " - ", puid)
			if sData.user_awaiting[tKey] == puid:
				del sData.user_awaiting[tKey]
				break


def blacklist_add(sData, raddr):
	# IP Blacklist - Currently not used
	"""
			CURRENTLY NOT IN USE!
			Add Client to the blacklist (blocking connections)

			:param sData:   Main Server-class
			:param raddr:   remote IP + Port to put on Blacklist
			:return:
			"""
	sData.blacklist.append(raddr[0])
	print("blacklist: ", sData.blacklist)


def blacklist_rem(sData, raddr):
	"""
	CURRENTLY NOT IN USE!
	Removes Client to the blacklist (blocking connections)

	:param sData:   Main Server-class
	:param raddr:   remote IP + Port to put on Blacklist
	:return:
	"""
	if raddr in sData.blacklist:
		sData.blacklist.remove(raddr)
		print(f"Blacklist: remote Address removed: {raddr}")
		print(f"Blacklist: {sData.blacklist}")
	else:
		print(f"Blacklist: remote Address NOT FOUND: {raddr}")