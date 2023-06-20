import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/models/chat_history_model.dart';
import 'package:flutter_lovers_orgin/pages/chatting_page.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_lovers_orgin/static_func_and_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konuşmalarım"),
      ),
      body: StreamBuilder<List<ChatHistoryModel>>(
        stream: ref.watch(userProvider.notifier).getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var currentData = snapshot.data![index];
                  return FutureBuilder(
                    future: ref
                        .watch(userProvider.notifier)
                        .getFriendUser(currentData.toWho),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasData) {
                        return ListTile(
                          onTap: (){
         if(!currentData.seen){ref.read(userProvider.notifier).markAsSeen(FirebaseAuth.instance.currentUser!.uid, userSnapshot.data!.userId);}
         Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChattingPage(friendUser: userSnapshot.data!)));
                          },
                          leading: userSnapshot.data!.profilUrl != null ? CircleAvatar(backgroundImage: NetworkImage(userSnapshot.data!.profilUrl!)) : const CircleAvatar(backgroundImage: AssetImage("assets/images/profil.png")),
                          title: Text(userSnapshot.data!.userName),
                          subtitle: Text(currentData.lastMessage),
                          trailing: Text(MyStatic.hourAndMinute(currentData.sentAt),
                          style: TextStyle(
                            color: currentData.seen ? Colors.grey : Colors.purple,
                          ),
                          
                          ),
                        );
                      }else{
                        return ListTile(
                          leading: const CircularProgressIndicator(),
                          title: const Text("user"),
                          subtitle: Text(currentData.lastMessage),
                        );
                      }
                    },
                  );
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.message, size: 34, color: Colors.purple,),
                  SizedBox(height: 15, width: MediaQuery.of(context).size.width ),
                  const Text("Buralar çok ıssız :/")
                ],
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}


