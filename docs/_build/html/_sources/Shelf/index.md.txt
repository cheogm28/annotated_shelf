# <i class="fa-solid fa-book"></i> Shelf

Dart Shelf is a powerful and flexible web server library for Dart that provides a simple, low-level API for building HTTP servers and web applications. Created by the Dart team, it is a popular choice for building web applications in Dart due to its ease of use and extensibility.
```{code}
class Service {

  Handler get handler {
    final router = Router();

    router.get('/say-hi/<name>', (Request request, String name) {
      return Response.ok('hi $name');
    });


    router.get('/user/<userId|[0-9]+>', (Request request) async {
      await Future.delayed(Duration(milliseconds: 100));
      return Response.ok('_o/');
    });


    router.mount('/api/', Api().router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}
from https://oldmetalmind.medium.com/dart-shelf-backend-with-dart-f068d4f37a7a
````

more information about Shelf: <a href="https://pub.dev/documentation/shelf/latest/">https://pub.dev/documentation/shelf/latest/ </a>

## @ Motivation
The main reasons why this project uses Shelf are:

- **Capable:** Dart Shelf can handle extensive web server needs, from serving static files to building complex APIs.

- **Created by the Dart team:** As an official Dart package, Dart Shelf is developed and maintained by the same team responsible for the Dart language and the Dart SDK.

- **Can be used as standard:** Dart Shelf is widely adopted for building web applications and APIs in Dart. Its popularity ensures that it will continue to be supported and improved.

- **Is not something new:** Dart Shelf has been around for several years and has proven to be a reliable and stable library for web development in Dart.

- **Has Response and Request object:** The library provides the Response and Request objects that make it easy to work with HTTP requests and responses.

- **Reliable:** Dart Shelf has a solid track record of being reliable and performing well in production environments.

- **Extensibility:** Dart Shelf's modular design allows easy extension and customization. You can easily add middleware or create custom handlers to suit specific needs.

- **Easy to integrate:** Designed to be easy, It has a simple API and is compatible with other Dart packages and frameworks.

In summary, Dart Shelf provides a capable, reliable, and extensible foundation for building 
web applications and APIs in Dart language and is a solid choice for creating a library that relies on web server functionality.

## @ Response Object
The Response class in Dart Shelf is an essential part of the framework to handle HTTP responses. It encapsulates the status code, headers, and message body. It provides developers with methods to modify its properties.
Unlike the Request class, the Response class is mutable, meaning you can change the value of the properties. Developers can set the response status code, headers, and message body using methods like write() or writeAll().
The Response class also offers convenience methods that allow developers to create common types of responses. For instance, the json() function creates a JSON response, while the redirect() function creates a redirect response.

Some properties of the Response class include:

- **status code:** represents the HTTP status code of the response.

- **headers:** It is a Map that contains the response headers.

- **body:** A StreamController to write the response body efficiently.

- **Content-Length:** property represents the length of the response body in bytes.
Furthermore, the Response class provides methods to create new Response objects with modified properties. For instance, the change() function creates a new Response object with a different status code, headers, or request body.

Overall, the Response class in Dart Shelf is a powerful tool that simplifies constructing and sending HTTP responses to clients.

## @ Request Object:
The Request class in Dart Shelf represents an HTTP request and provides developers easy access to the details of an incoming HTTP request. It is immutable. However, with change() method can create a new Request object with modified properties.

The properties of the Request class:

- **method:** The HTTP method used in the request (GET, POST, etc.).

- **URL:** The requested URI. It is an instance of the Uri class in Dart.

- **headers:** A Map that contains the request headers.

- **body:**  A Stream that represents the request body. Depending on the Content-Type, it returns a string, bytes, or other formats.

- **Content-Length:** property represents the length of the response body in bytes.

- **protocol Version:** The HTTP version used in the request 

The Request class is a useful abstraction that allows developers to work with HTTP requests straightforwardly and conveniently. With the Request class, developers can easily access specific parts of the request, such as query parameters or request headers, and create new Request objects with modified properties using the change() method.