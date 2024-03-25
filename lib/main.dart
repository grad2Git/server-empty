import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  var handler = const Pipeline()
      .addHandler(_echoRequest);


  var server = await serve(handler, '0.0.0.0', 443);

  server.autoCompress = false;
}

Future<Response> _echoRequest(Request request) async => Response.ok(
  {
    "headers": request.headers.map((key, value) => MapEntry(key, "$key:$value\n")).values.toString(),
    "body": await request.readAsString(),
  }.toString(),
);