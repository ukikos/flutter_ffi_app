import 'package:flutter/material.dart';
import 'package:flutter_ffi_app/dto/address.dart';
import 'package:flutter_ffi_app/dto/person.dart';
import 'package:flutter_ffi_app/service/libffitest_service.dart' as libffitest_service;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {

  int? sumResult;
  Future<int>? sumLongRunningResult;
  Person? person;
  String? message;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sumResult = libffitest_service.sum(11, 22);
                    });
                  },
                  child: Text("Sum: 11 + 22")
                ),
                Builder(
                  builder:(context) {
                    String text = "";
                    if (sumResult != null) {
                      text = sumResult.toString();
                    } else {
                      text = "";
                    }
                    return Text(text);
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sumLongRunningResult = libffitest_service.sumLongRunningAsync(44, 55);
                    });
                  },
                  child: Text("Sum: 44 + 55 (Long running imitation)")
                ),
                FutureBuilder(
                  future: sumLongRunningResult,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text("");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 30,
                        width: 30,
                          child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text(snapshot.data.toString());
                    }
                  }
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      person = libffitest_service.getPerson();
                    });
                  },
                  child: Text("Get person struct")
                ),
                Builder(
                  builder:(context) {
                    if (person != null) {
                      return Text(
                        "First name: ${person!.firstName}\n"
                        "Last name: ${person!.lastName}\n"
                        "Age: ${person!.age}\n"
                        "Address:\n"
                        "   Country: ${person!.address.country}\n"
                        "   City: ${person!.address.city}\n"
                        "   Street: ${person!.address.street}\n"
                        "   BuildingNumber: ${person!.address.buildingNumber}\n",
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "struct Person\n"
                  "firstName: \"Ivan\"\n"
                  "lastName: \"Solodov\"\n"
                  "age: \"44\"\n"
                  "address:\n"
                  "   country: \"Belarus\"\n"
                  "   city: \"Minsk\"\n"
                  "   street: \"Shirokaya \"\n"
                  "   buildingNumber: \"22\"\n"
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Person person = Person(
                        firstName: "Ivan",
                        lastName: "Solodov",
                        age: 44,
                        address: Address(
                          country: "Belarus", 
                          city: "Minsk", 
                          street: "Shirokaya", 
                          buildingNumber: "22"
                        )
                      );
                      message = libffitest_service.getPersonMessage(person);
                    });
                  },
                  child: Text("Send person struct and receive message")
                ),
                Builder(
                  builder:(context) {
                    if (message != null) {
                      return Text(message!);
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}