import ballerina/io;
import ballerina/http;
import ballerina/log;

function getDistance(string origin, string destination1){
    http:Client directionClient = new("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+origin+"&destinations="+destination1+"&key="+apiKey);
    var resp = directionClient->get("&user=sathya+piraveena");

    if (resp is http:Response) {

        var payload = resp.getJsonPayload();
        if (payload is json) {
            io:println(payload);
            //log:printInfo(payload.toString());

            string response = payload.status.toString();
            if (response == "OK") {
                selectCandidates(payload);

            } else {
                //log:printError(<string> payload.toString().detail().message);
            }

        } else {

            //log:printError(<string> payload.detail().message);
        }
    } else {

        log:printError(<string> resp.detail().message);
    }
}


