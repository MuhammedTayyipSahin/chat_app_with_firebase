import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHistoryModel {
  final String fromWho, toWho, lastMessage;
  final bool seen;
  final Timestamp sentAt;
 

  ChatHistoryModel(
      {required this.fromWho,
      required this.toWho,
      required this.lastMessage,
      required this.seen,
      required this.sentAt,
      });

  ChatHistoryModel.fromMap(Map<String, dynamic> map)
      : lastMessage = map["lastMessage"],
        fromWho = map["fromWho"],
        toWho = map['toWho'],
        sentAt = map['sentAt'],
        seen = map['seen']
        ;

  /* Map<String, dynamic> toMap(ChatHistoryModel chatModel) {
    return {
      "lastMessage": lastMessage,
      "fromWho": fromWho,
      'toWho': toWho,
      'sentAt': sentAt,
      'seen': seen
    };
  } */
}
