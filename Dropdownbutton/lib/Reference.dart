import 'package:flutter/material.dart';

class Ref {
  List<String> items = ["a05", "b05", "c05"];
  String item = "a05";

  DropdownButton getDropDown() {
    return DropdownButton(
      items: items.map((String e) => DropdownMenuItem(
        value: e, // 선택 시 onChanged 를 통해 반환할 value
        child: Text(e),
      )).toList(),
      onChanged: (value) {
        item = value;
      },
      value: item,
      style: const TextStyle(color: Colors.black, fontSize: 32),
      dropdownColor: Colors.grey,
    );
  }

  static List<String> itemsStatic = ["a06", "b06", "c06"];
  static String itemStatic = "a06";

  static DropdownButton getDropDownStatic() {
    return DropdownButton(
      items: itemsStatic.map((String e) => DropdownMenuItem(
        value: e, // 선택 시 onChanged 를 통해 반환할 value
        child: Text(e),
      )).toList(),
      onChanged: (value) {
        itemStatic = value;
      },
      value: itemStatic,
      style: const TextStyle(color: Colors.black, fontSize: 32),
      dropdownColor: Colors.grey,
    );
  }
}