import 'package:flutter/material.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottom_nav_bar.dart';
import 'package:haelo_flutter/features/bottom_bar/presentation/screens/bottombar.dart';

import '../../constants.dart';

void goToPage(BuildContext context,Widget pageName){
  Navigator.push(context,
      MaterialPageRoute(builder: (context)=>pageName));
}

void goToHomePage(BuildContext context){
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => BottomNavBar(bottom: 0)),
        (route) => false,);
}

bool isEmailValid(String email){
      RegExp regex =RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regex.hasMatch(email);
}


bool isPrime(pref){
  return  pref.getBool(Constants.is_prime)!=null
      && pref.getBool(Constants.is_prime)==true;

  //false mean free plan
}

String planName(pref){
  String name="free";//just for test
  if(pref.getString(Constants.plan_name)!=null){
    name=pref.getString(Constants.plan_name)!.toLowerCase();
  }
  return name;
}


