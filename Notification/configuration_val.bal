import ballerina/io;
import ballerina/config;

# A valid access token with gmail and google sheets access.
string accessToken = config:getAsString("ACCESS_TOKEN");

# The client ID for your application.
string clientId = config:getAsString("CLIENT_ID");

# The client secret for your application.
string clientSecret = config:getAsString("CLIENT_SECRET");

# A valid refreshToken with gmail and google sheets access.
string refreshToken = config:getAsString("REFRESH_TOKEN");

# Spreadsheet id of the reference google sheet.
string spreadsheetId = config:getAsString("SPREADSHEET_ID");

# Sheet name of the reference googlle sheet.
string sheetName = config:getAsString("SHEET_NAME");

# Sender email address.
string senderEmail = config:getAsString("SENDER");

# The user's email address.
string userId = config:getAsString("USER_ID");

# The email subject.
string emailSubject = config:getAsString("SUBJECT");

# API key for Distance Matrix API.
string apiKey = config:getAsString("API_KEY");
