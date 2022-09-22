import 'dart:io';
import 'package:args/args.dart';

void scan(String domain, int start, int end) async {

	print("scanning port range [$start .. $end] of $domain ...");
	int opennedPorts = 0;
	for (int port = start; port <= end; port++) {

	  	try{

			final socket = await Socket.connect(domain, port);
			socket.destroy();

			print('Port $port Openned');
			opennedPorts = opennedPorts + 1;
	  	}on SocketException{

			// print('Port $port Closed');
	  	}
	}

	print('Found $opennedPorts ports');
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
		..addOption("domain", abbr : "d", help : "domain name to be scanned");
	
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
	
  	scan(argsResult["domain"], int.parse(argsResult["start"]), int.parse(argsResult["end"]));
}
