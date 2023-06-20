

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_lovers_orgin/widgets/my_alert_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(context, ref) {
    var myUser = ref.watch(userProvider);
    debugPrint("MAİN builder tetiklendi.");

    TextEditingController controller = TextEditingController(text: myUser!.userName);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          TextButton(onPressed: ()async{
            await ref.read(userProvider.notifier).signOut();
          }, child: const Text("Çıkış", style: TextStyle(color: Colors.white),)) 
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context, builder: (context) => SizedBox(
                    height: 240,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text("Kameradan Çek"),
                          onTap:  () => selectFromCamera(ref, myUser.userId),
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text("Galeriden Seç"),
                          onTap:  () => selectFromGallery(ref, myUser.userId, context),
                        )
                      ],
                    ),
                  ),);
                },
                child: myUser.profilUrl != null ? CircleAvatar(backgroundImage: NetworkImage(myUser.profilUrl!), radius: 80,) :const CircleAvatar(backgroundImage: AssetImage("assets/images/profil.png"), radius: 80,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Consumer(
                builder: (context, refs, child){
                  debugPrint("TextFormField builder tetiklendi.");
                  return Theme(
                    data: ThemeData(primarySwatch: refs.watch(errorColorProvider)),
                    child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(labelText: "Username", border: const OutlineInputBorder(), errorText: refs.watch(errorTextProvider)),
                    onChanged: (value) async {
                      await refs.read(userProvider.notifier).updateUserName(myUser.userId, value);
                      },
                    onTap: ()async{
                       refs.read(errorColorProvider.notifier).state = Colors.purple;
                    },
                                  
                    ),
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(), ),
                initialValue: myUser.email,
                
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: "User ID", border: OutlineInputBorder()),
                initialValue: myUser.userId,
                ),
            ),            
      
          ],
        ),
      ),
    );
  }

  void selectFromCamera(WidgetRef ref, String userId)async{
    var newImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(newImage != null){
      ref.read(userProvider.notifier).updateProfilePhoto(userId, File(newImage.path));
    }
  }

  
  void selectFromGallery(WidgetRef ref, String userId, BuildContext context)async{
    var newImage = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(newImage != null){
      try{
        await ref.read(userProvider.notifier).updateProfilePhoto(userId, File(newImage.path));
      }on FirebaseException catch(e){
        showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                          errorCode: e.toString(),
                          title: "Kullanıcı Kayıt Hatası"));
      }
    }
  }

}