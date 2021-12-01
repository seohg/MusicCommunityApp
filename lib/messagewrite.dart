import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'board.dart';
import 'main.dart';
import 'model/mess.dart';
import 'model/product.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MessageWritePage extends StatefulWidget {
  final Mess message;
  final String title;

  MessageWritePage({Key? key, required this.message, required this.title})
      : super(key: key);

  @override
  MessageWritePageState createState() =>
      MessageWritePageState(this.message, this.title);
}

class MessageWritePageState extends State<MessageWritePage> {
  late Mess message;
  late String title;

  late bool liked;
  late int count;

  MessageWritePageState(Mess message, String title) {
    this.message = message;
    this.title = title;
  }

  final _messageController = TextEditingController();

  messageSubmit(String message) {
    CollectionReference messages =
        FirebaseFirestore.instance.collection('message');
    FirebaseAuth auth = FirebaseAuth.instance;
    messages.add({
      'id': auth.currentUser!.uid.toString(),
      'content': message,
      'writer': auth.currentUser!.displayName.toString(),
      'receiver': title,
      'created': Timestamp.fromDate(DateTime.now()).toString()
    });

    return;
  }

  List<Card> _buildListCards(BuildContext context, ApplicationState appState) {
    List<Mess> messages = appState.messMessages;
    List<Mess> newmess = [];
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (messages == null || messages.isEmpty) {
      return const <Card>[];
    }
    for(int i=0; i< messages.length; i++) {
      bool achecker = ((messages[i].receiver.toString() ==
          auth.currentUser!.displayName.toString()) ||
          (messages[i].writer.toString() == auth.currentUser!.displayName.toString()));
      bool bchecker = ((messages[i].receiver.toString() == title) ||
          (messages[i].writer.toString() == title));
      if(achecker && bchecker) {
        newmess.add(messages[i]);

      }
    }

    return newmess.map((mess) {
      bool color = mess.writer != auth.currentUser!.displayName.toString();
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        color: color ? Colors.grey[350] : Colors.white,
        child: /*checker ?*/ Row(
                children: <Widget>[
                  Container(
                    height: 100,
                    color: color ? Colors.grey[350] : Colors.white,
                    child: Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    mess.content,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  "From: " + mess.writer,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "To: " + mess.receiver,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            //: null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(title, textAlign: TextAlign.center),
          actions: <Widget>[],
        ),
        body: Center(
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              children: <Widget>[
                Expanded(
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return ListView(
                        padding: const EdgeInsets.all(8),
                        children: _buildListCards(context, appState),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Consumer<ApplicationState>(
            builder: (context, appState, _) => Container(
                padding: MediaQuery.of(context).viewInsets,
                color: Colors.grey[300],
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        //messageSubmit(_messageController.text);
                        appState.messageadd(_messageController.text, title);
                        _messageController.text = "";
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                      ),
                    )))));
  }
}
