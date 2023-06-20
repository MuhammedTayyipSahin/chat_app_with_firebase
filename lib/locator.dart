import 'package:flutter_lovers_orgin/services/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
}