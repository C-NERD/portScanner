import 'dart:io';

void main(List<String> arguments) async {

  if (arguments.length == 3) {

    int start = int.parse(arguments[1]);
    int end = int.parse(arguments[2]);
    for (int port = start; port <= end; port++) {

      try{

        final socket = await Socket.connect(arguments[0], port);
        socket.destroy();
        print('Port $port Openned');
      }on SocketException{

        print('Port $port Closed');
      }
    }
  }else{

    print('Invalid number of arguments');
  }
}
