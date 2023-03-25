import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents Interna server error 500
class InternalServerError extends BaseError {
  InternalServerError(super.message);

  @override
  Response getResponse() {
    return Response.internalServerError(body: message);
  }
}
