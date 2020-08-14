from datetime import datetime

def timestamp_get():
	return f"{datetime.fromtimestamp(datetime.timestamp(datetime.now()))}"
