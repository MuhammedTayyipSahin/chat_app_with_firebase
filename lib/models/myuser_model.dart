import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class MyUser{
  final String userId;
  final String? email;
  final String userName;
  final String? profilUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? seviye;
  const MyUser({required this.userId,  this.createdAt,  this.email,  required this.userName, this.profilUrl, this.updatedAt, this.seviye});
  
  /* Map<String, dynamic> toMap(){
    return {
      'userId' : userId, 
      'email' : email,
      'userName' :  email != null ? email!.substring(0, email!.indexOf('@')) + Random().nextInt(99).toString() : "user",
      'profilUrl' : profilUrl,
      'createdAt' : FieldValue.serverTimestamp(),
      'updatedAt' : FieldValue.serverTimestamp(),
      'seviye' : seviye
    }; 
  } */
  /* Map<String, dynamic> toMap2(User firebaseUser){
    return {
      'userId' : firebaseUser.uid, 
      'email' : firebaseUser.email,
      'userName' :  email != null ? email!.substring(0, email!.indexOf('@')) + Random().nextInt(99).toString() : "user",
      'profilUrl' : profilUrl,
      'createdAt' : FieldValue.serverTimestamp(),
      'updatedAt' : FieldValue.serverTimestamp(),
      'seviye' : seviye
    }; 
  } */

  MyUser.fromMap(Map<String, dynamic> map):
    userId = map['userId'],
    userName = map['userName'],
    email = map['email'],
    seviye = map['seviye'],
    profilUrl = map['profilUrl'],
    updatedAt = (map['updatedAt'] as Timestamp).toDate(),
    createdAt = (map['createdAt'] as Timestamp).toDate();

    
  



}