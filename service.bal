import ballerina/http;
import ballerina/log;


configurable string hrEndpoint = ?;

  type Flag record {|
    string flag;
    |};
    
# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function post country(http:Request req) returns http:Response|http:ClientError {
        http:Client clientEP = check new (hrEndpoint);
        http:Response|http:ClientError response = check clientEP->forward("/countryFlag",req);
        
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


    resource function get country/[string name]/flag() returns Flag|error? {
        http:Client clientEP = check new (hrEndpoint);
        json isoCode = check clientEP->/CountryISOCode.post({"sCountryName": name});
        log:printInfo("ISODE-"+isoCode.toString()+"-");
        json flag = check clientEP->/CountryFlag.post({"sCountryISOCode": isoCode});
        Flag result= {flag : check flag};
        return result;

     
    }

        resource function get currency/[string code]/flags() returns json[]|error? {
        http:Client clientEP = check new (hrEndpoint);
        json[] countrys = check clientEP->/CountriesUsingCurrency.post({"sISOCurrencyCode": code});

        json[] result= [];
        foreach var country in countrys {
            string isoCode = check country.sISOCode;
            string countryName = check country.sName;
            json flag = check clientEP->/CountryFlag.post({"sCountryISOCode": isoCode});   
            result.push({flag : flag,
                        country:countryName,
                        countrCode:isoCode});
        }

        return result;

     
    }
}
