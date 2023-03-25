import 'package:shelf/shelf.dart';

import 'base.error.dart';

/// Represents an http Not acceptable Error 406
class NotAcceptableError extends BaseError {
  NotAcceptableError(super.message);

  @override
  Response getResponse() {
    return Response(406, body: message);
  }
}
