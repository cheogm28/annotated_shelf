# Annotated Shelf

Annotated Shelf is a powerful Dart library for generating REST APIs using annotations. With a simple and intuitive interface, you can easily build APIs that are fast, efficient, and easy to use.

## Features

- Support for multiple HTTP methods and request types
- Automatic validation of request parameters

## Installation

To install Annotated Shelf, add it as a dependency in your `pubspec.yaml` file:

```yml
dependencies:
  annotated_shelf: ^0.0.5
```

Then, run `pub get` to install the package.

## Getting Started

To use Annotated Shelf to create a REST API, import the library and annotate your models and controllers with the following annotations:

```dart
@RestAPI,
@GET,
@POST,
@PUT,
@DELETE,
@PATCH,
```
Annotated Shelf will automatically generate the necessary routes and endpoints based on the annotations you have provided.

## Example
``` dart
import 'package:annotated_shelf/annotated_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const _hostname = 'localhost';
const _port = 8080;
var itemsList = [Item("first item"), Item("second Item")];

class Item extends Payload {
  final String? name;

  Item(this.name);

  @override
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json["name"]);
  }
  @override
  Map<String, dynamic> toJson() => {"name": name};
}

@RestAPI(baseUrl: 'to-do/list')
class ItemsAdaptor {
  @GET()
  List<Item> getAllItems(Request request) {
    return itemsList;
  }

  @GET(url: "/<iteName>")
  Item getItemByName(String name) {
    var index = itemsList.lastIndexWhere((element) => element.name == name);
    if (index > 0) {
      return itemsList[index];
    } else {
      throw NotFoundError('item not found'); // this creates a 404 response
    }
  }

  @PUT(url: "/<iteName>")
  Item updateItem(Item item, String itemName) {
    var index = itemsList.lastIndexWhere((element) => element.name == itemName);
    if (index > 0) {
      itemsList[index] = item;
      return getItemByName(item.name ?? '');
    } else {
      throw NotFoundError('item not found'); // this creates a 404 response
    }
  }

  @POST(url: "/")
  Response createNewItem(Item item) {
    var index =
        itemsList.lastIndexWhere((element) => element.name == item.name);
    if (index == -1) {
      itemsList.add(item);
      return Response(201); // pass a shelf response
    } else {
      throw BadRequestError('item with name in list');
    }
  }
}


Future<void> main(List<String> args) async {
  var router = Cascade();

  router = await mount(ItemsAdaptor(), router);

  var server = await io.serve(router.handler, _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');
}

```
## Contributing

We welcome contributions to Annotation Shelf! If you have an idea for a new feature or have found a bug, please open an issue on GitHub.

## License

Annotation Shelf is released under the BSD-3-Clause. See LICENSE for details.
