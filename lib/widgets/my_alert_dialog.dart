
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers_orgin/my_errors.dart';

class MyAlertDialog extends StatelessWidget {
  final String title, errorCode;
  const MyAlertDialog({super.key, required this.errorCode, required this.title});

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){

      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(MyErrors.createErrorMessage(errorCode)),
        actions: [
          CupertinoDialogAction(onPressed: (){Navigator.of(context).pop();}, child: const Text("Tamam")),
        ],
      );

    }else{
      
      return AlertDialog(
        title: Text(title),
        content: Text(MyErrors.createErrorMessage(errorCode)),
        actions: [
          TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("Tamam")),
        ],
      );

    }
  }
}