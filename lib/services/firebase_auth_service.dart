import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService{


  /* @override
  MyUser? currentUser() {

    try{
        var firebaseUser = FirebaseAuth.instance.currentUser;
        return  _userFromFirebase(firebaseUser);

    }catch(e){
        debugPrint(e.toString());
        return null;
    }

    
  } */

  Future<User?> signInAnonymously()async{
    try{
    var userCredential = await FirebaseAuth.instance.signInAnonymously(); 
    return userCredential.user;
    }catch(e){
      debugPrint("Anonim giriş hata: $e");
      return null;
    }

  }

  
  /* MyUser? _userFromFirebase(User? user){
    if(user == null){
      return null;
    }else{
      return MyUser(userId: user.uid, email: user.email, userName: user.);
    }
  } */


  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
  
  Future<User?> signInWithGmail() async {
     
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if(googleUser != null){
          GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          if(googleAuth.idToken != null && googleAuth.accessToken != null){
            
            var credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
            
           UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
                credential
            );

              debugPrint("userCreddntial null!");

            User? user = userCredential.user;
            
            return user;

          }

              debugPrint("tokenlar null!");

        }

        debugPrint("googleUser null!");
        return null; 

     


  }
  
  Future<User?> createUserWithEmail(String email, String password) async {
        UserCredential sonuc = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        return sonuc.user;
  }

  Future<User?> signInUserWithEmail(String email, String password) async {
        UserCredential sonuc = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        return sonuc.user;
  }

  User? getCurrentUser(){
      return FirebaseAuth.instance.currentUser;
  }

}