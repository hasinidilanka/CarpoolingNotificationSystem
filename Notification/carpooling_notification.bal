import ballerina/io;
import ballerina/log;

string location ="maharagama";
string url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=maharagama&destinations=kottawa|colombo|&key=AIzaSyATIXv5bZtzJXf_T9ee9IdU1QsKHFtDbXA";
string destination = "";

string[] locationArray = [];
string[] nameArray = [];
string[] telephoneArray = [];
string message = "";


function notify() returns boolean{
    //Retrieve the customer details from spreadsheet.
    var details = getDetailsFromGSheet();
    io:println(details);
    if (details is error) {
        log:printError("Failed to retrieve details from GSheet", err = details);
        return false;
    } else {
        int i = 0;
        boolean isSuccess = false;
        //Iterate through each customer details and send customized email.
        foreach var value in details {

            //Skip the first row as it contains header values.
            if (i > 0) {

                string address = sanitizeAndReturnUntainted(value[0]);
                locationArray[i-1] = address;

                string name = sanitizeAndReturnUntainted(value[1]);
                nameArray[i-1] = name;

                string telephone = sanitizeAndReturnUntainted(value[2]);
                telephoneArray[i-1] = telephone;

                destination += address +"|";

            }
            i += 1;
        }

        getDistance(location, destination);
        isSuccess = sendEmail( "hasini.14@cse.mrt.ac.lk",  message);
        return isSuccess;
    }

}

function sanitizeAndReturnUntainted(string input) returns @untainted string {
    string regEx = "[^a-zA-Z]";
    return input.replace(regEx, "");
}

function selectCandidates(json payload) {

    var elements = payload.rows[0].elements;

    int j = 0;

    while (j<elements.length()) {
        var duration = elements[j].duration.value;
        int|error durationValue = int.convert(duration.toString());

        if (durationValue is int) {
            if (durationValue<1000){
                io:println("Found a suitable candidate");
                message += nameArray[j]+" - "+locationArray[j]+" - "+telephoneArray[j]+"\n";
            }
            j += 1;
            io:println(duration);
        }

    }

}

public function main() {

    log:printDebug("Sending details about carpooling");
    boolean result = notify();
    if (result) {
        log:printDebug("Sending details successfully completed!");
    } else {
        log:printDebug("Sending details failed!");
    }

}