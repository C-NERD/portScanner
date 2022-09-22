import "dart:io";
import "package:args/args.dart";
import "package:interact/interact.dart";

void scan(String domain, int start, int end, {int delay = 0, int timeout = 2}) async {

	print("scanning port range [$start .. $end] of $domain ...");

  if (start > end){

    throw ArgumentError("start port $start is greater than end port $end");
  }

  List<int> opennedPorts = [];
  int totalOpennedPorts = 0;
  int rangeEnd = end - start;

  final progress = Progress(
    length: rangeEnd,
    size: 0.5,//100 / (end - start),
    rightPrompt: (current) => " ${(current + start).toString().padLeft(3)}/$end",
  ).interact();

	for (int port = start; port <= end; port++) {

	  try{

			final socket = await Socket.connect(domain, port, timeout : Duration(seconds : timeout));
			socket.destroy();

      opennedPorts.add(port);
			totalOpennedPorts = totalOpennedPorts + 1;
	  }on SocketException{

			// print("Port $port Closed");
	  }

    if (delay > 0){

      await Future.delayed(Duration(seconds : delay));
    }
    progress.increase(1);
	}

  progress.done();
	print("Found $totalOpennedPorts ports");
  print("Ports $opennedPorts are Openned");
}

void main(List<String> arguments) {

	var parser = ArgParser();

	parser
		..addFlag("help", abbr : "h", help : "print this help message", callback : (bool val) => {
			
			if (val){

				print(parser.usage)
			}
		})
		..addOption("start", abbr : "s", help : "port to start scanning from", defaultsTo : "0", callback : (String? val) => {

			if (val != null){
				
				if (int.parse(val) < 0){

					throw IndexError(int.parse(val), 65353)
				}
			}
		})
		..addOption("end", abbr : "e", help : "port to end scanning at", defaultsTo : "65353", callback : (String? val) => {

			if (val != null){

				if (int.parse(val) > 65353){

					throw IndexError(int.parse(val), 65353)
				}
			}
		})
    ..addOption("delay", abbr : "d", help : "number of seconds to wait between port scanning", defaultsTo : "0", callback : (String? val) => {

			if (val != null){

				if (int.parse(val) < 0){

					throw IndexError(int.parse(val), 600)
				}else if(int.parse(val) > 600 /*must be less than 10 minutes or 600 seconds*/){

          throw IndexError(int.parse(val), 600)
        }
			}
		})
    ..addOption("timeout", abbr : "t", help : "number of seconds to wait for an irresponsive port", defaultsTo : "2", callback : (String? val) => {

			if (val != null){

				if (int.parse(val) < 2){

					throw IndexError(int.parse(val), 20)
				}else if(int.parse(val) > 20 /*must be less than 10 minutes or 600 seconds*/){

          throw IndexError(int.parse(val), 20)
        }
			}
		})
		..addOption("domain", help : "domain name to be scanned");
	
	var argsResult = parser.parse(arguments);
	if (argsResult.arguments.isEmpty){

		print("use the --help or -h flag to print the help message");
		exit(0);
	}else if (argsResult["help"]){

		exit(0);
	}else if(argsResult["domain"] == null){

		print("domain parameter is empty");
		exit(-1);
	}
	
  	scan(
      argsResult["domain"], 
      int.parse(argsResult["start"]), 
      int.parse(argsResult["end"]), 
      delay : int.parse(argsResult["delay"]),
      timeout : int.parse(argsResult["timeout"])
    );
}
