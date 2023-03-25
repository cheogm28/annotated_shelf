import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Not found Error 404
class NotFoundError extends BaseError {
  NotFoundError(super.message);

  @override
  Response getResponse() {
    return Response.notFound(message);
  }
}
