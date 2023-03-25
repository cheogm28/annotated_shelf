import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Forbidden Error 403
class ForbiddenError extends BaseError {
  ForbiddenError(super.message);

  @override
  Response getResponse() {
    return Response.forbidden(message);
  }
}
