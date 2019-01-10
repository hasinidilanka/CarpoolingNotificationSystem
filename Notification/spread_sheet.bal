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