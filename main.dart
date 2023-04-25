import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimerHome(),
    );
  }
}

class TimerHome extends StatefulWidget {
  const TimerHome({
    super.key,
  });

  @override
  State<TimerHome> createState() => _TimerHomeState();
}

class _TimerHomeState extends State<TimerHome> {
  static const int totalTime = 60 * 1;
  int times = totalTime;
  late Timer timer;
  String timeView = '0:01:00';
  bool isRunning = false;

  void timeStart() {
    if (isRunning) {
      timeStop();
      isRunning = false;
    } else {
      if (times > 0) {
        isRunning = true;
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            timeView = Duration(seconds: times).toString().split('.')[0];
            times--;
          });
          if (times < 0) {
            timeStop();
            isRunning = false;
          }
        });
      }
    }
  }

  void timeReset() {
    setState(() {
      timeStop();
      timeView = '0:01:00';
      times = totalTime;
      isRunning = false;
    });
  }

  void timeStop() {
    setState(() {
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  timerButton(60, Colors.blueAccent),
                  timerButton(30, Colors.pinkAccent),
                  timerButton(-30, Colors.green)
                ],
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Center(
                    child: Text(
                  timeView,
                  style: const TextStyle(color: Colors.white, fontSize: 50),
                )),
              )),
          Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.orange,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 60,
                          onPressed: timeStart,
                          icon: isRunning
                              ? const Icon(Icons.pause_circle)
                              : const Icon(Icons.play_circle_outline_outlined)),
                      IconButton(
                          iconSize: 60,
                          onPressed: timeReset,
                          icon: const Icon(Icons.stop_circle_outlined))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  GestureDetector timerButton(int time, Color color) {
    return GestureDetector(
      onTap: () => addTime(time),
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text('+${time}s')),
      ),
    );
  }

  void addTime(int time) {
    setState(() {
      times += time;
      if (times < 0) {
        times = 0;
        timeStop();
      }
      timeView = Duration(seconds: times).toString().split('.')[0];
    });
  }
}
