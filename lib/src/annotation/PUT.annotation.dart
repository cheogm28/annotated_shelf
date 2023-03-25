import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/multipart.dart';

import '../errors/parameter_error.dart';
import '../errors/path.error.dart';
import '../models/enums/http_verbs.dart';
import '../core.dart';

dynamic putHandler(Uri urlUri, Request request, Function putFunction) async {
  if (isSameLink(urlUri.pathSegments, request.url.pathSegments) &&
      request.method.toLowerCase() == HttpVerbs.put.toStr()) {
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
    var response = await putFunction(parameters);
    return response;
  } else {
    throw PathError('');
  }
}

/// Represents the put http verb.
///
/// This is used to annotated a handler method as a put
class PUT {
  final String url;

  const PUT({this.url = ''});

  Future<Cascade> execute(
      Function putFunction, Cascade router, String baseUrl) async {
    var completeUrl = baseUrl + url;
    Uri urlUri = Uri.parse(completeUrl);
    print('adding put $completeUrl');
    return router.add((Request request) async {
      try {
        return await putHandler(urlUri, request, putFunction);
      } on PathError catch (_) {
        return Response.notFound('not found');
      } on ParameterError catch (_) {
        return Response.badRequest(body: 'parameter error');
      }
    });
  }
}
