from socket import *
from threading import Thread
from fib import fib

def echo_server(address):
    sock = socket(AF_INET, SOCK_STREAM)
    sock.setsockopt(SOL_SOCKET,SO_REUSEADDR,1)
    sock.bind(address)
    sock.listen(5)
    while True:
        client, addr = sock.accept()
        print("Connection ", addr)
        # echo_handler(client)
        Thread(target=echo_handler, args=(client,), daemon=True).start()

def echo_handler(client):
    while True:
        req = client.recv(100) #blocking
        if not req:
            break
        n = int(req)
        result=fib(n)
        resp = str(result).encode('ascii')
        client.send(resp) #blocking
    print("Close")

echo_server(('', 25000))
