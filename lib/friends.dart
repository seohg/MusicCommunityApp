import 'dart:core';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {

  final _friendsController = TextEditingController();
  int temp=0;

  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Friends"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: <Widget>[
        ],


      ),

      body: Center(
        child: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  FutureBuilder(
                      future: appState.showFriends(),
                      builder: (BuildContext context, AsyncSnapshot url) {
                        if (url.hasData == false) {
                          return Container(
                              alignment: Alignment.center,
                              width: 400.0,
                              height: 400,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text("BRINGING LIST OF FRIENDS!!",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center));
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
                                SizedBox(height:10),

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
                                      Text(temp.toString(),
                                          style: TextStyle(fontSize: 1, color: Colors.grey[300])),
                                      Text(url.data[i],
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                      SizedBox(height:15),
                                    ],
                                  ),
                                )
                              ]
                          );
                        }
                      }
                  ),
            )],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      Consumer<ApplicationState>(
                        builder: (context, appState, _) =>
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add with email", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),)
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _friendsController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Add"),
                                    onPressed: () {
                                      appState.friendadd(_friendsController.text);
                                      _friendsController.text = "";
                                      setState(() {
                                        temp++;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                      ),
                    ],
                  ),
                );
              });
        },
        label: const Text('Add a new friend'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}