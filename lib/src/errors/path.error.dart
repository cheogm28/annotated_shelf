/// Represents an error when parsing the parameters of an annotation
class PathError extends ArgumentError {
  PathError(message) : super(message);

  @override
  String toString() => 'PathError: $message';
}
