import asyncio
from asyncio.tasks import FIRST_COMPLETED
import ssl
import json
import sys
import time
from websockets import ConnectionClosed
from ws_stomp import WebSocketStomp
import redis
import argparse

def key_enter_callback(event):
    sys.stdin.readline()
    event.set()

async def future_read_message(ws, future):
    try:
        message = await ws.stomp_read_message()
        future.set_result(message)
    except ConnectionClosed:
        print('Websocket connection closed')

async def subscribe_loop(nodename, secret, ws_url, pubsub_node, topic):
    ws = WebSocketStomp(ws_url, nodename, secret, ssl._create_unverified_context())
    r = redis.Redis(host='localhost', port=6379, db=0)
    await ws.connect()
    await ws.stomp_connect(pubsub_node)
    await ws.stomp_subscribe(topic)
    # setup keyboard callback
    stop_event = asyncio.Event()
    asyncio.get_event_loop().add_reader(sys.stdin, key_enter_callback, stop_event)
    print("press <enter> to disconnect...")
    while True:
        future = asyncio.Future()
        future_read = future_read_message(ws, future)
        await asyncio.wait([stop_event.wait(), future_read], return_when=FIRST_COMPLETED)
        if not stop_event.is_set():
            message = json.loads(future.result())
            r.rpush("stomp:"+topic, json.dumps(message))
            # [print(i["state"] + " | " + i["userName"]) for i in message["sessions"]]
        else:
            await ws.stomp_disconnect('123')
            # wait for receipt
            await asyncio.sleep(3)
            await ws.disconnect()
            break


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--nodename', help='pxGrid controller node name')
    parser.add_argument('-w', '--webservice', help='pxGrid webservice path')
    parser.add_argument('-t', '--topic', help='webservice topic')
    parser.add_argument('-u', '--username', help='Client node name')
    parser.add_argument('-p', '--password', help='Password (optional)')
    config = parser.parse_args()
    asyncio.get_event_loop().run_until_complete(subscribe_loop(config.username, config.password, config.webservice, config.nodename, config.topic))
    # asyncio.get_event_loop().run_until_complete(subscribe_loop("isebox", "MDDqnieTIgzwAoq8", "wss://e-tddc-ise2-psn4.medcampus.org:8910/pxgrid/ise/pubsub", "e-tddc-ise2-psn4.medcampus.org", "/topic/com.cisco.ise.session"))
