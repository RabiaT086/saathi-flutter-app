import 'dart:io';

void main() async {
  final port = 8080;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Saathi App is live at http://localhost:$port/ and http://192.168.100.69:$port/');
  
  await for (HttpRequest request in server) {
    try {
      var path = request.uri.path;
      if (path == '/' || path.isEmpty) path = '/index.html';
      var file = File('build/web$path');
      
      if (!await file.exists()) {
        file = File('build/web/index.html');
      }

      request.response.headers.set('Cache-Control', 'no-cache, no-store, must-revalidate');

      if (file.path.endsWith('.js')) {
        request.response.headers.set('Content-Type', 'application/javascript; charset=utf-8');
      } else if (file.path.endsWith('.html')) {
        request.response.headers.set('Content-Type', 'text/html; charset=utf-8');
      } else if (file.path.endsWith('.json')) {
        request.response.headers.set('Content-Type', 'application/json; charset=utf-8');
      } else if (file.path.endsWith('.wasm')) {
        request.response.headers.set('Content-Type', 'application/wasm');
      } else if (file.path.endsWith('.png')) {
        request.response.headers.set('Content-Type', 'image/png');
      } else if (file.path.endsWith('.ttf')) {
        request.response.headers.set('Content-Type', 'font/ttf');
      }

      await file.openRead().pipe(request.response);
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.close();
    }
  }
}
