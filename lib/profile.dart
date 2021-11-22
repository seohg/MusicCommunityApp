import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}
class ProfilePageState extends State<ProfilePage> {
  late bool edit = true;
  final _statusController = TextEditingController();
  String s = "";
  void getS() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .get().then((snapshot) {
      setState(() {
        s = snapshot.data()!['status_message'].toString();
      });
    });
  }
  ProfilePageState(){
    getS();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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

        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) =>
                Row(
                  children: [

                  ],
                ),
          ),
        ],


      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) =>ListView(

          children: [
            FirebaseAuth.instance.currentUser!.isAnonymous
                ? Image.network('https://handong.edu/site/handong/res/img/logo.png',
              width: 400,
              height: 240,
              fit: BoxFit.cover,)
                : Image.network('${FirebaseAuth.instance.currentUser!.photoURL}',
              width: 300,
              height: 240,
              fit: BoxFit.cover,),

            Container(
              padding: EdgeInsets.all(30),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(top: 30),
                    ),

                    Container(
                      child:
                      Text('<${FirebaseAuth.instance.currentUser!.uid}>',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),

                    Text(
                      FirebaseAuth.instance.currentUser!.isAnonymous
                          ? 'Anonymous'
                          : '${FirebaseAuth.instance.currentUser!.email}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    if(!FirebaseAuth.instance.currentUser!.isAnonymous)
                      Text('${FirebaseAuth.instance.currentUser!.displayName}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    else
                      Text('Anonymous',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if ((!FirebaseAuth.instance.currentUser!.isAnonymous)&&(!edit))
                      TextField(
                        controller: _statusController,
                      )
                    else if((!FirebaseAuth.instance.currentUser!.isAnonymous)&&(edit))
                      Text(s,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    else
                      Text(s,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),


                    if ((!FirebaseAuth.instance.currentUser!.isAnonymous))
                      TextButton(
                        child: Text(edit?'edit':'save', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            if (edit == false) {
                              print("bye");
                              appState.profileEdit(FirebaseAuth.instance.currentUser!.uid,_statusController.text);
                              getS();
                              //appState.notifyListeners();
                              edit = true;
                            } else {
                              _statusController.text = s;
                              edit = false;
                            }
                          });

                        },
                      )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}