import cyclopts, logging
from typing import Literal
import scanner.scanner as scanner

logging.basicConfig(format = "%(levelname)s :: %(message)s", level = logging.DEBUG)
app = cyclopts.App()

@app.command
def scan(
    host: str = "localhost",
    start : int = 0,
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

        protocol = scanner.Protocol.TCP

    elif protocol == "UDP":

        protocol = scanner.Protocol.UDP

    scan_obj = scanner.Scanner(host, protocol)
    logging.debug("scanning for openned ports...")
    for port in scan_obj.scan(start, stop):

        print(port)

if __name__ == "__main__":

    app()
