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
function sendEmail( string recipient,  string messageBody) returns boolean {

    string data = getCustomEmailTemplate(messageBody);
    gmail:MessageRequest mes = createEmail(recipient, data);
    var sendMessageResponse = gmailClient->sendMessage(userId, untaint mes);

    if (sendMessageResponse is (string, string)){
        log:printInfo("Sent email to " + recipient);
        return true;
    } else {
        log:printInfo("Unable to sent email to "+recipient);
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
    messageRequest.contentType = gmail:TEXT_PLAIN;
    return messageRequest;

}

//Create a customer email template
function getCustomEmailTemplate(string messageBody) returns string {

    string emailTemplate = "Hi, \n";
    emailTemplate = emailTemplate + "Welcome to the location service! \n";
    if (message.length() == 0) {
        emailTemplate = emailTemplate + "Sorry to inform but there are no nearby friends for carpooling.\n";
    } else {
        emailTemplate = emailTemplate + "Below contains the available nearby friends for carpooling. \n";
        emailTemplate = emailTemplate + messageBody;
    }

    return emailTemplate;

}