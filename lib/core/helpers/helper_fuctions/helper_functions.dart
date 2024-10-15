import 'package:flutter/material.dart';

class HelperFunctions{
  static void navigateTo(context,Widget widget)=>
      Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));

  static void navigateAndReplace (context,Widget widget)=>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));

}