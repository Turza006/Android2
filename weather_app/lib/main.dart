import 'package:flutter/material.dart';
import './ui/Weather.dart';


void main(){
  runApp(MaterialApp(
    title: 'Weather Now',
    debugShowCheckedModeBanner: false,
    home: Weather(),
  ));
}