import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'add.dart';
import 'edit.dart';
import 'messagewrite.dart';
import 'model/mess.dart';
import 'model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key}) : super(key: key);

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  String dropdownValue = 'ASC';
  bool desc = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> friendchecker(String friend) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('friends')
        .where("user_id", isEqualTo: auth.currentUser!.email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    bool checker = false;
    for (int i = 0; i < allData.length; i++) {
      print(friend);
      print(allData[0]["friends"]);
      if (friend == allData[0]["friends"].toString()) {
        checker = true;
      }
    }
    print("hello");
    return checker;
  }

  final _primaryController = TextEditingController();
  final _secondaryController = TextEditingController();

  List<Card> _buildListCards(BuildContext context, ApplicationState appState) {
    List<Mess> messages = appState.messMessages;

    if (messages == null || messages.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    List<String> redundant = [''];

    return messages.map((mess) {
      String temp;
      bool redun = true;
      if ((mess.writer.toString() == auth.currentUser!.displayName.toString()) &&
          (mess.receiver.toString() != auth.currentUser!.displayName.toString())) {
        temp = mess.receiver;
        for (int i = 0; i < redundant.length; i++) {
          if (redundant[i] == temp) {
            redun = false;
            break;
          } else if (redundant[i] != temp) {
            redun = true;
          }
        }
      } else if ((mess.writer.toString() != auth.currentUser!.displayName.toString()) &&
          (mess.receiver.toString() == auth.currentUser!.displayName.toString())) {
        temp = mess.writer;

        for (int i = 0; i < redundant.length; i++) {
          if (redundant[i] == temp) {
            redun = false;
            break;
          } else if (redundant[i] != temp) {
            redundant.add(temp);
            redun = true;
          }
        }
      } else
        temp = "";
      if (redun == true) redundant.add(temp);

      bool achecker = ((mess.receiver.toString() == auth.currentUser!.displayName.toString()) ||
          (mess.writer.toString() == auth.currentUser!.displayName.toString()));

      bool checker = achecker && redun;

      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: checker
            ? Row(
                children: <Widget>[
                  SizedBox(width: 12.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => MessageWritePage(
                                  message: mess, title: temp)));
                    },
                    child: Container(
                      height: 100,
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Text(
                                    mess.receiver,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('메시지', textAlign: TextAlign.center),
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
                        builder: (context, appState, _) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Email Address",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _primaryController,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Message Content",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _secondaryController,
                              ),
                            ),
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Send"),
                                    onPressed: () {
                                      appState.newmessage(_primaryController.text,_secondaryController.text);
                                      _primaryController.clear();
                                      _secondaryController.clear();
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
        label: const Text('Write a new message'),
        icon: const Icon(Icons.message),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
