import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../button_widget.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void resetTimer() {
    seconds = maxSeconds;
    context.read<TimerCubit>().seconds();
  }

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        seconds--;
        context.read<TimerCubit>().seconds();
      } else {
        stopTimer(reset: false);
        context.read<TimerCubit>().seconds();
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer?.cancel();
    context.read<TimerCubit>().seconds();
  }

  @override
  Widget build(BuildContext context) {
    log('build ishtedi');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<TimerCubit, int>(
              builder: (context, state) {
                return buildTimer();
              },
            ),
            SizedBox(
              height: 80,
            ),
            BlocBuilder<TimerCubit, int>(
              builder: (context, state) {
                return buildButtons();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    log('bloc ishtedi');
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;

    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ButtonWidget(
              text: isRunning ? 'Pause' : 'Resume',
              onCliced: () {
                if (isRunning) {
                  stopTimer(reset: false);
                  context.read<TimerCubit>().seconds();
                } else {
                  startTimer(reset: false);
                  context.read<TimerCubit>().seconds();
                }
              },
            ),
            SizedBox(
              width: 12,
            ),
            ButtonWidget(text: 'Cancell', onCliced: stopTimer)
          ])
        : ButtonWidget(text: 'Start Timer!', onCliced: () => startTimer());
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.purple[900]),
            strokeWidth: 12,
            backgroundColor: Colors.black,
          ),
          Center(child: buildTime())
        ]),
      );

  Widget buildTime() {
    if (seconds == 0) {
      return Icon(
        Icons.done,
        color: Colors.black,
        size: 112,
      );
    } else {
      return BlocBuilder<TimerCubit, int>(
        builder: (context, state) {
          return Text(
            '$seconds',
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
          );
        },
      );
    }
  }
}

class TimerCubit extends Cubit<int> {
  TimerCubit() : super(60);

  seconds() => emit(state - 1);
}
