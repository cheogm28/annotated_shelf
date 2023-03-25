// descriptions taken from https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
enum HttpVerbs {
// The GET method requests a representation of the specified resource. Requests using GET should only retrieve data.
  get,
// The HEAD method asks for a response identical to a GET request, but without the response body.
  head,
// The POST method submits an entity to the specified resource, often causing a change in state or side effects on the server.
  post,
// The PUT method replaces all current representations of the target resource with the request payload.
  put,
// The DELETE method deletes the specified resource.
  delete,
// The CONNECT method establishes a tunnel to the server identified by the target resource.
  connect,
// The OPTIONS method describes the communication options for the target resource.
  options,
// The TRACE method performs a message loop-back test along the path to the target resource.
  trace,
// The PATCH method applies partial modifications to a resource.
  patch
}

extension ParseToString on HttpVerbs {
  String toStr() {
    return toString().split('.').last;
  }
}
