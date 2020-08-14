import base64
from datetime import datetime


class Counter:
    def __init__(self):
        pass
    cnt = 0


# make base64 ID
def create_id():
    # another offset for the Base64 ID
    Counter.cnt = (Counter.cnt + 1) % 900
    # create the base key string
    key = "%s-%s" % (datetime.now().isoformat(), Counter.cnt)
    # create the ID
    ret = base64.b64encode(bytes(key, 'utf-8')).decode("utf-8")
    # print(len(ret), ret, key, len(datetime.now().isoformat()))
    # print(len(ret), Counter.cnt)

    return ret  # len == 40 - string


# return to readable string - probably not needed
def decode_key(encode):
    return base64.b64decode(encode)
