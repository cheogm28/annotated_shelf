# <i class="fa-solid fa-shoe-prints"></i> Step by Step
In this section, you will create the endpoints you saw before in this document from scratch, and during the process, you will understand the parts of annotated_shelf.
This server will handle the CRUD of items that are part of a list of to-do items.

## Folders structure
This folder structure is the one you will use in this project. Using this structure, you can separate responsibilities in our services and helps the order in our application.

```{code}
🗂 bin
  ├ 🗂 Adaptors
  ├ 🗂 Models
  ├ 🗂 Resources
  ├ 🗂 Services
 └ 📄 server.dart
📄 pubspec.yaml
🗂 test
```

- **Adaptors:** This folder contains the annotated_shelf REST controllers definitions

- **Models:** Defines all your domain models.

- **Resources:**  Here is the connection with the database and APIs, a good practice here is to use the methods to execute queries and return mapped objects.

- **Services:**  Here is where your business logic goes. For instance: filtering data from resources or executing another resource call.

- **test:** it is where your unit test should be.

- **server:** This is your Main, where you mount the annotated adaptors.

## Creating the base

Under the Adaptors folder, create a file item_adaptor.dart and add a class ItemAdaptor with some handlers. 

```{note}
A good piece of advice is to name your handlers as the HTTP verbs they represent.
````
```{code}
import '../Models/item.dart';
import '../Services/Item_service.dart';

class ItemsAdaptor {
  ItemService itemService = ItemService();
  ItemsAdaptor();

  List<Item> getAllItems() {
    //This returns all the items
    return itemService.retrieveAllItems();
  }

  Item getItemById(int id) {
    // returns an Item by name
    return itemService.retrieveItemById(id);
  }

  Item putItem(Item item, int id) {
    //This takes an Item and updates the id
    return itemService.updateItem(item, id);
  }

  int postNewItem(Item item) {
    // adds an Item to the list
    return itemService.createItem(item);
  }
}
````

 Then you will create a file inside the Models. In this case, you need a class representing an item in the list. The file will be called item.dart, which looks like this:
```{code}
class Item {
  final int id;
  final String? name;
  Item(this.id, this.name);
}
```

 Next, you need to create the service under the Services folder. It will manage the data executing the business logic over it.
```{code}
import '../Models/item.dart';
import '../Repositories/data.dart';

class ItemService {
  List<Item> retrieveAllItems() {
    //This returns all the items
    print("ItemService.retrieveAllItems");
    return DATA;
  }

  Item retrieveItemById(int id) {
    // returns an Item by name
    print('ItemService.retrieveItemById');
    return Item(0, '');
  }

  Item updateItem(Item item, int id) {
    //This takes an Item and updates the id
    print("ItemService.updateItem");
    return Item(0, '');
  }

  int createItem(Item item) {
    // adds an Item to the list
    print('ItemService.createItem');
    return 0;
  }
}
```
In this case, our data source will be a JSON array of the data.dart file inside the Resources folder. The data is like this:
```{code}
import '../Models/item.dart';

final DATA = [Item('item 1', 1), Item('item 2', 2), Item('item 3', 3)];

```
 Now the main file. Here we are going to execute a service to see if everything works.

```{code}
import 'Adaptors/items_adaptor.dart';
import 'Models/item.dart';

void main(List<String> args) async {
  final adaptor = ItemsAdaptor();
  adaptor.getAllItems();
  adaptor.getItemById(1);
  adaptor.postNewItem(Item(4, ''));
}
```

Ok, now it is time to upgrade this app with annoteted_shelf 🎉. To do it, you add the dependencies by adding the lines on the pubspec.yaml file like this ( please check the readme to see the correct version):
```{code}
  shelf: ^1.4.0
  annotated_shelf: ^0.1.0
```
Then we execute the command pub get to download the packages in our locally. 
```{code}
 dart pub get
```

## @ RestAPI
After the installation, You can use the libraries inside the project. Starting with the adaptors folder, we can modify it to indicate it will group some URLs (these URLs are named endpoints) by adding annotations. The first annotation we are going to use is the RestAPI. The adaptor must be placed at the beginning of a class. The parameter of this annotation is the base URL indicating all the handlers created under this class start with that String and that String must start with "/". In our example, the base URL is going to be "/v1/items"
```{tip} 
Advise: Group endpoints that handle the same object or have the same purpose under the same REST API class
```
```{hint}
Common error: notice we do not add / at the end of the base URL. If you do it here, you must remove it at the beginning of each endpoint. 
```
```{code}
@RestAPI(baseUrl: '/v1/items')
class ItemsAdaptor {.....}
```

## @ Main
Adding an adaptor is as easy as calling a function and passing your adaptor as a parameter.
```{code}
Future<void> main(List<String> args) async {
  var router = Cascade();

  router = await mount(ItemsAdaptor(), router);

  var server = await io.serve(handler, _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');
}
```

## @ Handler function
Now that we have the base annotation in place. Let's create a handler function. We call a handler to that function that adds the business logic to our endpoints. To upgrade from a method to an endpoint, you need ( yes, you guessed it ) an annotation that tells which HTTP method you want the handler function to respond to. The library supports DELETE, GET, PATCH, POST, and PUT. For instance, if we take the function getAllItems and make it a GET just add @Get before declaring the method.

```{code}
@Get()
List<Item> getAllItems(){....}
```

All the annotations accept a parameter URL allowing you to add the specific path to this endpoint. If you do not add it, the URL of the endpoint is going to have only the base URL of the RestAPI.

```{code}
[CURL of GET]
```

## @ Path Parameters
 You may wonder. But what if I have a dynamic URL? To handle a path parameter, let's say to get a specific The answer is simple, You need to add a variable path to the endpoint by using the symbols "<>"  inside the URL property with the name of the variable inside of it then create a parameter with the type you need it to be and the same name you use in the URL, for instance, to get an Item by its id.
```{code}
@GET(url: '/<id>')
  Item getItemById(int id) {....}
```
As you can see, the id is a variable path, and the handler method getItemById receives it as a parameter. Notice here the param is a primitive type, and we do not need to do anything else to get the value. 
To execute it you will need to call it like this:

```{code}
[CURL example]
```

## @ Query parameter and the Request object
 But what if we have a parameter that is not a path parameter but a query string? 
To enable query parameters, add the query when you request it and then use the Shelf object Request. Accessing the Request object is as easy as adding a parameter of this type to your handler. Annotated_shelf does the rest. Once you have it, access the query properties as you need. 
```{code}
@GET(url: '/<id>')
  Response getItemById(int id, Request request) {
    queryParams = request.url.queryParameters;
    .....
}
```
## @ Request Body
 Some endpoints need to be able to manage more complex data as a parameter; For instance, the update handler needs to deal with a parameter of a complex type Item. 
In those cases, we have some classes that are added as flags in our code to indicate the library that we need them to be pars from the request to an object and then add the mapped class type as the type of one of our parameters in the handler method. 

### Payload
 This class represents an object sent to our service as a JSON object. Meaning it forces our object to implement the JSON methods tojson, as a reminder to implement the toJson and fromJson methods.

```{code}
import 'package:annotated_shelf/annotated_shelf.dart';

class Item extends Payload {
  final int id;
  final String? name;
  Item(this.id, this.name);

  @override
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json["id"], json["name"]);
  }

  @override
  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
```

 Next, you can annotate your handler to enable it as a route of your adaptor. You can add one parameter as a path parameter and another as a payload.

```{code}
 @PUT(url: '/<id>')
  Item putItem(Item item, int id) {....}
```
There is no need to access the request object, take the body as JSON, parse the properties, and add it to a shelf instance. In other words: extend, annotate, and use. 
```{note}
Note: if you are working with Date please remember to parse it from the JSON with 
 ```{code} 
 DateTime.parse(json["yourDate"])
 ```

### Form / multipart
 The kind of body in a request that usually comes when you send a form is different from JSON. The multipart body has a definition of each of the fields and their values with a delimiter expression. 

```{code}
curl --location 'localhost:8080/items' \
--form 'name="NEW_IMAGE_FROM_POSTMAN"' \
--form 'number="28"' \
```
Annotated_shelf got your back cover with this kind of request. In the same way, you did with the Payload parameters. Add a class in the Models folder, map it, and extend the Form class.
```{code} 
import 'package:annotated_shelf/annotated_shelf.dart';

class ItemForm extends Form {
  final int id;
  final String? name;

  ItemForm(this.id, this.name);

  @override
  factory ItemForm.fromJson(Map<String, dynamic> json) {
    return ItemForm(json["id"], json["name"]);
  }

  @override
  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
``` 
In your adaptor add a parameter of the type of your mapped form.
```{code} 
@POST(url: '/')
  int postNewItem(ItemForm form) {
    var item = Item.fromJson(form.toJson()); // if you need to create an object from a form.
     .....
   }
```

```{important}  
Note: you can manage images or files by adding a property of type File from annotented_shelf and sending the file in a form request. The File class looks like this:
```{code} 
  class File {
    String name;
    Uint8List data;
    String filename;
  }

THe request: 
curl --location 'localhost:8080/to-do/list/upload' \
--form 'image=@"/root/to/your/image.png"'
```

One good thing to point out here is that the values of the fields on the body and the mapping class must match.

## @ Responses
 When you have a Server, it is common, that you need to return something, you can return an object that is a subtype of the class Payload, and annotated_shelf will handle the creation of the response object and creates a JSON that represents the object.

```{code} 
@PUT(url: '/<id>')
  Item putItem(Item item, int id) {
    //This takes an Item and updates the id
    return itemService.updateItem(item, id); // this returns an Item
  }
```
If you have a list and want to return that collection, just adding the response type and the list of subtypes of Payload is what you need. 
```{code} 
@GET()
  List<Item> getAllItems() {
    //This returns all the items
    return itemService.retrieveAllItems();
  }
```
```{note} 
 Note: Our first example returns a list, and annotated_shelf is so easy to use that you do not even notice it. 😆
 ```

## @ Custom Response
Sometimes you will need your service to respond to something different than 200. In those cases, you can use the Response object from annotated_shelf and return it as the handler response. The Response object accepts an HTTP code, the message, and the content type.
```{code} 
  @POST(url: '/')
  RestResponse postNewItem(ItemForm form) {
    var item = Item.fromJson(form.toJson());
    return RestResponse( 201, {"id": itemService.createItem(item)}, "application/json" );
  }
```
The handler returns an HTTP 201 response with a JSON body.
```{code} 
{
"id": 0
}
```

## @ Error Responses
  The error response of an endpoint in annotated_shelf is easy using one of the errors built in the library.
You can do it in any part of the code. It means you do not need to handle a not found from your Resources until your Adaptor class. Just by throwing the error annotated_shelf is capable of understanding that the error is an HTTP error message and transforming it.
```{code} 
  BadRequestError
  ForbiddenError
  InternalServerError
  MethodNotAllowedError
  NotAcceptableError
  NotFoundError
  ParameterError
  PathError
  ServiceUnavailableError
  UnauthorizedError
```
 Continuing with the example, add to your service a not found error, and add a throw in any part of the server where you add the logic that should respond as a not found. In this specific case, add it in the file item_service.dart.
```{code} 
Item retrieveItemById(int id) {
    // returns an Item by name
    print('ItemService.retrieveItemById');
    if (id < 0) {
      throw NotFoundError('Item with id $id is not found');
    }
    return Item(0, '');
  }
```

If you need to create an Error,  you can create a class that extends the BaseError class and then add a default error code and a message. If you want to return an error code 418 with the message "I'm a teapot". You need to add this code.
```{code} 
import 'package:annotated_shelf/annotated_shelf.dart';
import 'package:shelf/src/response.dart';

class TeaPodError extends BaseError {
  TeaPodError({message = "418 I'm a teapot"}) : super(message);

  @override
  Response getResponse() {
    return Response(418, body: message);
  }
}
```
```{note} 
You can check status code here <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418"> https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418 </a>
```

## @ MiddleWares
 One option that makes Shelf attractive is to add middleware made by the community, and annotated shelf won't block that. To add a middle, you need to add it as you usually do with the Shelf method. 
```{code} 
Future<void> main(List<String> args) async {
  var router = Cascade();

  router = await mount(ItemsAdaptor(), router);

  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router.handler);

  var server = await io.serve(handler, _hostname, _port);
  print('Serving at http://${server.address.host}:${server.port}');
}
```

In this example, you are adding the logRequests. 

With this, you have the base knowledge to create a service using only the Dart language. annoteted_shelf team Hopes one day you have the opportunity to use it,  and it can be part of that big idea you are creating.
And remember, if you like the library do not hesitate to contribute by creating a pull request. 
