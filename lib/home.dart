import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'package:modu/src/authentication.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'board.dart';
import 'calendar.dart';
import 'friends.dart';
import 'group.dart';
import 'main.dart';
import 'message.dart';
import 'model/music.dart';
import 'musichome.dart';
import 'notification.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('product');
  late String gen="";



  Future<List> getBoardData(int num) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final picked = allData[num];
    DateTime tim = DateTime.fromMicrosecondsSinceEpoch(
        picked["update"].microsecondsSinceEpoch);
    String formattedtim = DateFormat('MM/dd  (kk:mm)').format(tim);
    List fin = [
      picked["contents"].toString(),
      picked["writer"].toString(),
      formattedtim,
    ];
    return fin;
  }

  Future<String> getGroupName() async {
    QuerySnapshot quer = await FirebaseFirestore.instance
        .collection('group')
        .where("user_email", isEqualTo: auth.currentUser!.email.toString())
        .get();
    List allData = quer.docs.map((doc) => doc.data()).toList();
    String grpname = allData[0]['group_name'];
    return grpname;
  }

  Future<String> getInstrument() async {
    QuerySnapshot quer = await FirebaseFirestore.instance
        .collection('group')
        .where("user_email", isEqualTo: auth.currentUser!.email.toString())
        .get();
    List allData = quer.docs.map((doc) => doc.data()).toList();
    String ins = allData[0]['instrument'];
    return ins;
  }

  Future<List> getMessageData(int num) async {
    QuerySnapshot quer = await FirebaseFirestore.instance
        .collection('message')
        .where("receiver", isEqualTo: auth.currentUser!.displayName.toString())
        .get();
    List allData = quer.docs.map((doc) => doc.data()).toList();

    var picked = allData[num];
    DateTime tim = DateTime.fromMicrosecondsSinceEpoch(
        picked["created"].microsecondsSinceEpoch);
    String formattedtim = DateFormat('MM/dd  (kk:mm)').format(tim);
    if (num > allData.length) {
      return ['', '', ''];
    }

    List fin = [
      picked["content"].toString(),
      picked["writer"].toString(),
      picked["receiver"].toString(),
      formattedtim,
    ];

    return fin;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  String getEmail() {
    final User? user = auth.currentUser;
    final email = user!.email.toString();
    return email;
  }

  String getUid() {
    final User? user = auth.currentUser;
    final uid = user!.uid.toString();
    return uid;
  }

  List<String> duplicate = [''];

  late List<DocumentSnapshot> snap;
  int check = 0;

  Future<List> _randomMusic(int num, String tmp) async {
    final QuerySnapshot result =
    await FirebaseFirestore.instance
        .collection('music').where('genre', isEqualTo:tmp).get();

    final List<DocumentSnapshot> documents = result.docs;
    if (check == 0) {
      documents.shuffle();
      snap = documents;
      check = 1;
    }
    List fin = [
      snap[num]["artist"].toString(),
      snap[num]["imageUrl"].toString(),
      snap[num]["title"].toString(),
    ];
    return fin;
  }

  Future<void> getUserGen() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    QuerySnapshot quer = await FirebaseFirestore.instance.collection('user').where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    List allData = quer.docs.map((doc) => doc.data()).toList();
    gen= allData[0]['genre'];
  }

  @override
  Widget build(BuildContext context) {
    getUserGen();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: DrawerHeader(
                child: Container(
                  alignment: Alignment(-0.8, 0.8),
                  child: Text('Shortcut',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.black),
              title: const Text('Friends'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FriendsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts, color: Colors.black),
              title: const Text('Group'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GroupPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.black),
              title: const Text('Schedule'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: const Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[IconButton(
          icon: Icon(
            Icons.refresh,
            semanticLabel: 'refresh',
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              semanticLabel: 'bell',
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 120,
                //color: Colors.black,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Text(
                          FirebaseAuth.instance.currentUser!.isAnonymous
                              ? 'Welcome Guest!'
                              : 'Welcome ${FirebaseAuth.instance.currentUser!.displayName}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.add_box_outlined,
                                  color: Colors.black54),
                              label: Text(
                                '프로필',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(14.0),
                                          side: BorderSide(
                                              color: Colors.black))))),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(getEmail(),
                            style:
                            TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Consumer<ApplicationState>(
                          builder: (context, appState, _) => FutureBuilder(
                              future: appState.getInstrument(),
                              builder:
                                  (BuildContext context, AsyncSnapshot url) {
                                if (url.hasData == false) {
                                  return Container(
                                    width: 115.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
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
                                  return Text("악기: " + url.data,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white));
                                }
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        FutureBuilder(
                            future: getGroupName(),
                            builder: (BuildContext context, AsyncSnapshot url) {
                              if (url.hasData == false) {
                                return Container(
                                  width: 115.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
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
                                return Text("소속그룹: " + url.data,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white));
                              }
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text('자유게시판', style: Theme.of(context).textTheme.headline5),
                  SizedBox(width: 200),
                  IconButton(
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BoardPage()));
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getBoardData(0),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[2],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getBoardData(1),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[2],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getBoardData(2),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[2],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getBoardData(3),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[2],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getBoardData(4),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[2],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text('메시지', style: Theme.of(context).textTheme.headline5),
                  SizedBox(width: 243),
                  IconButton(
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => MessagePage()));
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getMessageData(0),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                  offset: Offset(10.0, 5.0),
                                  ),
                                ],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[3],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getMessageData(1),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[3],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getMessageData(2),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[3],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getMessageData(3),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[3],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: getMessageData(4),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),

                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Container(
                                    height: 50,
                                    child: Text("  " + url.data[0],
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: 105,
                                    child: Text(
                                      url.data[1],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text("          " + url.data[3],
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text('추천음악', style: Theme.of(context).textTheme.headline5),
                  SizedBox(width: 221),
                  IconButton(
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => MusicHomePage()));
                    },
                  ),
                ],
              ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) =>Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 170.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[

                    SizedBox(width: 10),
                FutureBuilder(
                        future: _randomMusic(0,gen),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    child: Image.network(url.data[1]),
                                  ),
                                  //Image.network(url.data[1]),
                                  SizedBox(height: 10),
                                  Text(url.data[2],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text(
                                    url.data[0],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: _randomMusic(1,gen),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    child: Image.network(url.data[1]),
                                  ),
                                  //Image.network(url.data[1]),
                                  SizedBox(height: 10),
                                  Text(url.data[2],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text(
                                    url.data[0],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: _randomMusic(2,gen),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    child: Image.network(url.data[1]),
                                  ),
                                  //Image.network(url.data[1]),
                                  SizedBox(height: 10),
                                  Text(url.data[2],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text(
                                    url.data[0],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: _randomMusic(3,gen),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    child: Image.network(url.data[1]),
                                  ),
                                  //Image.network(url.data[1]),
                                  SizedBox(height: 10),
                                  Text(url.data[2],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text(
                                    url.data[0],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    FutureBuilder(
                        future: _randomMusic(4,gen),
                        builder: (BuildContext context, AsyncSnapshot url) {
                          if (url.hasData == false) {
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  color: Colors.white,
                                ),

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
                            return Container(
                              width: 115.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,

                                ),

                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 8),
                                  Container(
                                    height: 100,
                                    child: Image.network(url.data[1]),
                                  ),
                                  //Image.network(url.data[1]),
                                  SizedBox(height: 10),
                                  Text(url.data[2],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),
                                  Text(
                                    url.data[0],
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                  ],
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}