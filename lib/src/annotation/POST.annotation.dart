import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/multipart.dart';

import '../errors/parameter_error.dart';
import '../errors/path.error.dart';
import '../models/enums/http_verbs.dart';
import '../core.dart';

dynamic postHandler(Uri urlUri, Request request, Function postFunction) async {
  if (request.method.toLowerCase() == HttpVerbs.post.name &&
      isSameLink(urlUri.pathSegments, request.url.pathSegments)) {
    var pathParameters =
        getPathParamsMap(urlUri.pathSegments, request.url.pathSegments);
    Map<String, dynamic> parameters = {
      ...pathParameters,
      'shelf_request': request
    };
    if (request.isMultipart) {
      var form = <String, dynamic>{};
      await for (Multipart part in request.parts.asBroadcastStream()) {
        var data = await handleMultiPart(part);
        form.addAll(data);
      }
      // multiple files
      parameters = {...parameters, 'annotated_form': form};
    } else {
      parameters = await decodeBody(request, parameters);
    }
    try {
      var response = await postFunction(parameters);
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  } else {
    throw PathError('');
  }
}

/// Represents the post  http verb.
///
/// This is used to annotated a handler method as a Post
class POST {
  final String url;

  const POST({this.url = ''});

  Future<Cascade> execute(
      Function postFunction, Cascade router, String baseUrl) async {
    var completeUrl = baseUrl + url;
    Uri urlUri = Uri.parse(completeUrl);
    print('adding post $completeUrl');
    return router.add((Request request) async {
      try {
        return await postHandler(urlUri, request, postFunction);
      } on PathError catch (_) {
        print(_);
        return Response.notFound('not found');
      } on ParameterError catch (_) {
        return Response.badRequest(body: 'parameter error');
      }
    });
  }
}
