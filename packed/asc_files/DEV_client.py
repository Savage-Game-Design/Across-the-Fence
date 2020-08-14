import socket
import time
from threading import Thread
import random

# ip = ("89.163.145.36", 5555)
ip = ("127.0.0.1", 5555)
MESSAGEBUFFER = 512


# get messages, which are longer than the buffer size
# def getMulti(client_con, msg=b""):
def getMulti(client_con: socket.socket, msg: bytes = b""):
    """
    get a multi Message, by recursively getting messages (if a message is above the given buffer size)

    :param client_con:  selected socket connection (client connection)
    :param msg:         prev. message
    :return: byteString
    """

    buffer = MESSAGEBUFFER
    try:
        try:
            msg_new = client_con.recv(buffer)
        except ConnectionResetError:
            return None
        except OSError:
            return None
        if msg_new is None:
            return None
        # if a message exceeds a certain bytes limit (e.g. endless Message)
        if len(msg) > 4000:
            print("connection closed >4000")
            try:
                client_con.shutdown(socket.SHUT_RDWR)
                client_con.close()
            except ConnectionResetError:
                pass
            return

        elif len(msg_new) < buffer:
            msg += msg_new
            return msg

        elif len(msg_new) == buffer:
            msg += msg_new
            return getMulti(client_con, msg)

        else:
            # no idea what happened there /shrug
            return None
    except ConnectionAbortedError:
        print("getMulti - connection aborted")


def socket_client():
    socket_con = socket.socket()

    print('Waiting for Server')
    try:
        socket_con.connect(ip)
    except socket.error as e:
        print(str(e))
        return
    print("connected")
    print("trying to send DEV-Key")
    key = "12345678901234567890123456789012"
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

    while True:
        try:
            msg = getMulti(socket_con)
            print(msg)
            if msg is None:
                break
            elif len(msg) < 1:
                break
            pass
        except Exception as e:
            print(f"EXCEPT TRIGGERED: {e}")
            break
        # time.sleep(1)
    print("DEV CLIENT EXIT")


Thread(target=socket_client).start()

# for i in range(10):
#     # time.sleep(0.01)
#     Thread(target=socket_client).start()
