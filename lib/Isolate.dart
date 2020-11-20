import 'dart:async';
import 'dart:isolate';

Isolate _isolate;
Timer _timer;

Future<ReceivePort> starIsolate({String nombre}) async {
  ReceivePort receivePort = new ReceivePort();
  _isolate = await Isolate.spawn(
    _accionIsolate,
    {
      "nombre": nombre,
      "sendPort": receivePort.sendPort,
    },
  );

  return receivePort;
}

void stopIsolete() {
  if (_isolate != null) {
    _isolate.kill(priority: Isolate.immediate);
    _timer.cancel();
  }
}

void _accionIsolate(Map<String, dynamic> data) {
  String nombre = data["nombre"];
  SendPort sendPort = data["sendPort"];
  int cont = 0;
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    cont++;
    print("nombre: $nombre tiempo: $cont");
    sendPort.send({"timer": cont});
  });
}
