class MyErrors{
  static String createErrorMessage(String errorCode){
        switch (errorCode) {
          case "user-not-found": return "Kullanıcı bulunamadı.";
          case "wrong-password": return "Hatalı şifre girdiniz.";
          case "invalid-email": return "Geçersiz email girdiniz.";
          case "user-disabled": return "Kullanıcı devre dışı bırakıldı.";
          case "email-already-in-use": return "Email zaten kullanımda.";
          case "operation-not-allowed": return "Hesap erişilebilir değil.";
          case "weak-password": return "Girdiğiniz şifre yeterince güçlü değil.";

          default: return "Bir sorun var.";
        }


    }
}