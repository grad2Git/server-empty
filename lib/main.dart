import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main() async {
  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
    ACCESS_CONTROL_ALLOW_CREDENTIALS: 'true',
    ACCESS_CONTROL_EXPOSE_HEADERS: "['*']",
    'Content-Type': 'application/json;charset=utf-8'
  };
  var handler = const Pipeline()
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, '0.0.0.0', 8080);

  server.autoCompress = true;
}

Future<Response> _echoRequest(Request request) async => Response.ok(
  {
    "headers": request.headers.map((key, value) => MapEntry(key, "$key:$value\n")).values.toString(),
    "body": await request.readAsString(),
  }.toString(),
);
