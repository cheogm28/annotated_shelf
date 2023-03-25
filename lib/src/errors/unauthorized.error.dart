import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Unauthorized Error 401
class UnauthorizedError extends BaseError {
  UnauthorizedError(super.message);

  @override
  Response getResponse() {
    return Response.unauthorized(message);
  }
}
