# EL Plano REST API v.1
  
## Basis
  
This API is based on [JSON:API specification](https://jsonapi.org/).
  
Clients MUST send all JSON:API data in request documents with the header `Content-Type: application/vnd.api+json` without any media type parameters.
Otherwise, the server will respond with a `415 Unsupported Media Type` status code  
  
  
### HTTP verbs
  
Where possible, API strives to use appropriate HTTP verbs for each action.
  
| Verb      | Description
| ----------|-------------
| `GET`     | Used for retrieving resources.
| `POST`    | Used for creating resources.
| `PATCH`   | Used for updating resources with partial JSON data. For instance, an Issue resource has title and body attributes. A PATCH request may accept one or more of the attributes to update the resource. PATCH is a relatively new and uncommon HTTP verb, so resource endpoints also accept POST requests.
| `PUT`     | Used for replacing resources or collections. For PUT requests with no body attribute, be sure to set the Content-Length header to zero.
| `DELETE`  | Used for deleting resources.
  
### HTTP status codes
  
The API is designed to return different status codes according to context and action. 
This way, if a request results in an error, the caller is able to get insight into what went wrong.

The following table gives an overview of how the API functions generally behave.
  
| Request type      | Description
|-------------------|---------------------------------------------------------------------------------------------
| `GET`             | Access one or more resources and return the result as JSON.
| `POST`            | Return `201 Created` if the resource is successfully created and return the newly created resource as JSON.
| `GET` / `PUT`     | Return `200 OK` if the resource is accessed or modified successfully. The (modified) result is returned as JSON.
| `DELETE`          | Returns `204 No Content` if the resource was deleted successfully.

&nbsp;

The following table shows the possible return codes for API requests.
  
| Return values             | Description
|---------------------------|-------------------------------------------------------------------------------------------
| `200 OK`                  | The `GET`, `PUT` or `DELETE` request was successful, the resource(s) itself is returned as JSON.
| `204 No Content`          | The server has successfully fulfilled the request and that there is no additional content to send in the response payload body.
| `201 Created`             | The `POST` request was successful and the resource is returned as JSON.
| `304 Not Modified`        | Indicates that the resource has not been modified since the last request.
| `400 Bad Request`         | A required attribute of the API request is missing, e.g., the title of an issue is not given.
| `401 Unauthorized`        | The user is not authenticated, a valid user token is necessary.
| `403 Forbidden`           | The request is not allowed, e.g., the user is not allowed to delete a project.
| `404 Not Found`           | A resource could not be accessed, e.g., an ID for a resource could not be found.
| `415 Unsupported type`    | Indicates that the request has an unsupported type specified in `Content-Type` header.
| `422 Unprocessable`       | The entity could not be processed.
| `500 Server Error`        | While handling the request something went wrong server-side.

### Errors
 
A server might process multiple attributes and then return multiple validation problems in a single response.

Error objects provide additional information about problems encountered while performing an operation. 
Error objects are returned as an array keyed by errors in the top level of a JSON:API document.

An error object have the following members:

- `status` - The HTTP status code applicable to this problem, expressed as a string value.
- `source` - An object containing references to the source of the error, optionally including any of the following members:
    - `pointer` - A JSON Pointer [RFC6901](https://tools.ietf.org/html/rfc6901) to the associated entity in the request document [e.g. "/data" for a primary data object, or "/data/attributes/title" for a specific attribute].
- `detail` - A human-readable explanation specific to this occurrence of the problem.

Response example:

    {
        "errors": [
            {
                "status": 422,
                "source": {
                    "pointer": "/data/attributes/email"
                },
                "detail": "can't be blank"
            },
            {
                "status": 422,
                "source": {
                    "pointer": "/data/attributes/password"
                },
                "detail": "can't be blank"
            },
            {
                "status": 422,
                "source": {
                    "pointer": "/data/attributes/password_confirmation"
                },
                "detail": "doesn't match Password"
            },
            {
                "status": 422,
                "source": {
                    "pointer": "/data/attributes/username"
                },
                "detail": "can't be blank"
            },
            {
                "status": 422,
                "source": {
                    "pointer": "/data/attributes/email_confirmation"
                },
                "detail": "doesn't match Email"
            }
        ]
    }


### Cross origin resource sharing
The API supports Cross Origin Resource Sharing (CORS) for AJAX requests from any origin. 
You can read the [CORS W3C Recommendation](https://www.w3.org/TR/cors/), or [this intro](https://code.google.com/archive/p/html5security/wikis/CrossOriginRequestSecurity.wiki) from the HTML 5 Security Guide.

Work in progress...
  
## Authentication

API authentication is based on [OAuth 2.0 specification](https://tools.ietf.org/html/rfc6749)
You can use an OAuth2 token to authenticate with the API by passing it in the Authorization header.
  
Example of using the OAuth2 token in a parameter:

    curl --header "Authorization: Bearer OAUTH-TOKEN" http://elplano.example.com/api/v1/user  

&nbsp;

### Examples of access token issuing

#### `POST /oauth/token`
  
curl command, password grant :

    curl -F grant_type=password \
    -F username=user@example.com \
    -F password=password \
    -X POST http://elplano.example.com/oauth/token
    
command output :

    {
       "access_token":"0ddb922452c983a70566e30dce16e2017db335103e35d783874c448862a78168",
       "token_type":"bearer",
       "expires_in":7200,
       "refresh_token":"f2188c4165d912524e04c6496d10f06803cc08ed50271a0b0a73061e3ac1c06c",
    }

curl command, refresh token grant :

    curl -F grant_type=refresh_token \
    -F client_id=9b36d8c0db59eff5038aea7a417d73e69aea75b41aac771816d2ef1b3109cc2f \
    -F client_secret=d6ea27703957b69939b8104ed4524595e210cd2e79af587744a7eb6e58f5b3d2 \
    -F refresh_token=c65b265611713028344a2c285dfdc4e28f9ce2dbc36b9f7e12f626a3d106a304 \
    -X POST http://elplano.example.com/oauth/token

command output :

    {
       "access_token":"ad0b5847cb7d254f1e2ff1910275fe9dcb95345c9d54502d156fe35a37b93e80",
       "token_type":"bearer",
       "expires_in":30,
       "refresh_token":"cc38f78a5b8abe8ee81cdf25b1ca74c3fa10c3da2309de5ac37fde00cbcf2815",
    }

failed response (invalid username, password, or code)

command output :
    
    {
       "error":"invalid_grant",
       "error_description":"The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.",
    }

&nbsp;

#### `POST /oauth/revoke`

Post here with client credentials(in basic auth or in params client_id and client_secret) to revoke an access/refresh token. 
This corresponds to the token endpoint, using the OAuth 2.0 Token Revocation RFC (RFC 7009).

curl command, token revoke with client credentials in params

    curl -F client_id=9b36d8c0db59eff5038aea7a417d73e69aea75b41aac771816d2ef1b3109cc2f \
    -F client_secret=d6ea27703957b69939b8104ed4524595e210cd2e79af587744a7eb6e58f5b3d2 \
    -F token=dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781 \
    -X POST http://elplano.example.com/oauth/revoke


command output

    {}

curl command, token revoke with client credentials in basic auth

    curl -F token=dbaf9757982a9e738f05d249b7b5b4a266b3a139049317c4909f2f263572c781 \
    -u '9b36d8c0db59eff5038aea7a417d73e69aea75b41aac771816d2ef1b3109cc2f:d6ea27703957b69939b8104ed4524595e210cd2e79af587744a7eb6e58f5b3d2' \
    -X POST http://elplano.example.com/oauth/revoke

    
command output :

    {}
