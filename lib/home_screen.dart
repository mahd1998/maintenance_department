import 'package:assessment_task/profile_screen.dart';
import 'package:assessment_task/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Firestore = FirebaseFirestore.instance;
  late var trackingNumber;
  late String description;
  late bool ready;
  late String Ready;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  //____________________________________
  String isReady(){
    if(ready == true){
      Ready = "ready";
      return "ready";
    }else{
      Ready = "Not Ready";
      return "not Ready";
    }
  }
  //____________________________________
  void getCurrentUser() async {
    try{
      final User = await _auth.currentUser;
      if (User != null){
        loggedInUser = User;
        print(loggedInUser);
      }
    } catch (e){
      print(e);
    }
  }
  //__________________________________
  _showDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("$Ready"),
          content: new Text("$description"),
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
  //__________________________________

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(80),
                  ),
                  child: SizedBox(
                    // width: double.infinity,
                    // height: double.infinity,
                    child: Image.asset(
                      "assets/smtlogo.jpg",
                      //fit: BoxFit.fill,
                      height: 200.0,
                        width: 200.0,

                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    ),
                    color: Color(0x990061FF),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Tracking Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text(
                          //   "signed in as (${loggedInUser.email})",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 15),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          TextField(
                              onChanged: (value){
                                trackingNumber = value;
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter the number',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                  focusedBorder:OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                    borderRadius: BorderRadius.circular(15.0),),
                              ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: GestureDetector(
                      onTap: () async {
                        try{
                        await FirebaseFirestore.instance.collection("trackingNumbers").doc(trackingNumber).snapshots().listen((event) {
                          setState(() {
                            ready = event.get("ready");
                            description = event.get("description");
                          });
                          AlertDialog alert = AlertDialog(
                            title: Text('Your Device is ${isReady()}'),
                            content: Text('note: $description'),
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
                        });

                        }
                        catch(e){
                          //print(e);
                        }
                        setState(() {});
                        },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border:
                          Border.all(color: Color(0xff14279B), width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 0.26),
                            Text("Find",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFF1F3F6),
                                  fontFamily: "Poppins",
                                )),
                            SizedBox(width: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border:
                              Border.all(color: Color(0xff14279B), width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 0.26),
                            Text("Back",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF166FFF),
                                  fontFamily: "Poppins",
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 24,
                              color: Color(0xFF166FFF),
                            ),
                            SizedBox(width: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
