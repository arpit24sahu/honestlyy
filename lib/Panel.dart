import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:honestlyy/MoreInfo.dart';
import 'data.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class Panel extends StatefulWidget {
  FirebaseUser user;
  Panel({this.user});
  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  String _uid;

  List<int> _eyes = [0,0,0,0,0];
  List<int> _smile = [0,0,0,0,0];
  List<int> _humour = [0,0,0,0,0];
  List<int> _behaviour = [0,0,0,0,0];
  List<int> _attractiveness = [0,0,0,0,0];
  List<int> _dressing = [0,0,0,0,0];
  List<int> _honesty = [0,0,0,0,0];
  List<int> _attitude = [0,0,0,0,0];
  List<int> _craziness = [0,0,0,0,0];
  List<int> _timespent = [0,0,0,0,0];

  
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
          print("document length ${event.documents.length}");
          if(event.documents.length>0){
            setState(() {
              noOfResponses = event.documents.length;
            });
            print("hasData was $hasData");
            setState(() {
              hasData = 1;
            });
            print("hasData is $hasData");
          }
          event.documents.forEach((element) {
            _eyes[element.data['eyes']-1]++;
            _smile[element.data['smile']-1]++;
            _humour[element.data['humour']-1]++;
            _behaviour[element.data['behaviour']-1]++;
            _attractiveness[element.data['attractiveness']-1]++;
            _dressing[element.data['dressing']-1]++;
            _honesty[element.data['honesty']-1]++;
            _attitude[element.data['attitude']-1]++;
            _craziness[element.data['craziness']-1]++;
            _timespent[element.data['timespent']-1]++;
          });
    });
  }



  @override
  Widget build(BuildContext context) {
    print("--------------------hasData is $hasData");
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
//                Padding(
//                    padding: EdgeInsets.all(5),
//                    child: Material(
//                      shadowColor: Colors.blue,
//                      borderRadius: BorderRadius.circular(10),
//                      elevation: 10,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(10),
//                        child: Container(
//                          height: 40,
//                          color: Colors.yellow,
//                          child: Center(
//                            child: Text(_email),
//                          ),
//                        ),
//                      ),
//                    )
//                ),
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
                        stream: _firestore.collection('users').document(_uid).collection('entries').snapshots(),
                        builder: (context, snapshot){
                          if(!snapshot.hasData){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if(hasData==0){
                            return Center(
                              child: Text("No data yet. :)")
                            );
                          }

                          //------------------------------
                          //web
//                          if(noOfResponses>7){
//                            return Center(
//                              child: Column(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: [
//                                  Text("Ohh! Bummer...", textScaleFactor: 1.5,),
//                                  Text(" "),
//                                  Text("Unfortunately, We cannot display more than"),
//                                  Text("7 enteries on our web platform,"),
//                                  Text("But that's not the case with our App"),
//                                  Text("Head on to our App to get"),
//                                  Text("more Insights, Detailed Information, and"),
//                                  Text("for much more FUN!"),
//                                  Text(" "),
//
//                                  Material(
//                                    borderRadius: BorderRadius.circular(50),
//                                    color: Colors.white,
//                                    elevation: 10,
//                                    shadowColor: Colors.red,
//                                    child: MaterialButton(
//                                      onPressed: ()async{
//                                        String _url = "https://play.google.com/store/apps/details?id=com.arpit.honestlyy";
//                                        if(await canLaunch(_url)){
//                                          await launch(
//                                            _url,
//                                            forceWebView: false
//                                          );
//                                        } else {
//                                          Flushbar(
//                                            title: "Cannot launch PlayStore",
//                                            message: "Please search for \"Honestlyy\" App on Play Store.",
//                                            duration: Duration(seconds: 8),
//                                          ).show(context);
//                                        }
//
//                                      },
//                                      child: Container(
//                                        width: 250,
//                                        child: Row(
//                                          mainAxisAlignment: MainAxisAlignment.center,
//                                          children: [
//                                            Image.asset("assets/playstore.png", height: 30, width: 30,),
//                                            Text(" "),
//                                            Text(" "),
//                                            Text("Open Play Store", style: TextStyle(fontSize: 15),)
//                                          ],
//                                        ),
//                                      )
//                                    ),
//                                  )
//
//                                ],
//                              ),
//                            );
//                          }
                          //web
                          //--------------------------------

                          return Box(
                            eyes: _eyes,
                            attitude: _attitude,
                            honesty: _honesty,
                            humour: _humour,
                            craziness: _craziness,
                            attractiveness: _attractiveness,
                            behaviour: _behaviour,
                            dressing: _dressing,
                            timespent: _timespent,
                            smile: _smile,
                          );
                        },
                      )
                    ],
                  ),
                ),

//----------------------------------------------------------------
              //web

//                Padding(
//                    padding: EdgeInsets.all(5),
//                    child: Material(
//                      shadowColor: Colors.blue,
//                      borderRadius: BorderRadius.circular(10),
//                      elevation: 10,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(10),
//                        child: Container(
////                          height: 40,
//                          color: Colors.yellow,
//                          child: Center(
//                              child: RaisedButton(
//
//                                onPressed: () {
//                                  //------------------------
//                                  //web
////                                Flushbar(
////                                  title: "Method: Manual (Web)",
////                                  message: "Please use the link \"honestlyy.app.web\" and use your nick \"$_name\".\n"
////                                      "or you can download our App \"Honestlyy\" from Play Store to get the direct sharing options.",
////                                )..show(context);
//                                  //web
//                                  //--------------------------------
//                                },
//                                child: Text("Share"),
//                              )
//                          ),
//                        ),
//                      ),
//                    )
//                ),
              //web
              //--------------------------------------------------------
//                Padding(
//                    padding: EdgeInsets.all(5),
//                    child: Material(
//                      shadowColor: Colors.blue,
//                      borderRadius: BorderRadius.circular(10),
//                      elevation: 10,
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(10),
//                        child: Container(
////                          height: 40,
//                          color: Colors.yellow,
//                          child: Center(
//                              child: RaisedButton(
//                                onPressed: ()async {
//                                  await FlutterShareMe()
//                                      .shareToWhatsApp( msg: "Hello");
//                                },
//                                child: Image.asset("assets/wp.png")
//                              )
//                          ),
//                        ),
//                      ),
//                    )
//                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Material(
                      shadowColor: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
//                          height: 40,
                          color: Colors.yellow,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                color: Colors.blue,
                                onPressed: ()async {
                                  var response = await FlutterShareMe().shareToSystem(msg: "Hey, checkout this Awesome website\n\nHonestlyy.web.app\n\nUse the Nick: $_name\n\nand give me Hearts 🧡 according to what you feel about me. 😅😅 (Be Honest 😜)\n\n"
                                      "Create your own account 👍👍 and share with your friends 😊😊 to know what they think about you. 😎😎\n\nHave Fun..🥰\nIt's gonna be Legendary! 😅😅");
                                  if (response == 'success') {
                                    print('navigate success');
                                  }
                                },
                                icon: Icon(Icons.share),
                                iconSize: 30,
                              ),
                              IconButton(
                                  onPressed: ()async {
                                    await FlutterShareMe()
                                        .shareToWhatsApp( msg: "Hey, checkout this Awesome website\n\nHonestlyy.web.app\n\nUse the Nick: *$_name*\n\nand give me Hearts 🧡 according to what you feel about me. 😅😅 (Be Honest 😜)\n\n"
                                        "Create your own account 👍👍 and share with your friends 😊😊 to know what they think about you. 😎😎\n\nHave Fun..🥰\nIt's gonna be Legendary! 😅😅"

                                    );
                                  },
                                  iconSize: 50,
                                  icon: Image.asset("assets/wp.png",)
                              )
                            ],
                          )
                        ),
                      ),
                    )
                ),
              ],
            )
          ],

        ),
      )
    );
  }
}


class Box extends StatefulWidget {
  List<int> eyes;// = [0,0,0,0,0];
  List<int> smile;//; = [0,0,0,0,0];
  List<int> humour;//; = [0,0,0,0,0];
  List<int> behaviour;//; = [0,0,0,0,0];
  List<int> attractiveness;// = [0,0,0,0,0];
  List<int> dressing;// = [0,0,0,0,0];
  List<int> honesty;// = [0,0,0,0,0];
  List<int> attitude;// = [0,0,0,0,0];
  List<int> craziness;// = [0,0,0,0,0];
  List<int> timespent;// = [0,0,0,0,0];

  Box({this.eyes, this.attitude, this.attractiveness, this.behaviour, this.craziness,
    this.dressing, this.honesty, this.humour, this.smile, this.timespent,
  });

  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  FirebaseUser _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _getUser()async{
    _user = await _auth.currentUser();
  }
  List name = [
    "eyes",
    "smile",
    "humour",
    "behaviour",
    "attractiveness",
    "dressing",
    "honesty",
    "attitude",
    "craziness",
    "timespent",
  ];

  int _x = 2;
  List<int> ad = [0,0,0,0,0,0,0,0,0,0];

  @override
  void initState() {
    _getUser();
    for(int i=0; i<ad.length; i++){
      ad[i] = Random().nextInt(_x);
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("widgeteyes: ${widget.eyes.toString()}");
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[0].toUpperCase()}"),),
//                        Text(widget.eyes.toString()),
                      ],
                    )
                ),
                Graph(list: widget.eyes,),
                MoreInfoButton(user: _user, param: 'eyes',),
              ],
            ),
          ),
        ),
        (ad[0]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[1].toUpperCase()}"),),
//                        Text(widget.smile.toString()),
                      ],
                    )
                ),
                Graph(list: widget.smile),
                MoreInfoButton(user: _user, param: 'smile',),
//                MoreInfo(),//web
              ],
            ),
          ),
        ),
        (ad[1]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[2].toUpperCase()}"),),
//                        Text(widget.humour.toString()),
                      ],
                    )
                ),
                Graph(list: widget.humour),
                MoreInfoButton(user: _user, param: 'humour',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[2]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[3].toUpperCase()}"),),
//                        Text(widget.behaviour.toString()),
                      ],
                    )
                ),
                Graph(list: widget.behaviour),
                MoreInfoButton(user: _user, param: 'behaviour',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[3]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[4].toUpperCase()}"),),
//                        Text(widget.attractiveness.toString()),
                      ],
                    )
                ),
                Graph(list: widget.attractiveness),
                MoreInfoButton(user: _user, param: 'attractiveness',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[4]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[5].toUpperCase()}"),),
//                        Text(widget.dressing.toString()),
                      ],
                    )
                ),
                Graph(list: widget.dressing),
                MoreInfoButton(user: _user, param: 'dressing',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[5]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[6].toUpperCase()}"),),
//                        Text(widget.honesty.toString()),
                      ],
                    )
                ),
                Graph(list: widget.honesty),
                MoreInfoButton(user: _user, param: 'honesty',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[6]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[7].toUpperCase()}"),),
//                        Text(widget.attitude.toString()),
                      ],
                    )
                ),
                Graph(list: widget.attitude),
                MoreInfoButton(user: _user, param: 'attitude',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[7]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[8].toUpperCase()}"),),
//                        Text(widget.craziness.toString()),
                      ],
                    )
                ),
                Graph(list: widget.craziness),
                MoreInfoButton(user: _user, param: 'craziness',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[8]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
        Padding(
          padding: EdgeInsets.all(5),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.all(3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text("${name[9].toUpperCase()}"),),
//                        Text(widget.timespent.toString()),
                      ],
                    )
                ),
                Graph(list: widget.timespent),
                MoreInfoButton(user: _user, param: 'timespent',),
//                MoreInfo(),
              ],
            ),
          ),
        ),
        (ad[9]==1)?
        AdmobBanner(
          adSize: AdmobBannerSize.FULL_BANNER,
          adUnitId: Ads[3+Random().nextInt(4)],
        ):
        Container(),
      ],
    );
  }
}

class Graph extends StatefulWidget {
  List<int> list;
  List<int> peyes;
  Graph({this.list, this.peyes});

  @override
  _GraphState createState() => _GraphState();
}



class _GraphState extends State<Graph> {

  double maxi;
  double mini;
  List _sampleList;

  @override
  void initState() {
    // TODO: implement initState
    _sampleList = widget.list;
//    print("maxi: $maxi");
    maxi = widget.list.reduce(max).toDouble();
//    print("maxi: $maxi");
//    print("mini: $mini");
    mini = widget.list.reduce(min).toDouble();
//    print("mini:  $mini");
//    print("peyes: ${widget.peyes.toString()}");
//    _sampleList = widget.list;

    print("widgeteyesssssss: ${widget.list.toString()}");
//    _sampleList[0] = _sampleList[0]*100/maxi;
//    _sampleList[1] = _sampleList[1]*100/maxi;
//    _sampleList[2] = _sampleList[2]*100/maxi;
//    _sampleList[3] = _sampleList[3]*100/maxi;
//    _sampleList[4] = _sampleList[4]*100/maxi;
//    for(int i=0; i<5; i++){
//      _sampleList[i]=(widget.list[i]*100~/maxi).toInt();
//    }
//    print("_samplelist: ${_sampleList.toString()}");
    print("widgeteyesssssssss: ${widget.list.toString()}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.pinkAccent,
      child: Transform.rotate(
        angle: pi,
        child: Container(
          height: 180,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Transform.rotate(
                    angle: pi,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite, size: 15, color: Colors.pink,),
                        Text("5", style: TextStyle(fontSize: 10)),
                      ],
                    )
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite, size: 15, color: Colors.pink,),
                        Text("4", style: TextStyle(fontSize: 10)),
                      ],
                    )
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite, size: 15, color: Colors.pink,),
                        Text("3", style: TextStyle(fontSize: 10)),
                      ],
                    )
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite, size: 15, color: Colors.pink,),
                        Text("2", style: TextStyle(fontSize: 10)),
                      ],
                    )
                  ),
                  Transform.rotate(
                    angle: pi,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite, size: 15, color: Colors.pink,),
                        Text("1", style: TextStyle(fontSize: 10)),
                      ],
                    )
                  ),
                ],
              ),
              Container(
                height: 2,
                width: 100,
                color: Colors.black26,
              ),
              Center(
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: widget.list[4]*100/maxi,//_sampleList[4].toDouble(),
                          color: Colors.red,
                        ),
                        Transform.rotate(
                          angle: 3.14,
                          child: Text("${(widget.list[4]).round()}", style: TextStyle(fontSize: 10),),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: widget.list[3]*100/maxi,
                          color: Colors.orangeAccent,
                        ),
                        Transform.rotate(
                          angle: 3.14,
                          child: Text("${(widget.list[3]).round()}", style: TextStyle(fontSize: 10),),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: widget.list[2]*100/maxi,
                          color: Colors.yellow,
                        ),
                        Transform.rotate(
                          angle: 3.14,
                          child: Text("${(widget.list[2]).round()}", style: TextStyle(fontSize: 10),),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: widget.list[1]*100/maxi,
                          color: Colors.lightGreenAccent,
                        ),
                        Transform.rotate(
                          angle: 3.14,
                          child: Text("${(widget.list[1]).round()}", style: TextStyle(fontSize: 10),),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 15,
                          height: widget.list[0]*100/maxi,
                          color: Colors.green,
                        ),
                        Transform.rotate(
                          angle: 3.14,
                          child: Text("${(widget.list[0]).round()}", style: TextStyle(fontSize: 10),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}

//---------------------------------------------------
//Mobile
class MoreInfoButton extends StatefulWidget {
  final String param;
  final FirebaseUser user;
  const MoreInfoButton({this.param, this.user});
  @override
  _MoreInfoButtonState createState() => _MoreInfoButtonState();
}

class _MoreInfoButtonState extends State<MoreInfoButton> {

  AdmobInterstitial _interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
//    Admob.initialize(Ads[2]);
    _interstitialAd = AdmobInterstitial(
      adUnitId: Ads[7],
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) _interstitialAd.load();
      },
    );
    _interstitialAd.load();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: Colors.pinkAccent,
      borderRadius: BorderRadius.circular(50),
      child: MaterialButton(
        onPressed: ()async{
          if (await _interstitialAd.isLoaded) {
            _interstitialAd.show();
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreInfo(user: widget.user, param: widget.param,)
            )
          );
        },
        child: Text("More Info"),
      ),
    );
  }
}




//----------------------------------------------------------
//web
//class MoreInfoButton extends StatefulWidget {
//  @override
//  _MoreInfoButtonState createState() => _MoreInfoButtonState();
//}
//
//class _MoreInfoButtonState extends State<MoreInfoButton> {
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      elevation: 10,
//      shadowColor: Colors.pinkAccent,
//      borderRadius: BorderRadius.circular(50),
//      child: MaterialButton(
//        onPressed: (){
//          Alert(
//            title: "Download Honestlyy App",
//            context: context,
//            content: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Text("to get Awesome Insights,"),
//                Text("Detailed Informations"),
//                Text("and for more FUN!"),
////                Text("FUN!")
//
//              ],
//            ),
//
//            buttons: [
//              DialogButton(
//                child: Text("Open Play Store"),
//                onPressed: ()async{
//                  String _url = "https://play.google.com/store/apps/details?id=com.arpit.honestlyy";
//                  if(await canLaunch(_url)){
//                    await launch(
//                      _url,
//                      forceWebView: false
//                    );
//                  } else {
//                    Flushbar(
//                      title: "Cannot launch PlayStore",
//                      message: "Please search for \"Honestlyy\" App on Play Store.",
//                      duration: Duration(seconds: 8),
//                    ).show(context);
//                  }
//
//                },
//              )
//            ]
//          ).show();
//
//        },
//        child: Text("More Info"),
//      ),
//    );
//  }
//}
//----------------------------------------------------------
//web
