import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercio Contador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isStart = false;
  String _formatText = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerMinutes = TextEditingController();
  final controllerSeconds = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerSeconds.text = '00';
  }

  @override
  void dispose() {
    controllerMinutes.dispose();
    controllerSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ejercio Contador'),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isStart
                    ? labelCounter()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: widthScreen * .40,
                            child: TextFormField(
                              controller: controllerMinutes,
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              decoration: InputDecoration(
                                  label: const Text('Minutos'),
                                  hintText: '01',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: validateInputs,
                            ),
                          ),
                          Container(
                            width: widthScreen * .40,
                            child: TextFormField(
                                controller: controllerSeconds,
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                decoration: InputDecoration(
                                    label: const Text('Segundos'),
                                    hintText: '01',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                validator: validateInputs),
                          )
                        ],
                      ),
                const SizedBox(
                  height: 30.0,
                ),
                isStart
                    ? ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _formatText = ':';
                            isStart = false;
                          });
                        },
                        child: const Text('Parar'))
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Duration _duration = Duration(
                                minutes: int.parse(controllerMinutes.text),
                                seconds: int.parse(controllerSeconds.text));
                            await _start(duration: _duration);
                          }
                        },
                        child: const Text('Iniciar'))
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Widget labelCounter() {
    return Column(
      children: [
        Text(
          _formatText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 38.0),
        ),
        _formatText == '00:00'
            ? const Text(
                'Contador Terminado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
              )
            : const SizedBox()
      ],
    );
  }

  Future<void> _start({required Duration duration}) async {
    setState(() {
      isStart = true;
    });

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!isStart) {
        timer.cancel();
      }
      duration = duration - const Duration(seconds: 1);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String _minSecond = duration.toString().split('.')[0];
      setState(() {
        _formatText = _minSecond.split(':')[1] + ':' + _minSecond.split(':')[2];
      });

      if (_formatText == '00:00') {
        timer.cancel();
      }

      // print(_formatText);
    });
  }
}

String? validateInputs(String? value) {
  if (value == '') {
    return 'Ingrese datos';
  }
  final n = num.tryParse(value.toString());
  if (n == null) {
    return '"$value" no es un numero';
  }

  if (int.parse(value.toString()) > 60 && int.parse(value.toString()) > 0) {
    return 'Intente con menor a 60';
  }

  return null;
}
