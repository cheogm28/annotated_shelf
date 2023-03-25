import 'package:shelf/shelf.dart';

abstract class BaseError extends Error {
  final String message;
  BaseError(this.message) : super();

  Response getResponse();
}
