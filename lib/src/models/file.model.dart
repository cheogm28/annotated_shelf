import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import 'converters/unit_list_converter.dart';

part 'file.model.g.dart';

/// Represents a File usually created by a multiform request
///
/// This classs is used to tag a class a as a file
@JsonSerializable(converters: [Uint8ListConverter()])
class File {
  String name;
  Uint8List data;
  String filename;
  File(this.name, this.data, this.filename);

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);
  Map<String, dynamic> toJson() => _$FileToJson(this);
}
