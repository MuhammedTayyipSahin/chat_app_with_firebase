import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  
  final String messageText;
  final String fromWho;
  final String toWho;
  final Timestamp? sentAt;
  final bool isFromMe;

  MessageModel({required this.messageText, required this.fromWho, required this.toWho, this.sentAt, required this.isFromMe});
  
  Map<String, dynamic> toMap() => {
    "messageText" : messageText,
    "fromWho" : fromWho,
    "toWho" : toWho,
    "sentAt" : sentAt ?? FieldValue.serverTimestamp(), 
    "isFromMe" : isFromMe
  };

  Map<String, dynamic> toMapForFriend() => {
    "messageText" : messageText,
    "fromWho" : fromWho,
    "toWho" : toWho,
    "sentAt" : FieldValue.serverTimestamp(), 
    "isFromMe" : !isFromMe
  };


  MessageModel.fromMap(Map<String, dynamic> map):
  messageText = map["messageText"],
  fromWho = map["fromWho"],
  toWho = map['toWho'],
  sentAt = map['sentAt'],
  isFromMe = map['isFromMe'];
  
  @override
  String toString() {
   return "$fromWho'den $toWho'a MESAJ: $messageText";
  }

  }