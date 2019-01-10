import ballerina/io;
import ballerina/log;

function notify(string location, string email) returns boolean{

    Person[] candidates = getAllCandidates();
    string destination = getDestination(candidates);
    Person[] selectedCandidates = getSelectedCandidates(location, destination, candidates);
    string message = createMessage(selectedCandidates);
    boolean isSuccess = sendEmail( email,  message);
    return isSuccess;
}

