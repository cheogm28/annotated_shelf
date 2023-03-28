import 'dart:convert';
import 'dart:mirrors';
import 'dart:typed_data';

import 'package:annotated_shelf/annotated_shelf.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/multipart.dart';

/// Returns a map with the name of the parameter of the method and the value in the url
///
/// The [originalParam] represents the params in the method and the [requestParams] the params values
/// It throws [PathError] when parameters do not match
Map getPathParamsMap(List<String> originalParam, List<String> requestParams) {
  Map<String, String> pathParams = {};
  bool isParam = true;

  List segments = [...originalParam];
  segments.removeWhere((element) => requestParams.contains(element));

  for (var param in requestParams.asMap().entries) {
    var urlIndex = originalParam.indexOf(param.value);
    if (urlIndex == -1) {
      isParam = originalParam[param.key].contains('<') &&
          originalParam[param.key].contains('>');
      if (isParam) {
        var key = originalParam[param.key].replaceAll(RegExp(r'(\W+)'), '');
        pathParams[key] = param.value;
      } else {
        throw PathError('wrong path name');
      }
    }
  }

  if (segments.length == pathParams.length) {
    return pathParams;
  } else {
    throw PathError('wrong path name');
  }
}

/// Checks if the url params and the handler method params are the same
bool isSameLink(List<String> originalParam, List<String> requestParams) {
  var response = false;
  if (originalParam.length == requestParams.length) {
    response = true;
    var copyOfOriginal = [...originalParam];
    var copyRequestParam = [...requestParams];

    copyRequestParam.removeWhere((element) => originalParam.contains(element));
    copyOfOriginal.removeWhere((element) => requestParams.contains(element));

    if (copyRequestParam.length == copyOfOriginal.length) {
      for (var element in copyOfOriginal) {
        response = element.contains('<') && element.contains('>');
      }
    }
  }
  return response;
}

/// Checks if the given url accepts all the params in the list as parameters
///
/// If [parameter] contains [Payload], [Form] or [Request] they are not going
/// to be taken in count in thismethod because they must be the body param.
bool hasSameParams(String url, List<ParameterMirror> parameters) {
  var annotationUrlSegment = Uri.parse(url)
      .pathSegments
      .where((element) => element.contains('<'))
      .length;
  var functionParams = parameters.where((element) =>
      !(element.type.isSubtypeOf(reflectType(Form)) ||
          element.type.isSubtypeOf(reflectType(Payload)) ||
          element.type.isSubtypeOf(reflectType(Request))));
  return functionParams.length == annotationUrlSegment;
}

/// Creates an instance of [Type] from the map [parameter] and adds it to a list [parametersList]
///
/// The object that [Type] represents must have the fromJson method
/// throws [ParameterError] when something happens
void addCreatedObjectOfType(Type type, dynamic parameter, List parametersList) {
  try {
    var reflectedClass = reflectClass(type);
    var object =
        reflectedClass.newInstance(Symbol('fromJson'), [parameter]).reflectee;
    parametersList.add(object);
  } catch (e) {
    throw ParameterError('addCreatedObjectOfType');
  }
}

/// Creates a List of the type represented by [type] with no objects
List createEmptyListOfType(Type type) {
  var mirrorList = reflectType(List, [type]) as ClassMirror;
  return mirrorList
      .newInstance(Symbol('empty'), [], {Symbol('growable'): true}).reflectee;
}

/// Creates instances of the parameters of type [Payload]
///
/// This method could return a list of objects or a list of lists depending of
/// the handler body parameters.
List handlePayloadParam(
    ParameterMirror param, dynamic parameterValue, List<dynamic> parameters) {
  if (param.type.isSubtypeOf(reflectType(List))) {
    var bodyParameter = [];
    if (parameterValue.length > 0) {
      bodyParameter =
          createEmptyListOfType(param.type.typeArguments.single.reflectedType);
      for (var child in parameterValue) {
        addCreatedObjectOfType(param.type.typeArguments.single.reflectedType,
            child, bodyParameter);
      }
      parameters.add(bodyParameter);
    }
  } else {
    addCreatedObjectOfType(
        param.type.reflectedType, parameterValue, parameters);
  }
  return parameters;
}

/// Creates Instances of the parameters that are part of the url params
///
/// this method adds the insntances to the paramters list
void toParamType(
    ParameterMirror param, dynamic parameterValue, List<dynamic> parameters) {
  if (param.type.isSubtypeOf(reflectType(num))) {
    var value = parameterValue;
    if (parameterValue is String) {
      value = int.tryParse(parameterValue) ?? double.tryParse(parameterValue);
    }
    parameters.add(value);
  } else if (param.type.isSubtypeOf(reflectType(bool))) {
    if (parameterValue == 'true' || parameterValue == 'false') {
      parameters.add(parameterValue == 'true');
    } else {
      if (parameterValue is bool) {
        parameters.add(parameterValue);
      } else {
        throw Error();
      }
    }
  } else {
    parameters.add(parameterValue);
  }
}

/// Creates Instances of the parameters that are part of the body
///
List getFunctionParameters(List<ParameterMirror> functionParameters,
    Map<String, dynamic> mapedParameters) {
  var parameters = [];
  for (ParameterMirror param in functionParameters) {
    var parameterKey = MirrorSystem.getName(param.simpleName);
    var parameterValue = mapedParameters[parameterKey];

    if (parameterValue == null &&
        !param.type.isSubtypeOf(reflectType(Form)) &&
        !param.type.isSubtypeOf(reflectType(Payload)) &&
        !param.type.isSubtypeOf(reflectType(Request))) {
      throw PathError('no argument found');
    }
    if (param.type.isSubtypeOf(reflectType(Payload))) {
      handlePayloadParam(
          param, mapedParameters["annotated_payload"], parameters);
    } else if (param.type.isSubtypeOf(reflectType(Form))) {
      handleForm(mapedParameters, param, parameterKey, parameters);
    } else if (param.type.isSubtypeOf(reflectType(Request))) {
      handleRequest(mapedParameters, parameters);
    } else {
      toParamType(param, parameterValue, parameters);
    }
  }
  return parameters;
}

/// adds the shelf [Request] to the param list
List handleRequest(Map<String, dynamic> mapedParameters, List parameters) {
  parameters.add(mapedParameters["shelf_request"]);
  return parameters;
}

/// creates the instance of the [Form] property
List handleForm(Map<String, dynamic> mapedParameters, ParameterMirror param,
    String parameterKey, List parameters) {
  var declarations = reflectClass(param.type.reflectedType).declarations;

  for (var entry in declarations.entries) {
    var key = MirrorSystem.getName(entry.key);
    var value = mapedParameters["annotated_form"][key];

    try {
      var mirror = entry.value as VariableMirror;
      if (value != null) {
        if (mirror.type.isSubtypeOf(reflectType(bool))) {
          if (value == 'true' || value == 'false') {
            mapedParameters["annotated_form"][key] = value == 'true';
          } else {
            throw Error();
          }
        } else if (mirror.type.isSubtypeOf(reflectType(num))) {
          mapedParameters["annotated_form"][key] =
              int.tryParse(value) ?? double.tryParse(value) ?? value;
        }
      } else {
        if (mirror.type.isSubtypeOf(reflectType(File))) {
          mapedParameters["annotated_form"][key] =
              mapedParameters["annotated_form"]["annotated_file"];
        }
      }
    } catch (e) {
      continue;
    }
  }
  mapedParameters[parameterKey] = mapedParameters["annotated_form"];
  mapedParameters.remove("annotated_form");
  return handlePayloadParam(param, mapedParameters[parameterKey], parameters);
}

/// takes the multiform request and extracts the properties and values into a map
Future<Map<String, dynamic>> handleMultiPart(Multipart part) async {
  final headers = part.headers;
  var properties = <String, dynamic>{};
  var contentDispositions = headers["content-disposition"]
      ?.split(';')
      .map((e) => e.replaceAll('"', "").split("="))
      .skip(1);
  if (headers["content-type"] != null) {
    var file = <String, dynamic>{};
    Uint8List data = await part.readBytes();
    file['data'] = data;
    for (var content in contentDispositions!) {
      file[content[0].trim()] = content[1].trim();
    }
    properties['annotated_file'] = file;
  } else {
    for (var content in contentDispositions!) {
      try {
        properties[content[1]] = await part.readString();
      } catch (e) {
        print('bad request');
        throw ParameterError('handleMultiPart');
      }
    }
  }
  return properties;
}

/// Extracts the body from the requests and adds it to pathParams
Future<Map<String, dynamic>> decodeBody(request, pathParameters) async {
  try {
    var bodyPayload = await request.readAsString();
    var body = json.decode(bodyPayload);
    return {...pathParameters, 'annotated_payload': body};
  } catch (e) {
    print(e);
    throw ParameterError('decodeBody');
  }
}

/// takes the response object and creates a shelf [Response]
Response handleResponse(dynamic response) {
  if (response is RestResponse) {
    return Response(response.code,
        body: json.encode(response.messaje),
        headers: {"content-type": response.contentType});
  } else if (response is Response) {
    return response;
  } else if (response is List) {
    var responseList = [];
    for (var object in response) {
      if (object is Payload) {
        responseList.add(object.toJson());
      } else {
        responseList.add(object);
      }
    }
    return Response(200,
        body: json.encode(responseList), headers: {"content-type": "application/json"});
  }
  return Response(200,
      body: json.encode(response.toJson()),
      headers: {"content-type": "application/json"});
}

bool isAnnotatedShelfMethod(element) {
  return isGet(element) ||
      isDelete(element) ||
      isPatch(element) ||
      isPost(element) ||
      isPut(element);
}

bool isPost(element) {
  return element.reflectee is POST;
}

bool isPatch(element) {
  return element.reflectee is PATCH;
}

bool isPut(element) {
  return element.reflectee is PUT;
}

bool isDelete(element) {
  return element.reflectee is DELETE;
}

bool isGet(element) {
  return element.reflectee is GET;
}
