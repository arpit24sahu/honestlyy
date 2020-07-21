import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:honestlyy/Panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'data.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
  Future<void> _register()async{
    FirebaseUser user;
    if(_nameC.text.length>0&&
      _emailC.text.length>0&&
      _passwordC.text.length>0&&
      _nickStatus==1
      ){
      try{
        user = (await _auth.createUserWithEmailAndPassword(
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
      } finally {
        if(userIsThere==1){
          await _firestore.collection('users').document(user.uid).setData({
            'uid': user.uid,
            'email': user.email,
            'nick': _nameC.text,
            'password': _passwordC.text,
            'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Panel(user: user,)
            )
          );
        }
      }
    }
    else if (_nickStatus==0){
      Flushbar(
        title: "Nick Unavailable",
        message: "Please choose another unique Nick",
        duration: Duration(seconds: 10),
      )..show(context);
    }

  }
  int _nickStatus = -1;

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
              (_nickStatus==1)
                  ?Text("Nick Available", style: TextStyle(color: Colors.green),)
                  :Text("Nick Unavailable", style: TextStyle(color: Colors.red),),
              Container(
                width: 250,
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  elevation: 10,
                  child: TextField(
                    controller: _nameC,
                    decoration: InputDecoration(
                      hintText: "Name/Nick...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (texx){
                      if(_nameC.text.toString().length>0){
                        Firestore.instance
                            .collection("users")
                            .where('nick', isEqualTo: _nameC.text)
                            .getDocuments()
                            .then((value) {

//                          print("value: ${value.documents.length} ");
                          (value.documents.length==0)?print("value: ${value.documents.length}, ${_nameC.text} nick available,"):print("value: ${value.documents.length}, ${value.documents.last.data['nick'].toString().toUpperCase()} ${_nameC.text} nick Unavailable");
                              if(value.documents.length!=0){
                                setState(() {
                                  _nickStatus = 0;
                                });
                              }
                              else{
                                setState(() {
                                  _nickStatus = 1;
                                });
                              }
                              print("value: ${value.documents.length}");
                            }
                        );

                      }
                      setState(() {

                      });
                    },
                  ),
                ),
              ),
//              RaisedButton(
//                onPressed: (){
//                  if(_nameC.toString().length>0){
//                    Firestore.instance
//                        .collection("users")
//                        .where('nick', isEqualTo: _nameC.text)
//                        .getDocuments()
//                        .then((value) => print("value: ${value.documents.length} ${_nameC.text.toString()}")
//                    );
//                  }
//                },
//                child: Text("check"),
//              ),
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
                      _register();
                    },
                    child: Center(child: Text("Register")),
                  ),
                ),
              ),
              Text(" "),
              Text(" "),

              //-------------------------------------------
              //Mobile app
              AdmobBanner(
                adSize: AdmobBannerSize.FULL_BANNER,
                adUnitId: Ads[3],
              ),
              //Mobile App
              //--------------------------------------------------------------
              // web
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
              //web
              //---------------------------------------------------------------

              //---------------------------------------------------------------
              //Mobile App



            ],
          )
        ],
      ),
    );
  }
}
