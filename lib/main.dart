import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
            .orderBy('name', descending: false)
            .snapshots()
            .listen((snapshot) {
          _productMessages = [];
          for (final document in snapshot.docs) {
            _productMessages.add(
              Product(
                id: document.id,
                name: document.data()['name'] as String,
                description: document.data()['description'] as String,
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
        // to here
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _productMessages = [];
        _productSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;
  StreamSubscription<QuerySnapshot>? _productSubscription;
  List<Product> _productMessages = [];
  List<Product> get productMessages => _productMessages;

  void signOut() {
    FirebaseAuth.instance.signOut();
  }


  Future<DocumentReference> add(String name, String description) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }


    return FirebaseFirestore.instance
        .collection('product')
        .add(<String, dynamic>{
      'id': '',
      'name': name,
      'description': description,
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
          'name': name,
          'description': description,
          'update': FieldValue.serverTimestamp(),
          'UID':FirebaseAuth.instance.currentUser!.uid,
        });
    notifyListeners();
  }
  Future<void> sort(bool desc) async {
    _productSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('name', descending: desc)
        .snapshots()
        .listen((snapshot) {
      _productMessages = [];
      for (final document in snapshot.docs) {
        _productMessages.add(
          Product(
            id: document.id,
            name: document.data()['name'] as String,
            description: document.data()['description'] as String,
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





