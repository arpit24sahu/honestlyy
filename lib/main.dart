import 'package:flutter/material.dart';
import 'package:honestlyy/Answer.dart';
import 'Register.dart';
import 'Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';

void main() {
  Admob.initialize(Ads[2]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int _num=0;

class _HomePageState extends State<HomePage> {
  String _id;
  double h;
  double w;

  @override
  void initState() {

//    Admob.initialize("ca-app-pub-7741939794770856~6942195255");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
//          AdmobBanner(
//            adSize: AdmobBannerSize.FULL_BANNER,
//            adUnitId: "ca-app-pub-3940256099942544/6300978111",
//          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(),
              Hero(
                tag: 'main',
                child: Container(
                  height: 80,
                  width: 500,
                  child: Image.asset("assets/banner.png", height: 80, width: 200,),
                ),
              ),
              Text(" "),
              Text(" "),
              Container(
                width: 200,
                child: Material(
                  color: Colors.white,
                  shadowColor: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(5),
                  elevation: 10,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Nick",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      setState(() {
                        _id = value;
                      });
                    },
                  ),
                ),
              ),
              Text(" "),
              Container(
                width: 150,
                child: Material(
                  color: Colors.white,
                  shadowColor: Colors.deepPurple,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(5),
                  child: MaterialButton(
                    height: 10,
                    minWidth: 100,
                    onPressed: ()async{
                      await Firestore.instance
                          .collection("users")
                          .where('nick', isEqualTo: _id)
                          .getDocuments()
                          .then((value) {
                            print("value of documents length: ${value.documents.length}");
                            if(value.documents.length!=0){
                              print("id sent is: $_id");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Answer(id: _id,)
                                  )
                              );
                              setState(() {

                              });
                            }
                            else{
                              Flushbar(
                                title: "User not found",
                                message: "Please recheck the Nick that you entered",
                                duration: Duration(seconds: 10),
                              )..show(context);
                            }
                        print("value: ${value.documents.length}");
                      }
                      );







//                      if(_id!=null){
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => Answer(id: _id,)
//                            )
//                        );
//                      }
                    },
                    child: Center(child: Text("Continue")),
                  ),
                ),
              ),
              Text(" "),
              Text(" "),
              Text(" "),
              Text(" "),
              Container(
                width: 200,
                child: Material(
                  color: Colors.pinkAccent,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.deepPurple,
                  child: MaterialButton(
                    height: 10,
                    minWidth: 100,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()
                          )
                      );
                    },
                    child: Center(child: Text("Login")),
                  ),
                ),
              ),
              Text(" "),

              Container(
                width: 200,
                child: Material(
                  color: Colors.pinkAccent,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.deepPurple,
                  child: MaterialButton(
                    height: 10,
                    minWidth: 100,
                    onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()
                            )
                        );
                    },
                    child: Center(child: Text("Create your own")),
                  ),
                ),
              ),
              Text(" "),
              Text(" "),
              //---------------------------------------------------------------
              //Mobile App
              AdmobBanner(
                adSize: AdmobBannerSize.FULL_BANNER,
                adUnitId: Ads[3],
              ),
              //Mobile App
              //---------------------------------------------------------------
              //Web
//              Material(
//                borderRadius: BorderRadius.circular(50),
//                color: Colors.white,
//                elevation: 10,
//                shadowColor: Colors.red,
//                child: MaterialButton(
//                    onPressed: ()async{
//                      String _url = "https://play.google.com/store/apps/details?id=com.arpit.honestlyy";
//                      if(await canLaunch(_url)){
//                        await launch(
//                            _url,
//                            forceWebView: false
//                        );
//                      } else {
//                        Flushbar(
//                          title: "Cannot launch PlayStore",
//                          message: "Please search for \"Honestlyy\" App on Play Store.",
//                          duration: Duration(seconds: 8),
//                        ).show(context);
//                      }
//
//                    },
//                    child: Container(
//                      width: 200,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Image.asset("assets/playstore.png", height: 30, width: 30,),
//                          Text(" "),
//                          Text(" "),
//                          Text("Download App", style: TextStyle(fontSize: 15),)
//                        ],
//                      ),
//                    )
//                ),
//              )
              //web
              //---------------------------------------------------------------

            ],
          ),
        ],
      )
    );
  }
}
