import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myref/services/firestore_service.dart';

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _firestoreService = FirestoreService.instance;

}