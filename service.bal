import ballerina/http;

configurable string hrEndpoint = ?;


# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function post country(@http:Request req) returns  targetType|ClientError {
        http:Client clientEP = check new (hrEndpoint);
        return check clientEP->forward("",req);
     
    }
}
