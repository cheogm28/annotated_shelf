# <i class="fa-solid fa-at"></i> Annotations
 When working with Annotated Shelf, it is essential to understand the concept of annotations 
and their role in the framework. Annotations have been used in programming languages for a long time, and they are common in other backend libraries and frameworks
Annotations provide metadata to classes or functions that tell the execution context what it needs to do with them. For Annotated Shelf, annotations inform the Dart application to handle the annotated method as the handler of the corresponding HTTP verb.

 To use annotations in Annotated Shelf, add the **"@"** symbol, followed by the annotation's 
name or constructor. For example, if you want to mark a function as deprecated, you would use the **"@Deprecated"** annotation and specify the reason in the annotation's parameters.\
By leveraging annotations in Annotated Shelf, developers can easily add metadata to their code and create efficient, flexible, and robust REST APIs.

```{code}
@RestAPI(baseUrl: '')
class ItemsAdaptor {
  @GET()
  List<Item> getAllItems() {...}
}
```

## @ Motivation
 Annotations are a powerful tool in software development that allows developers to add metadata
and behavior to classes and functions without additional code. One of the primary motivations for using annotations is to improve code organization and readability. By using annotations, developers can indicate the purpose and functionality of their code, making it easier for other developers to understand and work with.

 Annotations also help to reduce code duplication by allowing developers to define reusable 
behavior, saving significant development time and effort, as developers no longer need to write the same code again.

 Another benefit of using annotations is that they can make code more maintainable and 
extensible. By encapsulating behavior in annotations, developers can easily add or modify functionality without extensive changes to the underlying codebase.

 
 In summary, annotations can lead to more organized, readable, and maintainable code, reducing 
development time and effort.

 The use of Shelf was logical, not only because the creator is the Dart team but also because 
it is a popular project in the Dart ecosystem. It is good to mention Annotated_shelf has the same purpose as Shelf. "to be a web server middleware for Dart" and the same advantages like expanding it with the use of middleware, the ability to have a request object that describes the requests and other.

 The other reason to build this project is the most important, to give an extra tool to you. 
One tool that helps you develop more with this beautiful language,  together with the community, you can create outstanding projects.