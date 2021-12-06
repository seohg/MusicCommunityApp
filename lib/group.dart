import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:modu/src/authentication.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';

class GroupPage extends StatefulWidget {
  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> groupChecker() async {
    bool checker = true;
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('group')
        .where("user_email", isEqualTo: auth.currentUser!.email)
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    if (allData.isEmpty) {
      checker = false;
    }
    return checker;
  }

  Future deleteGroup (String email) async {
    FirebaseFirestore.instance
        .collection('band')
        .where('captain_email', isEqualTo: email)
        .get()
        .then((snapshot) {
      snapshot.docs.single.reference.delete();
    });
    FirebaseFirestore.instance
        .collection('group')
        .where('captain_email', isEqualTo:email)
        .get()
        .then ((snapshot) {
      List<DocumentSnapshot> allDocs = snapshot.docs;
      for (DocumentSnapshot ds in allDocs){
        ds.reference.delete();
      }
    });
  }
  Future <List> distanceChecker() async{
    Location location = Location();
    LocationData _locationData;
    print("jell");

    _locationData = await location.getLocation();
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('band')
        .get();
    List allData = query.docs.map((doc) => doc.data()).toList();
    List tempData= ["<GROUP LIST>"];

    for(int i=0; i<allData.length;i++) {
      final Distance distance = new Distance();
      var loc= allData[i]['loc'];
      final num meter = distance(
          new LatLng(_locationData.latitude,_locationData.longitude),
          new LatLng(loc[0],loc[1])
      );
      if(meter<10.0) {
        tempData.add(allData[i]['group_name'].toString());
      }
    }
    print(tempData);

    return tempData;


  }

  Future changeInstrument(String email, String instrument) async {
    return FirebaseFirestore.instance
        .collection('group')
        .where('user_email', isEqualTo: email)
        .get()
        .then((snapshot) {
      snapshot.docs.single.reference.update({'instrument': instrument});
    });
  }


  ValueNotifier<String> va = ValueNotifier<String>("join");
  List<String> valcol = ["join", "change", "leave"];
  final _primaryController = TextEditingController();
  final _secondaryController = TextEditingController();
  final _tertiaryController = TextEditingController();
  final _quaternaryController = TextEditingController();

  ValueNotifier<String> initialValue=ValueNotifier<String>("<GROUP LIST>");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              semanticLabel: 'refresh',
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroupPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<ApplicationState>(
              builder: (context, appState, _) =>
                  FutureBuilder(
                      future: Future.wait(
                          [groupChecker(), appState.showGroup()]),
                      builder:
                          (BuildContext context, AsyncSnapshot<List<dynamic>> url) {
                        if (url.hasData == false) {
                          return Container(
                            width: 115.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10)),
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
                          if (url.data![0] == true) {
                            if (url.data![1][0]['captain_email'] != url.data![1][0]['user_email']) {
                              return Column(children: [
                                SizedBox(height: 30),
                                Text( url.data![1][0]['group_name'],
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                                SizedBox(height: 30),
                                Text(
                                  "Instrument: " +url.data![1][0]['instrument'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30),
                                SizedBox(height: 15),
                                ElevatedButton(

                                    child: Text(
                                      'Change Instrument Request',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                                        _primaryController
                                                            .clear();
                                                        _secondaryController
                                                            .clear();
                                                        _tertiaryController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                            Icons.close),
                                                        backgroundColor: Colors
                                                            .red,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<ApplicationState>(
                                                    builder:
                                                        (context, appState,
                                                        _) =>
                                                        Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  "Edit Request",
                                                                  style: TextStyle(
                                                                      fontSize: 24,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  "Preferred Instrument",
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: TextFormField(
                                                                controller:
                                                                _secondaryController,
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                                child: Text(
                                                                  "Request Details",
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: TextFormField(
                                                                controller:
                                                                _tertiaryController,
                                                                keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  4.0),
                                                              child: RaisedButton(
                                                                child: Text(
                                                                    "Send"),
                                                                onPressed: () {
                                                                  appState
                                                                      .groupRequest(
                                                                      "edit",
                                                                      "empty",
                                                                      _secondaryController
                                                                          .text,
                                                                      _tertiaryController
                                                                          .text);

                                                                  _secondaryController
                                                                      .clear();
                                                                  _tertiaryController
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      context);
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
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.black))))),
                                ElevatedButton(
                                    child: Text(
                                      'Exit From Group Request',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                                        _primaryController
                                                            .clear();
                                                        _secondaryController
                                                            .clear();
                                                        _tertiaryController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                            Icons.close),
                                                        backgroundColor: Colors
                                                            .red,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<ApplicationState>(
                                                    builder:
                                                        (context, appState,
                                                        _) =>
                                                        Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                                child: Text(
                                                                  "Exit Request",
                                                                  style: TextStyle(
                                                                      fontSize: 24,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                                child: Text(
                                                                  "Reason of Exit",
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                )),
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: TextFormField(
                                                                controller:
                                                                _tertiaryController,
                                                                keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  4.0),
                                                              child: RaisedButton(
                                                                child: Text(
                                                                    "Send"),
                                                                onPressed: () {
                                                                  appState
                                                                      .groupRequest(
                                                                      "exit",
                                                                      "empty",
                                                                      "",
                                                                      _tertiaryController
                                                                          .text);
                                                                  _tertiaryController
                                                                      .clear();
                                                                  Navigator.pop(
                                                                      context);
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
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.black))))),
                              ]);
                            } else  {
                              return Column(
                                children: [
                                  SizedBox(height: 30),
                                  Text( url.data![1][0]['group_name'],
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 30),
                                  Text(
                                    "Instrument: " +url.data![1][0]['instrument'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 30),
                                  SizedBox(height: 15),
                                  ElevatedButton(
                                      child: Text(
                                        'Change My Instrument',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                                          _primaryController
                                                              .clear();
                                                          _secondaryController
                                                              .clear();
                                                          _tertiaryController
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: CircleAvatar(
                                                          child: Icon(
                                                              Icons.close),
                                                          backgroundColor: Colors
                                                              .red,
                                                        ),
                                                      ),
                                                    ),
                                                    Consumer<ApplicationState>(
                                                      builder:
                                                          (context, appState,
                                                          _) =>
                                                          Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                  EdgeInsets.all(
                                                                      8.0),
                                                                  child: Text(
                                                                    "Preferred Instrument",
                                                                    style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    2.0),
                                                                child: TextFormField(
                                                                  controller:
                                                                  _secondaryController,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    4.0),
                                                                child: RaisedButton(
                                                                  child: Text(
                                                                      "Change"),
                                                                  onPressed: () {
                                                                    changeInstrument(url.data![1][0]['captain_email'].toString(),
                                                                        _secondaryController
                                                                            .text
                                                                    );

                                                                    _secondaryController
                                                                        .clear();
                                                                    _tertiaryController
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
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
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(Colors.black),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(5.0),
                                                  side: BorderSide(
                                                      color: Colors.black))))
                                  ),
                                  ElevatedButton(
                                      child: Text(
                                        'Delete My Group',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                                          _primaryController
                                                              .clear();
                                                          _secondaryController
                                                              .clear();
                                                          _tertiaryController
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: CircleAvatar(
                                                          child: Icon(
                                                              Icons.close),
                                                          backgroundColor: Colors
                                                              .red,
                                                        ),
                                                      ),
                                                    ),
                                                    Consumer<ApplicationState>(
                                                      builder:
                                                          (context, appState,
                                                          _) =>
                                                          Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                  EdgeInsets.all(
                                                                      8.0),
                                                                  child: Text(
                                                                    "Delete My Group",
                                                                    style: TextStyle(
                                                                        fontSize: 24,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  )),
                                                              Padding(
                                                                  padding:
                                                                  EdgeInsets.all(
                                                                      8.0),
                                                                  child: Text(
                                                                    "Are You Sure?",
                                                                    style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  )),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    4.0),
                                                                child: RaisedButton(
                                                                  child: Text(
                                                                      "Delete"),
                                                                  onPressed: () {
                                                                    deleteGroup(auth.currentUser!.email.toString());
                                                                    Navigator.pop(
                                                                        context);
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
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(Colors.black),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(5.0),
                                                  side: BorderSide(
                                                      color: Colors.black))))
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Center(
                              child: Column(children: [
                                SizedBox(height: 50),
                                Text("You are currently not in any Group.",style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                                SizedBox(height: 50),
                                ElevatedButton(
                                    child: Text(
                                      'Send Join Request',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                                        _primaryController
                                                            .clear();
                                                        _secondaryController
                                                            .clear();
                                                        _tertiaryController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                            Icons.close),
                                                        backgroundColor: Colors
                                                            .red,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<ApplicationState>(
                                                    builder:
                                                        (context, appState,
                                                        _) => SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  0),
                                                              child: Text(
                                                                "Join Request",
                                                                style: TextStyle(
                                                                    fontSize: 24,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  1.0),
                                                              child: Text(
                                                                "Group Email",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          FutureBuilder(
                                                              future: distanceChecker(),
                                                              builder: (BuildContext context, AsyncSnapshot url) {
                                                                if (url.hasData == false) {
                                                                  return Container(
                                                                      alignment:Alignment.center,
                                                                      width: 150,
                                                                      height: 48,
                                                                      child: Text("Bringing Groups...")
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
                                                                              initialValue.value = newValue!;
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
                                                                      valueListenable: initialValue,
                                                                    );
                                                                }
                                                              }
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  1.0),
                                                              child: Text(
                                                                "Instrument",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _secondaryController,
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  1.0),
                                                              child: Text(
                                                                "Request Content",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                1.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _tertiaryController,
                                                              keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                1.0),
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  "Send"),
                                                              onPressed: () {
                                                                appState.groupRequest(
                                                                    "join",
                                                                    initialValue.value,
                                                                    _secondaryController
                                                                        .text,
                                                                    _tertiaryController
                                                                        .text);
                                                                _primaryController
                                                                    .clear();
                                                                _secondaryController
                                                                    .clear();
                                                                _tertiaryController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.black))))),
                                ElevatedButton(
                                    child: Text(
                                      'Create Group',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                                        _primaryController
                                                            .clear();
                                                        _secondaryController
                                                            .clear();
                                                        _tertiaryController
                                                            .clear();
                                                        _quaternaryController
                                                            .clear();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                            Icons.close),
                                                        backgroundColor: Colors
                                                            .red,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<ApplicationState>(
                                                    builder:
                                                        (context, appState,
                                                        _) => SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child:Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                              child: Text(
                                                                "Group Creation",
                                                                style: TextStyle(
                                                                    fontSize: 24,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                              child: Text(
                                                                "Group Name",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _primaryController,
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: Text(
                                                                "Group Genre",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _secondaryController,
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: Text(
                                                                "Your Instrument",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _quaternaryController,
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                              child: Text(
                                                                "Group Description",
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                2.0),
                                                            child: TextFormField(
                                                              controller:
                                                              _tertiaryController,
                                                              keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                              maxLines: 2,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                4.0),
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  "Create"),
                                                              onPressed: () {
                                                                appState
                                                                    .createGroup(
                                                                    _primaryController
                                                                        .text,
                                                                    _secondaryController
                                                                        .text,
                                                                    _tertiaryController
                                                                        .text,
                                                                    _quaternaryController
                                                                        .text);
                                                                appState
                                                                    .getinGroup(
                                                                    _primaryController
                                                                        .text,
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .email
                                                                        .toString(),
                                                                    _quaternaryController
                                                                        .text,
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .displayName
                                                                        .toString(),
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .email
                                                                        .toString());
                                                                _primaryController
                                                                    .clear();
                                                                _secondaryController
                                                                    .clear();
                                                                _tertiaryController
                                                                    .clear();
                                                                _quaternaryController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Colors.black))))),
                              ]),
                            );
                          }
                        }
                      }),
            )
          ],
        ),
      ),
    );
  }
}