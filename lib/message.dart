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
    List<String> redundant=[''];

    return messages.map((mess) {
      String temp;
      bool redun=true;
      if((mess.writer.toString()==auth.currentUser!.displayName.toString())&&(mess.receiver.toString()!=auth.currentUser!.displayName.toString())) {
        temp = mess.receiver;
        for(int i=0;i<redundant.length;i++) {
          if(redundant[i]==temp) {
            redun = false;
            break;
          }
          else if(redundant[i]!=temp){
            redun = true;
          }
        }
      }
       else if ((mess.writer.toString()!=auth.currentUser!.displayName.toString())&&(mess.receiver.toString()==auth.currentUser!.displayName.toString())) {
        temp = mess.writer;

        for(int i=0;i<redundant.length;i++) {
          if(redundant[i]==temp) {
            redun=false;
            break;
          }
          else if (redundant[i]!=temp){
            redundant.add(temp);

            redun=true;
          }
        }
      }
        else
        temp="";
      if(redun==true)
        redundant.add(temp);

      bool achecker=((mess.receiver.toString()==auth.currentUser!.displayName.toString())||(mess.writer.toString()==auth.currentUser!.displayName.toString()));

      bool checker= achecker && redun;


      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: checker ?Row(
          children: <Widget>[
            SizedBox(width: 12.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (context)=>MessageWritePage(message: mess, title: temp)));
              },
              child: Container(
                height: 100,
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
                            SizedBox(height:20),
                            Text(
                              mess.receiver,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ) ,
              ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        label: const Text('Write a new message'),
        icon: const Icon(Icons.message),
        backgroundColor: Colors.grey,
      ),
    );
  }
}