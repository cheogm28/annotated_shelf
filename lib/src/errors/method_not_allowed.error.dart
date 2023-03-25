import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Bad Request Error 405
class MethodNotAllowedError extends BaseError {
  MethodNotAllowedError(super.message);

  @override
  Response getResponse() {
    return Response(405, body: message);
  }
}
