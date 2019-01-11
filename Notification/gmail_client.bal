import ballerina/io;
import ballerina/http;
import ballerina/log;
import wso2/gmail;

//Create a gmail configuration
gmail:GmailConfiguration gmailConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: accessToken,
            refreshToken: refreshToken,
            clientId: clientId,
            clientSecret: clientSecret
        }
    }
};

//Create a gmail client.
gmail:Client gmailClient = new(gmailConfig);

//Send the email
function sendEmail( string recipient,  Person[] candidates) returns boolean {

    string data = getCustomEmailTemplate(candidates);
    gmail:MessageRequest mes = createEmail(recipient, data);
    var sendMessageResponse = gmailClient->sendMessage(userId, untaint mes);

    if (sendMessageResponse is (string, string)){
        log:printInfo("Sent email to " + recipient);
        return true;
    } else {
        log:printError("Unable to send email to "+recipient, err = sendMessageResponse);
        return false;
    }
}

//create email request
function createEmail(string recipient, string data) returns gmail:MessageRequest {

    gmail:MessageRequest messageRequest = {};
    messageRequest.recipient = recipient;
    messageRequest.sender = senderEmail;
    messageRequest.subject = emailSubject;
    messageRequest.messageBody = data;
    messageRequest.contentType = gmail:TEXT_HTML;
    return messageRequest;
}

//Create a customer email template
function getCustomEmailTemplate(Person[] candidate) returns string {

    string emailTemplate = "<h3>Hi,</h3> \n";
    emailTemplate = emailTemplate + "<h4>Welcome to the carpooling notification service! </h4>\n";
    if (candidate.length() == 0) {
        emailTemplate = emailTemplate + "<p>Sorry to inform but there are no nearby friends for carpooling.</p>\n";
    } else {
        emailTemplate = emailTemplate + "<p>Please contact the below users for carpooling. </p>\n";
        emailTemplate = emailTemplate + "<table border=\"1\"><tr><th>Name</th> <th>Location</th><th>Telephone</th></tr>";
        emailTemplate = emailTemplate + createMessage(candidate);
    }
    io:println(emailTemplate);
    return emailTemplate;
}

//Create message including available carpooling details
function createMessage(Person[] candidates) returns string{
    string message ="";
    foreach Person person in candidates {
        message += "<tr><td>"+person.getName()+"</td><td>"+person.getLocation()+"</td><td>"+person.getTelephone()+"</td></tr>\n";
    }
    message += "</table>";
    return message;
}