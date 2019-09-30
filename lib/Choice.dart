import 'package:flutter/material.dart';

class Choice {
  String _choice;
  Icon _icon;

  Choice({String choice, Icon icon}){
    this._choice = choice;
    this._icon = icon;
  }

  String get getChoice {return this._choice;}

  Icon get getIcon {return this._icon; }
}