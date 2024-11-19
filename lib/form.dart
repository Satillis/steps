import 'package:flutter/material.dart';
import 'saveData.dart';
import 'main.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm>{

    @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(
               decoration: const InputDecoration(
                hintText: 'Имя'   
              ),
              onSubmitted: (value) {
                Singleton().userName = value;
              },
            ),

            TextField(
               decoration: const InputDecoration(
                hintText: 'Рост в см'   
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                Singleton().userHigeht = double.parse(value);
              },
            ),

            TextField(
               decoration: const InputDecoration(
                hintText: 'Вес в кг'   
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                Singleton().userWeght = double.parse(value);
              },
            ),

            Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed:() {
                Singleton().registred = true;
                Singleton().Save;
                Navigator.pushNamedAndRemoveUntil(context, '/',  (_) => false);
              },
              child: const Text('Сохранить'),
            )
            )

          ],
        ),
      ),
    );
}
}