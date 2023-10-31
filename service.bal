import ballerina/http;
import ballerina/log;


configurable string hrEndpoint = ?;


# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function post country(http:Request req) returns http:Response|http:ClientError {
        http:Client clientEP = check new (hrEndpoint);
        http:Response|http:ClientError response = check clientEP->forward("",req);
        
        if (response is http:Response) {
            return response;
        } else {
            log:printError("Error at h2_h1_passthrough", 'error = response);
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload(response.message());
            return res;
        }
     
    }
}
