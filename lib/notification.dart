import 'dart:core';

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
        actions: <Widget>[],
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
                            for (var i = 0; i < url.data.length; i++) Container(
                              width: 400.0,
                              margin: EdgeInsets.all(5),
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
                                  SizedBox(height:15),
                                  Text(url.data[i]['content'],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                  SizedBox(height:15),
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
