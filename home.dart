import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modu/src/authentication.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              child: DrawerHeader(
                child: Container(
                  alignment: Alignment(-0.8, 0.8),
                  child: Text('Shortcut',
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.black),
              title: const Text('Search'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: const Text('Profile'),
              onTap: () {
                MaterialPageRoute<void>(
                  builder: (context) => ProfilePage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: const Text('Log Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              semanticLabel: 'bell',
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 120,
              //color: Colors.black,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        FirebaseAuth.instance.currentUser!.isAnonymous
                            ? 'Welcome Guest!'
                            : 'Welcome ${FirebaseAuth.instance.currentUser!.displayName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: ElevatedButton.icon(
                            icon: Icon(Icons.add_box_outlined,
                                color: Colors.black54),
                            label: Text(
                              '프로필',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(14.0),
                                        side:
                                        BorderSide(color: Colors.black))))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('소속그룹: Group1',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('소속그룹: Group1',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text('소속그룹: Group1',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ],
              ),


            ),



            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Text('자유게시판',
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(width: 200),
                IconButton(
                  icon: Icon(Icons.arrow_right_alt),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 20),
                Text('메시지', style: Theme.of(context).textTheme.headline5),
                SizedBox(width: 243),
                IconButton(
                  icon: Icon(Icons.arrow_right_alt),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 20),
                Text('오늘의 추천음악',
                    style: Theme.of(context).textTheme.headline5),
                SizedBox(width: 150),
                IconButton(
                  icon: Icon(Icons.arrow_right_alt),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 115.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ],



        ),
        ),

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
