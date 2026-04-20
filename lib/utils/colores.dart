import 'package:flutter/material.dart';

const COLORFONDO = Color.fromRGBO(116, 9, 9, 1);
const COLORAPPBAR = Color.fromRGBO(116, 9, 9, 1);
const COLORBORDE = Color.fromARGB(209, 123, 123, 123);
const COLORTRANSPARENTE = Color.fromARGB(236, 249, 226, 221);
const COLORBASE = Color.fromRGBO(240, 216, 190, 1.000);

Color getColorScala(int value) {
  switch (value) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.amber;
    case 4:
      return Colors.lightGreen;
    case 5:
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getColorByAvance(int value) {
  // 0 = rojo, 50 = amarillo, 100 = verde
  if (value <= 50) {
    return Color.lerp(Colors.red, Colors.orange, value / 50)!;
  } else {
    return Color.lerp(Colors.orange, Colors.green, (value - 50) / 50)!;
  }
}
