import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:honestlyy/Panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'data.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  double h;
  double w;
  String _name, _email, _password, _nick;
  TextEditingController _nameC = TextEditingController();
  TextEditingController _nickC = TextEditingController();
  TextEditingController _emailC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();
  int userIsThere=0;

  Future<void> _login()async{
    FirebaseUser user;
    if(_emailC.text.length>0&&
        _passwordC.text.length>0){
      try{

        user = (await _auth.signInWithEmailAndPassword(
          email: _emailC.text,
          password: _passwordC.text,
        )).user;

        userIsThere = 1;
      }catch(e){
        print("Error: ${e.toString()}");
        userIsThere=0;
        Flushbar(
          title: "Error",
          message: e.toString(),
          duration: Duration(seconds: 10),
        )..show(context);
      } finally{
        if(userIsThere==1){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Panel(user: user,)
              )
          );
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
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
                width: 250,
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  elevation: 10,
                  child: TextField(
                    controller: _emailC,
                    decoration: InputDecoration(
                      hintText: "Email...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Text(" "),
              Container(
                width: 250,
                child: Material(

                  borderRadius: BorderRadius.circular(5),
                  elevation: 10,
                  child: TextField(
                    controller: _passwordC,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Text(" "),
              Container(
                width: 150,
                child: Material(
                  color: Colors.pinkAccent,
                  elevation: 10,
                  borderRadius: BorderRadius.circular(5),
                  child: MaterialButton(
                    height: 10,
                    minWidth: 100,
                    onPressed: (){
                      _login();
                    },
                    child: Center(child: Text("Login")),
                  ),
                ),
              ),
              Text(" "),
              Text(" "),


              //-------------------------------------
              //Mobile App
              AdmobBanner(
                adSize: AdmobBannerSize.FULL_BANNER,
                adUnitId: Ads[3],
              ),
              //Mobile App
              //--------------------------------------
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
//                      width: 250,
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
              //Web

            ],
          )
        ],
      ),
    );
  }

}

