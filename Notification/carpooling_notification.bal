import ballerina/io;
import ballerina/log;

//Send emails to the user about available carpooling options
function notify(string location, string email) returns boolean{

    //Get all the candidates that have filled in spread sheet.
    Person[] candidates = getAllCandidates();

    //Get destination from all the candidates.
    string destination = getDestination(candidates);

    //Select the most suitable candidates.
    Person[] selectedCandidates = getSelectedCandidates(location, destination, candidates);

    //Create a message including details about the selected candidates
    string message = createMessage(selectedCandidates);

    //Send email to the user
    boolean isSuccess = sendEmail( email,  message);

    return isSuccess;
}

