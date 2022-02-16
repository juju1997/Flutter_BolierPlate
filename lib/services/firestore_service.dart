import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<bool> set( {
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,} ) async {
      try{
        final reference = FirebaseFirestore.instance.doc(path);
        print('$path: $data');
        await reference.set(data);
        return true;
      }catch(e){
        return false;
      }
    }
}