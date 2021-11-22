import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'add.dart';
import 'edit.dart';
import 'model/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';
import 'package:provider/provider.dart';

var image ='';
class ProductClass {
  ProductClass({required this.description, required this.name, required this.url, required this.price});
  final String description;
  final String name;
  final String url;
  final int price;
}

class BoardPage extends StatefulWidget {
  BoardPage({Key? key}) : super(key: key);
  @override
  BoardPageState createState()=>BoardPageState();
}
class BoardPageState extends State<BoardPage> {
  String dropdownValue = 'ASC';
  bool desc = false;

  List<Card> _buildGridCards(BuildContext context, ApplicationState appState) {
    List<Product> products = appState.productMessages;

    if (products.isEmpty) {
      return const <Card>[];
    }

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 4.0, 10.0, 2.0),
                child: Expanded(
                  child:Row(
                    children:<Widget>[
                      Expanded(
                        flex:7,
                        child: Column(
                          // TODO: Align labels to the bottom and center (103)
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // TODO: Change innermost Column (103)
                          children:  <Widget>[
                            Text(
                              product.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.contents,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Expanded(
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:  <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding:EdgeInsets.zero,
                                      minimumSize: Size(20,40),

                                    ),
                                    child: const Text('more',
                                      style : TextStyle(
                                        color: Colors.black,
                                        fontSize: 8,
                                      ),
                                    ),

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(builder: (context)=>DetailPage(product: product)),
                                      );

                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        title: Text('자유게시판',
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
              DropdownButton<String>(
                value: dropdownValue,
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
                    dropdownValue = newValue!;
                    if (dropdownValue =='DESC')
                      desc = true;
                    else
                      desc = false;
                    appState.sort(desc);
                  });
                },
                items: <String>['ASC', 'DESC']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,

                    child: Text(value),
                  );
                }).toList(),
              ),
              Expanded(
                child: OrientationBuilder(
                  builder: (context,orientation){
                    return GridView.count(
                      crossAxisCount: orientation == Orientation.portrait?2:3,
                      padding: const EdgeInsets.all(16.0),
                      childAspectRatio: 8.0 / 9.0,
                      children: _buildGridCards(context, appState),
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

class DetailPage extends StatefulWidget {
  final Product product;
  DetailPage({Key? key, required Product this.product}) : super(key: key);

  @override
  DetailPageState createState() => DetailPageState(this.product);
}
class DetailPageState extends State<DetailPage> {
  late Product product;
  late int price;
  late List likeList;
  late bool liked;
  late int count;

  DetailPageState(Product product){
    this.product = product;
    likeList = this.product.likeList;
    count = likeList.length;
    likeList.contains(FirebaseAuth.instance.currentUser!.uid)
        ? liked = true
        : liked = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,

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

        title: Text('Detail',textAlign: TextAlign.center),

        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Row(
              children: [
                if(FirebaseAuth.instance.currentUser!.uid == product.UID)
                  IconButton(
                    icon: Icon(Icons.create),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute<void>(
                        builder: (context) => EditPage(product: product,),
                      ));

                    },
                  ),
                if (FirebaseAuth.instance.currentUser!.uid == product.UID)
                  IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: 25.0,
                    disabledColor: Colors.white,
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('product')
                          .where('id', isEqualTo: product.id)
                          .get()
                          .then((snapshot) {
                        snapshot.docs.single.reference.delete();
                      });

                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        ],


      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) =>ListView(
            children: [

              Padding(
                padding:EdgeInsets.all(30),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget>[

                      Padding(
                        padding:EdgeInsets.only(top:10),
                      ),

                      Padding(
                        padding:EdgeInsets.only(top:15),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  <Widget>[
                          Text(product.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:Colors.blue,
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.only(right:15),
                          ),
                          Text(product.contents,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:Colors.blue,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                            children:  <Widget>[
                              IconButton(
                            icon: Icon(Icons.thumb_up),
                            color: Colors.red,
                            iconSize: 30.0,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('product')
                                  .doc(product.id)
                                  .get()
                                  .then((doc){
                                List like = doc.get('likeList') as List;
                                like.contains(FirebaseAuth.instance.currentUser!.uid)
                                    ? liked = true
                                    : liked = false;
                              });
                              List<String> union = [
                                FirebaseAuth.instance.currentUser!.uid,
                              ];
                              if (liked == false){
                                FirebaseFirestore.instance
                                    .collection('product')
                                    .doc(product.id)
                                    .update({'likeList': FieldValue.arrayUnion(union),
                                });
                                count = count + 1;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('I LIKE IT!')));
                              }else{
                                count = count;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You can only do it once!!')));

                              }
                            },
                          ),
                          Text(count==null?'0':'${count}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:Colors.blue,
                            ),
                          ),],),
                        ],
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:10),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:10),
                      ),
                      const Divider(
                        height:1.0,
                        color:Colors.black,
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:10),
                      ),

                      Padding(
                        padding:EdgeInsets.only(top:10),
                      ),
                      Text('creator${product.UID}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:Colors.grey,
                        ),
                      ),
                      Text('${product.create.toDate()} created',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:Colors.grey,
                        ),
                      ),
                      Text('${product.update.toDate()} modified',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color:Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}