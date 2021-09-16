import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:propertymarket/navigator/bottom_navigation.dart';

class GoogleSignin extends StatefulWidget {
  @override
  _GoogleSigninState createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        signInWithGoogle().then((value){
          final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
          _firebaseMessaging.subscribeToTopic('user');
          _firebaseMessaging.getToken().then((value) {
            print(value);
            User user=FirebaseAuth.instance.currentUser;
            final databaseReference = FirebaseDatabase.instance.reference();
            databaseReference.child("userData").child(user.uid).set({
              'token': value,
              'id' : user.uid,
              'email': user.email,
              'username' : user.displayName,
              'profile': user.photoURL,
            }).then((value) => Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: BottomBar())));

          });
        });
      },
      child: Container(
          height: 50,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.center,
          margin: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google.png',
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "GOOGLE",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )),
    );

  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    GoogleSignInAccount googleUser = (await GoogleSignIn().signIn());

    // Obtain the auth details from the request
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<Null> signOutWithGoogle() async {
    // Sign out with firebase
    await FirebaseAuth.instance.signOut();
    // Sign out with google
    await GoogleSignIn().signOut();
  }


}