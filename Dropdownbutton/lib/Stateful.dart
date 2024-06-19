import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefStateful extends StatefulWidget {
  const RefStateful({Key? key}) : super(key: key);

  @override
  StatefulState createState() => StatefulState();
}

class StatefulState extends State<RefStateful> {
  List<String> items = ["a03-1", "b03-1", "c03-1"];
  String item = "a03-1";
  List<String> itemsBuild = ["a03-2", "b03-2", "c03-2"];
  String itemBuild = "a03-2";

  @override
  Widget build(BuildContext context) {
    return getDropdownBuild(context);
  }

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

  DropdownButton<String> getDropdownBuild(BuildContext context) {
    return DropdownButton<String>(
      items: itemsBuild.map((String e) => DropdownMenuItem(
        value: e, // 선택 시 onChanged 를 통해 반환할 value
        child: Text(e),
      )).toList(),
      onChanged: (value) {
        setState(() {
          itemBuild = value!;
        });
      },
      value: itemBuild,
      style: const TextStyle(color: Colors.black, fontSize: 32),
      dropdownColor: Colors.grey,
    );
  }


  static List<String> itemsStatic = ["a04", "b04", "c04"];
  static String itemStatic = "a04";

  static DropdownButton getDropdownStatic(BuildContext context) {
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