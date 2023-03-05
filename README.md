# Annotated Shelf

Annotated Shelf is a powerful Dart library based on dart shelf for generating REST APIs using annotations all this without generating extra files. With a simple and intuitive interface, you can easily build APIs that are fast, efficient, and easy to use. 

## Features

- Create REST API services using annotations
- Use the @RestAPI annotation to specify the root path for the API
- Use the following annotations for endpoint handlers:
    - @DELETE
    - @GET
    - @PATCH
    - @POST
    - @PUT
- Path parameters can be added using "< >" around the parameter name
- Handlers can accept a request body by adding a parameter that extends the Payload class
- Form data can be accepted by adding a parameter that extends the Form class
- File uploads can be handled by adding a parameter that extends the File class
- Based on the shelf package

## How to Install

To use this package, you will need to have [Dart](https://dart.dev/get-dart) installed on your system.

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  annotated_shelf: ^1.0.0

```
Then, run the following command to install the package:
```bash
$ dart pub get
```

## Example
The annotated_shelf package allows you to easily create a REST API using the shelf package in Dart. To use this package, you will need to create classes that extend either Payload or Form. The Form class can have file properties for handling file uploads. These classes will also need to have json handler functions.
The annotations are set above the handler functions and have the URL path as a parameter. Each handler must be a class with the @RestAPI annotation above that receives the root part of the path, which is used to complete the URL. The endpoints can have the following annotations: @DELETE, @GET, @PATCH, @POST, and @PUT.

Here is an example of how to create a REST API using the annotated_shelf package

```dart
import 'package:annotated_shelf/annotated_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const _hostname = 'localhost';
const _port = 8080;

Future<void> main(List<String> args) async {
  var router = Cascade();

  router = await mount(TestAdaptor(), router);

  var server = await io.serve(router.handler, _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');
}

@JsonSerializable()
class TestForm extends Form {
  String name;
  int number;
  File image;
  bool boolean;

  TestForm(this.name, this.number, this.image, this.boolean);

  factory TestForm.fromJson(Map<String, dynamic> json) =>
      _$TestFormFromJson(json);
  Map<String, dynamic> toJson() => _$TestFormToJson(this);
}

@JsonSerializable()
class User extends Payload {
  final String? name;
  final String? email;
  final String? password;
  final bool? hasImage;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.hasImage});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@RestAPI(baseUrl: 'api/test/<name>')
class TestAdaptor {
  @POST(url: '/payload')
  Future<RestResponse> payload(String name, User user, Request request) async {
    print('from post: ${name}');
    print(user);
    print(request);
    return new RestResponse(
        201,
        new User(
            name: 'name', email: 'email', password: 'password', hasImage: true),
        "application/json");
  }

  @POST(url: '/upload')
  Future<RestResponse> upload(String name, TestForm form) async {
    print('from post: ${name}');
    print(form);
    return new RestResponse(201, {"msj": 'ok'}, "application/json");
  }
}
```
In this example, we have created two classes: User and TestForm. These classes extend Payload and Form, respectively. We have also defined json handler functions for both of these classes.

We then create a TestAdaptor class and annotate it with @RestAPI. We specify the base URL for our API in this annotation. We can then define functions for handling different REST requests using the @POST annotation. In this example, we have defined two functions: payload and upload. The payload function takes a User object as its second parameter and the upload function takes a TestForm object as its second parameter.

To run the API, we mount the TestAdaptor class on a Cascade object and serve it using the shelf_io package.

You can modify this example to suit your needs by creating your own classes that extend Payload or Form and defining your own REST request handling functions using

## Documentation

The API reference documentation for `annotated_shelf` can be found [here](https://pub.dev/documentation/annotated_shelf/latest/annotated_shelf/annotated_shelf-library.html).

## Support

If you need help using `annotated_shelf`, please reach out to us on [GitHub Issues](https://github.com/<your-username>/<your-repository>/issues).

## Contributing

We welcome contributions to `annotated_shelf`! Please see our [contribution guide](https://github.com/<your-username>/<your-repository>/blob/main/CONTRIBUTING.md) for more information.

## License

`annotated_shelf` is distributed under the [MIT License](https://github.com/<your-username>/<your-repository>/blob/main/LICENSE).
