import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../board.dart';
import '../home.dart';
import '../main.dart';
import 'widgets.dart';

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
  signOut,
  googleLogin,
  anonymousLogin,
}

class Authentication extends StatelessWidget {

  const Authentication({
    required this.loginState,
    required this.signOut,
  });

  final ApplicationLoginState loginState;
  final void Function() signOut;


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {

    switch (loginState) {

      case ApplicationLoginState.loggedOut:
        return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover,
                  ),
              ),
            child:Center(
              child:
              Column(
                  children: [
                    SizedBox(height:160),
                    Container(
                      width:350,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color:Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow:
                        [BoxShadow(color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,)]

                      ),
                        child: SizedBox(
                          width:100,
                          child:Image(image: AssetImage('assets/logo.png'),width:100,height:100),
                        ),


                    ),

                    SizedBox(height:130),

                    SizedBox(height:80),
                    SizedBox(
                      width: 300.0,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        primary:Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                        side: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      ),
                        child:Text("Logging in with Google",style:TextStyle(fontSize: 18,color: Colors.black)),
                        onPressed: () {
                          signInWithGoogle();
                          Navigator.pop(context);

                        },
                      ),
                    ),
              SizedBox(height:20),

              SizedBox(
                  width: 300.0,
                  height: 60.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:Colors.white,
                      shadowColor: Colors.black,
                      elevation: 4.0,
                      side: BorderSide(color: Colors.white, width: 2.0, style: BorderStyle.solid),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        ),

                      child:Text("Logging in as a guest",style:TextStyle(fontSize: 18,color: Colors.black)),
                      onPressed:(){
                        FirebaseAuth.instance.signInAnonymously();
                        Navigator.pop(context);
                      },
                    )
              ),

                  ]),
            )),
        );

      case ApplicationLoginState.loggedIn:
        FirebaseAuth.instance.currentUser!.isAnonymous
            ? FirebaseFirestore.instance
                      .collection('user')
                      .doc('${FirebaseAuth.instance.currentUser!.uid}')
                      .set(<String, dynamic>{
                    'status_message': 'I promise to take the test honestly before GOD',
                    'uid':FirebaseAuth.instance.currentUser!.uid,
                  })
            : FirebaseFirestore.instance
                    .collection('user')
                    .doc('${FirebaseAuth.instance.currentUser!.uid}')
                    .set(<String, dynamic>{
                'email': FirebaseAuth.instance.currentUser!.email,
                'name':FirebaseAuth.instance.currentUser!.displayName,
                'status_message': 'I promise to take the test honestly before GOD',
                'uid':FirebaseAuth.instance.currentUser!.uid,
                });
        return MyHomePage();
    }
    return BoardPage();
  }
}


class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Authentication(
        loginState: appState.loginState,
        signOut: appState.signOut,
      ),
    );
  }
}