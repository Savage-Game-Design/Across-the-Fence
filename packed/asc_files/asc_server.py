import socket
import json
from asc_fnc import *
from cmdList import cmdList
from asc_fnc.asc_db import database
from asc_fnc.message_handler import message_handler_s

# set up the ServerData Class
class data_server:
    def __init__(self, blacklist=None, threads_max=150, msgBuffer=2000):
        if blacklist is None:
            blacklist = list()
        self.threads_max = threads_max
        self.cur = 0
        # self.blacklist = ["127.0.0.1"]
        self.blacklist = blacklist
        self.MESSAGEBUFFER = msgBuffer
        self.threads_max = threads_max
        self.user_awaiting = dict()
        self.user_active = dict()
        self.con_gameServer = None
        self.mainConnection = None
        self.database = None
        self.lootData = {"globalseed": "", "tables": {}}
        self.itemData = {}

    # ##################################################################################################

    def gameserver_listen(self, dbPath: str = "", dbName: str = ""):
        """

        :param dbPath:      Path to the database file
        :param dbName:      filename
        :return:
        """

        # Load up the Database:
        self.database = database.asc_db(dbName=dbName, dbPath=dbPath)
        if self.database.name is None:
            print(f"self.database.name: {self.database.name}")
            self.mainConnection.close()
            return
        print(f'#### ASC: DB Name: {self.database.db_get_name()}\n#### ASC: DB Last update: {self.database.db_get_lastUpd()}\n########################################################\n')

        print("ASC SERVER: arma_server COMMANDS:\n", cmdList["arma_server"])
        asc_g_msg.sendMsg("INIT_FUNCTIONS", cmdList["arma_server"], self.con_gameServer)
        print("\nASC SERVER: COMMANDS SEND TO SERVER\n")

        # listening Thread for messages from the game-Server
        while True:
            try:
                msg = asc_g_msg.getMulti(self.con_gameServer)
                if not msg:
                    print(f"GAME SERVER: Connection closed")
                    for key in self.user_active:
                        con = self.user_active[key]["con"]
                        con.shutdown(socket.SHUT_RDWR)
                        con.close()
                        pass
                    break
                else:
                    # check if multiple messages received at once and handle them separately
                    if b"}{" in msg:
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
                                message_handler_s(sData=self, code=code, args=data)
                            except Exception as e:
                                # something went wrong, terribly...
                                print(f"FAULTY MESSAGE RECEIVED! ABORTING! MESSAGE: Exception: {e}")
                                continue

                            # remove msg_tmp from the main "MultiMessage"
                            msg = msg[splitPos::]
                    else:
                        try:
                            # load as json and decode it
                            msg_d = json.loads(msg.decode('ascii'))
                            # get the codeTag for the functions cmdList
                            code = msg_d["fnc"]
                            data = msg_d["data"]

                            message_handler_s(sData=self, code=code, args=data)
                        except Exception:
                            # something went wrong, terribly...
                            print(f"FAULTY MESSAGE RECEIVED! ABORTING! MESSAGE: Exception: {e}")
                            continue

            except ConnectionResetError:
                print(f"GAME SERVER: CRE - Connection closed - Disconnecting all Clients...")
                for key in self.user_active:
                    con = self.user_active[key]["con"]
                    try:
                        con.shutdown(socket.SHUT_RDWR)
                        con.close()
                    except OSError:
                        # already closed
                        pass
                print(f"GAME SERVER: CRE - Connection closed - Disconnecting all Clients... done")
                break

            except socket.timeout:
                print("GAME SERVER: Socket timeout - Disconnecting all Clients...")
                for key in self.user_active:
                    con = self.user_active[key]["con"]
                    try:
                        con.shutdown(socket.SHUT_RDWR)
                        con.close()
                    except OSError:
                        # already closed
                        pass
                print("GAME SERVER: Socket timeout - Disconnecting all Clients... done")
                break

        try:
            print(f"GAME SERVER: Connection closed - closing Socket...")
            # Left in as a note: DO NOT RE-ENABLE! "breaks" the auto-exit... :whistle:
            # self.mainConnection.shutdown(socket.SHUT_RDWR)
            self.mainConnection.close()
        except OSError:
            # already closed
            print(f"GAME SERVER: Connection already closed.")

        print(f"GAME SERVER: Connection closed - closing Socket... done")
        return
