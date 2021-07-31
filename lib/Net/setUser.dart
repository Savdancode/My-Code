import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String> userSetup(String displayName, File? _image,String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  await firebase_storage.FirebaseStorage.instance
      .ref('upload/${_image!.path.split("/").last}')
      .putFile(_image);
  String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref('upload/${_image.path.split("/").last}')
      .getDownloadURL();
  String uid = auth.currentUser!.uid.toString();
  users
      .add(
        {
          'displayName': displayName,
          'uid': uid,
          'url': downloadURL,
          'email': email,
        },
      )
      .then((value) => 'Data has been submited!')
      .catchError((error) => 'Failed to add user: $error');
  return '';
}
