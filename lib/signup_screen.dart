import 'dart:math';

import 'package:assessment_task/Widget/customClipper.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/login_screen.dart';
import 'package:assessment_task/profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:assessment_task/util/database.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _firestore = FirebaseFirestore.instance;

  late String name;
  late String userEmail;
  late String password;
  late String password1;
  late String gname;
  late num cases;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final User? gUser = auth.currentUser;
    final height = MediaQuery.of(context).size.height;
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Full Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                onChanged: (value){
                                  name = value;
                                },
                                  controller: fullNameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Email address",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true))
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
                                  password = value;})
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "confirm your Password",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  controller: passwordController2,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                                  onChanged: (value) {
                                    password1 = value;}
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut();
                            setState(() {});
                            if(password == password1) {
                              final newUser = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              User? user = FirebaseAuth.instance.currentUser;
                              await DatabaseService(uid: user!.uid)
                                  .updateUserData('$name','${user.email}', cases);
                              await FirebaseFirestore.instance.collection("Users")
                                  .doc(user.uid).collection('trackingNum').doc(user.uid)
                                  .set({
                                '5': 65488,
                                '6': 26588,
                              },
                                SetOptions(merge: true),
                              );

                              if (newUser != null)
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ),
                                );
                            }
                            else{
                              AlertDialog alert = AlertDialog(
                                title: Text('Error'),
                                content: Text('password not same'),
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
                          }
                          catch (e) {
                            late String errorMessage = e.toString();
                            late String errormsg;
                            switch (errorMessage) {
                              case "[firebase_auth/unknown] Given String is empty or null":
                                {
                                  errormsg = "please fill all the blanks.";
                                }
                                break;

                              case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
                                {
                                  errormsg =
                                  "The email address is already in use.";
                                }
                                break;

                              case "[firebase_auth/invalid-email] The email address is badly formatted.":
                                {
                                  errormsg =
                                  "please write your email correctly";
                                }
                                break;

                              default:
                                {
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
                          'Register Now',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () async {
                        try {
                            await signInWithGoogle();
                            setState(() {});
                            User? gUser = FirebaseAuth.instance.currentUser;
                            gname = gUser!.displayName!;
                            await DatabaseService(uid: gUser.uid)
                                .updateUserData(gname, '${gUser.email}',cases);
                            await FirebaseFirestore.instance.collection("Users")
                                .doc(gUser.uid).collection('trackingNum').doc(gUser.uid)
                                .set({
                              '7': 77777,
                              '8': 88888,
                            },
                              SetOptions(merge: true),
                            );
                            late num trNumber;
                            await FirebaseFirestore.instance.collection("Users")
                                .doc(gUser.uid).collection('trackingNum').doc(gUser.uid).snapshots().listen((event) {
                              setState(() {
                                trNumber = event.get("1");
                              });
                            });
                            debugPrint("hello ooo  ${trNumber}");

                            ProgressDialog pr = ProgressDialog(context);
                            pr = ProgressDialog(
                                context, type: ProgressDialogType.Normal,
                                isDismissible: true,
                                showLogs: true,

                            );

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
                            pr.hide();

                        }
                        catch (e) {
                          late String errorMessage = e.toString();
                          print(e);
                        }
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

                      },
                    ),
                    SizedBox(height: height * .03),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already have an account ?',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Login',
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
                        child: Icon(Icons.keyboard_arrow_left,
                            color: Colors.black),
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
      ),
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
