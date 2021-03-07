import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main(){
  runApp(MaterialApp(
    title: 'IO',
    home: Home(),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<String>get _localPath async{
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File>get _localFile async{
    final path = await _localPath;
    return new File('$path/data.txt');
  }
  Future<File> writteData(String massage) async{
    final file = await _localFile;
    return file.writeAsString('$massage');
  }
  Future<String> readData()async{
    try{
      final file = await _localFile;
      String data = await file.readAsString();
    }catch(e){

    }
  }

}
