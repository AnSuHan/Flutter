import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Reference.dart';
import 'Stateful.dart';

void main() {
  runApp(const Dropdown());
}

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  StatefulState refStateful = StatefulState();
  Ref ref = Ref();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              // 'R' 키를 누르면 특정 메소드를 호출
              if (event.logicalKey == LogicalKeyboardKey.keyR) {
                _handleRKeyPressed();
              }
            }
          },
          child: Center(
              child: Column(
                children: [
                  getDropdown(),        //use without setState
                  getDropdownStatic(),  //use with setState

                  refStateful.getDropdown(),                //problem
                  const RefStateful(),                      //use without setState
                  StatefulState.getDropdownStatic(context), //use with setState

                  ref.getDropDown(),        //use with setState
                  Ref.getDropDownStatic(),  //use with setState
                ],
              )
          ),
        )
      ),
    );
  }

  void _handleRKeyPressed() {
    print("call setState");
    setState(() {

    });
  }

  List<String> items = ["a01", "b01", "c01"];
  String item = "a01";

  DropdownButton getDropdown() {
    return DropdownButton(
      items: items.map((String e) => DropdownMenuItem(
        value: e, // 선택 시 onChanged 를 통해 반환할 value
        child: Text(e),
      )).toList(),
      onChanged: (value) {
        setState(() {
          item = value!;
        });
      },
      value: item,
      style: const TextStyle(color: Colors.black, fontSize: 32),
      dropdownColor: Colors.grey,
    );
  }

  static List<String> itemsStatic = ["a02", "b02", "c02"];
  static String itemStatic = "a02";


  static DropdownButton getDropdownStatic() {
    return DropdownButton(
      items: itemsStatic.map((String e) => DropdownMenuItem(
        value: e, // 선택 시 onChanged 를 통해 반환할 value
        child: Text(e),
      )).toList(),
      onChanged: (value) {
        itemStatic = value!;
      },
      value: itemStatic,
      style: const TextStyle(color: Colors.black, fontSize: 32),
      dropdownColor: Colors.grey,
    );
  }
}