// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

File _$FileFromJson(Map<String, dynamic> json) => File(
      json['name'] as String,
      const Uint8ListConverter().fromJson(json['data'] as List<int>),
      json['filename'] as String,
    );

Map<String, dynamic> _$FileToJson(File instance) => <String, dynamic>{
      'name': instance.name,
      'data': const Uint8ListConverter().toJson(instance.data),
      'filename': instance.filename,
    };
