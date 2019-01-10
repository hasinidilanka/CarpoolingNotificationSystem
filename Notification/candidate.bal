import ballerina/io;

type Person object {
    private string name;
    private string location;
    private string telephone;

    function __init(string name, string location, string telephone) {
        self.name = name;
        self.location = location;
        self.telephone = telephone;
    }

    function getName() returns string {
        return self.name;
    }

    function getLocation() returns string {
        return self.location;
    }

    function getTelephone() returns string {
        return self.telephone;
    }
};