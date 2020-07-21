import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flushbar/flushbar.dart';

class Answer extends StatefulWidget {
  String id;
  Answer({this.id});
  @override
  _AnswerState createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {

  @override
  void initState() {
    _getUser();
    _eyesR = 0;
    _smileR = 0;
    _humourR = 0;
    _behaviourR = 0;
    _attractivenessR = 0;
    _dressingR = 0;
    _honestyR = 0;
    _attitudeR = 0;
    _crazinessR = 0;
    _timespentR = 0;
    // TODO: implement initState
    super.initState();
  }

  String _name = " ";
  String _email;
  String _password;
  int _timeStamp;
  String _uid = " ";

  String _photoUrl;

  Future<void> _getUser() async {
    await Firestore.instance
        .collection("users")
        .where('nick', isEqualTo: widget.id)
        .snapshots()
        .listen((data) {
          print("id got is: ${widget.id}");
          print("number of docs: ${data.documents.length}");
          DocumentSnapshot ds = data.documents.last;
          _name = ds.data['nick'];
          _email = ds.data['email'];
          _password = ds.data['password'];
          _timeStamp = ds.data['timestamp'];
          _uid = ds.data['uid'];
          setState(() {

          });
    });
  }

  int _eyesR;
  int _smileR;
  int _humourR;
  int _behaviourR;
  int _attractivenessR;
  int _dressingR;
  int _honestyR;
  int _attitudeR;
  int _crazinessR;
  int _timespentR;
  TextEditingController nameC = TextEditingController();

  Future<void> _submit() async {
    print("started");
    if(_eyesR != 0 &&
    _smileR != 0 &&
    _humourR != 0 &&
    _behaviourR != 0 &&
    _attractivenessR != 0 &&
    _dressingR != 0 &&
    _honestyR != 0 &&
    _attitudeR != 0 &&
    _crazinessR != 0 &&
    _timespentR != 0 &&
    nameC.text.length>0){
      print("uid to be filled is $_uid");
     await Firestore.instance
          .collection("users")
          .document(_uid)
          .collection("entries")
          .add({
        'eyes': _eyesR,
        'smile': _smileR,
        'humour': _humourR,
        'behaviour': _behaviourR,
        'attractiveness': _attractivenessR,
        'dressing': _dressingR,
        'honesty': _honestyR,
        'attitude': _attitudeR,
        'craziness': _crazinessR,
        'timespent': _timespentR,
        'n': nameC.text,
        'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      });
     Flushbar(
       title: "Awesome",
       message: "Your response has been submitted\n\n"
           "Head on to the \"Create your own\" section to create your profile, and share with your friends to know what they think about you. :)",
       duration: Duration(seconds: 10),
     )..show(context);
          
    }
    else {
      Flushbar(
        title: "Incomplete",
        message: "Please fill the complete form",
        duration: Duration(seconds: 10),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
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
                          child: Center(
                            child: Text(_name,textScaleFactor: 1.5,),
                          ),
                        ),
                      )
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Material(
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.blue,
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.yellow,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Honestlyy choose the hearts for me",textScaleFactor: 1.1,),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("1 heart: Just nice",textScaleFactor: 1,),
                                Text("2 hearts: Great",textScaleFactor: 1,),
                                Text("3 hearts: Awesome",textScaleFactor: 1,),
                                Text("4 hearts: Breathtaking",textScaleFactor: 1,),
                                Text("5 hearts: Best in the world",textScaleFactor: 1,),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          ),
                        ),
                      )
                  )
              ),

              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Eyes", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _eyesR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _eyesR = rating.toInt();
                                    });
                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Smile", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _smileR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _smileR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Humour", style: TextStyle(fontSize: 15)),),
                              Center(
                                child: RatingBar(
                                  initialRating: _humourR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _humourR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Behaviour", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _behaviourR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _behaviourR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Attractiveness", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _attractivenessR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _attractivenessR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Dressing", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _dressingR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _dressingR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Honesty", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _honestyR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _honestyR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Attitude", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _attitudeR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _attitudeR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Craziness", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _crazinessR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _crazinessR = rating.toInt();
                                    });

                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Time Spent", style: TextStyle(fontSize: 15),),),
                              Center(
                                child: RatingBar(
                                  initialRating: _timespentR.toDouble(),
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 30,
                                  ratingWidget: RatingWidget(
                                    empty: Icon(Icons.favorite_border, color: Colors.red,),
                                    full: Icon(Icons.favorite, color: Colors.red,),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    setState(() {
                                      _timespentR = rating.toInt();
                                    });
                                  },
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(" "),
                              Center(child: Text("Name", style: TextStyle(fontSize: 15),),),
                              Container(
                                height: 80,
                                width: 250,
                                child: Center(
                                    child: TextField(

                                      controller: nameC,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Name"
                                      ),
                                    )
                                ),
                              ),
                              Text(" "),
                            ],
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Material(
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.blue,
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 40,
                          color: Colors.yellow,
                          child: Center(
                            child: RaisedButton(
                              onPressed: (){
                                _submit();
                              },
                              child: Text("Submit"),
                            )
                          ),
                        ),
                      )
                  )
              ),

            ],
          )
        ],
      ),
    );
  }
}


