import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/locator.dart';
import 'package:flutter_lovers_orgin/models/chat_history_model.dart';
import 'package:flutter_lovers_orgin/models/message_model.dart';
import 'package:flutter_lovers_orgin/models/myuser_model.dart';
import 'package:flutter_lovers_orgin/services/firebase_auth_service.dart';
import 'package:flutter_lovers_orgin/services/firebase_service.dart';
import 'package:flutter_lovers_orgin/services/firebase_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyUserNotifier extends StateNotifier<MyUser?>{

  MyUserNotifier({required this.ref}):super(null){
    getCurrentUser();
  }

  final Ref ref; 
  var service = locator<FirebaseAuthService>(); 
  DBfirestore firestoreService  = DBfirestore();
  MyFirebaseStorageService storageService = MyFirebaseStorageService();

  Future<void>signInAnonymously()async{
    var user = await service.signInAnonymously();
    if(user!=null){
        var myUser = await firestoreService.saveUser(user);
        state = myUser; 
      }
  }

  Future<void> getCurrentUser()async{
    var user = service.getCurrentUser();
    if(user !=null){
      var myUser = await firestoreService.readUser(user);
      state = myUser;
    }
  }

  
  Future<void> signOut()async{
    await service.signOut();
    state = null; 
  }
  
  Future<void> signInWithGmail() async{
    var user = await service.signInWithGmail();
    if(user!=null){
        var myUser = await firestoreService.saveUser(user);
        debugPrint("Kurtlar vadisi operasyonu bitmiştir!");
        state = myUser; 
      }

  }

  Future<void> createUserWithEmailAndPassword(String? email, String? password)async{
      if(email != null && password != null){
      var user = await service.createUserWithEmail(email, password); 
      if(user!=null){
        var myUser = await firestoreService.saveUser(user);
        state = myUser; 
      }
      }
  }

  Future<void> signInWithEmailAndPassword(String? email, String? password)async{
      if(email != null && password != null){
      var user = await service.signInUserWithEmail(email, password); 
      if(user!=null){
       var myUser = await firestoreService.readUser(user);
        state = myUser; 
      }

    }
  }

  Future<void> updateUserName(String userId, String newName)async{
    bool result =  await firestoreService.changeUserName(userId, newName);
    if(!result){
      ref.read(errorTextProvider.notifier).state = "Kullanılmış isim!"; 
      ref.read(errorColorProvider.notifier).state = null; 
    }else{
      ref.read(errorTextProvider.notifier).state = null;
      ref.read(errorColorProvider.notifier).state = Colors.green; 
    }
    
  }

  Future<void> updateProfilePhoto(String userId, File newImage)async{
    var newUrl = await storageService.uploadProfilePhoto(userId, newImage);
    if(newUrl != null){
      debugPrint("NEW URL: $newUrl");
    firestoreService.changeProfilePhotoUrl(userId, newUrl);
    await getCurrentUser();
    }else{
      debugPrint("NEW URL NULL");
    }
  }

  Future<List<MyUser>> getAllUsers()async{
    return firestoreService.getAllUsers();
  }

  Future<MyUser> getFriendUser(String userID)async{
    return firestoreService.getFriendUser(userID); 
  }

  Stream<List<MessageModel>> getMessages({required String myId,required String hisId}){
    var snapshot = FirebaseFirestore.instance.collection("chats").doc("$myId--$hisId").collection("messages").orderBy("sentAt", descending: true).snapshots();
    return snapshot.map((event) => event.docs.map((e) => MessageModel.fromMap(e.data())).toList());

  }
  
  Stream<List<ChatHistoryModel>> getChats(){
    var snapshot = FirebaseFirestore.instance.collection("chats").where("fromWho",isEqualTo: state!.userId)
    .orderBy("sentAt", descending: true).snapshots();
    return snapshot.map((event) => event.docs.map((e) => ChatHistoryModel.fromMap(e.data())).toList());

  }

  Future<void> sendMessage(MessageModel messageModel)async{
    await firestoreService.sendMessage(messageModel);
    
  }

  Future<void> markAsSeen(String myId, String friendsId)async{
    var documentId = "$myId--$friendsId"; 
    await firestoreService.markAsSeen(documentId);
  }


}

final userProvider = StateNotifierProvider<MyUserNotifier, MyUser?>((ref) {
  return MyUserNotifier(ref: ref);
});






final errorTextProvider = StateProvider<String?>((ref) => null);

final errorColorProvider = StateProvider<MaterialColor?>((ref) => Colors.purple);


/* enum ViewState{idle, busy}

final viewStateProvider = StateProvider<ViewState>((ref) => ViewState.idle); */