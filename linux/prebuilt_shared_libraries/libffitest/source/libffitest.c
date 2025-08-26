#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "libffitest.h"

int sum(int a, int b) {
	return a + b;
}

int sumLongRunning(int a, int b) {
	usleep(5000 * 1000);
	return a + b;
}

Person* getPerson() {
	Address* address = malloc(sizeof(Address));
	address->country = "Russia\0";
	address->city = "Belgorod\0";
	address->street = "Kolcovskaya\0";
	address->buildingNumber = "22\0";
	
	Person* person = malloc(sizeof(Person));
	person->firstName = "Evgenii\0";
	person->lastName = "Ivanov\0";
	person->age = 30;
	person->address = address;
}

void freePerson(Person* person) {
	free(person->address);
	free(person);
}

// message need to be free
char* getPersonMessage(Person* person) {
	char* message;
	asprintf(&message, "Hello %s %s, age %d, from %s", person->firstName, person->lastName, person->age, person->address->country);
	return message;
}

int main()
{
    printf("Sum: %d\n", sum(3, 7));
    
    printf("Sum: %d\n", sumLongRunning(22, 33));
    
    Person* person = getPerson();
    
    char* message = getPersonMessage(person);
    printf("%s\n", message);
    
    free(message);
    freePerson(person);
}

