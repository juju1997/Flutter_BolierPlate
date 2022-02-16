import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> set( {
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,} ) async {
      final reference = FirebaseFirestore.instance.doc(path);
      print('$path: $data');
      await reference.set(data);
    }
}