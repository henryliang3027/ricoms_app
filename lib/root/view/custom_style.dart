import 'package:flutter/material.dart';

class CustomStyle {
  static Container getBox(int style, String data) {
    switch (style) {
      case 100:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.black),
          ),
        );
      case 101:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.white),
          ),
        );
      case 102:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.blue),
          ),
        );
      case 103:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.white),
          ),
        );
      case 104:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.white),
          ),
        );
      case 105:
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.green),
          ),
        );

      case 106:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.black),
          ),
        );

      case 107:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.blue),
          ),
        );

      case 108:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.green),
          ),
        );

      default:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Text(
            data,
            style: const TextStyle(color: Colors.black),
          ),
        );
    }
  }
}
