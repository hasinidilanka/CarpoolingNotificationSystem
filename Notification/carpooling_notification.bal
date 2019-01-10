import ballerina/io;
import ballerina/log;

string location1 ="maharagama";

function notify() returns boolean{

    Person[] candidates = getAllCandidates();
    string destination = getDestination(candidates);
    Person[] selectedCandidates = getSelectedCandidates(location1, destination, candidates);
    string message = createMessage(selectedCandidates);
    boolean isSuccess = sendEmail( "hasini.14@cse.mrt.ac.lk",  message);
    return isSuccess;

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