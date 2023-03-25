// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestResponse _$RestResponseFromJson(Map<String, dynamic> json) => RestResponse(
      json['code'] as int,
      json['messaje'],
      json['contentType'],
    );

Map<String, dynamic> _$RestResponseToJson(RestResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'messaje': instance.messaje,
      'contentType': instance.contentType,
    };
