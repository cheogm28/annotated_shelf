import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Bad Request Error 404
class BadRequestError extends BaseError {
  BadRequestError(super.message);

  @override
  Response getResponse() {
    return Response.badRequest(body: message);
  }
}
