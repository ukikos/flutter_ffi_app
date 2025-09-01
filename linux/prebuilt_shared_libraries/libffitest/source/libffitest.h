#ifndef LIBFFITEST_H
#define LIBFFITEST_H

typedef struct Address {
	char* country;
	char* city;
	char* street;
	char* buildingNumber;
} Address;

typedef struct Person {
	char* firstName;
	char* lastName;
	int age;
	Address* address;
} Person;

int sum(int a, int b);

int sumLongRunning(int a, int b);

Person* getPerson();

void freePerson();

char* getPersonMessage();

#endif
