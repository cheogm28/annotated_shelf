/// Represents an error when parsing the parameters of an annotation
class ParameterError extends Error {
  final String message;
  ParameterError(this.message);
}
