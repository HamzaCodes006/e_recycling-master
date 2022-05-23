import 'dart:async';

import 'package:flutter/material.dart';


class TimerChecking extends StatefulWidget {
  @override
  _TimerCheckingState createState() => _TimerCheckingState();
}

class _TimerCheckingState extends State<TimerChecking> {
  late Timer _timer;
  int _start = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(
          onPressed: (){
            const oneSec = const Duration(seconds: 1);
            _timer = new Timer.periodic(
              oneSec,
                  (Timer timer) {
                if (_start == 0) {
                  setState(() {
                    timer.cancel();
                    print("timer back to 0");
                  });
                } else {
                  setState(() {
                    _start--;
                  });
                }
              },
            );

          },
          child: Text('Start Timer'),
        ),
      ),
    );
  }
}
