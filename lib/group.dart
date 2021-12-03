import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  /*Future <bool> groupChecker () async{
    bool checker=true;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('group')
        .where("user_email", isEqualTo: auth.currentUser!.email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    if (allData==[]) {
      checker=false;
    }
    return checker;
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("소속 Group"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[],
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) => FutureBuilder(
                  future: appState.showGroup(),
                  builder: (BuildContext context, AsyncSnapshot url) {
                    if (url.hasData == false) {
                      return Container(
                        width: 115.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
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
                      return Column(
                          children: [
                            SizedBox(height: 10),

                            Text(url.data[0]['group_name'],
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            Text(
                              url.data[0]['instrument'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
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