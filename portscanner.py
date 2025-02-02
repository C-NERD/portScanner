#!/usr/bin/env python
import cyclopts, logging
from typing import Literal
import scanner.scanner as scanner

logging.basicConfig(format = "%(levelname)s :: %(message)s", level = logging.DEBUG)
app = cyclopts.App()

@app.command
def scan(
    host: str = "localhost",
    start : int = 1,
    stop : int = 500,
    protocol : Literal["TCP", "UDP"] = "TCP"
):
    """Scan ports on a host

    Parameters
    ----------
    host
        host address to scan.
    start
        port to start scanning from
    stop
        port to stop scanning at
    protocol
        internet protocol to be used
    """
    if protocol == "TCP":

        enum_protocol = scanner.Protocol.TCP

    elif protocol == "UDP":

        enum_protocol = scanner.Protocol.UDP

    scan_obj = scanner.Scanner(host, enum_protocol)
    logging.debug("scanning for openned ports...")
    for port in scan_obj.scan(start, stop):

        print(port)

if __name__ == "__main__":

    app()
