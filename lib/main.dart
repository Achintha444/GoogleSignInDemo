import 'package:flutter/material.dart';

import './Choice.dart';

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

  // Map<String, Icon> _choices = {
  //   "Sign In": Icon(Icons.person_add),
  //   "Sign Out": Icon(Icons.delete_forever),
  // };

  List<Choice> _choices = [
    new Choice(
      choice: "Sign In",
      icon: Icon(Icons.person_add),
    ),
    new Choice(
      choice: "Sign Out",
      icon: Icon(Icons.delete_forever),
    ),
  ];

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

  void _signOut() {
    _googleSignIn.signOut();
    print("User SIGNED OUT!");
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Google Sign in Test!"),
          bottom: new TabBar(
            isScrollable: true,
            tabs: _choices.map(
              (Choice choice) {
                return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/2,
                  child: Tab(
                    text: choice.getChoice,
                    icon: choice.getIcon,
                  ),
                );
              },
            ).toList(),
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Center(
              child: new RaisedButton(
                child: new Text("Sign in"),
                color: Colors.green,
                onPressed: () {
                  _signIn()
                      .then((FirebaseUser user) => print(user))
                      .catchError((e) => print(e));
                },
              ),
            ),
            new Center(
              child: new RaisedButton(
                child: new Text("Sign Out"),
                color: Colors.red,
                onPressed: () {
                  _signOut();
                },
              ),
            ),
          ],
        ),
        // body: new Container(
        //   padding: EdgeInsets.only(top: 30),
        //   alignment: Alignment.center,
        //   child: new Column(
        //     children: <Widget>[
        //       new RaisedButton(
        //         child: new Text("Sign in"),
        //         color: Colors.green,
        //         onPressed: () {
        //           _signIn()
        //               .then((FirebaseUser user) => print(user))
        //               .catchError((e) => print(e));
        //         },
        //       ),
        //       new RaisedButton(
        //         child: new Text("Sign Out"),
        //         color: Colors.red,
        //         onPressed: () {
        //           _signOut();
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
