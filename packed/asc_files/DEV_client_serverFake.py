import socket
import time
from threading import Thread
from _thread import *
import random
from asc_fnc import *

ip = ("89.163.145.36", 5555)
# ip = ("127.0.0.1", 5555)
MESSAGEBUFFER = 512


# get messages, which are longer than the buffer size
def getMulti(socket_cur, msg=b""):
    """
    get a multi Message, by recursively getting messages (if a message is above the given buffer size)

    :param socket_cur:  currently used socket
    :param msg:         prev. message
    :return: byteString
    """
    msg_new = socket_cur.recv(MESSAGEBUFFER)
    if msg_new is None:
        return None
    if len(msg_new) < MESSAGEBUFFER:
        msg += msg_new
        return msg
    else:
        msg += msg_new
        return getMulti(socket_cur, msg)


def socket_server_fake():
    socket_con = socket.socket()

    print('Waiting for Server')
    try:
        socket_con.connect(ip)
    except socket.error as e:
        print(str(e))
        return
    print("connected")

    key = "aBc123gHi456jKl789"
    msg = bytes(key, "ascii")
    try:
        socket_con.send(msg)
    except ConnectionAbortedError:
        print("Connection refused #1")
        return
    except ConnectionResetError:
        print("Connection refused #2")
        return
    print("key send")

    time.sleep(0.25)
    print("adding user...")
    msg = b"['test']"
    socket_con.send(msg)

    # for i in range(5):
    #     time.sleep(1)
    #     print(i)
    #
    # print("adding user...")
    # msg = b"['test']"
    # socket_con.send(msg)

    while True:
        try:
            message = getMulti(socket_con)
            print(message)
        except ConnectionResetError:
            print("CONNECTION ERROR - Connection closed")
            break
        except socket.timeout:
            print("DEV: TIMEOUT")
            break


# start_new_thread(socket_server_fake, ())
Thread(target=socket_server_fake).start()
