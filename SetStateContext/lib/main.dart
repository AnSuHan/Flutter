// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names

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
  static _ClassA_Stateful? _instance;
  List<int> value = [0, 0, 0];
  List<int> value_forClassC = [0, 0, 0];
  final ClassD classD = ClassD();
  final List<int> value_forClassD = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  void _update() {
    setState(() {});
  }

  static void _updateStatic() {
    _instance?._update();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //same class
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value[2].toString()),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      value[2] = increase_static(value[2]);
                      _updateStatic();
                    },
                    child: Text("C")
                ),
              ],
            ),
            //other stateful class
            const ClassB_Stateful(),
            //other stateless class
            ClassC_Stateless(
              value: value_forClassC,
              onUpdate: () {
                setState(() {});
              },
            ),
            //other class
            classD.getRow(_update),
            ClassD.getRow_static(_update, value_forClassD),
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

  static int increase_static(int a) {
    return ++a;
  }
}

class ClassB_Stateful extends StatefulWidget {
  const ClassB_Stateful({Key? key}) : super(key: key);

  @override
  ClassB_state createState() => ClassB_state();
}
class ClassB_state extends State<ClassB_Stateful> {
  static ClassB_state? _instance;
  List<int> value = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  void _update() {
    setState(() {});
  }

  static void _updateStatic() {
    _instance?._update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //same class
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
                child: Text("D")
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value[2].toString()),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  value[2] = increase_static(value[2]);
                  _updateStatic();
                },
                child: Text("E")
            ),
          ],
        ),
        //other stateful class

      ],
    );
  }

  static int increase_static(int a) {
    return ++a;
  }
}

class ClassC_Stateless extends StatelessWidget {
  final List<int> value;
  final VoidCallback onUpdate;

  const ClassC_Stateless({required this.value, required this.onUpdate, Key? key}) : super(key: key);

  static int increase_static(int a) {
    return ++a;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  value[0]++;
                  onUpdate();
                },
                child: Text("F")
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value[2].toString()),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  value[2] = increase_static(value[2]);
                  onUpdate();
                },
                child: Text("G")
            ),
          ],
        ),
      ],
    );
  }
}

class ClassD {
  List<int> value_forClassD = [0, 0, 0];

  Row getRow(VoidCallback onUpdate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value_forClassD[0].toString()),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            onPressed: () {
              value_forClassD[0]++;
              onUpdate();
            },
            child: Text("H")
        ),
      ],
    );
  }
  static Row getRow_static(VoidCallback onUpdate, List<int> value_forClassD) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value_forClassD[1].toString()),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            onPressed: () {
              value_forClassD[1]++;
              onUpdate();
            },
            child: Text("I")
        ),
      ],
    );
  }
}