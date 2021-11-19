import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'board.dart';
import 'main.dart';
import 'model/product.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  final Product product;
  EditPage({Key? key, required Product this.product}) : super(key: key);

  @override
  EditPageState createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  late Product product = widget.product;
  final picker = ImagePicker();

  final _productnameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    _productnameController.text = product.title;
    _descriptionController.text = product.contents;
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          child:Text('close',style:TextStyle(color: Colors.black)),
          onPressed: (){
            Navigator.pop(context);
          },
        ),

        title: Text('Edit',textAlign: TextAlign.center),
        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) =>
            TextButton(
              child:Text('Save',style:TextStyle(color: Colors.white)),
              onPressed: () {
                appState.edit(product.id,_productnameController.text, _descriptionController.text);

                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context)=>BoardPage()),
                );
              },
            ),
          ),
        ],


      ),
      body: ListView(
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(200, 0.0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.black,
                onPressed: () {
                },
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: TextField(
                    controller: _productnameController,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: TextField(
                    controller: _descriptionController,
                  ),
                ),
              ],
            )
          ]
      ),
    );
  }
}

