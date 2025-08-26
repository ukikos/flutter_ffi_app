import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter_ffi_app/dto/address.dart';
import 'package:flutter_ffi_app/dto/person.dart';

const String _libName = 'libffitest';

final ffi.DynamicLibrary _dylib = () {
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('$_libName.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();


typedef _NativeSum = ffi.Int32 Function(ffi.Int32 a, ffi.Int32 b);
typedef _DartSum = int Function(int a, int b);

int sum(int a, int b) {
  final _DartSum nativeSum = _dylib.lookup<ffi.NativeFunction<_NativeSum>>('sum').asFunction();
  return nativeSum(a, b);
}


typedef _NativeSumLR = ffi.Int32 Function(ffi.Int32 a, ffi.Int32 b);
typedef _DartSumLR = int Function(int a, int b);

Future<int> sumLongRunningAsync(int a, int b) async {
  final _DartSumLR nativeSumLongRunning = _dylib.lookup<ffi.NativeFunction<_NativeSumLR>>('sumLongRunning').asFunction();
  int result = await Isolate.run(() => nativeSumLongRunning(a, b));
  return result;
}


final class PersonStruct extends ffi.Struct {
  external ffi.Pointer<Utf8> firstName;
  external ffi.Pointer<Utf8> lastName;

  @ffi.Int32()
  external int age;

  external ffi.Pointer<AddressStruct> address;
}

final class AddressStruct extends ffi.Struct {
  external ffi.Pointer<Utf8> country;
  external ffi.Pointer<Utf8> city;
  external ffi.Pointer<Utf8> street;
  external ffi.Pointer<Utf8> buildingNumber;
}

typedef _NativeGetPerson = ffi.Pointer<PersonStruct> Function();
typedef _DartGetPerson = ffi.Pointer<PersonStruct> Function();

Person getPerson() {
  final _DartGetPerson nativeGetPerson = _dylib.lookup<ffi.NativeFunction<_NativeGetPerson>>('getPerson').asFunction();
  final ffi.Pointer<PersonStruct> personStruct = nativeGetPerson();

  Address address = Address(
    country: personStruct.ref.address.ref.street.toDartString(), 
    city: personStruct.ref.address.ref.city.toDartString(), 
    street: personStruct.ref.address.ref.street.toDartString(), 
    buildingNumber: personStruct.ref.address.ref.buildingNumber.toDartString()
  );

  Person person = Person(
    firstName: personStruct.ref.firstName.toDartString(), 
    lastName: personStruct.ref.lastName.toDartString(), 
    age: personStruct.ref.age, 
    address: address
  );

  freePersonStruct(personStruct);
  return person;
}

typedef _NativeFreePerson = ffi.Void Function(ffi.Pointer<PersonStruct>);
typedef _DartFreePerson = void Function(ffi.Pointer<PersonStruct>);

void freePersonStruct(ffi.Pointer<PersonStruct> person) {
  final _DartFreePerson nativeFreePerson = _dylib.lookup<ffi.NativeFunction<_NativeFreePerson>>('freePerson').asFunction();
  nativeFreePerson(person);
}


typedef _NativeGetPersonMessage = ffi.Pointer<Utf8> Function(ffi.Pointer<PersonStruct>);
typedef _DartGetPersonMessage = ffi.Pointer<Utf8> Function(ffi.Pointer<PersonStruct>);

String getPersonMessage(Person person) {
  final _DartGetPersonMessage getPersonMessage = _dylib.lookup<ffi.NativeFunction<_NativeGetPersonMessage>>('getPersonMessage').asFunction();

  ffi.Pointer<PersonStruct> personStruct = malloc<PersonStruct>();

  personStruct.ref.firstName = person.firstName.toNativeUtf8();
  personStruct.ref.lastName = person.lastName.toNativeUtf8();
  personStruct.ref.age = person.age;
  personStruct.ref.address = malloc<AddressStruct>();
  personStruct.ref.address.ref.country = person.address.country.toNativeUtf8();
  personStruct.ref.address.ref.city = person.address.city.toNativeUtf8();
  personStruct.ref.address.ref.street = person.address.street.toNativeUtf8();
  personStruct.ref.address.ref.buildingNumber = person.address.buildingNumber.toNativeUtf8();

  ffi.Pointer<Utf8> messagePtr = getPersonMessage(personStruct);
  final String message = messagePtr.toDartString();
  
  malloc.free(messagePtr);
  malloc.free(personStruct.ref.address);
  malloc.free(personStruct);
  return message;
}
