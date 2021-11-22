import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'package:modu/src/authentication.dart';

import 'board.dart';
import 'message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('product');
  CollectionReference _collectionRefe =
  FirebaseFirestore.instance.collection('message');


  Future<List> getBoardData(int num) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final picked = allData[num];
    List fin = [
      picked["contents"].toString(),
      picked["writer"].toString(),
      picked["update"].toDate().toString(),
    ];
    return fin;
  }

  Future<List> getMessageData(int num) async {
    // Get docs from collection reference
    int counter =0;
    QuerySnapshot querySnapshot = await _collectionRefe.get();
    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var picked;
    for(int i=0; i <allData.length; i++) {
      final temp = allData[i];
      if ((temp["receiver"].toString()==auth.currentUser!.displayName.toString())&&counter==num){
      picked = temp;
      counter++;
      }
    }
    List fin = [
      picked["content"].toString(),
      picked["writer"].toString(),
      picked["receiver"].toString(),
      picked["created"].toDate().toString(),
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

  @override
  Widget build(BuildContext context) {
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
              leading: Icon(Icons.search, color: Colors.black),
              title: const Text('Search'),
              onTap: () {},
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              semanticLabel: 'bell',
            ),
            onPressed: () {},
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ProfilePage()));
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
                        Text(getUid(),
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text('소속그룹: Group1',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
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
                                  SizedBox(height:4),
                                  Text("  "+ url.data[0]),
                                  SizedBox(height:15),
                                  Text(" "+url.data[1]),
                                  SizedBox(height:2),
                                  Text(" "+url.data[2]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text(url.data[1]),
                                  Text(url.data[2]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text(url.data[1]),
                                  Text(url.data[2]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text(url.data[1]),
                                  Text(url.data[2]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text(url.data[1]),
                                  Text(url.data[2]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text("from: " + url.data[1]),
                                  Text(url.data[3]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text("from: " + url.data[1]),
                                  Text(url.data[3]),
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
                                children: [
                                  Text(url.data[0]),
                                  Text("from: " + url.data[1]),
                                  Text(url.data[3]),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text('오늘의 추천음악',
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(width: 150),
                  IconButton(
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {},
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
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 115.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
