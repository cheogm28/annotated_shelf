import 'package:json_annotation/json_annotation.dart';

part 'rest_response.g.dart';

/// Represents the response of a handler
///
/// This response is used to force a response inseted of the default response.
@JsonSerializable()
class RestResponse {
  final int code;
  final dynamic messaje;
  final String contentType;
  RestResponse(this.code, this.messaje, this.contentType);

  factory RestResponse.fromJson(Map<String, dynamic> json) =>
      _$RestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RestResponseToJson(this);
}
