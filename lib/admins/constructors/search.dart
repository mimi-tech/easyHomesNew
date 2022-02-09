import 'package:easy_homes/colors/colors.dart';
import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.search,color: kRadioColor,size: 25,);
  }
}

class CancelIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.clear,color: kRadioColor,size: 25,);
  }
}
