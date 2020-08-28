import random
import socket
import string
from _thread import *
from threading import Thread
import asc_server
from asc_client import *
import time
import sys
import os


def server_start():
    print("PRE: Starting Main Thread... done")
    print("\n########################################################\nMAIN: Loading config...")
    # load the config.cfg values
    try:
        rel_dir = os.path.dirname(__file__)
        filepath = os.path.join(rel_dir, "config.cfg")
        lines = open(filepath, 'r').read().split("\n")
        params = dict()
    except FileExistsError:
        print("MAIN: ERROR: config.cfg not found")
        return
    try:
        for line in lines:
            line.strip()
            if len(line) == 0 or line[0] == "#":
                continue
            key, value = list(map(lambda x: x.strip(), line.split('=')))
            if len(value) == 0:
                value = None
            params[key] = value
    except Exception as e:
        print("MAIN: ERROR: YOU MADE A MESS IN THE CONFIG! SHAME ON YOU! ERROR:", sys.exc_info()[0])
        print(e)
        return

    print("MAIN: Loading config... done")

    # start the socket Server
    sock_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print("\n########################################################")
    print(f"#### Path to Backend:\n#### - {params['path']}")
    databasePath = params["databasePath"]
    databaseName = params["databaseName"]
    print(f'#### Path to Database:\n#### - {params["databasePath"]}{params["databaseName"]}')
    print(f"#### IP:Port:\n#### - {params['ip']}:{params['port']}")
    ip = (params["ip"], int(params["port"]))
    server_key = params["server_key"]
    server_ip = params["server_ip"]
    print(f'#### Server key:\n#### - "{server_key}"')

    # ############# Loot data thingy stuff burp
    # ####### set the main lootseed ...
    if params["lootseed"] is None:
        sData.lootData["globalseed"] = "".join(random.choices(string.ascii_letters, k=8))
    else:
        sData.lootData["globalseed"] = params["lootseed"]
    print(f'#### Lootseed:\n#### - "{sData.lootData["globalseed"]}"')

    # ... and load data from the json loot tables
    print(f'#### Loading loot-tables...')
    path_tables = f"{rel_dir}\\loottables\\"
    json_files = [pos_json for pos_json in os.listdir(path_tables) if pos_json.endswith('.json')]
    for filename in json_files:
        # print(f"DEBUG: filename: {filename}")
        with open(f"{path_tables}{filename}", "r") as read_file:
            # add the .json data to the sData dict
            sData.lootData["tables"][os.path.splitext(filename)[0]] = json.load(read_file)
    # # Debug
    # for key in sData.lootData["tables"]:
    #     print(f"DEBUG: key: {key}")
    # ############# Loot stuff... done
    print(f'#### Loading loot-tables... done')

    print("########################################################\n")

    try:
        sock_server.bind(ip)
    except socket.error as e:
        print(f'\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!!! SOCKET ALREADY IN USE! \n!!!! CHECK FOR ANOTHER RUNNING INSTANCE/PROGRAM THAT USES THE PORT: {params["port"]}\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\nError Message:')
        print(str(e))
        return

    # listen == max. backlog
    sock_server.listen(100)

    print('MAIN: STATUS: Waiting for game-server...')
    # wait for the Arma-Server to connect
    key_length = len(server_key)
    while True:
        # time.sleep(0.01)
        print("MAIN: waiting for connection... ")
        con_server, raddr = sock_server.accept()
        print("MAIN: waiting for connection... done")

        # DEV: When testing on remote Server, get your IP and add it to the config entry: "server_ip"
        # print(time.process_time_ns(), "Connection established from: ", raddr[0])
        if raddr[0] == server_ip:
            con_server.settimeout(1)
            try:
                print("MAIN: waiting for message... ")
                msg = con_server.recv(key_length).decode('ascii')
                print("MAIN: waiting for message... done")
                print(f"MAIN: Checking this Server key: {msg}")
                print(f"MAIN: Key matched: {msg == server_key}")

                if msg == server_key:
                    con_server.settimeout(None)
                    print(f"MAIN: Connected from {raddr[0]}:{raddr[1]}")
                    # set ConnectionData in the sData class
                    sData.con_gameServer = con_server
                    # add the mainSocket Con, so we can close it if needed
                    sData.mainConnection = sock_server

                    # start listening thread for messages from the Server
                    Thread(target=sData.gameserver_listen, args=[databasePath, databaseName]).start()
                    break
                else:
                    print(f"MAIN: Key did not match: {msg} / {server_key} | {msg == server_key}")
                    con_server.shutdown(socket.SHUT_RDWR)
                    con_server.close()
            except socket.timeout as e:
                print(f"MAIN: failed to respond in given time: {e}")
                con_server.shutdown(socket.SHUT_RDWR)
                con_server.close()
        else:
            con_server.shutdown(socket.SHUT_RDWR)
            con_server.close()

    print('MAIN: STATUS: Waiting for game-server... done')

    ########################################################

    print('MAIN: STATUS: Waiting for a Clients...')
    # allow user connections
    while True:
        try:
            # time.sleep(0.1)
            con_client, raddr = sock_server.accept()
            # print(f"raddr: {raddr} -  user_awaiting NOT empty: {len(sData.user_awaiting) > 0}")
            con_client.settimeout(2)
            if len(sData.user_awaiting) > 0:
                if sData.cur <= sData.threads_max:
                    print(f"MAIN: Client: New Connection from: {raddr[0]} : {raddr[1]}")
                    # create class
                    # start ClientThread to check for tKey
                    start_new_thread(client_checkKey, (sData, con_server, con_client, raddr))
                else:
                    # connection blocked
                    con_client.shutdown(socket.SHUT_RDWR)
                    con_client.close()
            else:
                print(f"MAIN: Client: Connection refused for {raddr} - closing connection")
                # connection blocked
                con_client.shutdown(socket.SHUT_RDWR)
                con_client.close()
        except OSError:
            print("MAIN: Client: SERVER CONNECTION CLOSED. Exiting...")
            # using this to "auto-close" the socket connection (cheap, but works ¯\_(ツ)_/¯ )
            break
    # graceful way of leaving:
    print("MAIN: Client: SERVER CONNECTION CLOSED. Exiting... done")


if __name__ == "__main__":
    print("########################################################")
    print("PRE: loading data_server... ")
    sData = asc_server.data_server()
    print("PRE: loading data_server... done")
    print("PRE: Starting Main Thread...")
    server_start()

    # shutting down with a short delay, so if there are errors, they can spot them
    print("\n\n########################################################")
    print(f"MAIN: SHUTTING DOWN IN 10s")
    time.sleep(5)
    print(f"MAIN: SHUTTING DOWN IN 5s")
    time.sleep(3)
    print(f"cya, bye bye and have a nice day")
    time.sleep(2)
