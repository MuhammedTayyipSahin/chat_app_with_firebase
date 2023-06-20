

import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton({super.key, required this.callback, required this.text, required this.iconData, required this.textColor, required this.backgroundColor, required this.iconColor});

  final String text;
  final IconData iconData;
  final VoidCallback callback; 
  final Color textColor; 
  final Color backgroundColor; 
  final Color iconColor; 

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: ElevatedButton.icon(

        
        icon: Icon(iconData, color: iconColor),
        label: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(text,  style: TextStyle(color: textColor),),
        ),
        onPressed: callback,
        style:  ElevatedButton.styleFrom(
          
          backgroundColor: backgroundColor
        ), 
      ),
    );
  }
}