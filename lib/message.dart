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
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future <String> friendfind() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('friends')
        .where("user_email", isEqualTo: auth.currentUser!.email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    String friend="";
    List halfData =[];
    for (int i = 0; i < allData.length; i++) {
      QuerySnapshot quer = await FirebaseFirestore.instance
          .collection('user')
          .where("email", isEqualTo: allData[i]["friends"])
          .get();
      halfData = quer.docs.map((doc) => doc.data()).toList();
    }
    return friend=halfData[0]["name"];
  }


  Future<List> friendlist() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('friends')
        .where("user_email", isEqualTo: auth.currentUser!.email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    List friends = ["<FRIENDS LIST>"];
    for (int i = 0; i < allData.length; i++) {
      QuerySnapshot quer = await FirebaseFirestore.instance
          .collection('user')
          .where("email", isEqualTo: allData[i]["friends"])
          .get();
      List halfData = quer.docs.map((doc) => doc.data()).toList();
      for (int i = 0; i < halfData.length; i++) {
        friends.add(halfData[i]["name"].toString());
      }
    }
    return friends;
  }

  final _secondaryController = TextEditingController();

  String dropdownValue = 'Friends';

  List<Card> _buildListCards(BuildContext context, ApplicationState appState) {
    List<Mess> messages = appState.messMessages;
    List<Mess> newmess =[];
    List<String> redundant=[];
    String temp ='';
    bool redun=false;

    if (messages == null || messages.isEmpty) {
      return const <Card>[];
    }

    for(int i=0; i< messages.length; i++) {


      if((messages[i].receiver.toString() ==
          auth.currentUser!.displayName.toString()) &&
          (messages[i].writer.toString() != auth.currentUser!.displayName.toString())) {
        temp=messages[i].writer;
      }
      else if((messages[i].receiver.toString() !=
          auth.currentUser!.displayName.toString()) &&
          (messages[i].writer.toString() == auth.currentUser!.displayName.toString())) {
        temp=messages[i].receiver;

      }
      for(int i=0; i<redundant.length;i++) {
        if(redundant[i]==temp) {
          redun=true;
          break;
        }else if (redundant[i]!=temp) {
          redun=false;
        }
      }
      if(redun==false) {
        redundant.add(temp);
        if(temp!="") {
          newmess.add(messages[i]);
        }
      }


    }





    return newmess.map((mess) {
      String name='';
      if(mess.receiver==auth.currentUser!.displayName.toString()) {
        name=mess.writer;
      } else if (mess.writer==auth.currentUser!.displayName.toString()) {
        name=mess.receiver;
      }
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Row(
                children: <Widget>[
                  SizedBox(width: 12.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => MessageWritePage(
                                  message: mess, title: name)));
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
                                    name,
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

      );
    }).toList();
  }

  ValueNotifier<String> va=ValueNotifier<String>("<FRIENDS LIST>");

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
                                  "Recepient",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            FutureBuilder(
                                future: appState.friendlist(),
                                builder: (BuildContext context, AsyncSnapshot url) {
                                  if (url.hasData == false) {
                                    return Container(
                                      alignment:Alignment.center,
                                      width: 150,
                                      height: 48,
                                      child: Text("Bringing Friends...")
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
                                    return
                                      ValueListenableBuilder<String>(
                                        builder: (BuildContext context, String vals, Widget? child) {
                                          return DropdownButton<String>(
                                            value: vals,
                                            icon: const Icon(Icons.arrow_drop_down_sharp),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            underline: Container(
                                              height: 2,
                                              color: Colors.black,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                va.value = newValue!;

                                              });
                                            },
                                            items: url.data.map<DropdownMenuItem<String>>((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),

                                          );
                                        },
                                        valueListenable: va,
                                      );
                                  }
                                }
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


                                child:TextFormField(
                                  controller: _secondaryController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text("Send"),
                                onPressed: () {
                                  appState.newmessage(va.value, _secondaryController.text);
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
