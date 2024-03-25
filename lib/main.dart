import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);


  var server = await serve(handler, '0.0.0.0', 8000);

  server.autoCompress = true;
}

Future<Response> _echoRequest(Request request) async => Response.ok(
  {
    "headers": request.headers.map((key, value) => MapEntry(key, "$key:$value\n")).values.toString(),
    "body": await request.readAsString(),
  }.toString(),
);