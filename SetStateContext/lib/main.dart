// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const ClassA_Stateful());
}

class ClassA_Stateful extends StatefulWidget {
  const ClassA_Stateful({Key? key}) : super(key: key);

  @override
  _ClassA_Stateful createState() => _ClassA_Stateful();
}
class _ClassA_Stateful extends State<ClassA_Stateful> {
  List<int> value = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value[0].toString()),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        value[0]++;
                      });
                    },
                    child: Text("A")
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value[1].toString()),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      increase();
                    },
                    child: Text("B")
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void increase() {
    setState(() {
      value[1]++;
    });
  }
}