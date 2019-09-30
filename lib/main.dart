import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(
      new MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleSignInAuthentication =
        await _googleSignInAccount.authentication;
    AuthCredential _credential = GoogleAuthProvider.getCredential(
      accessToken: _googleSignInAuthentication.accessToken,
      idToken: _googleSignInAuthentication.idToken,
    );

    FirebaseUser user = (await _auth.signInWithCredential(_credential)).user;
    print(user.displayName + "\n");
    return user;
    //FirebaseUser _user = await _auth
  }

  void _signOut(){
    _googleSignIn.signOut();
    print ("User SIGNED OUT!");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Google Sign in Test!"),
      ),
      body: new Container(
        padding: EdgeInsets.only(top: 30),
        alignment: Alignment.center,
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text("Sign in"),
              color: Colors.green,
              onPressed:(){ _signIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e));},
            ),
            new RaisedButton(
              child: new Text("Sign Out"),
              color: Colors.red,
              onPressed: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
