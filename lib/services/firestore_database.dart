import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myref/services/firebase_path.dart';
import 'package:myref/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _firestoreService = FirestoreService.instance;

  // Insert User Document
  Future<void> setUserDoc(String uid) async => await _firestoreService.set(
      path: FirestorePath.user(uid),
      data: {
        'uid' : uid,
        'r_date': documentIdFromCurrentDate()
      }
  );

}