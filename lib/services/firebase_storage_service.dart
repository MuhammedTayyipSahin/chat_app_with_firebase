import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class MyFirebaseStorageService{

  Future<String?> uploadProfilePhoto(String userId, File newImage)async{

    final storageReference = FirebaseStorage.instance.ref();

    final mountainsRef = storageReference.child("profilePhotos").child(userId);
  
    await mountainsRef.putFile(newImage);

    return await mountainsRef.getDownloadURL();

   

    
  }

}