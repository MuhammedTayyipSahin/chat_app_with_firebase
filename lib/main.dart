import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/firebase_options.dart';
import 'package:flutter_lovers_orgin/locator.dart';
import 'package:flutter_lovers_orgin/pages/home_page.dart';
import 'package:flutter_lovers_orgin/pages/sign_in_page.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(
    const ProviderScope(child: MyApp() ) );

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    
    return  MaterialApp(
      title: 'Flutter Lovers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: 
      
        ref.watch(userProvider) != null ?  const HomePage() : const SignInPage(),

      );
  }
}

