# import asc_fnc
# import lib
import socket
from asc_fnc import *
from anarchy_main.client import *
from asc_fnc.message_handler import message_handler_c
from cmdList import cmdList
import json


def client_checkKey(sData, con_server, con_client, raddr):
    """

    :param sData:       socket Connection Data
    :param con_server:  Server Connection
    :param con_client:  Client Connection
    :param raddr:       remote IP and Port of connected Client
    :return:            None
    """
    # 1st message = We expect the Key of a length of 32Bit, to identify the connected User:
    print("waiting for Key...")
    while True:
        try:
            # receive only the 32Bit key, nothing else
            tKey_tmp = con_client.recv(32)
            if len(tKey_tmp) != 32:
                # key does not have the exact size!
                con_client.shutdown(socket.SHUT_RDWR)
                con_client.close()
                return
            else:
                # decode key to get a normal string
                tKey = tKey_tmp.decode("ascii")

                # print(f"AWAITING: KEY : {tKey}")
                # print(f"AWAITING: LIST: {sData.user_awaiting}")

                if tKey in sData.user_awaiting:
                    # reset timeout
                    con_client.settimeout(None)

                    # get PUID from awaiting list, before deleting the entry
                    puid = sData.user_awaiting[tKey]

                    # remove tKey from awaiting list
                    print(f"DEBUG MSG: user_rem: tKey: {tKey} - puid: {puid}")
                    del sData.user_awaiting[tKey]

                    # add the client connection to user_active (to close the connection)
                    sData.user_active[puid] = {"con": con_client}

                    # add to active connections
                    asc_s_lst_client.clientCnt_add(sData)

                    # create class and start client_handler
                    client = data_client(sData=sData, con_server=con_server, con_client=con_client, raddr=raddr, puid=puid)

                    # start listening to the socket connection
                    client.client_listener()
                else:
                    print("ASC_CLIENT: Key not found in awaitList - closing connection")
                    con_client.shutdown(socket.SHUT_RDWR)
                    con_client.close()
                break
        except socket.timeout:
            con_client.shutdown(socket.SHUT_RDWR)
            con_client.close()
            print("Timeout on connection")
            return


class data_client:
    def __init__(self, sData, con_server, con_client, raddr, puid):
        self.sData = sData
        self.con_server = con_server
        self.con_client = con_client
        self.ip = raddr
        self.puid = puid
        self.cData = {}


    #####################################################
    def client_listener(self):
        """
        Listening Thread for each connected Client on the Gameserver
        """

        con = self.con_client
        raddr = self.ip

        # print("ASC CLIENT: arma_client COMMANDS: ", cmdList["arma_client"])
        asc_g_msg.sendMsg("INIT_FUNCTIONS", cmdList["arma_client"], con)
        print("ASC CLIENT: COMMANDS SEND TO CLIENT")

        # load up the client information
        client_handler.client_init(self)

        while True:
            try:
                msg = asc_g_msg.getMulti(con)
                if not msg:
                    # print(f"ASC_CLIENT: None - Connection closed: {raddr[0]} : {raddr[1]}")
                    break
                try:
                    # Todo: MERGE WITH ASC_SERVER
                    # check if multiple messages received at once and handle them separately
                    if b"}{" in msg:
                        print("ASC_CLIENT: GET MESSAGE: MULTI MESSAGE RECEIVED")
                        for i in range(msg.count(b"}{") + 1):
                            splitPos = msg.find(b"}{") + 1
                            if splitPos == 0:
                                msg_tmp = msg
                            else:
                                msg_tmp = msg[:splitPos:]

                            try:
                                msg_d = json.loads(msg_tmp.decode('ascii'))
                                # get the codeTag and Data for the functions cmdList
                                code = msg_d["fnc"]
                                data = msg_d["data"]
                                message_handler_c(client=self, code=code, args=data)
                            except Exception as e:
                                # something went wrong, terribly...
                                print(f"FAULTY MESSAGE RECEIVED! ABORTING! MESSAGE: Exception: {e}")
                                continue

                            # remove msg_tmp from the main "MultiMessage"
                            msg = msg[splitPos::]
                    else:
                        try:
                            print("ASC_CLIENT: GET MESSAGE: SINGLE MESSAGE RECEIVED")
                            # load as json and decode it
                            msg_d = json.loads(msg.decode('ascii'))
                            # get the codeTag for the functions cmdList
                            code = msg_d["fnc"]
                            data = msg_d["data"]

                            message_handler_c(client=self, code=code, args=data)
                            # message_handler_c(con=con, code=code, cData=self.cData, args=data)
                        except Exception as e:
                            # something went wrong, terribly...
                            print(f"FAULTY MESSAGE RECEIVED! ABORTING! MESSAGE: Exception: {e}")
                            continue

                except (UnicodeDecodeError, Exception) as e:
                    print(f"ASC_CLIENT: {e} = msg: {msg}")
                    pass
            except ConnectionResetError:
                print(f"ASC_CLIENT: CR - Connection closed: {raddr[0]} : {raddr[1]}")
                break
            except socket.timeout:
                print("DEV: TIMEOUT")
                break

        # reduce Connected Client Count
        asc_s_lst_client.clientCnt_rem(self.sData)

        # Todo: Check if even needed
        try:
            con.shutdown(socket.SHUT_RDWR)
            con.close()
        except OSError:
            # already closed
            pass
