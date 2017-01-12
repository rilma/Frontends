angular.module('PeopleApp', ['ngMaterial'])
    .controller('PeopleController', function($scope) {
        $scope.people = [
            {
                name: "Alice",
                children: ["Bob"]
            },
            {
                name: "Bob",
                children: ["Chloe", "John"]
            },
            {
                name: "Chloe",
                children: []
            },
            {
                name: "John",
                children: []
            }
        ]

        $scope.findDescendants = function (parent, people) {
            
            // return an array with the names of all descendants of "parent" in "people"
            // NOTE: Fix to include levels from great-grand-parents and above!
            
            var descendants = [];

            descendants.push(parent.children.join(', '));

            for (var i = 0; i < parent.children.length; i++) {
                for (var j = 0; j < people.length; j++) {
                    if (parent.children[i] == people[j].name) {
                        for (var k = 0; k < people[j].children.length; k++) descendants.push(people[j].children[k]);
                    }
                }
            }
            return [descendants.join(', ')];

        }

        $scope.person = {name: '', children: []};

        $scope.addPerson = function () {
            var oldIndex = $scope.people.find(function (person) {
                return person.name == $scope.person.name;
            });

            if(oldIndex) {
                $scope.people.splice(oldIndex, 1);
            }

            $scope.people.push($scope.person);
            $scope.person = {name: '', children: []};
        }
    });
