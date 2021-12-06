import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String notificationContent(String email, String type, String instrument) {
    String msg = "";
    if (type == 'join')
      msg = "\"" + email + "\" has sent a group join request";
    else if (type == 'edit')
      msg = "\"" +
          email +
          "\" has sent an instrument change request to " +
          instrument;
    else if (type == 'exit')
      msg = "\"" + email + "\" has sent a group exit request";
    else if (type == 'schedule')
      msg = "You have a schedule today! " ;

    return msg;
  }

  Future<String> nameFinder(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user')
        .where("email", isEqualTo: email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    return allData[0]['name'];
  }

  Future<String> groupFinder(String? email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('band')
        .where("captain_email", isEqualTo: email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    return allData[0]['group_name'];
  }

  Future acceptRequest(String email, String type, String instrument) async {
    if (type == 'join') {
      FirebaseFirestore.instance.collection('group').add(<String, dynamic>{
        'captain_email': FirebaseAuth.instance.currentUser!.email.toString(),
        'group_name': await groupFinder(FirebaseAuth.instance.currentUser!.email),
        'user_email': email,
        'user_name': await nameFinder(email),
        'instrument': instrument
      });
    } else if (type == 'edit') {
      FirebaseFirestore.instance
          .collection('group')
          .where('user_email', isEqualTo: email)
          .get()
          .then((snapshot) {
        snapshot.docs.single.reference.update({'instrument': instrument});
      });
    } else if (type == 'exit') {
      FirebaseFirestore.instance
          .collection('group')
          .where('user_email', isEqualTo: email)
          .get()
          .then((snapshot) {
        snapshot.docs.single.reference.delete();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Notifications"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              semanticLabel: 'refresh',
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) => FutureBuilder(
                  future: appState.showNotification(),
                  builder: (BuildContext context, AsyncSnapshot url) {
                    if (url.hasData == false) {
                      return Container(
                        width: 115.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],

                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      return Column(children: [
                        SizedBox(height: 10),
                        for (var i = 0; i < url.data.length; i++)
                          Container(
                            width: 400.0,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 2,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 15),
                                Text(notificationContent(
                                  url.data[i]['sender_email'],
                                  url.data[i]['type'],
                                  url.data[i]['instrument'],
                                ), textAlign: TextAlign.center,),
                                Text(
                                  url.data[i]['content'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(url.data[i]['type']!="schedule")
                                      RaisedButton(
                                        child: Text("Accept"),
                                        onPressed: () {
                                          acceptRequest(
                                            url.data[i]['sender_email'],
                                            url.data[i]['type'],
                                            url.data[i]['instrument'],
                                          );
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('notification')
                                                .where('created',
                                                isEqualTo: url.data[i]
                                                ["created"])
                                                .get()
                                                .then((snapshot) {
                                              snapshot.docs.single.reference
                                                  .delete();
                                            });
                                          });
                                          sleep(Duration(milliseconds: 200));
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotificationPage()));
                                        },
                                      ),
                                    if(url.data[i]['type']!="schedule")
                                      SizedBox(width: 15),
                                    if(url.data[i]['type']!="schedule")
                                      RaisedButton(
                                        child: Text("Decline"),
                                        onPressed: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('notification')
                                                .where('created',
                                                isEqualTo: url.data[i]
                                                ["created"])
                                                .get()
                                                .then((snapshot) {
                                              snapshot.docs.single.reference
                                                  .delete();
                                            });
                                          });
                                          sleep(Duration(milliseconds: 200));
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotificationPage()));
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                      ]);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}