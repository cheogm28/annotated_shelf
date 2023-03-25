import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

/// converts a bit array into a Unit8List
class Uint8ListConverter implements JsonConverter<Uint8List, List<int>> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(List<int> json) => Uint8List.fromList(json);

  @override
  List<int> toJson(Uint8List object) => object.toList();
}
