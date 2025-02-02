import socket, logging
from enum import IntEnum

class Protocol(IntEnum):
    
    TCP = socket.IPPROTO_TCP
    UDP = socket.IPPROTO_UDP

class Scanner:

    def __init__(self, host : str, proto : Protocol):

        self.__proto = proto
        if self.__proto is None:

            self.__proto = Protocol.TCP

        self.host : str = host

    def validate_start_stop(self, start : int, stop : int):

        if start > stop:

            raise IndexError("start is greater than stop")

        elif start == 0:

            raise ValueError("start must not be zero")

        elif start < 0:

            raise ValueError("start must not be negative")

        elif stop > 65353:

            raise ValueError("stop should not be greater than 65353")

    def scan(self, start : int, stop : int):

        logging.debug(f"scanning {self.__proto.name} ports on {self.host} from {start} to {stop}...")
        self.validate_start_stop(start, stop)
        for i in range(start, stop + 1):
            
            try:
                
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, self.__proto.value)
                sock.settimeout(5.0)
                sock.connect((self.host, i))
                sock.close()
                yield i

            except ConnectionRefusedError:

                continue

            except (TimeoutError, socket.timeout):

                logging.error(f"timeout when scanning port {i}")
                continue

    #def __def__(self):
    #   
    #    logging.debug("destroying scanner resources...")

