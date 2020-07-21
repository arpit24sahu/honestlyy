//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'data.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admob_flutter/admob_flutter.dart';

class MoreInfo extends StatefulWidget {
  FirebaseUser user;
  String param;
  MoreInfo({this.user, this.param});
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  String _uid;


  @override
  void initState() {
    hasData = 0;
    setState(() {
      _uid = widget.user.uid;
    });
    _getUser();
    _getData();
    // TODO: implement initState
    super.initState();
  }
  FirebaseUser _user;
  String _name= " ";
  int _timeStamp=0;
  String _email=" ";
  String _password=" ";

  Future<void> _getUser()async{
    Firestore.instance
        .collection('users')
        .document(_uid)
        .snapshots()
        .listen((data) async {
      _name = data.data['nick'];
      print(_name);
      _email = data.data['email'];
      print(_email);
      _timeStamp = data.data['timestamp'];
      print(_timeStamp);
      _password = data.data['password'];
      print(_password);

      setState(() {

      });
    });
  }

  int hasData = 0;
  int noOfResponses = 0;


  Future<void> _getData()async{
    FirebaseUser muser = await _auth.currentUser();
    print("-------------------------------------------uid is"+_uid);
    await Firestore.instance
        .collection("users")
        .document(_uid)
        .collection('entries')
        .snapshots()
        .listen((event) async {
      if(event.documents.length>0){
        setState(() {
          noOfResponses = event.documents.length;
        });
        setState(() {
          hasData = 1;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Material(
                          borderRadius: BorderRadius.circular(10),
                          shadowColor: Colors.blue,
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                height: 80,
                                color: Colors.yellow,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(_name,textScaleFactor: 1.5,),
                                    ),
                                    Center(
                                      child: Text(_email),
                                    ),
                                  ],
                                )
                            ),
                          )
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        shadowColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 40,
                            color: Colors.yellow,
                            child: Center(
                              child: Text("${widget.param.toUpperCase()}", style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        shadowColor: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 40,
                            color: Colors.yellow,
                            child: Center(
                              child: Text("Responses received: $noOfResponses"),
                            ),
                          ),
                        ),
                      )
                  ),
                  AdmobBanner(
                    adSize: AdmobBannerSize.FULL_BANNER,
                    adUnitId: Ads[3],
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('users').document(widget.user.uid).collection('entries').snapshots(),
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if(noOfResponses==0){
                              return Center(
                                child: Text("No Responses yet")
                              );
                            }

//                            if(noOfResponses>0){
//                              return Center(
//                                child: Text("${noOfResponses}"),
//                              );
//                            }

                            List <DocumentSnapshot> docs = snapshot.data.documents;
                            List<Widget> messages = docs.map((doc) => Entry(
                              from: doc.data['n'],
                              value: doc.data['${widget.param}'],
                              time: doc.data['timestamp'],
                            )).toList();
                            return ListView(
                              children: [
                                ...messages,
                                AdmobBanner(
                                  adSize: AdmobBannerSize.LARGE_BANNER,
                                  adUnitId: Ads[4],
                                ),
                              ],
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],

          ),
        )
    );
  }
}

class Entry extends StatefulWidget {
  String from;
  int value;
  int time;
  Entry({this.from, this.value, this.time});
  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),

//        child: Text("Hello World"),
      child: Material(
        shadowColor: Colors.pinkAccent,
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(

          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${DateTime.fromMillisecondsSinceEpoch(widget.time).day}-${DateTime.fromMillisecondsSinceEpoch(widget.time).month}-${DateTime.fromMillisecondsSinceEpoch(widget.time).year}"),
              Text("${DateTime.fromMillisecondsSinceEpoch(widget.time).hour}:${DateTime.fromMillisecondsSinceEpoch(widget.time).minute}:${DateTime.fromMillisecondsSinceEpoch(widget.time).second}"),

            ],
          ),
          title: Text("${widget.from}"),
          trailing: Text("${widget.value}"),
        ),
      )

    );
  }
}
