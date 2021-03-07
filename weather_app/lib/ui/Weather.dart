import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}
 
class _WeatherState extends State<Weather> {
  String _cityEntered;

  Future _gotoNextScreen(BuildContext context)async{
    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map> (
        builder:(BuildContext context){
          return Changecity();
        }
      )
    );
    if (results!= null && results.containsKey('enter')){
      _cityEntered = results['enter'];
      // print("From fast Screen"+results['enter'].toString());
    }
  }
  void showStuff() async{
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Weather',
        style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(162, 191, 228, 100),
        actions: <Widget>[
          IconButton(
              icon:Icon(Icons.menu,
              color: Colors.black,),
              onPressed:(){_gotoNextScreen(context);}
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/clearsky.jpg',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0),
            child: Text('${_cityEntered == null? util.defaultCity:_cityEntered}',
            style: cityStyle(),),
          ),
          Container(
            alignment: Alignment.center,
              child: Image.asset('images/light_rain.png'),
          ),
          Container(
            // margin: const EdgeInsets.fromLTRB(30.0, 450.0, 0, 0),
            alignment: Alignment.center,
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.apiId}&units=metric';
    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }
  Widget updateTempWidget(String city,){
    return FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity:city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){

        if (snapshot.hasData){
          Map content = snapshot.data;
          return Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(content['main']['temp'].toString()+'c',
                  style: TextStyle(
                    fontSize: 49.9,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: Colors.white
                  ),),
                  subtitle: ListTile(
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()} c\n"
                          "Min:${content['main']['temp_min'].toString()} c\n"
                          "Max:${content['main']['temp_max'].toString()} c",
                      style: Details(),
                    ),
                  ),
                ),

              ],
            ),
          );
        }else{
          return Container();
        }
      });
  }

}

class Changecity extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather',
          style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(162, 191, 228, 100),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/clearsky.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: (){
                    Navigator.pop(context,{
                      'enter':_cityFieldController.text,
                    });
                  },
                  textColor: Colors.white70,
                  color: Colors.blueGrey,
                  child: Text('Get Weather'),

                ),
              )
            ],
          )
          
        ],
      ),
    );
  }
}


TextStyle Details(){
  return TextStyle(
    color: Colors.white70,
    fontStyle: FontStyle.normal,
    fontSize: 14.5
  );
}


TextStyle cityStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 22.9,
      fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}
