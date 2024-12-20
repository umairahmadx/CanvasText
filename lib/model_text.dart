import 'dart:ui';
import 'package:flutter/material.dart';

enum ActionType { add, move ,property }
enum FontName{Mali,Montserrat,Roboto}
class ModalText {
  final int id;
  String text;
  double textSize;
  bool italic;
  bool bold;
  bool underline;
  Offset position;
  Offset? previousPosition;
  FontName fontName;
  ActionType actionType;

  ModalText({
    this.fontName = FontName.Roboto,
    required this.actionType,
    required this.id,
    required this.position,
    this.previousPosition,
    this.text = "New Text",
    this.textSize = 18.0,
    this.italic = false,
    this.bold = false,
    this.underline = false,
  });

}
