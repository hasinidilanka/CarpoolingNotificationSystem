import ballerina/io;
import ballerina/http;
import ballerina/log;
import wso2/gsheets4;

//Create a spread sheet configuration
gsheets4:SpreadsheetConfiguration spreadsheetConf = {
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

//Create a spread sheet client.
gsheets4:Client spreadsheetClient = new(spreadsheetConf);


//Read all the values from the sheet.
function getDetailsFromGSheet() returns string[][]|error {

    var values = spreadsheetClient->getSheetValues(spreadsheetId, sheetName, topLeftCell = "A1", bottomRightCell = "D5");
    return values;
}

//Create Person objects from the spread sheet values.
function getAllCandidates() returns Person[] {

    Person[] candidates = [];

    //Retrieve the candidate details from spreadsheet.
    var details = getDetailsFromGSheet();
    if (details is error) {
        log:printError("Failed to retrieve details from GSheet", err = details);

    } else {

        int i = 0;
        foreach var value in details {
            //Skip the first row as it contains header values.
            if (i > 0) {
                string address = sanitizeAndReturnUntainted(value[0]);
                string name = sanitizeAndReturnUntainted(value[1]);
                string telephone = sanitizeAndReturnUntainted(value[2]);
                Person person = new (name, address, telephone);
                candidates[i-1] = person;
            }
            i += 1;
        }
    }
    return candidates;
}

//Check for validity of string type.
function sanitizeAndReturnUntainted(string input) returns @untainted string {
    string regEx = "[^a-zA-Z]";
    return input.replace(regEx, "");
}