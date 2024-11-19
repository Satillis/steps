
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Singleton {
  
  static Singleton? _instance;

  factory Singleton() => _instance ??= Singleton._();
  
  bool registred = false;
  String userName ='?';
  double userHigeht = 0;
  double userWeght = 0;
  int satrtSteps = 0;

  bool startCount = false;


  void Load() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    registred = prefs.getBool('registred') ?? false;
    userName = prefs.getString('userName') ?? '?';
    userHigeht = prefs.getDouble('userHigeht') ?? 0;
    userWeght = prefs.getDouble('userWeght') ?? 0;
    satrtSteps = prefs.getInt('satrtSteps') ?? 0;
  }

  void Save() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('registred', registred);
    prefs.setString('userName',userName);
    prefs.setDouble('userHigeht',userHigeht);
    prefs.setDouble('userWeght',userWeght);
    prefs.setInt('satrtSteps',satrtSteps);
  }

  void Logout() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  
  Singleton._();
}
