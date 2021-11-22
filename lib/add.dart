import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  final _productnameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: TextButton(
            child:Text('close',style:TextStyle(color: Colors.white)),
            onPressed: (){
              Navigator.pop(context);
            },
          ),

        title: Text('글 작성',textAlign: TextAlign.center),
        actions: <Widget>[
          Consumer<ApplicationState>(
          builder: (context, appState, _) =>
            Container(
            child: TextButton(
              child:Text('Save',style:TextStyle(color: Colors.white)),
              onPressed: (){
                appState.add(_productnameController.text, _descriptionController.text);
                Navigator.pop(context);
              },
            ),
          ),
          ),
        ],


      ),
      body: ListView(
          children: [

            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: TextField(
                    controller: _productnameController,
                    decoration: InputDecoration(
                      labelText: 'title',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Contents',
                    ),
                  ),
                ),
              ],
            )
          ]
      ),
    );
  }
}

