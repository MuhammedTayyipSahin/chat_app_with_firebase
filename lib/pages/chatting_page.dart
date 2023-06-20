import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/models/message_model.dart';
import 'package:flutter_lovers_orgin/models/myuser_model.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_lovers_orgin/static_func_and_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChattingPage extends ConsumerStatefulWidget {
  final MyUser friendUser;
  const ChattingPage({Key? key, required this.friendUser}) : super(key: key);

  @override
  ChattingPageState createState() => ChattingPageState();
}

class ChattingPageState extends ConsumerState<ChattingPage> {
  TextEditingController controller = TextEditingController();
  var scrollController =  ScrollController(); 
  @override
  Widget build(BuildContext context) {
    // We can also use "ref" to listen to a provider inside the build method
    
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6.0, top: 6.0, right: 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.only(left: 3.0, top: 3.0, bottom: 3.0, right: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.friendUser.profilUrl != null
                          ? NetworkImage(widget.friendUser.profilUrl!)
                              as ImageProvider<Object>
                          : const AssetImage("assets/images/profil.png")),
                ],
              ),
            ),
          ),
        ),
        title: Text(widget.friendUser.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: ref.watch(userProvider.notifier).getMessages(myId:  FirebaseAuth.instance.currentUser!.uid,hisId:  widget.friendUser.userId),           
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      reverse: true,
                      controller: scrollController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var currentMessage = snapshot.data!.elementAt(index);
                        bool withTail = (index == 0) ? true : setWithTail(currentMessage.isFromMe,  snapshot.data!.elementAt(index-1).isFromMe);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BubbleSpecialThree(
                              text: currentMessage.messageText,
                              isSender: currentMessage.isFromMe,
                              color: currentMessage.isFromMe ? const Color.fromARGB(255, 233, 156, 246) : Colors.grey,
                              tail: withTail,
                            ),
                            Align(
                              alignment: currentMessage.isFromMe ? Alignment.topRight : Alignment.topLeft,
                              child: Text(MyStatic.hourAndMinute(currentMessage.sentAt))),
                          ],
                        );
                      },
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
                
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)))),
                )),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.purple, //<-- SEE HERE
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if(controller.text.trim().isNotEmpty){
                            var messageText = controller.text;
                            controller.clear();                             
                           await ref.read(userProvider.notifier).sendMessage(MessageModel(messageText: messageText, fromWho: FirebaseAuth.instance.currentUser!.uid, toWho: widget.friendUser.userId, isFromMe: true));
                          }
                          scrollController.animateTo(0.0, duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
                        },
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
  
  bool setWithTail(bool currentMessageFromMe, bool previousMessageFromMe) {
   if(currentMessageFromMe != previousMessageFromMe){
      return true;
    }else{
      return false;
    }
  }
  
 

}
