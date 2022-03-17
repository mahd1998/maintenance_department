import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:assessment_task/Widget/customClipper.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:assessment_task/main.dart';
import 'profile_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:assessment_task/util/database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:assessment_task/util/connection_provider.dart';
import 'package:assessment_task/util/no_internet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  _showDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("error"),
          content: new Text("Email or Password not correct"),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late String email;
  late String password;
  late String userEmail;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final User? gUser = auth.currentUser;

    final height = MediaQuery.of(context).size.height;
    void _onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading"),
              ],
            ),
          );
        },
      );
    }
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -MediaQuery.of(context).size.height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: Container(
                child: Transform.rotate(
              angle: -pi / 3.5,
              child: ClipPath(
                clipper: ClipPainter(),
                child: Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffE6E6E6),
                        Color(0xff14279B),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: height * .2),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Smart',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff14279B),
                        ),
                        children: [
                          TextSpan(
                            text: 'Tablets',
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ]),
                  ),
                  SizedBox(height: 50),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Email Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                                controller: emailController,
                                obscureText: false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                                onChanged: (value) {
                                  email = value;
                                }
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                                onChanged: (value) {
                                password = value;}
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                        setState(() {});
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        setState(() {});
                        ProgressDialog pr = ProgressDialog(context);
                        pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
                        if (user != null) {
                          await pr.show();

                          final snackBar = SnackBar(
                              duration: const Duration(seconds: 1,milliseconds: 10),
                              content: Text('logged in'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),

                            ),
                          );
                        }
                      }
                      catch (e) {
                        late String errorMessage = e.toString();
                        late String errormsg;
                        switch(errorMessage){
                          case "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.":{
                            errormsg = "wrong email or password";
                          }
                          break;

                          case "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.":{
                            errormsg = "There is no user record corresponding to this identifier.";
                          }
                          break;

                          case "[firebase_auth/unknown] Given String is empty or null":{
                            errormsg = "please write your email and password ";
                          }
                          break;

                          case "[firebase_auth/invalid-email] The email address is badly formatted.":{
                              errormsg = "please write your email correctly";
                            }
                            break;

                          default: {
                            errormsg = errorMessage;
                          }
                          break;

                        }
                        print(e);
                        AlertDialog alert = AlertDialog(
                          title: Text('Error'),
                          content: Text('$errormsg'),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff14279B),
                            Color(0xff14279B),
                          ],
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: height * .005),

                  SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () async {

                      try {

                        if (gUser == null) {
                          await signInWithGoogle();
                          setState(() {});

                          ProgressDialog pr = ProgressDialog(context);
                          pr = ProgressDialog(
                              context, type: ProgressDialogType.Normal,
                              isDismissible: true,
                              showLogs: true);

                          await pr.show();
                          final snackBar = SnackBar(
                              duration: const Duration(
                                  seconds: 1, milliseconds: 10),
                              content: Text('logged in'));
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBar);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        }
                      }
                      catch (e) {
                        late String errorMessage = e.toString();
                        print(e);
                      }
                      if(gUser != null){
                        ProgressDialog pr = ProgressDialog(context);
                        pr = ProgressDialog(
                            context, type: ProgressDialogType.Normal,
                            isDismissible: true,
                            showLogs: true);

                        await pr.show();
                        final snackBar = SnackBar(
                            duration: const Duration(
                                seconds: 1, milliseconds: 10),
                            content: Text('logged in'));
                        ScaffoldMessenger.of(context).showSnackBar(
                            snackBar);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      }
                    },
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     debugPrint(gUser?.email);
                  //     debugPrint(gUser?.displayName);
                  //     debugPrint(gUser?.photoURL);
                  //
                  //     await FirebaseAuth.instance.signOut();
                  //       userEmail = '';
                  //       await GoogleSignIn().signOut();
                  //       setState(() {});
                  //       ProgressDialog pr = ProgressDialog(context);
                  //       pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
                  //       if (gUser != null) {
                  //
                  //         final snackBar = SnackBar(
                  //             duration: const Duration(seconds: 1,milliseconds: 10),
                  //             content: Text('logged out from ${gUser.email}'));
                  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  //       }
                  //       if(gUser == null){
                  //         final snackBar = SnackBar(
                  //             duration: const Duration(seconds: 1,milliseconds: 10),
                  //             content: Text('no such a user logged in'));
                  //       }
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     padding: EdgeInsets.symmetric(vertical: 15),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(5)),
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //             color: Colors.grey.shade200,
                  //             offset: Offset(2, 4),
                  //             blurRadius: 5,
                  //             spreadRadius: 2)
                  //       ],
                  //       gradient: LinearGradient(
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //         colors: [
                  //           Color(0xff14279B),
                  //           Color(0xff14279B),
                  //         ],
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'SignOut from Google',
                  //       style: TextStyle(fontSize: 20, color: Colors.white),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * .055),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don\'t have an account ?',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Register',
                            style: TextStyle(
                                color: Color(0xff14279B),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                      child:
                          Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    ),
                    Text('Back',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
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
    userEmail = googleUser!.email;
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
