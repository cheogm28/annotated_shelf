# <i class="fa-solid fa-code-compare"></i> REST API

A REST (Representational State Transfer) API is a web service that uses HTTP methods to manipulate resources by URLs. REST is an architectural style for building web services based on treating the web as a set of resources, each uniquely identified by a URI (Uniform Resource Identifier).
In a REST API, clients send requests to the server to create, read, update, or delete resources. The server responds with the appropriate HTTP status code and representations in a format such as JSON or XML.
A REST API typically has the following characteristics:

- **Client-server architecture:** The client and server are separate components that communicate over the network.


- **Statelessness:** Each request contains all the information necessary for the server to process it, and the client context is stored on the server between requests.

- **Cacheability:** Responses must be marked as cacheable or non-cacheable to prevent clients from reusing stale or inappropriate data in response to further requests.

- **Layered system:** A client cannot tell whether it is connected directly to the server or an intermediary, such as a load balancer or cache.

- **Uniform interface:** The interface between the client and server should be uniform across all resources, following a set of well-defined constraints.

The URL (Uniform Resource Locator) is a string of characters that locates a resource on the web. Some uses of URLs are: to identify a web page, a file, an image, a video, or any other resource that can be accessed using a web browser or other software that supports the HTTP (Hypertext Transfer Protocol) or other web protocols.
URLs have a standardized format that includes a protocol (such as HTTP or HTTPS).

## @ URL parts:
A URL typically consists of the following parts:
- **Scheme:** The scheme specifies the protocol used to access the resource on the web.

- **Host:** The host is the domain name or IP address where of the location of a resource, for instance, www.annotated_shelf.com.

- **Port:** The port number is used to identify a specific process to which an Internet or other network message is to be delivered. The port number in the URL follows the domain name or IP address, separated by a colon. For example, if a server is on port 5000 instead of the default port 80.
It looks like this: https://www.annotated_shelf.com:5000

- **Path:** The path specifies the location of the resource on the web server. It starts with a slash (/) and can include subdirectories and file names.

- **Query string:** The query string allows sending additional information to the server as key-value pairs. It starts with a question mark (?) and includes one or more parameters separated by ampersands (&). For example, ?param1=value1&param2=value2.

- **Fragment identifier:** The fragment identifier specifies a section, usually an anchor tag, to which the URL refers. It starts with a hash (#),  and it s often in combination with a named anchor tag to provide links to specific parts of a page.

Here's an example URL that includes all of these parts:
```{code}
https://www.annotated_shelf.com:8080/path/to/resource?param1=value1&param2=value2#section1
```
In this example:
- **Scheme:** https
- **Host:** www.annotated_shelf.com
- **Port:** 8080
- **Path:** /path/to/resource 
- **Query string:** ?param1=value1&param2=value2 
- **Fragment identifier:** #section1 

Another concept you need to CRUD is a common concept in REST APIs that stands for Create, Read, Update, and Delete. It represents the basic operations performed on a resource in a RESTful API. 

Here's a brief overview of what each entails:

## @ Create/POST
This operation creates a new resource in the API. It typically involves sending data to the server as a request body, which contains the details of the new item. The server then creates the resource and returns a response with the details of the newly created resource.

## @ Read/GET
 This operation retrieves one or more resources from the API. It typically involves sending a request to the server with a set of query parameters that specify the criteria for the resources to be retrieved. The server then returns a response with the details of the requested resources.

## @ Update/PUT
 This operation modifies an existing resource in the API. It typically involves sending data to the server as a request body, which contains the updated details of the item. The server then updates the resource and returns a response with the updated details.

## @ Delete/DELETE
 This operation removes a resource from the API. It typically involves sending a request to the server with a unique identifier of the item and deleting it. The server then removes the resource and returns a response indicating all is ok.

CRUD operations form the foundation of most RESTful APIs and provide a simple and intuitive way for clients to interact with resources in the API. It's important to note that CRUD operations are not the only types of operations in a RESTful API, but they are a good starting point for building a basic API.