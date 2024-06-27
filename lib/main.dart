import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen(this.mode, {super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active ? Colors.black : Colors.grey[800],
      body: SafeArea(
        child: widget.mode == WearMode.active
            ? buildActiveMode()
            : Center(
                child: Text(
                  _strCount,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildActiveMode() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.timer,
                size: 30,
                color: Colors.green,
              ),
              const SizedBox(height: 10.0),
              Text(
                _strCount,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_timer != null) {
                    _timer.cancel();
                    setState(() {
                      _count = 0;
                      _strCount = "00:00:00";
                      _status = "Start";
                    });
                  }
                },
                child: const Text("Reset"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  textStyle: TextStyle(fontSize: 16),
                  minimumSize: Size(60, 30),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45, // Increased height for more visibility
            margin: EdgeInsets.only(bottom: 0), // Adjust margin to move it lower
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_status == "Start" || _status == "Continue") {
                  _startTimer();
                } else if (_status == "Stop") {
                  _timer.cancel();
                  setState(() {
                    _status = "Continue";
                  });
                }
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  _status,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),
                padding: EdgeInsets.only(top: 25),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    setState(() {
      _status = "Stop";
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
