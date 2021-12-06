
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String loc="";

  void getS() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .get().then((snapshot) {
      setState(() {
        s = snapshot.data()!['status_message'].toString();
        loc = snapshot.data()!['loc'].toString();
      });
    });
  }
  ProfilePageState(){
    getS();
  }


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
          Positioned(
            bottom: 20.0,
            left: 110,
            right: 30.0,
            child: SizedBox(
              height: 500.0,
              child: Card(
                //margin: EdgeInsets.zero,
                elevation: 3.0,
                color: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Container(),
              ),
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 90.0,
            right: 50,
            child: SizedBox(
              height: 500.0,
              child: Card(
                //margin: EdgeInsets.zero,
                elevation: 3.0,
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Container(),
              ),
            ),
          ),
          Positioned(
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

                            Text(loc,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              child: Text("location update",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),),
                              onPressed: () {
                                setState((){
                                  appState.updateloc(FirebaseAuth.instance.currentUser!.uid);
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
          ),
        ],
      ),
    );
  }
}