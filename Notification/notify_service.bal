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
                //Get email and location from the json payload.
                string email= <string>jsonRequest.Email;
                string location= <string>jsonRequest.Location;

                //Send the notification to the provided email.
                boolean status = notify(location, email);

                //Send the response.
                if (status == true){
                    var s =caller->respond("Successfull");
                } else {
                    var ss= caller->respond("Not Successfull");
                }
            } else {
                log:printError("Error getting request", err = jsonRequest);
            }
    }
}
