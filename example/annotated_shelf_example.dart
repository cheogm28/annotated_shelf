import 'package:annotated_shelf/annotated_shelf.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const _hostname = 'localhost';
const _port = 8080;
var itemsList = [Item("item1"), Item("item2")];

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

class TestForm extends Form {
  String name;
  int number;
  File image;

  TestForm(this.name, this.number, this.image);

  @override
  factory TestForm.fromJson(Map<String, dynamic> json) {
    return TestForm(
      json['name'] as String,
      json['number'] as int,
      File.fromJson(json['image'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'number': number,
        'image': image,
      };
}

@RestAPI(baseUrl: '/to-do/list')
class ItemsAdaptor {
  @GET()
  List<Item> getAllItems(Request request) {
    return itemsList;
  }

  @GET(url: "/<itemName>")
  Item getItemByName(String itemName) {
    var index = itemsList.lastIndexWhere((element) => element.name == itemName);
    if (index >= 0) {
      return itemsList[index];
    } else {
      throw NotFoundError('item not found'); // this creates a 404 response
    }
  }

  @PUT(url: "/<itemName>")
  Item updateItem(Item item, String itemName) {
    var index = itemsList.lastIndexWhere((element) => element.name == itemName);
    if (index >= 0) {
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

  // examplo of uploading a file
  @POST(url: '/upload')
  Future<RestResponse> upload(TestForm form) async {
    print(form);
    return new RestResponse(201, {"msj": 'ok'}, "application/json");
  }
}

Future<void> main(List<String> args) async {
  var router = Cascade();

  router = await mount(ItemsAdaptor(), router);

  var server = await io.serve(router.handler, _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');
}
