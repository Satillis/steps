import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'saveData.dart';
import 'form.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  Singleton().Load;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Singleton().registred
                  ? '/'
                  : '/form',
      routes: {
        '/': (context) => MainPage(),
        '/form': (context) => MyCustomForm()
      },
    ),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?', _ccal = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {

      if(Singleton().startCount == false){
        Singleton().satrtSteps = event.steps;
        Singleton().startCount = true;
      }


      _ccal = ((1.15 * Singleton().userWeght * (event.steps - Singleton().satrtSteps) * (Singleton().userHigeht / 4 + 37)) / 10000).toStringAsFixed(2);

      _steps = (event.steps - Singleton().satrtSteps).toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (await _pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return  
      
      Scaffold(
        appBar: AppBar(
          title: const Text('Шагомер'),
          actions: [
            IconButton(
              onPressed: (){
                Singleton().Logout;
                Navigator.pushNamedAndRemoveUntil(context, '/form',  (_) => false);
              },
               icon: const Icon(Icons.account_circle_outlined)
               )
          ],
        ),
        
        body: 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                Singleton().userName,
                style: TextStyle(fontSize: 60),
              ),

              Text(
                'Шаги',
                style: TextStyle(fontSize: 30),
              ),

              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),

              Divider(
                height: 60,
                thickness: 0,
                color: Colors.white,
              ),

              Icon(
                
                Icons.accessibility_new,
                size: 180,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Column(
                    children: [
                      const Text(
                "Кал.",
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _ccal,
                style: TextStyle(fontSize: 40),
              ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text(
                "Кг.",
                style: TextStyle(fontSize: 30),
              ),

              

              Text(
                Singleton().userWeght.toString(),
                style: TextStyle(fontSize: 40),
              ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      );
  }
}

    




