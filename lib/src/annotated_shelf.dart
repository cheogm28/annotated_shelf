import 'dart:mirrors';

import 'package:shelf/shelf.dart';

import 'annotation/RESTAPI.annoation.dart';
import 'errors/base.error.dart';
import 'core.dart';

Future<Cascade> addExecute(
    Cascade router, function, rootMember, ref, baseUrl) async {
  router = await function.reflectee.execute(
      (Map<String, dynamic> mapedParameters) async {
    try {
      var functionParameters =
          getFunctionParameters(rootMember.parameters, mapedParameters);
      var result = ref.invoke(rootMember.simpleName, functionParameters);
      var response = await result.reflectee;
      return handleResponse(response);
    } on BaseError catch (e) {
      return e.getResponse();
    }
  }, router, baseUrl);
  return router;
}

Future<Cascade> handleProperties(
    Iterable<InstanceMirror> propertyData,
    Cascade router,
    MethodMirror rootMember,
    InstanceMirror ref,
    String baseUrl) async {
  for (var function in propertyData) {
    var completeUrl = baseUrl + function.reflectee.url;
    if (hasSameParams(completeUrl, rootMember.parameters)) {
      router = await addExecute(router, function, rootMember, ref, baseUrl);
    }
  }
  return router;
}

Future<Cascade> mountURLMethod(MethodMirror rootMember, InstanceMirror ref,
    Cascade router, String baseUrl) async {
  var propertyData =
      rootMember.metadata.where((element) => isAnnotatedShelfMethod(element));
  if (propertyData.isNotEmpty) {
    router =
        await handleProperties(propertyData, router, rootMember, ref, baseUrl);
  }
  return router;
}

/// Mounts the router [adapter] inside the shelf [Cascade] [router]
///
/// The [adapter] must have the [RestAPI] annotation
Future<Cascade> mount(dynamic adapter, Cascade router) async {
  var ref = reflect(adapter);
  print('-------------------------------------');
  print('mounting ${ref.reflectee}');
  var rootmember = ref.type.metadata
      .where((element) => element.reflectee is RestAPI)
      .toList();
  var baseUrl = rootmember.single.reflectee.baseUrl != ""
      ? rootmember.single.reflectee.baseUrl
      : "";
  for (var rootMember in ref.type.instanceMembers.values) {
    if (rootMember.metadata.isNotEmpty) {
      router = await mountURLMethod(rootMember, ref, router, baseUrl);
    }
  }
  print('-------------------------------------');
  return router;
}
