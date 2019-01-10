import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/config;

@http:ServiceConfig { basePath: "/carpooling" }
service hello on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/notify"
    }

    resource function notify(http:Caller caller, http:Request req) {

            var jsonRequest = req.getJsonPayload();

            if (jsonRequest is json) {

                string email;
                string location;
                email= <string>jsonRequest.Email;
                location= <string>jsonRequest.Location;
                io:println(email);
                io:println(location);

                boolean status = notify(location, email);

                if (status == true){
                    var s =caller->respond("Successfull");
                } else {
                    var ss= caller->respond("Not Successfull");
                }

            } else {

                log:printError("Error getting request", err = jsonRequest);

            }

    }
    //}
}
