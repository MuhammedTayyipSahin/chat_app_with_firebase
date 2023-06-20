import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/icons/google_icon_icons.dart';
import 'package:flutter_lovers_orgin/pages/email_page.dart';
import 'package:flutter_lovers_orgin/providers/provider_user.dart';
import 'package:flutter_lovers_orgin/widgets/custom_button.dart';
import 'package:flutter_lovers_orgin/widgets/my_alert_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Flutter Lovers"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text("Oturum Açın",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ),
          MyCustomButton(
              callback: () async {
                try {
                  await ref.read(userProvider.notifier).signInWithGmail();
                } on FirebaseAuthException catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                          errorCode: e.code, title: "Kullanıcı Kayıt Hatası"));
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                          errorCode: e.toString(),
                          title: "Kullanıcı Kayıt Hatası"));
                }
              },
              text: "Google ile Oturum Aç",
              iconData: GoogleIcon.google,
              textColor: Colors.black,
              backgroundColor: Colors.white,
              iconColor: Colors.red),

          /*  MyCustomButton(callback: (){}, text: "Facebook ile Oturum Aç", iconData: Icons.facebook, textColor: Colors.white, backgroundColor: const Color.fromARGB(255, 1, 42, 111), iconColor: Colors.white,), */

          MyCustomButton(
            callback: () async {
/*             showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
 */
              var infoList = await Navigator.of(context)
                  .push<EmailAndPasswordInstance>(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const EmailPage(),
              ));
              if (infoList != null) {
                if (infoList.formType == FormType.register) {
                  {
                    try {
                      await ref
                          .read(userProvider.notifier)
                          .createUserWithEmailAndPassword(
                              infoList.email, infoList.password);
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) => MyAlertDialog(
                              errorCode: e.code,
                              title: "Kullanıcı Kayıt Hatası"));
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) => MyAlertDialog(
                              errorCode: e.toString(),
                              title: "Kullanıcı Kayıt Hatası"));
                    }
                  }
                } else if (infoList.formType == FormType.logIn) {
                  try {
                    await ref
                        .read(userProvider.notifier)
                        .signInWithEmailAndPassword(
                            infoList.email, infoList.password);
                  } on FirebaseAuthException catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) => MyAlertDialog(
                            errorCode: e.code,
                            title: "Kullanıcı Girişi Hatası"));
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) => MyAlertDialog(
                            errorCode: e.toString(),
                            title: "Kullanıcı Girişi Hatası"));
                  }
                }
              }
            },
            text: "Email ile Oturum Aç",
            iconData: Icons.email,
            textColor: Colors.black,
            backgroundColor: Colors.grey.shade300,
            iconColor: Colors.black,
          ),
          MyCustomButton(
              callback: () async {
                showDialog(
                  context: context,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                await ref.read(userProvider.notifier).signInAnonymously();
                Navigator.pop(context);
              },
              text: "Misafir girişi",
              iconData: Icons.person,
              textColor: Colors.white,
              backgroundColor: Colors.purple,
              iconColor: Colors.white)
        ],
      ),
    );
  }
}
