import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'add.dart';
import 'edit.dart';
import 'model/mess.dart';
import 'model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';
import 'package:provider/provider.dart';



class MessagePage extends StatefulWidget {
  MessagePage({Key? key}) : super(key: key);
  @override
  MessagePageState createState()=>MessagePageState();
}
class MessagePageState extends State<MessagePage> {
  String dropdownValue = 'ASC';
  bool desc = false;

  List<Card> _buildListCards(BuildContext context, ApplicationState appState) {
    List<Mess> messages = appState.messMessages;


    if (messages == null || messages.isEmpty) {
      return const <Card>[];
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final ThemeData theme = Theme.of(context);

    return messages.map((mess) {
      bool checker=((mess.receiver.toString()==auth.currentUser!.displayName.toString())||(mess.writer.toString()==auth.currentUser!.displayName.toString()));
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: checker ?Row(
          children: <Widget>[
            SizedBox(width: 12.0),
            Container(
              height: 150,
              child:
              Expanded(
              child:  Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          mess.content,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          "From: " +mess.writer,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "To: "+mess.receiver,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ) ,
            ),
          ],

        ) :null,
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
          ), onPressed: () {
          Navigator.pop(context);
        },
        ),
        title: Text('메시지',
            textAlign: TextAlign.center),

        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context)=>AddPage()),
              );
            },

          ),
        ],
      ),

      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children:<Widget>[
              Expanded(
                child: OrientationBuilder(
                  builder: (context,orientation){
                    return
                    ListView(
                      padding: const EdgeInsets.all(8),
                      children: _buildListCards(context,appState),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}