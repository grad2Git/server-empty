import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main() async {
  final overrideHeaders = {
    'Content-Type': 'application/json;charset=utf-8'
  };
  final listChecker = originOneOf(['https://grad2git-server-empty-ce64.twc1.net']);
  var handler = const Pipeline()
      .addMiddleware(corsHeaders(headers: overrideHeaders, originChecker: listChecker))
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
