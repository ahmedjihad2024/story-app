import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SupabaseLogger extends http.BaseClient {
  SupabaseLogger([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;

  static const _hiddenHeaders = {'authorization', 'apikey'};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final sw = Stopwatch()..start();

    final headers = request.headers.map(
      (k, v) => MapEntry(k, _hiddenHeaders.contains(k.toLowerCase()) ? '***' : v),
    );

    final reqBody = request is http.Request ? request.body : '';
    _log(
      '┌── REQUEST ──────────────────────────────\n'
      '│ ${request.method} ${request.url}\n'
      '│ Headers: $headers\n'
      '${reqBody.isNotEmpty ? '│ Body: ${_pretty(reqBody)}\n' : ''}'
      '└─────────────────────────────────────────',
    );

    try {
      final response = await _inner.send(request);
      final bytes = await response.stream.toBytes();
      final resBody = utf8.decode(bytes, allowMalformed: true);
      sw.stop();

      _log(
        '┌── RESPONSE ─────────────────────────────\n'
        '│ ${response.statusCode} ${request.method} ${request.url}  (${sw.elapsedMilliseconds}ms)\n'
        '│ Body: ${_pretty(resBody)}\n'
        '└─────────────────────────────────────────',
      );

      // لازم نرجّع stream جديد لأن الأصلي اتقرا
      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        contentLength: bytes.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e) {
      sw.stop();
      _log(
        '┌── ERROR ────────────────────────────────\n'
        '│ ${request.method} ${request.url}  (${sw.elapsedMilliseconds}ms)\n'
        '│ $e\n'
        '└─────────────────────────────────────────',
      );
      rethrow;
    }
  }

  String _pretty(String body) {
    if (body.isEmpty) return '(empty)';
    try {
      return const JsonEncoder.withIndent('  ').convert(jsonDecode(body));
    } catch (_) {
      return body;
    }
  }

  /// بيقسّم اللوج لأسطر، وأي سطر طويل بيتقسم لأجزاء 800 حرف
  /// عشان Android logcat مايقصّهوش.
  void _log(String message) {
    if (!kDebugMode) return;
    const chunkSize = 800;
    for (final line in message.split('\n')) {
      if (line.length <= chunkSize) {
        debugPrint(line);
      } else {
        for (var i = 0; i < line.length; i += chunkSize) {
          final end = (i + chunkSize < line.length) ? i + chunkSize : line.length;
          debugPrint(line.substring(i, end));
        }
      }
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}