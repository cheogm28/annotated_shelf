import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Service Unavailable Error 503
class ServiceUnavailableError extends BaseError {
  ServiceUnavailableError(super.message);

  @override
  Response getResponse() {
    return Response(503, body: message);
  }
}
