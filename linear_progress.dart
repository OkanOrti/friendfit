import 'dart:async';
import 'package:flutter/material.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinearProgress Indicator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState()
  {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double value  = 0;
  var download="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter LinearProgress Indicator"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Column(
                children:[
                  Container(
                    child: Text("Indeterminate Progress Indicator",style: TextStyle(fontSize: 18),),
                    margin: EdgeInsets.all(20),
                  ),

                  Container(
                    margin: EdgeInsets.all(20),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.purple,
                      minHeight: 5,
                    ),
                  ),
                  Container(
                    child: Text("Determinate Progress Indicator",style: TextStyle(fontSize: 18)),
                    margin: EdgeInsets.all(20),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.red,
                      minHeight: 5,
                      value: value,
                    ),
                  ),Container(
                    margin: EdgeInsets.all(20),
                    child: Text("${download}"),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: ElevatedButton(
                      child: Text("Download File"),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.green
                      ),
                      onPressed: ()
                      {
                        value = 0;
                        downloadData();
                        setState(() {

                        });
                      },
                    ),
                  )
                ]
            )
        )
    );
  }

  void downloadData(){
    new Timer.periodic(
        Duration(seconds: 1),
            (Timer timer){
          setState(() {
            if(value == 1) {
              timer.cancel();
              //download="${(10*value*10).toInt()}% Completed";
            }
            else {
              value = value + 0.1;
              print("Calling");
              if(value>=1)
                {

                  timer.cancel();
                  download="${(100).toInt()}% Completed";
                }else
                  {
                    download="${(10*value*10).toInt()}% Completed";
                  }

            }
          });
        }
    );
  }
}