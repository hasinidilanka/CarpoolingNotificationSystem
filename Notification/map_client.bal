import ballerina/io;
import ballerina/http;
import ballerina/log;

//Get the distances from origin to destinantions
function getDistanceMatrix(string origin, string destination1) returns json{
    //Call the distance matrix endpoint with origin, destinations and api key.
    http:Client directionClient = new("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+origin+"&destinations="+destination1+"&key="+apiKey);
    var resp = directionClient->get("");

    if (resp is http:Response) {
        io:println(resp);

        var payload = resp.getJsonPayload();
        if (payload is json) {
            string response = payload.status.toString();

            //Check the status
            if (response == "OK") {
                return payload;

            } else {
                //log:printError(<string> payload.toString().detail().message);
            }

        } else {

            //log:printError(<string> payload.detail().message);
        }
    } else {

        log:printError(<string> resp.detail().message);
    }
    return null;
}

//Select the most suitable candidates.
function getSelectedCandidates(string origin, string destination1,Person[] candidates) returns Person[] {

    Person[] selectedCandidates = [];

    var payload = getDistanceMatrix(origin, destination1);
    if (payload == null) {
        return selectedCandidates;
    } else {
        var elements = payload.rows[0].elements;
        int j = 0;

        //Read payload and get the durations from origin to destinations.
        while (j < elements.length()) {
            var duration = elements[j].duration.value;
            int|error durationValue = int.convert(duration.toString());
            int k = 0;
            if (durationValue is int) {

                //Check for destinations less than 1000 seconds.
                if (durationValue < 1000) {
                    selectedCandidates[k] = candidates[j];
                    k += 1;
                    io:println("Found a suitable candidate");
                }
                j += 1;
            }

        }
        return selectedCandidates;
    }
}

//Get the distances from all the candidates
function getDestination(Person[] candidates) returns string{
    string destination ="";
    foreach Person person in candidates {
        destination += person.getLocation()+"|";
    }
    return destination;
}
