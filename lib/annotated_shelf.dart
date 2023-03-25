/// Helps to create the REST API
///
/// This library uses annotation to create a service.
library annotated_shelf;

export './src/annotation/index.dart'
    show DELETE, GET, PATCH, POST, PUT, RestAPI;
export './src/errors/index.dart'
    show
        BaseError,
        BadRequestError,
        ForbiddenError,
        InternalServerError,
        MethodNotAllowedError,
        NotAcceptableError,
        NotFoundError,
        ParameterError,
        PathError,
        ServiceUnavailableError,
        UnauthorizedError;
export './src/models/index.dart' show File, Form, Payload, RestResponse;
export 'src/annotated_shelf.dart' show mount;
