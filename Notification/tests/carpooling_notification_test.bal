import ballerina/log;
import ballerina/test;
import ballerina/io;

@test:Config
function testNotify() {
    log:printDebug("Carpooling Notification -> Sending notification to a user");
    boolean result = notify("maharagama","john@gmail.com");
    test:assertTrue(result, msg = "Carpooling Notification -> Sending notification to a user failed");
}
