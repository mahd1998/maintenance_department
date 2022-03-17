import 'dart:ui';
import 'package:assessment_task/signup_screen.dart';
import 'package:assessment_task/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart';
import 'login_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

bool isLoading = false;   //create a variable to define wheather loading or not

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

//_____________________________

  final FirebaseAuth auth = FirebaseAuth.instance;
  static late int count;
  static List<String> description = [];

    //________________________________________
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  setState(() {});
                  SystemNavigator.pop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  //________________________________________
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final _firestore = FirebaseFirestore.instance;
    var collection = FirebaseFirestore.instance.collection('trackingNumbers');
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('trackingNumbers');
    final User? gUser = auth.currentUser;
    String? photoUrl = gUser?.photoURL;
    late bool ready;
    late String Ready;
    //____________________________________
    Future<void> getCases() async {
      await FirebaseFirestore.instance.collection("Users")
          .doc(gUser?.uid).snapshots().listen((event) {
        setState(() {
          count = event.get("cases");
        });
      });
    }
    getCases();
    //__________________________________________
    Future<String> setdesc(String desc) async {
      late String descr = '';
      await FirebaseFirestore.instance.collection("trackingNumbers")
          .doc(desc).snapshots().listen((event) {
          description.add(event.get("description"));

        setState(() {
          descr = event.get("description");
        });
      });
      return descr;
    }
    Future<void> newadder() async {
      var coll = FirebaseFirestore.instance.collection('Users').doc(gUser?.uid).collection('trackingNum');
      var querySnapshot = await coll.get();
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        for(int i = 1 ; i <= count ; i++){
          //description.add(data['${i.toString()}']);
        }
      }
    }
    newadder();
       debugPrint(description[0]);
       debugPrint(description[1]);

    getCases();
    //_______________________________________
    Future<String>getReady(dynamic trackingNumber) async {
      late bool ready;
      late String Ready;
      await FirebaseFirestore.instance.collection("trackingNumbers").doc(trackingNumber).snapshots().listen((event) {
        setState(() {
          ready = event.get("ready");
        });
      });
      String isReady(bool ready){
        if(ready == true){
          Ready = "ready";
          return "ready";
        }else{
          Ready = "Not Ready";
          return "not Ready";
        }
      }
      return Ready;
    }
    //____________________________

  //__________________________________
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xff09031D),
        appBar: AppBar(
          title: Text("SmartTablet"),
          elevation: 0,
          backgroundColor: Color(0xff09031D),
          actions: <Widget>[],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff6D0E85), Color(0xff4059f1)],
                        begin: Alignment.bottomRight,
                        end: Alignment.centerLeft)),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Track your device'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              ListTile(
                title: const Text('LogOut',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  setState(() {});
                  ProgressDialog pr = ProgressDialog(context);
                  pr = ProgressDialog(context,
                      type: ProgressDialogType.Normal,
                      isDismissible: true,
                      showLogs: true);
                  if (gUser != null) {
                    final snackBar = SnackBar(
                        duration: const Duration(seconds: 1, milliseconds: 10),
                        content: Text('logged out from ${gUser.email}'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (gUser == null) {
                    final snackBar = SnackBar(
                        duration: const Duration(seconds: 1, milliseconds: 10),
                        content: Text('no such a user logged in'));
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 17.0, top: 7),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: CachedNetworkImage(
                        imageUrl: "$photoUrl",
                        fit: BoxFit.cover,
                        placeholder: (context, photoUrl) => Center(
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: new CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, photoUrl, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 38.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${gUser?.displayName}',
                          textWidthBasis: TextWidthBasis.longestLine,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        // Padding(
                        //     padding: const EdgeInsets.only(top: 8.0),
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: <Widget>[
                        //         Icon(Icons.location_on,
                        //         color: Colors.white, size:17),
                        //         // Padding(
                        //         //   padding: const EdgeInsets.only(left :8.0),
                        //         //   child: Text('Amman_JO',
                        //         //     style: TextStyle(
                        //         //       color: Colors.white,
                        //         //       wordSpacing: 2,
                        //         //       letterSpacing: 4,
                        //         //     )
                        //         //
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0, left: 20.0, top: 15, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${gUser?.email}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          )),
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    width: 0.2,
                    height: 22,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(33)),
                        gradient: LinearGradient(
                            colors: [Color(0xff6D0E85), Color(0xff4059f1)],
                            begin: Alignment.bottomRight,
                            end: Alignment.centerLeft)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      onPressed: () async =>
                          await FlutterPhoneDirectCaller.callNumber(
                              '962797699348'),
                      child: const Text('Call Us',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(34))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, left: 20, bottom: 5),
                        child: GradientText(
                          'Your tickets:',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                          colors: [
                            Color(0xff6D0E85),
                            Color(0xff4059f1),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                              child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: 320,
                                  child:StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('Users').doc(gUser?.uid).collection('trackingNum').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) return new Text('Loading...');
                                      final data = snapshot.requireData;
                                      final dataCount = count;
                                      // for(int i = 1 ; i <= dataCount ; i++){
                                      //   setdesc("${snapshot.data?.docs[0]['${i.toString()}'].toString()}");
                                      // }
                                      return new ListView.builder(
                                    itemCount: dataCount,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                              (index + 1).toString() +
                                                  "-  ${snapshot.data?.docs[0]['${(index + 1).toString()}'].toString()}",
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                             new Text(
                                                "Status",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                             new Text(
                                                "ready",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          new Text(
                                            "Description:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          new Text(
                                            'descri',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "in service",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "No",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(right: 12, left: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(33)),
                                ),
                                height: 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Icon(Icons.home, color: Color(0xff434BE6),),
                                    // Icon(Icons.notifications_active,
                                    // color: Colors.grey.withOpacity(0.6)),
                                    SizedBox(
                                      width: 33,
                                    ),
                                    // Icon(Icons.person,
                                    //     color: Colors.grey.withOpacity(0.6)),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 18,
                                child: Container(
                                  height: 66,
                                  width: 66,
                                  child: IconButton(
                                    icon: const Icon(Icons.search_outlined,
                                        color: Colors.white, size: 26),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(55)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff6615C1),
                                        Color(0xff484FDE),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                      })
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
