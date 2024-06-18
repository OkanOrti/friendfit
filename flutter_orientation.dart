import 'package:flutter/material.dart';
import "package:flutter/services.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]).then((_){
    runApp(MaterialApp(

        home: MyApp()));
  });
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool isPortrait=false;
  @override
  Widget build(BuildContext context) {
    print("Called");
    return Scaffold(
        appBar: AppBar(title:Text("Rotate Widget")),
        body:SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child:Card(
                        child: Column(
                          children: [
                            Image.network("https://images.unsplash.com/photo-1591969851586-adbbd4accf81?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cm9tYW50aWMlMjBjb3VwbGV8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",height:200,),
                            MaterialButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: (){
                                  print("Called");

                                },child:Text("Play Viedo")),

                          ],
                        ),
                      )
                  ),
                  Center(
                      child:Card(
                        child: Column(
                          children: [
                            Image.network("https://images.unsplash.com/photo-1591969851586-adbbd4accf81?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cm9tYW50aWMlMjBjb3VwbGV8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",height:200,),
                            MaterialButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: (){
                                  print("Called");

                                },child:Text("Play Viedo")),

                          ],
                        ),
                      )
                  ),
                ],
              ),
              MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Chane Orientation"),
                  onPressed: (){
                    if(!isPortrait)
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    else
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

                    isPortrait=!isPortrait;
                  }

              )
            ],
          ),
        )
    );
  }
}
