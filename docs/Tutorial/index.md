# <i class="fa-solid fa-bolt"></i> Quick Tutorial

In this section, you will have the opportunity to create your first service using the annotated_shelf library and learn the basic structure of the library. You will take the code below, divide it and explain what each of the parts does.
The entire example looks like this
[README Example]


## How to Install it
To run the example code, you need to install Dart first. You need to execute different commands depending on the OS. Here are the basic installation commands:  

### <i class="fa-brands fa-apple"></i> On mac 
 Install Homebrew, and then run the following commands:
 ```{code}
 brew tap dart-lang/dart
 brew install dart
 brew info dart 
```

### <i class="fa-brands fa-linux"></i> On Linux 
 Install apt-get and Debian package manager
 ```{code}
sudo apt-get update
sudo apt-get install dart
export PATH="$PATH:/usr/lib/dart/bin"
echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile
```

### <i class="fa-brands fa-windows"></i> On Windows
 Install a Chocolatey and run it as an admin
 ```{code}
choco install dart-sdk
choco upgrade dart-sdk
```

 You can find more information about how to install Dar here 
<a href="https://dart.dev/get-dart"> https://dart.dev/get-dart </a>

### @ Installing the library
After the dart installation, you can install annotated_shelf by executing the command dart pub add annotated_shelf or adding it manually to your pubspect.yml file under the dependencies section.
```{code}
dependencies:
  annotated_shelf: ^0.0.8
```
```{code}
dart pub add annotated_shelf
```
## How to run it
  Using the console, go to your project location and execute the dart run command using the server file as a parameter.
```{code}
dart bin/server.dart
```

It will display the name of the adaptor's annotated_shelf mounts and the URL of the endpoints it mounts in each adaptor.
```{code}
mounting Instance of 'ItemsAdaptor'
adding get /to-do/list
adding get /to-do/list/<itemName>
adding put /to-do/list/<itemName>
adding post /to-do/list/
adding post /to-do/list/upload
```

## Checking the endpoints
Because of the nature of the service, you need to check your endpoints using a tool to execute the requests to your local server, you can use: 

```{code}
curl --location 'localhost:8080/to-do/list'

curl --location 'localhost:8080/to-do/list/item2'

curl --location --request PUT 'localhost:8080/to-do/list/item2' \
--header 'Content-Type: application/json' \
--data '{
    "name":"3"
}'

curl --location 'localhost:8080/to-do/list/' \
--header 'Content-Type: application/json' \
--data '{
    "name":"4"
}'

curl --location 'localhost:8080/to-do/list/upload' \
--form 'number="28"' \
--form 'image=@"path/to/your/image.png"' \
--form 'name="new item"'
```
Or  you can use the Dart code like this:
```{code}
var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('PUT', Uri.parse('localhost:8080/to-do/list/item2'));
request.body = json.encode({
  "name": "3"
});
request.headers.addAll(headers);
// -----
http.StreamedResponse response = await request.send();

var request = http.Request('POST', Uri.parse('localhost:8080/to-do/list/'));
request.body = json.encode({
  "name": "4"
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

//---------
var request = http.Request('PUT', Uri.parse('localhost:8080/to-do/list/item2'));
request.body = json.encode({
  "name": "3"
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

//------------
var request = http.MultipartRequest('POST', Uri.parse('localhost:8080/to-do/list/upload'));
request.fields.addAll({
  'number': '28',
  'name': 'new item'
});
request.files.add(await http.MultipartFile.fromPath('image', '/path/to/your/image.png'));

http.StreamedResponse response = await request.send();
```