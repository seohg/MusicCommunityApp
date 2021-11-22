import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'model/mess.dart';
import 'model/product.dart';
import 'src/authentication.dart';

void main() {
  //Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          highlightColor: Colors.deepPurple,
        ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),

    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Authentication( //return from authentication.dart(loginpage, state)
        loginState: appState.loginState,
        signOut: appState.signOut,
      ),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _productSubscription = FirebaseFirestore.instance
            .collection('product')
            .orderBy('title', descending: false)
            .snapshots()
            .listen((snapshot) {
          _productMessages = [];
          for (final document in snapshot.docs) {
            _productMessages.add(
              Product(
                id: document.id,
                title: document.data()['title'] as String,
                contents: document.data()['contents'] as String,
                writer: document.data()['writer'] as String,
                UID: document.data()['UID'] as String,
                likeList: document.data()['likeList'] as List,
                create: document.data()['create'] as Timestamp,
                update: document.data()['update'] as Timestamp,
                sort: document.data()['sort'] as String,
              ),
            );
            FirebaseFirestore.instance.collection('product').doc(document.id).update({'id': document.id,});
          }
          notifyListeners();
        });
        _messageSubscription = FirebaseFirestore.instance
            .collection('message')
            .orderBy('created', descending: false)
            .snapshots()
            .listen((snapshot) {
          _messMessages = [];
          for (final document in snapshot.docs) {
            _messMessages.add(
              Mess(
                id: document.id,
                content: document.data()['content'] as String,
                writer: document.data()['writer'] as String,
                UID: document.data()['UID'] as String,
                created: document.data()['created'] as Timestamp,
                sort: document.data()['sort'] as String,
                receiver: document.data()['receiver'] as String,
              ),
            );
            FirebaseFirestore.instance.collection('message').doc(document.id).update({'id': document.id,});
          }
          notifyListeners();
        });

        // to here
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _productMessages = [];
        _productSubscription?.cancel();
        _messMessages=[];
        _messageSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;
  StreamSubscription<QuerySnapshot>? _productSubscription;
  StreamSubscription<QuerySnapshot>? _messageSubscription;
  List<Product> _productMessages = [];
  List<Product> get productMessages => _productMessages;
  List<Mess> _messMessages = [];
  List<Mess> get messMessages => _messMessages;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }


  Future<DocumentReference> add(String name, String description) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    String writer;
    writer = (FirebaseAuth.instance.currentUser!.isAnonymous ?'Anonymous'
        : FirebaseAuth.instance.currentUser!.displayName)!;


    return FirebaseFirestore.instance
        .collection('product')
        .add(<String, dynamic>{
      'id': '',
      'title': name,
      'contents': description,
      'writer':writer,
      'create': FieldValue.serverTimestamp(),
      'update': FieldValue.serverTimestamp(),
      'UID':FirebaseAuth.instance.currentUser!.uid,
      'likeList': List<dynamic>.empty(),
    });
  }
  Future<void> edit(String id,String name, String description)async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance
        .collection('product')
        .doc(id)
        .update({
      'title': name,
      'contents': description,
      'update': FieldValue.serverTimestamp(),
      'UID':FirebaseAuth.instance.currentUser!.uid,
    });
    notifyListeners();
  }
  Future<void> sort(bool desc) async {

    _productSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('title', descending: desc)
        .snapshots()
        .listen((snapshot) {
      _productMessages = [];
      for (final document in snapshot.docs) {
        _productMessages.add(
          Product(
            id: document.id,
            title: document.data()['title'] as String,
            contents: document.data()['contents'] as String,
            writer:document.data()['writer'] as String,
            UID: document.data()['UID'] as String,
            likeList: document.data()['likeList'] as List,
            create: document.data()['create'] as Timestamp,
            update: document.data()['update'] as Timestamp,
            sort: document.data()['sort'] as String,
          ),
        );
        FirebaseFirestore.instance.collection('product').doc(document.id).update({'id': document.id,});
      }
      notifyListeners();
    });
  }
  Future<void> profileEdit(String id,String status) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update({
      'status_message': status,
    });
    //notifyListeners();
  }

}