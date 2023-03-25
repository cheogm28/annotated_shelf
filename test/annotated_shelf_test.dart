import 'dart:convert';
import 'dart:mirrors';

import 'package:annotated_shelf/annotated_shelf.dart';
import 'package:annotated_shelf/src/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/multipart.dart';
import 'package:test/test.dart';

class TestForm extends Form {
  String name;
  TestForm(this.name) : super();

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  factory TestForm.fromJson(Map<String, dynamic> json) {
    return TestForm(json["name"]);
  }
}

class TestPayload extends Payload {
  String name;
  TestPayload(this.name) : super();

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  factory TestPayload.fromJson(Map<String, dynamic> json) {
    return TestPayload(json["name"]);
  }
}

void main() {
  group('core: ', () {
    late Request requestMuck;

    setUp(() {
      requestMuck = Request('GET', Uri.parse('http://localhost/test'),
          headers: {"content-type": "application/json"},
          body: json.encode({'property': 'value'}));
    });

    test('it can handle form parameters', (() {
      ClosureMirror testFunction =
          reflect((TestForm x) => true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      List response = handleForm(
          {
            "annotated_form": {"name": "test_name"}
          },
          parameters[0],
          "form",
          []);
      expect(response[0], TypeMatcher<TestForm>());
      expect(response[0].name, "test_name");
    }));

    test('it can decode the payload of the request', () async {
      var response = await decodeBody(requestMuck, {'pathParam': 'value'});
      expect(response, {
        'pathParam': 'value',
        'annotated_payload': {'property': 'value'}
      });
    });

    test('it can handle single payload parameters', (() {
      ClosureMirror testFunction =
          reflect((TestPayload x) => true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      List response =
          handlePayloadParam(parameters[0], {"name": "test_name"}, []);
      expect(response[0], TypeMatcher<TestPayload>());
      expect(response[0].name, "test_name");
    }));

    test('it can handle a payload list parameters', (() {
      ClosureMirror testFunction =
          reflect((List<TestPayload> x) => true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      List response = handlePayloadParam(parameters[0], [
        {"name": "test_name"},
        {"name": "test_name2"}
      ], []);
      expect(response[0], TypeMatcher<List<TestPayload>>());
      expect(response[0][0].name, "test_name");
      expect(response[0][1].name, "test_name2");
    }));

    test('it can handle basic parameters', (() {
      ClosureMirror testFunction = reflect((
        int v,
        bool w,
        int x,
        double y,
        bool z,
      ) =>
          true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      var values = ["5", "true", 1, 2.3, true];
      List response = [];
      for (var i = 0; i < parameters.length; i++) {
        toParamType(parameters[i], values[i], response);
      }

      expect(response[0], TypeMatcher<int>());
      expect(response[1], TypeMatcher<bool>());
      expect(response[2], TypeMatcher<int>());
      expect(response[3], TypeMatcher<double>());
      expect(response[4], TypeMatcher<bool>());
    }));

    test('it can add Request Parameter', (() {
      List response = handleRequest({"shelf_request": requestMuck}, []);
      expect(response[0], TypeMatcher<Request>());
      expect(response[0], requestMuck);
    }));

    test('it can map path Parameters', (() {
      // testing url path /test/path/<param>
      var mapParams = getPathParamsMap(
          ["test", "path", "<paramter>'"], ["test", "path", "parameterValue"]);
      expect(mapParams.entries.length, greaterThan(0));
      expect(mapParams['paramter'], "parameterValue");
    }));

    test(
        'it can check if the url with params and the requeste url are the same',
        (() {
      // testing url path /test/path/<param>
      var response = isSameLink(
          ["test", "path", "<paramter>'"], ["test", "path", "parameterValue"]);
      expect(response, true);
    }));

    test(
        'it can check if an url and a function have the same amount of parameters',
        (() {
      // testing url path /test/path/<param>
      ClosureMirror testFunction =
          reflect((String param) => true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      var response = hasSameParams("test/path/<param>", parameters);
      expect(response, true);
    }));

    test('it can create an empty list of "Type"', (() {
      // testing url path /test/path/<param>
      var response =
          createEmptyListOfType(reflectType(TestPayload).reflectedType);
      expect(response, TypeMatcher<List<TestPayload>>());
      expect(response.length, equals(0));
    }));

    test('it can map multipart', (() async {
      Request requestF = Request('POST', Uri.parse('http://localhost/test'),
          body:
              '--end\r\nContent-Disposition: form-data; name="input_name"\r\n\r\nform_name_value\r\n--end\r\nContent-Disposition: form-data; name="test_image_name"; filename="test_file_name.png"\r\nContent-Type: image/png\r\n\r\n11, 20, 29, 08, 28, 02, 2, 0, 0, 0, 6\r\n--end--\r\n',
          headers: {'Content-Type': 'multipart/form-data; boundary=end'});

      var response = <String, dynamic>{};
      await for (Multipart part in requestF.parts.asBroadcastStream()) {
        var data = await handleMultiPart(part);
        response.addAll(data);
      }

      expect(response['annotated_file'], TypeMatcher<Map>());
      expect(response['annotated_file']['name'], 'test_image_name');
      expect(response['annotated_file']['filename'], 'test_file_name.png');
      expect(response['input_name'], 'form_name_value');
    }));

    test('it can map a form to an object', (() {
      ClosureMirror testFunction =
          reflect((TestForm x) => true) as ClosureMirror;
      List<ParameterMirror> parameters = testFunction.function.parameters;
      List response = handleForm(
          {
            "annotated_form": {"name": "test_name"}
          },
          parameters[0],
          "form",
          []);
      expect(response[0], TypeMatcher<TestForm>());
      expect(response[0].name, "test_name");
    }));

    test('it can response an array of objects', (() async {
      Response response = handleResponse(
          [TestPayload('hola'), TestPayload('hola'), TestPayload('hola')]);
      expect(response, TypeMatcher<Response>());
      expect(response.statusCode, 200);
      expect(response.headers['content-type'], 'application/json');
      expect(int.parse(response.headers['content-length'] ?? '0'), 3);
    }));
    test('it can response an objects', (() async {
      Response response = handleResponse(TestPayload('hola'));
      expect(response, TypeMatcher<Response>());
      expect(response.statusCode, 200);
      expect(response.headers['content-type'], 'application/json');
      print(response..toString());
    }));
  });
}
