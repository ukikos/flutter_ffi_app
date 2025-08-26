import 'package:flutter_ffi_app/dto/address.dart';

final class Person {
  String firstName;
  String lastName;
  int age;
  Address address;

  Person({required this.firstName, required this.lastName, required this.age, required this.address});
}