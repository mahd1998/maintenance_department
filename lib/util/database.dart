import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference smtCollection = FirebaseFirestore.instance.collection('Users');
  Future updateUserData(String name, String email, num cases) async {
    return await smtCollection.doc(uid).set({
      'name' : name,
      'Email' : email,
    });
  }
}