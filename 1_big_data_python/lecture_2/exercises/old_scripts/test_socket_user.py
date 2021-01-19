from socket import *
import time

sock = socket(AF_INET, SOCK_STREAM)
sock.connect(('localhost', 25000))

n=0
def monitor():
    global n
    while True:
        time.sleep(1)
        print(n, "reqs/sec")
        n=0

while True:
    start = time.time()
    sock.send(b'30')
    resp = sock.recv(100)
    end = time.time()
    print(start - end)
