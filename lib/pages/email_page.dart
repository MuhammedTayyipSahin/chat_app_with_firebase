
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum FormType{
  register, logIn
}



class EmailAndPasswordInstance{
  final String? email, password;
  final FormType formType; 
  const EmailAndPasswordInstance({required this.email, required this.password, required this.formType});

  
}

class EmailPage extends ConsumerStatefulWidget {
  const EmailPage({Key? key}): super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<EmailPage> {

  String? email, password;
  final formKey = GlobalKey<FormState>(); 
  FormType formType = FormType.logIn;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text( formType == FormType.register ? "Email ile kayıt ol"  : "Email ile giriş yap"),
      ),
      
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            children:  [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  validator: (value) {
                    if(value!=null){
                        if(!value.contains('@') || !value.contains('.') || value.length<5){
                          return "Geçersiz emil girişi!";
                        }else{
                         return null;
                        }
                    }else{
                      return "Bir email adresi girmelisiniz.";
                    }
                     
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline),
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    
                  ),
                  onSaved: (text){
                    email = text;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if(value != null){
                      if(value.length < 6){
                        return "Şifre en az 6 karakter içermelidir.";
                      }
                      return null;
                    }else{
                      return "Şifre alanı boş bırakılamaz.";
                    }
                  },
                  decoration: const InputDecoration(
                    
                    prefixIcon: Icon(Icons.mail_outline),
                    hintText: "Passaword",
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (text){
                    password = text;
                  }
                  ,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: ()async{
                    if(!formKey.currentState!.validate()){
                      setState(() {
                        formKey.currentState!.save();
                      });  
                    }else{
    formKey.currentState!.save();
    Navigator.pop<EmailAndPasswordInstance>(context, EmailAndPasswordInstance(email: email, password: password, formType: formType));
                    }
                   
                    
                   
                    debugPrint("email: $email, şifre: $password");
                  }, 
                  child: Text(formType == FormType.register ? "Kayıt ol" : "Giriş Yap")
              
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if(formType == FormType.register){
                      formType = FormType.logIn; 
                    }else {
                      formType = FormType.register;
                    }
                    
                  });

                }, 
                child: Text(formType == FormType.register ? "Giriş yap" : "Hesabın mı yok? Kaydol")
                ),
            ],
          ),
        ),
      ),      

    );
  }
}