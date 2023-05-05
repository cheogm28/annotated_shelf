# <i class="fa-solid fa-wand-magic-sparkles"></i> Features

## @ Multiple HTTP methods and request types:
 Annotated Shelf offers comprehensive support for handling various HTTP methods and request 
types, making it easy for developers to create APIs.\
With Annotated Shelf, you can easily define the HTTP methods such as **GET, POST, PUT, DELETE,** and more. You can also specify the request types that your API supports, such as JSON, HTML, or plain text.

 For example, if you want to create an API endpoint that handles a POST request, you can 
annotate your API method with @Post() and provide the relevant parameters in the request body.

 Similarly, if you want to create an API endpoint that handles a GET request, you can annotate 
your API method with @Get() and provide the necessary parameters in the request URL.

 By providing support for multiple HTTP methods and request types, Annotated Shelf gives you 
the flexibility and control to create APIs that meet your unique requirements. Whether you are building a simple API or a complex one, Annotated Shelf makes it easy to define the methods and request types your endpoints should support.

```{code}
@GET(url: "/<itemName>")
  Item getItemByName(String itemName) {...}

  @PUT(url: "/<itemName>")
  Item updateItem(Item item, String itemName) {...}

  @POST(url: "/")
  Response createNewItem(Item item) {... }
```

## @ Multipart request and File upload: 
Annotated Shelf provides seamless support for handling multipart requests and file uploads, making it easy for developers to build APIs that handle file uploads and other complex data types.

With Annotated Shelf, you can easily create API endpoints that support multipart requests, which allow clients to send multiple data types in a single request. You can also specify which parts are files that need to be uploaded, and Annotated Shelf will automatically handle the file upload process.

To create an API endpoint that accepts an image file upload, you can annotate your API method with @Post() and specify the corresponding Form parameter. Annotated Shelf will handle the file upload process for you, and you can then perform any necessary validation or processing on the uploaded file.

```{code}
 @POST(url: '/upload')
  Future<RestResponse> upload(TestForm form) async {
    print(form);
    return new RestResponse(201, {"msj": 'ok'}, "application/json");
  }
````

## @ Automatic validation of request parameters:
Mapping the request body into a class defined by the developer Annotated_shelf achieves automatic validation, making it easy for developers to ensure that the data sent to their API is valid and in the expected format.\
For example, if you have an API endpoint that accepts a JSON object as a request body, you can define a class that represents the expected structure of the JSON object. Annotated Shelf will automatically map the JSON object to an instance of this class.\
This approach can help to reduce bugs and improve the reliability of your API by catching errors early in the development process. Additionally, it can help to reduce the amount of code.\
```{code}
class Item extends Payload {
  final String? name;
  final int id;
  ....
}

curl --location 'localhost:8080/v1/items/' \
--form 'name="a"' \
--form 'id="a"'

>> 400 parameter error
```

## @ Automatic Error responses based on exceptions:
Annotated Shelf simplifies error handling by providing automatic error responses based on exceptions. With Annotated Shelf, you can define your exception, such as NotFoundError, and annotate them with the appropriate HTTP status codes, such as 404.

When an exception occurs during the execution of an API endpoint, Annotated Shelf automatically generates a response with the corresponding status code and message. For example, if a NotFoundError occurs, Annotated Shelf will generate a 404 response with a message.

By providing automatic error responses based on exceptions, Annotated Shelf makes it easy to handle common API errors and ensures that your API responses are consistent and informative.