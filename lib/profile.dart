import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:location/location.dart';



class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late LocationData _locationData;
  late bool edit = true;
  final _statusController = TextEditingController();


  String s = "";
  String loc = "";

  Future<List> getGroup() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    QuerySnapshot quer = await FirebaseFirestore.instance.collection('group').where("user_email", isEqualTo: auth.currentUser!.email.toString()).get();
    List allData = quer.docs.map((doc) => doc.data()).toList();
    String ins= allData[0]['captain_email'];
    QuerySnapshot query = await FirebaseFirestore.instance.collection('band').where("captain_email", isEqualTo: ins).get();
    List fullData = quer.docs.map((doc) => doc.data()).toList();
    return fullData[0];
  }

  void getS() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .get()
        .then((snapshot) {
      setState(() {
        s = snapshot.data()!['status_message'].toString();
        loc = snapshot.data()!['loc'].toString();
      });
    });
  }

  ProfilePageState() {
    getS();
  }

  Alignment alignment = Alignment(0.0, 0.0);
  bool allowVerticalMovement = true;

  //int counter=0;
  ValueNotifier<int> counter = ValueNotifier<int>(0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[



          ValueListenableBuilder<int>(
            builder: (BuildContext context, int val, Widget? child) {
              if(counter.value==1) {
                return Positioned(
                  bottom: 50.0,
                  left: 60.0,
                  right: 60,
                  child: SizedBox(
                    height: 500.0,
                    child: Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Consumer<ApplicationState>(
                        builder: (context, appState, _) =>
                            ListView(children: [
                              SizedBox(height: 10),
                              Text(
                                "User Information",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              FirebaseAuth.instance.currentUser!.isAnonymous
                                  ? Image.network(
                                'https://handong.edu/site/handong/res/img/logo.png',
                                width: 400,
                                height: 240,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                '${FirebaseAuth.instance.currentUser!
                                    .photoURL}',
                                width: 100,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      Text(
                                        "UID",
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '<${FirebaseAuth.instance.currentUser!
                                            .uid}>',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Email",
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        FirebaseAuth.instance.currentUser!
                                            .isAnonymous
                                            ? 'Anonymous'
                                            : '${FirebaseAuth.instance
                                            .currentUser!.email}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Name",
                                        style: TextStyle(
                                          fontSize: 15,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        FirebaseAuth.instance.currentUser!
                                            .displayName.toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Location",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.underline,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      Text(
                                        loc,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,

                                        ),textAlign: TextAlign.center,
                                      ),
                                      TextButton(
                                        child: Text(
                                          "location update",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            appState.updateloc(
                                                FirebaseAuth.instance
                                                    .currentUser!.uid);
                                            appState.notifyListeners();
                                            getS();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                );
              }
              else if(counter.value==2) {
                return Positioned(
                  bottom: 50.0,
                  left: 60.0,
                  right: 60,
                  child: SizedBox(
                    height: 500.0,
                    child: Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Consumer<ApplicationState>(
                        builder: (context, appState, _) =>
                            FutureBuilder(
                                future: appState.getGroup(),
                                builder: (BuildContext context, AsyncSnapshot url) {
                                  print(url.data);
                                  if (url.hasData == false) {
                                    return Container(
                                        alignment:Alignment.center,
                                        width: 150,
                                        height: 48,
                                        child: Text("Calling Group Info...")
                                    );
                                  } else if (url.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Error: ${url.error}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    );
                                  } else {
                                    return ListView(children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Group Information",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      FutureBuilder(
                                          future: appState.imageUrl(),
                                          builder:
                                              (BuildContext context, AsyncSnapshot url) {
                                            if (url.hasData == false) {
                                              return Container(
                                                width: 115.0,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              );
                                            } else if (url.hasError) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Error: ${url.error}',
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              );
                                            } else {
                                              if (url.data != "") {
                                                return Image.network(url.data,
                                                    fit: BoxFit.fitWidth,
                                                    height: 200,
                                                    width: 200);
                                              } else {
                                                return Image.network(
                                                    "https://www.touchtaiwan.com/images/default.jpg",
                                                    fit: BoxFit.fitWidth,
                                                    height: 200,
                                                    width: 200);
                                              }
                                            }
                                          }),
                                      Container(
                                        padding: EdgeInsets.all(30),
                                        child: Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text(
                                                "Group Name",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[0]['group_name'],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Captain Email",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[0]['captain_email'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Captain Name",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[0]['captain_name'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Group Location",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[0]['loc'].toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }
                                }
                            ),


                      ),
                    ),
                  ),
                );
              }
              else if(counter.value==0) {
                return Positioned(
                  bottom: 50.0,
                  left: 60.0,
                  right: 60,
                  child: SizedBox(
                    height: 500.0,
                    child: Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Consumer<ApplicationState>(
                        builder: (context, appState, _) =>
                            FutureBuilder(
                                future: appState.getMusic(),
                                builder: (BuildContext context, AsyncSnapshot url) {
                                  print(url.data);
                                  if (url.hasData == false) {
                                    return Container(
                                        alignment:Alignment.center,
                                        width: 150,
                                        height: 48,
                                        child: Text("Calling Music Info...")
                                    );
                                  } else if (url.hasError) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Error',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    );
                                  } else {
                                    return ListView(children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Music Information",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Image.network(
                                        'https://i.pinimg.com/originals/db/f0/98/dbf098866a153bc938dce016f180e397.jpg',
                                        width: 200,
                                        height: 240,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(30),
                                        child: Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text(
                                                "My Music Genre",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[2],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "My Instrument",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[0],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Group's Music Genre",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                url.data[1],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }
                                }
                            ),


                      ),
                    ),
                  ),
                );
              }
              return Positioned(
                bottom: 50.0,
                left: 60.0,
                right: 60,
                child: SizedBox(
                  height: 500.0,
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Consumer<ApplicationState>(
                      builder: (context, appState, _) =>
                          ListView(children: [
                            SizedBox(height:220),
                            Center(child:Text(
                              "Click to Go Back to the Beginning",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),), ),

                          ]),
                    ),
                  ),
                ),
              );
            },
            valueListenable: counter,
          ),
          /*if(counter.value==1) Positioned(
            bottom: 50.0,
            left: 60.0,
            right: 60,
            child: SizedBox(
              height: 500.0,
              child: Card(
                elevation: 3.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Consumer<ApplicationState>(
                  builder: (context, appState, _) => ListView(children: [
                    SizedBox(height: 10),
                    Text(
                      "User Information",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    FirebaseAuth.instance.currentUser!.isAnonymous
                        ? Image.network(
                            'https://handong.edu/site/handong/res/img/logo.png',
                            width: 400,
                            height: 240,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            '${FirebaseAuth.instance.currentUser!.photoURL}',
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "UID",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '<${FirebaseAuth.instance.currentUser!.uid}>',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser!.isAnonymous
                                  ? 'Anonymous'
                                  : '${FirebaseAuth.instance.currentUser!.email}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser!.displayName.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              loc,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              child: Text(
                                "location update",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  appState.updateloc(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  appState.notifyListeners();
                                  getS();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ), */
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (counter.value<3)
            counter.value++;
          else
            counter.value=0;
          print(counter);
        },
        label: const Text('Move to Next Info'),
        icon: const Icon(Icons.arrow_right),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
