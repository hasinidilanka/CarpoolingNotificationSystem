import ballerina/io;
import ballerina/http;
import ballerina/log;

function getDistanceMatrix(string origin, string destination1) returns json{
    http:Client directionClient = new("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="+origin+"&destinations="+destination1+"&key="+apiKey);
    var resp = directionClient->get("");

    if (resp is http:Response) {
        io:println(resp);

        var payload = resp.getJsonPayload();
        if (payload is json) {
            io:println(payload);
            //log:printInfo(payload.toString());

            string response = payload.status.toString();
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

function getSelectedCandidates(string origin, string destination1,Person[] candidates) returns Person[] {

    Person[] selectedCandidates = [];

    var payload = getDistanceMatrix(origin, destination1);
    if (payload == null) {
        return selectedCandidates;
    } else {

        var elements = payload.rows[0].elements;

        int j = 0;

        while (j < elements.length()) {
            var duration = elements[j].duration.value;
            int|error durationValue = int.convert(duration.toString());

            int k = 0;
            if (durationValue is int) {
                if (durationValue < 1000) {
                    selectedCandidates[k] = candidates[j];
                    k += 1;
                    //Person selectedCandidate = candidates[j];
                    io:println("Found a suitable candidate");
                    //message += selectedCandidate.getName()+" - "+selectedCandidate.getLocation()+" - "+selectedCandidate.getTelephone()+"\n";

                }
                j += 1;
            }

        }
        return selectedCandidates;

    }
}

function getDestination(Person[] candidates) returns string{
    string destination ="";
    foreach Person person in candidates {
        destination += person.getLocation()+"|";

    }
    return destination;
}
