import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
            body: Center(
              child:
              Column(
                  children: [
                    SizedBox(height:100),
                    Container(
                      height:300,
                      width:400,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color:Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        height: 250,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color:Colors.white,
                          ),
                        ),
                        child: Image(image: AssetImage('assets/logo.png'),width: 300,height:100,fit:BoxFit.contain),
                      ),
                    ),

                    SizedBox(height:100),
                    OutlinedButton.icon(
                      icon: Icon(Icons.android,color: Colors.black),
                      label:Text("GOOGLE",style:TextStyle(color: Colors.black)),
                      onPressed: () {
                        signInWithGoogle();
                        Navigator.pop(context);
                      },
                    ),
                    OutlinedButton.icon(
                      icon: Icon(Icons.switch_account,color: Colors.black),
                      label:Text("   Guest   ",style:TextStyle(color: Colors.black)),
                      onPressed:(){
                        FirebaseAuth.instance.signInAnonymously();
                        Navigator.pop(context);
                      },
                    )

                  ]),
            ));

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