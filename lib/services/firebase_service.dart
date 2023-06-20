import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/models/message_model.dart';
import 'package:flutter_lovers_orgin/models/myuser_model.dart';

class DBfirestore{

  Future<MyUser?> saveUser(User user)async{
    
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set(
      {
      'userId' : user.uid, 
      'email' : user.email,
      'userName' :  user.email != null ? user.email!.substring(0, user.email!.indexOf('@')) + Random().nextInt(99).toString() : "user${Random().nextInt(9999)}",
      'profilUrl' : null,
      'createdAt' : FieldValue.serverTimestamp(),
      'updatedAt' : FieldValue.serverTimestamp(),
      'seviye' : null
      }
      );
    var documentSnapshot = await FirebaseFirestore.instance.doc("users/${user.uid}").get();
    var map = documentSnapshot.data();
    if(map != null){
        MyUser myUser = MyUser.fromMap(map); 
        return myUser;
    }else{
      return null;

    }

    
  
  }


  Future<MyUser?> readUser(User user)async{
    
    var documentSnapshot = await FirebaseFirestore.instance.doc("users/${user.uid}").get();
    var map = documentSnapshot.data();
    if(map != null){
        MyUser myUser = MyUser.fromMap(map); 
        return myUser;
    }else{
      return null;

    }
  }

  Future<bool> changeUserName(String userID, String newName)async{
      var snap = await FirebaseFirestore.instance.collection("users").where("userName", isEqualTo: newName).get();
       if(snap.docs.isEmpty){
         debugPrint("EŞLEŞME YOK");
         await FirebaseFirestore.instance.collection("users").doc(userID).update({'userName' : newName});
         return true;
       }else{
         debugPrint("EŞLEŞME VAR");
        return false;
      }
    } 

  Future<void> changeProfilePhotoUrl(String userId, String newUrl)async{
      await FirebaseFirestore.instance.collection("users").doc(userId).update({'profilUrl' : newUrl});

    }

    
  Future<List<MyUser>> getAllUsers()async{
   var querySnapshot  = await FirebaseFirestore.instance.collection("users").get(); 
    
    return querySnapshot.docs.map((e) => MyUser.fromMap(e.data())).toList();


  }

  Future<MyUser> getFriendUser(String userID)async{
    var querySnapshot = await FirebaseFirestore.instance.collection("users").doc(userID).get();
    return MyUser.fromMap(querySnapshot.data()!);
  }

  Future<void> sendMessage(MessageModel messageModel)async{
      var messageId = FirebaseFirestore.instance.collection("chats").doc().id;
      var myDocumentId = "${messageModel.fromWho}--${messageModel.toWho}";
      var friendsDocumentId = "${messageModel.toWho}--${messageModel.fromWho}";
      await FirebaseFirestore.instance.collection('chats').doc(myDocumentId).collection('messages').doc(messageId).set(messageModel.toMap());

      await FirebaseFirestore.instance.collection('chats').doc(friendsDocumentId).collection('messages').doc(messageId).set(messageModel.toMapForFriend());

      await FirebaseFirestore.instance.collection('chats').doc(myDocumentId).set(
        {
          "fromWho" : messageModel.fromWho,
          "toWho" : messageModel.toWho,
          "lastMessage" : messageModel.messageText,
          "sentAt" : FieldValue.serverTimestamp(),
          "seen" : true
      }
      );

       await FirebaseFirestore.instance.collection('chats').doc(friendsDocumentId).set(
        {
          "fromWho" : messageModel.toWho,
          "toWho" : messageModel.fromWho,
          "lastMessage" : messageModel.messageText,
          "sentAt" : FieldValue.serverTimestamp(),
          "seen" : false
      }
      );

  }

  Future<void> markAsSeen(String documentId)async{
    await FirebaseFirestore.instance.collection('chats').doc(documentId).update({'seen' : true});
  }


}


 /* 
 userName uniq olması gerekseydi: 
 var snap = await FirebaseFirestore.instance.collection("users").where("userName", isEqualTo: newName).get();
 
      if(snap.docs.isNotEmpty) 
      
      
      */