import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modu/profile.dart';
import 'add.dart';
import 'edit.dart';
import 'model/music.dart';
import 'model/product.dart';
import 'model/comment.dart';
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

class MusicHomePage extends StatefulWidget {
  MusicHomePage({Key? key}) : super(key: key);
  @override
  MusicHomePageState createState()=>MusicHomePageState();
}
class MusicHomePageState extends State<MusicHomePage> {
  String dropdownValue = 'ASC';
  bool desc = false;

  List<Card> _buildGridCards(BuildContext context, ApplicationState appState) {
    List<Music> musics = appState.musicList;

    if (musics.isEmpty) {
      return const <Card>[];
    }

    return musics.map((music) {
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: ClipRRect(
                borderRadius:BorderRadius.circular(8.0),
                child: Image.network(
                  music.imageUrl,
                  fit: BoxFit.contain,
                  width: 100,),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
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
                              music.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              music.artist,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
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
                                    child: const Text('listen',
                                      style : TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                      ),
                                    ),

                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(builder: (context)=>MusicDetailPage(music: music)),
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
        title: Text('음악추천',
            textAlign: TextAlign.center),
      ),

      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            children:<Widget>[
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

class MusicDetailPage extends StatefulWidget  {
  final Music music;
  MusicDetailPage({Key? key, required Music this.music}) : super(key: key);

  @override
  MusicDetailPageState createState() => MusicDetailPageState(this.music);
}
class MusicDetailPageState extends State<MusicDetailPage> {
  late Music music;
  late List<Comment> comments =[];
  late int price;
  late List likeList;
  late bool liked;
  late int count;
  bool showComments = false;
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  MusicDetailPageState(Music music){
    this.music = music;
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

        title: Text('Player',textAlign: TextAlign.center),
      ),

      body: Consumer<ApplicationState>(

        builder: (context, appState, _) =>Container(
            color: Colors.black,
            child:ListView(

            children: [
              Padding(

                padding:EdgeInsets.all(30),
                child: Expanded(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  <Widget>[
                      Image.network(
                        music.imageUrl,
                        fit: BoxFit.fitWidth,
                        width:320,
                        ),
                      Divider(),
                      Text(music.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:15),
                      ),
                      Text(music.artist,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:15),
                      ),
                      Text(music.genre,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:Colors.grey,
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(top:30),
                      ),
                      Row(
                          children:  <Widget>[

                            Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow,
                                  color:Colors.white),
                                  onPressed: () async {
                                    try {
                                      await _assetsAudioPlayer.open(
                                        Audio.network(music.songUrl),
                                      );
                                    } catch (t) {
                                      //mp3 unreachable
                                    }
                                      _assetsAudioPlayer.play();
                                  },
                                ),
                            ),
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.stop,
                                    color:Colors.white),
                                onPressed: () {
                                    _assetsAudioPlayer.stop();
                                },

                              ),

                            ),
                          ],
                      ),



                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
      ),
    );
  }
}