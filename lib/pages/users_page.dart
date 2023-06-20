import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/models/myuser_model.dart';
import 'package:flutter_lovers_orgin/pages/chatting_page.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';











class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({Key? key}): super(key: key);

  @override
  UsersPageState createState() => UsersPageState();
}



class UsersPageState extends ConsumerState<UsersPage> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
        actions: [
          IconButton(onPressed: (){
          }, icon: const Icon(Icons.title)),
        ],
      ),
      body: FutureBuilder<List<MyUser>>(
        future: ref.read(userProvider.notifier).getAllUsers(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.length>1){
              return RefreshIndicator(
                onRefresh: () async{
                  setState(() {
                    
                  });
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var currentMyUser = snapshot.data!.elementAt(index);
                    if(currentMyUser.userId == FirebaseAuth.instance.currentUser!.uid){
                      return Container();
                    }else{
                    return ListTile(
                      onTap: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChattingPage(friendUser: currentMyUser)));
                      },
                      title: Text(currentMyUser.userName), 
                      subtitle: Text(currentMyUser.userId),
                      leading: currentMyUser.profilUrl != null ? CircleAvatar(backgroundImage: NetworkImage(currentMyUser.profilUrl!)) : const CircleAvatar(backgroundImage: AssetImage("assets/images/profil.png")),
                      );
                    }
                    
                    },
                ),
              );

            }else{
              return RefreshIndicator(
                onRefresh: () async{
                  setState(() {
                    
                  });
                },
                child:  SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.82,
                    child: const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_accounts,size: 34, color: Colors.purple,),
                          SizedBox(height: 15,),
                          Text("Kayıtlı kullanıcı bulunamadı."),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

          }else{
            return const Center(child: CircularProgressIndicator());
          }


        },
       ),
    );

  }
}








/* class UsersPage extends ConsumerWidget{
  const UsersPage({super.key});

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
        actions: [
          IconButton(onPressed: (){
          }, icon: const Icon(Icons.title)),
        ],
      ),
      body: FutureBuilder<List<MyUser>>(
        future: ref.read(userProvider.notifier).getAllUsers(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.length>1){
              return RefreshIndicator(
                onRefresh: () {
                  
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var currentMyUser = snapshot.data!.elementAt(index);
                    if(currentMyUser.userId == FirebaseAuth.instance.currentUser!.uid){
                      return Container();
                    }else{
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChattingPage(friendUser: currentMyUser)));
                      },
                      child: ListTile(
                        title: Text(currentMyUser.userName), 
                        subtitle: Text(currentMyUser.userId),
                        leading: currentMyUser.profilUrl != null ? CircleAvatar(backgroundImage: NetworkImage(currentMyUser.profilUrl!)) : const CircleAvatar(backgroundImage: AssetImage("assets/images/profil.png")),
                        ),
                    );
                    }
                    
                    },
                ),
              );

            }else{
              return const Center(child: Text("Kayıtlı kullanıcı bulunamadı."),);
            }

          }else{
            return const Center(child: CircularProgressIndicator());
          }


        },
       ),
    );
  }
}




 */